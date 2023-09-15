include("ConstructiveSolution.jl")
include("LocalSearch.jl")


using TSPLIB
using .ConstructiveSolution
using .LocalSearch

tsp = readTSP("data/xql662.tsp")
starting_node = 1
sol, cost = basicGreedy(tsp, starting_node)

println("Solution: ", sol)
println("Cost: ", cost)

first_improvement(sol, tsp, cost, true)