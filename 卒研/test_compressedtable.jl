module TestCompressedTable

# packages
using Test

# extarnal modules
include("compressedtable.jl")

function test()
    @testset "Naive" begin
        testmain(setindex!ω = setindex!0, getindexω = getindex0, haskeyω = haskey0, makehashtableω = makehashtable0, keysω = keys0)
    end
    @testset "Array" begin
        testmain(setindex!ω = setindex!1, getindexω = getindex1, haskeyω = haskey1, makehashtableω = makehashtable1, keysω = keys1)
    end
    @testset "α" begin
        testmain(setindex!ω = setindex!α, getindexω = getindexα, haskeyω = haskeyα, makehashtableω = makehashtableα, keysω = keysα)
    end
    @testset "β" begin
        testmain(setindex!ω = setindex!β, getindexω = getindexβ, haskeyω = haskeyβ, makehashtableω = makehashtableβ, keysω = keysβ)
    end
    @testset "αβ" begin
        testmain(setindex!ω = setindex!αβ, getindexω = getindexαβ, haskeyω = haskeyαβ, makehashtableω = makehashtableαβ, keysω = keysαβ)
    end
end

function testmain(;setindex!ω, getindexω, haskeyω, makehashtableω, keysω)
    initialize_basics(4)
    initialize_icequive(4)
    h = makehashtableω()
    # setindex!, getindex
    @test getindexω(h, RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])) == RCircuit([]) # 仕様により恒等関数はsetindex!できないので、getindexのみテストする。
    f = RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7])
    c = RCircuit([RGate(3, [])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,1,10,11,4,5,14,15,8,9,2,3,12,13,6,7])
    c = RCircuit([RGate(3, [1])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,1,2,3,12,13,14,15,8,9,10,11,4,5,6,7])
    c = RCircuit([RGate(3, [2])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,1,2,3,4,5,14,15,8,9,10,11,12,13,6,7])
    c = RCircuit([RGate(3, [1,2])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7])
    c = RCircuit([RGate(3, [0,1,2])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,5,2,7,4,1,6,3,8,13,10,15,12,9,14,11])
    c = RCircuit([RGate(2, [0])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,5,10,15,4,1,14,11,8,13,2,7,12,9,6,3])
    c = RCircuit([RGate(3, [1]), RGate(2, [0])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([8,9,10,11,12,13,14,15,0,1,2,7,4,5,6,3])
    c = RCircuit([RGate(2, [0,1,3]), RGate(3, [])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([0,1,2,3,4,5,6,11,8,9,10,15,12,13,14,7])
    c = RCircuit([RGate(3, [0,1,2]), RGate(2, [0,1,3])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([8,9,10,11,12,13,14,15,0,1,6,7,4,5,2,3])
    c = RCircuit([RGate(2, [1,3]), RGate(3, [])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f = RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3])
    c = RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    f= RFunc([0,1,2,3,4,5,6,14,8,9,10,15,12,13,11,7])
    c = RCircuit([RGate(3, [0,1,2]), RGate(0, [1,2,3]), RGate(2, [0,1,3])])
    setindex!ω(h, f, c); @test getindexω(h, f) == c
    @test getindexω(h, f, 3) == c
    # haskey
    @test !(haskeyω(h, RFunc([3,1,4,6,12,9,8,2,7,5,11,13,15,0,10,14]))) # 未登録の場合のテスト
    @test haskeyω(h, RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]))
    @test haskeyω(h, RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7]))
    @test haskeyω(h, RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7]))
    @test haskeyω(h, RFunc([0,5,2,7,4,1,6,3,8,13,10,15,12,9,14,11]))
    @test haskeyω(h, RFunc([0,5,10,15,4,1,14,11,8,13,2,7,12,9,6,3]))
    @test haskeyω(h, RFunc([0,1,2,3,4,5,6,11,8,9,10,15,12,13,14,7]))
    @test haskeyω(h, RFunc([8,9,10,11,12,13,14,15,0,1,6,7,4,5,2,3]))
    @test haskeyω(h, RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3]))
    @test haskeyω(h, RFunc([0,1,2,3,4,5,6,14,8,9,10,15,12,13,11,7]))
    @test haskeyω(h, RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),0)
    @test haskeyω(h, RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7]),1)
    @test haskeyω(h, RFunc([8,9,10,11,12,13,14,15,0,1,6,7,4,5,2,3]),2)
    @test haskeyω(h, RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3]),3)
    # keys
    @test RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) in keysω(h)
    @test RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7]) in keysω(h)
    @test RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7]) in keysω(h)
    @test RFunc([0,5,2,7,4,1,6,3,8,13,10,15,12,9,14,11]) in keysω(h)
    @test RFunc([0,5,10,15,4,1,14,11,8,13,2,7,12,9,6,3]) in keysω(h)
    @test RFunc([0,1,2,3,4,5,6,11,8,9,10,15,12,13,14,7]) in keysω(h)
    @test RFunc([8,9,10,11,12,13,14,15,0,1,6,7,4,5,2,3]) in keysω(h)
    @test RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3]) in keysω(h)
    @test RFunc([0,1,2,3,4,5,6,14,8,9,10,15,12,13,11,7]) in keysω(h)
    @test RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) in keysω(h,0)
    @test RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7]) in keysω(h,1)
    @test RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7]) in keysω(h,1)
    @test RFunc([0,5,2,7,4,1,6,3,8,13,10,15,12,9,14,11]) in keysω(h,1)
    @test RFunc([0,5,10,15,4,1,14,11,8,13,2,7,12,9,6,3]) in keysω(h,2)
    @test RFunc([0,1,2,3,4,5,6,11,8,9,10,15,12,13,14,7]) in keysω(h,2)
    @test RFunc([8,9,10,11,12,13,14,15,0,1,6,7,4,5,2,3]) in keysω(h,2)
    @test RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3]) in keysω(h,3)
    @test RFunc([0,1,2,3,4,5,6,14,8,9,10,15,12,13,11,7]) in keysω(h,3)
end

end # module

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestCompressedTable
    TestCompressedTable.test()
end
