%% --------------------- step2_resampling_plots.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses 1004_Expl_S_1_ET_1_flattened.csv file
% Output: 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
% datapaths Westbrook harddrive
% savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processing_2023\';
% 
% cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% datapaths Living Transformation harddrive
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\step2_resampling\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\step1_dupl_clean_smooth\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;




data = readtable('1004_Session_2_ET_3_data_dupl_clean_smooth.csv');


samplingRate = diff(data.timeStampDataPointStart_converted);
samplingRate = 1 ./ samplingRate;
samplingRate = [NaN; samplingRate];


% Define the window
len = height(data);
window = len-10:len;
% window = 1250:1300;
% window = 1:50;


[hitP_x_resamp, TyHPX] = resample(data.processedCollider_NH_hitPointOnObject_x,data.timeStampDataPointStart_converted, 90);
[hitP_y_resamp, TyHPY] = resample(data.processedCollider_NH_hitPointOnObject_y,data.timeStampDataPointStart_converted, 90);
[hitP_z_resamp, TyHPZ] = resample(data.processedCollider_NH_hitPointOnObject_z,data.timeStampDataPointStart_converted, 90);
% windowRS = TyHPX<= data.timeStampDataPointStart_converted(max(window)) & TyHPX>= data.timeStampDataPointStart_converted(min(window)) ;
windowRS =  TyHPX>= data.timeStampDataPointStart_converted(min(window)) ;


% Create a figure with 3 subplots
% figure('Position', [100, 100, 1500, 1000]);
figure(1)

