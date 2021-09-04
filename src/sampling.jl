function sampling_params(m::ReactionSystem;idx_n::Integer = 1, idx_s::Integer=1, Setting=setting())
    p = rand(Setting.K_dist,length(params(m)))
    p[idx_n] = convert(typeof(p[1]), rand(Setting.K_N_dist))
    return p
end