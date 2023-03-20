#findopt 

#using BenchmarkTools

include("header.jl")
include("basics.jl")
include("icequive.jl")
include("compressedtable.jl")
#include("lb.jl")
#include("A_star.jl")

using Combinatorics

const findflag = 1 #0でfindopt_n,1でfindopt_A,2でfindopt_a

#findopt:入力した可逆関数fを再現する最小回路を出力する
function findopt_n(f::AbstractRFunc, H, k=length(H)-1)
    try
        #ハッシュテーブル内にfがキーとして存在するかをチェック
        haskeyω(H, f) && return getindexω(H, f)

        #入力した可逆関数fのサイズがkより大きい場合の処理
        #サイズk以下の2つの関数に分けてそれぞれがハッシュテーブル内にキーとして存在したら回路を出力する
        for i in 1:k
            for g::RFunc in keysω(H, i)
                h = to_rfunc(f ∘ g)
                if haskeyω(H, h)
                    c_g = getindexω(H, g)
                    c_h = getindexω(H, h)
                    circuit = vcat(inv(c_g), c_h)
                    #println(length(circuit))
                    return circuit
                end
            end
        end
        return nothing
    catch
        #エラー処理
        #println("Size of f is lerger than ", k*2, ".")
        return false
    end
end

#BFS:最小回路のサイズが引数kまでの可逆関数と回路のハッシュテーブルHを出力する
function BFS(k)
    #H：可逆関数をキー、回路を値としたハッシュテーブル まずは枠組みを作る
    H = makehashtableω(k)
    #A：Hのキーのリスト 不要だった

    for i in 1:k
        for j::RFunc in keysω(H, i-1)
            for (rgate, gfunc) in жrgate_rfunc_dictж
                #すでにハッシュテーブルHに格納されている回路(とその逆回路)にゲートをひとつ追加して、その関数をHに格納する
                #ひとつの回路に対してすべてのn入力可逆ゲートについて検証する
                h = to_rfunc(gfunc ∘ j)
                #hi = to_rfunc(inv(j) ∘ gfunc)

                c = vcat(getindexω(H, j, i-1), rgate)
                #ci = vcat(rgate, getindexω(H, inv(j), i-1))

                haskeyω(H,h) || setindex!ω(H, h, c)
                #haskeyω(H,hi) || setindex!ω(H, hi, ci)
            end
        end
    end
    return H
end

# 現時点で思いつく方法　
# ・ある程度候補になりそうな回路群を取っておいてその中から最小のものを解にする 実装は簡単だがそもそも枝刈りで排除したものの中に最小回路が無いことを証明できない
# ・最初に枝刈りを用いて関数の適当な回路を求める→関数のサイズは適当に求めた回路のゲート数以下であるため、回路表にある最小回路を組み合わせることで求められる(探索の上限を先に作る)
#   おそらく最小のものが出せると思うが実装が難しい あと結局計算量をさほど絞れてない

#=function findopt_A(f::AbstractRFunc, H, k)
    #ハッシュテーブル内にfがキーとして存在するかをチェック
    haskeyω(H, f) && return getindexω(H, f)

    #入力した可逆関数fのサイズがkより大きい場合の処理
    #サイズk以下の2つの関数に分けてそれぞれがハッシュテーブル内にキーとして存在したら回路を出力する

    d_open = Dict()

    for i in 1:k
        for g::RFunc in keysω(H, i)
            h = to_rfunc(f ∘ g)
            c_g = getindexω(H, g)

            if haskeyω(H, h)
                #c_g = getindexω(H, g)
                c_h = getindexω(H, h)
                return vcat(inv(c_g), c_h)
            end

            if i == k
                reps = rep_res(to_rfunc(inv(c_g)), inv(c_g), h, to_lb(h))
                if haskey(d_open, reps[begin]) == false
                    d_open[reps[begin]] = reps[2:end]
                else
                    comp_A2(reps, d_open)
                end
                #d_open[to_rfunc(inv(c_g))] = (inv(c_g), h, to_lb(h))
            end
        end
    end    

    #println(length(d_open))
    #optimal = optimize_a_star(f, H, k, d_open)
    optimal = optimize_A_star(f, d_open)

    return optimal

    #= 多分使わない
    lbmin = to_lb(f) #fの下界
    fmin = f
    f_s = 0

    for g::RFunc in keysω(H, k)
        h = to_rfunc(f ∘ g)
        lbh = to_lb(h) #hの下界
        if lbmin > lbh
            lbmin = lbh
            fmin = h
            f_s = g
        end
    end

    cir_size = optimize_A_star(getindexω(H, f_s, k), fmin)
    re_circuit = remake_circuit(cir_size, f, H, k)

    #println(re_circuit)=#
    #return  re_circuit

    #return false
    
