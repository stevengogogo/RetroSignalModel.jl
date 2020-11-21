using RetroSignalModel
using Test

@testset "RetroSignalModel.jl" begin
    @testset "Chemical Reaction Functions" begin
        include("chemical_reactions.jl")
    end
end
