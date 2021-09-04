
model = RetroSignalModel.rtgM4.model

odesys = convert(ODESystem, model)

tex = latexify(model)
eqs = latexify(odesys)

tex = replace(tex, "\\require{mhchem}"=>"\n")
eqs = replace(eqs, "{align}"=>"{aligned}")

open(spt_ph("eqs.tex"; dir="aux"), "w") do io
    write(io, "\\documentclass[12pt]{article}\n\\usepackage[version=3]{mhchem}\n\\usepackage{amsmath}\n\\begin{document}\n")

    write.([io], [tex, "\n", eqs])

    write(io, "\n\\end{document}")
end

