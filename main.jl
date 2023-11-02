using TSPLIB
using UnionFind
using Printf
using Dates

DEBUG = false

include("src/ConstructiveSolution.jl")
include("src/Solution.jl")
include("src/Swap.jl")
include("src/Utils.jl")
include("src/TwoOpt.jl")
include("src/Relocate.jl")
include("src/Benchmark.jl")
include("src/ShuffleSublist.jl")
include("src/StageDisturb.jl")

instance = readTSPLIB(:eil76)

sol = basicGreedy(instance)
sd = StageDisturb(instance, sol, [TwoOpt(instance, sol), Swap(instance, sol), Relocate(instance, sol)], 0, [250, 1000, 4000],
 [simple_shuffle!, shuffle_and_move!, full_shuffle!], 40)

iteratedLocalSearch(sd)