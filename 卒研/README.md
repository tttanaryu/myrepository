# Findopt 可逆回路最小化プログラム

## 主なファイル

<DL>
  <DT>header.jl</DT> <DD>ヘッダファイル</DD>
  <DT>basics.jl</DT> <DD>プログラム全体で使われる基本機能</DD>
  <DT>icequive.jl</DT> <DD>同値類関係</DD>
  <DT>findopt.jl</DT> <DD>回路の最小化関係</DD>
  <DT>complessedtable.jl</DT> <DD>最小回路表へのアクセス機能</DD>
  <DT>lb.jl</DT> <DD>可逆関数のサイズの下界計算</DD>
  <DT>A_star.jl</DT> <DD>A*アルゴリズムによるfindoptの拡張機能</DD>
  <DT>test_*.jl</DT> <DD>TestBasics準拠のユニットテスト</DD>
</DL>

## 関連リンク

開発者向けの情報は、下記のWikiページ参照。

* メモのWikiページ: <https://github.com/kono-cis-iwate-u-ac-jp/github-tanaryu/wiki>

# 使い方

## テスト

test_*.jlがテストプログラム。
例えば、test_basics.jlのテストを実行したいとき、コマンドラインから以下のようにすればよい。

```
julia test_basics.jl
```

他のテストプログラムの実行についても、やり方は同様。

# 主な関数

## basics.jl

### inv

```julia
inv(rfunc::AbstractRFunc) -> AbstractRFunc
```

RFuncの逆関数を求める。

例: 

```
julia> inv(RFunc([2,0,3,1]))
4-element Array{UInt8,1}:
 0x01
 0x03
 0x00
 0x02
```

```julia
inv(rcircuit::RCircuit) -> RCircuit
```

RCircuitの逆関数回路を求める。

例: 

```
julia> inv(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]))
3-element Array{RGate,1}:
 RGate(0x00, UInt8[0x02])
 RGate(0x03, UInt8[])
 RGate(0x02, UInt8[0x01, 0x03])
```

### 関数様オブジェクト

RFunc, RGate, RCircuitについて、可逆関数とみなして、入力値に対する出力値を求める関数様オブジェクト(function-like object)が用意されている。

例: 使い方

```
julia> initialize_basics(4)
4

julia> r = RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7])
16-element Array{UInt8,1}:
 0x08
 0x09
 0x0a
 0x0b
 0x0c
 0x0d
 0x0e
 0x0f
 0x00
 0x01
 0x02
 0x03
 0x04
 0x05
 0x06
 0x07

julia> r(0)
0x08

julia> r(1)
0x09

julia> r(15)
0x07

julia> g = RGate(3, [0,1,2])
RGate(0x03, UInt8[0x00, 0x01, 0x02])

julia> g(14)
14

julia> g(15)
7

julia> to_rfunc(g)
16-element Array{UInt8,1}:
 0x00
 0x01
 0x02
 0x03
 0x04
 0x05
 0x06
 0x0f
 0x08
 0x09
 0x0a
 0x0b
 0x0c
 0x0d
 0x0e
 0x07

julia> c = RCircuit([RGate(2, [0,1,3]), RGate(0, [1,2,3])])
2-element Array{RGate,1}:
 RGate(0x02, UInt8[0x00, 0x01, 0x03])
 RGate(0x00, UInt8[0x01, 0x02, 0x03])

julia> c(14)
15

julia> c(15)
11

julia> to_rfunc(c)
16-element Array{UInt8,1}:
 0x00
 0x01
 0x02
 0x03
 0x04
 0x05
 0x06
 0x07
 0x08
 0x09
 0x0a
 0x0e
 0x0c
 0x0d
 0x0f
 0x0b
```

### 関数合成(Base.∘)

関数様オブジェクトを用意したので、Base.∘による数学の関数合成が可能。
RFunc, RGate, RCircuitを混在させても大丈夫。
ただし、Base.∘で関数合成した結果は、Juliaの関数であってRFuncではないことには注意。
RFuncにしたいときには、to_rfuncを使う。

