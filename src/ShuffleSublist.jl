using Random

struct ShuffleSublist
    data::TSP
    solution::Solution
    gap::Int
 end

 function keep_new(_::ShuffleSublist)::Bool
    return false;
 end


function perform_shuffle!(ss::ShuffleSublist, i::Int, j::Int)
    route = ss.solution.route
    n = length(route)
    if j > i
        shuffle!(view(route, i:j))
    else
        sl = vcat(route[i:n-1], route[2:j])
        x = rand(0:length(sl))
        shuffle!(sl)
        ss.solution.route = vcat([1], sl[1:x], route[j+1:i-1], sl[x+1:length(sl)], [1])
    end
end

 function simple_shuffle!(ss::ShuffleSublist)
    n = length(ss.solution.route)
    gap = ss.gap

    i = rand(2:n-1)
    gap_size = rand(gap:n-1)
    j = (i + gap_size) % n + 1
    perform_shuffle!(ss, i, j)
end
