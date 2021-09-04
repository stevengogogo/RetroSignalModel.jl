
"""
"""
function isValid(m::RTGmodel)
    #todo
end

"""
"""
function isSteady(m::RTGmodel)
    if ismissing(m.u) || ismissing(m.p)
        return false
    end

    
    #todo 
end

function getSteadyU(m::RTGmodel)
    #todo
end

function getSteady(m::RTGmodel)
    #todo
end

function knockout(m::RTGmodel, prName; del_conc=DEL_CONC)
    #todo
end

function getConditions(;csvPath=COND_DATA_PATH)
    RTG_Response_Boolean = DataFrame(CSV.File(csvPath))
    return RTG_Response_Boolean 
end