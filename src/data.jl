function getExpLevels(;df=DataTables.RNAseq, condition="unstressed", Max_expr=Max_expr,idxName=1)
    prNames = df[!,idxName]
    ex = df[!, condition]
    ex = capVec(ex, Max_expr)
    return NamedTuple{tuple(Symbol.(prNames)...)}(tuple(ex...))
end
getConditions(;df=DataTables.BoolCond) = df

