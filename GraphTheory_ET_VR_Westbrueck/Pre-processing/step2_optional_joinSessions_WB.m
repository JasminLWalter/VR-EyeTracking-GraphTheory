%% -------------------step2_optional_join3Sessions_WB.m------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Puprpose: optional step after step 2 in pre-processing pipeline
% (only necessary if data acquisition was completed in several sessions)
% combines condensedColliders files of different VR sessions into one file


% Usage:
% - Adjust: savepath, input folder (cd), and PartList.
% - Input files: <ParticipantID>Session<S>ET<E>_condensedColliders_WB.mat (Sessions 1..5).
% - Run the script in MATLAB.
%
% Inputs:
% - Condensed MAT files from Step 1 in the current folder (variable: condensedData).
%
% Outputs:
% - Per participant (savepath): <ID>_condensedColliders5S_WB.mat (variable: condensedColliders5S)
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;

%% --------adjust the following variables savepath, cd, listpath

savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_durationBased_2023\150_min_combined\Step2_combinedFiles\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_durationBased_2023\Step1_condensedColliders\';

% load list that contains the participant numbers belonging together sorted
% into the different sessions (this list here is uploaded with the other
% data)


%% main code
 
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;



% loop code over all participants in participant list

for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    condensedColliders5S = struct;
        
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        tic
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_condensedColliders_WB.mat']);
        
        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data
            
            dataSess = struct;
                                  
            for indexET = 1:length(dirSess)
                % read in the data
                currentET = load([num2str(currentPart) '_Session_' num2str(indexSess) '_ET_' num2str(indexET) '_condensedColliders_WB.mat']);
                currentET = currentET.condensedData;
                
                sessInfo = cell(length(currentET),1);               
                sessInfo(:) = {['Session', num2str(indexSess)]};
                [currentET.Session] = sessInfo{:};
                
                etInfo = cell(length(currentET),1);
                etInfo(:) = {['ETSession', num2str(indexET)]};
                [currentET.ETSession] = etInfo{:};
                
                currentET(end+1).hitObjectColliderName = 'newSession';
                currentET(end).sampleNr = 40;
                currentET(end).clusterDuration = 400;    
                
                if length(dataSess) ==1
                
                    dataSess = currentET;
                else

                    dataSess = [dataSess, currentET];
                end


            end

            
        end
        
        if length(condensedColliders5S) == 1
            condensedColliders5S = dataSess;

        else

            condensedColliders5S = [condensedColliders5S, dataSess];

        end
        
    end
    
    save([savepath, num2str(currentPart), '_condensedColliders5S_WB.mat'],'condensedColliders5S');
    
end


disp('done');
