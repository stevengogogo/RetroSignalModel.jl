@with_kw struct setting
    "Model"
    MODEL = rtgM4.model

    "Validation"
    DEL_CONC=1e-4
    TRANS_THRESHOLD = 1.5
    val_tspan = (0.,100.)
    SSMETHOD = DynamicSS(AutoTsit5(Rosenbrock23()))


    "Sampling"
    #Domain of Maximum Concentration
    CONC_SPAN = (1e-6, 10000.0)

    #Domain of Parameter Ranges"
    K_SPAN = (0.01,10000.)
    K_N_SPAN = (1.,16.)
    S_SPAN = (1e-6,1.0)

    #Base of Loguniform"
    BASE_SAMP = 10 # Uniform
    VAR_RATIO = 0.5 #∈(0,1)

    # Sampling Hill number
    ODDS = true #for hill number. Sampling Hill with ODD number. False: Don't care

    #=
    Relative Quantative order of parameters
    Description:
    1&2: NLS parameters.

    Ref:
    1&2: https://science.sciencemag.org/content/339/6118/460.long
    =#
    order_params = [
        [:k3inA, :k3outA],
        [:k3outI, :k3inI]
    ]


    #=
    The relative total concentration between RTG genes.
    The relation is based on (1:stressed and 2:unstressed) condition.
    Bmh is set to be the baseline (=1), and the actually sequencing amount is 1239.4666
    Ref:
    1. https://github.com/stevengogogo/MitochondrialRetrogradeSignaling/tree/master/rna_seq
    2. GSE102475
    =#
    rna_expr = SLVector(
        Bmh= (1611.5946, 1239.5666),
        Rtg1= (17.2068, 18.0878),
        Rtg2= (221.9025, 80.7769),
        Rtg3= (25.7976, 50.7607),
        Mks=  (47.8059,33.158)
    )

    solution_filename = Data.filepath
    var_ratio_of_gamma = 10.

end 