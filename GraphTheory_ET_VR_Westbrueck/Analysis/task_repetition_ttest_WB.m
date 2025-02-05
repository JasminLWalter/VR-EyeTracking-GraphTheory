%% ------------------ task_repetition_ttest_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables:  

savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\P2B_controls_analysis\RepetitionAnalysis\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

%% load data

dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');

% Reshape the data to wide format
data_wide = unstack(dataP2B, 'RecalculatedAngle', 'TrialOrder', 'AggregationFunction', @mean);

% Calculate differences
data_wide.Difference = data_wide.Trial2 - data_wide.Trial1;

% Perform paired t-tests for each participant
subjectIDs = unique(data_wide.SubjectID);
numSubjects = length(subjectIDs);
t_statistics = zeros(numSubjects, 1);
p_values = zeros(numSubjects, 1);
conf_low = zeros(numSubjects, 1);
conf_high = zeros(numSubjects, 1);

for i = 1:numSubjects
    subj_data = data_wide(data_wide.SubjectID == subjectIDs(i), :);
    [h, p, ci, stats] = ttest(subj_data.Trial1, subj_data.Trial2);
    t_statistics(i) = stats.tstat;
    p_values(i) = p;
    conf_low(i) = ci(1);
    conf_high(i) = ci(2);
end

% Combine results into a table
t_test_summary = table(subjectIDs, t_statistics, p_values, conf_low, conf_high, ...
    'VariableNames', {'SubjectID', 'tStatistic', 'pValue', 'ConfLow', 'ConfHigh'});

% Add a new variable for significance
Significance = repmat("Not Significant", numSubjects, 1);
Significance(p_values <= 0.05) = "Significant";
t_test_summary.Significance = Significance;






