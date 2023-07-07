clear all;

%% adjust the following variables: 

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\performance_fixed_effects_analysis\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

%% load data overvew
dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');

variableNames = dataP2B.Properties.VariableNames;

%% load overview of the mean performance of each participant
overviewPerformance = load('F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\overviewPerformance.mat');
overviewPerformance = overviewPerformance.overviewPerformance;

%% load FRS data

overviewFRS = readtable('Overview_FRS_Data.csv');

%% sort participants and get unique building lists

% sort the participants according to their mean performance

sortedOverviewPerformance = sortrows(overviewPerformance,2);
sortedParticipantIDs = sortedOverviewPerformance.Participants;

% get a list of all houses/nodes
uniqueTrialHouses = unique(dataP2B.StartBuildingName);

%% create colors for plots later

colorHouses = parula(height(uniqueTrialHouses));
colorParticipants = parula(length(PartList));
colorUniqueTrials = parula(28);

%% create overviews for the node based measures

overviewNodeDegree = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% these combinations are identical
% overviewNodeDegreeStartHouses = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% overviewNodeDegreeTargetHouses = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));

overviewNodeDegree_weighted = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% these combinations are identical
% overviewNodeDegreeStartHouses_weighted = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% overviewNodeDegreeTargetHouses_weighted = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));

overviewBuildingsDwellingTime = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% these combinations are identical
% overviewStartBuildingDwellingTime = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
% overviewTargetBuildingDwellingTime= zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));

% and corresponding performance means

overviewPerformance_startHouses = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));
overviewPerformance_targetHouses  = zeros(length(sortedParticipantIDs), height(uniqueTrialHouses));

% create means and fill in overviews
for index = 1:length(sortedParticipantIDs)
   
    currentPart = sortedParticipantIDs(index);
    selection = dataP2B(dataP2B.SubjectID == currentPart,:);

    
    for index2 = 1: height(uniqueTrialHouses)
        
        start = strcmp(selection.StartBuildingName, uniqueTrialHouses{index2});
        target = strcmp(selection.TargetBuildingName, uniqueTrialHouses{index2});
                
        overviewNodeDegree(index,index2) = mean(selection{start,7});
        
        overviewNodeDegree_weighted(index,index2) = mean(selection{start,9});
        
        overviewBuildingsDwellingTime(index, index2) = mean(selection{start,15});
        % and corresponding performance means
        
        overviewPerformance_startHouses(index,index2) = mean(selection{start,5});
        overviewPerformance_targetHouses(index,index2) = mean(selection{target,5});
        
    end
        
end

%% create overviews of all trial based measures

% create a list with unique trials
uniqueTrials = unique(dataP2B(:,3:4),'rows');
uniqueTrialsWithOutRep = uniqueTrials;

%remove doublicates
uniqueTrialsWithOutRep(50:56,:) = [];
uniqueTrialsWithOutRep(43:48,:) = [];
uniqueTrialsWithOutRep(36:40,:) = [];
uniqueTrialsWithOutRep(29:32,:) = [];
uniqueTrialsWithOutRep(22:24,:) = [];
uniqueTrialsWithOutRep(15:16,:) = [];
uniqueTrialsWithOutRep(8,:) = [];



%% check of max flow is always equivalent in both directions
% overviewEquMaxFlowS = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));
% overviewEquMaxFlowW = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));
% 
% for index = 1:length(sortedParticipantIDs)
%    
%     currentPart = sortedParticipantIDs(index);
%     selection = dataP2B(dataP2B.SubjectID == currentPart,:);
% 
%     
%     for index2 = 1: height(uniqueTrialsWithOutRep)
%         
%         oneH = uniqueTrials{index2,1};
%         twoH = uniqueTrials{index2,2};
%         
%         oneCombi = strcmp(selection.StartBuildingName, oneH) & strcmp(selection.TargetBuildingName, twoH);
%         twoCombi = strcmp(selection.StartBuildingName, twoH) & strcmp(selection.TargetBuildingName, oneH);
% 
%         % binary max flow
%         meanMaxFlowS1C = mean(selection{oneCombi,11});
%         meanMaxFlowS2C = mean(selection{twoCombi,11});
%         
%         overviewEquMaxFlowS(index, index2) = meanMaxFlowS1C == meanMaxFlowS2C;
%         
%         % weighted max flow
%         meanMaxFlowW1C = mean(selection{oneCombi,12});
%         meanMaxFlowW2C = mean(selection{twoCombi,12});
%         
%         overviewEquMaxFlowW(index, index2) = meanMaxFlowW1C == meanMaxFlowW2C;
%         
%     end
%         
% end

%% calculate all unique edge trial based measures

overviewMaxFlowS = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));
overviewMaxFlowW = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));
overviewShortestPath = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));
overviewAlternatingIndex = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));

overviewDistancePart2Building = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));

% and corresponding performance means
overviewPerformance_uniqueEdgeTrials = zeros(length(sortedParticipantIDs), height(uniqueTrialsWithOutRep));



