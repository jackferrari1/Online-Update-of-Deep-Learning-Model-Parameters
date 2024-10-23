function rmseOriginal = runInferenceAndPlotPredictions(dlnet, XTest, YTest)

dlXTest = dlarray(single(XTest),"CT");
YPredOriginal = predict(dlnet,dlXTest);
rmseOriginal = rmse(YTest,extractdata(YPredOriginal));

figure
plot(YPredOriginal);
hold on;
plot(YTest,'k--',LineWidth=2); 
hold off
xlabel("Sample")
ylabel("Y")
legend("SOC estimated using original network","SOC ground truth",location="best");

end