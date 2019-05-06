%% -----------------------------newTry-------------------------------


clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';


% load overviews

overviewMaxFixations = load('D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\overviewMaximums.mat');
overviewMaxFixations = overviewMaxFixations.overviewMaximums;

overviewMaxNodeDegree = load('D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\overviewTop3.mat');

overviewMaxNodeDegree = overviewMaxNodeDegree.overviewTop3;



allHouses = [overviewMaxFixations{1,:},overviewMaxFixations{3,:},overviewMaxNodeDegree{1,:}];
allHouses = allHouses';

uniqueHouses = unique(allHouses);

%% create overviews with occurence of houses 
% for number of fixations

[uniqueFixNr,ia,ic] = unique(overviewMaxFixations{1,:}');
occFixNr = accumarray(ic,1);
helper_FixNr = table;
helper_FixNr.Houses = uniqueFixNr;
helper_FixNr.Occurence = occFixNr;



checkHouse = ismember(uniqueHouses, helper_FixNr.Houses);

missingFixNr = table;
missingFixNr.Houses = uniqueHouses(not(checkHouse));
missingFixNr.Occurence(:) = 0;

sumFixNr = table;
sumFixNr = [sumFixNr; helper_FixNr; missingFixNr];

sumFixNr = sortrows(sumFixNr,1);

% for duration of fixations

[uniqueFixDur,ia,ic] = unique(overviewMaxFixations{3,:}');
occFixDur = accumarray(ic,1);
helper_FixDur = table;
helper_FixDur.Houses = uniqueFixDur;
helper_FixDur.Occurence = occFixDur;

checkHouse = ismember(uniqueHouses, helper_FixDur.Houses);

missingFixDur = table;
missingFixDur.Houses = uniqueHouses(not(checkHouse));
missingFixDur.Occurence(:) = 0;

sumFixDur = table;
sumFixDur = [sumFixDur; helper_FixDur; missingFixDur];
sumFixDur = sortrows(sumFixDur,1);

% for node degree


[uniqueDegree,ia,ic] = unique(overviewMaxNodeDegree{1,:}');
occDegree = accumarray(ic,1);
helper_Degree = table;
helper_Degree.Houses = uniqueDegree;
helper_Degree.Occurence = occDegree;

checkHouse = ismember(uniqueHouses, helper_Degree.Houses);

missingDegree = table;
missingDegree.Houses = uniqueHouses(not(checkHouse));
missingDegree.Occurence(:) = 0;

sumDegree = table;
sumDegree = [sumDegree; helper_Degree; missingDegree];
sumDegree = sortrows(sumDegree,1);

save(strcat(savepath,'sumFixNr.mat'),'sumFixNr');
save(strcat(savepath,'sumFixDur.mat'),'sumFixDur');
save(strcat(savepath,'sumDegree.mat'),'sumDegree');

% now scatter plot it
% 1st plot

figure(1)

scatty1 = scatter(categorical(sumFixNr.Houses),sumFixNr.Occurence,'filled','blue');

grid on;
hold on;

scatty2 = scatter(categorical(sumFixDur.Houses),sumFixDur.Occurence,'filled','cyan');

hold on;

scatty3 = scatter(categorical(sumDegree.Houses),sumDegree.Occurence,'s','filled','red');

set(gca,'TickLabelInterpreter','none')
ax = gca;
ax.XLabel.String = 'houses';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'number of participants';
ax.YLabel.FontSize = 12;

title({'Houses with maximums values in 3 categories','distribution over participants'});

legend({'house with max nr of fixations','house with max viewing duration','house with max node'},'interpreter','none')

saveas(gcf,strcat(savepath,'scatterAllMaximums.png'),'png');

% % using barplot
% 
% sumBar = [sumFixNr.Occurence, sumFixDur.Occurence, sumDegree.Occurence];
% 
% 
% figure(2)
% 
% barplott = bar(sumBar,'grouped');
% set(gca,'TickLabelInterpreter','none')
% set(barplott,{'FaceColor'},{'b';'c';'r'});
% xticks(linspace(0,26));
% set(gca,'XTickLabel',sumFixNr.Houses)
