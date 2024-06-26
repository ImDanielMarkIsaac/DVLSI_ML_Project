function fr = leaky_relu_second_stage(x,trial)
    f = zeros(length(x),1);
    
    % Normal Naive approach
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,131,128,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,131,128,1);

    % % Disregarded fixed point conversion for input image
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,67,64,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,67,64,1);

    % % Final optimisation
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,41,32,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,41,32,1);

    % Final optimisation 2
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,11,8,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,11,8,1);

    [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,14,12,1);
    [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,14,12,1);
    
    for i = 1:length(x)
        if x(i)>=0
            f(i) = onefixedinteger*x(i); % Q19.16 * Q57.48 = Q76.64
        else
            f(i) = slpfixedinteger*x(i); % Q19.16 * Q57.48 = Q76.64
        end
    end
    fr = f;
end