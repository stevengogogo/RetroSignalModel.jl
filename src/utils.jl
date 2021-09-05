readCSV(fn) = DataFrame(CSV.File(fn))

function getTables(csv_fns::NamedTuple)
    dfs = [] 
    for fn in csv_fns 
        push!(dfs, readCSV(fn))
    end
    return NamedTuple{keys(csv_fns)}(tuple(dfs...))
end

"""
Get constructor from a data type
"""
construct(datatype) = typeof(datatype).name.wrapper


function findID(sNames, features; convert_lower = true)
    sNames = convert_lower ? lowercase.(sNames) : sNames
    features = convert_lower ? lowercase.(features) : features
    idxs = Vector{Int}()
    for (ind, i) in enumerate(sNames)
        isEle = true
        for f in features
            if occursin(f, string(i)) == false 
                isEle = false
                break
            end
        end
        isEle ? push!(idxs, ind) : nothing
    end
    return idxs
end
