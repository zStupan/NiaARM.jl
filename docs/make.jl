using Documenter
using NiaARM

makedocs(
    sitename = "NiaARM.jl",
    format = Documenter.HTML(),
    modules = [NiaARM]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
