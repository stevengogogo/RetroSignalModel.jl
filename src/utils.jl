export dudt 

"""
Parameter setting for model
"""
@with_kw struct Param
    u 
    p 
end

"""
Compartment concentration of protein
"""
@with_kw struct Protein
    n
    c
    t = n+c
end

"""
Model meta. To store information of model object, conditions, and protein lookup table
"""
struct model_meta
    model
    cond
    protein_lookup
end


"""
    model_meta(model)
Get model meta. Including the origianl model input, conditional data from csv, and protein lookup table
"""
function model_meta(model)
    cond = get_Exptable()
    protein_lookup = get_protein_lookup(model)
    return model_meta(model, cond, protein_lookup)
end

"""
Protein lookup table: reported the indexes of specify protein and location
"""
function get_protein_lookup(model)

    spec_names = string.(Catalyst.species(model))
    #=
    Create Protein lookup table with their indexes in model
    =#
    protein_lookup = Dict(
        :s => 1, # input: mitochondrial damage signal
        :Rtg1 => [ind for (ind, i) in enumerate(spec_names) if occursin("1", string(i))],
        :Rtg2 => [ind for (ind, i) in enumerate(spec_names) if occursin("2", string(i))],
        :Rtg3 => [ind for (ind, i) in enumerate(spec_names) if occursin("3", string(i))],
        :bmhmks => [ind for (ind, i) in enumerate(spec_names) if occursin("BmhMks", string(i))],
        :Bmh => [ind for (ind, i) in enumerate(spec_names) if occursin("Bmh", string(i))],
        :Mks => [ind for (ind, i) in enumerate(spec_names) if occursin("Mks", string(i))],
        :Rtg1_n => [ind for (ind,i) in enumerate(spec_names) if occursin("1", string(i)) && occursin("_n", string(i))],
        :Rtg1_c => [ind for (ind,i) in enumerate(spec_names) if occursin("1", string(i)) && occursin("_c", string(i))],
        :Rtg3_n => [ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("_n", string(i))],
        :Rtg3_c => [ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("_c", string(i))]
    )
    return protein_lookup
end


"""
Get Boolean model
"""
function get_Exptable()
    return Data.RTG_Response_Boolean
end

"""
Get Dictionary of index. Both agents (u) and parameters(p)
Example:
julia> index_dict = get_index_dictionary(MODEL);
WARNING: redefining constant index_dict
julia> index_dict.u.s
1
julia> index_dict.p.n_s
1
"""
function get_index_dictionary(model)

    u_dict = @LArray collect(1 : length(species(model)) : length(species(model))) Tuple(species(model))
    p_dict = @LArray collect(1 : length(params(model)) : length(params(model))) Tuple(params(model))

    index_dic = @LArray [u_dict, p_dict] (:u,:p)

    return index_dic
end


function linspace(start, interval, stop)
    return [start:interval:stop]
end

"""Return the derivatives of the DE model"""
function cal_dudt(model, u, p, init_t =0.0)
    du = similar(u)
    dU = model(du, u, p, init_t)
    return dU
end

"""
    dudt(model, u, p; t=nothing)
Get the derivative in given u and p from Catalyst model. 
"""
function dudt(model, u, p; t=nothing)
    ode_func! = ODEFunction(convert(ODESystem, model))
    u_ = deepcopy(u)
    ode_func!(u_, u, p, t)
    return u_
end


function dudt(u, de::T; t=nothing) where T <:FindSteadyStates.DEmeta
    return dudt(de.func, u, de.p; t=t)
end


