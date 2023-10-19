using Random

struct ShuffleSublist
    data::TSP
    solution::Solution
    gap::Int
 end

 function keep_new(_::ShuffleSublist)::Bool
    return false;
 end

 function simple_shuffle!(ss::ShuffleSublist)
    route = ss.solution.route
    n = length(route) - 1
    gap = ss.gap

    pop!(route)

    i = rand(1:n-gap)
    gap_size = rand(gap:n)
    j = (i + gap_size) % n
    if i > j
        route[:] = vcat(route[i:n], route[1:i-1])
        shuffle!(view(route, 1:i))
    else
        shuffle!(view(route, i:j))
    end
    convertRepresentation!(route)
end

function shuffle_and_move!(ss::ShuffleSublist)
    route = ss.solution.route
    n = length(route) - 1
    gap = ss.gap

    pop!(route)

    i = rand(1:n-gap)
    gap_size = rand(gap:n)
    j = ((i + gap_size - 1) % n) + 1
    if i > j
        route[:] = vcat(route[i:n], route[1:j-1], route[j:i-1])
    else
        route[:] = vcat(route[i:j], route[j+1:n], route[1:i-1])
    end
    shuffle!(view(route, 1:gap_size))
    x = rand(0:(n-gap_size))
    route[:] = vcat(route[1+gap_size:gap_size+x], route[1:gap_size], route[gap_size+x+1:n]) 
    convertRepresentation!(route)
end
