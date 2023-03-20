include("basics.jl")
using BitOperations:bset,bget

# 初期化関数。
# 最初に初期化が必要。可逆関数の変数の個数を変えるときにも再度初期化すること。
function initialize_icequive(n::Integer) # nに可逆関数の変数の個数を指定する。
    initialize_basics(n)
    set_allpermutations(n)
    return n
end

# IC同値の変換パターンを表す構造体
# 初期値は恒等変換(無変換)パターン
Base.@kwdef struct ICPattern
    inversion::Bool = true
    conjugation::Vector{<:Integer} = Vector{UInt8}(0:жnumж::Integer-1)
end

# Tuple{RFunc,ICPattern}の集合(実体は辞書)を使用するので、hashと
# isequalの両方をオーバーロードする必要がある。isequalは辞書用の等価性
# 判定関数であり、Juliaの仕様により、isequalは、ハッシュ値同士が等しい
# ことに定義する。
# hashは、ICPattern同士が異なっても、RFunc同士が等しければ、ハッシュ値
# が等しくなるように定義する。RFuncにつき一つのICPatternがあれば十分
# (RFuncの重複を避けたい)であるため。
# 参考URL:
# https://stackoverflow.com/questions/34936593/overload-object-comparison-when-adding-to-a-set-in-julia/34937834
Base.hash(x::Tuple{T,ICPattern}, h::UInt) where {T<:AbstractRFunc} = hash(x[1], h)
Base.isequal(x::Tuple{T,ICPattern}, y::Tuple{T,ICPattern}) where {T<:AbstractRFunc} = Base.isequal(hash(x), hash(y))

####################
# 共役同値
####################

function conjugation_class((rfunc, pattern)::Tuple{T,ICPattern}) where {T<:AbstractRFunc}
    # rfuncの共役同値類とそのICPatternを求める。
    return Set((apply_pattern(rfunc, perm), ICPattern(pattern.inversion, perm)) for perm in жallpermutationsж::Vector{Vector{UInt8}})
end

function conjugation_class(rfunc::AbstractRFunc)
    # rfuncの共役同値類を求める。
    return Set(apply_pattern(rfunc, perm) for perm in жallpermutationsж::Vector{Vector{UInt8}})
end

# 可逆関数の集合が与えられたときには、各可逆関数について共役同値類を求めて、その和集合を返す。
# Tは、AbstractRFuncまたはTuple{AbstractRFunc,ICPattern}を想定している。
#conjugation_class(rfuncs::Set{T}) where T = union([conjugation_class(rfunc) for rfunc in rfuncs]...)
conjugation_class(rfuncs::Set{T}) where T = union(conjugation_class.(rfuncs)...)

# rfuncの共役同値類とそのICPatternを求める。
# たぶん出番はないので、コメントアウトする。 追記：出番がありました。
conjugation_class_ptn(rfunc::AbstractRFunc) = conjugation_class((rfunc, ICPattern()))

# rfuncの共役同値類代表関数を求める。
# 共役同値類代表関数 = 共役同値類の最小要素
conj_representative_function = minimum ∘ conjugation_class
# rfuncのIC同値類代表関数とそのICPatternを求める。
conj_representative_function_ptn(rfunc::AbstractRFunc) = conj_representative_function((rfunc, ICPattern()))

function apply_pattern(rfunc::AbstractRFunc, perm::Vector{<:Integer})
    # 置換permで指定されたように、rfuncの共役関数を求める。
    con_rfunc = similar(rfunc)
    for input::RInt in 0:length(rfunc)-1
        con_input = rint_permutation(input, perm)
        con_output = rint_permutation(rfunc(input), perm)
        con_rfunc[begin+con_input] = con_output
    end
    return con_rfunc
end    

function rint_permutation(rint::Integer, perm::Vector{<:Integer})
    # rintは0以上の整数。
    # 置換permで指定されたように，rintのビットを置換した値を返す。
    # bget,bsetは仕様でゼロインデックスであることに注意。
    newrint = rint
    for (index, p) in enumerate(perm)
        newrint = bset(newrint, p, bget(rint, index - 1))
    end
    return newrint
