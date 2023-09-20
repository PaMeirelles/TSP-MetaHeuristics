using TSPLIB

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")
include("src/Benchmark.jl")

function testCase(instance::TSP)
    sol, cost = basicGreedy(instance)
    @info "Basic greedy solution" sol cost
    swap = Swap(instance, Solution(sol, cost))
    bestImprovement!(swap)
    @info "Best Improvement solution" swap.solution.route swap.solution.cost

    if (abs(swap.solution.cost - instance.optimal) < 1e-5)
        @info "Solution is optimal"
    else
        @warn "Solution is not optimal"
    end
end

instance = readTSPLIB(:pr1002)
sol, cost = basicGreedy(instance)

swap1 = Swap(instance, Solution(copy(sol), cost))    
swap2 = Swap(instance, Solution(copy(sol), cost))   

benchmark(firstImprovement!, swap2)
benchmark(bestImprovement!, swap1)
