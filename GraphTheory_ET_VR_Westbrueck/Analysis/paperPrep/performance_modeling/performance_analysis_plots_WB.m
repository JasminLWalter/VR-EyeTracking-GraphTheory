%% ------------------ performance_analysis_plots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\';


imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location


cd 'F:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

saveAll = true;

%% load the data overview
dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
variableNames = dataP2B.Properties.VariableNames;


overviewTrialRepDiffAbs = readtable('overviewTrialRepDiff_absoluteError.csv');

trialRepDiffAbs = load('trialRepDiffAbs.mat');
trialRepDiffAbs = trialRepDiffAbs.trialRepDiffAbs;

trialRepDiffMean = load('trialRepDiffMean.mat');
trialRepDiffMean = trialRepDiffMean.trialRepDiffMean;

trialRepDiffStd = load('trialRepDiffStd.mat');
trialRepDiffStd = trialRepDiffStd.trialRepDiffStd;


%% create an overview of the mean performance of each participant
% also save all performance data for each participant seperately in cell

overviewPerformance = table;
overviewMeans = [];
overviewSTD = [];

performanceDataIndividual = [];

edges=(0:10:180);



for index= 1: length(PartList)

    currentPart = PartList(index);

    selection = dataP2B.SubjectID == currentPart;

    % save mean and std 
    overviewMeans = [overviewMeans, mean(dataP2B.RecalculatedAngle(selection))];
    overviewSTD = [overviewSTD, std(dataP2B.RecalculatedAngle(selection))];


end


overviewPerformance.Participants = PartList';
overviewPerformance.meanPerformance = overviewMeans';
overviewPerformance.stdPerformance = overviewSTD';

%% save overview
if saveAll 

    save([savepath 'overviewPerformance'],'overviewPerformance');
    writetable(overviewPerformance, [savepath, 'overviewPerformance.csv']);
