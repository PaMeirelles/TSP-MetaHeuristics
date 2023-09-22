DEBUG = true
struct Relocate
    data::TSP
    solution::Solution
 end

 # Assuming remove node from pos1, insert before pos2
 function eval(relocate::Relocate, pos1::Int64, pos2::Int64)::Int64
    weights = relocate.data.weights
    route = relocate.solution.route
    node = relocate.solution.route[pos1]

    oldCost = nodeCost(route, pos1, weights) + weights[prev(route, pos2), route[pos2]]

    newCost = weights[prev(route, pos1), next(route, pos1)] + weights[prev(route, pos2), node] + weights[node, route[pos2]]


    return newCost - oldCost
 end
  # Assuming remove node from pos1, insert before pos2
 function move!(relocate::Relocate, pos1::Int64, pos2::Int64)
    node = relocate.solution.route[pos1]
    deleteat!(relocate.solution.route, pos1)
    if pos1 > pos2
        insert!(relocate.solution.route, pos2, node)
    else
        insert!(relocate.solution.route, pos2-1, node)
    end
 end
 
 function firstImprovement!(relocate::Relocate)::Bool
    size = length(relocate.solution.route)
    for i in 1:size
       # We cannot start at i+1, since move(i, j) is not the same from move(j,i)
       for j in 1:size
            # However, we can skip i=j and i+1 = j
            if i==j || (i%size)+1 == j
                continue
            end 
           delta = eval(relocate, i, j)
           if (delta < 0)
               if DEBUG
                   println("Score improved $delta by performing a relocate from $i to $j")
               end
               move!(relocate, i, j)
               relocate.solution.cost += delta
               return true
           end
       end
   end
   if DEBUG 
       println("Local minimum achieved")
   end
   return false
end

 function bestImprovement!(relocate::Relocate)::Bool
    bestFrom = nothing
    bestTo = nothing
    bestScore = 0

    size = length(relocate.solution.route)
     for i in 1:size
        # Same reasoning as firstImprovement
        for j in 1:size 
            if i==j || (i%size)+1 == j
                continue
            end
            delta = eval(relocate, i, j)
            if (delta < bestScore)
                bestScore = delta
                bestFrom, bestTo = i, j
            end
        end
    end
    if bestScore < 0
        move!(relocate, bestFrom, bestTo)
        if DEBUG
            println("Score improved $bestScore by performing a relocate from $bestFrom to $bestTo")
        end
        return true
    else
        if DEBUG 
            println("Local minimum achieved")
        end
        return false
    end
end

