function test_sampling(model, u; kwags... )

    p = sampling_params(model)
    valid, test_log= try_conditions(u,p, valid_setting(model);kwags... )

    return u,p,valid, test_log
end


function simulate(model;num_sim=1, BREAK=false, saveall=true)
    cond = RTG_Response_Boolean
    sim_results = ["condition $i" for i in range(1,stop= size(cond)[1])]

    syms_str = replace.(string.(species(model)), "(t)"=>"")
    params_str = string.(Catalyst.params(model))

    df_key = [syms_str..., params_str..., "validity", sim_results...,"Steady"]

    trials = Dict(zip(df_key, [ [] for i in eachindex(df_key) ]))


    try
        for i in tqdm(1:num_sim)
            u,p,valid, test_log, steady = test_sampling(model, u)

           # Avoid StackOverflowError
           if valid == 1
               if try_simulate(model, p, u) == 0
                   valid = 0
               end
           end

           # Create Summary Result
           if saveall # Save Each Step
               df = Dict( df_key .=> [u;p;valid; test_log; steady] )
               # append dictionary
               trials = appendDict(trials, df)
           elseif valid == 1
               df = Dict( df_key .=> [u;p;valid; test_log; steady] )
               # append dictionary
               trials = appendDict(trials, df)
           end

           # Print Instance Trial
            if valid == 1
                println("valid result")
                println("u : $u")
                println("p:  $p")

                # Save sol
                try
                    CSV.write("SOL_rtg4_$i.csv", DataFrame(df))

                catch e
                    print("Save error: $e")
                end

                if BREAK
                    break
                end

            # Print Pogress
            elseif i%1000==0

                println("$i/$num_sim")

            end
        end
    catch e
        print("$e\n")
        return trials
    end

     #DataFrame(trials)
     return trials
end