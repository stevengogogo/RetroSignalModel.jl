
"""Join local path"""
spt_ph(path; dir="")= joinpath( dirname(@__FILE__), dir,path)