例: 

```
julia> initialize_basics(4)
4

julia> r = RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7]) ∘ RGate(3, [0,1,2]) ∘  RCircuit([RGate(2, [0,1,3]), RGate(0, [1,2,3])])
#64 (generic function with 1 method)

julia> to_rfunc(r)
16-element Array{UInt8,1}:
 0x08
 0x09
 0x0a
 0x0b
 0x0c
 0x0d
 0x0e
 0x07
 0x00
 0x01
 0x02
 0x06
 0x04
 0x05
 0x0f
 0x03
```

回路のゲートの並び順と数学の関数合成の並び順は逆であることにも注意。

例: 

```
julia> initialize_basics(4)
4

julia> to_rfunc(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])])) == to_rfunc(RGate(0, [2]) ∘ RGate(3, []) ∘ RGate(2, [1,3]))
true
```

## icequive.jl

逆関数同値と共役同値を合わせた同値類(逆関数同値と共役同値の推移閉包)をIC同値類と呼ぶ。

### ic_class

```julia
ic_class(rfunc::AbstractRFunc) -> Set{AbstractRFunc}
```

rfuncのIC同値類を求める。

例: 

```
julia> initialize_icequive(3)
3

julia> ic_class(RFunc([6,5,0,7,3,4,2,1]))
Set{Array{UInt8,1}} with 12 elements:
  UInt8[0x04, 0x03, 0x07, 0x02, 0x05, 0x00, 0x01, 0x06]
  UInt8[0x03, 0x06, 0x00, 0x02, 0x05, 0x01, 0x07, 0x04]
  UInt8[0x01, 0x05, 0x07, 0x04, 0x06, 0x00, 0x02, 0x03]
  UInt8[0x05, 0x06, 0x03, 0x01, 0x00, 0x04, 0x07, 0x02]
  UInt8[0x02, 0x05, 0x03, 0x00, 0x07, 0x04, 0x01, 0x06]
  UInt8[0x01, 0x03, 0x06, 0x00, 0x07, 0x02, 0x04, 0x05]
  UInt8[0x06, 0x03, 0x05, 0x02, 0x00, 0x07, 0x04, 0x01]
  UInt8[0x04, 0x07, 0x03, 0x01, 0x06, 0x02, 0x00, 0x05]
  UInt8[0x02, 0x07, 0x06, 0x04, 0x05, 0x01, 0x00, 0x03]
  UInt8[0x05, 0x00, 0x06, 0x07, 0x03, 0x01, 0x04, 0x02]
  UInt8[0x03, 0x00, 0x05, 0x01, 0x06, 0x07, 0x02, 0x04]
  UInt8[0x06, 0x05, 0x00, 0x07, 0x03, 0x04, 0x02, 0x01]

```

```julia
ic_class_ptn(rfunc::AbstractRFunc) -> Set{Tuple{AbstractRFunc,ICPattern}}
```

rfuncのIC同値類とそのICPatternを求める。

例: 

