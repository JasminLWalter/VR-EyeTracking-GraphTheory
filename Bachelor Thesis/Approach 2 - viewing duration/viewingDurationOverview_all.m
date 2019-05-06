%%---------------------viewingDurationsOverview_all-----------------------
% written by Jasmin Walter

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\viewingDurations\summedParticipants\';


cd 'D:\BA Backup\Data_after_Script\approach2-fixations\viewingDurations\summedParticipants\'


overviewAll = load('overviewViewingDuration_all.mat');
overviewAll = overviewAll.overviewAll;

overviewAllHouses = load('overviewViewingDuration_houses.mat');
overviewAllHouses = overviewAllHouses.overviewAllHouses;

overviewAllOther = load('overviewViewingDuration_skyNH.mat');
overviewAllOther = overviewAllOther.overviewAllOther;

meanAll = mean(overviewAll.Looks);
meanHouses = mean(overviewAllHouses.Looks);
meanOther = mean(overviewAllOther.Looks);

figure(1)
plotAll = boxplot(overviewAll.Looks);
grid on
set(gca,'XTickLabel',{'viewing durations'});
ax = gca;
ax.YLabel.String = 'samples';
ax.YLabel.FontSize = 12;

title('viewing durations of all objects - all participants');

saveas(gcf,strcat(savepath,'viewing durations of all objects - all participants.jpg'),'jpg');


figure(2)
plotHouses = boxplot(overviewAllHouses.Looks);
grid on
set(gca,'XTickLabel',{'viewing durations'});
ax = gca;
ax.YLabel.String = 'samples';
ax.YLabel.FontSize = 12;

title('viewing durations of all houses - all participants');
saveas(gcf,strcat(savepath,'viewing durations of all houses - all participants.jpg'),'jpg');


figure(3)

plotOther = boxplot(overviewAllOther.Looks);
grid on
set(gca,'XTickLabel',{'viewing durations'});
ax = gca;
ax.YLabel.String = 'samples';
ax.YLabel.FontSize = 12;
title('viewing durations of sky and NH objects - all participants');

saveas(gcf,strcat(savepath,'viewing durations of sky and NH objects - all participants.jpg'),'jpg');
