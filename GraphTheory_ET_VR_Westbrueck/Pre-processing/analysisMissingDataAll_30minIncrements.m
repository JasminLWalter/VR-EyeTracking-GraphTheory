%% analyze missing data - use full 30 min session to calculate percentage
% Description: 

% creates an overview of the amount of missing data in all files based on
% the gaze validity bitmasks
%% adjust the following variables: savepath, current folder and participant list!-----------
savepathNewData = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\rawData_with_renamedColliders\';
savepathCondensedData = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\condensedColliders\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;

overviewMissingDataAll = table;
overviewMissingData_Participants = table;

% loop code over all participants in participant list

for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    part_totalRows = 0;
    part_missing31 = 0;
    part_missing3 = 0;
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        tic
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Expl_S_' num2str(indexSess) '*_flattened.csv']);
        
        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data
            sessionRows = 0;
            missingData31Sum = 0;
            missingData3Sum = 0;
            
            
            for indexET = 1:length(dirSess)
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                data = readtable(dirSess(indexET).name);
                
                sessionRows = sessionRows + height(data);
        
                
                
                %% identify the bad data samples with not enough eye tracking validity
                
                notBothEyes31 = not(data.leftGazeValidityBitmask == 31 & data.rightGazeValidityBitmask == 31);

                missingData31Sum = missingData31Sum +sum(notBothEyes31);
                
                notBothEyes3 = not(data.combinedGazeValidityBitmask == 3);
                
                missingData3Sum = missingData3Sum + sum(notBothEyes3);
        
                
                
               
          
                
            end
                        
            % update data overviewMissing data:
                              
%             helperOA = table;
% 
%             helperOA.Participant = currentPart;
%             helperOA.Session = indexSess;
%             helperOA.totalRows = sessionRows;
% 
%             helperOA.noDataRows_bothEyes31 = missingData31Sum;
%             helperOA.percentage_NotBothEyes31 = missingData31Sum / sessionRows;
% 
%             helperOA.noDataRows_combinedEyes3 = missingData3Sum;
%             helperOA.percentage_notCombinedEyes3 = missingData3Sum / sessionRows;
% 
%             overviewMissingDataAll = [overviewMissingDataAll; helperOA];
            
            % update participant overview
            
           part_totalRows = part_totalRows + sessionRows;
           part_missing31 = part_missing31 + missingData31Sum;
           part_missing3 = part_missing3 + missingData3Sum;

            
            
            toc 
            
        end
    
        
    end
    
    helper2 = table;
    helper2.Participant = currentPart;
    helper2.totalRows = part_totalRows;
    helper2.noDataRows_bothEyes31 = part_missing31;
    helper2.percentage_notBothEyes31 = part_missing31 / part_totalRows;
    helper2.noDataRows_combinedEyes3 = part_missing3;
    helper2.percentage_notCombined3 = part_missing3 / part_totalRows;

    overviewMissingData_Participants = [overviewMissingData_Participants; helper2];
    
    

    
  

end            
            
% save overviews


% save missing data overview in both folders
% writetable(overviewMissingDataAll, ['overviewMissingDataAll_30min.csv']);
writetable(overviewMissingData_Participants, ['overviewMissingDataAll_Participants.csv']);

disp('saved overviews');

% save missing data info
if height(missingFiles) > 0
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------');
    
    disp(strcat(height(missingFiles),' files were missing'));

    writetable(missingFiles, [savepathNewData 'missingFiles.csv']);
    writetable(missingFiles, [savepathCondensedData 'missingFiles.csv']);
    disp('saved missing file list');
    
else
    
    disp('all files were found');
    
end


disp('done');





