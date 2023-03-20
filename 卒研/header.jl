# header.jl
# プログラム全体の中で、始めに1度だけ実行し、2回以上実行しないコードを
# このファイルに書く。

const HEADERFLAG = true # 読み込み済みを記録するフラグ

#########################
# 可逆関数のデータ構造
#########################

# プログラムが想定する変数の個数(可逆論理関数の変数の個数、可逆論理回路のライン数)の最大値。これを変更した場合、再コンパイルが必要。大域定数というより、コンパイルパラメータ。
const MAX_N = 8 # <= 16まで

# 可逆関数は置換の1行表現で表すものとし、実際のデータ構造としては1次元
# 配列を用いる。可逆関数の入力値はゼロから始まるため、可逆関数や置換を
# 意味する1次元配列はゼロインデックスとするアクセス関数が用意されてい
# る。

# RInt: Data type for in/out values of reversible functions.
if MAX_N <= 8
    const RInt = UInt8 # upto 8-variable reversible functions
elseif MAX_N <= 16
    const RInt = UInt16 # upto 16-variable reversible functions
elseif MAX_N <= 32
    const RInt = UInt32 # upto 32-variable reversible functions
end

# RFunc: Data type for a reversible function.
const RFunc = Vector{RInt}
const AbstractRFunc = Vector{<:Integer}

# RFuncのコンストラクタ。初期値はn変数の恒等関数。
#RFunc(n::Integer=жnumж::Integer) = RFunc(0:(2^n)-1)
# (廃止)type piracyの問題を引き起こすことが確認されたため。恒等関数を使いたいときには、大域変数のжidentityжを参照せよ。

# 1次元配列をゼロインデックスで使うための単純なマクロ
# @zeroindexed(v,k)は、v[k+1]に変換される。マクロなので代入も可能。
macro zeroindexed(v, k)
    Expr(:ref, esc(v), Expr(:call, +, esc(k), 1))
end

# function-like object: 可逆関数AbstractRFuncに、入力値inputを与えたときの出力値を返す。
function (rfunc::AbstractRFunc)(input::Integer)
    return rfunc[begin+input]
end

#########################
# ゲートや回路のデータ構造
#########################

import BitOperations:bset,bget,bmask,bflip

# ライン番号は、ゼロインデックスとする。
# (conjugationの置換パターンをゼロインデックスにしているため)

# RGateのデータ構造を変更したときには、「basics.jl」のhashとisequalのオーバーロードも修正する必要があることに注意。

# ↓これは取りやめた。メモリ削減のため。
# ゲートRGateは、controlとtargetからなる構造体とする。
# controlはVector{RInt}型。targetはRInt型とする。
# controlの要素は昇順にソートすること。
# Base.@kwdef struct RGate
#     target::RInt = typemax(RInt) # initial target is a dummy
#     control::Vector{RInt} = []
# end
# function get_target(rgate::RGate)
#     return rgate.target
# end
# function get_control(rgate::RGate)
#     return rgate.control
# end

# ゲートRGateは、整数表現のビット列。UInt16の別名。
# RGateのコンストラクタなどを作ると、UInt16そのものの振る舞いを変えてしまうため、type piracy問題の意味でかなり危険。しかし、メモリ節約のために背に腹は変えられない。(本来は安全面から、こういうときはUInt16をラップした構造体にするのが望ましい。)
# rgate::RGateのデータ構造
# ・ターゲット: rgateの下位RGateTargetBitLengthビットが、ターゲットビットの位置の2進数整数を表す。
# ・コントロール: (rgate >>> RGateTargetBitLength)が、コントロールビットの位置が1になっているビット列(フラグ列)を表す。
# 人間が使うために、コントロールビットの配列で指定するコンストラクタやアクセス関数も用意されている。コンストラクタにおいてコントロールビットの並びはソートされている必要はない。アクセス関数get_controlの結果は昇順にソートされている。
if MAX_N <= 12
    const RGate = UInt16 # the lines(bits) of a gate is up to 12.
    const RGateTargetBitLength = 4
elseif MAX_N <= 27
    const RGate = UInt32 # the lines(bits) of a gate is up to 27.
    const RGateTargetBitLength = 5
end
function RGate(target::Integer, control::Vector) # human-friendly constructor. 'control' may be an empty vector, whose type is Vector{Any}.
    tg::RGate = bget(target, 0:(RGateTargetBitLength-1))
    ct::RGate = (|)(RGate(0), bmask.(RGate, control)...)
    return (ct << RGateTargetBitLength) | tg
end
function RGate() # dangerous?
    RGate((1 << RGateTargetBitLength) - 1, Int[])
end
function get_target(rgate::RGate)
    # rgateのターゲットビットの位置(0index)を返す
    return bget(rgate, 0:(RGateTargetBitLength-1))
