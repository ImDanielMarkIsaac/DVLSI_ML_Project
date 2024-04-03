function accuracy = inference_fixed_point(data,testd,w12,w23,b12,b23)
%Inference on test data

%Test Data
images = data(1:testd,1:256);
images = images';

%Test Labels
test_labels = data(1:testd,257:266);
labels_ts = zeros(testd,1);

%Converting one-hot labels to integer for comparison
for i = 1:testd
    [maxv,index] = max(test_labels(i,:));
    labels_ts(i) = index - 1;
end

% Normal Naive approach
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,19,16,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,67,64,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,35,32,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,131,128,1);

% % Disregarded fixed point conversion for input image
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,19,16,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,35,32,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,19,16,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,67,64,1);

% % Final optimisation
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,19,16,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,35,32,1);

% % % Final optimisation 2
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,15,13,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,16,13,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,14,12,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,14,12,1);

% % % Final optimisation 3
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,12,10,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,15,12,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,10,8,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,13,11,1);

% % Final optimisation 4
[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,10,8,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,15,12,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,10,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,13,11,1);


success = 0;
for i = 1:testd

    
    % % % Normal Naive approach
    % % Feed forward
    % a1 = images(:,i);
    % [a1fixedfloat , a1fixedinteger ,err] = fixedpoint1(a1,19,16,1);
    % z2_temp = w12fixedinteger*a1fixedinteger; % Q16 * Q16 = Q32
    % z2 = z2_temp + b12fixedinteger; % Q32 + Q32 = Q32
    % a2 = leaky_relu_fixed_point(z2); % Q32 * Q32 = Q64 
    % z3_temp = w23fixedinteger*a2;  % Q64 * Q64 = Q128
    % z3 = z3_temp + b23fixedinteger; % Q128 + Q128 = Q128
    % a3 = leaky_relu_second_stage(z3); % Q128 * Q128 = Q256
    % a3 = a3 /(2^256);

    % % Disregarded fixed point conversion for input image
    % Feed forward
    % a1 = images(:,i);
    % % [a1fixedfloat , a1fixedinteger ,err] = fixedpoint1(a1,19,16,1);
    % z2_temp = w12fixedinteger*a1; % Q16 
    % z2 = z2_temp + b12fixedinteger; % Q16 + Q16 = Q16
    % a2 = leaky_relu_fixed_point(z2); % Q16 * Q16 = Q32 
    % z3_temp = w23fixedinteger*a2;  % Q32 * Q32 = Q64
    % % z3_temp = w23fixedfloat*a2;  % Q32 * Q32 = Q64
    % z3 = z3_temp + b23fixedinteger; % Q64 + Q64 = Q64
    % a3 = leaky_relu_second_stage(z3); % Q64 * Q64 = Q128
    % a3 = a3 /(2^128);


    % % Final optimisation
    % % % Feed forward
    % a1 = images(:,i);
    % z2_temp = w12fixedinteger*a1; % Q8 
    % z2 = z2_temp + b12fixedinteger; % Q8 + Q8 = Q8
    % a2 = leaky_relu_fixed_point(z2); % Q8 * Q8 = Q16 
    % z3_temp = w23fixedinteger*a2;  % Q16 * Q16 = Q32
    % z3 = z3_temp + b23fixedinteger; % Q32 + Q32 = Q32
    % a3 = leaky_relu_second_stage(z3); % Q32 * Q32 = Q64
    % a3 = a3 /(2^64);

    % % % Final optimisation 2
    % % % % Feed forward
    % a1 = images(:,i);
    % z2_temp = w12fixedinteger*a1; % Q15.13 
    % z2 = z2_temp + b12fixedinteger; % Q15.13 + Q16.13 = Q16.13
    % a2 = leaky_relu_fixed_point(z2); % Q14.12 * Q16.13 = Q30.25
    % 
    % z3_temp = w23fixedinteger*a2;  % Q14.12 * Q30.25 = Q44.37
    % z3 = z3_temp + b23fixedinteger*(2^(25)); % Q44.37 + Q14.12->Q39.37 = Q44.37
    % a3 = leaky_relu_fixed_point(z3); % Q14.12 * Q44.37 = Q58.49
    % 
    % a3 = a3 /(2^49);



    % % % Final optimisation 3
    % % % % Feed forward
    % a1 = images(:,i);
    % z2_temp = w12fixedinteger*a1; % Q12.10 
    % z2 = z2_temp*(2^2) + b12fixedinteger; % Q12.10->Q14.12 + Q15.12 = Q15.12
    % a2 = leaky_relu_fixed_point(z2); % Q14.12 * Q15.12 = Q29.24
    % 
    % z3_temp = w23fixedinteger*a2;  % Q10.8 * Q29.24 = Q39.32
    % z3 = z3_temp + b23fixedinteger*(2^(21)); % Q39.32 + Q13.11->Q34.32 = Q39.32
    % a3 = leaky_relu_fixed_point(z3); % Q14.12 * Q39.32 = Q53.44
    % 
    % a3 = a3 /(2^44);

    % % Final optimisation 4
    % % % Feed forward
    a1 = images(:,i);
    z2_temp = w12fixedinteger*a1; % Q10.8 
    z2 = z2_temp*(2^4) + b12fixedinteger; % Q10.8->Q14.12 + Q15.12 = Q15.12
    a2 = leaky_relu_fixed_point(z2); % Q14.12 * Q15.12 = Q29.24

    z3_temp = w23fixedinteger*a2;  % Q10.8 * Q29.24 = Q39.32
    z3 = z3_temp + b23fixedinteger*(2^(21)); % Q39.32 + Q13.11->Q34.32 = Q39.32
    a3 = leaky_relu_fixed_point(z3); % Q14.12 * Q39.32 = Q53.44

    a3 = a3 /(2^44);
    
    %Get the index of the maximum output
    [maxv1,index1] = max(a3);
    num = index1-1; %subtract the index by 1 as matlab indices are 1-10

    %compare with integer label
    if labels_ts(i) == num
        success = success + 1;
    end    

end

accuracy = success/testd*100;

end

