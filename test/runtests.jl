using RetroSignalModel
using Test

@testset "Data files" begin
    include("load_data.jl")
end

@testset "Build models" begin
    include("build_model.jl")
end

@testset "Parameter searching" begin
    include("params.jl")
end