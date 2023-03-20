module TestBasics

# packages
using Test

# extarnal modules
include("basics.jl")

# method
function test()

    @testset "RFunc Operations" begin
        @testset "Composition" begin
            initialize_basics(2)
            @test to_rfunc(RFunc([0,1,2,3]) ∘ RFunc([0,1,2,3])) == RFunc([0,1,2,3])
            @test to_rfunc(RFunc([0,1,2,3]) ∘ RFunc([2,1,3,0])) == RFunc([2,1,3,0])
            @test to_rfunc(RFunc([2,1,3,0]) ∘ RFunc([0,1,2,3])) == RFunc([2,1,3,0])
            @test to_rfunc(RFunc([1,2,3,0]) ∘ RFunc([1,2,3,0])) == RFunc([2,3,0,1])
            @test to_rfunc(RFunc([0,3,2,1]) ∘ RFunc([2,1,3,0])) == RFunc([2,3,1,0])
            @test to_rfunc(RFunc([2,0,3,1]) ∘ RFunc([1,3,0,2])) == RFunc([0,1,2,3])
        end
        @testset "Inversion" begin
            initialize_basics(2)
            @test inv(RFunc([0,1,2,3])) == RFunc([0,1,2,3])
            @test inv(RFunc([1,3,0,2])) == RFunc([2,0,3,1])
            @test inv(RFunc([2,0,3,1])) == RFunc([1,3,0,2])
            @test inv(RFunc([0,3,2,1])) == RFunc([0,3,2,1])
            @test inv(RFunc([3,2,1,0])) == RFunc([3,2,1,0])
            @test inv(RFunc([2,3,1,0])) == RFunc([3,2,0,1])
            @test inv(RFunc([1,2,3,0])) == RFunc([3,0,1,2])
        end
    end
    @testset "Circuit Operations" begin
        @testset "RGate" begin
            initialize_basics(4)
            @test get_target(RGate(3, [])) == 3
            @test get_control(RGate(3, [])) == []
            @test get_target(RGate(0, [1,2])) == 0
            @test get_control(RGate(0, [1,2])) == [1,2]
            @test to_rfunc(RGate()) == RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]) # strange test?
            @test to_rfunc(RGate(3, [])) == RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7])
            @test to_rfunc(RGate(3, [2])) == RFunc([0,1,2,3,12,13,14,15,8,9,10,11,4,5,6,7])
            @test to_rfunc(RGate(3, [1,2])) == RFunc([0,1,2,3,4,5,14,15,8,9,10,11,12,13,6,7])
            @test to_rfunc(RGate(3, [0,1,2])) == RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7])
        end
        @testset "to_rfunc" begin
            initialize_basics(4)
            @test to_rfunc(RCircuit([])) == RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
            @test to_rfunc(RCircuit([RGate(3, [])])) == RFunc([8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7])
            @test to_rfunc(RCircuit([RGate(3, [2])])) == RFunc([0,1,2,3,12,13,14,15,8,9,10,11,4,5,6,7])
            @test to_rfunc(RCircuit([RGate(3, [1,2])])) == RFunc([0,1,2,3,4,5,14,15,8,9,10,11,12,13,6,7])
            @test to_rfunc(RCircuit([RGate(3, [0,1,2])])) == RFunc([0,1,2,3,4,5,6,15,8,9,10,11,12,13,14,7])
            @test to_rfunc(RCircuit([RGate(3, [1]), RGate(2, [0])])) == RFunc([0,5,10,15,4,1,14,11,8,13,2,7,12,9,6,3])
            @test to_rfunc(RCircuit([RGate(2, [0,1,3]), RGate(3, [])])) == RFunc([8,9,10,11,12,13,14,15,0,1,2,7,4,5,6,3])
            @test to_rfunc(RCircuit([RGate(3, [0,1,2]), RGate(2, [0,1,3])])) == RFunc([0,1,2,3,4,5,6,11,8,9,10,15,12,13,14,7])
            @test to_rfunc(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])])) == RFunc([8,9,10,11,13,12,15,14,0,1,7,6,5,4,2,3])
            @test to_rfunc(RCircuit([RGate(3, [0,1,2]), RGate(0, [1,2,3]), RGate(2, [0,1,3])])) == RFunc([0,1,2,3,4,5,6,14,8,9,10,15,12,13,11,7])
        end
        @testset "Inversion" begin
            initialize_basics(4)
            @test to_rfunc(inv(RCircuit([]))) == RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
            @test to_rfunc(inv(RCircuit([RGate(3, [1,2])]))) == RFunc([0,1,2,3,4,5,14,15,8,9,10,11,12,13,6,7])
            @test to_rfunc(inv(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]))) == RFunc([8,9,14,15,13,12,11,10,0,1,2,3,5,4,7,6])
            @test to_rfunc(inv(RCircuit([RGate(3, [0,1,2]), RGate(0, [1,2,3]), RGate(2, [0,1,3])]))) == RFunc([0,1,2,3,4,5,6,15,8,9,10,14,12,13,7,11])
        end
    end

end

end # module

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestBasics
    TestBasics.test()
end
