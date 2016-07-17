function ch = Mutation(p, t, T, r, b)
    METHOD_MUTATION = randi([1 2]);
    nVar = numel(p);
    k = randsample(nVar, 1);
    pk = p(k);
    
    pku = max(p);
    pkl = min(p);
    
    delta1 = (pku - pk) * r * ((1 - t / T) ^ b);
    delta2 = (pk - pkl) * r * ((1 - t / T) ^ b);
    
    switch METHOD_MUTATION
        case 1
            pk = pk + delta1;
        case 2
            pk = pk - delta2;
    end
    
    
    p(k) = pk;
    ch = p;
end

