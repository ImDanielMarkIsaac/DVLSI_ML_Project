function fr = leaky_relu_fixed_point(x)
    f = zeros(length(x),1);

    % Normal Naive approach
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,35,32,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,35,32,1);

    % % Disregarded fixed point conversion for input image
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,19,16,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,19,16,1);

    % % Final optimisation
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,11,8,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,11,8,1);
   
    [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,14,12,1);
    [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,14,12,1);
    

    for i = 1:length(x)
        if x(i)>=0
            f(i) = onefixedinteger*x(i); % Q14.12 * Q16.13 = Q30.25
        else
            f(i) = slpfixedinteger*x(i); % Q14.12 * Q16.13 = Q30.25
        end
    end
    
    fr = f;
end