var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = RetroSignalModel","category":"page"},{"location":"#RetroSignalModel","page":"Home","title":"RetroSignalModel","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [RetroSignalModel]\nOrder   = [:type, :function, :constant]","category":"page"},{"location":"#RetroSignalModel.actM1_model-Tuple{}","page":"Home","title":"RetroSignalModel.actM1_model","text":"Activation Model:\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.capVec-Tuple{Any, Any}","page":"Home","title":"RetroSignalModel.capVec","text":"Scale maximum element to capVal. v is a vector\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.construct-Tuple{Any}","page":"Home","title":"RetroSignalModel.construct","text":"Get constructor from a data type\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.getOutput-Tuple{Any, Any, Any}","page":"Home","title":"RetroSignalModel.getOutput","text":"Compare the cytosolic concentration of either 'rtg1' or 'rtg3' with their nucleus concentrations. Output: 1 : nucleus concentration is higher than the cytosolic one 0 : otherwise\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.getSteady-Tuple{RetroSignalModel.RTGmodel}","page":"Home","title":"RetroSignalModel.getSteady","text":"Returm RTGmodel with u in steady state.\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.getSteadySol-Tuple{RetroSignalModel.RTGmodel, Any}","page":"Home","title":"RetroSignalModel.getSteadySol","text":"Solve steady state of RTGmodel based on given initial variables (u). Noted that fieldname u is ignored.\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.get_protein_lookup-Tuple{ModelingToolkit.ReactionSystem}","page":"Home","title":"RetroSignalModel.get_protein_lookup","text":"Protein lookup table: reported the indexes of specify protein and location\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.init_u-Tuple{ModelingToolkit.ReactionSystem, Any}","page":"Home","title":"RetroSignalModel.init_u","text":"Create initial values of reaction systems based on protein total concentration. Each concentration is solved by Linear programming.\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.isValid-Tuple{RetroSignalModel.RTGmodel}","page":"Home","title":"RetroSignalModel.isValid","text":"Validate responses \n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.knockout-Tuple{RetroSignalModel.RTGmodel, Any}","page":"Home","title":"RetroSignalModel.knockout","text":"Knockout specified protein with name prName, and set as low concentration equal to DEL_CONC\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.paramSearching-Tuple{RetroSignalModel.RTGmodel}","page":"Home","title":"RetroSignalModel.paramSearching","text":"Parameter searching Api. It can be run in single core or multiple-processing\n\nPerformance\n\njulia> addprocs(exeflags=\"--project=/home/runner/work/RetroSignalModel.jl/RetroSignalModel.jl/docs/Project.toml\");\njulia> @time @everywhere using RetroSignalModel\njulia> nprocs()\n9\njulia> @time rs.paramSearching(rs.rtgM4(); num_sim=100, distributed=true, saveall=true)\n  2.378919 seconds (78.95 k allocations: 4.964 MiB)\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.paramSearching_Once-Tuple{RetroSignalModel.RTGmodel}","page":"Home","title":"RetroSignalModel.paramSearching_Once","text":"Sampling one parameter set for validation\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM1_model-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM1_model","text":"Rtg Model: version 1\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM2_model-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM2_model","text":"This model is modified version of rtgM1. Major changes:\n\nChange input to be michaelis menten\nChange the translocation to be Michaelis menten\nRtg1p and Rtg3p enter nucleus separately\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM3_model-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM3_model","text":"This model is modified version of rtgM2. Major changes:\n\nChange input to be michaelis menten\nChange the translocation to be Michaelis menten: (which is not ture). See supplemental material\nRtg1p and Rtg3p enter nucleus separately\n\nReferences\n\nHao, N., Budnik, B. A., Gunawardena, J., & O'Shea, E. K. (2013). Tunable signal processing through modular control of transcription factor translocation. Science, 339(6118), 460-464. [Article, SOM]\nMitochondrial Signaling: The Retrograde Response. 2004. (Reaction of Bmh-Mks on Rtg13 dimer) [Article]\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM4_model-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM4_model","text":"Modified version from rtgM3\n\nChange input to Hill kinetics\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM4_p-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM4_p","text":"A valid parameter set\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.rtgM4_u-Tuple{}","page":"Home","title":"RetroSignalModel.rtgM4_u","text":"\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.setTuple-Tuple{Any, Any, Any}","page":"Home","title":"RetroSignalModel.setTuple","text":"Change tuple element and return a new one\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.setTuples-Tuple{Any, Any, Any}","page":"Home","title":"RetroSignalModel.setTuples","text":"Change tuple elements and return a new one\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.try_conditions-Tuple{RetroSignalModel.RTGmodel}","page":"Home","title":"RetroSignalModel.try_conditions","text":"Try conditions of the model with given initial variables and parameters.\n\n\n\n\n\n","category":"method"},{"location":"#RetroSignalModel.K_dist","page":"Home","title":"RetroSignalModel.K_dist","text":"Parameter searching\n\n\n\n\n\n","category":"constant"},{"location":"#RetroSignalModel.SSMETHOD","page":"Home","title":"RetroSignalModel.SSMETHOD","text":"Steady state solver. \n\nA Stiff solver is chosen TRBDF2 (stand for Tranpezoidal Backward Differeital Formula) from DifferentialEquations.jl for robust simulation of stability. \n\nTRBF2 is a one-step method based on trapezoidal rule and the backward differentiaion formula of order 2, and it is strongly L-stable that means TRBFS is good at integrating stiff equations [1]. \n\nReferences\n\nHosea, M. E., & Shampine, L. F. (1996). Analysis and implementation of TR-BDF2. Applied Numerical Mathematics, 20(1-2), 21-37. URL: https://www.sciencedirect.com/science/article/pii/0168927495001158?via%3Dihub\nDifferentialEqiations.jl - Stiff Problems. [link]\n\n\n\n\n\n","category":"constant"}]
}
