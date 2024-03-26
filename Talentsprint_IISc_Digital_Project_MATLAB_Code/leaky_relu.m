function fr = leaky_relu(x)
    f = zeros(length(x),1);
    for i = 1:length(x)
        if x(i)>=0
            f(i) = x(i);
        else
            % f(i) = 0.02*x(i);
            % f(i) = 0.02*x(i);     0.019531250000000
            f(i) = 0.019531250000000*x(i); 
        end
    end
    fr = f;
end