
"""
"""
function isValid(m::RTGmodel)
    #todo
end


function getSteadySol(m::RTGmodel; ssmethod=SSMETHOD)
    #todo
    prob = DEsteady(func=m.model, u0=m.u, p=m.p, method=ssmethod)
    sol = solve(prob)
    return sol
end

"""
Returm RTGmodel with `u` in steady state
"""
function getSteady(m::RTGmodel;warning=true, kwags...)
    sol_ss = getSteadySol(m;kwags...)
    model = construct(m)
    m_ss = model(m;u=sol_ss.u)

    # Warning
    warning && sol_ss.retcode == :Success ? @warn("Steady state not found with resid=$(sol_ss.resid)") : nothing

    return m_ss
end

function knockout(m::RTGmodel, prName; del_conc=DEL_CONC)
    #todo
end

function getConditions(;csvPath=COND_DATA_PATH)
    RTG_Response_Boolean = DataFrame(CSV.File(csvPath))
    return RTG_Response_Boolean 
end



"""
Get constructor from a data type
"""
construct(datatype) = typeof(datatype).name.wrapper