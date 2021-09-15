%% -----------------analyseMissingData_beforeInterpolation----------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------




clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\missingData\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\combined3sessions\'


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

sameDiffInfo = {};
sampleInfo = [];


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'condensedColliders_3Sessions_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        % load data
        condensedColliders = load(file);
        condensedColliders = condensedColliders.condensedColliders3S;
        for index = 1:length(condensedColliders)
            if strcmp(condensedColliders(index).Collider,'noData')
                if (index == 1 || index == length(condensedColliders))
                    sampleInfo = [sampleInfo; condensedColliders(index).Samples];
                    sameDiffInfo = [sameDiffInfo; 'startend'];
                    
                else
                    sampleInfo = [sampleInfo; condensedColliders(index).Samples];
                    
                    col1 = condensedColliders(index-1).Collider;
                    col2 = condensedColliders(index+1).Collider;
                    if(strcmp(col1,col2))
                        sameDiffInfo= [sameDiffInfo; 'same'];
                    else
                        sameDiffInfo = [sameDiffInfo; 'diff'];
                    end
                    
                end
                
              
                
                
            end
            
        end
        
        
        
    else
        disp('something went really wrong with participant list');
    end

end

missingDataOverview = table;
missingDataOverview.Samples = sampleInfo;
missingDataOverview.SameDiff = sameDiffInfo;

save(strcat(savepath, 'missingDataOverview_beforeInterpolation'), 'missingDataOverview');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');