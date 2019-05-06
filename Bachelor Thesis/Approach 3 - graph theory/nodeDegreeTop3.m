%----------------------- maxDegreeCentrality-------------
% written by Jasmin Walter

% visualizes the summaryFixations.mat created with descriptiveInformation_Analysis.m



clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\'

% load overviews

% load overview node degree
overviewNodeDegree= load('Overview_NodeDegree.mat');
overviewNodeDegree= overviewNodeDegree.overviewNodeDegree;

workingOverview = overviewNodeDegree;

% create overview of max elements:
participantVars = overviewNodeDegree.Properties.VariableNames;

overviewTop3 = table;

% extract and add 1st max to overview
[m1Element,max1Index] = max(workingOverview{:,2:end});
houses = workingOverview.houseList';

max1Table = houses(max1Index);
m1ElementT = array2table(m1Element);

overviewTop3 = [overviewTop3;max1Table;m1ElementT];
overviewTop3.Properties.VariableNames = participantVars(2:end);

% now delete first max from workingOverview
for index = 2:width(workingOverview)
    
    maxIndex = max1Index(index-1);
    workingOverview{maxIndex,index} = 0;
    
end


%% 2nd maximum

[m2Element,max2Index] = max(workingOverview{:,2:end});

max2Table = houses(max2Index);
m2ElementT = array2table(m2Element);

helperTable2 = table;
helperTable2 = [helperTable2;max2Table;m2ElementT];
helperTable2.Properties.VariableNames = participantVars(2:end);

overviewTop3 = [overviewTop3;helperTable2];

% now delete 2nd max from workingOverview
for index = 2:width(workingOverview)
    
    maxIndex = max2Index(index-1);
    workingOverview{maxIndex,index} = 0;
    
end

%% 3rd maximum

[m3Element,max3Index] = max(workingOverview{:,2:end});

max3Table = houses(max3Index);
m3ElementT = array2table(m3Element);

helperTable3 = table;
helperTable3 = [helperTable3;max3Table;m3ElementT];
helperTable3.Properties.VariableNames = participantVars(2:end);

overviewTop3 = [overviewTop3;helperTable3];

% now delete 2nd max from workingOverview
for index = 2:width(workingOverview)
    
    maxIndex = max3Index(index-1);
    workingOverview{maxIndex,index} = 0;
    
end

%%
% name rows

overviewTop3.Properties.RowNames = {'1stMaxHouse','1stMaxDegree','2ndMaxHouse','2ndMaxDegree','3rdMaxHouse','3rdMaxDegree'};

% save overview

save([savepath 'overviewTop3.mat'],'overviewTop3');

 
%% plot top3 with pie plots
% prepare 1st data, so it can be plotted nicely

max1st = overviewTop3{1,:}';

[uniqueMax1st,ia,ic] = unique(max1st);
occCounts1 = accumarray(ic,1);
sum_top1 = table;
sum_top1.Houses = uniqueMax1st;
sum_top1.Occurence = occCounts1;
sortSumTop1 = sortrows(sum_top1,2,'descend');


figure(1)
pie1st = pie(sortSumTop1.Occurence);
legend(sortSumTop1.Houses,'interpreter','none','location','bestoutside')
title({'Houses with highest node degree of each participant','     '});

saveas(gcf,strcat(savepath,'nodeDegreeTop1.jpg'),'jpg');
%% 
% prepare 2nd data, so it can be plotted nicely

max2nd = overviewTop3{3,:}';

[uniqueMax2st,ia,ic] = unique(max2nd);
occCounts2 = accumarray(ic,1);
sum_top2 = table;
sum_top2.Houses = uniqueMax2st;
sum_top2.Occurence = occCounts2;
sortSumTop2 = sortrows(sum_top2,2,'descend');


figure(2)
pie2nd = pie(sortSumTop2.Occurence);
legend(sortSumTop2.Houses,'interpreter','none','location','bestoutside')
title({'Houses with 2nd highest node degree of each participant','     '});

saveas(gcf,strcat(savepath,'nodeDegreeTop2.jpg'),'jpg');

%%
% prepare 3rd data, so it can be plotted nicely

max3rd = overviewTop3{5,:}';

[uniqueMax1st,ia,ic] = unique(max3rd);
occCounts3 = accumarray(ic,1);
sum_top3 = table;
sum_top3.Houses = uniqueMax1st;
sum_top3.Occurence = occCounts3;
sortSumTop3 = sortrows(sum_top3,2,'descend');


figure(3)
pie3rd = pie(sortSumTop3.Occurence);
legend(sortSumTop3.Houses,'interpreter','none','location','bestoutside')
title({'Houses with 3rd highest node degree of each participant','     '});

saveas(gcf,strcat(savepath,'nodeDegreeTop3.jpg'),'jpg');

%% all top 3 together


maxAll = [max1st; max2nd; max3rd];

[uniqueMaxAll,ia,ic] = unique(maxAll);
occCountsAll = accumarray(ic,1);
sum_topAll = table;
sum_topAll.Houses = uniqueMaxAll;
sum_topAll.Occurence = occCountsAll;
sortSumTopAll = sortrows(sum_topAll,2,'descend');

% combine all houses only occuring once into one data chunck

is1Occ = sortSumTopAll{:,2} == 1;

amount1Occ = sum(is1Occ);

sortSumComb = sortSumTopAll;
sortSumComb(is1Occ,:) = [];
helperComb = table;
helperComb.Houses = cellstr('houses occuring once');
helperComb.Occurence = amount1Occ;

% combine all houses only occuring only twice into one data chunck

is2Occ = sortSumTopAll{:,2} == 2;

amount2Occ = sum(is2Occ);

sortSumComb(is2Occ,:) = [];
helperComb2 = table;
helperComb2.Houses = cellstr('houses occuring twice');
helperComb2.Occurence = amount2Occ;

% combine all houses only occuring only 3times into one data chunck

is3Occ = sortSumTopAll{:,2} == 3;

amount3Occ = sum(is3Occ);

sortSumComb(is3Occ,:) = [];
helperComb3 = table;
helperComb3.Houses = cellstr('houses occuring 3x');
helperComb3.Occurence = amount3Occ;

sortSumComb = [sortSumComb;helperComb3; helperComb2;helperComb];

% plot it

figure(4)
pieAllTop = pie(sortSumComb.Occurence);
legend(sortSumComb.Houses,'interpreter','none','location','bestoutside')
title({'all houses with top 3 highest node degree of each participant', '     '});

saveas(gcf,strcat(savepath,'nodedegreeAllTop3Houses.jpg'),'jpg');


figure(5)
pieAllTop2 = pie(sortSumTopAll.Occurence);
legend(sortSumTopAll.Houses,'interpreter','none','location','bestoutside')
title({'all houses with top 3 highest node degree of each participant', '     '});

saveas(gcf,strcat(savepath,'nodedegreeAllTop3Houses2.jpg'),'jpg');