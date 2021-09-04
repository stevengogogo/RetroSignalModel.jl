
"ODE function of rtgM4
Created and modified via ModelConv.create_func_exp(model)


# Argumemt
- 'u::Vector': systemic component of model
- 'p::Vector': parameters
- 'tspan::Tuple(1,2)': Start time , and ending
- 'sig::Function': sig(t) is the signal generator. The signal should be differentiable.

# Examples
```julia-repl
> model = Model.rtgM4
> solution = get_solution(;i=4)
> u,p = rtgPar()
> sig = Waves.SIN(amp=3, freq=0.5/(2*pi), phi= 2*pi * 3/4)
> tspan = (0.0,200.0)
> sol = solve_ode(param.u, param.p, tspan, sig)
```

# Note
If the parameter set is not in steady-state when t=0 with sig(t). This function automatically calculate the steady-state and start the simulation. However, it takes seconds to
"
function solve_dym_rtgM4(u, p, tspan, sig; ode_method=AutoTsit5(Rosenbrock23()), ode_err=1e-3)

   function ode_rtgM4_!(du, u, p, t)

       s, Rtg2_ina_c,Rtg2_act_c,Mks,Rtg2Mks_c,Bmh,BmhMks,Rtg13_a_c,Rtg13_i_c,Rtg3_i_c,Rtg3_a_c,Rtg3_a_n,Rtg3_i_n,Rtg1_c,Rtg1_n,Rtg13_a_n,Rtg13_i_n=u

       n_s,ksV,ksD,k2I,k2M,kn2M,kBM,knBM,k13I,k13IV,k13ID,k3A_c,k3I_c,k3I_n,k13_c,kn13_c,k13_n,kn13_n,k1in,k1out,k3inA,k3outA,k3inI,k3outI=p

       # rtgM4 Model"

       # Input signal can be number or function
       du[1] =ds = dsig(t)
       du[2] = dRtg2_ina_c = -(((ksV * s ^ n_s) / (ksD ^ n_s + s ^ n_s)) * Rtg2_ina_c) + k2I * Rtg2_act_c
       du[3] = dRtg2_act_c = ((((ksV * s ^ n_s) / (ksD ^ n_s + s ^ n_s)) * Rtg2_ina_c - k2I * Rtg2_act_c) - k2M * Rtg2_act_c * Mks) + kn2M * Rtg2Mks_c
       du[4] = dMks = ((-(k2M * Rtg2_act_c * Mks) + kn2M * Rtg2Mks_c) - kBM * Bmh * Mks) + knBM * BmhMks
       du[5] = dRtg2Mks_c = k2M * Rtg2_act_c * Mks - kn2M * Rtg2Mks_c
       du[6] = dBmh = -(kBM * Bmh * Mks) + knBM * BmhMks
       du[7] = dBmhMks = kBM * Bmh * Mks - knBM * BmhMks
       du[8] = dRtg13_a_c = (-((k13I + (k13IV * BmhMks) / (k13ID + BmhMks)) * Rtg13_a_c) + k13_c * Rtg1_c * Rtg3_a_c) - kn13_c * Rtg13_a_c
       du[9] = dRtg13_i_c = ((k13I + (k13IV * BmhMks) / (k13ID + BmhMks)) * Rtg13_a_c + k13_c * Rtg1_c * Rtg3_i_c) - kn13_c * Rtg13_i_c
       du[10] = dRtg3_i_c = ((((-(k3A_c * Rtg3_i_c) + k3I_c * Rtg3_a_c) - k13_c * Rtg1_c * Rtg3_i_c) + kn13_c * Rtg13_i_c) - k3inI * Rtg3_i_c) + k3outI * Rtg3_i_n
       du[11] = dRtg3_a_c = ((((k3A_c * Rtg3_i_c - k3I_c * Rtg3_a_c) - k13_c * Rtg1_c * Rtg3_a_c) + kn13_c * Rtg13_a_c) - k3inA * Rtg3_a_c) + k3outA * Rtg3_a_n
       du[12] = dRtg3_a_n = (((-(k3I_n * Rtg3_a_n) - k13_n * Rtg1_n * Rtg3_a_n) + kn13_n * Rtg13_a_n) + k3inA * Rtg3_a_c) - k3outA * Rtg3_a_n
       du[13] = dRtg3_i_n = (((k3I_n * Rtg3_a_n - k13_n * Rtg1_n * Rtg3_i_n) + kn13_n * Rtg13_i_n) + k3inI * Rtg3_i_c) - k3outI * Rtg3_i_n
       du[14] = dRtg1_c = ((((-(k13_c * Rtg1_c * Rtg3_a_c) + kn13_c * Rtg13_a_c) - k13_c * Rtg1_c * Rtg3_i_c) + kn13_c * Rtg13_i_c) - k1in * Rtg1_c) + k1out * Rtg1_n
       du[15] = dRtg1_n = ((((-(k13_n * Rtg1_n * Rtg3_a_n) + kn13_n * Rtg13_a_n) - k13_n * Rtg1_n * Rtg3_i_n) + kn13_n * Rtg13_i_n) + k1in * Rtg1_c) - k1out * Rtg1_n
       du[16] = dRtg13_a_n = k13_n * Rtg1_n * Rtg3_a_n - kn13_n * Rtg13_a_n
       du[17] = dRtg13_i_n = k13_n * Rtg1_n * Rtg3_i_n - kn13_n * Rtg13_i_n

       return du
   end

   # Derivative of signal
   dsig = Calculus.derivative(sig)

   u_ = deepcopy(u)

   u_[1] = sig(tspan[1])

   # Check the model is in steady-state when t= t_start
   err_dudt = sum(Model_meta.cal_dudt(ode_rtgM4_!, u_, p))
   if err_dudt > ode_err
       prob = SteadyStateProblem(ode_rtgM4_!,  u_, p)
       sol = solve(prob, DynamicSS(ode_method))
       u_ = sol.u

   end

   # Solve time-series response
   prob = ODEProblem(ode_rtgM4_!, u_, tspan, p)

   if ode_method == Nothing
       sol = solve(prob)
   else
       sol = solve(prob, ode_method, callback = TerminateSteadyState())
   end

   return sol
