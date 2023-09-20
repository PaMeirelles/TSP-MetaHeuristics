DEBUG = true

struct Swap
    data::TSP
    solution::Solution
 end

 function eval(swap::Swap, pos1::Int64, pos2::Int64)::Int64
    route = swap.solution.route
    weights = swap.data.weights

    oldCost = nodeCost(route, pos1, weights) + nodeCost(route, pos2, weights)
    # I know we are performing and reverting the swap many times, but this seemed the cleanest way yo do eval, and since the
    # swap is performed in O(1), it also seems efficient. If it is not, I will be happy to be educated on the reasons why.
    move!(swap, pos1, pos2) 
    newCost = nodeCost(route, pos1, weights) + nodeCost(route, pos2, weights)
    move!(swap, pos2, pos1)
    return newCost - oldCost

 end
 
 function move!(swap::Swap, pos1::Int64, pos2::Int64)
    swap.solution.route[pos1], swap.solution.route[pos2] = swap.solution.route[pos2], swap.solution.route[pos1]
 end
 
 function firstImprovement!(swap::Swap)::Bool
    size = length(swap.solution.route)
     for i in 1:size
        for j in i+1:size 
            delta = eval(swap, i, j)
            if (delta < 0)
                if DEBUG
                    println("Score improved $delta by swapping $i and $j")
                end
                move!(swap, i, j)
                swap.solution.cost += delta
                return true
            end
        end
    end
    if DEBUG 
        println("Local minimum achieved")
    end
    return false
 end

 function bestImprovement!(swap::Swap)::Bool
    bestFrom = nothing
    bestTo = nothing
    bestScore = 0

    size = length(swap.solution.route)
     for i in 1:size
        for j in i+1:size 
            delta = eval(swap, i, j)
            if (delta < bestScore)
                bestScore = delta
                bestFrom, bestTo = i, j
            end
        end
    end
    if bestScore < 0
        move!(swap, bestFrom, bestTo)
        if DEBUG
            println("Score improved $bestScore by swapping $bestFrom and $bestTo")
        end
        return true
    else
        if DEBUG 
            println("Local minimum achieved")
        end
        return false
    end
end
