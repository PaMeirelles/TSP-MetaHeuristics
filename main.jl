using TSPLIB
using UnionFind

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")
include("src/TwoOpt.jl")
include("src/Benchmark.jl")
include("src/Relocate.jl")

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

instance = readTSPLIB(:eil101)
# testCase(instance)


sol, cost = basicGreedy(instance)
@info "Basic greedy solution" sol cost

solution = randomPath(instance)
@info "Random Path" solution.route solution.cost

cheap = cheapestInsertion(instance)
@info "Cheapest Insertion" cheap.route cheap.cost

# n1 = Swap(instance, basicGreedy(instance))    
# n2 = Swap(instance, basicGreedy(instance))   
# n3 = TwoOpt(instance, basicGreedy(instance))    
# n4 = TwoOpt(instance, basicGreedy(instance))  
n5 = Relocate(instance, basicGreedy(instance))    
n6 = Relocate(instance, basicGreedy(instance))  

benchmark(firstImprovement!, n5)
benchmark(bestImprovement!, n6)