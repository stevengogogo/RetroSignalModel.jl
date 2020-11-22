"""
Confirm the size and names are same with the reaction_network model
"""
# Test model 
model = RetroSignalModel.rtgM4.model
param = RetroSignalModel.rtgM4.param()
names_u = string.(species(RetroSignalModel.rtgM4.model))
names_p = string.(params(RetroSignalModel.rtgM4.model))

names_u_valid = keys(param.u)
names_p_valid = keys(param.p)

# Number of parameters
num_par  = length(model.ps)
# Number of proteins 
num_species = length(model.states)

# Valid Parameter



# Test 

## Length of parameters
@test length(param.u) == num_species
@test length(param.p) == num_par

## Test compatibility between names of given parameter set and model
@testset "Protein names" for (model_n,n) in zip(names_u, names_u_valid )
    n = string(n, "(t)") # arguements
    @test n == model_n
end

@testset "Parmeter names" for (model_n,n) in zip(names_p, names_p_valid)
    n = string(n)
    @test n == model_n
end