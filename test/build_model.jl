models = [
    rs.actM1(),
    rs.rtgM1(),
    rs.rtgM2(),
    rs.rtgM3(),
    rs.rtgM4(),
]

rs.getSteady.(models)
[rs.knockout(m, "rtg1") for m in models] 

@test rs.isValid(rs.rtgM4()) == true
@test rs.isSteady(rs.rtgM4()) == true
