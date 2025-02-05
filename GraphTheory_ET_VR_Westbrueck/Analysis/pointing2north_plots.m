%% ------------------- plot_pointing2north.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;


%% adjust the following variables: 
% savepath, imagepath, clistpath, current folder and participant list!-----

savepath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\P2N_plots\';
savepath2 = 'F:\Cyprus_project_overview\data\analysis\pointing_tasks\';


cd 'D:\WestbrookData\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];




p2n = readtable('df_PTN_Ctrl_Preprocessed.csv');

saveAll = true;

%% create an overview of the mean performance of each participant
% also save all performance data for each participant seperately in cell

overviewPerformance = table;
overviewMeans = [];
overviewSTD = [];

performanceDataIndividual = [];

edges=(0:10:180);



for index= 1: length(PartList)
   
    currentPart = PartList(index);
    
    selection = p2n.SubjectID == currentPart;
    
    % save mean and std 
    overviewMeans = [overviewMeans, mean(p2n.RecalculatedAngle(selection))];
    overviewSTD = [overviewSTD, std(p2n.RecalculatedAngle(selection))];
    
end

overviewPerformance.Participants = PartList';
overviewPerformance.meanPerformance = overviewMeans';
overviewPerformance.stdPerformance = overviewSTD';

%% save overview
if saveAll 
        
    save([savepath 'overviewPerformance'],'overviewPerformance');
    save([savepath 'overviewPerformance'],'overviewPerformance');
    writetable(overviewPerformance, [savepath, 'overviewPerformance.csv']);
end


%% plot boxplot of performance data

% sort the participants according to their mean performance

sortedOverviewPerformance = sortrows(overviewPerformance,2);
sortedParticipantIDs = sortedOverviewPerformance.Participants;

% extract the individual performance and put in matrix

for index2 = 1:length(sortedParticipantIDs)
    
    currentPart = sortedParticipantIDs(index2);
    selection = p2n.SubjectID == currentPart;

    % save performance separately
    performanceDataIndividual = [performanceDataIndividual,p2n.RecalculatedAngle(selection)];
end    



figure(1)
plotty = boxchart(performanceDataIndividual, 'Notch','on');
xlabel('participants');
ylabel('performance / angual error');
title({'Performance grouped by participants - sorted by mean', ' '});
% 
hold on
plot(mean(performanceDataIndividual), '-o')  % x-axis is the intergers of position
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath, 'boxplot_performance.png'),'Resolution',600)
end


%% performance Limassol plots


limassolTasks = readtable("F:\Cyprus_project_overview\store_cyprus_project\task_data\task_error.csv");

allP2B = [];

for index = 2:9

allP2B = [allP2B; limassolTasks{:,index}];


end


meanValue =  mean(allP2B,"omitmissing");

disp(meanValue)

figure(2)
plotty = boxchart(allP2B);
ylabel('performance / angual error');
title({'Performance P2B Limassol', ' '});
% 
hold on
plot([0.5, 1.5], [meanValue,meanValue]);

hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath2, 'boxplot_performance_limassolP2B.png'),'Resolution',600)
end


% pointing to north task

meanValueN =  mean(limassolTasks.North,"omitmissing");

disp(meanValueN)

figure(3)
plotty = boxchart(limassolTasks.North);
ylabel('performance / angual error');
title({'Performance P2B Limassol', ' '});
% 
hold on
plot([0.5, 1.5], [meanValueN,meanValueN]);
ylim([0,180])

hold off

ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath2, 'boxplot_performance_limassolP2N.png'),'Resolution',600)
end


