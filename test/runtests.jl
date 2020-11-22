using RetroSignalModel
using Catalyst
using Test

@testset "RetroSignalModel.jl" begin
    @testset "Chemical Reaction Functions" begin
        include("chemical_reactions.jl")
    end

    @testset "Parameter Compatibility" begin 
        include("parameter_compat.jl")
    end 

    @testset "Latex completeness of rtgM4" begin
        include("latex.jl") 
    end
end
