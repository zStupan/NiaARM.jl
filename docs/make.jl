using Documenter
using NiaARM

makedocs(
    sitename = "NiaARM.jl",
    format = Documenter.HTML(),
    modules = [NiaARM],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "getting_started.md",
            "interestingness_measures.md",
            "algorithms.md",
            "visualization.md",
        ],
        "API Reference" => "api_reference.md",
        "About" => [
            "contributing.md",
            "code_of_conduct.md",
            "license.md",

        ]
    ],
)


deploydocs(
    repo = "https://github.com/firefly-cpp/NiaARM.jl",
    push_preview = true,
)
