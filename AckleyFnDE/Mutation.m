function u = Mutation(p, beta)
    u = p(1).position + beta * (p(2).position - p(3).position);
end

