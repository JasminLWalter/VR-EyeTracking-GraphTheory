%---------------------------Interpolate Lost Data-----------------------------
clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\AnalysisAllViews\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data\ViewedHouses\'

% participant list including all participants
%PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

% participant list only with participants who have lost less than 30% of
% their data
PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('ViewedHouses_VP',num2str(currentPart),'.txt');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        % load data
        AllSeen = load(file);
        AllSeen = AllSeen.AllSeen;
        
        for index = 1:height(AllSeen)
           
            % interpolate if small enough
            if (AllSeen{index,3} < 3)
               
                if
                    
                else
                end
                
                
            end
            
            
        end

        
        
        
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');