using Revise
import RetroSignalModel as rs
using Test


@testset "Chemical Reaction Functions" begin
    include("load_data.jl")
end

@testset "Build models" begin 
    include("build_model.jl")
end

