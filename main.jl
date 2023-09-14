include("constructive_solution.jl")
include("local_search.jl")


using TSPLIB
using .ConstructiveSolution
using .LocalSearch

tsp = readTSP("data/xqf131.tsp")
starting_node = 1
sol, cost = basic_greedy(tsp, starting_node)

println("Solution: ", sol)
println("Cost: ", cost)

cost += perform_swap(sol, 1, 2, tsp)

println("Solution: ", sol)
println("Cost: ", cost)