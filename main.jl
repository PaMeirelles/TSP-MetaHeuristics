include("ConstructiveSolution.jl")
include("Swap.jl")
include("Solution.jl")
using TSPLIB

tsp = readTSP("data/xqf131.tsp")
starting_node = 1
sol, cost = basicGreedy(tsp, starting_node)

# println("Solution: ", sol)
# println("Cost: ", cost)

solution = Solution(sol, cost)
swap = Swap(tsp, solution)

while localSearch!(swap)
    ()
end


