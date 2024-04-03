function [accuracy, prediction,a1,z2_temp,z2,a2,z3_temp,z3,a3,a4] = inference_fp_single_image(data,testd,w12,w23,b12,b23)
%Inference on test data

%Test Data
images = data(testd,1:256);
images = images';

%Test Labels
test_labels = data(testd,257:266);
labels_ts = zeros(1,1);

%Converting one-hot labels to integer for comparison
[maxv,index] = max(test_labels(1,:));
labels_ts(1) = index - 1;
fprintf("Correct answer %d \n",labels_ts(1));

% % Disregarded fixed point conversion for input image
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,19,16,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,35,32,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,19,16,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,67,64,1);

% % [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
% % [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,19,16,1);
% % [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
% % [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,41,32,1);
% 
% % Final optimisation 2
% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,22,16,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,44,32,1);

% [w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,19,16,1);
% [w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,35,32,1);
% [b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,19,16,1);
% [b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,67,64,1);

% % Final optimisation 2
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

% % % Final optimisation 2
% a1 = images(:,1);
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
% a1 = images(:,1);
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
a1 = images(:,1);
z2_temp = w12fixedinteger*a1; % Q11.8 
z2 = z2_temp*(2^4) + b12fixedinteger; % Q11.8->Q15.12 + Q15.12 = Q15.12
a2 = leaky_relu_fixed_point(z2); % Q14.12 * Q15.12 = Q29.24

z3_temp = w23fixedinteger*a2;  % Q10.8 * Q29.24 = Q39.32
z3 = z3_temp + b23fixedinteger*(2^(21)); % Q39.32 + Q13.11->Q34.32 = Q39.32
a3 = leaky_relu_fixed_point(z3); % Q14.12 * Q39.32 = Q53.44

a4 = a3 /(2^44);


%Get the index of the maximum output
[maxv1,index1] = max(a3);
num = index1-1; %subtract the index by 1 as matlab indices are 1-10

%compare with integer label
if labels_ts(1) == num
    success = success + 1;
end    

accuracy = success/1*100;
fprintf("Predicted answer %d \n",num);
prediction = num;

end

