
function get_protein_lookup(m::RTGmodel)
    return get_protein_lookup(m.model)
end

"""
Protein lookup table: reported the indexes of specify protein and location
"""
function get_protein_lookup(model::ReactionSystem)

    spec_names = catalyst_name(model)

    #=
    Create Protein lookup table with their indexes in model
    =#
    protein_lookup = Dict(
        :s => 1, # input: mitochondrial damage signal
        :Rtg1 => findID(spec_names, ["1"]),
        :Rtg2 => findID(spec_names, ["2"]),
        :Rtg3 => findID(spec_names, ["3"]),
        :Bmh => findID(spec_names, ["Bmh"]),
        :Mks => findID(spec_names, ["Mks"]),
        :bmhmks => findID(spec_names, ["BmhMks"]),
        :Rtg1_n => findID(spec_names, ["1", "_n"]),#[ind for (ind,i) in enumerate(spec_names) if occursin("1", string(i)) && occursin("_n", string(i))],
        :Rtg1_c => findID(spec_names, ["1", "_c"]),#[ind for (ind,i) in enumerate(spec_names) if occursin("1", string(i)) && occursin("_c", string(i))],
        :Rtg3_n => findID(spec_names, ["3", "_n"]),#[ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("_n", string(i))],
        :Rtg3_c => findID(spec_names, ["3", "_c"]),#[ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("_c", string(i))],
        :Rtg13_c => findID(spec_names, ["1", "3","_c"]), #[ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("1", string(i)) && occursin("_c", string(i))],
        :Rtg13_n => findID(spec_names, ["1", "3","_n"]), #[ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("1", string(i)) && occursin("_n", string(i))],
        :Rtg13 => findID(spec_names, ["1","3"]),#[ind for (ind,i) in enumerate(spec_names) if occursin("3", string(i)) && occursin("1", string(i))]
    )
    return protein_lookup
end

function _find_id(df, ext_func)
    maxID = -1
    for k in keys(df)
        maxID = ext_func([df[k]..., maxID])
    end
    return maxID
end

"""
Change tuple element and return a new one
"""
function setTuple(tup, fieldname, newVal)
    newT = NamedTuple{tuple(fieldname)}(newVal)
    return merge(tup, newT)
end

"""
Create initial values of reaction systems based on protein total concentration.
Each concentration is solved by Linear programming.
"""
function init_u(model::ReactionSystem, protein_lookup; expLevels=getExpLevels(;condition=DefaultCondition), idx_s::Integer = 1, init_s=S_SPAN[1], optimizer=GLPK.Optimizer)
    RTGm = jp.Model(optimizer)
    numVar = _find_id(protein_lookup, maximum) 
    jp.@variables(RTGm, begin 
        us[1:numVar] >= 0
    end)

    # Add constraints
    consts = []
    for k in keys(expLevels)
        pr_idx = protein_lookup[k]
        push!(consts, jp.@constraint(RTGm, sum(us[pr_idx]) == expLevels[k]))
        jp.set_name(consts[end], string(k))
    end

    jp.optimize!(RTGm)
    u_opt = jp.value.(us)
    u_opt[idx_s] = init_s

    # U vec constructor 
    U = @SLVector tuple(Symbol.(catalyst_name(model))...)

    return U(u_opt...)
end

function init_u(m::RTGmodel;kwags...)
    return init_u(m.model, m.protein_lookup;kwags...)
end



function init_p(m::ReactionSystem; idx_hill_coefs=[1], K_dist=K_dist, K_N_dist=K_N_dist)
    p = rand(K_dist, length(Catalyst.params(m)))
    for i in idx_hill_coefs
        p[i] = rand(K_N_dist)
    end

    Names = catalyst_name(m;fcall=Catalyst.params)

    U = @SLVector tuple(Symbol.(Names)...)
    return U(p...)
end