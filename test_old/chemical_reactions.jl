"""
For testing the Michaelis-Menten and Hill function in  'models/utils.jl'. 



See Also
--------
1. [Issue](https://github.com/SciML/Catalyst.jl/issues/278)
"""


@testset "Michaelis Menten" begin 



chem, k, kd = 2.0, 3.0, 2.0

MM(chem, k, kd)= k* chem / (kd + chem)
HILL(chem, k, kd, n) = k* chem^n / (kd^n + chem^n)

@test MM(chem, k, kd) == 0.5*k
@test HILL(0, k, kd, 1) == 0

end