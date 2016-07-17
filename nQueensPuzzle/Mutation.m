function ch = Mutation(p)
    METHOD_MUTATION = randi([1 3]);
    
    switch METHOD_MUTATION
        case 1
            ch = Mutation_Inversion(p);
        case 2
            ch = Mutation_Reciprocal(p);
        case 3
            ch = Mutation_Insertion(p);
    end
end

function ch = Mutation_Insertion(p)
    nVar = numel(p);
    cc = randsample(nVar, 2);
    
    c1 = min(cc);
    c2 = max(cc);
    pc2 = p(c2);   
    p = p(p~=pc2);
    ch = [p(1:c1) pc2 p(c1+1:end)];
end

function ch = Mutation_Inversion(p)
    nVar = numel(p);
    cc = randsample(nVar, 2);
    
    c1 = min(cc);
    c2 = max(cc);
    
    pflr = fliplr(p(c1+1:c2));
    ch = [p(1:c1) pflr p(c2+1:end)];
end


function ch = Mutation_Reciprocal(p)
    nVar = numel(p);
    cc = randsample(nVar, 2);
    
    c1 = min(cc);
    c2 = max(cc);
    
    pc1 = p(c1);
    pc2 = p(c2);
    
    p(c1) = pc2;
    p(c2) = pc1;
    
    ch = p;
end