%Top Script to Train and Classify Handwritten Digits
% clear all;

disp('Starting ...');

load_randomized_data = 1;

if (load_randomized_data)
    %Load Data from .mat file
    %This data is randomized
    load('semeion_data_randomized.mat');
else
    %Load Data from .data file
    %This data is arranged in increasing order of digit. so randomize
    data = load('semeion.datamin(min(w12))');
    data = data(randperm(size(data, 1)), :); %Randomize data rows
end

hn1 = 60; %Number of neurons in the first hidden layer

%divide the dataset into training and testing
traind = 1100; % Training set
testd = 493; % Testing set
train_data = data(1:traind,:);
test_data = data((traind + (1:testd)),:);

%Training function to get weights and biases and save them
%comment out the 2 lines below when a desired test accuracy is reached and
%you want to run only inference.

%Load the saved training parameters
load('trained_params.mat','w12','w23','b12','b23');

[w12fixedfloat , w12fixedinteger ,err] = fixedpoint1(w12,11,8,1);
[w23fixedfloat , w23fixedinteger ,err] = fixedpoint1(w23,11,8,1);
[b12fixedfloat , b12fixedinteger ,err] = fixedpoint1(b12,11,8,1);
[b23fixedfloat , b23fixedinteger ,err] = fixedpoint1(b23,11,8,1);

%Check train data accuracy
% train_accuracy = inference(train_data,traind,w12fixedfloat,w23fixedfloat,b12fixedfloat,b23fixedfloat);
train_accuracy = inference_fixed_point(train_data,traind,w12,w23,b12,b23);

fprintf('Train Accuracy: %f %% \n',train_accuracy);

%Check test data accuracy
% test_accuracy = inference(test_data,testd,w12fixedfloat,w23fixedfloat,b12fixedfloat,b23fixedfloat);
test_accuracy = inference_fixed_point(test_data,testd,w12,w23,b12,b23);
fprintf('Test Accuracy: %f %% \n',test_accuracy);

disp('Done!');

% %display a sample image
% img_num = 20;
% sample_img_vector = data(img_num,1:256);
% sample_img = reshape(sample_img_vector,[16,16]);
% imshow(sample_img.')
