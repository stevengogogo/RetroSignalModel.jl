
"""
ODE function of rtgM4
Created and modified via ModelConv.create_func_exp(model)

Argumemt
--------
- 'u::Vector': systemic component of model
- 'p::Vector': parameters
- 'tspan::Tuple(1,2)': Start time , and ending
- 'sig::Function': sig(t) is the signal generator. The signal should be differentiable.

Examples
--------
```julia
model = Model.rtgM4
solution = get_solution(;i=4)
u,p = rtgPar()
sig = Waves.SIN(amp=3, freq=0.5/(2*pi), phi= 2*pi * 3/4)
tspan = (0.0,200.0)
sol = solve_ode(param.u, param.p, tspan, sig)
```

Note
----
If the parameter set is not in steady-state when t=0 with sig(t). This function automatically calculate the steady-state and start the simulation. However, it takes seconds to
"""
function solve_dym(m::rtgM4, u, p, tspan, sig; ode_method=AutoTsit5(Rosenbrock23()), ode_err=1e-3)
    
end