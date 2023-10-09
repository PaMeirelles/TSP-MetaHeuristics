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

    disturb = ShuffleSublist(instance, sol)

    bestSol = deepcopy(sol)

    for _ in 1:100

        while ( bestImprovement!(n1) || bestImprovement!(n2) || bestImprovement!(n3))
            updateCost!(n1.solution, n1.data.weights)
        end

        
        if n1.solution.cost < bestSol.cost 
            @info "Best Improvement solution" n1.solution.route n1.solution.cost
            bestSol = deepcopy(sol)
        else
            sol = deepcopy(bestSol)
        end

        perform_operation!(disturb)
    end

    if (abs(n1.solution.cost - instance.optimal) < 1e-5)
        @info "Solution is optimal"
    else
        @warn "Solution is not optimal"
    end
end

instance = readTSPLIB(:a280)

testCase(instance)