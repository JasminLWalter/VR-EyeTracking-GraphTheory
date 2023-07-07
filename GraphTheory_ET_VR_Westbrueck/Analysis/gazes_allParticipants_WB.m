%% ------------------ gazes_allParticipants_WB.m---------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% Script combines all gazes data from all participants into one file.
% Script also combines all interpolated data files from all participants
% into one file. 

% Input:
% gazes_data_V3.mat = gaze data files
% interpolatedColliders_3Sessions_V3.mat = interpolated data files

% Output:
% gazes_allParticipants = combined gaze files from all participants
% interpolData_allParticipants = combined interpolated data files from all participants            

% Missing_Participant_Files.mat    = contains all participant numbers where the
%                                    data file could not be loaded
%                                   NOTE: only checks the gazes files


clear all;

%% adjust the following variables: 
% savepath, gazePath, interpolPath, and PartList---------------------------

savepath= 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\allParticipants\';

gazePath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\gazes_vs_noise\';

interpolPath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\interpolatedColliders\';

% 26 participants with 150 min VR trainging in Westbrook (control group)
partList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

%---------------------------------------------------------------------------

Number = length(partList);
noFilePartList = [];
countMissingPart = 0;

% 
% for ii = 1:Number
% 
%     currentPart = partList(ii);
%     disp(currentPart)    
%     
%     file = strcat(gazePath, num2str(currentPart),'_gazes_data_WB.mat');
%  
%     % check for missing files
%     if exist(file)==0
%         countMissingPart = countMissingPart+1;
%         
%         noFilePartList = [noFilePartList;currentPart];
%         disp(strcat(file,' does not exist in folder'));
%     %% main code   
%     elseif exist(file)==2
%       
%         %% gazes
%         % load gaze data
%         gazesData = load(file);
%         gazesData = gazesData.gazes_data;
%         % create table with necessary fields
%         fields = fieldnames(gazesData);
%         impFields = ismember(fields,{'hitObjectColliderName',...
%             'playerBodyPosition_x', 'playerBodyPosition_y',...
%             'playerBodyPosition_z'});
%         
%         rmFields = fields(not(impFields));
%         gazedData_r = rmfield(gazesData,rmFields);
%         
%         if (ii ==1)
%         
%             gazes_allParticipants = gazedData_r;
%         else
%             
%             gazes_allParticipants = [gazes_allParticipants, gazedData_r];
%         end
%         
% %        clear gazedObjects
% 
%                
%     else
%         disp('something went really wrong with participant list');
%     end
% 
% end
% 
% 
% save(strcat(savepath,'gazes_allParticipants'),'gazes_allParticipants');
% 
% clear gazes_allParticipants
% 
% disp('gazes all participants saved----------------------------------------')

%% do the same for the interpolated data as well (separated loops to not run out of memory)


for ii = 1:Number

    currentPart = partList(ii);
    disp(currentPart)    

   %% interpolated data

   % load interpolated data
    file2 = strcat(interpolPath,num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
    interpolatedData = load(file2);
    interpolatedData = interpolatedData.interpolatedData;

    % create table with necessary fields

    fields = fieldnames(interpolatedData);
    impFields = ismember(fields,{'hitObjectColliderName',...
        'playerBodyPosition_x', 'playerBodyPosition_y',...
        'playerBodyPosition_z'});

    rmFields = fields(not(impFields));
    interpolatedData_r = rmfield(interpolatedData,rmFields);

    if (ii ==1)

        interpolData_allParticipants = interpolatedData;
    else

        interpolData_allParticipants = [interpolData_allParticipants, interpolatedData];
    end


end

save(strcat(savepath,'interpolData_allParticipants'),'interpolData_allParticipants');    

disp('done');