end
function get_control(rgate::RGate)
    # rgateのコントロールビットの位置(0index)を配列で返す
    xcontrol = rgate >>> RGateTargetBitLength
    counter = 0
    result = RInt[]
    while !(iszero(xcontrol))
        if ((xcontrol & 0b1) == 1)
            push!(result, counter)
        end
        xcontrol = xcontrol >>> 1
        counter += 1
    end
    return result
end
function get_target_bin(rgate::RGate)
    # ゲートの、ターゲットビットの位置が1になっているビット列を表す。
    position = get_target(rgate)
    return bmask(RGate, position)
end
function get_control_bin(rgate::RGate)
    # ゲートの、コントロールビットの位置が1になっているビット列を表す。
    return rgate >>> RGateTargetBitLength
end

#import Base.:&
#(&)() = true # 引数なしのビットANDの結果は1(true)とする。NOTゲートではANDの単位元1が仮想的なコントロールとみなすことに合わせるため。
# 廃止: ゼロ個の引数のときに、引数の型がわからないのに、これが常に動作することになって危険。
# function-like object: ゲートRGateを関数と見て、入力値inputを与えたときの出力値を返す。
# function (rgate::RGate)(input::Integer)
#     # bget,bsetは仕様でゼロインデックスであることに注意。
#     target_input = bget(input, get_target(rgate))
#     control_inputs = [bget(input, control) for control in get_control(rgate)]
#     target_output = (&)(control_inputs..., true) ⊻ target_input
#     return bset(input, get_target(rgate), Bool(target_output))
# end
function (rgate::RGate)(input::Integer)
    control_mask = get_control_bin(rgate)
    if (input & control_mask) == control_mask
        return bflip(input, get_target(rgate))
    else
        return input
    end
end

# 回路RCircuitはゲートの1次元配列とする。
const RCircuit = Vector{RGate}
# function-like object: 回路RCircuitを関数と見て、入力値inputを与えたときの出力値を返す。
function (rcircuit::RCircuit)(input::Integer)
    rint = input
    for rgate in rcircuit
        rint = rgate(rint)
    end
    return rint
end

#########################
# 大域変数
#########################

# Juliaには大域変数を局所変数と見分けるような命名規則がない。
# 一目で見分けられるようにしたいので、このプログラムでは、独自の大域変
# 数の命名規則をつける。
# 規則: 大域変数名は、最初の文字と最後の文字を「ж」(ロシア文字の小文
# 字:Unicode U+0436)にする。

# Juliaでは、大域変数を使うとプログラムの速度が落ちる。原因は大域変数
# の型がAnyになるから。対策として、大域変数にアクセスするところでは、
# 型アノテーションを付けて書くこと。

# жnumж::Integer 関数の変数の個数を保持する変数
# жallpermutationsж::Vector{Vector{UInt8}} すべての置換を予め計算してキャッシュしておくための変数
# жrgate_rfunc_dictж::Dict{RGate,RFunc} すべてのrgateとrfuncの対応を予め計算してキャッシュしておくための辞書
# жidentityж::RFunc 恒等関数を保持する変数

function set_num(n::Integer)
    global жnumж = n # Integer 関数の変数の個数を保持する変数
    # 注: 大域変数の初期化では型アノテーションをつけられない。
end

import Combinatorics:permutations
function set_allpermutations(n::Integer)
    global жallpermutationsж = collect(permutations(UnitRange{UInt8}(0:n-1)))
    # 注: 大域変数の初期化では型アノテーションをつけられない。
end
#get_allpermutations() = жallpermutationsж::Vector{Vector{UInt8}}

function set_rgate_rfunc_dict(n::Integer; max_controls::Integer=n-1)
    global жrgate_rfunc_dictж = Dict([(rgate, to_rfunc(rgate)) for rgate in generate_all_rgates(n, max_controls)])
    # 注: 大域変数の初期化では型アノテーションをつけられない。
end
#get_rgate_rfunc_dict() = жrgate_rfunc_dictж::Dict{RGate,RFunc}
#rfunc_dict(rgate) = жrgate_rfunc_dictж::Dict{RGate,RFunc}[rgate]

function set_identity(n::Integer)
    global жidentityж = RFunc(0:(2^n)-1)
    # 注: 大域変数の初期化では型アノテーションをつけられない。
end

# function set_varepsilon()
#     global жvarepsilonж = RCircuit()
#     # 注: 大域変数の初期化では型アノテーションをつけられない。
# end
# (廃止) 空回路にpush!して使うことが想定されるので、大域変数を壊してしまう恐れあり。面倒でもコンストラクタRCircuit()を呼んで空回路を生成すべし。