end

function findopt_a(f::AbstractRFunc, H, k, flag=0)
    #ハッシュテーブル内にfがキーとして存在するかをチェック
    haskeyω(H, f) && return getindexω(H, f)

    #入力した可逆関数fのサイズがkより大きい場合の処理
    #サイズk以下の2つの関数に分けてそれぞれがハッシュテーブル内にキーとして存在したら回路を出力する

    for i in 1:k
        for g::RFunc in keysω(H, i)
            h = to_rfunc(f ∘ g)
            if haskeyω(H, h)
                c_g = getindexω(H, g)
                c_h = getindexω(H, h)
                #println(length(vcat(inv(c_g), c_h)))
                return vcat(inv(c_g), c_h)
            end
        end
    end

    if flag == 0
        lbmin = to_lb(f) #fの下界
        fmin = f
        f_s = 0

        for g::RFunc in keysω(H, k)
            h = to_rfunc(f ∘ g)
            lbh = to_lb(h) #hの下界
            if lbmin > lbh
                lbmin = lbh
                fmin = h
                f_s = g
            end
        end

        #circuit = optimize_A_star(getindexω(H, f_s, k), fmin)
        #extend = optimize_A_star(H, k, fmin)
        circuit = optimize_A_star(f_s, H, k, fmin)

        #println(length(circuit))
        return  circuit
    end

    return false
end

if findflag == 0
    findopt = findopt_n
elseif findflag == 1
    findopt = findopt_A
elseif findflag == 2
    findopt = findopt_a
end

#=function min_circuit(list)
    minsize = 65535
    mincir = 0
    for circuit in list
        size = length(circuit)
        if size < minsize
            minsize = size
            mincir = circuit
        end
    end

    return mincir
end=#

function remake_circuit(cir_size, f, H, k)
    circuit = 0
    op_size = 65535
    c_parts = cir_size ÷ k + 1
    count = 0

    flist = [f for f in keysω(H)]

    for i in 0:length(flist)^c_parts-1
        cir_num = convert_0n(i, c_parts, length(flist))
        c = getindexω(H, flist[Int(cir_num[1]+1)])
        for j in 2:c_parts
            joint_f = flist[Int(cir_num[j]+1)]
            c = vcat(c, getindexω(H, joint_f))       
        end
        
        if to_rfunc(c) == f && op_size > length(c)
            circuit = c
            op_size = length(c)
        end        
    end
            
    #=for ci in keysω(H)
        fc = 0
        if cir_size ÷ k + 1 == nflag
            getindexω(H, ci)
        else  
            fc = vcat(getindexω(H, ci), remake_circuit(cir_size, f, H, k, nflag+1))
            if nflag != 1
                return fc
            end
        end
        
        if f == to_rfunc(fc) && c_size >= length(fc)
            circuit = fc
            c_size = length(fc)
        end
    end=#

    #fkeys = [i for i in keysω(H)]
    #f_comb = [i for i in permutations(fkeys, c_parts)]

    
    return circuit
end

# 自然数Nをn進数に変換　何かと使えるかもしれないのでできたら別スクリプトにしてもいいかもしれない
# 返り値number_listはn進数を表現する配列 number_list[i]はn進数i桁目の値を表す
# あくまで回路を求めるために使いたい関数なので純粋にn進数に変換するための効率のいいコードではない
function convert_0n(N, c_parts, n)
    number_list = zeros(c_parts)
    #number_list = zeros(Int(ceil(log(n, N))))   
    for j in 1:c_parts
        if N < n
            number_list[j] = N
            break
        end

        number_list[j] = N % n
        N ÷= n
    end

    return number_list
end=#
