"""
For testing the Michaelis-Menten and Hill function in  'models/utils.jl'. 

Limitation
----------
1. `@reaction_func` is not documentable
2. `@reaction_func` can not return or be seen in the `Main`.

See Also
--------
1. [Issue](https://github.com/SciML/Catalyst.jl/issues/278)
"""


@testset "Michaelis Menten" begin 

mm_func = RetroSignalModel.MM 

chem, k, kd = 2.0, 3.0, 2.0

MM(chem, k, kd)= k* chem / (kd + chem)
HILL(chem, k, kd, n) = k* chem^n / (kd^n + chem^n)

@test MM(chem, k, kd) == 0.5*k
@test HILL(0, k, kd, 1) == 0

end