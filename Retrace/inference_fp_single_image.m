function accuracy = inference_fp_single_image(data,testd,w12,w23,b12,b23)
%Inference on test data

%Test Data
images = data(testd,1:256);
images = images';

%Test Labels
test_labels = data(testd,257:266);
labels_ts = zeros(1,1);

%Converting one-hot labels to integer for comparison
% for i = 1:testd
    [maxv,index] = max(test_labels(1,:));
    labels_ts(1) = index - 1;
    fprintf("Correct answer %d \n",labels_ts(1));
% end

[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,19,16,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,41,32,1);

success = 0;
% 
% % for i = 1:testd
% 
%     %Feed forward
%     a1 = images(:,1);
% 
%     z2 = w12*a1 + b12;
%     a2 = leaky_relu(z2);
% 
%     z3 = w23*a2 + b23;
%     a3 = leaky_relu(z3); %Output vector
    
    a1 = images(:,1);
    
    % [a1fixedfloat , a1fixedinteger ,err] = fixedpoint1(a1,19,16,1);
    z2_temp = w12fixedinteger*a1; % Q8 
    
     

    z2 = z2_temp + b12fixedinteger; % Q8 + Q8 = Q8
    
    
    a2 = leaky_relu_fixed_point(z2); % Q8 * Q8 = Q16 

    


    % a2 = a2;
    % disp(a2);

    z3_temp = w23fixedinteger*a2;  % Q16 * Q16 = Q32

    

    % z3_temp = w23fixedfloat*a2;  % Q32 * Q32 = Q64
    z3 = z3_temp + b23fixedinteger; % Q32 + Q32 = Q32

    

    a3 = leaky_relu_second_stage(z3); % Q32 * Q32 = Q64

    

    a3 = a3 /(2^64);
    % a3 = bitsra(a3,32);

    fpw = fopen("check_a3_adjust.txt","w");
    fprintf(fpw,"%d \n",a3);
    
    %Get the index of the maximum output
    [maxv1,index1] = max(a3);
    num = index1-1; %subtract the index by 1 as matlab indices are 1-10

    %compare with integer label
    if labels_ts(1) == num
        success = success + 1;
    end    

% end

accuracy = success/1*100;
fprintf("Predicted answer %d \n",num);
end

