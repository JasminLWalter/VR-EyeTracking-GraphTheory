%% -------------------step2_optional_join3Sessions_WB.m------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% optional step after step 2 in pre-processing pipeline
% (only necessary if data acquisition was completed in several sessions)
% combines condensedColliders files of different VR sessions into one file


% Input: 
% combinedSessions_newPartNumbers.csv = list matching the different
%                                       numbers of each session to the 
%                                       respective participant (uploaded in
%                                       https://osf.io/aurjk/)
% condensedColliders_V3.mat = files created when running script
%                             step1_condenseRawData_V3.m
% uses
% Output: 
% condensedColliders3S.mat     = files combining the three sessions for
%                                each participant

clear all;

%% --------adjust the following variables savepath, cd, listpath

savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\condensedColls_combinedSess\';

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\condensedColliders\';

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



% for part = 1: height(combinedSessions)
% 
% 
%     data1 = load(strcat(num2str(combinedSessions.Session1(part)),'_condensedColliders_V3.mat'));
%     data1 = data1.condensedData;
%     
%     data2 = load(strcat(num2str(combinedSessions.Session2(part)),'_condensedColliders_V3.mat'));
%     data2 = data2.condensedData;
%     
%     data3 = load(strcat(num2str(combinedSessions.Session3(part)),'_condensedColliders_V3.mat'));
%     data3 = data3.condensedData;
%     
%     % add variable session to each data
%     % for data1
%     s1 = cell(length(data1),1);
%     s1(:) = {'Session1'};
%     [data1.Session] = s1{:};
%     order = [21,1:20];
%     data1 = orderfields(data1,order);
%     
%     % for data2
%     s2 = cell(length(data2),1);
%     s2(:) = {'Session2'};
%     [data2.Session] = s2{:};
%     data2 = orderfields(data2,order);
%             
%     % for data3
%     s3 = cell(length(data3),1);
%     s3(:) = {'Session3'};
%     [data3.Session] = s3{:};
%     data3 = orderfields(data3,order);
%     
%     
%     % add a row to seperate sessions, in case they need to be identified
%     % again at a later point
%     data1(end+1).Collider = 'newSession';  
%     
%     data1(end).Session= NaN; 
%     data1(end).TimeStamp= NaN; 
%     data1(end).Samples= NaN; 
%     data1(end).Distance= NaN; 
%     data1(end).hitPointX= NaN; 
%     data1(end).hitPointY= NaN; 
%     data1(end).hitPointZ= NaN; 
%     data1(end).PosX= NaN; 
%     data1(end).PosY= NaN; 
%     data1(end).PosZ= NaN; 
%     data1(end).PosRX= NaN; 
%     data1(end).PosRY= NaN; 
%     data1(end).PosRZ= NaN; 
%     data1(end).PosTimeStamp=NaN; 
%     data1(end).PupilLTimeStamp= NaN; 
%     data1(end).VectorX= NaN; 
%     data1(end).VectorY= NaN; 
%     data1(end).VectorZ= NaN; 
%     data1(end).eye2Dx= NaN; 
%     data1(end).eye2Dy= NaN; 
% 
%     % same with data2
%     
%     data2(end+1).Collider = 'newSession';
%     
%     data2(end).Session= NaN; 
%     data2(end).TimeStamp= NaN; 
%     data2(end).Samples= NaN; 
%     data2(end).Distance= NaN; 
%     data2(end).hitPointX= NaN; 
%     data2(end).hitPointY= NaN; 
%     data2(end).hitPointZ= NaN; 
%     data2(end).PosX= NaN; 
%     data2(end).PosY= NaN; 
%     data2(end).PosZ= NaN; 
%     data2(end).PosRX= NaN; 
%     data2(end).PosRY= NaN; 
%     data2(end).PosRZ= NaN; 
%     data2(end).PosTimeStamp=NaN; 
%     data2(end).PupilLTimeStamp= NaN; 
%     data2(end).VectorX= NaN; 
%     data2(end).VectorY= NaN; 
%     data2(end).VectorZ= NaN; 
%     data2(end).eye2Dx= NaN; 
%     data2(end).eye2Dy= NaN;
% 
%     % combine all the session
%     condensedColliders3S = [data1, data2, data3];
%     newName = strcat(num2str(combinedSessions.newPartNumber(part)),'condensedColliders_3Sessions_V3');
%     save(strcat(savepath,newName),'condensedColliders3S');
% 
% end


disp('done');
