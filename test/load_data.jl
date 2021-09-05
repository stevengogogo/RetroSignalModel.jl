@testset "Check file availability" for fn in rs.DataFiles
    @test isfile(fn)
    df = DataFrame(CSV.File(fn))
end

exp = rs.getExpLevels()
cond = rs.getConditions()

prNamesRNA = ["rtg1", "rtg2", "rtg3", "bmh", "mks"]
prNamesCond = ["rtg1", "rtg2", "rtg3", "mks"]


@testset "Protein name availability (RNA-Seq)" for pr in prNamesRNA 
    @test pr in exp."protein"
end
@testset "Protein name availability (Conditions)" for pr in prNamesCond
    @test pr in names(cond)
end

@test "s" in names(cond)
@test "gfp" in names(cond)
@test "Trans2Nuc" in names(cond)

@test "protein" in names(exp)
