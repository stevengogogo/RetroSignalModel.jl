@testset "Check file availability" for fn in rs.DataFiles
    @test isfile(fn)
    df = DataFrame(CSV.File(fn))
end

exp = rs.getExpLevels()
cond = rs.getConditions()

prNamesRNA = [:Rtg1, :Rtg2, :Rtg3, :Bmh, :Mks]
prNamesCond = ["Rtg1", "Rtg2", "Rtg3", "Mks"]


@testset "Protein name availability (RNA-Seq)" for pr in prNamesRNA 
    @test pr in collect(keys(exp))
end
@testset "Protein name availability (Conditions)" for pr in prNamesCond
    @test pr in names(cond)
end

@test "s" in names(cond)
@test "gfp" in names(cond)
@test "Trans2Nuc" in names(cond)