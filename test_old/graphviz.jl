#=
Simple model comes from Catalyst documentation: 
https://catalyst.sciml.ai/stable/#Illustrative-Example
=#


svg_dir = "aux"
svg_dir = spt_ph(svg_dir)

isdir(svg_dir) ? nothing : mkdir(svg_dir) 

@testset "visualize simple model" begin 

    rn = @reaction_network begin
        α, S + I --> 2I
        β, I --> R
    end α β

    g = Graph(rn)
    Catalyst.savegraph(g, joinpath(svg_dir,"simple_model.svg"), "svg" )

end

@testset "visualize rtgM4" begin
    
    model = RetroSignalModel.rtgM4.model

    g = Graph(model)
    Catalyst.savegraph(g, joinpath(svg_dir,"rtgM4.svg"), "svg" )
end