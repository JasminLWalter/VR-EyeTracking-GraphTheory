%---------------------------Interpolate Lost Data-----------------------------
clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\interpolatedData\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\condenseViewedHouses\'

% participant list including all participants
%PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

% participant list only with participants who have lost less than 30% of
% their data
PartList = {1809};%,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

checkCleaning = [];


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_condensedViewedHouses.mat');
 
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
        rawSave = AllSeen;
        
        cleanAllSeen = AllSeen;
      
        
        firstSum = sum(AllSeen.Looks);
        firstSumCHeck = sum(cleanAllSeen.Looks);
        removeRows = false(height(AllSeen),1);
        testi = zeros(height(AllSeen),1);
        
        % go through all rows
        for index = 1:height(AllSeen)
            
            % if the row is a noData row
            if strcmp(AllSeen{index,1},'noData')
                testi(index,1) = AllSeen{index-1,3};
                
                cNrSample = AllSeen{index,3};
            % number of missing samples if small enough, they get
            % interpolated
            if (cNrSample < 3)
                ibefore = index -1;
                iafter = index+1;
               
                % differentiating if seen houses before and after missing
                % samples are identical
                if strcmp(AllSeen{index-1,1},AllSeen{index+1,1})
                    
                    % and if the line before was not already marked for removal
                    if (removeRows(index-1) == false)
                        % combine all samples falling on the same house into
                        % one row
                        cleanAllSeen{index-1,3} = AllSeen{index-1,3}+ cNrSample + AllSeen{index+1,3};
                    else
                        % if row before was already marked for removal
                        % backtracking to find last unmarked house
                        rowTest = index;
                        while (removeRows(rowTest) == false)
                            disp('while loop'+rowTest);
                            rowTest = rowTest -1;
                            
                            if rowTest > 1
                                break
                            end
                            
                            cleanAllSeen{rowTest,3} = AllSeen{rowTest,3}+ cNrSample + AllSeen{index+1,3};
                            end
                        
                        
                    end
                    
                    
                    % mark the lines for removal.
                    
                    removeRows(index) = 1;
                    removeRows(index+1) = 1;
                else
                    % divide the missing data onto both houses
%                     switch cNrSample
%                         case 1
%                             cleanAllSeen{index-1,3} = cleanAllSeen{index-1,3}+ cNrSample;
%                         
%                         case 2
%                             cleanAllSeen{index-1,3} = AllSeen{index-1,3}+ (cNrSample/2);
%                             cleanAllSeen{index+1,3} = AllSeen{index+1,3}+ (cNrSample/2);
%                     end
%                     
%                     removeRows(index,1) = 1;
                    
                end   
                
            end
            end    
            
        end
        
        % remove all marked rows from All Seen and save them into
        % cleanAllSeen
        
        
        
        cleanAllSeen(removeRows,:) = [];
        
        save([savepath num2str(currentPart) '_cleanViewedHouses.mat'],'cleanAllSeen');
        
        % doublecheck cleaning:
        
        secondSum = sum(cleanAllSeen{:,3});
        checkCleaning = [checkCleaning; currentPart, firstSum, secondSum ];
        
        
        
    else
        disp('something went really wrong with participant list');
    end

end

checkCleaning = [checkCleaning; 0, sum(checkCleaning(:,2)), sum(checkCleaning(:,3))];

disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');