end


function ode_rtgM4!(du, u, p, t)
       s, Rtg2_ina_c,Rtg2_act_c,Mks,Rtg2Mks_c,Bmh,BmhMks,Rtg13_a_c,Rtg13_i_c,Rtg3_i_c,Rtg3_a_c,Rtg3_a_n,Rtg3_i_n,Rtg1_c,Rtg1_n,Rtg13_a_n,Rtg13_i_n=u

        n_s,ksV,ksD,k2I,k2M,kn2M,kBM,knBM,k13I,k13IV,k13ID,k3A_c,k3I_c,k3I_n,k13_c,kn13_c,k13_n,kn13_n,k1in,k1out,k3inA,k3outA,k3inI,k3outI=p

       # rtgM4 Model
       u[1] = s
       du[1] = ds = 0
       du[2] = dRtg2_ina_c = -(((ksV * s ^ n_s) / (ksD ^ n_s + s ^ n_s)) * Rtg2_ina_c) + k2I * Rtg2_act_c
       du[3] = dRtg2_act_c = ((((ksV * s ^ n_s) / (ksD ^ n_s + s ^ n_s)) * Rtg2_ina_c - k2I * Rtg2_act_c) - k2M * Rtg2_act_c * Mks) + kn2M * Rtg2Mks_c
       du[4] = dMks = ((-(k2M * Rtg2_act_c * Mks) + kn2M * Rtg2Mks_c) - kBM * Bmh * Mks) + knBM * BmhMks
       du[5] = dRtg2Mks_c = k2M * Rtg2_act_c * Mks - kn2M * Rtg2Mks_c
       du[6] = dBmh = -(kBM * Bmh * Mks) + knBM * BmhMks
       du[7] = dBmhMks = kBM * Bmh * Mks - knBM * BmhMks
       du[8] = dRtg13_a_c = (-((k13I + (k13IV * BmhMks) / (k13ID + BmhMks)) * Rtg13_a_c) + k13_c * Rtg1_c * Rtg3_a_c) - kn13_c * Rtg13_a_c
       du[9] = dRtg13_i_c = ((k13I + (k13IV * BmhMks) / (k13ID + BmhMks)) * Rtg13_a_c + k13_c * Rtg1_c * Rtg3_i_c) - kn13_c * Rtg13_i_c
       du[10] = dRtg3_i_c = ((((-(k3A_c * Rtg3_i_c) + k3I_c * Rtg3_a_c) - k13_c * Rtg1_c * Rtg3_i_c) + kn13_c * Rtg13_i_c) - k3inI * Rtg3_i_c) + k3outI * Rtg3_i_n
       du[11] = dRtg3_a_c = ((((k3A_c * Rtg3_i_c - k3I_c * Rtg3_a_c) - k13_c * Rtg1_c * Rtg3_a_c) + kn13_c * Rtg13_a_c) - k3inA * Rtg3_a_c) + k3outA * Rtg3_a_n
       du[12] = dRtg3_a_n = (((-(k3I_n * Rtg3_a_n) - k13_n * Rtg1_n * Rtg3_a_n) + kn13_n * Rtg13_a_n) + k3inA * Rtg3_a_c) - k3outA * Rtg3_a_n
       du[13] = dRtg3_i_n = (((k3I_n * Rtg3_a_n - k13_n * Rtg1_n * Rtg3_i_n) + kn13_n * Rtg13_i_n) + k3inI * Rtg3_i_c) - k3outI * Rtg3_i_n
       du[14] = dRtg1_c = ((((-(k13_c * Rtg1_c * Rtg3_a_c) + kn13_c * Rtg13_a_c) - k13_c * Rtg1_c * Rtg3_i_c) + kn13_c * Rtg13_i_c) - k1in * Rtg1_c) + k1out * Rtg1_n
       du[15] = dRtg1_n = ((((-(k13_n * Rtg1_n * Rtg3_a_n) + kn13_n * Rtg13_a_n) - k13_n * Rtg1_n * Rtg3_i_n) + kn13_n * Rtg13_i_n) + k1in * Rtg1_c) - k1out * Rtg1_n
       du[16] = dRtg13_a_n = k13_n * Rtg1_n * Rtg3_a_n - kn13_n * Rtg13_a_n
       du[17] = dRtg13_i_n = k13_n * Rtg1_n * Rtg3_i_n - kn13_n * Rtg13_i_n

end

