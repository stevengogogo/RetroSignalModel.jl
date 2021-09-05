@with_kw struct rtgM4{A,B,C} <: RTGmodel
    model::A = rtgM4_model()
    u::B = rtgM4_u()
    p::C = rtgM4_p()
    protein_lookup = model
end



"""
Modified version from rtgM3
1. Change input to Hill kinetics
"""
function rtgM4_model()
    model= @reaction_network begin
        #=
        Input
        =#
        (1), s→s

        #=
        Modulation Layer
        =#
        (hill(s, ksV, ksD, n_s), k2I), Rtg2_ina_c ↔ Rtg2_act_c #[1]
        (k2M, kn2M), Rtg2_act_c + Mks ↔ Rtg2Mks_c
        (kBM, knBM), Bmh + Mks ↔ BmhMks

        #=
        Activation Model:
        =#
        # NLSact: Nuclear Localization Signal (NLS) activation
        (k13I + mm(BmhMks, k13IV, k13ID)), Rtg13_a_c → Rtg13_i_c
        (k3A_c, k3I_c), Rtg3_i_c ↔ Rtg3_a_c
        (k3I_n), Rtg3_a_n → Rtg3_i_n

        # Rtg1Binding: Rtg13 formation
        (k13_c, kn13_c), Rtg1_c + Rtg3_a_c ↔ Rtg13_a_c
        (k13_c, kn13_c), Rtg1_c + Rtg3_i_c ↔ Rtg13_i_c

        (k13_n, kn13_n), Rtg1_n + Rtg3_a_n ↔ Rtg13_a_n #[3]
        (k13_n, kn13_n), Rtg1_n + Rtg3_i_n ↔ Rtg13_i_n #[3]

        # Translocation
        (k1in , k1out), Rtg1_c ↔ Rtg1_n #[2]
        (k3inA, k3outA), Rtg3_a_c ↔ Rtg3_a_n #[2]
        (k3inI, k3outI), Rtg3_i_c ↔ Rtg3_i_n

        #(k4, kn4), Rtg13_a_c ↔ Rtg13_a_n # Deleted [2]
    end n_s ksV ksD k2I k2M kn2M kBM knBM k13I k13IV k13ID k3A_c k3I_c k3I_n k13_c kn13_c k13_n kn13_n k1in k1out k3inA k3outA k3inI k3outI
end

function rtgM4_u()
    u = (;
        s = 0.0,
        Rtg2_ina_c = 651.6543766184084,
        Rtg2_act_c = 0.0,
        Mks = 0.4062432721006166,
        Rtg2Mks_c = 0.0,
        Bmh = 9732.909523047472,
        BmhMks = 267.09047695253264,
        Rtg13_a_c = 1.4274087263484285,
        Rtg13_i_c = 17.714161994146533,
        Rtg3_i_c = 227.17595080074952,
        Rtg3_a_c = 36.19618619564863,
        Rtg3_a_n = 65.76199082382354,
        Rtg3_i_n = 0.45661180302819115,
        Rtg1_c = 58.80414604200244,
        Rtg1_n = 7.203337949792787,
        Rtg13_a_n = 60.352251822015404,
        Rtg13_i_n = 0.4190498225319596
    )
    return u
end


function rtgM4_p()
    p = (;
        n_s= 7.0,
        ksV= 11.672453857459798,
        ksD= 0.9652060600816972,
        k2I= 4.947912367971165,
        k2M= 1604.1502827169095,
        kn2M= 0.04254255493422655,
        kBM= 0.05895557134274864,
        knBM= 2.412620893447476,
        k13I= 0.09229304669754668,
        k13IV= 2484.2634221986104,
        k13ID= 25.13534590431395,
        k3A_c= 30.70305169723245,
        k3I_c= 0.012479519278799235,
        k3I_n= 1.4869621407220823,
        k13_c= 233.8066917491108,
        kn13_c= 220.91514234006863,
        k13_n= 461.0270088897297,
        kn13_n= 0.595848762435901,
        k1in= 3.196651589365529,
        k1out= 5967.990311992441,
        k3inA= 1.024908423419303,
        k3outA= 0.048990374555417784,
        k3inI= 0.03795742242697436,
        k3outI= 0.12330849328071895
    )
    return p
end