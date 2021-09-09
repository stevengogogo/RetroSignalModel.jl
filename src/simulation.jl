"""
Validate responses 
"""
function isValid(m::RTGmodel)
    #todo
end

function getOutput(m::RTGmodel)
    #todo
end

"""
"""
function knockout(m::RTGmodel, prName; del_conc=DEL_CONC)
    #todo
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

