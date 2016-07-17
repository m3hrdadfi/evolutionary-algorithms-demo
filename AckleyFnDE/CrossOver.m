function pc = CrossOver(p, pm, nd, pr)
    pc = zeros(1, nd);
    METHOD_CROSSOVER = randi([1 2]);
    
    switch METHOD_CROSSOVER
        case 1
            J = CrossOver_Binomial(nd, pr);
        case 2
            J = CrossOver_Exponential(nd, pr);
    end
   
    
    for j = 1:nd
        member = ismember(J, j);
        if member(member~=0) == 1
            pc(j) = pm(j);
        else
            pc(j) = p(j);
        end
    end

end

function J = CrossOver_Binomial(nd, pr)
    J = [];
    gen = rand(1, nd);
    for j = 1:nd
        if gen(j) < pr
            J = [J j];
        end
    end
    if isempty(J)
        J = [J randi([1 nd])];
    end
end

function J = CrossOver_Exponential(nd, pr)
    J = [];
    j = randi([1 nd]);
    gen = rand(1, nd);
    l = 0;
    while (length(J) == nd) || (gen(j) < pr)
        J = [J j+1];
        j = mod((j+1), nd);
        if j == 0
            j = 1;
        end
        l = l + 1;
        if l > nd
            break;
        end
    end
    if isempty(J)         
        J = [randi([1 nd])];
    end
end

