
"""
"""
function isValid(m::RTGmodel)
    #todo
end


function getSteadyU(m::RTGmodel; ssmethod=SSMETHOD)
    #todo
    prob = DEsteady(func=m.model, u0=m.u, p=m.p, method=rs.SSMETHOD)
    return solve(prob)
end

"""
"""
function getSteady(m::RTGmodel;kwags...)
    u_ss = getSteadyU(m;kwags...)
    model = construct(m)
    m_ss = model(m;u=u_ss)
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