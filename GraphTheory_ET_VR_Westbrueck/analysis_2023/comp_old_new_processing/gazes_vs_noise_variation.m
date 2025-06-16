%% -----------------------step4_gazes_vs_noise_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

%

clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\gaze_noise_prep\';

cd 'E:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\interpolatedColliders\';

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedPart= 0;

overviewGazes = array2table(zeros(Number,4));
overviewGazes.Properties.VariableNames = {'Participant','totalAmount','gazes','noise'};


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        tic
        countAnalysedPart = countAnalysedPart +1;
        % load data
        interpolatedData = load(file);
        interpolatedData = interpolatedData.interpolatedData;
        
        % threshold based classification of gazes
        % a gaze is a cluster of min duration of 266.6 ms
        

         % Compute the logical values for isGaze
        gazes = num2cell([interpolatedData.clusterDuration] > 266.6);
        
        % Assign values directly to the structure array
        [interpolatedData.isGaze] = gazes{:};
                     
        
        
        % save both tables
        save([savepath num2str(currentPart) '_data_gazeInfo_WB.mat'],'interpolatedData');
        
        % update overview with values

        
     
  
        toc
        
    else
        disp('something went really wrong with participant list');
    end

end


disp('done');