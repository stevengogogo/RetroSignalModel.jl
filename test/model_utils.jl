
model = RetroSignalModel.rtgM4.model



mod = RetroSignalModel.model_meta(model)


getfield.([mod], [:model, :cond, :protein_lookup])