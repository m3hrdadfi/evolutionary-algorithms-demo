function [ch1, ch2] = CrossOver(p1, p2)
    landa = rand;
    
    ch1 = p1 + (1 - landa) * p2;
    ch2 = p2 + (1 - landa) * p1;
end

