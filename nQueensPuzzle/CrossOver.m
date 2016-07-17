function [ch1, ch2] = CrossOver(p1, p2)
    METHOD_CROSSOVER = randi([1 2]);
    % METHOD_CROSSOVER = 1;
    
    switch METHOD_CROSSOVER
        case 1
            [ch1, ch2] = CrossOver_PMX(p1, p2);
        case 2
            [ch1, ch2] = CrossOver_OX(p1, p2);
    end
end

function [ch1, ch2] = CrossOver_PMX(p1, p2)
    nVar = numel(p1);
    cc = randsample(nVar-1, 2);
    
    c1 = min(cc);
    c2 = max(cc);
    cdiff = c2 - c1;
    
    p1m = p1(c1+1: c2);
    p2m = p2(c1+1: c2);
    
    ch1 = [p1(1:c1) zeros(1, cdiff) p1(c2+1:end)];
    ch2 = [p2(1:c1) zeros(1, cdiff) p2(c2+1:end)];
    
    p1r = intersect(ch1, p2m);
    p2r = intersect(ch2, p1m);
    
    ch1(ismember(ch1, p1r)) = p2r;
    ch2(ismember(ch2, p2r)) = p1r;
    
    ch1(c1+1:c2) = p2m;
    ch2(c1+1:c2) = p1m;
end

function [ch1, ch2] = CrossOver_OX(p1, p2)
    nVar = numel(p1);
    cc = randsample(nVar-1, 2);
    
    c1 = min(cc);
    c2 = max(cc);
    
    
    p1m = p1(c1+1: c2);
    p2m = p2(c1+1: c2);
    
    p1u = setdiff(p1, p2m, 'stable');
    p2u = setdiff(p2, p1m, 'stable');
    
    ch1 = [p1u(1:c1) p2m p1u(c1+1:end)];
    ch2 = [p2u(1:c1) p1m p2u(c1+1:end)];
end