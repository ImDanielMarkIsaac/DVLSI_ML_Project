function fr = leaky_relu_fixed_point(x)
    f = zeros(length(x),1);
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.02,35,32,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,35,32,1);
    % for i = 1:length(x)
    %     if x(i)>=0
    %         f(i) = onefixedinteger*x(i); % Q32 * Q32 = Q64
    %     else
    %         % f(i) = 0.02*x(i);
    %         f(i) = slpfixedinteger*x(i); % Q32 * Q32 = Q64
    %     end
    % end

    [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,11,8,1);
    
    [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,11,8,1);
    

    for i = 1:length(x)
        if x(i)>=0
            f(i) = onefixedinteger*x(i); % Q8 * Q8 = Q16
            % fprintf("i %d ",i);
            % fprintf("onefixedinteger %d ",onefixedinteger);
            % fprintf("x(i) %d \n ",x(i));
            % fprintf("f(i) %d \n ",f(i));
        else
            % f(i) = 0.02*x(i);
            f(i) = slpfixedinteger*x(i); % Q8 * Q8 = Q16
        end
    end
    fr = f;
end