%----------------------- descriptiveInformation_visualisation-------------
% visualizes the summaryFixations.mat created with descriptiveInformation_Analysis.m



clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\';

cd 'D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\'


summaryFixations = load(strcat(savepath,'SummaryFixations.mat'));

summaryFixations = summaryFixations.summaryFixations;

summaryFixations{2,1} = 100;
summaryFixations{2,2} = 100;

plotSum = [summaryFixations{2,3},summaryFixations{2,4};summaryFixations{2,7},summaryFixations{2,8};summaryFixations{2,5},summaryFixations{2,6}];

ticknames = {'House';'Sky';'Other'};

figure(1)
plotty = bar(plotSum);
plotty(1).FaceColor = 'b';
plotty(2).FaceColor = 'c';
set(gca,'xticklabel',ticknames)
legend('Number of Fixations','Duration of Fixations')
ylabel('Percentage')
grid on;
title('Distribution of fixations across categories');

saveas(gcf,strcat(savepath,'descriptiveDataPlot.png'));