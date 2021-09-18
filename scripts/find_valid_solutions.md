
Environment

```julia
using Pkg
Pkg.status()
```

```
Status `~/RetroSignalModel.jl/scripts/Project.toml`
  [336ed68f] CSV v0.8.5
  [a93c6f00] DataFrames v1.2.2
  [413adb04] RetroSignalModel v0.1.0 `https://github.com/stevengogogo/Retro
SignalModel.jl#master`
  [295af30f] Revise v3.1.19
  [44d3d7a6] Weave v0.10.10
  [8ba89e20] Distributed
```




Load library to main worker

```julia
@time using Distributed, RetroSignalModel, CSV
import RetroSignalModel as rs
```

```
0.000180 seconds (282 allocations: 22.422 KiB)
```




Add workers

```julia
addprocs(exeflags="--project=$(Base.active_project())");
@show nprocs();
```

```
nprocs() = 33
```




Load library to workers

```julia
@time @everywhere using RetroSignalModel;
```

```
24.164095 seconds (3.01 k allocations: 118.391 KiB)
```




Parameter searching

```julia
@time df = rs.paramSearching(rs.rtgM4(); num_sim=100, distributed=true, saveall=true)
```

```
Error: MethodError: objects of type Module are not callable
```






```julia
CSV.write("data/valid_sol.csv", df)
```

```
Error: UndefVarError: df not defined
```


