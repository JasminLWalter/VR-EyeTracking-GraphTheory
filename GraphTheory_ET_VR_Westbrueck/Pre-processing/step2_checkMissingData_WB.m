%% ---------------------step2_checkMissingData_WB.m----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% step 2 in pre-processing pipeline
% Script investigates the percentage of missing data in each file and prints
% some stat summary and suggestions. 


% Input: 

%% adjust the following variables: current folder and participant list!-----------

clear all;


% cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_durationBased_2023\Step1_condensedColliders\';
cd 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\condensedColliders\'


%-------------------------------------------------------------------------------------------------

% load overview fixated_vs_noise
overviewMissingData = readtable('overviewMissingData.csv', 'Delimiter', ',');

sortedOverview = sortrows(overviewMissingData, 4, "descend");

more30missing = sortedOverview.percentageMissing >= 0.3;
sumMore30Missing = sum(more30missing);

disp(strcat("The number of files containing more than 30% missing data is: ", num2str(sumMore30Missing)))

more20missing = sortedOverview.percentageMissing >= 0.2;
sumMore20Missing = sum(more20missing);
disp(strcat("The number of files containing more than 20% missing data is: ", num2str(sumMore20Missing)))

if ((sumMore30Missing == 0) & (sumMore20Missing ==0))
    maxMissing = max(sortedOverview.percentageMissing); 
    meanMissing = mean(sortedOverview.percentageMissing); 
    disp("All files are missing less than 20% of the data")
    disp(strcat("The data file with worst data quality is missing ", num2str(maxMissing * 100) , "% data"))
    disp(strcat("On average, the data files contain ", num2str(meanMissing * 100) , "% of missing data (including blinks etc.)"))
    disp("no further action necessary")

else

    disp("The data quality is not ideal, further discussions on how to handle the data files with larger percentages of missing data are necessary")

end


disp('done');

