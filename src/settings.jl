const COND_DATA_PATH = joinpath(@__DIR__,"data","boolean_table_RTG13.csv")
const DEL_CONC = 1e-4

"""
Steady state solver
"""
const SSMETHOD = DynamicSS(AutoTsit5(Rosenbrock23()))

const DataFiles = (;
    RNAseq= joinpath(@__DIR__,"data","RNAseq_RTG_expression.csv"),
    BoolCond = joinpath(@__DIR__,"data","boolean_table_RTG13.csv")
)

"""
Parameter searching
"""
const K_dist = Exponential(1000)
const K_N_dist = Geometric(0.3) + 1
const S_SPAN = (1e-6,1.0)

const DataTables = getTables(DataFiles)