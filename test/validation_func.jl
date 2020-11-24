"""
Objectives
----------
1. The given parameter set should be compatible with the data.
2. Meaure the time used for solution  
"""

model = rtgM4.model 

setting_ = valid_setting(model)

param = rtgM4.param()

@time valid, test_log = try_conditions(param.u, param.p, setting_)

@assert valid == 1
@assert length(test_log) == size(setting_.cond)[1]
