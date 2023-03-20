module TestIcequive

# packages
using Test

# extarnal modules
include("icequive.jl")

# method
function test()

    @testset "Conjugation" begin
        @testset "Conjugation: N=3" begin
            initialize_icequive(3)
            @test conjugation_class(RFunc([0,1,2,3,4,5,6,7])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7]]))
            @test conjugation_class(RFunc([7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[7,6,5,4,3,2,1,0]]))
            @test conjugation_class(RFunc([0,1,2,4,3,5,6,7])) == Set(Vector{RFunc}([[0,1,2,4,3,5,6,7],[0,1,5,3,4,2,6,7],[0,6,2,3,4,5,1,7]]))
            @test conjugation_class(RFunc([7,1,5,4,3,2,6,0])) == Set(Vector{RFunc}([[7,1,5,4,3,2,6,0],[7,6,2,4,3,5,1,0],[7,6,5,3,4,2,1,0]]))
            @test conjugation_class(RFunc([3,7,4,2,0,5,1,6])) == Set(Vector{RFunc}([[3,7,4,2,0,5,1,6],[5,7,0,3,2,4,1,6],[3,4,7,1,0,2,6,5],[6,0,7,3,1,2,4,5],[5,2,0,4,7,1,6,3],[6,0,1,4,7,5,2,3]]))
            @test conjugation_class(RFunc([6,2,0,4,3,5,7,1])) == Set(Vector{RFunc}([[6,2,0,4,3,5,7,1],[6,4,5,3,0,2,7,1],[5,0,1,4,3,7,6,2],[5,6,4,3,0,7,1,2],[3,0,5,7,1,2,6,4],[3,6,0,7,2,5,1,4]]))
            @test conjugation_class(RFunc([3,5,7,1,4,0,2,6])) == Set(Vector{RFunc}([[3,5,7,1,4,0,2,6],[5,3,2,0,7,1,4,6],[3,7,6,2,4,1,0,5],[6,1,3,0,7,4,2,5],[5,7,2,1,6,4,0,3],[6,1,7,2,5,0,4,3]]))
            @test conjugation_class(RFunc([7,1,4,3,2,6,5,0])) == Set(Vector{RFunc}([[7,1,4,3,2,6,5,0],[7,1,4,6,2,5,3,0],[7,4,2,3,1,6,5,0],[7,4,2,5,1,3,6,0],[7,2,1,6,4,5,3,0],[7,2,1,5,4,3,6,0]]))
            @test conjugation_class(RFunc([3,2,7,0,1,6,5,4])) == Set(Vector{RFunc}([[3,2,7,0,1,6,5,4],[5,4,1,6,7,0,3,2],[3,7,1,0,2,6,5,4],[6,2,4,5,7,3,0,1],[5,7,4,6,1,0,3,2],[6,4,7,5,2,3,0,1]]))
            @test conjugation_class(RFunc([6,5,0,7,3,4,2,1])) == Set(Vector{RFunc}([[6,5,0,7,3,4,2,1],[6,3,5,2,0,7,4,1],[5,0,6,7,3,1,4,2],[5,6,3,1,0,4,7,2],[3,0,5,1,6,7,2,4],[3,6,0,2,5,1,7,4]]))
            # Check type
            @test typeof(conjugation_class(RFunc([6,5,0,7,3,4,2,1]))) == Set{RFunc}
            @test typeof(conjugation_class([6,5,0,7,3,4,2,1])) == Set{Array{Int,1}}
        end
        @testset "Conjugation: N=4" begin
            initialize_icequive(4)
            @test conjugation_class(RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]))
            @test conjugation_class(RFunc([15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]]))
            @test conjugation_class(RFunc([0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15],[0,1,13,3,4,5,6,7,8,9,10,11,12,2,14,15],[0,1,2,3,11,5,6,7,8,9,10,4,12,13,14,15],[0,1,2,3,4,5,6,8,7,9,10,11,12,13,14,15]]))
            @test conjugation_class(RFunc([15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,11,10,9,7,8,6,5,4,3,2,1,0],[15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0],[15,1,13,12,11,10,9,8,7,6,5,4,3,2,14,0],[15,14,2,12,11,10,9,8,7,6,5,4,3,13,1,0]]))
            @test conjugation_class(RFunc([15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0],[15,14,2,12,11,10,9,7,8,6,5,4,3,13,1,0],[15,1,13,12,11,10,9,7,8,6,5,4,3,2,14,0],[15,14,2,12,4,10,9,8,7,6,5,11,3,13,1,0],[15,1,13,12,4,10,9,8,7,6,5,11,3,2,14,0],[15,1,2,12,11,10,9,8,7,6,5,4,3,13,14,0]]))
            @test conjugation_class(RFunc([0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],[0,14,2,3,4,10,6,7,8,9,5,11,12,13,1,15],[0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],[0,1,13,3,4,10,6,7,8,9,5,11,12,2,14,15],[0,1,13,3,4,5,9,7,8,6,10,11,12,2,14,15],[0,1,13,12,4,5,6,7,8,9,10,11,3,2,14,15],[0,1,2,12,11,5,6,7,8,9,10,4,3,13,14,15],[0,1,2,3,11,5,9,7,8,6,10,4,12,13,14,15],[0,1,2,3,11,10,6,7,8,9,5,4,12,13,14,15],[0,1,2,12,4,5,6,8,7,9,10,11,3,13,14,15],[0,1,2,3,4,10,6,8,7,9,5,11,12,13,14,15],[0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15]]))
            @test conjugation_class(RFunc([0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15])) == Set(Vector{RFunc}([[0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],[0,14,2,3,4,10,6,7,8,9,5,11,12,13,1,15],[0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],[0,1,13,12,4,5,6,7,8,9,10,11,3,2,14,15],[0,1,13,3,4,5,9,7,8,6,10,11,12,2,14,15],[0,1,13,3,4,10,6,7,8,9,5,11,12,2,14,15],[0,1,2,3,11,10,6,7,8,9,5,4,12,13,14,15],[0,1,2,3,11,5,9,7,8,6,10,4,12,13,14,15],[0,1,2,12,11,5,6,7,8,9,10,4,3,13,14,15],[0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15],[0,1,2,3,4,10,6,8,7,9,5,11,12,13,14,15],[0,1,2,12,4,5,6,8,7,9,10,11,3,13,14,15]]))
            @test conjugation_class(RFunc([2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11])) == Set(Vector{RFunc}([[2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11],[2,13,8,11,1,14,3,5,9,10,15,12,0,4,6,7],[4,11,3,6,2,7,15,10,1,14,0,8,5,9,12,13],[4,11,1,14,8,13,5,3,9,12,0,2,15,10,6,7],[8,7,3,10,1,14,0,4,2,11,15,6,9,5,12,13],[8,7,1,14,5,12,0,2,4,13,9,3,15,6,10,11],[1,4,14,7,6,15,5,12,2,3,13,10,0,9,8,11],[1,8,14,11,2,3,13,6,10,15,9,12,0,5,4,7],[4,3,11,5,1,15,7,9,2,0,13,8,6,12,10,14],[4,2,11,13,8,6,14,3,10,0,12,1,15,5,9,7],[8,3,7,9,2,0,13,4,1,15,11,5,10,12,6,14],[8,2,7,13,6,0,12,1,4,10,14,3,15,9,5,11],[1,2,6,15,14,7,3,10,4,5,0,9,11,12,8,13],[1,8,4,5,14,13,11,6,12,15,0,3,9,10,2,7],[2,5,1,15,13,3,7,9,4,0,6,10,11,8,12,14],[2,4,8,6,13,11,14,5,12,0,15,3,10,1,9,7],[8,5,4,0,7,9,11,2,1,15,12,10,13,3,6,14],[8,4,6,0,7,11,10,1,2,12,15,9,14,5,3,13],[1,2,10,15,8,9,0,5,14,11,3,6,7,12,4,13],[1,4,8,9,12,15,0,3,14,13,7,10,5,6,2,11],[2,9,1,15,8,0,10,6,13,3,11,5,7,4,12,14],[2,8,4,10,12,0,15,3,13,7,14,9,6,1,5,11],[4,9,8,0,1,15,12,6,11,5,7,2,13,3,10,14],[4,8,10,0,2,12,15,5,11,7,6,1,14,9,3,13]]))
            @test conjugation_class(RFunc([11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9])) == Set(Vector{RFunc}([[11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9],[7,6,2,9,3,13,1,14,4,15,10,8,11,12,0,5],[13,12,8,15,4,3,6,2,5,11,7,10,1,14,0,9],[7,6,5,11,4,9,1,14,2,15,13,10,12,8,0,3],[13,12,4,15,9,7,11,6,8,3,10,2,1,14,0,5],[11,10,9,7,2,15,13,6,8,5,1,14,12,4,0,3],[11,1,9,6,8,5,15,4,3,2,14,13,7,0,12,10],[7,1,5,10,3,2,14,13,4,9,15,8,11,0,12,6],[14,8,12,15,4,5,3,1,6,7,11,9,2,0,13,10],[7,6,5,11,4,2,10,13,1,14,15,9,12,0,8,3],[14,4,12,15,10,11,7,5,8,9,3,1,2,0,13,6],[11,10,9,7,1,14,15,5,8,2,6,13,12,0,4,3],[13,1,8,3,9,6,15,2,5,4,7,0,14,11,10,12],[7,1,5,4,3,12,14,11,2,9,13,0,15,8,10,6],[14,8,2,3,10,15,5,1,6,7,4,0,13,9,11,12],[7,6,2,4,3,13,12,11,1,14,10,0,15,9,8,5],[14,2,12,13,10,15,7,3,8,9,4,0,5,1,11,6],[13,12,1,14,9,7,15,3,8,4,10,0,6,11,2,5],[13,1,4,3,9,8,11,0,5,10,15,2,14,7,6,12],[11,1,9,8,2,5,13,0,3,12,14,7,15,4,6,10],[14,4,2,3,10,11,8,0,6,15,9,1,13,5,7,12],[11,10,2,8,1,14,6,0,3,13,12,7,15,5,4,9],[14,2,12,13,4,5,8,0,6,15,11,3,9,1,7,10],[13,12,1,14,4,8,6,0,5,11,15,3,10,7,2,9]]))
            @test conjugation_class(RFunc([13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12])) == Set(Vector{RFunc}([[13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12],[13,9,4,3,8,1,10,2,6,15,5,14,0,11,7,12],[11,3,12,15,8,5,9,14,2,1,0,7,6,4,13,10],[11,9,8,1,2,5,12,4,6,15,0,13,3,14,7,10],[7,3,12,15,2,1,0,11,4,9,5,14,10,8,13,6],[7,5,4,1,10,15,0,13,2,9,12,8,3,14,11,6],[14,8,6,3,9,10,15,13,4,5,2,1,0,11,7,12],[14,4,10,3,8,9,2,1,5,6,15,13,0,7,11,12],[11,12,3,15,8,10,6,13,1,0,2,7,5,14,4,9],[11,8,10,2,1,12,6,4,5,0,15,14,3,7,13,9],[7,12,3,15,1,0,2,11,4,6,10,13,9,14,8,5],[7,4,6,2,9,0,15,14,1,12,10,8,3,11,13,5],[14,8,9,12,6,5,15,11,2,3,0,13,4,1,7,10],[14,2,8,9,12,5,4,1,3,6,0,7,15,11,13,10],[13,10,8,12,5,15,6,11,1,0,3,14,4,7,2,9],[13,8,1,10,12,4,6,2,3,0,5,7,15,14,11,9],[7,10,1,0,5,15,4,13,2,6,9,14,12,11,8,3],[7,2,9,0,6,4,15,14,1,10,5,13,12,8,11,3],[14,4,5,12,2,3,0,13,10,9,15,7,8,1,11,6],[14,2,4,5,3,10,0,11,12,9,8,1,15,7,13,6],[13,6,4,12,1,0,3,14,9,15,10,7,8,11,2,5],[13,4,1,6,3,0,9,11,12,8,10,2,15,14,7,5],[11,6,1,0,2,10,5,14,9,15,8,13,12,7,4,3],[11,2,5,0,1,6,9,13,10,8,15,14,12,4,7,3]]))
            @test conjugation_class(RFunc([4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12])) == Set(Vector{RFunc}([[4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12],[8,1,9,15,2,5,4,13,10,0,6,11,3,7,14,12],[2,1,6,0,3,15,12,7,4,9,5,13,8,11,14,10],[8,1,4,3,9,15,2,11,12,0,5,7,6,13,14,10],[2,1,10,0,8,5,9,13,3,15,12,11,4,7,14,6],[4,1,8,3,12,0,9,11,5,15,2,7,10,13,14,6],[4,6,2,15,5,9,0,7,1,8,10,14,3,13,11,12],[8,10,2,15,1,4,6,14,9,5,0,11,3,13,7,12],[1,5,2,0,3,12,15,7,4,6,10,14,8,13,11,9],[8,4,2,3,10,1,15,11,12,6,0,7,5,13,14,9],[1,9,2,0,8,10,6,14,3,12,15,11,4,13,7,5],[4,8,2,3,12,10,0,11,6,1,15,7,9,13,14,5],[2,6,3,9,4,15,0,7,1,8,5,11,12,14,13,10],[8,12,1,2,4,15,6,14,9,3,5,11,0,13,7,10],[1,3,5,10,4,0,15,7,2,6,8,11,12,14,13,9],[8,2,12,1,4,5,15,13,10,6,3,11,0,7,14,9],[1,9,8,12,4,0,6,14,5,10,2,11,15,13,7,3],[2,8,10,12,4,5,0,13,6,1,9,11,15,7,14,3],[2,10,3,5,1,4,9,7,8,15,0,11,12,14,13,6],[4,12,1,2,5,3,9,7,8,15,10,14,0,13,11,6],[1,3,9,6,2,10,4,7,8,0,15,11,12,14,13,5],[4,2,12,1,6,10,3,7,8,9,15,13,0,11,14,5],[1,5,4,12,9,6,2,7,8,0,10,14,15,13,11,3],[2,4,6,12,10,1,5,7,8,9,0,13,15,11,14,3]]))
            @test conjugation_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set(Vector{RFunc}([[2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6],[2,15,6,8,4,0,14,1,11,7,12,5,13,9,3,10],[4,15,7,13,12,2,10,9,8,0,11,3,14,1,5,6],[4,15,2,0,6,8,14,1,13,7,11,9,10,3,5,12],[8,15,11,13,4,0,7,3,12,2,6,5,14,1,9,10],[8,15,2,0,13,11,7,5,10,4,14,1,6,3,9,12],[1,9,15,4,7,12,11,10,8,13,0,2,14,3,6,5],[1,5,15,8,4,13,0,2,11,12,7,6,14,3,10,9],[4,7,15,14,12,9,1,10,8,11,0,3,13,6,2,5],[4,1,15,0,5,13,8,2,14,11,7,10,9,6,3,12],[8,11,15,14,4,7,0,3,12,5,1,6,13,10,2,9],[8,1,15,0,14,7,11,6,9,13,4,2,5,10,3,12],[1,9,7,10,15,2,13,12,8,11,14,5,0,4,6,3],[1,3,2,11,15,8,0,4,13,10,14,5,7,6,12,9],[2,7,10,9,15,14,1,12,8,13,11,6,0,5,4,3],[2,1,3,11,15,0,8,4,14,13,9,6,7,12,5,10],[8,13,2,7,15,14,0,5,10,3,11,12,1,6,4,9],[8,1,14,7,15,0,13,6,9,11,3,12,2,4,5,10],[1,5,11,6,4,7,14,9,15,2,13,12,0,8,10,3],[1,3,2,7,13,6,14,9,15,4,0,8,11,10,12,5],[2,11,6,5,4,13,7,10,15,14,1,12,0,9,8,3],[2,1,3,7,14,13,5,10,15,0,4,8,11,12,9,6],[4,13,2,11,6,3,7,12,15,14,0,9,1,10,8,5],[4,1,14,11,5,7,3,12,15,0,13,10,2,8,9,6]]))
            # Check type
            @test typeof(conjugation_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]))) == Set{RFunc}
            @test typeof(conjugation_class([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set{Array{Int,1}}
        end
    end

    @testset "Inversion" begin
        @testset "Inversion: N=3" begin
            initialize_icequive(3)
            @test inversion_class(RFunc([0,1,2,3,4,5,6,7])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7]]))
            @test inversion_class(RFunc([7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[7,6,5,4,3,2,1,0]]))
            @test inversion_class(RFunc([0,1,2,4,3,5,6,7])) == Set(Vector{RFunc}([[0,1,2,4,3,5,6,7]]))
            @test inversion_class(RFunc([7,1,5,4,3,2,6,0])) == Set(Vector{RFunc}([[7,1,5,4,3,2,6,0]]))
            @test inversion_class(RFunc([3,7,4,2,0,5,1,6])) == Set(Vector{RFunc}([[3,7,4,2,0,5,1,6],[4,6,3,0,2,5,7,1]]))
            @test inversion_class(RFunc([6,2,0,4,3,5,7,1])) == Set(Vector{RFunc}([[6,2,0,4,3,5,7,1],[2,7,1,4,3,5,0,6]]))
            @test inversion_class(RFunc([3,5,7,1,4,0,2,6])) == Set(Vector{RFunc}([[3,5,7,1,4,0,2,6],[5,3,6,0,4,1,7,2]]))
            @test inversion_class(RFunc([7,1,4,3,2,6,5,0])) == Set(Vector{RFunc}([[7,1,4,3,2,6,5,0]]))
            @test inversion_class(RFunc([3,2,7,0,1,6,5,4])) == Set(Vector{RFunc}([[3,2,7,0,1,6,5,4],[3,4,1,0,7,6,5,2]]))
            @test inversion_class(RFunc([6,5,0,7,3,4,2,1])) == Set(Vector{RFunc}([[6,5,0,7,3,4,2,1],[2,7,6,4,5,1,0,3]]))
            # Check type
            @test typeof(inversion_class(RFunc([6,5,0,7,3,4,2,1]))) == Set{RFunc}
            @test typeof(inversion_class([6,5,0,7,3,4,2,1])) == Set{Array{Int,1}}
        end
        @testset "Inversion: N=4" begin
            initialize_icequive(4)
            @test inversion_class(RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]))
            @test inversion_class(RFunc([15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]]))
            @test inversion_class(RFunc([0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15]]))
            @test inversion_class(RFunc([15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0]]))
            @test inversion_class(RFunc([15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0]]))
            @test inversion_class(RFunc([0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15]]))
            @test inversion_class(RFunc([0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15])) == Set(Vector{RFunc}([[0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15]]))
            @test inversion_class(RFunc([2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11])) == Set(Vector{RFunc}([[2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11],[12,8,0,10,2,4,5,3,13,11,14,15,7,1,9,6]]))
            @test inversion_class(RFunc([11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9])) == Set(Vector{RFunc}([[11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9],[14,10,2,8,7,3,6,12,4,15,1,0,13,9,11,5]]))
            @test inversion_class(RFunc([13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12])) == Set(Vector{RFunc}([[13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12],[12,9,11,3,8,1,10,13,2,6,4,14,15,0,7,5]]))
            @test inversion_class(RFunc([4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12])) == Set(Vector{RFunc}([[4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12],[5,1,8,12,0,2,4,7,10,9,6,13,15,11,14,3]]))
            @test inversion_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set(Vector{RFunc}([[2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6],[9,11,0,14,3,13,15,4,8,7,2,5,6,12,10,1]]))
            # Check type
            @test typeof(inversion_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]))) == Set{RFunc}
            @test typeof(inversion_class([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set{Array{Int,1}}
        end
    end

    @testset "IC Class" begin
        @testset "IC Class: N=3" begin
            initialize_icequive(3)
            @test ic_class(RFunc([0,1,2,3,4,5,6,7])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7]]))
            @test ic_class(RFunc([7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[7,6,5,4,3,2,1,0]]))
            @test ic_class(RFunc([0,1,2,4,3,5,6,7])) == Set(Vector{RFunc}([[0,1,2,4,3,5,6,7],[0,1,5,3,4,2,6,7],[0,6,2,3,4,5,1,7]]))
            @test ic_class(RFunc([7,1,5,4,3,2,6,0])) == Set(Vector{RFunc}([[7,1,5,4,3,2,6,0],[7,6,2,4,3,5,1,0],[7,6,5,3,4,2,1,0]]))
            @test ic_class(RFunc([3,7,4,2,0,5,1,6])) == Set(Vector{RFunc}([[3,7,4,2,0,5,1,6],[4,6,3,0,2,5,7,1],[5,7,0,3,2,4,1,6],[2,6,4,3,5,0,7,1],[3,4,7,1,0,2,6,5],[4,3,5,0,1,7,6,2],[6,0,7,3,1,2,4,5],[1,4,5,3,6,7,0,2],[5,2,0,4,7,1,6,3],[2,5,1,7,3,0,6,4],[6,0,1,4,7,5,2,3],[1,2,6,7,3,5,0,4]]))
            @test ic_class(RFunc([6,2,0,4,3,5,7,1])) == Set(Vector{RFunc}([[6,2,0,4,3,5,7,1],[2,7,1,4,3,5,0,6],[6,4,5,3,0,2,7,1],[4,7,5,3,1,2,0,6],[5,0,1,4,3,7,6,2],[1,2,7,4,3,0,6,5],[5,6,4,3,0,7,1,2],[4,6,7,3,2,0,1,5],[3,0,5,7,1,2,6,4],[1,4,5,0,7,2,6,3],[3,6,0,7,2,5,1,4],[2,6,4,0,7,5,1,3]]))
            @test ic_class(RFunc([3,5,7,1,4,0,2,6])) == Set(Vector{RFunc}([[3,5,7,1,4,0,2,6],[5,3,6,0,4,1,7,2],[5,3,2,0,7,1,4,6],[3,5,2,1,6,0,7,4],[3,7,6,2,4,1,0,5],[6,5,3,0,4,7,2,1],[6,1,3,0,7,4,2,5],[3,1,6,2,5,7,0,4],[5,7,2,1,6,4,0,3],[6,3,2,7,5,0,4,1],[6,1,7,2,5,0,4,3],[5,1,3,7,6,4,0,2]]))
            @test ic_class(RFunc([7,1,4,3,2,6,5,0])) == Set(Vector{RFunc}([[7,1,4,3,2,6,5,0],[7,1,4,6,2,5,3,0],[7,4,2,3,1,6,5,0],[7,4,2,5,1,3,6,0],[7,2,1,6,4,5,3,0],[7,2,1,5,4,3,6,0]]))
            @test ic_class(RFunc([3,2,7,0,1,6,5,4])) == Set(Vector{RFunc}([[3,2,7,0,1,6,5,4],[3,4,1,0,7,6,5,2],[5,4,1,6,7,0,3,2],[5,2,7,6,1,0,3,4],[3,7,1,0,2,6,5,4],[3,2,4,0,7,6,5,1],[6,2,4,5,7,3,0,1],[6,7,1,5,2,3,0,4],[5,7,4,6,1,0,3,2],[5,4,7,6,2,0,3,1],[6,4,7,5,2,3,0,1],[6,7,4,5,1,3,0,2]]))
            @test ic_class(RFunc([6,5,0,7,3,4,2,1])) == Set(Vector{RFunc}([[6,5,0,7,3,4,2,1],[2,7,6,4,5,1,0,3],[6,3,5,2,0,7,4,1],[4,7,3,1,6,2,0,5],[5,0,6,7,3,1,4,2],[1,5,7,4,6,0,2,3],[5,6,3,1,0,4,7,2],[4,3,7,2,5,0,1,6],[3,0,5,1,6,7,2,4],[1,3,6,0,7,2,4,5],[3,6,0,2,5,1,7,4],[2,5,3,0,7,4,1,6]]))
            # Check type
            @test typeof(ic_class(RFunc([6,5,0,7,3,4,2,1]))) == Set{RFunc}
            @test typeof(ic_class([6,5,0,7,3,4,2,1])) == Set{Array{Int,1}}
        end
        @testset "IC Class: N=4" begin
            initialize_icequive(4)
            @test ic_class(RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])) == Set(Vector{RFunc}([[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]]))
            @test ic_class(RFunc([15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]]))
            @test ic_class(RFunc([0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15],[0,1,13,3,4,5,6,7,8,9,10,11,12,2,14,15],[0,1,2,3,11,5,6,7,8,9,10,4,12,13,14,15],[0,1,2,3,4,5,6,8,7,9,10,11,12,13,14,15]]))
            @test ic_class(RFunc([15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,11,10,9,7,8,6,5,4,3,2,1,0],[15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0],[15,1,13,12,11,10,9,8,7,6,5,4,3,2,14,0],[15,14,2,12,11,10,9,8,7,6,5,4,3,13,1,0]]))
            @test ic_class(RFunc([15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0])) == Set(Vector{RFunc}([[15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0],[15,14,2,12,11,10,9,7,8,6,5,4,3,13,1,0],[15,1,13,12,11,10,9,7,8,6,5,4,3,2,14,0],[15,14,2,12,4,10,9,8,7,6,5,11,3,13,1,0],[15,1,13,12,4,10,9,8,7,6,5,11,3,2,14,0],[15,1,2,12,11,10,9,8,7,6,5,4,3,13,14,0]]))
            @test ic_class(RFunc([0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15])) == Set(Vector{RFunc}([[0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],[0,14,2,3,4,10,6,7,8,9,5,11,12,13,1,15],[0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],[0,1,13,3,4,10,6,7,8,9,5,11,12,2,14,15],[0,1,13,3,4,5,9,7,8,6,10,11,12,2,14,15],[0,1,13,12,4,5,6,7,8,9,10,11,3,2,14,15],[0,1,2,12,11,5,6,7,8,9,10,4,3,13,14,15],[0,1,2,3,11,5,9,7,8,6,10,4,12,13,14,15],[0,1,2,3,11,10,6,7,8,9,5,4,12,13,14,15],[0,1,2,12,4,5,6,8,7,9,10,11,3,13,14,15],[0,1,2,3,4,10,6,8,7,9,5,11,12,13,14,15],[0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15]]))
            @test ic_class(RFunc([0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15])) == Set(Vector{RFunc}([[0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],[0,14,2,3,4,10,6,7,8,9,5,11,12,13,1,15],[0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],[0,1,13,12,4,5,6,7,8,9,10,11,3,2,14,15],[0,1,13,3,4,5,9,7,8,6,10,11,12,2,14,15],[0,1,13,3,4,10,6,7,8,9,5,11,12,2,14,15],[0,1,2,3,11,10,6,7,8,9,5,4,12,13,14,15],[0,1,2,3,11,5,9,7,8,6,10,4,12,13,14,15],[0,1,2,12,11,5,6,7,8,9,10,4,3,13,14,15],[0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15],[0,1,2,3,4,10,6,8,7,9,5,11,12,13,14,15],[0,1,2,12,4,5,6,8,7,9,10,11,3,13,14,15]]))
            @test ic_class(RFunc([2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11])) == Set(Vector{RFunc}([[2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11],[12,8,0,10,2,4,5,3,13,11,14,15,7,1,9,6],[2,13,8,11,1,14,3,5,9,10,15,12,0,4,6,7],[12,4,0,6,13,7,14,15,2,8,9,3,11,1,5,10],[4,11,3,6,2,7,15,10,1,14,0,8,5,9,12,13],[10,8,4,2,0,12,3,5,11,13,7,1,14,15,9,6],[4,11,1,14,8,13,5,3,9,12,0,2,15,10,6,7],[10,2,11,7,0,6,14,15,4,8,13,1,9,5,3,12],[8,7,3,10,1,14,0,4,2,11,15,6,9,5,12,13],[6,4,8,2,7,13,11,1,0,12,3,9,14,15,5,10],[8,7,1,14,5,12,0,2,4,13,9,3,15,6,10,11],[6,2,7,11,8,4,13,1,0,10,14,15,5,9,3,12],[1,4,14,7,6,15,5,12,2,3,13,10,0,9,8,11],[12,0,8,9,1,6,4,3,14,13,11,15,7,10,2,5],[1,8,14,11,2,3,13,6,10,15,9,12,0,5,4,7],[12,0,4,5,14,13,7,15,1,10,8,3,11,6,2,9],[4,3,11,5,1,15,7,9,2,0,13,8,6,12,10,14],[9,4,8,1,0,3,12,6,11,7,14,2,13,10,15,5],[4,2,11,13,8,6,14,3,10,0,12,1,15,5,9,7],[9,11,1,7,0,13,5,15,4,14,8,2,10,3,6,12],[8,3,7,9,2,0,13,4,1,15,11,5,10,12,6,14],[5,8,4,1,7,11,14,2,0,3,12,10,13,6,15,9],[8,2,7,13,6,0,12,1,4,10,14,3,15,9,5,11],[5,7,1,11,8,14,4,2,0,13,9,15,6,3,10,12],[1,2,6,15,14,7,3,10,4,5,0,9,11,12,8,13],[10,0,1,6,8,9,2,5,14,11,7,12,13,15,4,3],[1,8,4,5,14,13,11,6,12,15,0,3,9,10,2,7],[10,0,14,11,2,3,7,15,1,12,13,6,8,5,4,9],[2,5,1,15,13,3,7,9,4,0,6,10,11,8,12,14],[9,2,0,5,8,1,10,6,13,7,11,12,14,4,15,3],[2,4,8,6,13,11,14,5,12,0,15,3,10,1,9,7],[9,13,0,11,1,7,3,15,2,14,12,5,8,4,6,10],[8,5,4,0,7,9,11,2,1,15,12,10,13,3,6,14],[3,8,7,13,2,1,14,4,0,5,11,6,10,12,15,9],[8,4,6,0,7,11,10,1,2,12,15,9,14,5,3,13],[3,7,8,14,1,13,2,4,0,11,6,5,9,15,12,10],[1,2,10,15,8,9,0,5,14,11,3,6,7,12,4,13],[6,0,1,10,14,7,11,12,4,5,2,9,13,15,8,3],[1,4,8,9,12,15,0,3,14,13,7,10,5,6,2,11],[6,0,14,7,1,12,13,10,2,3,11,15,4,9,8,5],[2,9,1,15,8,0,10,6,13,3,11,5,7,4,12,14],[5,2,0,9,13,11,7,12,4,1,6,10,14,8,15,3],[2,8,4,10,12,0,15,3,13,7,14,9,6,1,5,11],[5,13,0,7,2,14,12,9,1,11,3,15,4,8,10,6],[4,9,8,0,1,15,12,6,11,5,7,2,13,3,10,14],[3,4,11,13,0,9,7,10,2,1,14,8,6,12,15,5],[4,8,10,0,2,12,15,5,11,7,6,1,14,9,3,13],[3,11,4,14,0,7,10,9,1,13,2,8,5,15,12,6]]))
            @test ic_class(RFunc([11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9])) == Set(Vector{RFunc}([[11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9],[14,10,2,8,7,3,6,12,4,15,1,0,13,9,11,5],[7,6,2,9,3,13,1,14,4,15,10,8,11,12,0,5],[14,6,2,4,8,15,1,0,11,3,10,12,13,5,7,9],[13,12,8,15,4,3,6,2,5,11,7,10,1,14,0,9],[14,12,7,5,4,8,6,10,2,15,11,9,1,0,13,3],[7,6,5,11,4,9,1,14,2,15,13,10,12,8,0,3],[14,6,8,15,4,2,1,0,13,5,11,3,12,10,7,9],[13,12,4,15,9,7,11,6,8,3,10,2,1,14,0,5],[14,12,11,9,2,15,7,5,8,4,10,6,1,0,13,3],[11,10,9,7,2,15,13,6,8,5,1,14,12,4,0,3],[14,10,4,15,13,9,7,3,8,2,1,0,12,6,11,5],[11,1,9,6,8,5,15,4,3,2,14,13,7,0,12,10],[13,1,9,8,7,5,3,12,4,2,15,0,14,11,10,6],[7,1,5,10,3,2,14,13,4,9,15,8,11,0,12,6],[13,1,5,4,8,2,15,0,11,9,3,12,14,7,6,10],[14,8,12,15,4,5,3,1,6,7,11,9,2,0,13,10],[13,7,12,6,4,5,8,9,1,11,15,10,2,14,0,3],[7,6,5,11,4,2,10,13,1,14,15,9,12,0,8,3],[13,8,5,15,4,2,1,0,14,11,6,3,12,7,9,10],[14,4,12,15,10,11,7,5,8,9,3,1,2,0,13,6],[13,11,12,10,1,7,15,6,8,9,4,5,2,14,0,3],[11,10,9,7,1,14,15,5,8,2,6,13,12,0,4,3],[13,4,9,15,14,7,10,3,8,2,1,0,12,11,5,6],[13,1,8,3,9,6,15,2,5,4,7,0,14,11,10,12],[11,1,7,3,9,8,5,10,2,4,14,13,15,0,12,6],[7,1,5,4,3,12,14,11,2,9,13,0,15,8,10,6],[11,1,8,4,3,2,15,0,13,9,14,7,5,10,6,12],[14,8,2,3,10,15,5,1,6,7,4,0,13,9,11,12],[11,7,2,3,10,6,8,9,1,13,4,14,15,12,0,5],[7,6,2,4,3,13,12,11,1,14,10,0,15,9,8,5],[11,8,2,4,3,15,1,0,14,13,10,7,6,5,9,12],[14,2,12,13,10,15,7,3,8,9,4,0,5,1,11,6],[11,13,1,7,10,12,15,6,8,9,4,14,2,3,0,5],[13,12,1,14,9,7,15,3,8,4,10,0,6,11,2,5],[11,2,14,7,9,15,12,5,8,4,10,13,1,0,3,6],[13,1,4,3,9,8,11,0,5,10,15,2,14,7,6,12],[7,1,11,3,2,8,14,13,5,4,9,6,15,0,12,10],[11,1,9,8,2,5,13,0,3,12,14,7,15,4,6,10],[7,1,4,8,13,5,14,11,3,2,15,0,9,6,10,12],[14,4,2,3,10,11,8,0,6,15,9,1,13,5,7,12],[7,11,2,3,1,13,8,14,6,10,4,5,15,12,0,9],[11,10,2,8,1,14,6,0,3,13,12,7,15,5,4,9],[7,4,2,8,14,13,6,11,3,15,1,0,10,9,5,12],[14,2,12,13,4,5,8,0,6,15,11,3,9,1,7,10],[7,13,1,11,4,5,8,14,6,12,15,10,2,3,0,9],[13,12,1,14,4,8,6,0,5,11,15,3,10,7,2,9],[7,2,14,11,4,8,6,13,5,15,12,9,1,0,3,10]]))
            @test ic_class(RFunc([13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12])) == Set(Vector{RFunc}([[13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12],[12,9,11,3,8,1,10,13,2,6,4,14,15,0,7,5],[13,9,4,3,8,1,10,2,6,15,5,14,0,11,7,12],[12,5,7,3,2,10,8,14,4,1,6,13,15,0,11,9],[11,3,12,15,8,5,9,14,2,1,0,7,6,4,13,10],[10,9,8,1,13,5,12,11,4,6,15,0,2,14,7,3],[11,9,8,1,2,5,12,4,6,15,0,13,3,14,7,10],[10,3,4,12,7,5,8,14,2,1,15,0,6,11,13,9],[7,3,12,15,2,1,0,11,4,9,5,14,10,8,13,6],[6,5,4,1,8,10,15,0,13,9,12,7,2,14,11,3],[7,5,4,1,10,15,0,13,2,9,12,8,3,14,11,6],[6,3,8,12,2,1,15,0,11,9,4,14,10,7,13,5],[14,8,6,3,9,10,15,13,4,5,2,1,0,11,7,12],[12,11,10,3,8,9,2,14,1,4,5,13,15,7,0,6],[14,4,10,3,8,9,2,1,5,6,15,13,0,7,11,12],[12,7,6,3,1,8,9,13,4,5,2,14,15,11,0,10],[11,12,3,15,8,10,6,13,1,0,2,7,5,14,4,9],[9,8,10,2,14,12,6,11,4,15,5,0,1,7,13,3],[11,8,10,2,1,12,6,4,5,0,15,14,3,7,13,9],[9,4,3,12,7,8,6,13,1,15,2,0,5,14,11,10],[7,12,3,15,1,0,2,11,4,6,10,13,9,14,8,5],[5,4,6,2,8,15,9,0,14,12,10,7,1,11,13,3],[7,4,6,2,9,0,15,14,1,12,10,8,3,11,13,5],[5,8,3,12,1,15,2,0,11,4,10,13,9,14,7,6],[14,8,9,12,6,5,15,11,2,3,0,13,4,1,7,10],[10,13,8,9,12,5,4,14,1,2,15,7,3,11,0,6],[14,2,8,9,12,5,4,1,3,6,0,7,15,11,13,10],[10,7,1,8,6,5,9,11,2,3,15,13,4,14,0,12],[13,10,8,12,5,15,6,11,1,0,3,14,4,7,2,9],[9,8,14,10,12,4,6,13,2,15,1,7,3,0,11,5],[13,8,1,10,12,4,6,2,3,0,5,7,15,14,11,9],[9,2,7,8,5,10,6,11,1,15,3,14,4,0,13,12],[7,10,1,0,5,15,4,13,2,6,9,14,12,11,8,3],[3,2,8,15,6,4,9,0,14,10,1,13,12,7,11,5],[7,2,9,0,6,4,15,14,1,10,5,13,12,8,11,3],[3,8,1,15,5,10,4,0,13,2,9,14,12,11,7,6],[14,4,5,12,2,3,0,13,10,9,15,7,8,1,11,6],[6,13,4,5,1,2,15,11,12,9,8,14,3,7,0,10],[14,2,4,5,3,10,0,11,12,9,8,1,15,7,13,6],[6,11,1,4,2,3,15,13,10,9,5,7,8,14,0,12],[13,6,4,12,1,0,3,14,9,15,10,7,8,11,2,5],[5,4,14,6,2,15,1,11,12,8,10,13,3,0,7,9],[13,4,1,6,3,0,9,11,12,8,10,2,15,14,7,5],[5,2,11,4,1,15,3,14,9,6,10,7,8,0,13,12],[11,6,1,0,2,10,5,14,9,15,8,13,12,7,4,3],[3,2,4,15,14,6,1,13,10,8,5,0,12,11,7,9],[11,2,5,0,1,6,9,13,10,8,15,14,12,4,7,3],[3,4,1,15,13,2,5,14,9,6,8,0,12,7,11,10]]))
            @test ic_class(RFunc([4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12])) == Set(Vector{RFunc}([[4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12],[5,1,8,12,0,2,4,7,10,9,6,13,15,11,14,3],[8,1,9,15,2,5,4,13,10,0,6,11,3,7,14,12],[9,1,4,12,6,5,10,13,0,2,8,11,15,7,14,3],[2,1,6,0,3,15,12,7,4,9,5,13,8,11,14,10],[3,1,0,4,8,10,2,7,12,9,15,13,6,11,14,5],[8,1,4,3,9,15,2,11,12,0,5,7,6,13,14,10],[9,1,6,3,2,10,12,11,0,4,15,7,8,13,14,5],[2,1,10,0,8,5,9,13,3,15,12,11,4,7,14,6],[3,1,0,8,12,5,15,13,4,6,2,11,10,7,14,9],[4,1,8,3,12,0,9,11,5,15,2,7,10,13,14,6],[5,1,10,3,0,8,15,11,2,6,12,7,4,13,14,9],[4,6,2,15,5,9,0,7,1,8,10,14,3,13,11,12],[6,8,2,12,0,4,1,7,9,5,10,14,15,13,11,3],[8,10,2,15,1,4,6,14,9,5,0,11,3,13,7,12],[10,4,2,12,5,9,6,14,0,8,1,11,15,13,7,3],[1,5,2,0,3,12,15,7,4,6,10,14,8,13,11,9],[3,0,2,4,8,1,9,7,12,15,10,14,5,13,11,6],[8,4,2,3,10,1,15,11,12,6,0,7,5,13,14,9],[10,5,2,3,1,12,9,11,0,15,4,7,8,13,14,6],[1,9,2,0,8,10,6,14,3,12,15,11,4,13,7,5],[3,0,2,8,12,15,6,14,4,1,5,11,9,13,7,10],[4,8,2,3,12,10,0,11,6,1,15,7,9,13,14,5],[6,9,2,3,0,15,8,11,1,12,5,7,4,13,14,10],[2,6,3,9,4,15,0,7,1,8,5,11,12,14,13,10],[6,8,0,2,4,10,1,7,9,3,15,11,12,14,13,5],[8,12,1,2,4,15,6,14,9,3,5,11,0,13,7,10],[12,2,3,9,4,10,6,14,0,8,15,11,1,13,7,5],[1,3,5,10,4,0,15,7,2,6,8,11,12,14,13,9],[5,0,8,1,4,2,9,7,10,15,3,11,12,14,13,6],[8,2,12,1,4,5,15,13,10,6,3,11,0,7,14,9],[12,3,1,10,4,5,9,13,0,15,8,11,2,7,14,6],[1,9,8,12,4,0,6,14,5,10,2,11,15,13,7,3],[5,0,10,15,4,8,6,14,2,1,9,11,3,13,7,12],[2,8,10,12,4,5,0,13,6,1,9,11,15,7,14,3],[6,9,0,15,4,5,8,13,1,10,2,11,3,7,14,12],[2,10,3,5,1,4,9,7,8,15,0,11,12,14,13,6],[10,4,0,2,5,3,15,7,8,6,1,11,12,14,13,9],[4,12,1,2,5,3,9,7,8,15,10,14,0,13,11,6],[12,2,3,5,0,4,15,7,8,6,10,14,1,13,11,9],[1,3,9,6,2,10,4,7,8,0,15,11,12,14,13,5],[9,0,4,1,6,15,3,7,8,2,5,11,12,14,13,10],[4,2,12,1,6,10,3,7,8,9,15,13,0,11,14,5],[12,3,1,6,0,15,4,7,8,9,5,13,2,11,14,10],[1,5,4,12,9,6,2,7,8,0,10,14,15,13,11,3],[9,0,6,15,2,1,5,7,8,4,10,14,3,13,11,12],[2,4,6,12,10,1,5,7,8,9,0,13,15,11,14,3],[10,5,0,15,1,6,2,7,8,9,4,13,3,11,14,12]]))
            @test ic_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set(Vector{RFunc}([[2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6],[9,11,0,14,3,13,15,4,8,7,2,5,6,12,10,1],[2,15,6,8,4,0,14,1,11,7,12,5,13,9,3,10],[5,7,0,14,4,11,2,9,3,13,15,8,10,12,6,1],[4,15,7,13,12,2,10,9,8,0,11,3,14,1,5,6],[9,13,5,11,0,14,15,2,8,7,6,10,4,3,12,1],[4,15,2,0,6,8,14,1,13,7,11,9,10,3,5,12],[3,7,2,13,0,14,4,9,5,11,12,10,15,8,6,1],[8,15,11,13,4,0,7,3,12,2,6,5,14,1,9,10],[5,13,9,7,4,11,10,6,0,14,15,2,8,3,12,1],[8,15,2,0,13,11,7,5,10,4,14,1,6,3,9,12],[3,11,2,13,9,7,12,6,0,14,8,5,15,4,10,1],[1,9,15,4,7,12,11,10,8,13,0,2,14,3,6,5],[10,0,11,13,3,15,14,4,8,1,7,6,5,9,12,2],[1,5,15,8,4,13,0,2,11,12,7,6,14,3,10,9],[6,0,7,13,4,1,11,10,3,15,14,8,9,5,12,2],[4,7,15,14,12,9,1,10,8,11,0,3,13,6,2,5],[10,6,14,11,0,15,13,1,8,5,7,9,4,12,3,2],[4,1,15,0,5,13,8,2,14,11,7,10,9,6,3,12],[3,1,7,14,0,4,13,10,6,12,11,9,15,5,8,2],[8,11,15,14,4,7,0,3,12,5,1,6,13,10,2,9],[6,10,14,7,4,9,11,5,0,15,13,1,8,12,3,2],[8,1,15,0,14,7,11,6,9,13,4,2,5,10,3,12],[3,1,11,14,10,12,7,5,0,8,13,6,15,9,4,2],[1,9,7,10,15,2,13,12,8,11,14,5,0,4,6,3],[12,0,5,15,13,11,14,2,8,1,3,9,7,6,10,4],[1,3,2,11,15,8,0,4,13,10,14,5,7,6,12,9],[6,0,2,1,7,11,13,12,5,15,9,3,14,8,10,4],[2,7,10,9,15,14,1,12,8,13,11,6,0,5,4,3],[12,6,0,15,14,13,11,1,8,3,2,10,7,9,5,4],[2,1,3,11,15,0,8,4,14,13,9,6,7,12,5,10],[5,1,0,2,7,14,11,12,6,10,15,3,13,9,8,4],[8,13,2,7,15,14,0,5,10,3,11,12,1,6,4,9],[6,12,2,9,14,7,13,3,0,15,8,10,11,1,5,4],[8,1,14,7,15,0,13,6,9,11,3,12,2,4,5,10],[5,1,12,10,13,14,7,3,0,8,15,9,11,6,2,4],[1,5,11,6,4,7,14,9,15,2,13,12,0,8,10,3],[12,0,9,15,4,1,3,5,13,7,14,2,11,10,6,8],[1,3,2,7,13,6,14,9,15,4,0,8,11,10,12,5],[10,0,2,1,9,15,5,3,11,7,13,12,14,4,6,8],[2,11,6,5,4,13,7,10,15,14,1,12,0,9,8,3],[12,10,0,15,4,3,2,6,14,13,7,1,11,5,9,8],[2,1,3,7,14,13,5,10,15,0,4,8,11,12,9,6],[9,1,0,2,10,6,15,3,11,14,7,12,13,5,4,8],[4,13,2,11,6,3,7,12,15,14,0,9,1,10,8,5],[10,12,2,5,0,15,4,6,14,11,13,3,7,1,9,8],[4,1,14,11,5,7,3,12,15,0,13,10,2,8,9,6],[9,1,12,6,0,4,15,5,13,14,11,3,7,10,2,8]]))
            # Check type
            @test typeof(ic_class(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]))) == Set{RFunc}
            @test typeof(ic_class([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == Set{Array{Int,1}}
        end
    end

    @testset "IC Representative Function" begin
        @testset "IC Representative Function: N=3" begin
            initialize_icequive(3)
            @test ic_representative_function(RFunc([0,1,2,3,4,5,6,7])) == RFunc([0,1,2,3,4,5,6,7])
            @test ic_representative_function(RFunc([7,6,5,4,3,2,1,0])) == RFunc([7,6,5,4,3,2,1,0])
            @test ic_representative_function(RFunc([0,1,2,4,3,5,6,7])) == RFunc([0,1,2,4,3,5,6,7])
            @test ic_representative_function(RFunc([7,1,5,4,3,2,6,0])) == RFunc([7,1,5,4,3,2,6,0])
            @test ic_representative_function(RFunc([3,7,4,2,0,5,1,6])) == RFunc([1,2,6,7,3,5,0,4])
            @test ic_representative_function(RFunc([6,2,0,4,3,5,7,1])) == RFunc([1,2,7,4,3,0,6,5])
            @test ic_representative_function(RFunc([3,5,7,1,4,0,2,6])) == RFunc([3,1,6,2,5,7,0,4])
            @test ic_representative_function(RFunc([7,1,4,3,2,6,5,0])) == RFunc([7,1,4,3,2,6,5,0])
            @test ic_representative_function(RFunc([3,2,7,0,1,6,5,4])) == RFunc([3,2,4,0,7,6,5,1])
            @test ic_representative_function(RFunc([6,5,0,7,3,4,2,1])) == RFunc([1,3,6,0,7,2,4,5])
        end
        @testset "IC Representative Function: N=4" begin
            initialize_icequive(4)
            @test ic_representative_function(RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])) == RFunc([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
            @test ic_representative_function(RFunc([15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0])) == RFunc([15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0])
            @test ic_representative_function(RFunc([0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15])) == RFunc([0,1,2,3,4,5,6,8,7,9,10,11,12,13,14,15])
            @test ic_representative_function(RFunc([15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0])) == RFunc([15,1,13,12,11,10,9,8,7,6,5,4,3,2,14,0])
            @test ic_representative_function(RFunc([15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0])) == RFunc([15,1,2,12,11,10,9,8,7,6,5,4,3,13,14,0])
            @test ic_representative_function(RFunc([0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15])) == RFunc([0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15])
            @test ic_representative_function(RFunc([0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15])) == RFunc([0,1,2,3,4,5,9,8,7,6,10,11,12,13,14,15])
            @test ic_representative_function(RFunc([2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11])) == RFunc([1,2,6,15,14,7,3,10,4,5,0,9,11,12,8,13])
            @test ic_representative_function(RFunc([11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9])) == RFunc([7,1,4,8,13,5,14,11,3,2,15,0,9,6,10,12])
            @test ic_representative_function(RFunc([13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12])) == RFunc([3,2,4,15,14,6,1,13,10,8,5,0,12,11,7,9])
            @test ic_representative_function(RFunc([4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12])) == RFunc([1,3,5,10,4,0,15,7,2,6,8,11,12,14,13,9])
            @test ic_representative_function(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])) == RFunc([1,3,2,7,13,6,14,9,15,4,0,8,11,10,12,5])
        end
    end

    @testset "IC Pattern RFunc" begin
        @testset "IC Pattern RFunc: N=3" begin
            initialize_icequive(3)
            testfuncs = Vector{RFunc}([
                [0,1,2,3,4,5,6,7],
                [7,6,5,4,3,2,1,0],
                [0,1,2,4,3,5,6,7],
                [7,1,5,4,3,2,6,0],
                [3,7,4,2,0,5,1,6],
                [6,2,0,4,3,5,7,1],
                [3,5,7,1,4,0,2,6],
                [7,1,4,3,2,6,5,0],
                [3,2,7,0,1,6,5,4],
                [6,5,0,7,3,4,2,1]
            ])
            for testfunc in testfuncs
                @test ic_representative_function_ptn(testfunc)[1] == ic_representative_function(testfunc)
            end
        end
        @testset "IC Pattern RFunc: N=4" begin
            initialize_icequive(4)
            testfuncs = Vector{RFunc}([
                [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
                [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0],
                [0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15],
                [15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0],
                [15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0],
                [0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],
                [0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],
                [2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11],
                [11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9],
                [13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12],
                [4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12],
                [2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]
            ])
            for testfunc in testfuncs
                @test ic_representative_function_ptn(testfunc)[1] == ic_representative_function(testfunc)
            end
        end
    end

    @testset "IC RFunc Restore" begin
        @testset "IC RFunc Restore: N=3" begin
            initialize_icequive(3)
            testfuncs = Vector{RFunc}([
                [0,1,2,3,4,5,6,7],
                [7,6,5,4,3,2,1,0],
                [0,1,2,4,3,5,6,7],
                [7,1,5,4,3,2,6,0],
                [3,7,4,2,0,5,1,6],
                [6,2,0,4,3,5,7,1],
                [3,5,7,1,4,0,2,6],
                [7,1,4,3,2,6,5,0],
                [3,2,7,0,1,6,5,4],
                [6,5,0,7,3,4,2,1]
            ])
            for testfunc in testfuncs
                rfunc, ptn = ic_representative_function_ptn(testfunc)
                @test apply_pattern(rfunc, inv(ptn)) == testfunc
            end
            # Check type
            rfunc, ptn = ic_representative_function_ptn(RFunc([6,5,0,7,3,4,2,1]))
            @test typeof(apply_pattern(rfunc, inv(ptn))) == RFunc
            rfunc, ptn = ic_representative_function_ptn([6,5,0,7,3,4,2,1])
            @test typeof(apply_pattern(rfunc, inv(ptn))) == Array{Int,1}
        end
        @testset "IC RFunc Restore: N=4" begin
            initialize_icequive(4)
            testfuncs = Vector{RFunc}([
                [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
                [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0],
                [0,14,2,3,4,5,6,7,8,9,10,11,12,13,1,15],
                [15,14,13,12,4,10,9,8,7,6,5,11,3,2,1,0],
                [15,14,13,12,4,10,9,7,8,6,5,11,3,2,1,0],
                [0,14,2,3,4,5,9,7,8,6,10,11,12,13,1,15],
                [0,14,2,12,4,5,6,7,8,9,10,11,3,13,1,15],
                [2,13,4,7,5,6,15,12,1,14,3,9,0,8,10,11],
                [11,10,2,5,8,15,6,4,3,13,1,14,7,12,0,9],
                [13,5,8,3,10,15,9,14,4,1,6,2,0,7,11,12],
                [4,1,5,15,6,0,10,7,2,9,8,13,3,11,14,12],
                [2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]
            ])
            for testfunc in testfuncs
                rfunc, ptn = ic_representative_function_ptn(testfunc)
                @test apply_pattern(rfunc, inv(ptn)) == testfunc
            end
            # Check type
            rfunc, ptn = ic_representative_function_ptn(RFunc([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6]))
            @test typeof(apply_pattern(rfunc, inv(ptn))) == RFunc
            rfunc, ptn = ic_representative_function_ptn([2,15,10,4,7,11,12,9,8,0,14,1,13,5,3,6])
            @test typeof(apply_pattern(rfunc, inv(ptn))) == Array{Int,1}
        end
    end

    @testset "IC RCircit Restore" begin
        initialize_icequive(4)
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(true, UInt8[0x00, 0x01, 0x02, 0x03])) == RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(true, UInt8[0x00, 0x03, 0x02, 0x01])) == RCircuit([RGate(2, [1,3]), RGate(1, []), RGate(0, [2])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(true, UInt8[0x01, 0x02, 0x03, 0x00])) == RCircuit([RGate(3, [0,2]), RGate(0, []), RGate(1, [3])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(true, UInt8[0x02, 0x03, 0x00, 0x01])) == RCircuit([RGate(0, [1,3]), RGate(1, []), RGate(2, [0])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(true, UInt8[0x03, 0x00, 0x01, 0x02])) == RCircuit([RGate(1, [0,2]), RGate(2, []), RGate(3, [1])])

        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, UInt8[0x00, 0x01, 0x02, 0x03])) == RCircuit([RGate(0, [2]), RGate(3, []), RGate(2, [1,3])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, UInt8[0x00, 0x03, 0x02, 0x01])) == RCircuit([RGate(0, [2]), RGate(1, []), RGate(2, [1,3])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, UInt8[0x01, 0x02, 0x03, 0x00])) == RCircuit([RGate(1, [3]), RGate(0, []), RGate(3, [0,2])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, UInt8[0x02, 0x03, 0x00, 0x01])) == RCircuit([RGate(2, [0]), RGate(1, []), RGate(0, [1,3])])
        @test apply_pattern(RCircuit([RGate(2, [1,3]), RGate(3, []), RGate(0, [2])]), ICPattern(false, UInt8[0x03, 0x00, 0x01, 0x02])) == RCircuit([RGate(3, [1]), RGate(2, []), RGate(1, [0,2])])
    end

end

end # module

if abspath(PROGRAM_FILE) == @__FILE__
    using .TestIcequive
    TestIcequive.test()
end
