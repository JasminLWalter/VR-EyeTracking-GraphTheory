%% ------------------baseline_gaze_comparison_allParticipants_visualization_V3----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\baseline_gaze_comparison_allParticipants\';

% path desync data - baseline data
cd 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\baseline_gaze_comparison_allParticipants\';

% house list
listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};
nrHouses = height(coordinateList);
        
% load overview

overviewComparisonAllParts = load('allParticipants_overview_comparison_baseline_gazes_V3.mat');

overviewComparisonAllParts = overviewComparisonAllParts.overviewComparisonAllParts;


  
figure(1)

plotty = histogram(overviewComparisonAllParts(8).StartPoints, 100);
title('House 08');
ylabel('gaze count')
hold on
plot([0,0],[0,10000], 'r');



hold off
saveas(gcf, strcat(savepath, 'baselineComparison_Gazes_House08.png'));



figure(2)

plotty2 = histogram(overviewComparisonAllParts(7).StartPoints, 100);
title('House 07');
ylabel('gaze count')
hold on
plot([0,0],[0,900], 'r');
hold off
saveas(gcf, strcat(savepath, 'baselineComparison_Gazes_House07.png'));

figure(3)

plotty3 = histogram(overviewComparisonAllParts(9).StartPoints, 100);
title('House 09');
ylabel('gaze count')
hold on
plot([0,0],[0,9000], 'r');
hold off
saveas(gcf, strcat(savepath, 'baselineComparison_Gazes_House09.png'));

%% compare landmark and other houses

RCHouseList = readtable("E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\RC_HouseList.csv");

sortedRCL = sortrows(RCHouseList,'RCCount','ascend');

housesTop10RC = sortedRCL{end-9:end,1}';

startPointsLM = [];

houseIndex10 = ismember({overviewComparisonAllParts(:).House}, housesTop10RC);

overviewLM = overviewComparisonAllParts(houseIndex10);

overviewOther = overviewComparisonAllParts(not(houseIndex10));

figure(10)

plotty10 = histogram([overviewLM(:).StartPoints],100,'Normalization','probability');
title({'all 10 gaze-graph-defined-landmarks','probability normalization'});
ylabel('probability')
hold on
plot([0,0],[0,0.05], 'r');
hold off
saveas(gcf, strcat(savepath, 'baselineComparison_gaze_graph_defined_landmarks_probabilityNormalization.png'));


figure(11)
%,'Normalization','probability'
plotty11 = histogram([overviewOther(:).StartPoints],100,'Normalization','probability');
title({'all houses that are not gaze-graph-defined-landmarks' ,'probability normalization'});
ylabel('probability')
hold on
plot([0,0],[0,0.05], 'r');

hold off
saveas(gcf, strcat(savepath, 'baselineComparison_Gazes_not_landmark_houses_probabilityNormalization.png'));

% without normalization
figure(12)

plotty12 = histogram([overviewLM(:).StartPoints],100);
title({'all 10 gaze-graph-defined-landmarks','full count'});
ylabel('gaze count')
hold on
plot([0,0],[0,90000], 'r');
hold off
saveas(gcf, strcat(savepath, 'baselineComparison_gaze_graph_defined_landmarks_fullCount.png'));


figure(13)
%,'Normalization','probability'
plotty13 = histogram([overviewOther(:).StartPoints],100);
title({'all houses that are not gaze-graph-defined-landmarks','full count'});
ylabel('gaze count')
hold on
plot([0,0],[0,600000], 'r');

hold off
saveas(gcf, strcat(savepath, 'baselineComparison_Gazes_not_landmark_houses_fullCount.png'));

figure(14)
plotty10_14 = histogram([overviewLM(:).StartPoints],100,'Normalization','probability','FaceAlpha', 0.3);
hold on
plotty11_14 = histogram([overviewOther(:).StartPoints],100,'Normalization','probability','FaceAlpha', 0.3);
legend('gg-landmarks','no-lm-houses');
title({'comparision gg-landmarks vs no-landmark-houses' ,'probability normalization'});
ylabel('probability')
hold off
saveas(gcf, strcat(savepath, 'baselineComparison_comparing_gglandmarks_vs_noLMhouses.png'));

figure(15)
testi = histogram([overviewLM(:).StartPoints],100,'Normalization','pdf');

disp('done');