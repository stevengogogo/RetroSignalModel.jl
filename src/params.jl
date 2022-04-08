# Parameter searching to meet the conditions
using SciMLBase
using SteadyStateDiffEq
using OrdinaryDiffEq
using ModelingToolkit

# Distributions of RTG1 and RTG3 proteins
rtg13_nucleus(sol) = sol[Rtg13I_n] + sol[Rtg13A_n]
rtg13_cytosol(sol) = sol[Rtg13I_c] + sol[Rtg13A_c]
rtg3_nucleus(sol) = rtg13_nucleus(sol) + sol[Rtg3A_n] + sol[Rtg3I_n]
rtg3_cytosol(sol) = rtg13_cytosol(sol) + sol[Rtg3A_c] + sol[Rtg3I_c]
rtg1_nucleus(sol) = rtg13_nucleus(sol) + sol[Rtg1_n]
rtg1_cytosol(sol) = rtg13_cytosol(sol) + sol[Rtg1_c]

Rodas5

"""
Scan for parameters that meet the boolean conditions in the retrograde (RTG) signalling model.
"""
function scan_params(
    Model=RtgMTK;
    datafile=joinpath(@__DIR__, "data", "boolean_table_RTG13.csv"),
    knockoutlevel=1e-6,
    nuclearRatioThreshold=10,
    trajectories=1000,
    batch_size=trajectories,
    proteinlevels=STRESSED,
    steadyStateSolver=DynamicSS(Rodas5()),
    ensembleSolver=EnsembleThreads(),
    ntarget=100,
    saveall=false,
    rollparams=() -> exp10(rand(-3:0.1:3)),
    rollhill=() -> rand(0.5:0.5:5.0)
)
    # Boolean conditions for nuclear accumulation
    conds = load_conditions(datafile)

    @named sys = Model(ONE_SIGNAL; proteinlevels)

    param2idx = Dict(k => i for (i, k) in enumerate(parameters(sys)))
    idxnRuns = param2idx[nRuns]
    idxnS = param2idx[n_S]

    prob = SteadyStateProblem(sys, resting_u0(sys))

    # Initalize parameters for the first batch
    batchParams = zeros(batch_size, length(parameters(sys)))

    # Populate parameters for the batches
    function populate_batch_params!(batchParams)
        for i in eachindex(batchParams)
            batchParams[i] = rollparams()
        end

        for i in 1:batch_size
            batchParams[i, idxnS] = rollhill()
        end
    end

    populate_batch_params!(batchParams)

    # select random param for a fresh problem
    # repeat for each conditions
    function prob_func(prob, i, iter)
        params = prob.p
        params .= view(batchParams, i % batch_size + 1, :)
        params[idxnRuns] = iter

        # Adjust params according to conditions
        cond = conds[iter]
        params[param2idx[ΣRtg1]] = ifelse(cond[:Rtg1] == 0, knockoutlevel, proteinlevels[ΣRtg1])
        params[param2idx[ΣRtg2]] = ifelse(cond[:Rtg2] == 0, knockoutlevel, proteinlevels[ΣRtg2])
        params[param2idx[ΣRtg3]] = ifelse(cond[:Rtg3] == 0, knockoutlevel, proteinlevels[ΣRtg3])
        params[param2idx[ΣMks]] = ifelse(cond[:Mks] == 0, knockoutlevel, proteinlevels[ΣMks])
        params[param2idx[mul_S]] = cond[:s]

        remake(prob, p=params)
    end

    function pass_cond(idx, conds, sol)
        cond = conds[idx]
        passed = false
        if cond[:gfp] == "rtg3"
            if cond[:Trans2Nuc] == 1
                passed = rtg3_nucleus(sol) > nuclearRatioThreshold * rtg3_cytosol(sol)
            else
                passed = nuclearRatioThreshold * rtg3_nucleus(sol) < rtg3_cytosol(sol)
            end
        elseif cond[:gfp] == "rtg1"
            if cond[:Trans2Nuc] == 1
                passed = rtg1_nucleus(sol) > nuclearRatioThreshold * rtg1_cytosol(sol)
            else
                passed = nuclearRatioThreshold * rtg1_nucleus(sol) < rtg1_cytosol(sol)
            end
        end
        return passed
    end

    # rerun when passed a condition and number for runs < number of conditions
    # otherwise, do not rerun
    function output_func(sol, i)
        idx = Int(sol.prob.p[idxnRuns])
        rerun = (idx < length(conds)) && pass_cond(idx, conds, sol)
        return (sol, rerun)
    end

    # Only add tests that passed all conditions
    function reduction(u, batch, I)

        for sol in batch
            idx = Int(sol.prob.p[idxnRuns])
            if saveall || (idx == length(conds) && pass_cond(idx, conds, sol))
                u = push!(u, sol)
            end
        end

        populate_batch_params!(batchParams)

        return (u, length(u) >= ntarget)
    end

    ensprob = EnsembleProblem(prob; output_func, prob_func, reduction)

    sim = solve(ensprob, steadyStateSolver, ensembleSolver; trajectories, batch_size)
end
