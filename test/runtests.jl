using RetroSignalModel
using Catalyst
using DifferentialEquations
using FindSteadyStates
using ModelingToolkit
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

    @testset "Model meta" begin 
        include("model_utils.jl")
    end

    @testset "Compatibility with FindSteadyStates.jl" begin 
        include("catalyst_FindSteadyStates.jl")
    end

    @testset  "Get flux" begin 
        include("get_flux.jl")
    end

    @testset "Validation function" begin
        include("validation_func.jl")
    end
end