for index3 = 1:length(sortedParticipantIDs)
   
    currentPart = sortedParticipantIDs(index3);
    selection = dataP2B(dataP2B.SubjectID == currentPart,:);

    
    for index4 = 1: height(uniqueTrialsWithOutRep)
        
        oneH = uniqueTrials{index4,1};
        twoH = uniqueTrials{index4,2};
        
        oneCombi = strcmp(selection.StartBuildingName, oneH) & strcmp(selection.TargetBuildingName, twoH);
        twoCombi = strcmp(selection.StartBuildingName, twoH) & strcmp(selection.TargetBuildingName, oneH);

        bothHouseCombis = oneCombi | twoCombi;
        
        overviewMaxFlowS(index3, index4) = mean(selection{bothHouseCombis,11});
        overviewMaxFlowW(index3, index4)= mean(selection{bothHouseCombis,12});
        overviewShortestPath(index3, index4) = mean(selection{bothHouseCombis,13});
        overviewAlternatingIndex(index3, index4) = mean(selection{bothHouseCombis,14});
        
        overviewDistancePart2Building(index3, index4) = mean(selection{bothHouseCombis,6});

        % and corresponding performance means
        
        overviewPerformance_uniqueEdgeTrials(index3, index4) = mean(selection{bothHouseCombis,5});
   
    end
        
end
%% plot all node based measures

