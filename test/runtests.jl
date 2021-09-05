using Revise
using DataFrames
import CSV
import RetroSignalModel as rs
using Test


@testset "Data files" begin
    include("load_data.jl")
end

@testset "Build models" begin 
    include("build_model.jl")
end

