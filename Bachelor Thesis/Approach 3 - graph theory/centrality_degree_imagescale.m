%------------------- image scale degree centrality-----------------------
% creates image scale for node degree centrality values over all
% participants
% prepares data for Anova - adds 1 and takes log

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\'


overviewDegree= load('Overview_NodeDegree.mat');

overviewDegree= overviewDegree.overviewNodeDegree;
%% create image scale
transpose2plot= overviewDegree{:,2:end}';

fig = figure;
imagescaly = imagesc(transpose2plot);
colorbar
title({'Image Scale Degree Centrality - all Participants','     '});
ax = gca;
ax.XTick = 0:10:213;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:213;

 ax.XLabel.String = 'Houses';
 ax.YLabel.String = 'Participants';
 
 %saveas(gcf,strcat(savepath,'ImageScale_DegreeCentrality_allParticipants.png'),'png');
 %fig.PaperPositionMode = 'manual';
 %orient(fig,'landscape')
 %print(gcf,'ImageScale_DegreeCentrality_allParticipants.pdf','-dpdf','-fillpage')
 
% %% prepare data for anova
% 
% dataMat = overviewDegree{:,2:end};
% datest = log(dataMat +1);
% dataLnAnd1= overviewDegree;
% dataLnAnd1{:,2:end} = log(dataLnAnd1{:,2:end}+1);
% %writetable(dataLnAnd1, [savepath 'prepDataNodeDegreeLn+1.csv'],'Delimiter',',');

