% Script to classify Handwritten Digits

disp('Starting ...');

load_randomized_data = 1;

if (load_randomized_data)
    %Load Data from .mat file
    %This data is randomized
    load('semeion_data_randomized.mat');
else
    %Load Data from .data file
    %This data is arranged in increasing order of digit. so randomize
    data = load('semeion.data');
    data = data(randperm(size(data, 1)), :); %Randomize data rows
end

%divide the dataset into training and testing
traind = 1100; % Training set
testd = 493; % Testing set
train_data = data(1:traind,:);
test_data = data((traind + (1:testd)),:);


%Load the saved training parameters
load('trained_params.mat','w12','w23','b12','b23');

test = [ 1, 21, 41, 61, 81, 101, 121, 141, 161, 181];

figure
tiledlayout(2,5)

%Check test 10 images
data = load('semeion.data');
for i = 1:10
    nexttile
    [test_accuracy,prediction] = inference_fp_single_image(data,test(i),w12,w23,b12,b23);
    fprintf('Test Accuracy single: %f %% \n',test_accuracy);
    img_num = test(i);
    sample_img_vector = data(img_num,1:256);
    sample_img = reshape(sample_img_vector,[16,16]);
    imshow(sample_img.')
    display_statement = sprintf('Handwritten %d', i-1);
    title(display_statement)
    display_statement = sprintf('Classification result: %d', prediction);
    xlabel(display_statement);
end
