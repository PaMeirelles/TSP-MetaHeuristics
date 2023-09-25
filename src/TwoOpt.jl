struct TwoOpt
    data::TSP
    solution::Solution
 end

 function eval(twoOpt::TwoOpt, pos1::Int64, pos2::Int64)::Int64
    route = twoOpt.solution.route
    weights = twoOpt.data.weights
    size = twoOpt.data.dimension

    # Assuming pos2 > pos1
    oldCost = weights[route[pos1], route[pos1+1]] + weights[route[pos2], route[(pos2%size)+1]]
    newCost = weights[route[pos1], route[pos2]] + weights[route[pos1+1], route[(pos2%size)+1]]

    return newCost - oldCost

 end
 
 function move!(twoOpt::TwoOpt, pos1::Int64, pos2::Int64)
    twoOpt.solution.route[pos1+1:pos2] = reverse(twoOpt.solution.route[pos1+1:pos2])
 end
 
 function firstImprovement!(twoOpt::TwoOpt)::Bool
    size = length(twoOpt.solution.route)-1
     for i in 2:size
        # We can start at i+2, since performing a 2opt between adjacent nodes does nothing
        for j in i+2:size 
            delta = eval(twoOpt, i, j)
            if (delta < 0)
                if DEBUG
                    println("Score improved $delta by performing a 2opt between $i and $j")
                end
                move!(twoOpt, i, j)
                twoOpt.solution.cost += delta
                return true
            end
        end
    end
    if DEBUG 
        println("Local minimum achieved")
    end
    return false
 end

 function bestImprovement!(twoOpt::TwoOpt)::Bool
    bestFrom = nothing
    bestTo = nothing
    bestScore = 0

    size = length(twoOpt.solution.route)-1
     for i in 2:size
        # Same reasoning as firstImprovement
        for j in i+2:size 
            delta = eval(twoOpt, i, j)
            if (delta < bestScore)
                bestScore = delta
                bestFrom, bestTo = i, j
            end
        end
    end
    if bestScore < 0
        move!(twoOpt, bestFrom, bestTo)
        if DEBUG
            println("Score improved $bestScore by performing a 2 opt between $bestFrom and $bestTo")
        end
        return true
    else
        if DEBUG 
            println("Local minimum achieved")
        end
        return false
    end
end

