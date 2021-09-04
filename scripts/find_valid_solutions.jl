using Pkg 
Pkg.activate(@__DIR__)
Pkg.instantiate()

@time using Distributed, CSV, DataFrames, RetroSignalModel


# Add workers
Ncore = max(0, Sys.CPU_THREADS - 1 - nprocs())
addprocs(Ncore, exeflags="--project=$(Base.active_project())");
@show nprocs();

@time @everywhere using Distributed, CSV, DataFrames, RetroSignalModel


function mergelistDF(p)
    for i = 2:length(p)
       for key in keys(p[1])
           append!(p[1][key], p[i][key])
       end
   end

   df = DataFrame(; [Symbol(k)=>v for (k,v) in p[1]]...)

   return df
end



function main(;num_sim=3, savename="simulation/trial_rtgM4", saveall=true)

    futures = Array{Future}(undef, nworkers())

    for (i,id) in enumerate(workers())
        futures[i] = @spawnat id Parameter_searching.simulate(;num_sim=num_sim, saveall=saveall)
    end

    # Parallel Simulation
    p = fetch.(futures)

    # Merge
    res = mergelistDF(p)

    # Save
    savename= Parameter_searching.Naming.avoidDup!(savename, num_sim*nworkers())
    CSV.write(savename,  DataFrame(res))



    # Printout
    if size(res)[1] == 0
        found = 0
        total = num_sim*nworkers()
    else
        found = Int(sum(res[!,:validity]))
        total = length(res[!,:validity])
    end

    println("==============================================")
    println("Found $found / $total Valid set ")
    println("DONE: $savename created.")


end

