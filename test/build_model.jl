models = [
    rs.actM1(),
    rs.rtgM1(),
    rs.rtgM2(),
    rs.rtgM3(),
    rs.rtgM4(),
]

getSteadyU.(models)
getSteady.(models)
[knockout(m, "rtg1") for m in models] 

@test isValid(rs.rtgM4()) == true
@test isSteady(rs.rtgM4()) == true
