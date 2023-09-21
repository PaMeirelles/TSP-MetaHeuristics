using TSPLIB

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")
include("src/Benchmark.jl")
include("src/TwoOpt.jl")

function testCase(instance::TSP)
    sol, cost = basicGreedy(instance)
    @info "Basic greedy solution" sol cost
    neighbour = TwoOpt(instance, Solution(sol, cost))
    bestImprovement!(neighbour)
    updateCost!(neighbour.solution, neighbour.data.weights)
    @info "Best Improvement solution" neighbour.solution.route neighbour.solution.cost

    if (abs(neighbour.solution.cost - instance.optimal) < 1e-5)
        @info "Solution is optimal"
    else
        @warn "Solution is not optimal"
    end
end

instance = readTSPLIB(:a280)
# testCase(instance)


sol, cost = basicGreedy(instance)

n1 = Swap(instance, Solution(copy(sol), cost))    
n2 = Swap(instance, Solution(copy(sol), cost))   
n3 = TwoOpt(instance, Solution(copy(sol), cost))    
n4 = TwoOpt(instance, Solution(copy(sol), cost))  

benchmark(firstImprovement!, n1)
benchmark(bestImprovement!, n2)
benchmark(firstImprovement!, n3)
benchmark(bestImprovement!, n4)
