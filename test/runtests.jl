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

    @testset "Data" begin
        include("data.jl")
    end

    @testset "Protein lookup" begin 
        include("protein_lookup.jl")
    end

end
