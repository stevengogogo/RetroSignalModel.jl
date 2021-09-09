function getExpLevels(;df=DataTables.RNAseq, condition="stressed", idxName=1)
    prNames = df[!,idxName]
    ex = df[!, condition]
    return NamedTuple{tuple(Symbol.(prNames)...)}(tuple(ex...))
end
getConditions(;df=DataTables.BoolCond) = df