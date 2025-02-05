%% ------------------ FRS_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\FRS\';

cd 'F:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];


%% load data

frsData = readtable('Overview_FRS_Data.csv');

figure(1)

% plotty1 = boxchart(frsData.Participant, frsData.Mean_egocentric_global,'Notch','on');
plotty1 = bar(frsData.Mean_egocentric_global);


title('Boxplot FRS egocentric global');
xlabel('Trial sequence at same start building / location');
ylabel('pointing error')

% hold on
% plot(groupStats14.mean_RecalculatedAngle, '-o')  % x-axis is the intergers of position
% hold off
%legend(["performance data","performance mean"])
 

% saveas(gcf, strcat(savepath, 'Boxplot pointing errors sorted into trial sequence at the same start location_fig10.png'));


disp("FRS stats - ego global")
disp(min(frsData.Mean_egocentric_global))

disp(max(frsData.Mean_egocentric_global))

disp("FRS stats - survey")
disp(min(frsData.Mean_survey))

disp(max(frsData.Mean_survey))


disp("FRS stats - cardinal")
disp(min(frsData.Mean_cardinal))

disp(max(frsData.Mean_cardinal))