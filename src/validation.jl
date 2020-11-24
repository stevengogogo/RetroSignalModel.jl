export valid_setting, get_output, try_simulate, try_conditions, get_del_u, try_conditions!

## SETTING


"""
Setting for validation.
"""
@with_kw struct valid_setting
    model # RTG model 
    S_SPAN # Domain (low, high)
    DEL_CONC # Concentration of deletion
    TRANS_THRESHOLD 
    SSMETHOD 
    meta
    cond 
    protein_lookup
end


"""
Generate validation setting from `setting.jl`.
"""
function valid_setting(model;Setting=setting())
    meta = model_meta(model)

    return valid_setting(
    model = model,
    S_SPAN = Setting.S_SPAN,
    DEL_CONC= Setting.DEL_CONC,
    TRANS_THRESHOLD = Setting.TRANS_THRESHOLD,
    SSMETHOD = Setting.SSMETHOD,
    meta = meta,
    cond = meta.cond, 
    protein_lookup =  meta.protein_lookup
    )
end




"""
Try conditions of the model with given initial variables and parameters.
"""
function try_conditions(u,p, VALID_SETTING;
                        BREAK=false,
                        Cond_Random=true)

        @unpack  model, S_SPAN, DEL_CONC, TRANS_THRESHOLD,  SSMETHOD, cond, protein_lookup = VALID_SETTING

        valid = 1

        num_cond = size(cond)[1] # number of conditions

        # Shuffling the conditions
        trial_cond_order = Cond_Random ? shuffle(1:num_cond) : 1:num_cond

        test_log = Vector{Union{Missing, Int16}}(missing, num_cond)

        # get initial condition
        de = DEsteady(func=model, u0=u, p=p, method=SSMETHOD)
        u_ = solve(de) # This step changed the initial value, and reset as the steady ones

        for trial_n in trial_cond_order # Test conditions

            con = cond[trial_n,:]

            typeof(con.Trans2Nuc) == Missing ? continue : nothing # some conditions are not measured
            

            ud = get_del_u(u_, con.rtg1, con.rtg2, con.rtg3, con.mks, con.s, protein_lookup; del_conc=DEL_CONC, s_span=S_SPAN)

            sol = solve(de(ud))

            # Check the steady-state is real
            if sol.retcode==:Failure
                valid = 0 #unstable system
                break
            end


            trans2nuc = get_output(sol, con.gfp, protein_lookup, threshold=TRANS_THRESHOLD) # 1 means nucleus has significantly higer concentration than cytosol


            if trans2nuc != con.Trans2Nuc
                valid = 0
                test_log[trial_n] = 0
    
                # Early termination when invalid condition is confirmed
                BREAK ? break : nothing
            else
                test_log[trial_n] = 1
            end
        end

      
        return valid, test_log
end





"""
Compare the cytosolic concentration of either 'rtg1' or 'rtg3' with their nucleus concentrations.
Output:
1 : nucleus concentration is higher than the cytosolic one
0 : otherwise
"""
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

"""
Test for solving ODE. 
"""
function try_simulate(model, p, u; tspan=tspan)
    st = 1
    try
        @info "try simulate"
        oprob = ODEProblem(model, u, tspan, p )
        osol = solve(oprob)
        @info "Simulation successed"
    catch y
        println(y) # What to do when an error occurs.
        st = 0
    end
    return st
end

"""
Copy vector u, and delete elements with lookup table
"""
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



"""
Qualitative Validation

method
------
Substraction of nuclear concentration with cytoplasmic concentration"""
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


