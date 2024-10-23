function out = mUpdateLearnablesAndPredict(matfile, in, doUpdate)
%#codegen

persistent dlnet

if isempty(dlnet)
    dlnet = coder.loadDeepLearningNetwork(coder.const(matfile));
end

% Mark network for update
dlnet = coder.ai.enableParameterUpdate(dlnet);

if doUpdate
    % Update learnables from file when trigger signal doUpdate is true
    learnablesValue = coder.read('learnablesValue.coderdata');
    % Convert learnables to dlarray and assign them
    dlnet.Learnables.Value = cellfun(@dlarray,learnablesValue, 'UniformOutput', false);
end

% Run inference
out = dlnet.predict(in);

end
