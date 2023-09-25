include("Solution.jl")

function benchmark(method::Function, localSearch::Union{Swap, TwoOpt, Relocate})
    solution = localSearch.solution
    @info "Basic greedy solution" solution.route solution.cost
    startingCost = solution.cost

    while(method(localSearch))
        ()
    end
    updateCost!(localSearch.solution, localSearch.data.weights)
    endCost = localSearch.solution.cost
    delta = endCost - startingCost

    @info "Cost improved by $delta"
end