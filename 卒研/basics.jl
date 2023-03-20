# basics.jl
# プログラム全体で使われる基本機能に関するコードをこのファイルに書く。

# Avoiding duplicate inclusion of "header.jl"
try
    HEADERFLAG
catch
    include("header.jl")
end

# プログラム全体の初期化関数。
# 最初に初期化が必要。可逆関数の変数の個数を変えるときにも再度初期化すること。
function initialize_all(n::Integer; max_controls::Integer=n-1)
    # nに可逆関数の変数の個数を指定する。
    # max_conrtolsにToffoliゲートの最大コントロール数を指定する(デフォルトn-1)。
    initialize_basics(n; max_controls=max_controls)
    initialize_icequive(n)
    return n
end

# 初期化関数。
function initialize_basics(n::Integer; max_controls::Integer=n-1)
    # nに可逆関数の変数の個数を指定する。
    # max_conrtolsにToffoliゲートの最大コントロール数を指定する(デフォルトn-1)。
    set_num(n)
    set_rgate_rfunc_dict(n; max_controls=max_controls)
    set_identity(n)
    #set_varepsilon()
    return n
end

#########################
# 可逆関数の操作
#########################

# RFuncのアクセス関数(書き換え)
# function rfunc_set!(rfunc::AbstractRFunc, input::Integer, output::Integer)
#     # rfuncを関数と見て、rfunc(input)=outputとなるようにrfuncを上書きする。
#     rfunc[begin+input] = output
# end

# import Base.∘
# function (∘)(g::AbstractRFunc, f::AbstractRFunc)
#     # RFunc同士の(数学の)関数合成
#     return [g(f(i)) for i in UnitRange{RInt}(0:length(f)-1)]
# end

#(∘)(fs::AbstractRFunc...) = reduce((∘), fs; init=RFunc())
# 廃止: ゼロ個の引数のときに、引数の型がわからないのに、これが常に動作することになって危険。

import Base.inv
function inv(rfunc::AbstractRFunc)
    # rfuncの逆関数を求める。
    inv_rfunc = similar(rfunc)
    for (input, output) in zip(UnitRange{RInt}(0:length(rfunc)-1), rfunc)
        inv_rfunc[begin+output] = input
    end
    return inv_rfunc    
end

#########################
# ゲートや回路の操作
#########################

# RGateの等価性判定。
# ==は、target同士が等しくかつcontrol同士が等しいことに定義する。
#import Base.==
#(==)(x::RGate, y::RGate) = (x._target == y._target) && (x._control == y._control)
# RGateをキーとする辞書を使用するので、hashとisequalの両方をオーバーロー
# ドする必要がある。isequalは辞書用の等価性判定関数であり、Juliaの仕
# 様により、isequalは、ハッシュ値同士が等しいことに定義する。
# hashは、target同士が等しくかつcontrol同士が等しければ、ハッシュ値が
# 等しくなるように定義する。
# 参考URL:
# https://stackoverflow.com/questions/34936593/overload-object-comparison-when-adding-to-a-set-in-julia/34937834
# Base.hash(x::RGate, h::UInt) = hash(x._target, hash(x._control, hash(:RGate, h)))
# Base.isequal(x::RGate, y::RGate) = Base.isequal(hash(x), hash(y))

# objが実現する可逆関数を求める。
# objとしては、RGate, RCircuit, その他真理値表的な関数(含function-like object)を想定している。
# 変数の個数はжnumжと仮定する。
function to_rfunc(obj; num::Integer=жnumж::Integer)
    return RFunc([obj(input) for input in UnitRange{RInt}(0:(2^num)-1)])
end

using Combinatorics:combinations
function generate_control_patterns(num::Integer, num_control::Integer)
    # numは変数の個数。
    # num_controlは、コントロールAND数。
    # num_controlで指定した個数のコントロールANDを持つゲートのパターンをすべて求める。
    return [RGate(target, controls) for target in UnitRange{RInt}(0:num-1) for controls in combinations(collect(delete!(Set(UnitRange{RInt}(0:num-1)), target)), num_control)]
end

function generate_all_rgates(num::Integer, max_controls::Integer=num-1)
    # 下記では、numをNと表す。
    # N変数のすべてのゲートを求める。
    # max_controlsには，ゲートの取り得るコントロール数の最大値を指定する。
    # ゲート数は，max_control = N - 1のときには，N × 2^{N - 1}で，
    # 一般には，N × Σ_{0 <= i <= max_control}((N - 1) choose i)である。
    # 一般のときのこのΣは単純な式にはならないらしい。(参照: D. Knuth, The art of computer programming Vol.1, P.64 Eq.(36))
    return collect(Iterators.flatten([generate_control_patterns(num, num_controls) for num_controls in UnitRange{RInt}(0:max_controls)]))
end

import Base.inv
function inv(rcircuit::RCircuit)
    # rcircuitの逆関数回路を求める。
    return reverse(rcircuit)
end
function inv(rgate::RGate)
    # rgateの逆関数ゲートを求める。
    # 実際には、rgateをそのまま返すだけ。Toffoli型ゲートの逆関数ゲートは自分自身だから。
    return rgate
end
