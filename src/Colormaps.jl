module Colormaps

using PyCall
@pyimport importlib
using PyPlot
@pyimport matplotlib.colors as COL

data_dir = joinpath(Pkg.dir("Colormaps"), "data")
for file in filter(f -> ismatch(r"\.py$", f), readdir(data_dir))
    cmap_name = replace(rsplit(file, ".", limit=2)[1], ".", "_")
    mod = importlib.machinery[:SourceFileLoader](cmap_name,
                                                 joinpath(data_dir,file))[:load_module]()
    try
        plt[:cm][:get_cmap](cmap_name)
    catch
        cmap = COL.ListedColormap(mod[:cm_data], name=cmap_name)
        register_cmap(cmap_name, cmap)
    end
end

end # module
