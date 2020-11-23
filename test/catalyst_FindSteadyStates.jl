

@testset "Sample reaction model" begin 
    model = @reaction_network begin
        c1, X --> 2X
        c2, X --> 0
        c3, 0 --> X
    end c1 c2 c3
    p = (1.0,2.0,50.) # [c1,c2,c3]
    u0 = [5.]

    de = DEsteady(func=model, u0= u0, p= p)

    sol  = solve(de)
end



@testset "Custom model" begin
    
    model = rtgM4.model 
    param = rtgM4.param()

    # By Differential Equations.jl
    prob = SteadyStateProblem(model, Vector(param.u), Vector(param.p))
    sol = solve(prob, DynamicSS(AutoTsit5(Rosenbrock23())))
    
    # By FindSteadyStates.jl
    de = DEsteady(func=model, u0= param.u, p= param.p, method= DynamicSS(AutoTsit5(Rosenbrock23())))
    sol_d = solve(de)

    #"Check if produce NaN solution (DifferentialEquation.jl)" 
    @test all( .!isnothing.(sol.u) )

    #"Check if produce NaN solution (FindSteadyStates.jl)" 
    @test all( .!isnothing.(sol_d.u) )

    #"The solution should be the same"
    @test all(abs.(sol.u .- sol_d.u) .< 10e-5 )

end

@testset "Root finding" begin 
    model = rtgM4.model 
    param = rtgM4.param()    

    de = DEsteady(func=model, u0= param.u, p= param.p, method= SSRootfind())

    solve(de)

end

@testset "Random search root" begin 
    model = rtgM4.model 
    param = rtgM4.param()  

    de = DEsteady(func=model, u0= param.u, p= param.p, method= SSRootfind())

    param_ranges = [  
        0.:1.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
        0.:1000.,
    ]

    pr = ParameterRandom(
        param_ranges,
        len = 10 )

    solve(de, pr)

end

