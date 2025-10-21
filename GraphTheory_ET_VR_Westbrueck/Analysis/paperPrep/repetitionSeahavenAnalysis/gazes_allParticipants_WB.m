%% ------------------ gazes_allParticipants_WB.m---------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Combines per-participant gaze data into a single file. Optionally (code provided but
%          commented out) combines interpolated data across participants as well.
%
% Usage:
% - Adjust: savepath, gazePath, interpolPath, and partList.
% - Run the script in MATLAB. Uncomment the second loop to also aggregate interpolated data.
%
% Inputs:
% - Per participant gazes: <ID>_gazes_data_WB.mat (variable: gazes_data)
% - Optional, per participant interpolated data: <ID>_interpolatedColliders_5Sessions_WB.mat (variable: interpolatedData)
%
% Outputs (to savepath):
% - gazes_allParticipants.mat (struct array with fields: hitObjectColliderName, hmdPosition_x/y/z)
% - Optional (if uncommented): interpolData_allParticipants.mat
% - Notes: Missing files are reported in the console; no separate list is saved.
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)


clear all;

%% adjust the following variables: 
% savepath, gazePath, interpolPath, and PartList---------------------------


savepath= 'E:\WestbrookProject\Spa_Re\control_group\Analysis\allParticipants\';

gazePath = 'E:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\gazes_vs_noise\';

interpolPath = 'E:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\interpolatedColliders\';

% 26 participants with 150 min VR trainging in Westbrook (control group)
partList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

%---------------------------------------------------------------------------

Number = length(partList);
noFilePartList = [];
countMissingPart = 0;


for ii = 1:Number

    currentPart = partList(ii);
    disp(currentPart)    

    file = strcat(gazePath, num2str(currentPart),'_gazes_data_WB.mat');

    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;

        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        %% gazes
        % load gaze data
        gazesData = load(file);
        gazesData = gazesData.gazes_data;
        % create table with necessary fields
        fields = fieldnames(gazesData);
        impFields = ismember(fields,{'hitObjectColliderName',...
            'hmdPosition_x', 'hmdPosition_y',...
            'hmdPosition_z'});

        rmFields = fields(not(impFields));
        gazedData_r = rmfield(gazesData,rmFields);

        if (ii ==1)

            gazes_allParticipants = gazedData_r;
        else

            gazes_allParticipants = [gazes_allParticipants, gazedData_r];
        end

%        clear gazedObjects


    else
        disp('something went really wrong with participant list');
    end

end


save(strcat(savepath,'gazes_allParticipants'),'gazes_allParticipants');

clear gazes_allParticipants

disp('gazes all participants saved----------------------------------------')

%% do the same for the interpolated data as well (separated loops to not run out of memory)

% 
% for ii = 1:Number
% 
%     currentPart = partList(ii);
%     disp(currentPart)    
% 
%    %% interpolated data
% 
%    % load interpolated data
%     file2 = strcat(interpolPath,num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
%     interpolatedData = load(file2);
%     interpolatedData = interpolatedData.interpolatedData;
% 
%     % create table with necessary fields
% 
%     fields = fieldnames(interpolatedData);
%     impFields = ismember(fields,{'hitObjectColliderName',...
%         'hmdPosition_x', 'hmdPosition_y',...
%         'hmdPosition_z'});
% 
%     rmFields = fields(not(impFields));
%     interpolatedData_r = rmfield(interpolatedData,rmFields);
% 
%     if (ii ==1)
% 
%         interpolData_allParticipants = interpolatedData;
%     else
% 
%         interpolData_allParticipants = [interpolData_allParticipants, interpolatedData];
%     end
% 
% 
% end
% 
% save(strcat(savepath,'interpolData_allParticipants'),'interpolData_allParticipants');    
% 
% disp('done');