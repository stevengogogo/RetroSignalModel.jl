module Validation

using DifferentialEquations
using Random
using Suppressor


using Model
import Model.Model_meta
using Sim

include("Setting.jl")
using .Setting

include("Sampling.jl")


## SETTING
const S_SPAN = Sampling.S_SPAN
const DEL_CONC=Setting.DEL_CONC
const TRANS_THRESHOLD = Setting.TRANS_THRESHOLD
const tspan = Setting.val_tspan
const SSMETHOD = Setting.SSMETHOD
const DEFAULT_MODEL = Setting.MODEL
##

model_meta = Model_meta.get_model_meta(DEFAULT_MODEL)
const meta = Model_meta.get_model_meta(DEFAULT_MODEL)
const cond, protein_lookup = meta.cond, meta.protein_lookup


export get_output, try_simulate, try_conditions, get_del_u


function try_conditions!(u,p;
                        model=DEFAULT_MODEL,
                        BREAK=false,
                        Cond_Random=true)
        valid = 1
        steady = 1

        num_cond = size(cond)[1]

        if Cond_Random # Shuffling the conditions
            trial_cond_order = shuffle( Int.(range(1,stop=num_cond,length=num_cond ) ) )
        else
            trial_cond_order = Int.(range(1,stop=num_cond,length=num_cond) )
        end

        test_log = Vector{Union{Missing, Int16}}(missing, num_cond)

        # get initial condition
        u[:] = Sim.solve_SSODE(model, u, p) # This step changed the initial value, and reset as the steady ones

        for trial_n in trial_cond_order # Test conditions
            con = cond[trial_n,:]

            if typeof(con.Trans2Nuc) == Missing
                continue # some conditions are not measured
            end

            ud = get_del_u(u, con.rtg1, con.rtg2, con.rtg3, con.mks, con.s, protein_lookup; del_conc=DEL_CONC, s_span=S_SPAN)


            sol = @suppress begin
                    Sim.solve_SSODE(model, ud, p; method=SSMETHOD)
                end

            # Check the steady-state is real
            if sol.retcode==:Failure
                steady = 0
                valid = 0 #unstable system
                break
            end

            trans2nuc = get_output(sol, con.gfp, protein_lookup, threshold=TRANS_THRESHOLD) # 1 means nucleus has significantly higer concentration than cytosol


            if trans2nuc != con.Trans2Nuc
                valid = 0
                test_log[trial_n] = 0
                if BREAK # Early termination when invalid condition is confirmed
                    break
                end
            else
                test_log[trial_n] = 1
            end
        end

        if valid == 1 # Simulation test
            if try_simulate(model,p,u) == 0
                valid = 0
            end
        end

        return valid, test_log, steady
end

"
Compare the cytosolic concentration of either 'rtg1' or 'rtg3' with their nucleus concentrations.
Output:
1 : nucleus concentration is higher than the cytosolic one
0 : otherwise
"
function get_output(sol, gfp, protein_lookup; threshold = TRANS_THRESHOLD)

    if gfp == "rtg1"
        cyt_index = protein_lookup[:Rtg1_c]
        nuc_index = protein_lookup[:Rtg1_n]
    elseif gfp == "rtg3"
        cyt_index = protein_lookup[:Rtg3_c]
        nuc_index = protein_lookup[:Rtg3_n]
    else
        throw(MathodError)
    end

    total_conc_cyt = sum(sol[cyt_index])
    total_conc_nuc = sum(sol[nuc_index])

    if total_conc_nuc > threshold*total_conc_cyt
        output = 1
    else
        output = 0
    end
    return output
end

"
Testing on solving ODE
"
function try_simulate(model, p, u; tspan=tspan)
    st = 1
    try
        println("try simulate")
        oprob = ODEProblem(model, u, tspan, p )
        osol = solve(oprob)
        println("Simulation successed")
    catch y
        println(y) # What to do when an error occurs.
        st = 0
    end
    return st
end

"
Copy vector u, and delete elements with lookup table
"
function get_del_u(u, rtg1, rtg2, rtg3, mks, s, protein_lookup; del_conc=DEL_CONC, s_span=S_SPAN )

    del_info = Dict([:Rtg1, :Rtg2, :Rtg3, :Mks] .=> [rtg1, rtg2, rtg3, mks])
    ud = deepcopy(u)

    for protein in keys(del_info)
        protein_existence = del_info[protein]
        if protein_existence == 0
            ud[protein_lookup[protein]] .= del_conc
        end
    end

    ud[protein_lookup[:s]] = s_span[s+1] #in boolean, s=0 means 1 in span_tuple

    return ud
end


"Qualitative Validation"

"Substraction of nuclear concentration with cytoplasmic concentration"
function get_outputQ(sol, gfp, protein_lookup; threshold = TRANS_THRESHOLD)

    if gfp == "rtg1"
        cyt_index = protein_lookup[:Rtg1_c]
        nuc_index = protein_lookup[:Rtg1_n]
    elseif gfp == "rtg3"
        cyt_index = protein_lookup[:Rtg3_c]
        nuc_index = protein_lookup[:Rtg3_n]
    else
        throw(MathodError)
    end

    total_conc_cyt = sum(sol[cyt_index])
    total_conc_nuc = sum(sol[nuc_index])

    output = total_conc_nuc - threshold*total_conc_cyt

    return output
end


end
