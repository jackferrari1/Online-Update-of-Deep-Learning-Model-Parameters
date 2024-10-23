% Load latest version of model
load('dlnet.mat');

% Measure baseline RMSE
load('testData.mat');
rmseOriginal = runInferenceAndPlotPredictions(dlnet, XTest, YTest);
display(rmseOriginal);

% Load latest version of training data
load('trainData.mat');

% Train model on latest data
load('validationData.mat');
options = getTrainingOptions(XVal,YVal);
dlnetRetrained = trainnet(XTrain,YTrain,dlnetwork(dlnet.Layers),"mean-squared-error",options);

% Evaluate new RMSE
rmseNew = runInferenceAndPlotPredictions(dlnetRetrained, XTest, YTest);
display(rmseNew);

% If accuracy improves, extract new weights
if rmseNew < rmseOriginal
    dlnet = dlnetRetrained;
    save dlnet.mat dlnet
    updatedLearnables = cellfun(@extractdata, dlnet.Learnables.Value, UniformOutput=false);
    coder.write('learnablesValue.coderdata', updatedLearnables);
end
