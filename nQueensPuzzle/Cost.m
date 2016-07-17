function z = Cost(threats)
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;
    
    z = sum(threats);
end