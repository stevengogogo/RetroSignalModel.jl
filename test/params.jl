const nRuns = 10

sim = scan_params(; trajectories=nRuns, saveall=true)

@test length(sim) == nRuns