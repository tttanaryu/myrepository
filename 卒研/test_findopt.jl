module Testfindopt

using Test

include("findopt.jl")

function tests()
    @testset "BFS & findopt" begin
        @testset "BFS: n=3 k=4" begin
            #keys()の仕様で環境ごとにループで引く関数やゲートの順番が違う可能性がある(キーと値の関係が異なる場合がある)
            #したがってとりあえず辞書引きができることを確認　回路のサイズは環境で変わらないはずなのでサイズチェックをする
            initialize_all(3)
            H= BFS(4)

            #println(comp_flag)
            @test haskeyω(H, RFunc([0,1,2,3,4,5,6,7]))
            @test haskeyω(H, RFunc([0,1,2,3,5,4,7,6]))
            @test haskeyω(H, RFunc([0,1,2,3,4,5,7,6]))
            @test haskeyω(H, RFunc([1,2,3,0,5,6,7,4]))
            @test haskeyω(H, RFunc([6,7,4,5,2,3,0,1]))
            @test haskeyω(H, RFunc([0,1,2,5,6,7,4,3]))
            @test haskeyω(H, RFunc([0,1,2,3,5,6,7,4]))
            @test haskeyω(H, RFunc([1,0,3,2,5,6,7,4]))
            @test haskeyω(H, RFunc([0,1,6,7,3,2,5,4]))
            @test haskeyω(H, RFunc([0,1,7,2,3,6,4,5]))
            @test haskeyω(H, RFunc([7,6,5,4,3,2,1,0]))
            @test haskeyω(H, RFunc([0,1,4,5,6,7,3,2]))
            @test haskeyω(H, RFunc([0,1,3,4,6,7,5,2]))
            @test haskeyω(H, RFunc([1,2,3,0,7,4,5,6]))
            @test haskeyω(H, RFunc([0,5,3,6,4,1,2,7]))
            @test haskeyω(H, RFunc([3,2,4,1,7,6,0,5]))
            @test haskeyω(H, RFunc([0,1,4,5,3,2,7,6]))
            @test haskeyω(H, RFunc([1,3,6,4,5,7,2,0]))
            @test haskeyω(H, RFunc([0,1,3,2,7,5,6,4]))
            @test haskeyω(H, RFunc([0,1,3,6,2,7,4,5]))

            @test haskeyω(H, RFunc([0,1,2,3,4,5,6,7]), 0)
            @test haskeyω(H, RFunc([0,1,2,3,5,4,7,6]), 1)
            @test haskeyω(H, RFunc([0,1,2,3,4,5,7,6]), 1)
            @test haskeyω(H, RFunc([1,2,3,0,5,6,7,4]), 2)
            @test haskeyω(H, RFunc([6,7,4,5,2,3,0,1]), 2)
            @test haskeyω(H, RFunc([0,1,2,5,6,7,4,3]), 2)
            @test haskeyω(H, RFunc([0,1,2,3,5,6,7,4]), 2)
            @test haskeyω(H, RFunc([1,0,3,2,5,6,7,4]), 2)
            @test haskeyω(H, RFunc([0,1,6,7,3,2,5,4]), 3)
            @test haskeyω(H, RFunc([0,1,7,2,3,6,4,5]), 3)
            @test haskeyω(H, RFunc([7,6,5,4,3,2,1,0]), 3)
            @test haskeyω(H, RFunc([0,1,4,5,6,7,3,2]), 3)
            @test haskeyω(H, RFunc([0,1,3,4,6,7,5,2]), 3)
            @test haskeyω(H, RFunc([1,2,3,0,7,4,5,6]), 3)
            @test haskeyω(H, RFunc([0,5,3,6,4,1,2,7]), 3)
            @test haskeyω(H, RFunc([3,2,4,1,7,6,0,5]), 4)
            @test haskeyω(H, RFunc([0,1,4,5,3,2,7,6]), 4)
            @test haskeyω(H, RFunc([1,3,6,4,5,7,2,0]), 4)
            @test haskeyω(H, RFunc([0,1,3,2,7,5,6,4]), 4)
            @test haskeyω(H, RFunc([0,1,3,6,2,7,4,5]), 4)

        end


        @testset "findopt: n=4, k=2" begin
            #最適回路の出力　出力された回路が入力関数と等価関係であることをチェック
            initialize_all(4)
            H = BFS(2)

            @test RFunc([4,5,6,7,0,1,2,3,12,15,14,13,8,11,10,9]) == to_rfunc(findopt(RFunc([4,5,6,7,0,1,2,3,12,15,14,13,8,11,10,9]), H, 2))
            @test RFunc([5,0,7,2,1,4,3,6,13,8,15,10,9,12,11,14]) == to_rfunc(findopt(RFunc([5,0,7,2,1,4,3,6,13,8,15,10,9,12,11,14]), H, 2))
            @test RFunc([0,1,2,15,4,5,6,11,8,9,10,7,12,13,14,3]) == to_rfunc(findopt(RFunc([0,1,2,15,4,5,6,11,8,9,10,7,12,13,14,3]), H, 2))
            @test RFunc([0,1,2,3,4,5,7,6,12,13,15,14,8,9,10,11]) == to_rfunc(findopt(RFunc([0,1,2,3,4,5,7,6,12,13,15,14,8,9,10,11]), H, 2))
            @test RFunc([2,3,0,1,14,15,4,5,10,7,8,13,6,11,12,9]) == to_rfunc(findopt(RFunc([2,3,0,1,14,15,4,5,10,7,8,13,6,11,12,9]), H, 2))
            @test RFunc([0,1,2,3,13,12,15,14,8,9,10,11,7,6,5,4]) == to_rfunc(findopt(RFunc([0,1,2,3,13,12,15,14,8,9,10,11,7,6,5,4]), H, 2))
            @test RFunc([0,7,10,13,4,3,14,9,8,15,2,5,12,11,6,1]) == to_rfunc(findopt(RFunc([0,7,10,13,4,3,14,9,8,15,2,5,12,11,6,1]), H, 2))
        end

    end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .Testfindopt
    Testfindopt.tests()
end
