module rtgM4

using Catalyst 
using Calculus
using DifferentialEquations
using Parameters
using LabelledArrays

#export model, param,  solve_dym_rtgM4, ode_rtgM4!, LatexRtgM4

include("utils.jl")
include("model.jl")
include("param.jl")
include("solve.jl")
include("alias.jl")

end


