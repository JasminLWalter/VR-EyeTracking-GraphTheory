%% ------------------ checkValidityData----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input:  
% 

% Output:
% 

clear all;
disp('start script-----------------------------------------------');

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis_controls\checked_raw_files\';


cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% 26 participants control group - recorded in 5 sessions for 30 min each
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
%PartList = {1004 1005 1008};
%-------------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


%% check raw csv data files for doublicated rows and summarize central information in overview
allFiles = dir('*flattened.csv');

% overviewSessionInfo = table('Size', [length(PartList)*5, 3],'VarTypes',{'double','double','double'},'VariableNames',{'Participant','RecordingSession','ETSessions'});
overviewValidityInfo = table;
%overviewDataCheckInfo = table('Size', [length(allFiles), 3],'VarTypes',{'double','double','double'},'VariableNames',{'Participant','RecordingSession','ETSession','TotalDataRows','TotalDoublicates','PercentDoublicates','TotalMissingData','PercentMissingData'});

% loop over all known information to check for missing data files
% loop over participants
for indexPart = 1:Number
    tic
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Expl_S_' num2str(indexSess) '*_flattened.csv']);
                
        
        % loop over ET sessions and check data
        for indexET = 1: length(dirSess)
            %tic
            currentData = readtable(dirSess(indexET).name);
            
            
            helperT = table;
            helperT.File = dirSess(indexET).name;
            helperT.TotalLength = height(currentData);
            
            % add the unique occurences of validity bitmasks
            helperT.uniqueCombinedValidityBitMasks = {unique(currentData.combinedGazeValidityBitmask)};
            helperT.uniqueLeftValidityBitMasks = {unique(currentData.leftGazeValidityBitmask)};
            helperT.uniqueRightValidityBitMasks = {unique(currentData.rightGazeValidityBitmask)};
            
            % calculate the occurences of combined 3 or 0
            combined3 = currentData.combinedGazeValidityBitmask == 3;
            combined0 = currentData.combinedGazeValidityBitmask == 0;
            combinedNot3or0 = not(combined3 | combined0);
            
            % calculate the occurences of right or left eye being 31
            rightEye31 = currentData.rightGazeValidityBitmask == 31;
            leftEye31 = currentData.leftGazeValidityBitmask == 31;
            
            
            % sum how often one thing occurs
            helperT.SumCombined3 = sum(combined3);
            helperT.SumCombined3_P = helperT.SumCombined3/helperT.TotalLength;
            
            helperT.SumCombined0 = sum(combined0);
            helperT.SumCombined0_P = helperT.SumCombined0/helperT.TotalLength;
            
            helperT.SumCombinedNot3or0 = sum(combinedNot3or0);
            helperT.SumCombinedNot3or0_P = helperT.SumCombinedNot3or0/helperT.TotalLength;
            
            helperT.SumRightEye31 = sum(rightEye31);
            helperT.SumRightEye31_P = helperT.SumRightEye31/helperT.TotalLength;
            
            helperT.SumRightEyeNot31 = sum(not(rightEye31));
            helperT.SumRightEyeNot31_P = helperT.SumRightEyeNot31/helperT.TotalLength;
            
            helperT.SumLeftEye31 = sum(leftEye31);
            helperT.SumLeftEye31_P = helperT.SumLeftEye31/helperT.TotalLength;
            
            helperT.SumLeftEyeNot31 = sum(not(leftEye31));
            helperT.SumLeftEyeNot31_P = helperT.SumLeftEyeNot31/helperT.TotalLength;
            
           
            % check the different combinations of occurences
            helperT.BothEyes31andCombined3 = sum(rightEye31 & leftEye31 & combined3);
            helperT.BothEyes31andCombined3_P = helperT.BothEyes31andCombined3/helperT.TotalLength;
            
            helperT.onlyOneEye31andCombined3 = sum(((rightEye31 & combined3)| (leftEye31 & combined3)) & not(rightEye31 & leftEye31) );
            helperT.onlyOneEye31andCombined3_P = helperT.onlyOneEye31andCombined3/helperT.TotalLength;
            
            helperT.NoEye31andCombined3 = sum(not(rightEye31 | leftEye31) & combined3);
            helperT.NoEye31andCombined3_P = helperT.NoEye31andCombined3/helperT.TotalLength;
            
            helperT.BothEyes31andCombined0 = sum(rightEye31 & leftEye31 & combined0);
            helperT.BothEyes31andCombined0_P = helperT.BothEyes31andCombined0/helperT.TotalLength;
            
            helperT.onlyOneEye31andCombined0 = sum(((rightEye31 & combined0)| (leftEye31 & combined0)) & not(rightEye31 & leftEye31) );
            helperT.onlyOneEye31andCombined0_P = helperT.onlyOneEye31andCombined0/helperT.TotalLength;
            
            helperT.NoEye31andCombined0 = sum(not(rightEye31 | leftEye31) & combined0);
            helperT.NoEye31andCombined0_P = helperT.NoEye31andCombined0/helperT.TotalLength;
            
            
            overviewValidityInfo = [overviewValidityInfo; helperT];
                       

                      
        end
        
        
          
        
    end
    
    
%     writeTable(overvieTimeStamps, [savepath num2str(currentPart) '_' num2str(indexSess) '_' num2str(indexET) '_overviewTimeStamps.csv']);
%     
    
toc    

end

save(strcat(savepath,'overviewValidityInfo.mat'),'overviewValidityInfo');

disp(strcat(num2str(Number), ' Participants analysed'));

disp('done');