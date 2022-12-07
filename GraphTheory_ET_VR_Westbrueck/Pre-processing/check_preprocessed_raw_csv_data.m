%% ------------------ check_preprocessed_raw_csv_data----------------------

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
%PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
PartList = {1004 1005 1008};
%-------------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%% summarize the info summary data into one table

% infoSummary = table;
% 
% dirInfo = dir('*infoSummary.csv');
% 
% for infoIndex = 1: length(dirInfo)
%     
%     currentInfo = readtable(dirInfo(infoIndex).name);
%     infoSummary = [infoSummary; currentInfo];
%     
%     
%     
% end
% 
% writetable(infoSummary, [savepath 'data_info_overview.csv'])
% 

%% check raw csv data files for doublicated rows and summarize central information in overview
allFiles = dir('*flattened.csv');

% overviewSessionInfo = table('Size', [length(PartList)*5, 3],'VarTypes',{'double','double','double'},'VariableNames',{'Participant','RecordingSession','ETSessions'});
overviewSessionInfo = table;
dataCheckOverview = table;
recordingOverview = table;
overviewFrameRates = table;
%overviewDataCheckInfo = table('Size', [length(allFiles), 3],'VarTypes',{'double','double','double'},'VariableNames',{'Participant','RecordingSession','ETSession','TotalDataRows','TotalDoublicates','PercentDoublicates','TotalMissingData','PercentMissingData'});

% loop over all known information to check for missing data files
% loop over participants
for indexPart = 1:Number
    
    currentPart = cell2mat(PartList(indexPart));
    
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Expl_S_' num2str(indexSess) '*_flattened.csv']);
        
        % update overviewSessionInfo
        sessionInfo = table;
        sessionInfo.Participant = currentPart;
        sessionInfo.RecordingSession = indexSess;
        sessionInfo.ETsessions = length(dirSess);
        
        overviewSessionInfo = [overviewSessionInfo;sessionInfo];
        
        % loop over ET sessions and check data
        for indexET = 1: length(dirSess)
            
            currentData = readtable(dirSess(indexET).name);
            
            % check data and save into currentCheck table
            currentCheck = table;
            currentCheck.Participant = currentPart;
            currentCheck.rSession = indexSess;
            currentCheck.ETsess = indexET;
            
            currentCheck.totalStarts = length(currentData.timeStampDataPointStart);
            currentCheck.uniqueStarts = length(unique(currentData.timeStampDataPointStart));
            currentCheck.doublicatedStarts = currentCheck.totalStarts - currentCheck.uniqueStarts;
            
            currentCheck.totalEnds = length(currentData.timeStampDataPointEnd);
            currentCheck.uniqueEnds = length(unique(currentData.timeStampDataPointEnd));
            currentCheck.doublicatedEnds = currentCheck.totalEnds - currentCheck.uniqueEnds;
            
            currentCheck.totalVerboseTS = length(currentData.timeStampGetVerboseData);
            currentCheck.uniqueVerboseTS = length(unique(currentData.timeStampGetVerboseData));
            currentCheck.doublicatedVerboseTS = currentCheck.totalVerboseTS - currentCheck.uniqueVerboseTS;
            
            dataCheckOverview = [dataCheckOverview; currentCheck];

%--------------------------------------------------------------------
%             figure(indexET)
%             plotty = plot(currentData.timeStampDataPointStart);
%             
%             figure(indexET+10)
%             plotty2 = plot(currentData.timeStampDataPointEnd);
%             
%             figure(indexET+100)
%             
%             plotty3 = plot(currentData.timeStampGetVerboseData);

%-------------------------------------------------------------------------
            overviewTimeStamps = table;
            overviewTimeStamps.timeStampDataPointStart = currentData.timeStampDataPointStart;
            overviewTimeStamps.timeStampDataPointEnd = currentData.timeStampDataPointEnd;
            overviewTimeStamps.timeStampGetVerboseData = currentData.timeStampGetVerboseData;
            
            overviewTimeStamps.DifStartEnd = overviewTimeStamps.timeStampDataPointStart - overviewTimeStamps.timeStampDataPointEnd;
            overviewTimeStamps.DifStartVerbose = overviewTimeStamps.timeStampDataPointStart - overviewTimeStamps.timeStampGetVerboseData;
            overviewTimeStamps.DifVerboseEnd = overviewTimeStamps.timeStampGetVerboseData - overviewTimeStamps.timeStampDataPointEnd;

            



            for indexData = 2:height(currentData)
                
                
                currentStart = currentData.timeStampDataPointStart(indexData);
                lastStart = currentData.timeStampDataPointStart(indexData-1);
                
                overviewTimeStamps.recRateStart(indexData-1) = currentStart-lastStart;
                
                currentEnd = currentData.timeStampDataPointEnd(indexData);
                lastEnd = currentData.timeStampDataPointEnd(indexData-1);
                
                overviewTimeStamps.recRateEnd(indexData-1) = currentEnd-lastEnd;
                
                currentVB = currentData.timeStampGetVerboseData(indexData);
                lastVB = currentData.timeStampGetVerboseData(indexData-1);
                
                overviewTimeStamps.recRateVerboseD(indexData-1) = currentVB-lastVB;
                
                
            end
            
            writetable(overviewTimeStamps, [savepath num2str(currentPart) '_' num2str(indexSess) '_' num2str(indexET) '_overviewTimeStamps.csv']);
            
            currentT = table;
            currentT.FileName = dirSess(indexET).name;
            currentT.meanDifStartEnd = mean(overviewTimeStamps.DifStartEnd);
            currentT.meanDifStartVerbose = mean(overviewTimeStamps.DifStartVerbose);
            currentT.meanDifVerboseEnd = mean(overviewTimeStamps.DifVerboseEnd);
            currentT.meanRecRateStart = mean(overviewTimeStamps.recRateStart);
            currentT.meanRecRateEnd = mean(overviewTimeStamps.recRateEnd);
            currentT.meanRecRateVerboseD = mean(overviewTimeStamps.recRateVerboseD);

            overviewFrameRates = [overviewFrameRates; currentT];



            
                      
        end
        
        
          
        
    end
    
    
    writetable(overviewSessionInfo, [savepath 'overviewSessionInfo.csv']);
    writetable(dataCheckOverview, [savepath 'overviewDataCheck.csv']);
    writetable(overviewFrameRates, [savepath 'overviewFrameRates']);
%     writeTable(overvieTimeStamps, [savepath num2str(currentPart) '_' num2str(indexSess) '_' num2str(indexET) '_overviewTimeStamps.csv']);
%     
    
    

end


disp(strcat(num2str(Number), ' Participants analysed'));

disp('done');