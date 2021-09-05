
function get_protein_lookup(m::RTGmodel)
    return get_protein_lookup(m.model)
end

"""
Protein lookup table: reported the indexes of specify protein and location
"""
function get_protein_lookup(model::ReactionSystem)

    spec_names_t = string.(Catalyst.species(model))
    spec_names = replace.(spec_names_t, "(t)"=>"")

    #=
    Create Protein lookup table with their indexes in model
    =#
    protein_lookup = Dict(
        :s => 1, # input: mitochondrial damage signal
        :Rtg1 => findID(spec_names, ["1"]),
        :Rtg2 => findID(spec_names, ["2"]),
        :Rtg3 => findID(spec_names, ["3"]),
        :bmhmks => findID(spec_names, ["BmhMks"]),
        :Bmh => findID(spec_names, ["Bmh"]),
        :Mks => findID(spec_names, ["Mks"]),
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
