%% ------------------ comparison_durationsBetweenGazes_plotting_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

cd 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\durationsBetweenGazes\overviews\'


savepath =  'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\durationsBetweenGazes\';



% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);

overview_oldDataTimeStamps = [];
overview_newDataTimeStamps = [];


for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));
    
    % load old data
    newDurations = load(strcat(num2str(currentPart), '_newData_durationsBetweenGazes.mat'));
    newDurations = newDurations.overview_newDataTimeStamps;


    oldDurations = load(strcat(num2str(currentPart), '_oldData_durationsBetweenGazes.mat'));
    oldDurations = oldDurations.overview_oldDataTimeStamps;

    overview_oldDataTimeStamps = [overview_oldDataTimeStamps, oldDurations];
    overview_newDataTimeStamps = [overview_newDataTimeStamps, newDurations];

    

end

disp("plotting")



% Create a figure window
figure(1);

% Plot the first boxplot in the first subplot
subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
boxplot(overview_oldDataTimeStamps);
title('Old data');
ylim([0,7])
ylabel('seconds')

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
boxplot(overview_newDataTimeStamps);
title('new Data');
ylim([0,7])
ylabel('seconds')

saveas(gcf, strcat(savepath, 'boxplot_timeBetweenGazes.png'))



% Create a figure window
figure(2);

% Plot the first boxplot in the first subplot
subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
boxplot(overview_oldDataTimeStamps);
title('Old data');
ylim([0,1.2])
ylabel('seconds')

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
boxplot(overview_newDataTimeStamps);
title('new Data');
ylim([0,1.2])
ylabel('seconds')


saveas(gcf, strcat(savepath, 'boxplot_limited_timeBetweenGazes.png'))


figure(3)

% Plot the first boxplot in the first subplot
subplot(1, 2, 1);  % 1 row, 2 columns, 1st position
histogram(overview_oldDataTimeStamps, normalization = "probability");
title('Old data');
xlim([0,1.2])
ylim([0,0.2])
xline(mean(overview_oldDataTimeStamps),'red');
xlabel('seconds')
ylabel('probability')

% Plot the second boxplot in the second subplot
subplot(1, 2, 2);  % 1 row, 2 columns, 2nd position
histogram(overview_newDataTimeStamps, BinWidth=1/90, normalization = "probability");
title('new Data');
xlim([0,1.2])
ylim([0,0.2])
xline(mean(overview_newDataTimeStamps),'red');
xlabel('seconds')
ylabel('probability')


saveas(gcf, strcat(savepath, 'histogram_timeBetweenGazes.png'))




disp(['old data mean ', num2str(mean(overview_oldDataTimeStamps))])
disp(['old data std ', num2str(std(overview_oldDataTimeStamps))])
disp(['old data median ', num2str(median(overview_oldDataTimeStamps))])


disp(['new data mean ', num2str(mean(overview_newDataTimeStamps))])
disp(['new data std ', num2str(std(overview_newDataTimeStamps))])
disp(['new data median ', num2str(median(overview_newDataTimeStamps))])