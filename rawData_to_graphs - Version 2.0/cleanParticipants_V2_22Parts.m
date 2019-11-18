%%------------------------------clean_Participants----------
% written by Jasmin Walter

% creates a new list of participants, 
% lists only participants in new list who had only less than 30% of their
% eye tracking data removed during cleaning

clear all;

savepath = 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\';

cd 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\combined3Sessions\'


% Participant list of all participants that participated at least 3
% sessions in the Seahaven - 90min
%PartList = {1909 3668 8466 3430 6348 2151 4502 7670 8258 3377 1529 9364 6387 2179 4470 6971 5507 8834 5978 1002 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 2011 2098 3856 7942 6594 4510 3949 9748 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 5239 8936 9961 9017 1089 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593 9848};

% partlist of combined 3 sessions for 22 participants in VR
PartList = [21 22 23 24 25 26 27 28 30 31 32 33 34 35 36 37 38 41 43 44 45 46];

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedPart= 0;
overviewAnalysis = array2table(zeros(Number,4));
overviewAnalysis.Properties.VariableNames = {'Participant','noData_Rows','total_Rows','percentage'};

for ii = 1:Number
    currentPart = PartList(ii);
    
    file = strcat('condensedViewedHouses3_Part',num2str(currentPart),'.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        countAnalysedPart = countAnalysedPart +1;

        % load data
        viewedHouses3 = load(file);
        viewedHouses3 = viewedHouses3.viewedHouses3;
        
        noData = strcmp(viewedHouses3.House,'noData');
        
        noDataTable = viewedHouses3(noData,:);
        otherDataTable = viewedHouses3(not(noData),:);
        
        noDataRows = sum(noDataTable.Samples) - 20;
        otherDataRows = sum(otherDataTable.Samples);
        
        allRows = sum(viewedHouses3.Samples) - 20;
        testSum = noDataRows + otherDataRows;
        
        % update overview
            
        overviewAnalysis.Participant(ii)= currentPart;
        overviewAnalysis.noData_Rows(ii)= noDataRows;
        overviewAnalysis.total_Rows(ii)= allRows;
            
        percent = (noDataRows*100)/allRows;
            
        overviewAnalysis.percentage(ii) = percent;
        
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countAnalysedPart), ' Participants analyzed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

save(strcat(savepath,'overviewNoData_22Parts'),'overviewAnalysis');

disp('saved Overview Gazes');



% create table with all participants that have less than 30% data discarted
lessThan30 = overviewAnalysis{:,4} < 30;
lessThan30Table = overviewAnalysis(lessThan30,:);

% save list of participants, that have less than 30% data discarted
newParticipantList = lessThan30Table{:,1}';
Number= length(newParticipantList);
save(strcat(savepath, 'newParticipantList'),'newParticipantList');

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

