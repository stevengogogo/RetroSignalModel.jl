
#' Environment
using Pkg
Pkg.activate(@__DIR__)
cd(@__DIR__)
Pkg.status()

#' Load library to main worker
@time using Distributed, RetroSignalModel, CSV
import RetroSignalModel as rs
#' Add workers
addprocs(1,exeflags="--project=$(Base.active_project())");
@show nprocs();

#' Load library to workers
@time @everywhere using RetroSignalModel;

#' Parameter searching
@time df = rs.paramSearching(rs.rtgM4(); num_sim=100, distributed=true, saveall=true)

#'
CSV.write("data/valid_sol.csv", df)