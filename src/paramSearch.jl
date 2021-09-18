# Parameter searching api

"""
Parameter searching Api. It can be run in single core or multiple-processing

Performance
------------
```
julia> addprocs(exeflags="--project=$(Base.active_project())");
julia> @time @everywhere using RetroSignalModel
julia> nprocs()
9
julia> @time rs.paramSearching(rs.rtgM4(); num_sim=100, distributed=true, saveall=true)
  2.378919 seconds (78.95 k allocations: 4.964 MiB)
```
"""
function paramSearching(m::RTGmodel;num_sim::Int64=10, distributed=false, batch_size=nprocs(), Break=false, saveall=true, idx_hill_coefs=[1], K_dist=K_dist, K_N_dist=K_N_dist,conditions=getConditions(;df=DataTables.BoolCond),ssmethod=SSMETHOD,kwags...)
    #create table 
    df = get_search_df(m, conditions)

    # parameter searching 
    res = @showprogress pmap( x->paramSearching_Once(x[1];conditions=x[2], x[3]...), 
                            fill([m, conditions, kwags], num_sim),
                            distributed=distributed,
                            batch_size=batch_size)

    # Merge result
    map(r-> push_sim!(df, r.test_log, r.p, r.u), res)

    return df
end


"""
Parameter searching for RTG model.

Method 
------
1. Random sampling based on distribution [`K_dist`](@ref), [`K_N_dist`](@ref)

Performance
------------
```
BenchmarkTools.Trial: 389 samples with 1 evaluation.
Range (min … max):   5.758 ms … 63.790 ms  ┊ GC (min … max): 0.00% … 41.05%
Time  (median):      9.910 ms              ┊ GC (median):    0.00%
Time  (mean ± σ):   12.907 ms ±  9.385 ms  ┊ GC (mean ± σ):  4.72% ±  9.37%

█▆      ▁▆▂      ▂▂▁      ▁                                  
██▄▁▅▄▆▄███▅▄▁▅▄▇███▁▁▁▁▁▆███▄▁▄▁▆▆▆▅▁▁▁▁▅▄▅▅▆▄▁▅▁▁▁▁▁▁▄▄▁▄ ▆
5.76 ms      Histogram: log(frequency) by time      46.9 ms <

Memory estimate: 1.72 MiB, allocs estimate: 38861.
```
"""
function paramSearching_OneCore(m::RTGmodel;num_sim::Int64=10, Break=false, saveall=true, idx_hill_coefs=[1], K_dist=K_dist, K_N_dist=K_N_dist,conditions=getConditions(;df=DataTables.BoolCond),ssmethod=SSMETHOD,kwags...)

    #create table 
    df = get_search_df(m, conditions)

    # parameter searching 
    res = @showprogress map( x->paramSearching_Once(x[1];conditions=x[2], x[3]...), 
                            fill([m, conditions, kwags], num_sim))

    # Merge result
    map(r-> push_sim!(df, r.test_log, r.p, r.u), res)

    return df
end

"""
Sampling one parameter set for validation
"""
function paramSearching_Once(m::RTGmodel;Break=false, idx_hill_coefs=[1], K_dist=K_dist, K_N_dist=K_N_dist,conditions=getConditions(;df=DataTables.BoolCond),ssmethod=SSMETHOD,kwags...)
    # Sampling parameters 
    p = init_p(m.model;idx_hill_coefs=idx_hill_coefs, K_dist=K_dist, K_N_dist=K_N_dist)
    m.p[:] = p 

    u = getSteadySol(m, m.u; ssmethod=ssmethod).u

    # Test validity
    isValid, test_log = try_conditions(m;conditions=conditions, Break=Break,kwags...)

    return (; isValid=isValid, test_log=test_log, u=u, p=p)
end


# Data processing
function get_search_df(m, conditions)
    # Labels
    condNs = ["condition $i" for i in range(1,stop= size(conditions)[1])]
    pNs = string.(keys(init_p(m.model)))
    uNames = string.(keys(init_u(m)))
    # Create empty dataframe
    df_key = [condNs..., pNs...,uNames...]
    trials = DataFrame( [ [] for i in eachindex(df_key) ], df_key)

    return trials
end

function push_sim!(df, conds, ps, us)
    vec = [conds..., ps...,us...]
    push!(df, vec)
end