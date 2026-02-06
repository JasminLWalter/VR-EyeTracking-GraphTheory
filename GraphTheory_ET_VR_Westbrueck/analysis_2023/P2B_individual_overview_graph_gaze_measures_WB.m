%% ------------------ P2B_individual_overview_graph_gaze_measures_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\gaze_measure_plots\';

cd 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\data_overviews\';


clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];




%% load overview of the mean performance of each participant
overviewGraphMeasures = readtable('overviewGraphMeasures.csv');
overviewGazeMeasures = readtable('overviewGazeMeasures.csv');

% overviewGazeMeasures.perDiffObGazes = overviewGazeMeasures.nrDiffObjects ./ overviewGazeMeasures.nrGazes;
% overviewGazeMeasures.perDiffBuildingGazes = overviewGazeMeasures.nrDiffBuildings ./ overviewGazeMeasures.nrGazes;


overviewGraphGazeMeasures = [overviewGraphMeasures, overviewGazeMeasures(:, 2:end)];





%% save overviews
writetable(overviewGraphGazeMeasures, 'overviewGraphGazeMeasures.csv');

%%

numericData = overviewGraphGazeMeasures{:, 2:end};

% Compute the correlation matrix
correlationMatrix = corr(numericData);



% Create a heatmap of the correlation matrix
figure(1)

heatmap(overviewGraphGazeMeasures.Properties.VariableNames(2:end), overviewGraphGazeMeasures.Properties.VariableNames(2:end), correlationMatrix, ...
       'Colormap',parula,'ColorbarVisible', 'on', 'Interpreter','none');
title('Correlation Matrix Heatmap');
xlabel('Measures');
ylabel('Measures');


correlationMatrix2 = correlationMatrix;
correlationMatrix2(correlationMatrix > 0.5 ) = NaN;
correlationMatrix2(correlationMatrix < -0.5 ) = NaN;

% Create a heatmap of the correlation matrix
figure(2)

heatmap(overviewGraphGazeMeasures.Properties.VariableNames(2:end), overviewGraphGazeMeasures.Properties.VariableNames(2:end), correlationMatrix2, ...
       'Colormap',parula,'ColorbarVisible', 'on', 'Interpreter','none');
title('Correlation Matrix Heatmap');
xlabel('Measures');
ylabel('Measures');

R2Matrix = correlationMatrix .^ 2;

% Create a heatmap of the correlation matrix
figure(3)

heatmap(overviewGraphGazeMeasures.Properties.VariableNames(2:end), overviewGraphGazeMeasures.Properties.VariableNames(2:end), R2Matrix, ...
       'Colormap',parula,'ColorbarVisible', 'on', 'Interpreter','none');
title('Correlation Matrix Heatmap');
xlabel('Measures');
ylabel('Measures');


%% make plots of gaze variables

for index= 2: width(overviewGazeMeasures)
    figure(index+2)

    label = overviewGazeMeasures.Properties.VariableNames(index);

    x= overviewGazeMeasures{:,index};
    y = overviewGraphMeasures.meanPerformance;
    plotty4 = scatter(x,y,'filled');
    xlabel(label,  'Interpreter','none')
    ylabel('mean error')
    title(strcat(label, '& performance'),  'Interpreter','none')
    % xlim([6,10]);

    % Calculate regression line
    p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
    yfit = polyval(p, x);

    % Add regression line to plot
    hold on
    plot(x, yfit, 'r-')
    % legend('Data', 'Regression Line')
    hold off

    ax = gca;
    saveas(ax,strcat(savepath, 'scatter_performance_', string(label), '.png'))




end


disp('done')