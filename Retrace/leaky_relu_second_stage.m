function fr = leaky_relu_second_stage(x)
    f = zeros(length(x),1);
    % [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.02,131,128,1);
    % [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,131,128,1);
    % for i = 1:length(x)
    %     if x(i)>=0
    %         f(i) = onefixedinteger*x(i); % Q128 * Q128 = Q256
    %     else
    %         % f(i) = 0.02*x(i);
    %         f(i) = slpfixedinteger*x(i); % Q128 * Q128 = Q256
    %     end
    % end

    [slpfixedfloat , slpfixedinteger ,err] = fixedpoint1(0.1,35,32,1);
    [onefixedfloat , onefixedinteger ,err] = fixedpoint1(1,35,32,1);
    for i = 1:length(x)
        if x(i)>=0
            f(i) = onefixedinteger*x(i); % Q32 * Q32 = Q64
        else
            % f(i) = 0.02*x(i);
            f(i) = slpfixedinteger*x(i); % Q32 * Q32 = Q64
        end
    end
    fr = f;
end