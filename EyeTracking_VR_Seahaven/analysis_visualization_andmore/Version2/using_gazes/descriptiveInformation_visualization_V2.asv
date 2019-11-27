%----------------------- descriptiveInformation_visualisation-------------
% visualizes the overviewGazes_Statistics.mat created with descriptiveInformation_Analysis.m



clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\'


overviewGazes_Statistics = load(strcat(savepath,'overviewGazes_Statistics.mat'));

overviewGazes_Statistics = overviewGazes_Statistics.overviewGazes_Statistics;

overviewGazes_Statistics{2,1} = 100;
overviewGazes_Statistics{2,2} = 100;

plotSum = [overviewGazes_Statistics{2,3},overviewGazes_Statistics{2,4};overviewGazes_Statistics{2,7},overviewGazes_Statistics{2,8};overviewGazes_Statistics{2,5},overviewGazes_Statistics{2,6}];

ticknames = {'House';'Sky';'Other'};

figure(1)
plotty = bar(plotSum);
plotty(1).FaceColor = 'b';
plotty(2).FaceColor = 'c';
set(gca,'xticklabel',ticknames)
legend('Number of Gazes','overall duration of Gazes')
ylabel('Percentage')
grid on;
title('Distribution of gazes across categories');

saveas(gcf,strcat(savepath,'descriptiveDataPlot.png'));