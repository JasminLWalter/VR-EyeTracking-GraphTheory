% analysis of check validity 2

clear all;
disp('start script-----------------------------------------------');

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis_controls\checked_raw_files\';


cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% 26 participants control group - recorded in 5 sessions for 30 min each
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
%PartList = {1004 1005 1008};

Number = length(PartList);

% overviewValidityInfo = load('overviewValidityInfo.mat');
% 
% overviewValidityInfo = overviewValidityInfo.overviewValidityInfo;
% 
% 
% bitmasksSingle = [];
% bitmasksCombined = [];
% 
% for index = 1:height(overviewValidityInfo)
%     
%     cBMcombinedBM = overviewValidityInfo{index, 3}{1};
%     cBMleftBM = overviewValidityInfo{index, 4}{1};
%     cBMrightBM = overviewValidityInfo{index, 5}{1};
%     
%     bitmasksCombined = [bitmasksCombined; cBMcombinedBM];
%     bitmasksSingle = [bitmasksSingle; cBMleftBM; cBMrightBM];
% end
% 
% uniqueCombined = unique(bitmasksCombined);
% uniqueSingle = unique(bitmasksSingle);
% 

%%

allBitMaskData_3 = [];
allBitMaskData_0 = [];

allEyeOpennessBM8_3 = [];
allEyeOpennessBM24_3 = [];
allEyeOpennessBM25_3 = [];
allEyeOpennessBM31_3 = [];

allEyeOpennessBM8_0 = [];
allEyeOpennessBM24_0 = [];
allEyeOpennessBM25_0 = [];
allEyeOpennessBM31_0 = [];

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
            
                       
          
            % calculate the occurences of combined 3 or 0
            combined3 = currentData.combinedGazeValidityBitmask == 3;
            combined0 = currentData.combinedGazeValidityBitmask == 0;
            
            % calculate the occurences of right or left eye being 31
            rightEye31 = currentData.rightGazeValidityBitmask == 31;
            leftEye31 = currentData.leftGazeValidityBitmask == 31;
            
            
          
            onlyOneEye31andCombined3 = ((rightEye31 & combined3)| (leftEye31 & combined3)) & not(rightEye31 & leftEye31);
            onlyInterestingRight = onlyOneEye31andCombined3 & not(rightEye31);
            onlyInterestingLeft = onlyOneEye31andCombined3 & not(leftEye31);
            
            allBitMaskData_3 = [allBitMaskData_3; currentData{onlyInterestingRight,9};currentData{onlyInterestingLeft,8}];
            allBitMaskData_0 = [allBitMaskData_0; currentData{combined0,9};currentData{combined0,8}];
            % now eye openness
                        
            left8 = currentData.leftGazeValidityBitmask == 8;
            left24 = currentData.leftGazeValidityBitmask == 24;
            left25 = currentData.leftGazeValidityBitmask == 25;
            
            right8 = currentData.rightGazeValidityBitmask == 8;
            right24 = currentData.rightGazeValidityBitmask == 24;
            right25 = currentData.rightGazeValidityBitmask == 25;
            
            allEyeOpennessBM8_3 = [allEyeOpennessBM8_3;currentData{(left8&combined3) ,4}; currentData{(right8&combined3) ,5}];
            allEyeOpennessBM24_3 = [allEyeOpennessBM24_3;currentData{(left24&combined3),4};currentData{(right24&combined3),5}];
            allEyeOpennessBM25_3 = [allEyeOpennessBM25_3;currentData{(left25&combined3),4};currentData{(right25&combined3),5}];
            allEyeOpennessBM31_3 = [allEyeOpennessBM31_3;currentData{(leftEye31&combined3),4};currentData{(combined3&rightEye31),5}];
            
            allEyeOpennessBM8_0 = [allEyeOpennessBM8_0;currentData{(left8&combined0) ,4}; currentData{(right8&combined0) ,5}];
            allEyeOpennessBM24_0 = [allEyeOpennessBM24_0;currentData{(left24&combined0),4};currentData{(right24&combined0),5}];
            allEyeOpennessBM25_0 = [allEyeOpennessBM25_0;currentData{(left25&combined0),4};currentData{(right25&combined0),5}];
            allEyeOpennessBM31_0 = [allEyeOpennessBM31_0;currentData{(leftEye31&combined0),4};currentData{(combined0&rightEye31),5}];
            
            
            
                        
            
                      
        end
        
        
          
        
    end
    
    
%     writeTable(overvieTimeStamps, [savepath num2str(currentPart) '_' num2str(indexSess) '_' num2str(indexET) '_overviewTimeStamps.csv']);
%     
    
toc    

end

save([savepath 'workspace_analisisBitmasksEyeOpenness2']);

