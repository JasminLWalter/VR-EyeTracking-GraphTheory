%% analyze missing data!
% Description: 

% creates an overview of the amount of missing data in all files based on
% the gaze validity bitmasks
%% adjust the following variables: savepath, current folder and participant list!-----------
savepathNewData = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\rawData_with_renamedColliders\';
savepathCondensedData = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\condensedColliders\';

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;

overviewMissingDataAll = table;

% loop code over all participants in participant list

for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    
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
            for indexET = 1:length(dirSess)
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                data = readtable(dirSess(indexET).name);
                
                totalRows = height(data);
        
                
                
                %% identify the bad data samples with not enough eye tracking validity
                
                notBothEyes31 = not(data.leftGazeValidityBitmask == 31 & data.rightGazeValidityBitmask == 31);

                missingData31Sum = sum(notBothEyes31);
                
                notBothEyes3 = not(data.combinedGazeValidityBitmask == 3);
                
                missingData3Sum = sum(notBothEyes3);
        
                
                
                % update data overviewMissing data:
                              
                helperOA = table;
                
                helperOA.File = dirSess(indexET).name;
                helperOA.totalRows = totalRows;

                helperOA.noDataRows_bothEyes31 = missingData31Sum;
                helperOA.percentage_NotBothEyes31 = missingData31Sum / totalRows;
                
                helperOA.noDataRows_bothEyes3 = missingData3Sum;
                helperOA.percentage_NotBothEyes3 = missingData3Sum / totalRows;
                
                overviewMissingDataAll = [overviewMissingDataAll; helperOA];
                
          
                
            end
            toc 
            
        end
        
          
        
    end
    
    

    
  

end            
            
% save overviews


% save missing data overview in both folders
writetable(overviewMissingDataAll, [savepathNewData 'overviewMissingDataAll.csv']);
writetable(overviewMissingDataAll, [savepathCondensedData 'overviewMissingDataAll.csv']);

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





