function [accuracy, prediction,debug] = inference_fp_single_image(data,testd,w12,w23,b12,b23,trial)
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

[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,trial+3,trial,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,trial+3,trial,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,trial+3,trial,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,trial+3,trial,1);


success = 0;
    
a1 = images(:,1);
% a1 = a1*0 + 1;
z2_temp = w12fixedinteger*a1; % Q8 
% z2_temp = w12*a1; % Q8 


% z2 = z2_temp + b12fixedinteger; % Q8 + Q8 = Q8
z2 = z2_temp + b12fixedinteger; % Q8 + Q8 = Q8
debug = z2;

a2 = leaky_relu_fixed_point(z2,trial); % Q8 * Q8 = Q16 
z3_temp = w23fixedinteger*a2;  % Q16 * Q16 = Q32
z3 = z3_temp + b23fixedinteger*(2^(2*trial)); % Q57.48 + Q19.16->Q51.48 = Q57.48
a3 = leaky_relu_second_stage(z3,trial); % Q19.16 * Q57.48 = Q76.64
a3 = a3 /(2^64);

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

