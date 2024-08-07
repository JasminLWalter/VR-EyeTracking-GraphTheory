%% ------------------baseline_gaze_comparison_allParticipants_V3----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\baseline_gaze_comparison_allParticipants\';

% path desync data - baseline data
cd 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\baseline_gaze_comparison\';

% house list
listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};
nrHouses = height(coordinateList);
        

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};




Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedFile= 0;

% create overview
houseTable = coordinateList(:,1);
overviewComparisonAllParts = table2struct(houseTable);

    

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    file = strcat(num2str(currentPart),'_overview_comparison_baseline_gazes_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;

        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        countAnalysedFile = countAnalysedFile +1;
        % load desync data - basline
        individualOverview = load(file);
        individualOverview = individualOverview.overviewComparison;

       if(countAnalysedFile == 1)
           overviewComparisonAllParts = individualOverview;
       else
           for houseIndex = 1 : height(overviewComparisonAllParts)
               
               overviewComparisonAllParts(houseIndex).StartPoints = [[overviewComparisonAllParts(houseIndex).StartPoints], [individualOverview(houseIndex).StartPoints]];
               overviewComparisonAllParts(houseIndex).GazeLengthSamples = [[overviewComparisonAllParts(houseIndex).GazeLengthSamples], [individualOverview(houseIndex).GazeLengthSamples]];
           end
       end


        else
            disp('something went really wrong with participant list');
        end
    
end

% save overview

save([savepath 'allParticipants_overview_comparison_baseline_gazes_V3.mat'],'overviewComparisonAllParts');


disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countAnalysedFile), ' files analyzed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');


disp('done');