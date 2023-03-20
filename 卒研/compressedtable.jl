# 最小回路の表: (キー:可逆関数, 値:可逆回路)を格納するハッシュテーブル
# 上記は外部仕様であり、内部的には、さまざまなメモリ節約機能を使って、最小回路の表をエミュレーションしている。
#
# 仕様
# ・makehashtableω()を実行したときに、キー:жidentityж(恒等関数)とその値:空回路が最小回路の表に格納された状態に初期設定される。
# ・setindex!ωで恒等関数の回路を登録してはいけない。そうした場合の動作は不定とする。
# ・getindexωで恒等関数の回路(空回路)を引くことはできる。
# ・最小回路の表にないキーを使ってgetindexωを呼んだ場合の動作は不定とする。典型的にはエラーが発生する。
# ・もし回路のゲート数がわかっている場合には、getindexω(h, f)よりもgetindexω(h, f, rcircuitsize)の方が高速。haskeyωについても同様。

include("basics.jl")
include("icequive.jl")
const MAXCIRCUITSIZE = 18

#comp_flag:メモリ圧縮をするかどうかのフラグ 0でnaive版 1で非圧縮 2で値の圧縮(α) 3でキーの圧縮(β) 4でキーと値の圧縮(αβ)
#最終的にはこれだけで制御するようにしたい
const comp_flag = 4

########################
# Naive
########################

setindex!0(h::Dict{RFunc,RCircuit}, f::RFunc, c::RCircuit) = h[f] = c
getindex0(h::Dict{RFunc,RCircuit}, f::RFunc) = h[f]
getindex0(h::Dict{RFunc,RCircuit}, f::RFunc, rcircuitsize::Integer) = getindex0(h, f)
haskey0(h::Dict{RFunc,RCircuit}, f::RFunc) = haskey(h, f)
haskey0(h::Dict{RFunc,RCircuit}, f::RFunc, rcircuitsize::Integer) = haskey0(h, f)
makehashtable0(maxcircuitsize=MAXCIRCUITSIZE) = Dict{RFunc,RCircuit}([(жidentityж::RFunc, RCircuit())])
keys0(h::Dict{RFunc,RCircuit}) = keys(h)
keys0(h::Dict{RFunc,RCircuit}, rcircuitsize::Integer) = [rfunc for (rfunc, rcircuit) in h if length(rcircuit) == rcircuitsize]
if comp_flag == 0
    setindex!ω = setindex!0
    getindexω = getindex0
    haskeyω = haskey0
    makehashtableω = makehashtable0
    keysω = keys0
end

########################
# No compression
########################

setindex!1(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, c::RCircuit) = @zeroindexed(h, length(c))[f] = c
function getindex1(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc)
    for h_ in h
        if haskey(h_, f)
            return h_[f]
        end
    end
    error("KeyError: key $f not found")
end
getindex1(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, rcircuitsize::Integer) = @zeroindexed(h, rcircuitsize)[f]
haskey1(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc) = any([haskey(h_, f) for h_ in h])
haskey1(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, rcircuitsize::Integer) = haskey(@zeroindexed(h, rcircuitsize), f)
function makehashtable1(maxcircuitsize=MAXCIRCUITSIZE)
    h = [Dict{RFunc,RCircuit}() for _ in 1:(maxcircuitsize + 1)]
    @zeroindexed(h, 0)[жidentityж::RFunc] = RCircuit()
    return h
end
keys1(h::Vector{Dict{RFunc,RCircuit}}) = Iterators.flatten([keys(h_) for h_ in h])
keys1(h::Vector{Dict{RFunc,RCircuit}}, rcircuitsize::Integer) = keys(@zeroindexed(h, rcircuitsize))
if comp_flag == 1
    setindex!ω = setindex!1
    getindexω = getindex1
    haskeyω = haskey1
    makehashtableω = makehashtable1
    keysω = keys1
end

########################
# The values of hashtable are RGate, instead of RCircuit
########################

# ハッシュテーブル(辞書)の型が変わるので注意。
# 圧縮なしの辞書::Dict{RFunc, RCircuit}
# ↓
# 圧縮ありの辞書::Dict{RFunc, RGate}
function setindex!α(h::Vector{Dict{RFunc,RGate}}, f::RFunc, c::RCircuit)
    if isempty(c) || haskeyα(h, f, length(c))
        return c
    end
    @zeroindexed(h, length(c))[f] = c[end]
    setindex!α(h, to_rfunc(inv(c[end]) ∘ f), c[1:end - 1])
    return c
end
function getindexα(h::Vector{Dict{RFunc,RGate}}, f::RFunc)
    if f == жidentityж::RFunc
        return RCircuit()
    end
    idx = findfirst(h_ -> haskey(h_, f), h)
    if idx != nothing
        g = h[idx][f]
        return push!(getindexα(h, to_rfunc(inv(g) ∘ f), idx - 2), g)
        # idxは1インデックスなので、\tau(inv(g) ∘ f) = idx-2
    else
        error("KeyError: key $f not found")
    end
end
function getindexα(h::Vector{Dict{RFunc,RGate}}, f::RFunc, rcircuitsize::Integer)
    if rcircuitsize == 0
        return RCircuit()
    end
    g = @zeroindexed(h ,rcircuitsize)[f]
    return push!(getindexα(h, to_rfunc(inv(g) ∘ f), rcircuitsize - 1), g)
