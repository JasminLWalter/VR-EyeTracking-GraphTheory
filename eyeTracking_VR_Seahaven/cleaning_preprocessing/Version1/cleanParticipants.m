%%------------------------------clean_Participants----------
% written by Jasmin Walter

% creates a new list of participants, 
% lists only participants in new list who had only less than 30% of their
% eye tracking data removed during cleaning

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\';

cd 'D:\BA Backup\Data_after_Script\CondenseViewedHouses\'

PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};


% load overview fixated_vs_noise
overviewAnalysis = load('overviewAnalysis.mat');
overviewAnalysis = overviewAnalysis.overviewAnalysis;

% create table with all participants that have less than 30% data discarted
lessThan30 = overviewAnalysis{:,4} < 30;
lessThan30Table = overviewAnalysis(lessThan30,:);

% save list of participants, that have less than 30% data discarted
newParticipantList = lessThan30Table{:,1}';
Number= length(newParticipantList);
save(savepath,'newParticipantList');

% analyse data of new participant list
summaryNewData = array2table(zeros(1,3),'VariableNames',{'Min','Max','Average'});
summaryNewData.Min(1) = min(lessThan30Table{:,4});
summaryNewData.Max(1) = max(lessThan30Table{:,4});
summaryNewData.Average(1) = mean(lessThan30Table{:,4});

save(strcat(savepath, 'NewDataOverview'), 'summaryNewData');

discarted= overviewAnalysis{:,4} >= 30;
discartedDataOverview= overviewAnalysis(discarted,:);
save(strcat(savepath, 'discartedDataOverview'), 'discartedDataOverview');
testMean = mean(discartedDataOverview.percentage);
        

disp('done');

