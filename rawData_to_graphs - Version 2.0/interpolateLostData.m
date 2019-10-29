%%---------------------------Interpolate Lost Data----------------------------
% written by Jasmin Walter

% interpolates all lost data sample clusters that are <= 7 samples big and
% are between the same house




clear all;

savepath = 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\interpolateLostData\';

cd 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\condenseViewedHouses\'


% participant list of 90 min VR - only with participants who have lost less than 30% of
% their data (after running script cleanParticipants_V2)
PartList = {1909 3668 8466 2151 4502 7670 8258 3377 9364 6387 2179 4470 6971 5507 8834 5978 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 3856 7942 6594 4510 3949 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 9961 9017 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

checkInterpolation = [];


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
        AllData = load(file);
        AllData = AllData.AllData;
        rawSave = AllData;
        
        interpolatedData = AllData;
      
        
        firstSum = sum(AllData.Samples);
        firstSumCHeck = sum(interpolatedData.Samples);
        removeRows = false(height(AllData),1);
        testi = zeros(height(AllData),1);
        problem = 0;
        rowTest = 0;
        exceptions = 0;

        % go through all rows
        for index = 1:height(AllData)

            % if the row is a noData row
            if strcmp(AllData{index,1},'noData')
  
                cNrSample = AllData{index,3};
            % number of missing samples if small enough, they get
            % interpolated
            
            
            if (cNrSample < 8)
                
                ibefore = index -1;
                iafter = index+1;
                % catch exceptions
                if index ==1
                    exceptions = exceptions +1;
                    
                elseif index == height(AllData)
                    exceptions = exceptions +1;
                    
              
                %% differentiating if seen houses before and after missing
                % samples are identical
                elseif strcmp(AllData{index-1,1},AllData{index+1,1})
                    
                    % and if the line before was not already marked for removal
                    if (removeRows(index-1) == false)
                        % combine all samples falling on the same house into
                        % one row
                        interpolatedData{index-1,3} = AllData{index-1,3}+ cNrSample + AllData{index+1,3};
                        
                    elseif (removeRows(index-1) == true)
                        % if row before was already marked for removal
                        % backtracking to find last unmarked house
                        rowTest = index-1;

                        while removeRows(rowTest)

                            
                            rowTest = rowTest -1;

                            if rowTest < 1
                                break
                            end

                        end
                        interpolatedData{rowTest,3} = interpolatedData{rowTest,3}+ cNrSample + AllData{index+1,3};

                    else
                        problem = problem +1;
                    end

                    
                    % mark the lines for removal.
                    
                    removeRows(index) = 1; 
                    removeRows(index+1) = 1;

                %% if houses are different 
                else

%                     divide the missing data onto both houses
%                     
%                     switch cNrSample
%                         case 1
%                             interpolatedData{index-1,3} = interpolatedData{index-1,3}+ cNrSample;
%                         
%                         case 2
%                             interpolatedData{index-1,3} = AllData{index-1,3}+ (cNrSample/2);
%                             interpolatedData{index+1,3} = AllData{index+1,3}+ (cNrSample/2);
%                     end
% %                     
% %                     removeRows(index,1) = 1;
                    
                end   

            end
          
            end
          
            
        end
        
        %% remove all marked rows from interpolatedData and save them into
        % interpolatedViewedHouses
        

        interpolatedData(removeRows,:) = [];
        
        save([savepath num2str(currentPart) '_interpolatedViewedHouses.mat'],'interpolatedData');
           
        % doublecheck cleaning: 
         
        secondSum = sum(interpolatedData{:,3});
        checkInterpolation = [checkInterpolation; currentPart, firstSum, secondSum ];
        
        
        
    else
        disp('something went really wrong with participant list');
    end

end

checkInterpolation = [checkInterpolation; 0, sum(checkInterpolation(:,2)), sum(checkInterpolation(:,3))];

disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');