```
julia> initialize_icequive(3)
3

julia> ic_class_ptn(RFunc([6,5,0,7,3,4,2,1]))
Set{Tuple{Array{UInt8,1},ICPattern}} with 12 elements:
  (UInt8[0x04, 0x03, 0x07, 0x02, 0x05, 0x00, 0x01, 0x06], ICPattern(false, UInt8[0x01, 0x02, 0x00]))
  (UInt8[0x03, 0x06, 0x00, 0x02, 0x05, 0x01, 0x07, 0x04], ICPattern(true, UInt8[0x02, 0x01, 0x00]))
  (UInt8[0x01, 0x05, 0x07, 0x04, 0x06, 0x00, 0x02, 0x03], ICPattern(false, UInt8[0x01, 0x00, 0x02]))
  (UInt8[0x05, 0x06, 0x03, 0x01, 0x00, 0x04, 0x07, 0x02], ICPattern(true, UInt8[0x01, 0x02, 0x00]))
  (UInt8[0x02, 0x05, 0x03, 0x00, 0x07, 0x04, 0x01, 0x06], ICPattern(false, UInt8[0x02, 0x01, 0x00]))
  (UInt8[0x01, 0x03, 0x06, 0x00, 0x07, 0x02, 0x04, 0x05], ICPattern(false, UInt8[0x02, 0x00, 0x01]))
  (UInt8[0x06, 0x03, 0x05, 0x02, 0x00, 0x07, 0x04, 0x01], ICPattern(true, UInt8[0x00, 0x02, 0x01]))
  (UInt8[0x04, 0x07, 0x03, 0x01, 0x06, 0x02, 0x00, 0x05], ICPattern(false, UInt8[0x00, 0x02, 0x01]))
  (UInt8[0x02, 0x07, 0x06, 0x04, 0x05, 0x01, 0x00, 0x03], ICPattern(false, UInt8[0x00, 0x01, 0x02]))
  (UInt8[0x05, 0x00, 0x06, 0x07, 0x03, 0x01, 0x04, 0x02], ICPattern(true, UInt8[0x01, 0x00, 0x02]))
  (UInt8[0x03, 0x00, 0x05, 0x01, 0x06, 0x07, 0x02, 0x04], ICPattern(true, UInt8[0x02, 0x00, 0x01]))
  (UInt8[0x06, 0x05, 0x00, 0x07, 0x03, 0x04, 0x02, 0x01], ICPattern(true, UInt8[0x00, 0x01, 0x02]))
```

### ic_representative_function

```julia
ic_representative_function(rfunc::AbstractRFunc) -> AbstractRFunc
```

rfuncのIC同値類代表関数を求める。

例: 

```
julia> initialize_icequive(3)
3

julia> ic_representative_function(RFunc([6,5,0,7,3,4,2,1]))
8-element Array{UInt8,1}:
 0x01
 0x03
 0x06
 0x00
 0x07
 0x02
 0x04
 0x05
```

### ic_representative_funcptntion_ptn

```julia
ic_representative_function_ptn(rfunc::AbstractRFunc) -> Tuple{AbstractRFunc,ICPattern}
```

rfuncのIC同値類代表関数とそのICPatternを求める。

例: 

```
julia> initialize_icequive(3)
3

julia> ic_representative_function_ptn(RFunc([6,5,0,7,3,4,2,1]))
(UInt8[0x01, 0x03, 0x06, 0x00, 0x07, 0x02, 0x04, 0x05], ICPattern(false, UInt8[0x02, 0x00, 0x01]))
```

### inv

```julia
inv(icpattern::ICPattern) -> ICPattern
```

ICPatternの復元パターン(逆変換パターン)を生成する。

例: 

```
julia> initialize_icequive(3)
3

julia> inv(ICPattern(false, Vector{RInt}([2,0,1])))
ICPattern(false, UInt8[0x01, 0x02, 0x00])

julia> inv(ICPattern(true, Vector{RInt}([2,0,1])))
ICPattern(true, UInt8[0x01, 0x02, 0x00])
```

### apply_pattern

```julia
apply_pattern(obj::T, icpattern::ICPattern) -> T
```

icpatternで指定されたように、objのIC同値版を求める。
objとしては、AbstractRFunc, RGate, RCircuitを想定している。

例: obj::AbstractRFuncについては、IC同値関数を求める。

```
julia> initialize_icequive(3)
3

julia> apply_pattern(RFunc([1,3,6,0,7,2,4,5]), ICPattern(false, Vector{RInt}([1,2,0])))
8-element Array{UInt8,1}:
 0x06
 0x05
 0x00
 0x07
 0x03
 0x04
 0x02
 0x01
```

例: obj::RCircuitについては、IC同値回路を求める。