%% node degree - general visualizations
% % boxplot of ND averaged over participants for all task houses
% figure(1)
% plotty1 = boxplot(overviewNodeDegree);
% xlabel('task building');
% ylabel('node degree');
% title({'Node degree of each task building avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '1_nodeDegree_taskBuildings_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(overviewNodeDegree');
% xlabel('participants');
% ylabel('node degree');
% title({'Node degree of participants avg over task buildings', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '2_nodeDegree_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(overviewNodeDegree);
% 
% xlabel('node degree - task buildings')
% ylabel('frequency')
% title({'Distribution of node degree values', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '3_nodeDegree_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(overviewNodeDegree);
% colorbar
% title({'Image Scale - node Degree - task buildings','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'task building';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '4_nodeDegree_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% x = [1:8];
% plotty5 = errorbar(mean(overviewNodeDegree), std(overviewNodeDegree),'black','Linewidth',1);
% xlabel('task buildings')
% ylabel('node degree')
% xlim([0 9])
% title({'Mean node degree of each task building with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(overviewNodeDegree),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '5_nodeDegree_taskBuilding_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% x = [1:26];
% plotty3 = errorbar(mean(overviewNodeDegree,2), std(overviewNodeDegree,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('node degree')
% xlim([-1 27])
% title({'Mean node degree of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(overviewNodeDegree,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '6_nodeDegree_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(overviewNodeDegree)
%    
%    plotty7 = scatter(overviewNodeDegree(:,indexC1),overviewPerformance_startHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('node degree - start buildings')
% ylabel('mean error - start buildings')
% title({'Node degree of start buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree);
% 
% % Add regression line to plot
% plot(overviewNodeDegree, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '7_nodeDegree_performance_startBuildings_colorBuildings.png'),'Resolution',600);
% 
% % second - every participant has their own color
% 
% colorHouses = parula(height(uniqueTrialHouses));
% colorParticipants = parula(length(PartList));
% 
% figure(8)
% for indexC2 = 1: height(overviewNodeDegree)
%    
%    plotty8 = scatter(overviewNodeDegree(indexC2,:),overviewPerformance_startHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('node degree - start buildings')
% ylabel('mean error - start buildings')
% title({'Node degree of start buildings and performance - 1 color for each participant', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree);
% 
% % Add regression line to plot
% plot(overviewNodeDegree, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '8_nodeDegree_performance_startBuildings_colorParticipants.png'),'Resolution',600);
% 
% % target building
% % first - every house has its own color
% 
% colorHouses = parula(height(uniqueTrialHouses));
% colorParticipants = parula(length(PartList));
% 
% figure(9)
% for indexC1 = 1: width(overviewNodeDegree)
%    
%    plotty9 = scatter(overviewNodeDegree(:,indexC1),overviewPerformance_targetHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('node degree - target buildings')
% ylabel('mean error - target buildings')
% title({'Node degree of target buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree);
% 
% % Add regression line to plot
% plot(overviewNodeDegree, yfit, 'r-')
% % legend('Data', 'Regression Line')
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '9_nodeDegree_performance_targetBuildings_colorBuildings.png'),'Resolution',600);
% legend('House1', 'House2', 'House3', 'House4', 'House5', 'House6', 'House7', 'House8',  'Regression','Location','northeastoutside'); 
% hold off
% 
% % second - every participant has their own color
% 
% figure(10)
% for indexC2 = 1: height(overviewNodeDegree)
%    
%    plotty10 = scatter(overviewNodeDegree(indexC2,:),overviewPerformance_targetHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('node degree - target buildings')
% ylabel('mean error - target buildings')
% title({'Node degree of target buildings and performance - 1 color for each participant', ' '})
% % Calculate regression line
% p = polyfit(overviewNodeDegree, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree);
% 
% % Add regression line to plot
% plot(overviewNodeDegree, yfit, 'r-')
% % legend('Data', 'Regression Line')
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '10_nodeDegree_performance_targetBuilding_colorParticipants.png'),'Resolution',600);
% 
% % save legend
% legend('Part1', 'Part2', 'Part3', 'Part4', 'Part5', 'Part6', 'Part7', 'Part8', 'Part9', 'Part10', 'Part11', 'Part12', 'Part13', 'Part14', 'Part15', 'Part16', 'Part17','Part18', 'Part19', 'Part20', 'Part21', 'Part22', 'Part23', 'Part24', 'Part25', 'Part26', 'Regression','Location','northeastoutside'); 
% 
% % ax = gca;
% % exportgraphics(ax,strcat(savepath, '0_legend_colorParticipants.png'),'Resolution',600);
% 
% hold off



%% node degree weighted
% % boxplot of ND averaged over participants for all task houses
% figure(1)
% plotty1 = boxplot(overviewNodeDegree_weighted);
% xlabel('task building');
% ylabel('weighted node degree');
% title({'Weighted node degree of each task building avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '11_weighted_nodeDegree_taskBuildings_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(overviewNodeDegree_weighted');
% xlabel('participants');
% ylabel('weighted node degree');
% title({'Weighted node degree of participants avg over task buildings', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '12_weighted_nodeDegree_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(overviewNodeDegree_weighted);
% 
% xlabel('weighted node degree - task buildings')
% ylabel('frequency')
% title({'Distribution of weighted node degree values', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '13_weighted nodeDegree_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(overviewNodeDegree_weighted);
% colorbar
% title({'Image Scale - weighted node Degree - task buildings','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'task building';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '14_weighted_nodeDegree_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(overviewNodeDegree_weighted), std(overviewNodeDegree_weighted),'black','Linewidth',1);
% xlabel('task buildings')
% ylabel('weighted node degree')
% xlim([0 9])
% title({'Mean weighted node degree of each task building with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(overviewNodeDegree_weighted),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '15_weighted_nodeDegree_taskBuilding_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(overviewNodeDegree_weighted,2), std(overviewNodeDegree_weighted,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('weighted node degree')
% xlim([-1 27])
% title({'Mean weighted node degree of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(overviewNodeDegree_weighted,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '16_weighted_nodeDegree_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(overviewNodeDegree_weighted)
%    
%    plotty7 = scatter(overviewNodeDegree_weighted(:,indexC1),overviewPerformance_startHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('weighted node degree - start buildings')
% ylabel('mean error - start buildings')
% title({'Weighted Node degree of start buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree_weighted, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree_weighted);
% 
% % Add regression line to plot
% plot(overviewNodeDegree_weighted, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '17_weighted_nodeDegree_performance_startBuildings_colorBuildings.png'),'Resolution',600);
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(overviewNodeDegree_weighted)
%    
%    plotty8 = scatter(overviewNodeDegree_weighted(indexC2,:),overviewPerformance_startHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('weighted node degree - start buildings')
% ylabel('mean error - start buildings')
% title({'Weighted node degree of start buildings and performance - 1 color for each participant', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree_weighted, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree_weighted);
% 
% % Add regression line to plot
% plot(overviewNodeDegree_weighted, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '18_weighted_nodeDegree_performance_startBuildings_colorParticipants.png'),'Resolution',600);
% 
% % target building
% % first - every house has its own color
% 
% 
% figure(9)
% for indexC1 = 1: width(overviewNodeDegree_weighted)
%    
%    plotty9 = scatter(overviewNodeDegree_weighted(:,indexC1),overviewPerformance_targetHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('weighted node degree - target buildings')
% ylabel('mean error - target buildings')
% title({'Weighted node degree of target buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree_weighted, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree_weighted);
% 
% % Add regression line to plot
% plot(overviewNodeDegree_weighted, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '19_weighted_nodeDegree_performance_targetBuildings_colorBuildings.png'),'Resolution',600);
% 
% % second - every participant has their own color
% 
% 
% figure(10)
% for indexC2 = 1: height(overviewNodeDegree_weighted)
%    
%    plotty10 = scatter(overviewNodeDegree_weighted(indexC2,:),overviewPerformance_targetHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('weighted node degree - target buildings')
% ylabel('mean error - target buildings')
% title({'Weighted node degree of target buildings and performance - 1 color for each participant', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewNodeDegree_weighted, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewNodeDegree_weighted);
% 
% % Add regression line to plot
% plot(overviewNodeDegree_weighted, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '20_weighted_nodeDegree_performance_targetBuilding_colorParticipants.png'),'Resolution',600);


%% dwelling time

% % boxplot of ND averaged over participants for all task houses
% figure(1)
% plotty1 = boxplot(overviewBuildingsDwellingTime);
% xlabel('task building');
% ylabel('dwelling time s');
% title({'Dwelling time of each task building avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '21_dwellingTime_taskBuildings_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(overviewBuildingsDwellingTime');
% xlabel('participants');
% ylabel('dwelling time s');
% title({'Dwelling time of participants avg over task buildings', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '22_dwellingTime_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(overviewBuildingsDwellingTime);
% 
% xlabel('dwelling time s - task buildings')
% ylabel('frequency')
% title({'Distribution of dwelling time', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '23_dwellingTime_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(overviewBuildingsDwellingTime);
% colorbar
% title({'Image Scale - dwelling time s - task buildings','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'task building';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '24_dwellingTime_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(overviewBuildingsDwellingTime), std(overviewBuildingsDwellingTime),'black','Linewidth',1);
% xlabel('task buildings')
% ylabel('dwelling time s')
% xlim([0 9])
% title({'Mean dwelling time of each task building with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(overviewBuildingsDwellingTime),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '25_dwellingTime_taskBuilding_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(overviewBuildingsDwellingTime,2), std(overviewBuildingsDwellingTime,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('dwelling time s')
% xlim([-1 27])
% title({'Mean dwelling time of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(overviewBuildingsDwellingTime,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '26_dwellingTime_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(overviewBuildingsDwellingTime)
%    
%    plotty7 = scatter(overviewBuildingsDwellingTime(:,indexC1),overviewPerformance_startHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('dwelling time s - start buildings')
% ylabel('mean error - start buildings')
% title({'Dwelling time of start buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewBuildingsDwellingTime, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewBuildingsDwellingTime);
% 
% % Add regression line to plot
% plot(overviewBuildingsDwellingTime, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '27_dwellingTime_performance_startBuildings_colorBuildings.png'),'Resolution',600);
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(overviewBuildingsDwellingTime)
%    
%    plotty8 = scatter(overviewBuildingsDwellingTime(indexC2,:),overviewPerformance_startHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('dwelling time s - start buildings')
% ylabel('mean error - start buildings')
% title({'Dwelling time of start buildings and performance - 1 color for each participant', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewBuildingsDwellingTime, overviewPerformance_startHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewBuildingsDwellingTime);
% 
% % Add regression line to plot
% plot(overviewBuildingsDwellingTime, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '28_dwellingTime_performance_startBuildings_colorParticipants.png'),'Resolution',600);
% 
% % target building
% % first - every house has its own color
% 
% 
% figure(9)
% for indexC1 = 1: width(overviewBuildingsDwellingTime)
%    
%    plotty9 = scatter(overviewBuildingsDwellingTime(:,indexC1),overviewPerformance_targetHouses(:,indexC1),50,colorHouses(indexC1,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('dwelling time s - target buildings')
% ylabel('mean error - target buildings')
% title({'Dwelling time of target buildings and performance - 1 color for each building', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewBuildingsDwellingTime, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewBuildingsDwellingTime);
% 
% % Add regression line to plot
% plot(overviewBuildingsDwellingTime, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '29_dwellingTime_performance_targetBuildings_colorBuildings.png'),'Resolution',600);
% 
% % second - every participant has their own color
% 
% 
% figure(10)
% for indexC2 = 1: height(overviewBuildingsDwellingTime)
%    
%    plotty10 = scatter(overviewBuildingsDwellingTime(indexC2,:),overviewPerformance_targetHouses(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('dwelling time s - target buildings')
% ylabel('mean error - target buildings')
% title({'Dwelling time of target buildings and performance - 1 color for each participant', ' '})
% 
% % Calculate regression line
% p = polyfit(overviewBuildingsDwellingTime, overviewPerformance_targetHouses, 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, overviewBuildingsDwellingTime);
% 
% % Add regression line to plot
% plot(overviewBuildingsDwellingTime, yfit, 'r-')
% % legend('Data', 'Regression Line')
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '30_dwellingTime_performance_targetBuilding_colorParticipants.png'),'Resolution',600);


%% ---------------------------------------------------------------------------------------
%% all edge based measures
% overviewMaxFlowS
% overviewMaxFlowW
% overviewShortestPath 
% overviewAlternatingIndex
% overviewDistancePart2Building
%% Max flow un-weighted

% % boxplot of averaged over participants for all task houses
% 
% 
% figure(1)
% plotty1 = boxplot(overviewMaxFlowS);
% xlabel('edges/unique trials');
% ylabel('max flow');
% title({'Max flow of each unique trial/edge avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '31_maxFlow_trialsEdge_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(overviewMaxFlowS');
% xlabel('participants');
% ylabel('max flow');
% title({'Max flow of participants avg over unique trials/edges', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '32_maxFlow_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(overviewMaxFlowS);
% 
% xlabel('max flow - uniqe trials/edges')
% ylabel('frequency')
% title({'Distribution of max flow', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '33_maxFlow_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(overviewMaxFlowS);
% colorbar
% title({'Image Scale - max flow - unique trials/edges','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'trials/edges';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '34_maxFlow_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(overviewMaxFlowS), std(overviewMaxFlowS),'black','Linewidth',1);
% xlabel('trials/edges')
% ylabel('max flow')
% xlim([0 29])
% title({'Mean max flow of each unique trial/edge with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(overviewMaxFlowS),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '35_maxFlow_uniqueTrial_Edge_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(overviewMaxFlowS,2), std(overviewMaxFlowS,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('max flow')
% xlim([-1 27])
% title({'Mean max flow of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(overviewMaxFlowS,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '36_maxFlow_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(overviewMaxFlowS)
%    
%    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5);
% 
%    % command with legend information
% %    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5,'DisplayName',strcat('Edge',num2str(indexC1)));
%    hold on 
%     
% end
% 
% xlabel('max flow')
% ylabel('mean error')
% title({'Max flow and performance - 1 color for each trial/edge', ' '})
% 
% xRS = reshape(overviewMaxFlowS, [1],[]);
% yRS = reshape(overviewPerformance_uniqueEdgeTrials, [1],[]);
% 
% % Calculate regression line
% p = polyfit(xRS , yRS , 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, xRS );
% 
% % Add regression line to plot
% plot(xRS , yfit, 'r-', 'DisplayName','Regression')
% % legend 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '37_maxFlow_performance_colorTrials.png'),'Resolution',600);
% 
% 
% hold off
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(overviewMaxFlowS)
%    
%    plotty8 = scatter(overviewMaxFlowS(indexC2,:),overviewPerformance_uniqueEdgeTrials(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('max flow')
% ylabel('mean error')
% title({'Max flow and performance - 1 color for each participant', ' '})
% 
% plot(xRS , yfit, 'r-', 'DisplayName','Regression');
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '38_maxFlow_performance_colorParticipants.png'),'Resolution',600);


%% Max Flow Weighted

% currentOverview = overviewMaxFlowW;
% % boxplot of averaged over participants for all task houses
% 
% 
% figure(1)
% plotty1 = boxplot(currentOverview );
% xlabel('edges/unique trials');
% ylabel('weighted max flow');
% title({'Weighte max flow of each unique trial/edge avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '41_weighted_maxFlow_trialsEdge_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(currentOverview');
% xlabel('participants');
% ylabel('weighted max flow');
% title({'Weighted max flow of participants avg over unique trials/edges', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '42_weighted_maxFlow_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(currentOverview);
% 
% xlabel('weighted max flow - uniqe trials/edges')
% ylabel('frequency')
% title({'Distribution of weighted max flow', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '43_weighted_maxFlow_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(currentOverview );
% colorbar
% title({'Image Scale - weighted max flow - unique trials/edges','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'trials/edges';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '44_weighted_maxFlow_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(currentOverview), std(currentOverview),'black','Linewidth',1);
% xlabel('trials/edges')
% ylabel('weighted max flow')
% xlim([0 29])
% title({'Mean weighted max flow of each unique trial/edge with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(currentOverview),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '45_weighted_maxFlow_uniqueTrial_Edge_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(currentOverview,2), std(currentOverview,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('weighted max flow')
% xlim([-1 27])
% title({'Mean weighted max flow of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(currentOverview,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '46_weighted_maxFlow_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(currentOverview)
%    
%    plotty7 = scatter(currentOverview(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5);
% 
%    % command with legend information
% %    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5,'DisplayName',strcat('Edge',num2str(indexC1)));
%    hold on 
%     
% end
% 
% xlabel('weighted max flow')
% ylabel('mean error')
% title({'Weighted max flow and performance - 1 color for each trial/edge', ' '})
% 
% xRS = reshape(currentOverview, [1],[]);
% yRS = reshape(overviewPerformance_uniqueEdgeTrials, [1],[]);
% 
% % Calculate regression line
% p = polyfit(xRS , yRS , 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, xRS );
% 
% % Add regression line to plot
% plot(xRS , yfit, 'r-', 'DisplayName','Regression')
% % legend 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '47_weighted_maxFlow_performance_colorTrials.png'),'Resolution',600);
% 
% 
% hold off
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(currentOverview)
%    
%    plotty8 = scatter(currentOverview(indexC2,:),overviewPerformance_uniqueEdgeTrials(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('weighted max flow')
% ylabel('mean error')
% title({'Weighted max flow and performance - 1 color for each participant', ' '})
% 
% plot(xRS , yfit, 'r-', 'DisplayName','Regression');
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '48_weighted_maxFlow_performance_colorParticipants.png'),'Resolution',600);

%% alternating index
% currentOverview = overviewAlternatingIndex;
% % boxplot of averaged over participants for all task houses
% 
% 
% figure(1)
% plotty1 = boxplot(currentOverview );
% xlabel('edges/unique trials');
% ylabel('alternating index');
% title({'Alternating index of each unique trial/edge avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '51_alternatingIndex_trialsEdge_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(currentOverview');
% xlabel('participants');
% ylabel('alternating index');
% title({'Alternating index of participants avg over unique trials/edges', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '52_alternatingIndex_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(currentOverview);
% 
% xlabel('alternating index - uniqe trials/edges')
% ylabel('frequency')
% title({'Distribution alternating index', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '53_alternatingIndex_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(currentOverview );
% colorbar
% title({'Image Scale - alternating index - unique trials/edges','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'trials/edges';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '54_alternatingIndex_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(currentOverview), std(currentOverview),'black','Linewidth',1);
% xlabel('trials/edges')
% ylabel('alternating index')
% xlim([0 29])
% title({'Alternating indexof each unique trial/edge with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(currentOverview),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '55_alternatingIndex_uniqueTrial_Edge_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(currentOverview,2), std(currentOverview,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('alternating index')
% xlim([-1 27])
% title({'Alternating index of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(currentOverview,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '56_alternatingIndex_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(currentOverview)
%    
%    plotty7 = scatter(currentOverview(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5);
% 
%    % command with legend information
% %    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5,'DisplayName',strcat('Edge',num2str(indexC1)));
%    hold on 
%     
% end
% 
% xlabel('alternating index')
% ylabel('mean error')
% title({'Alternating index and performance - 1 color for each trial/edge', ' '})
% 
% xRS = reshape(currentOverview, [1],[]);
% yRS = reshape(overviewPerformance_uniqueEdgeTrials, [1],[]);
% 
% % Calculate regression line
% p = polyfit(xRS , yRS , 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, xRS );
% 
% % Add regression line to plot
% plot(xRS , yfit, 'r-', 'DisplayName','Regression')
% % legend 
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '57_alternatingIndex_performance_colorTrials.png'),'Resolution',600);
% 
% 
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(currentOverview)
%    
%    plotty8 = scatter(currentOverview(indexC2,:),overviewPerformance_uniqueEdgeTrials(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('alternating index')
% ylabel('mean error')
% title({'Alternating index and performance - 1 color for each participant', ' '})
% 
% plot(xRS , yfit, 'r-', 'DisplayName','Regression');
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '58_alternating_performance_colorParticipants.png'),'Resolution',600);

%% shortest path

% currentOverview = overviewShortestPath;
% % boxplot of averaged over participants for all task houses
% 
% 
% figure(1)
% plotty1 = boxplot(currentOverview );
% xlabel('edges/unique trials');
% ylabel('shortest path');
% title({'Shortest path of each unique trial/edge avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '61_shortestPath_trialsEdge_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(currentOverview');
% xlabel('participants');
% ylabel('shortest path');
% title({'Shortest path of participants avg over unique trials/edges', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '62_shortestPath_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(currentOverview);
% 
% xlabel('shortest path - uniqe trials/edges')
% ylabel('frequency')
% title({'Distribution alternating index', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '63_shortestPath_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(currentOverview );
% colorbar
% title({'Image Scale - shortest path - unique trials/edges','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'trials/edges';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '64_shortestPath_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(currentOverview), std(currentOverview),'black','Linewidth',1);
% xlabel('trials/edges')
% ylabel('shortest path')
% xlim([0 29])
% title({'Shortest path of each unique trial/edge with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(currentOverview),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '65_shortestPath_uniqueTrial_Edge_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(currentOverview,2), std(currentOverview,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('shortest path')
% xlim([-1 27])
% title({'Shortest path of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(currentOverview,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '66_shortestPath_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(currentOverview)
%    
%    plotty7 = scatter(currentOverview(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5);
% 
%    % command with legend information
% %    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5,'DisplayName',strcat('Edge',num2str(indexC1)));
%    hold on 
%     
% end
% 
% xlabel('shortest path')
% ylabel('mean error')
% title({'Shortest path and performance - 1 color for each trial/edge', ' '})
% 
% xRS = reshape(currentOverview, [1],[]);
% yRS = reshape(overviewPerformance_uniqueEdgeTrials, [1],[]);
% 
% % Calculate regression line
% p = polyfit(xRS , yRS , 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, xRS );
% 
% % Add regression line to plot
% plot(xRS , yfit, 'r-', 'DisplayName','Regression')
% % legend 
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '67_shortestPath_performance_colorTrials.png'),'Resolution',600);
% 
% 
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(currentOverview)
%    
%    plotty8 = scatter(currentOverview(indexC2,:),overviewPerformance_uniqueEdgeTrials(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('shortest path')
% ylabel('mean error')
% title({'Shortest path and performance - 1 color for each participant', ' '})
% 
% plot(xRS , yfit, 'r-', 'DisplayName','Regression');
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '68_shortestPath_performance_colorParticipants.png'),'Resolution',600);

%% distance participant 2 target building

% currentOverview = overviewDistancePart2Building;
% % boxplot of averaged over participants for all task houses
% 
% 
% figure(1)
% plotty1 = boxplot(currentOverview );
% xlabel('edges/unique trials');
% ylabel('distance');
% title({'Distance of each unique trial/edge avg over participants', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '71_distance_trialsEdge_boxplot.png'),'Resolution',600)
% 
% % boxplot of ND averaged over start houses for all participants
% figure(2)
% plotty2 = boxplot(currentOverview');
% xlabel('participants');
% ylabel('distance');
% title({'Distance of participants avg over unique trials/edges', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '72_distance_participants_boxplot.png'),'Resolution',600)
% 
% 
% figure(3)
% % edges2 =
% plotty3 = histogram(currentOverview);
% 
% xlabel('distance - uniqe trials/edges')
% ylabel('frequency')
% title({'Distribution distances', ' '});
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '73_distance_histogram.png'),'Resolution',600)
% 
% 
% 
% figure(4)
% 
% imagescaly4 = imagesc(currentOverview );
% colorbar
% title({'Image Scale - distance - unique trials/edges','     '});
% ax = gca;
% % ax.XTick = 0:10:8;
% ax.TickDir = 'out';
% % ax.XMinorTick = 'on';
% % ax.XAxis.MinorTickValues = 1:1:244;
% ax.XLabel.String = 'trials/edges';
% ax.YLabel.String = 'participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '74_distance_imagescale.png'),'Resolution',600)
% 
% 
% 
% % create the corresponding error plots
% 
% % meanTrials = mean(overviewTrialPerformance);
% % meanParticipants = mean(overviewTrialPerformance,2);
% 
% % stdTrials = std(overviewTrialPerformance);
% % stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% 
% plotty5 = errorbar(mean(currentOverview), std(currentOverview),'black','Linewidth',1);
% xlabel('trials/edges')
% ylabel('distance')
% xlim([0 29])
% title({'Distance of each unique trial/edge with error bars', ' '});
% hold on
% 
% plotty5a = plot(mean(currentOverview),'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, '75_distance_uniqueTrial_Edge_errorbar.png'),'Resolution',600)
% 
% 
% figure(6)
% 
% plotty3 = errorbar(mean(currentOverview,2), std(currentOverview,0,2),'black','Linewidth',1);
% xlabel('participants')
% ylabel('shortest path')
% xlim([-1 27])
% title({'Distance of each participant with error bars', ' '});
% hold on
% 
% plotty6a = plot(mean(currentOverview,2),'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '76_distance_participants_errorbar.png'),'Resolution',600)
% 
% % node degree and performance
% 
% % for start buildings
% 
% % first - every house has its own color
% 
% figure(7)
% for indexC1 = 1: width(currentOverview)
%    
%    plotty7 = scatter(currentOverview(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5);
% 
%    % command with legend information
% %    plotty7 = scatter(overviewMaxFlowS(:,indexC1),overviewPerformance_uniqueEdgeTrials(:,indexC1),50,colorUniqueTrials(indexC1,:),'filled','MarkerFaceAlpha',0.5,'DisplayName',strcat('Edge',num2str(indexC1)));
%    hold on 
%     
% end
% 
% xlabel('distance')
% ylabel('mean error')
% title({'Distance and performance - 1 color for each trial/edge', ' '})
% 
% xRS = reshape(currentOverview, [1],[]);
% yRS = reshape(overviewPerformance_uniqueEdgeTrials, [1],[]);
% 
% % Calculate regression line
% p = polyfit(xRS , yRS , 1);  % Fit a first-order polynomial (i.e. a line)
% yfit = polyval(p, xRS );
% 
% % Add regression line to plot
% plot(xRS , yfit, 'r-', 'DisplayName','Regression')
% % legend 
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '77_distance_performance_colorTrials.png'),'Resolution',600);
% 
% 
% 
% % second - every participant has their own color
% 
% 
% figure(8)
% for indexC2 = 1: height(currentOverview)
%    
%    plotty8 = scatter(currentOverview(indexC2,:),overviewPerformance_uniqueEdgeTrials(indexC2,:),50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
%    hold on 
%     
% end
% 
% xlabel('distance')
% ylabel('mean error')
% title({'Distance and performance - 1 color for each participant', ' '})
% 
% plot(xRS , yfit, 'r-', 'DisplayName','Regression');
% 
% hold off
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, '78_distance_performance_colorParticipants.png'),'Resolution',600);

%% FRS analysis
% boxplot of averaged over participants for all task houses
overviewFRSselect = [overviewFRS{:,2},overviewFRS{:,5},overviewFRS{:,8}];

figure(1)
plotty1 = boxplot(overviewFRSselect,'labels',{'egocentric/global','survey','cardinal'});
ylim([0,10]);

title({'Mean FRS values over participants', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, '81_FRS_scales_boxplot.png'),'Resolution',600)

% boxplot of ND averaged over start houses for all participants
figure(2)
plotty2 = boxplot(overviewFRSselect');
ylim([0,10]);
xlabel('participants');
ylabel('FRS values');
title({'Mean FRS values for each participant avg over all scales', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, '82_FRS_participants_boxplot.png'),'Resolution',600)

% histograms
edges=(0:1:10);
figure(3)
plotty3 = histogram(overviewFRSselect(:,1),edges);

xlabel('FRS - egocentric global scale')
ylabel('frequency')
title({'Distribution answers egocentric global scale', ' '});
ylim([0,12])

ax = gca;
exportgraphics(ax,strcat(savepath, '83_FRS_egocentricGlobal_histogram.png'),'Resolution',600)

figure(4)
plotty3 = histogram(overviewFRSselect(:,2),edges);

xlabel('FRS - survey scale')
ylabel('frequency')
title({'Distribution answers survey scale', ' '});
ylim([0,12])

ax = gca;
exportgraphics(ax,strcat(savepath, '84_FRS_survey_histogram.png'),'Resolution',600)

figure(5)
plotty5 = histogram(overviewFRSselect(:,3),edges);

xlabel('FRS - cardinal')
ylabel('frequency')
title({'Distribution answers cardinal scale', ' '});
ylim([0,12])

ax = gca;
exportgraphics(ax,strcat(savepath, '85_FRS_cardinal_histogram.png'),'Resolution',600)



figure(6)

imagescaly6 = imagesc(overviewFRSselect);
colorbar
title({'Image Scale - FRS scales','     '});
ax = gca;
% ax.XTick = 0:10:8;
ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:244;
ax.XLabel.String = 'FRS scales';
ax.YLabel.String = 'participants';

ax = gca;
exportgraphics(ax,strcat(savepath, '86_FRS_imagescale.png'),'Resolution',600)


figure(7)

plotty7 = errorbar(mean(overviewFRSselect), std(overviewFRSselect),'black','Linewidth',1);
xlabel('FRS scales')
ylabel('FRS means')
xlim([0 4])
title({'FRS means of each scale with error bars', ' '});
hold on

plotty7a = plot(mean(overviewFRSselect),'b','Linewidth',3);

hold off
ax = gca;
exportgraphics(ax,strcat(savepath, '87_FRS_scales_errorbar.png'),'Resolution',600)


figure(8)

plotty8 = errorbar(mean(overviewFRSselect,2), std(overviewFRSselect,0,2),'black','Linewidth',1);
xlabel('participants')
ylabel('FRS means')
xlim([-1 27])
title({'FRS means of each participant with error bars', ' '});
hold on

plotty8a = plot(mean(overviewFRSselect,2),'b','Linewidth',3);

set(gca,'view',[90 90])
hold off


ax = gca;
exportgraphics(ax,strcat(savepath, '88_FRS_participants_errorbar.png'),'Resolution',600)

% FRS and performance



figure(9)

for indexC2 = 1: height(overviewFRSselect)
   
   plotty9 = scatter(overviewFRSselect(indexC2,1),overviewPerformance{indexC2,2},50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
   hold on 
    
end

xlabel('egocentric global')
ylabel('mean error')
title({'FRS egocentric global and performance', ' '})
% xlim([0,10])

% Calculate regression line
p = polyfit(overviewFRSselect(:,1), overviewPerformance{:,2} , 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, overviewFRSselect(:,1) );

% Add regression line to plot
plot(overviewFRSselect(:,1), yfit, 'r-')
% legend 

hold off

ax = gca;
exportgraphics(ax,strcat(savepath, '89_FRS_egocentricGlobal_performance_colorParts.png'),'Resolution',600);


% survey
figure(10)

for indexC2 = 1: height(overviewFRSselect)
   
   plotty10 = scatter(overviewFRSselect(indexC2,2),overviewPerformance{indexC2,2},50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
   hold on 
    
end


xlabel('survey')
ylabel('mean error')
title({'FRS survey and performance', ' '})
% xlim([0,10])


% Calculate regression line
p = polyfit(overviewFRSselect(:,2), overviewPerformance{:,2} , 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, overviewFRSselect(:,2) );

% Add regression line to plot
plot(overviewFRSselect(:,2), yfit, 'r-')
% legend 

hold off

ax = gca;
exportgraphics(ax,strcat(savepath, '90_FRS_survey_performance_colorParts.png'),'Resolution',600);


% cardinal
figure(11)

for indexC2 = 1: height(overviewFRSselect)
   
   plotty11 = scatter(overviewFRSselect(indexC2,3),overviewPerformance{indexC2,2},50,colorParticipants(indexC2,:),'filled','MarkerFaceAlpha',0.5);
   hold on 
    
end


xlabel('cardinal')
ylabel('mean error')
title({'FRS cardinal and performance', ' '})
% xlim([0,10])


% Calculate regression line
p = polyfit(overviewFRSselect(:,3), overviewPerformance{:,2}  , 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, overviewFRSselect(:,3) );

% Add regression line to plot
plot(overviewFRSselect(:,3), yfit, 'r-')
% legend 

hold off

ax = gca;
exportgraphics(ax,strcat(savepath, '91_FRS_cardinal_performance_colorParts.png'),'Resolution',600);
