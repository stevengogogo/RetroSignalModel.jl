
const COND_DATA_PATH = joinpath(@__DIR__,"data","boolean_table_RTG13.csv")
const DEL_CONC = 1e-4

"""
Steady state solver
"""
const SSMETHOD = DynamicSS(AutoTsit5(Rosenbrock23()))