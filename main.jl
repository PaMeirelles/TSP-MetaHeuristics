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
    
    output_file = open("output.txt", "w")

    redirect_stdout(output_file)
    @info "Basic greedy solution" sol

    n1 = TwoOpt(instance, sol)
    n2 = Swap(instance, sol)
    n3 = Relocate(instance, sol)

    bestSol = deepcopy(sol)
    it = 0
    max_iter = 10000
    while it < max_iter
        println(it)        
        ns = [n1, n2, n3]
        shuffle!(ns)
        while ( bestImprovement!(ns[1]) || bestImprovement!(ns[2]) || bestImprovement!(ns[3]))
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
            it = 0
        end
        sol = deepcopy(bestSol)

        disturb = ShuffleSublist(instance, sol, 60)

        if it < 80
            simple_shuffle!(disturb)
        else
            shuffle_and_move!(disturb)
        end

        updateCost!(sol, instance.weights)
        n1 = TwoOpt(instance, sol)
        n2 = Swap(instance, sol)
        n3 = Relocate(instance, sol)
        it += 1
    end

end

instance = readTSPLIB(:ch130)

testCase(instance)