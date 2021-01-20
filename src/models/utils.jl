#=
    MM(chem, k, kd) 

Michaelis Menten Equation

Reference
---------
1. Michaelis Menten. Wikipidia.
=#
MM(chem, k, kd)= k* chem / (kd + chem)

#=
    HILL(chem, k, kd, n)
Hill equation. 'k' is the activation coefficient; `kd` is the half-speed concentration, and `n` is Hill coefficient.
=#
HILL(chem, k, kd, n) = k* chem^n / (kd^n + chem^n)