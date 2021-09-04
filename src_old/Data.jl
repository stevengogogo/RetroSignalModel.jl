module Data

using DataFrames
using CSV 

export RTG_Response_Boolean

filepath = joinpath(@__DIR__,"data","boolean_table_RTG13.csv")

RTG_Response_Boolean = DataFrame(CSV.File(filepath))

end
