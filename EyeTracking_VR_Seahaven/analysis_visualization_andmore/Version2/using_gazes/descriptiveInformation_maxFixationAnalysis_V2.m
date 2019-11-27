%----------------------- descriptiveInformation_visualisation-------------
% written by Jasmin Walter

% visualizes the distribution of houses with the maximum gazes count of every participant

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\';

cd 'D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\'

% load overviews

overviewFixationHousesNr = load('overviewFixationHouseNr.mat');
overviewFixationHousesNr = overviewFixationHousesNr.overviewFixationHousesNr;

overviewFixationHousesDuration = load('overviewFixationHouseDuration.mat');
overviewFixationHousesDuration = overviewFixationHousesDuration.overviewFixationHousesDuration;

% create overview of max elements:
participantVars = overviewFixationHousesNr.Properties.VariableNames;

overviewMaximums = table;

% add max number to overview
[mElement,maxIndex] = max(overviewFixationHousesNr{:,2:end});
houses = overviewFixationHousesNr.Houses';

maxNrHousesT = houses(maxIndex);
mElementT = array2table(mElement);

overviewMaximums = [overviewMaximums;maxNrHousesT;mElementT];
overviewMaximums.Properties.VariableNames = participantVars(2:end);



% add max duration to overview

[mDuration,maxIDur] = max(overviewFixationHousesDuration{:,2:end});

maxDurHousesT = houses(maxIDur);
mDurationT = array2table(mDuration);

overviewDurations = table;
overviewDurations = [overviewDurations;maxDurHousesT;mDurationT];
overviewDurations.Properties.VariableNames = participantVars(2:end);

overviewMaximums = [overviewMaximums;overviewDurations];

% name rows

overviewMaximums.Properties.RowNames = {'1stMaxNrHouse','1stMaxNr','1stMaxDurHouse','1stMaxDurSamples'};

%save overview

save([savepath 'overviewMaximums.mat'],'overviewMaximums');


% prepare Nr max data, so it can be plotted nicely

maxNr = overviewMaximums{1,:}';

[uniqueMaxNr,ia,ic] = unique(maxNr);
occCounts = accumarray(ic,1);
sum_countsOcc = table;
sum_countsOcc.MaxElements = uniqueMaxNr;
sum_countsOcc.CountsOcc = occCounts;
sortSum = sortrows(sum_countsOcc,2,'descend');


figure(1)
pieNr = pie(sortSum.CountsOcc);
legend(sortSum.MaxElements,'interpreter','none','location','bestoutside')
title({'Houses with highest fixation count of each participant', 'all maximums are distributed over 18 houses'});

saveas(gcf,strcat(savepath,'maxNrFixationDistribution.jpg'),'jpg');

% prepare duration max data, so it can be plotted nicely

maxDur = overviewMaximums{3,:}';

[uniqueMaxDur,iaD,icD] = unique(maxDur);
occCountsD = accumarray(icD,1);
sum_countsDur = table;
sum_countsDur.MaxElements = uniqueMaxDur;
sum_countsDur.CountsOcc = occCountsD;
sortSumDur = sortrows(sum_countsDur,2,'descend');


figure(2)
pieDur = pie(sortSumDur.CountsOcc);
legend(sortSumDur.MaxElements,'interpreter','none','location','bestoutside')
title({'Houses with highest fixation duration of each participant', 'all maximums are distributed over 13 houses'});

saveas(gcf,strcat(savepath,'maxDurationFixationDistribution.jpg'),'jpg');


