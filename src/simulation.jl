struct RTGoutput{T}
    IsNucAccum::Bool 
    Conc_Cyt::T
    Conc_Nuc::T
    threshold::T
end

IsNucAccum(res::RTGoutput) = res.IsNucAccum

"""
Validate responses 
"""
function isValid(m::RTGmodel)
    #todo
end

function getOutput(m::RTGmodel, gfp;kwags...)
    return getOutput(m.u, gfp, m.protein_lookup; kwags...)
end

"""
Compare the cytosolic concentration of either 'rtg1' or 'rtg3' with their nucleus concentrations.
Output:
1 : nucleus concentration is higher than the cytosolic one
0 : otherwise
"""
function getOutput(sol, gfp, protein_lookup; threshold = TRANS_THRESHOLD)
    gfp = lowercase(gfp)
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

    NucAccum = total_conc_nuc > threshold*total_conc_cyt ? true : false

    return RTGoutput(NucAccum, total_conc_cyt, total_conc_nuc, threshold)
end

"""
Knockout specified protein with name [`prName`](@ref), and set as low concentration equal to [`DEL_CONC`](@ref)
"""
function knockout(m::RTGmodel, prName::Symbol; del_conc=DEL_CONC, WildExpLevels::NamedTuple=getExpLevels(;condition=DefaultCondition), kwags...)
    knockout_exp = setTuple(WildExpLevels, prName, del_conc)
    u = init_u(m;expLevels=knockout_exp,kwags...)
    return u
end



"""
Solve steady state of [RTGmodel](@ref) based on given initial variables (`u`). Noted that fieldname `u` is ignored.
"""
function getSteadySol(m::RTGmodel, u; ssmethod=SSMETHOD)
    #todo
    prob = DEsteady(func=m.model, u0=u, p=m.p, method=ssmethod)
    sol = solve(prob)
    return sol
end

"""
Returm [RTGmodel](@ref) with `u` in steady state.
"""
function getSteady(m::RTGmodel;warning=true, kwags...)
    # consider
    sol_ss = getSteadySol(m, m.u;kwags...)
    model = construct(m)
    m_ss = model(m,sol_ss.u, m.p, m.protein_lookup)

    # Warning
    warning && sol_ss.retcode == :Success ? @warn("Steady state not found with resid=$(sol_ss.resid)") : nothing

    return m_ss
end