```
julia> initialize_icequive(4)
4

julia> apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, Vector{RInt}([0x03, 0x00, 0x01, 0x02])))
3-element Array{RGate,1}:
 RGate(0x03, UInt8[0x01])
 RGate(0x02, UInt8[])
 RGate(0x01, UInt8[0x00, 0x02])
```
## findopt.jl
 最小化アルゴリズムをまとめたスクリプト。
### findopt(f, H, k)
 可逆関数の最小回路を求めるアルゴリズム。

 引数について
 
 f：最小回路を求めたい可逆関数。
 
 H：最小回路表。可逆関数をキー、最小回路を値に取るハッシュテーブルになっている。
 
 k：最小回路表に登録されている可逆関数(最小回路)の最大サイズ。BFSの引数と同じ。
 
 出力は引数fの最小回路。
 
 例
 ```
 julia> initialize_icequive(4)
 4
 
 julia> findopt(RFunc([4,5,6,7,0,1,2,3,12,15,14,13,8,11,10,9]), H)
 2-element Array{RGate,1}:
  RGate(0x02, UInt8[])
  RGate(0x01, UInt8[0x00, 0x03])
 ```
 
 ### BFS(k)
 最小回路表を作成するアルゴリズム。
 
 引数k(任意の自然数)までのサイズの可逆関数/最小回路を登録した最小回路表を出力する。出力される最小回路表は可逆関数をキー、最小回路を値に取るハッシュテーブルになっている。
 
 ## complessedtable.jl
 最小化アルゴリズムにおいて最小回路表へのアクセス時に用いる関数をまとめたスクリプト。
 
 以下、関数で使用する引数の定義はすべてのアクセス関数で共通である。
 
 h：最小回路表。キーが可逆関数、値が最小回路のハッシュテーブルになっている。 
 
 f：可逆関数。 
 
 c：最小回路。 
 
 rcircuitsize：関数(とその最小回路)のサイズを表す。サイズは最小回路のゲート数に等しい。
 
 ### setindex!ω(h,f,c)
 ハッシュテーブルhのキーに可逆関数f、値に最小回路cを登録するアクセス関数。返り値は無し。
 ### getindexω(h, f)
 ハッシュテーブルhからキーである可逆関数fに対応した最小回路を出力するアクセス関数。fのサイズが分かっている場合は引数を`(h, f, rcircuit)`とすることで効率が良くなる。返り値はハッシュテーブルh内でキーfに対応した値の最小回路。
 ### haskeyω(h, f)
 ハッシュテーブルh内に可逆関数fがキーとして存在するかどうかを判定するアクセス関数。返り値はbool型(trueまたはfalse)。
 ### makehashtableω()
 キーが可逆関数、値が最小回路のハッシュテーブルを生成する。返り値はハッシュテーブル。
 ### keysω(h)
 ハッシュテーブルのキーになっている要素すべての集合を返り値とする。
引数を`(h, rcircuitsize)`とすることでサイズがrcircuitsizeと等しいキーだけの要素の集合を返り値とする。

 ## lb.jl
 可逆関数のサイズの下界を計算する関数をまとめたスクリプト。
 
 細かい処理ごとに関数分けされているので、実際に呼び出す関数だけ書いておく。
 
 ### to_lb(f)
 引数である可逆関数fのサイズの下界を返す関数。スクリプトの最初にある定数lb_flagの値を変更することで下界計算の方法を変更できる。
 
 #### sigma_lb
 lb_flag = 0のときはto_lb(f)でsigma計算を行う。返す下界の精度は高い(真値に近い値を返す)が、計算に時間がかかる。
 
 例　f = (1,5,4,6,2,3,7,0)のとき(サイズの真値は7)
 ```
 julia> to_lb([1,5,4,6,2,3,7,0])
 5
 ```
 
 #### kappa_lb
 lb_flag = 1のときはto_lb(f)でkappa計算を行う。計算時間が短く、返す下界の精度はsigmaよりわずかに低い程度(ほとんどの場合sigmaと一致する)。
 ```
 julia> to_lb([1,5,4,6,2,3,7,0])
 4
 ```
 