end
% 
% 
% %% plot boxplot of performance data
% 
% % sort the participants according to their mean performance
% 
% sortedOverviewPerformance = sortrows(overviewPerformance,2);
% sortedParticipantIDs = sortedOverviewPerformance.Participants;
% 
% % extract the individual performance and put in matrix
% 
% for index2 = 1:length(sortedParticipantIDs)
% 
%     currentPart = sortedParticipantIDs(index2);
%     selection = dataP2B.SubjectID == currentPart;
% 
%     % save performance separately
%     performanceDataIndividual = [performanceDataIndividual,dataP2B.RecalculatedAngle(selection)];
% end    
% 
% 
% figure(1)
% plotty = boxplot(performanceDataIndividual);
% xlabel('participants');
% ylabel('performance / angual error');
% title({'Performance grouped by participants - sorted by mean', ' '});
% 
% ax = gca;
% if saveAll       
%     exportgraphics(ax,strcat(savepath, 'boxplot_performance.png'),'Resolution',600)
% end
% 
% %% create errorbar plot  
% figure(2)
% 
% x = [1:26];
% plotty2 = errorbar(sortedOverviewPerformance.meanPerformance, sortedOverviewPerformance.stdPerformance,'black','Linewidth',1);
% xlabel('participants')
% ylabel('performance/angular error')
% xlim([-1 27])
% title({'Mean performance of each participant with error bars - sorted by mean', ' '});
% hold on
% 
% plotty2a = plot(sortedOverviewPerformance.meanPerformance,'b','Linewidth',3);
% 
% hold off
% 
% ax = gca;
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_plot_performance.png'),'Resolution',600)
% end
% 
% %% create histogram
% 
% figure(3)
% 
% plotty3 = histogram(sortedOverviewPerformance.meanPerformance,edges);
% 
% ylabel('frequency')
% xlabel('performance / angular error')
% title({'histogram of mean performance', ' '});
% 
% ax = gca;
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'histogram_performance.png'),'Resolution',600)
% end
% 
% %% create image scale and error bar for performance in all trials
% 
% % extract the data and sort into matrix
% uniqueTrials = unique(dataP2B(:,5:6),'rows');
% 
% overviewTrialPerformance = zeros(26,112);
% 
% for index3 = 1:length(sortedParticipantIDs)
% 
%     currentPart = sortedParticipantIDs(index3);
%     selection = dataP2B(dataP2B.SubjectID == currentPart,:);
% 
%     firstTrials = selection.TrialOrder == 1;
%     secondTrials = selection.TrialOrder ==2;
% 
%     trialPerformance = zeros(1,112);
% 
%     for index4 = 1: height(uniqueTrials)
% 
%         start = strcmp(selection.StartBuildingName, uniqueTrials{index4,1});
%         target = strcmp(selection.TargetBuildingName, uniqueTrials{index4,2});
% 
% 
%         trial1 = selection.RecalculatedAngle(start & target & firstTrials);
%         trial2 = selection.RecalculatedAngle(start & target & secondTrials);
% 
% 
%         trialPerformance(1,index4*2-1) = trial1;
%         trialPerformance(1,index4*2) = trial2;
% 
% 
%     end
% 
%     overviewTrialPerformance(index3,:) = trialPerformance;
% 
% end
% 
% 
% 
% figure(4)
% 
% imagescaly = imagesc(overviewTrialPerformance);
% colorbar
% title({'Image Scale Performance - all Trials','     '});
% ax = gca;
% ax.XTick = 0:10:244;
% ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'Trials';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allTrials.png'),'Resolution',600)
% end
% 
% % do the same but without sorting the participants
% 
% overviewTrialPerformance2 = zeros(26,112);
% 
% for index5 = 1:length(PartList)
% 
%     currentPart = PartList(index5);
%     selection = dataP2B(dataP2B.SubjectID == currentPart,:);
% 
%     firstTrials = selection.TrialOrder == 1;
%     secondTrials = selection.TrialOrder ==2;
% 
%     trialPerformance = zeros(1,112);
% 
%     for index6 = 1: height(uniqueTrials)
% 
%         start = strcmp(selection.StartBuildingName, uniqueTrials{index6,1});
%         target = strcmp(selection.TargetBuildingName, uniqueTrials{index6,2});
% 
% 
%         trial1 = selection.RecalculatedAngle(start & target & firstTrials);
%         trial2 = selection.RecalculatedAngle(start & target & secondTrials);
% 
% 
%         trialPerformance(1,index6*2-1) = trial1;
%         trialPerformance(1,index6*2) = trial2;
% 
%     end
% 
%     overviewTrialPerformance2(index5,:) = trialPerformance;
% 
% end
% 
% 
% 
% figure(40)
% 
% imagescaly = imagesc(overviewTrialPerformance2);
% colorbar
% title({'Image Scale Performance - all Trials','     '});
% ax = gca;
% ax.XTick = 0:10:244;
% ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'Trials';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% % save manually, to get more vertical format of figure
% % if saveAll
% %     exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allTrials_notsorted.png'),'Resolution',600)
% % end
% 
% 
% 
% %% create the corresponding error plots
% 
% meanTrials = mean(overviewTrialPerformance);
% meanParticipants = mean(overviewTrialPerformance,2);
% 
% stdTrials = std(overviewTrialPerformance);
% stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% x = [1:112];
% plotty2 = errorbar(meanTrials, stdTrials,'black','Linewidth',1);
% xlabel('Trials')
% ylabel('angular error')
% % xlim([-1 27])
% title({'Mean performance of each trial with error bars', ' '});
% hold on
% 
% plotty2a = plot(meanTrials,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_allTrials.png'),'Resolution',600)
% end
% 
% figure(6)
% x = [1:26];
% plotty2 = errorbar(meanParticipants, stdParticipants,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean performance of each participant with error bars', ' '});
% hold on
% 
% plotty2a = plot(meanParticipants,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_participants_vertical.png'),'Resolution',600)
% end
% 
% %% the same for the start and target house
% startHPerformanceMeans = zeros(length(sortedParticipantIDs),8);
% startHPerformanceSTDs = zeros(length(sortedParticipantIDs),8);
% 
% targetHPerformanceMeans = zeros(length(sortedParticipantIDs),8);
% targetHPerformanceSTDs = zeros(length(sortedParticipantIDs),8);
% 
% uniqueTrialHouses = unique(dataP2B.StartBuildingName);
% 
% for index5 = 1:length(sortedParticipantIDs)
% 
%     currentPart = sortedParticipantIDs(index5);
%     selection = dataP2B(dataP2B.SubjectID == currentPart,:);
% 
% 
%     for index6 = 1: height(uniqueTrialHouses)
% 
%         start = strcmp(selection.StartBuildingName, uniqueTrialHouses{index6});
%         target = strcmp(selection.TargetBuildingName, uniqueTrialHouses{index6});
% 
%         startHPerformanceMeans(index5,index6) = mean(selection.RecalculatedAngle(start));
%         startHPerformanceSTDs(index5,index6) = std(selection.RecalculatedAngle(start));
% 
%         targetHPerformanceMeans(index5,index6) = mean(selection.RecalculatedAngle(target));
%         targetHPerformanceSTDs(index5,index6) = std(selection.RecalculatedAngle(target));
%     end
% 
% end
% 
% 
% 
% %% Start House image scale and error plots
% 
% figure(7)
% 
% imagescaly = imagesc(startHPerformanceMeans);
% colorbar
% title({'Performance for each start house averaged over trials','     '});
% ax = gca;
% % ax.XTick = 0:10:213;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:213;
% ax.XLabel.String = 'Start Houses';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allStartHouses.png'),'Resolution',600)
% end
% 
% 
% % create the corresponding error plots
% 
% meanSH = mean(startHPerformanceMeans);
% meanParticipantsSH = mean(startHPerformanceMeans,2);
% 
% stdSH = std(startHPerformanceMeans);
% stdParticipantsSH = std(startHPerformanceMeans,0,2);
% 
% figure(8)
% x = [1:8];
% plotty8 = errorbar(meanSH, stdSH,'black','Linewidth',1);
% xlabel('Start Houses')
% ylabel('angular error')
% xlim([0 9])
% title({'Mean performance of each start house with error bars', ' '});
% hold on
% 
% plotty8a = plot(meanSH,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_allStartHouses.png'),'Resolution',600)
% end
% 
% figure(9)
% x = [1:26];
% plotty9 = errorbar(meanParticipantsSH, stdParticipantsSH,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean performance of each participant with error bars - StartHouses', ' '});
% hold on
% 
% plotty9a = plot(meanParticipantsSH,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_participants_vertical_SH.png'),'Resolution',600)
% end
% 
% %% Target House image scale and error plots
% 
% figure(10)
% 
% imagescaly3 = imagesc(targetHPerformanceMeans);
% colorbar
% title({'Performance for each target house averaged over trials','     '});
% ax = gca;
% % ax.XTick = 0:10:213;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:213;
% ax.XLabel.String = 'Target Houses';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allTargetHouses.png'),'Resolution',600)
% end
% 
% 
% % create the corresponding error plots
% 
% meanTH = mean(targetHPerformanceMeans);
% meanParticipantsTH = mean(targetHPerformanceMeans,2);
% 
% stdTH = std(targetHPerformanceMeans);
% stdParticipantsTH = std(targetHPerformanceMeans,0,2);
% 
% figure(11)
% x = [1:8];
% plotty11 = errorbar(meanTH, stdTH,'black','Linewidth',1);
% xlabel('Target Houses')
% ylabel('angular error')
% xlim([0 9])
% title({'Mean performance of each target house with error bars', ' '});
% hold on
% 
% plotty11a = plot(meanTH,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_allTargetHouses.png'),'Resolution',600)
% end
% 
% figure(12)
% x = [1:26];
% plotty12 = errorbar(meanParticipantsTH, stdParticipantsTH,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean performance of each participant with error bars - targetHouses', ' '});
% hold on
% 
% plotty12a = plot(meanParticipantsTH,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, 'errorbar_performance_participants_vertical_TH.png'),'Resolution',600)
% end
% %% plot the deviation between the repeated trials
% 
% currentRepDiff = trialRepDiffAbs;
% figure(13)
% 
% imagescaly3 = imagesc(currentRepDiff);
% colorbar
% title({'Absolute error difference between same trials','     '});
% ax = gca;
% % ax.XTick = 0:10:213;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:213;
% ax.XLabel.String = 'Unique Trials';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, '13_imagescale_performance_absoluteError_difference_trials.png'),'Resolution',600)
% end
% 
% 
% % create the corresponding error plots
% 
% meanTD = mean(currentRepDiff);
% meanParticipantsTD = mean(currentRepDiff,2);
% 
% stdTD = std(currentRepDiff);
% stdParticipantsTD = std(currentRepDiff,0,2);
% 
% figure(14)
% x = [1:56];
% plotty14 = errorbar(meanTD, stdTD,'black','Linewidth',1);
% xlabel('Unique Trials')
% ylabel('angular error')
% xlim([0 57])
% title({'Mean absolute repetition performance error with error bars', ' '});
% hold on
% 
% plotty14a = plot(meanTD,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% if saveAll
%     exportgraphics(ax,strcat(savepath, '14_errorbar_performance_mean_absoluteError_difference_trials.png'),'Resolution',600)
% end
% 
% figure(15)
% x = [1:26];
% plotty15 = errorbar(meanParticipantsTD, stdParticipantsTD,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean absolute repetition error of each participant with error bars - targetHouses', ' '});
% hold on
% 
% plotty15a = plot(meanParticipantsTD,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% if saveAll
%     exportgraphics(ax,strcat(savepath, '15_errorbar_performance_participants_performance_absoluteError_difference_trials.png'),'Resolution',600)
% end
% 
% % do the same with the mean error
% 
% currentRepDiff = trialRepDiffMean;
% 
% figure(16)
% 
% imagescaly3 = imagesc(currentRepDiff);
% colorbar
% title({'Mean performance error unique trials','     '});
% ax = gca;
% % ax.XTick = 0:10:213;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:213;
% ax.XLabel.String = 'Unique Trials';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, '16_imagescale_performance_MeanError_trials.png'),'Resolution',600)
% end
% 
% 
% % create the corresponding error plots
% 
% meanTD = mean(currentRepDiff);
% meanParticipantsTD = mean(currentRepDiff,2);
% 
% stdTD = std(currentRepDiff);
% stdParticipantsTD = std(currentRepDiff,0,2);
% 
% figure(17)
% x = [1:56];
% plotty17 = errorbar(meanTD, stdTD,'black','Linewidth',1);
% xlabel('unique trials')
% ylabel('angular error')
% xlim([0 57])
% title({'Mean performance in unique trials with error bars', ' '});
% hold on
% 
% plotty17a = plot(meanTD,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, '17_errorbar_performance_mean_mean_uniqueTrials.png'),'Resolution',600)
% end
% 
% figure(18)
% x = [1:26];
% plotty15 = errorbar(meanParticipantsTD, stdParticipantsTD,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean performance error of each participant over unique trials with error bars - targetHouses', ' '});
% hold on
% 
% plotty18a = plot(meanParticipantsTD,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% 
% if saveAll
%     exportgraphics(ax,strcat(savepath, '18_errorbar_performance_participants_ meanError_uniqueTrials.png'),'Resolution',600)
% end
% 
% 
% %% plot the task buildings on map and color code them according to their performance
% 
% % load map
% 
% map = imread (strcat(imagepath,'map_natural_white_flipped.png'));
% 
% % load house list with coordinates
% 
% listname = strcat(clistpath,'building_collider_list.csv');
% colliderList = readtable(listname);
% 
% [uhouses,loc1,loc2] = unique(colliderList.target_collider_name);
% 
% houseList = colliderList(loc1,:);
% 
% 
% 
% % plot 1 - task buildings on map
% 
% node = ismember(houseList.target_collider_name,uniqueTrialHouses);
% x = houseList.transformed_collidercenter_x(node);
% y = houseList.transformed_collidercenter_y(node);
% 
% % display map
% figure(19)
% imshow(map);
% alpha(0.2)
% hold on;
% 
% plotty19 = scatter(x, y,'filled');
% 
% set(gca,'xdir','normal','ydir','normal')
% title('Task Buildings in Westbrook')
% 
% if saveAll
%     saveas(gcf,strcat(savepath,'taskBuildings_onMap.png'));
% end
% 
% % color code the task buildings based on performance as start buildings
% 
% colorCode = meanSH;
% 
% % display map
% figure(20)
% imshow(map);
% alpha(0.2)
% hold on;
% 
% plotty20 = scatter(x, y, 50, colorCode, 'filled');
% % colormap(flipud(parula))
% colormap(parula)
% colorbar
% set(gca,'xdir','normal','ydir','normal')
% title('Task buildings color coded to mean performance as start building')
% 
% if saveAll
%     saveas(gcf,strcat(savepath,'taskBuildings_meanPerformance_startBuilding.png'));
% end
% % color code the task buildings based on performance as start buildings
% 
% colorCode = meanTH;
% 
% % display map
% figure(21)
% imshow(map);
% alpha(0.2)
% hold on;
% 
% plotty21 = scatter(x, y, 50, colorCode, 'filled');
% % colormap(flipud(parula))
% colormap(parula)
% 
% colorbar
% set(gca,'xdir','normal','ydir','normal')
% title('Task buildings color coded to mean performance as target building')
% 
% if saveAll
%     saveas(gcf,strcat(savepath,'taskBuildings_meanPerformance_targetBuilding.png'));
% end
% 
% 
