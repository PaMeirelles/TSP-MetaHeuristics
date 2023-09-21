DEBUG = true
struct Relocate
    data::TSP
    solution::Solution
 end


   function eval(relocate::Relocate, pos1::Int64, pos2::Int64)::Int64
      weights = relocate.data.weights
      oldCost = nodeCost(relocate.solution.route, pos1, weights) + nodeCost(relocate.solution.route, pos2, weights)
      move!(relocate, pos1, pos2)
      newCost = nodeCost(relocate.solution.route, pos1, weights) + nodeCost(relocate.solution.route, pos2, weights)
      move!(relocate, pos2, pos1)
      return newCost - oldCost
   end

   function move!(relocate::Relocate, from::Int64, to::Int64)
      vertex = popat!(relocate.solution.route, from)
      if from > to
         insert!(relocate.solution.route, to, vertex)
      else
         insert!(relocate.solution.route, to - 1, vertex)
      end
   end
   
   function firstImprovement!(relocate::Relocate)::Bool
      size = length(relocate.solution.route)
      for i in 1:size
         for j in i+1:size
            delta = eval(relocate, i, j)
            if (delta < 0)
                  if DEBUG
                     println("Score improved $delta by relocating $i to $j")
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
   end

