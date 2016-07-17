function y = Akley(xx)
    d = length(xx);

    c = 2 * pi;
    b = 0.2;
    a = 20;

    sum1 = 0;
    sum2 = 0;
    for ii = 1:d
        xi = xx(ii);
        sum1 = sum1 + xi ^ 2;
        sum2 = sum2 + cos(c * xi);
    end
    
    term1 = -a * exp( -b * sqrt( sum1 / d ) );
    term2 = -exp( sum2 / d );
    
    y = term1 + term2 + a + exp(1);
    
end