end

function apply_pattern(rgate::RGate, perm::Vector{<:Integer})
    # 置換permで指定されたように、rgateの共役ゲートを求める。
#    return RGate(perm[begin+get_target(rgate)], sort!([perm[begin+c] for c in get_control(rgate)]))
    return RGate(perm[begin+get_target(rgate)], RInt[perm[begin+c] for c in get_control(rgate)])
end

function apply_pattern(rcircuit::RCircuit, perm::Vector{<:Integer})
    # 置換permで指定されたように、rcircuitの共役回路を求める。
    return RCircuit([apply_pattern(rgate, perm) for rgate in rcircuit])
end

####################
# 逆関数同値
####################

function inversion_class((rfunc, pattern)::Tuple{T,ICPattern}) where {T<:AbstractRFunc}
    # rfuncの逆関数同値類とそのICPatternを求める。
    # 通常は2個のRFuncのリストが返るが，恒等関数やNOTゲートのみの可逆関数は1個のRFuncのリストになる。
    return Set((apply_pattern(rfunc, polarity), ICPattern(polarity, pattern.conjugation)) for polarity in [true, false])
end

function inversion_class(rfunc::AbstractRFunc)
    # rfuncの逆関数同値類を求める。
    # 通常は2個のRFuncのリストが返るが，恒等関数やNOTゲートのみの可逆関数は1個のRFuncのリストになる。
    return Set(apply_pattern(rfunc, polarity) for polarity in [true, false])
end

# 可逆関数の集合が与えられたときには、各可逆関数について逆関数同値類を求めて、その和集合を返す。
# Tは、AbstractRFuncまたはTuple{AbstractRFunc,ICPattern}を想定している。
# inversion_class(rfuncs::Set{T}) where T = union([inversion_class(rfunc) for rfunc in rfuncs]...)
inversion_class(rfuncs::Set{T}) where T = union(inversion_class.(rfuncs)...)

# rfuncの逆関数同値類とそのICPatternを求める。
# たぶん出番はないので、コメントアウトする。
#inversion_class_ptn(rfunc::AbstractRFunc) = inversion_class((rfunc, ICPattern()))

# 極性polarityで指定されたように、objの逆オブジェクトを求める。
# objとしては、AbstractRFunc, RGate, RCircuitを想定している。
# polarity=trueのとき、objを返す。
# polarity=falseのとき、inv(obj)を返す。
function apply_pattern(obj, polarity::Bool)
    return polarity ? obj : inv(obj)
end

####################
# IC同値類(逆関数同値+共役同値)
####################

# rfuncのIC同値類を求める。
# function ic_class(rfunc::RFunc)
#     rfunc |> conjugation_class |> inversion_class
# end
#ic_class = inversion_class ∘ conjugation_class
ic_class = conjugation_class ∘ inversion_class 
# IC同値類 = 共役同値と逆関数同値の合成関数

# rfuncのIC同値類とそのICPatternを求める。
ic_class_ptn(rfunc::AbstractRFunc) = ic_class((rfunc, ICPattern()))

# rfuncのIC同値類代表関数を求める。
# IC同値類代表関数 = IC同値類の最小要素
ic_representative_function = minimum ∘ ic_class
# rfuncのIC同値類代表関数とそのICPatternを求める。
ic_representative_function_ptn(rfunc::AbstractRFunc) = ic_representative_function((rfunc, ICPattern()))

####################
# 可逆関数・回路の復元
####################

# ICPatternの復元パターン(逆変換パターン)を生成する。
import Base.inv
function inv(icpattern::ICPattern)
    return ICPattern(icpattern.inversion, inv(icpattern.conjugation))
end

# icpatternで指定されたように、objのIC同値版を求める。
# objとしては、AbstractRFunc, RGate, RCircuitを想定している。
# obj::AbstractRFuncについては、IC同値関数を求める。
# obj::RCircuitについては、IC同値回路を求める。
apply_pattern(obj, icpattern::ICPattern) = apply_pattern(apply_pattern(obj, icpattern.conjugation), icpattern.inversion)