end
haskeyα(h::Vector{Dict{RFunc,RGate}}, f::RFunc) = any([haskey(h_, f) for h_ in h])
haskeyα(h::Vector{Dict{RFunc,RGate}}, f::RFunc, rcircuitsize::Integer) = haskey(@zeroindexed(h, rcircuitsize), f)
function makehashtableα(maxcircuitsize=MAXCIRCUITSIZE)
    h = [Dict{RFunc,RGate}() for _ in 1:(maxcircuitsize + 1)]
    @zeroindexed(h, 0)[жidentityж::RFunc] = RGate()
    return h
end
keysα(h::Vector{Dict{RFunc,RGate}}) = Iterators.flatten([keys(h_) for h_ in h])
keysα(h::Vector{Dict{RFunc,RGate}}, rcircuitsize::Integer) = keys(@zeroindexed(h, rcircuitsize))
if comp_flag == 2
    setindex!ω = setindex!α
    getindexω = getindexα
    haskeyω = haskeyα
    makehashtableω = makehashtableα
    keysω = keysα
end

########################
# The keys of hashtable are representative functions only
########################

function setindex!β(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, c::RCircuit)
    r, p = ic_representative_function_ptn(f)
    cr = apply_pattern(c, p)
    @zeroindexed(h, length(cr))[r] = cr
    return c
end
function getindexβ(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc)
    r, p = ic_representative_function_ptn(f)
    cr = getindex1(h, r)
    return apply_pattern(cr, inv(p))
end
function getindexβ(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, rcircuitsize::Integer)
    r, p = ic_representative_function_ptn(f)
    cr = getindex1(h, r, rcircuitsize)
    return apply_pattern(cr, inv(p))
end
haskeyβ(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc) = haskey1(h, ic_representative_function(f))
haskeyβ(h::Vector{Dict{RFunc,RCircuit}}, f::RFunc, rcircuitsize::Integer) = haskey1(h, ic_representative_function(f), rcircuitsize)
makehashtableβ = makehashtable1
keysβ(h::Vector{Dict{RFunc,RCircuit}}) = Iterators.flatten([ic_class(f) for h_ in h for f in keys(h_)])
keysβ(h::Vector{Dict{RFunc,RCircuit}}, rcircuitsize::Integer) = Iterators.flatten([ic_class(f) for f in keys(@zeroindexed(h, rcircuitsize))])
if comp_flag == 3
    setindex!ω = setindex!β
    getindexω = getindexβ
    haskeyω = haskeyβ
    makehashtableω = makehashtableβ
    keysω = keysβ
end 

########################
# Mixture of α and β techniques
########################

function setindex!αβ(h::Vector{Dict{RFunc,RGate}}, f::RFunc, c::RCircuit)
    r, p = ic_representative_function_ptn(f)
    if isempty(c) || haskey(@zeroindexed(h, length(c)), r)
        return c
    end
    cr = apply_pattern(c, p)
    @zeroindexed(h, length(cr))[r] = cr[end]
    setindex!αβ(h, to_rfunc(inv(cr[end]) ∘ r), cr[1:end - 1])
    return c
end
function getindexαβ(h::Vector{Dict{RFunc,RGate}}, f::RFunc)
    if f == жidentityж::RFunc
        return RCircuit()
    end
    r, p = ic_representative_function_ptn(f)
    idx = findfirst(h_ -> haskey(h_, r), h)
    if idx != nothing
        g = h[idx][r]
        cr = push!(getindexαβ(h, to_rfunc(inv(g) ∘ r), idx - 2), g)
        # idxは1インデックスなので、\tau(inv(g) ∘ r) = idx-2
        return apply_pattern(cr, inv(p))
    else
        error("KeyError: key $f not found")
    end
end
function getindexαβ(h::Vector{Dict{RFunc,RGate}}, f::RFunc, rcircuitsize::Integer)
    if rcircuitsize == 0
        return RCircuit()
    end
    r, p = ic_representative_function_ptn(f)
    g = @zeroindexed(h, rcircuitsize)[r]
    cr = push!(getindexαβ(h, to_rfunc(inv(g) ∘ r), rcircuitsize - 1), g)
    return apply_pattern(cr, inv(p))
end
haskeyαβ(h::Vector{Dict{RFunc,RGate}}, f::RFunc) = haskeyα(h, ic_representative_function(f))
haskeyαβ(h::Vector{Dict{RFunc,RGate}}, f::RFunc, rcircuitsize::Integer) = haskeyα(h, ic_representative_function(f), rcircuitsize)
makehashtableαβ = makehashtableα
keysαβ(h::Vector{Dict{RFunc,RGate}}) = Iterators.flatten([ic_class(f) for h_ in h for f in keys(h_)])
keysαβ(h::Vector{Dict{RFunc,RGate}}, rcircuitsize::Integer) = Iterators.flatten([ic_class(f) for f in keys(@zeroindexed(h, rcircuitsize))])
if comp_flag == 4
    setindex!ω = setindex!αβ
    getindexω = getindexαβ
    haskeyω = haskeyαβ
    makehashtableω = makehashtableαβ
    keysω = keysαβ
end
