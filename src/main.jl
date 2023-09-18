using TSPLIB

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")

function testCase(instance::TSP)
    sol, cost = basicGreedy(instance)
    @info "Basic greedy solution" sol cost
    swap = Swap(instance, Solution(sol, cost))
    firstImprovement!(swap)
    @info "First improvement solution" swap.solution.route swap.solution.cost

    if (abs(swap.solution.cost - instance.optimal) < 1e-5)
        @info "Solution is optimal"
    else
        @warn "Solution is not optimal"
    end
end

instance = readTSPLIB(:burma14)
testCase(instance)