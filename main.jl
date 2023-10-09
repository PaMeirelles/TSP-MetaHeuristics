using TSPLIB
using UnionFind

DEBUG = false

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")
include("src/TwoOpt.jl")
include("src/Relocate.jl")
include("src/Benchmark.jl")
include("src/ShuffleSublist.jl")

function testCase(instance::TSP)
    sol = basicGreedy(instance)
    @info "Basic greedy solution" sol

    n1 = TwoOpt(instance, sol)
    n2 = Swap(instance, sol)
    n3 = Relocate(instance, sol)

    bestSol = deepcopy(sol)

    while true
        while ( bestImprovement!(n1) || bestImprovement!(n3) || bestImprovement!(n2))
            updateCost!(n1.solution, n1.data.weights)
        end
 
        if n1.solution.cost < bestSol.cost 
            @info "Best Improvement solution" n1.solution.route n1.solution.cost
            if (abs(n1.solution.cost - instance.optimal) < 1e-5)
                @info "Solution is optimal"
                break
            else
                @warn "Solution is not optimal"
            end
            bestSol = deepcopy(n1.solution)
        end
        sol = deepcopy(bestSol)
        disturb = ShuffleSublist(instance, sol)
        perform_operation!(disturb)
        updateCost!(sol, instance.weights)
        n1 = TwoOpt(instance, sol)
        n2 = Swap(instance, sol)
        n3 = Relocate(instance, sol)

        updateCost!(n1.solution, n1.data.weights)
    end

end

instance = readTSPLIB(:gr96)

testCase(instance)