% First subplot
subplot(5, 1, 1);
plot(TyHPX(windowRS), [90;1./diff(TyHPX(windowRS))],'-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), samplingRate(window), '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');

yline(90, '--r', 'DisplayName', 'Intended Sampling Rate');
plot(TyHPX(windowRS), [90;1./diff(TyHPX(windowRS))],'-', 'Color','black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Sampling Rate');

hold off;
xlabel('Time (seconds)');
% ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
legend('Location','northeastoutside');
grid on;

% Second subplot
subplot(5, 1, 2);
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', 'w', 'marker','.','MarkerSize',15,'DisplayName', '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');
                                                                                                                                                                                    
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');


hold off;
xlabel('Time (seconds)');
% ylabel('hit point coordinates');
title('hit point coordinates over Time');
legend('Location','northeastoutside');
grid on;



subplot(5, 1, 3);
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', 'w', 'marker','.','MarkerSize',15,'DisplayName', '--------------------------------------');
hold on;

plot(TyHPX(windowRS), hitP_x_resamp(windowRS),  '-', 'Color','red','marker','.','MarkerSize',15, 'DisplayName', 'resampled X Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(TyHPY(windowRS), hitP_y_resamp(windowRS),  '-', 'Color','black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');

plot(TyHPZ(windowRS), hitP_z_resamp(windowRS),  '-', 'Color','blue','marker','.','MarkerSize',15, 'DisplayName', 'resampled Z Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');

hold off;
xlabel('Time (seconds)');
% ylabel('hit point coordinates');
title('resampled hit point coordinates over Time');
legend('Location','northeastoutside');
grid on;



subplot(5, 1, 4);
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName',  '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');
hold off;
xlabel('Time (seconds)');
% ylabel('eye position coordinates');
title('eye position coordinates over Time');
legend('Location','northeastoutside');
grid on;

[eyePCW_x_resamp, TyEPX] = resample(data.eyePositionCombinedWorld_x,data.timeStampDataPointStart_converted, 90);
[eyePCW_y_resamp, TyEPY] = resample(data.eyePositionCombinedWorld_y,data.timeStampDataPointStart_converted, 90);
[eyePCW_z_resamp, TyEPZ] = resample(data.eyePositionCombinedWorld_z,data.timeStampDataPointStart_converted, 90);



% Second subplot
subplot(5, 1, 5);
plot(TyEPX(windowRS), eyePCW_x_resamp(windowRS),  '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName','--------------------------------------');
hold on;

plot(TyEPX(windowRS), eyePCW_x_resamp(windowRS),  '-', 'Color','red','marker','.','MarkerSize',15, 'DisplayName', 'resampled X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(TyEPY(windowRS), eyePCW_y_resamp(windowRS), '-', 'Color', 'black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');

plot(TyEPZ(windowRS), eyePCW_z_resamp(windowRS), '-', 'Color', 'blue', 'marker','.','MarkerSize',15,'DisplayName', 'resampled Z Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');

hold off;
xlabel('Time (seconds)');
% ylabel('eye position coordinates');
title('resampled eye position coordinates over Time');
legend('Location','northeastoutside');
grid on;





% MATLAB code to replicate the functionality

% Example data frame
timestampSeconds = [0, 2.5, 3, 10, 11, 12, 15, 18.5, 19.5, 22, 25, 27, 32, 32.5, 32.8, 40, 41, 44, 45, 47];
value1 = [10, 12, 15, 16, 14, 16, 16, 15, 14, 13, 15, 15, 13.5, 13, 15, 13, 12, 13, 15, 15];
value2 = [20, 18, 17, 14, 15, 15, 15.5, 16, 16, 18, 19, 20, 21, 20, 19.5, 18, 19, 19, 16, 16];

dataSim = table;
dataSim.timestampSeconds  = timestampSeconds';
dataSim.value1 = value1';
dataSim.value2 = value2';

% Compute sampling rate
samplingRate2 = 1 ./ diff(timestampSeconds);
samplingRate2 = [NaN, samplingRate2]; % to match the size of timestampSeconds

% Plotting the data
figure(2);
subplot(2, 1, 1); % First subplot

% Plot Sampling Rate
plot(timestampSeconds, samplingRate2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');
xlabel('Time (seconds)');
ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
legend;
grid on;

subplot(2, 1, 2); % Second subplot

% Plot Values
plot(timestampSeconds, value1,  '-', 'Color',[1 0.5 0],'marker','.','MarkerSize',15,'DisplayName', 'Value1');
hold on;
plot(timestampSeconds, value2,  '-', 'Color',[0.2 0.7 0],'marker','.','MarkerSize',15, 'DisplayName', 'Value2');
xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
legend;
grid on;

hold off

[value1_resampled, Ty1] = resample(dataSim.value1,dataSim.timestampSeconds, 1.3);
[timestamp_resampled, Ty2] = resample(dataSim.timestampSeconds,dataSim.timestampSeconds, 1.3);
[value2_resampled, Ty3] = resample(dataSim.value2,dataSim.timestampSeconds, 1.3);

resampledSamplingRate = diff(timestamp_resampled);
resampledSamplingRate = [NaN; 1 ./resampledSamplingRate];

vector = (1:(1/1.3):100);

% plot resampled data

figure(3);
subplot(3, 1, 1); % First subplot
plot(timestampSeconds, samplingRate2, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on
% Plot Sampling Rate
plot(timestampSeconds, samplingRate2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');

plot(timestamp_resampled, resampledSamplingRate, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Sampling Rate');
xlabel('Time (seconds)');
ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
legend('Location','northeastoutside');
grid on;
hold off


subplot(3, 1, 2); % Second subplot

% Plot Values
plot(Ty1, value1_resampled, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on;
plot(Ty1, value1_resampled, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Value1');

plot(timestampSeconds, value1,  '-', 'Color',[1 0.8 0],'marker','.','MarkerSize',15,'DisplayName', 'Value1');

plot(timestampSeconds, value2,  '-', 'Color',[0.2 0.7 0],'marker','.','MarkerSize',15, 'DisplayName', 'Value2');



xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
legend('Location','northeastoutside');
grid on;

hold off



subplot(3, 1, 3); % Second subplot

plot((1:65), Ty1, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on

plot((1:65), Ty1, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Ty1');

plot((1:65), Ty2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Ty2');

plot((1:65), timestamp_resampled, '-', 'Color','g','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');

plot((1:65),  vector(1:65), '-', 'Color','k','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');
xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
grid on;
legend('Location','northeastoutside');

hold off



figure(4);
subplot(3, 1, 1); % First subplot
maxTS = max(timestampSeconds);
selection1 = timestamp_resampled <= maxTS;


% Plot Sampling Rate
plot(timestampSeconds, samplingRate2, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on
plot(timestampSeconds, samplingRate2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');

plot(timestamp_resampled(selection1), resampledSamplingRate(selection1), '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Sampling Rate');
plot(Ty1, 1/Ty1, '-', 'Color','black','marker','.','MarkerSize',15, 'DisplayName', 'T1 sampling rate');
xlabel('Time (seconds)');
ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
legend('Location','northeastoutside');
grid on;
hold off


subplot(3, 1, 2); % Second subplot
selection2 = (Ty1 <= maxTS);
% Plot Values
plot(Ty1(selection2), value1_resampled(selection2), '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on;

plot(Ty1(selection2), value1_resampled(selection2), '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Value1');
plot(timestampSeconds, value1,  '-', 'Color',[1 0.8 0],'marker','.','MarkerSize',15,'DisplayName', 'Value1');


plot(Ty3(selection2), value2_resampled(selection2), '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Value1');

plot(timestampSeconds, value2,  '-', 'Color',[0.2 0.7 0],'marker','.','MarkerSize',15, 'DisplayName', 'Value2');



xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
legend('Location','northeastoutside');
grid on;

hold off


subplot(3, 1, 3); % Second subplot

plot((1:sum(selection2)), Ty1(selection2), '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on
plot((1:sum(selection2)), Ty1(selection2), '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Ty1');

selection3 = Ty2 <= maxTS;
plot((1:sum(selection3)), Ty2(selection3), '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Ty2');

selection4 = timestamp_resampled <= maxTS;
plot((1:sum(selection4)), timestamp_resampled(selection4), '-', 'Color','g','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');

plot((1:65),   vector(1:65), '-', 'Color','k','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');
xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
grid on;
legend('Location','northeastoutside');


hold off
%% do it again, but with the interpolation using splines

[value1_resampleds, Ty1s] = resample(dataSim.value1,dataSim.timestampSeconds, 1.3,'spline');
[timestamp_resampleds, Ty2s] = resample(dataSim.timestampSeconds,dataSim.timestampSeconds, 1.3,'spline');

resampledSamplingRates = diff(timestamp_resampleds);
resampledSamplingRates = [NaN; 1 ./resampledSamplingRates];


% plot resampled data

figure(5);
subplot(3, 1, 1); % First subplot

% Plot Sampling Rate
plot(timestampSeconds, samplingRate2, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName',  '--------------------------------------');
hold on
plot(timestampSeconds, samplingRate2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');
plot(timestamp_resampleds, resampledSamplingRates, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Sampling Rate');
xlabel('Time (seconds)');
ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
% legend('Location','northeastoutside');
grid on;
hold off


subplot(3, 1, 2); % Second subplot

% Plot Values
plot(Ty1s, value1_resampleds, '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName',  '--------------------------------------');
hold on;
plot(Ty1s, value1_resampleds, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Value1');

plot(timestampSeconds, value1,  '-', 'Color',[1 0.8 0],'marker','.','MarkerSize',15,'DisplayName', 'Value1');

plot(timestampSeconds, value2,  '-', 'Color',[0.2 0.7 0],'marker','.','MarkerSize',15, 'DisplayName', 'Value2');



xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
% legend;
grid on;

hold off


subplot(3, 1, 3); % Second subplot

plot((1:65),  vector(1:65), '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on
plot((1:65),  vector(1:65), '-', 'Color','k','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');



plot((1:65), Ty1, '-', 'Color','r','marker','.','MarkerSize',15, 'DisplayName', 'Ty1');

plot((1:65), Ty2, '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Ty2');

plot((1:65), timestamp_resampleds, '-', 'Color','g','marker','.','MarkerSize',15, 'DisplayName', 'Resampled Timestamp');

xlabel('Time (seconds)');
ylabel('Values');
title('Values over Time');
grid on;

hold off
%% cut off end

maxTS = max(timestampSeconds);
selection1 = timestamp_resampled <= maxTS;


%% do some padding to avoid edge effects
% add some padding by extending the data points at the start and end
paddingSize = 10;

helperStart = nan(paddingSize ,3);
helperStart(:,1) = data.processedCollider_NH_hitPointOnObject_x(1);
helperStart(:,2) = data.processedCollider_NH_hitPointOnObject_y(1);
helperStart(:,3) = data.processedCollider_NH_hitPointOnObject_z(1);



helperEnd = nan(paddingSize ,3);
helperEnd(:,1) = data.processedCollider_NH_hitPointOnObject_x(end);
helperEnd(:,2) = data.processedCollider_NH_hitPointOnObject_y(end);
helperEnd(:,3) = data.processedCollider_NH_hitPointOnObject_z(end);

sR = 1/90;

startTS = data.timeStampDataPointStart_converted(1);
endTS = data.timeStampDataPointStart_converted(end);
helperTSStart= nan(paddingSize,1);
helperTSEnd = nan(paddingSize,1);
for i = 1:paddingSize
    helperTSStart(i,1) = startTS - (i*sR);
    helperTSEnd(i,1) =  endTS + (i*sR);

end

timeStamp = [helperTSStart(:,1); data.timeStampDataPointStart_converted; helperTSEnd(:,1)];




[hitP_x_resamp, TyHPX] = resample([helperStart(:,1);data.processedCollider_NH_hitPointOnObject_x; helperEnd(:,1)],timeStamp, 90);
[hitP_y_resamp, TyHPY] = resample([helperStart(:,2);data.processedCollider_NH_hitPointOnObject_y; helperEnd(:,2)],timeStamp, 90);
[hitP_z_resamp, TyHPZ] = resample([helperStart(:,3);data.processedCollider_NH_hitPointOnObject_z; helperEnd(:,3)],timeStamp, 90);
% windowRS = TyHPX<= data.timeStampDataPointStart_converted(max(window)) & TyHPX>= data.timeStampDataPointStart_converted(min(window)) ;
windowRS =  TyHPX>= data.timeStampDataPointStart_converted(min(window)) ;
% windowRS = TyHPX<= data.timeStampDataPointStart_converted(max(window));

helperStart2 = nan(paddingSize ,3);
helperStart2(:,1) = data.eyePositionCombinedWorld_x(1);
helperStart2(:,2) = data.eyePositionCombinedWorld_y(1);
helperStart2(:,3) = data.eyePositionCombinedWorld_z(1);

helperEnd2 = nan(paddingSize ,3);
helperEnd2(:,1) = data.eyePositionCombinedWorld_x(end);
helperEnd2(:,2) = data.eyePositionCombinedWorld_y(end);
helperEnd2(:,3) = data.eyePositionCombinedWorld_z(end);


[eyePCW_x_resamp, TyEPX] = resample([helperStart2(:,1);data.eyePositionCombinedWorld_x; helperEnd2(:,1)],timeStamp, 90);
[eyePCW_y_resamp, TyEPY] = resample([helperStart2(:,2);data.eyePositionCombinedWorld_y; helperEnd2(:,2)],timeStamp, 90);
[eyePCW_z_resamp, TyEPZ] = resample([helperStart2(:,3);data.eyePositionCombinedWorld_z; helperEnd2(:,3)],timeStamp, 90);





% Create a figure with 3 subplots
% figure('Position', [100, 100, 1500, 1000]);
figure(6)

% First subplot
subplot(5, 1, 1);
plot(TyHPX(windowRS), [90;1./diff(TyHPX(windowRS))],'-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName', '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), samplingRate(window), '-', 'Color','b','marker','.','MarkerSize',15, 'DisplayName', 'Sampling Rate');

yline(90, '--r', 'DisplayName', 'Intended Sampling Rate');
plot(TyHPX(windowRS), [90;1./diff(TyHPX(windowRS))],'-', 'Color','black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Sampling Rate');

hold off;
xlabel('Time (seconds)');
% ylabel('Sampling Rate (Hz)');
title('Sampling Rate Over Time');
legend('Location','northeastoutside');
grid on;

% Second subplot
subplot(5, 1, 2);
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', 'w', 'marker','.','MarkerSize',15,'DisplayName', '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');
                                                                                                                                                                                    
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');


hold off;
xlabel('Time (seconds)');
% ylabel('hit point coordinates');
title('hit point coordinates over Time');
legend('Location','northeastoutside');
grid on;



subplot(5, 1, 3);
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', 'w', 'marker','.','MarkerSize',15,'DisplayName', '--------------------------------------');
hold on;

plot(TyHPX(windowRS), hitP_x_resamp(windowRS),  '-', 'Color','red','marker','.','MarkerSize',15, 'DisplayName', 'resampled X Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(TyHPY(windowRS), hitP_y_resamp(windowRS),  '-', 'Color','black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');

plot(TyHPZ(windowRS), hitP_z_resamp(windowRS),  '-', 'Color','blue','marker','.','MarkerSize',15, 'DisplayName', 'resampled Z Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.processedCollider_NH_hitPointOnObject_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');

hold off;
xlabel('Time (seconds)');
% ylabel('hit point coordinates');
title('resampled hit point coordinates over Time');
legend('Location','northeastoutside');
grid on;



subplot(5, 1, 4);
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName',  '--------------------------------------');
hold on;
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');
hold off;
xlabel('Time (seconds)');
% ylabel('eye position coordinates');
title('eye position coordinates over Time');
legend('Location','northeastoutside');
grid on;

% Second subplot
subplot(5, 1, 5);
plot(TyEPX(windowRS), eyePCW_x_resamp(windowRS),  '-', 'Color','w','marker','.','MarkerSize',15, 'DisplayName','--------------------------------------');
hold on;

plot(TyEPX(windowRS), eyePCW_x_resamp(windowRS),  '-', 'Color','red','marker','.','MarkerSize',15, 'DisplayName', 'resampled X Coordinate');

plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_x(window),  '-', 'Color',[0.9 0.9 0],'marker','.','MarkerSize',15, 'DisplayName', 'X Coordinate');

plot(TyEPY(windowRS), eyePCW_y_resamp(windowRS), '-', 'Color', 'black','marker','.','MarkerSize',15, 'DisplayName', 'resampled Y Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_y(window), '-', 'Color', [1 0.5 0],'marker','.','MarkerSize',15, 'DisplayName', 'Y Coordinate');

plot(TyEPZ(windowRS), eyePCW_z_resamp(windowRS), '-', 'Color', 'blue', 'marker','.','MarkerSize',15,'DisplayName', 'resampled Z Coordinate');
plot(data.timeStampDataPointStart_converted(window), data.eyePositionCombinedWorld_z(window), '-', 'Color', [0 0.9 0.1], 'marker','.','MarkerSize',15,'DisplayName', 'Z Coordinate');

hold off;
xlabel('Time (seconds)');
% ylabel('eye position coordinates');
title('resampled eye position coordinates over Time');
legend('Location','northeastoutside');
grid on;



















