%% ------------------ gazeData_comparison_plotting_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

cd 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\overviews\'


savepath =  'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\plots\';



% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);

gazeOverview = table;

eventCounter = []
isNoisy = [];
hasGaze = [];
gazeDuration = [];
gazeDurationPer = [];


tic
for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));
    
    % load old data
    gazeData = load(strcat(num2str(currentPart), '_gazeData_comparison.mat'));
    gazeData = gazeData.oldData;

    if(ii ==1)
        allGazeData = gazeData;

    else

        allGazeData = [allGazeData, gazeData];

    end


 

end
toc
disp("plotting")


allGazeData = struct2table(allGazeData);

figure(1)

% Plot the first boxplot in the first subplot
subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.eventBoundaryDifference_start), BinWidth=1/90, Normalization="probability")
title('start event boundary difference');
ylabel('probability')
xlim([-0.5,0])

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.eventBoundaryDifference_end), BinWidth=1/90, Normalization="probability")
title('end event boundary difference');
ylabel('probability')
xlim([-0.5,0])


saveas(gcf, strcat(savepath, 'eventBoundaryDifferences.png'))


isGaze = allGazeData.isGaze;


figure(2)

% Plot the first boxplot in the first subplot
subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.eventBoundaryDifference_start(isGaze)), BinWidth=1/90, Normalization="probability")
title('start event boundary difference');
ylabel('probability')
xlim([-0.5,0])

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.eventBoundaryDifference_end(isGaze)), BinWidth=1/90, Normalization="probability")
title('end event boundary difference');
ylabel('probability')
xlim([-0.5,0])

sgtitle(" event boundary differences - old gazes only")


saveas(gcf, strcat(savepath, 'eventBoundaryDifferences_Gazes.png'))


clusterNH = strcmp(allGazeData.hitObjectColliderName, 'NH');

figure(3)
% Plot the first boxplot in the first subplot
subplot(1, 3, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.eventCounter(isGaze)), 'Normalization','probability')
title('event counter - gazes');
ylabel('probability')
xlim([0,50])

% Plot the second boxplot in the second subplot
subplot(1, 3, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.eventCounter(isGaze & ~clusterNH)), 'Normalization','probability')
title('event counter - building gazes');
ylabel('probability')
xlim([0,50])

% Plot the second boxplot in the second subplot
subplot(1, 3, 3);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.eventCounter(~isGaze)), 'Normalization','probability')
title('event counter - not gazes');
ylabel('probability')

sgtitle("how many events in one old cluster")

saveas(gcf, strcat(savepath, 'eventCounter.png'))



figure(4) % gaze counter

subplot(1, 3, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.gazeCounter(isGaze)), 'Normalization','probability')
title('gaze counter - gazes');
ylabel('probability')
xlim([0,20])

subplot(1, 3, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.gazeCounter(isGaze & ~clusterNH)), 'Normalization','probability')
title('gaze counter - building gazes');
ylabel('probability')
xlim([0,20])

subplot(1, 3, 3);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.gazeCounter(~isGaze)), 'Normalization','probability')
title('gaze counter - not gazes');
ylabel('probability')

sgtitle("how many gazes in one old cluster")

saveas(gcf, strcat(savepath, 'gazeCounter.png'))


hasGaze_gaze = cell2mat(allGazeData.gazeCounter(isGaze)) > 0;
hasGaze_nogaze = cell2mat(allGazeData.gazeCounter(~isGaze)) > 0;


figure(5) % gaze durations

gazeDurations_gaze = cell2mat(allGazeData.gazeDurations(isGaze));
gazeDurations_per = cell2mat(allGazeData.gazeDurations_per(isGaze));

gazeDurations_ngaze  = cell2mat(allGazeData.gazeDurations(~isGaze));
gazeDurations_nper = cell2mat(allGazeData.gazeDurations_per(~isGaze));

subplot(1, 4, 1);  % 1 row, 2 columns, 1st position
histogram(gazeDurations_gaze(hasGaze_gaze))
title('gaze durations (if new cluster has also gaze) - old cluster gazes');
xlabel("seconds")
xlim([0,5])
title('duration(s), gaze');

subplot(1, 4, 2);  % 1 row, 2 columns, 2nd position
histogram(gazeDurations_per(hasGaze_gaze))
title('percentage, gaze');
xlabel("cluster duration percentage")
xlim([0,0.0012])



subplot(1, 4, 3);  % 1 row, 2 columns, 1st position
histogram(gazeDurations_ngaze(hasGaze_nogaze), BinWidth=1/90)
xlabel("seconds")
title('duration(s), gaze');
xlim([0,1])


subplot(1, 4, 4);  % 1 row, 2 columns, 2nd position
histogram(gazeDurations_nper(hasGaze_nogaze))
xlabel("cluster duration percentage")
title('percentage, gaze');
xlim([0,0.0012])


sgtitle("If there is a gaze in the new data, how much percentage of the cluster duration ?")

saveas(gcf, strcat(savepath, 'gazeDurations.png'))



figure(6) % number of unique gaze buildings

subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.numUniqueGazeBuildings(isGaze)))
title('cluster is gaze');
ylabel('count')

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.numUniqueGazeBuildings(~isGaze)))
title('cluster is not gaze');
ylabel('count')

sgtitle(" number of different buildings as gaze locations")


saveas(gcf, strcat(savepath, 'nr_different_gaze_buildings.png'))


figure(7)

subplot(1, 5, 1);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.num_sameGazeHitPoint(isGaze)))
title('num same gaze hit points');
ylabel('count')
xlim([0,20])

% Plot the second boxplot in the second subplot
subplot(1, 5, 2);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.num_sameGazeHitPoint_per(isGaze)))
title('percentage');
ylabel('count')
xlim([0,1])

subplot(1, 5, 3);  % 1 row, 2 columns, 1st position
histogram(cell2mat(allGazeData.sameGazeHitPoint_Duration_old(isGaze)))
title('duration');
ylabel('count')
xlim([0,10])

% Plot the second boxplot in the second subplot
subplot(1, 5, 4);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.sameGazeHitPoint_Duration_per(isGaze)))
title('duration per');
ylabel('count')


% Plot the second boxplot in the second subplot
subplot(1, 5, 5);  % 1 row, 2 columns, 2nd position
histogram(cell2mat(allGazeData.sameGazeHitPoint_Duration_per_old(isGaze)))
title('duration per old');
ylabel('count')




sgtitle("same gaze location old cluster and new data")


saveas(gcf, strcat(savepath, 'same_gaze_loc_analysis.png'))

