%% -----------------create_overviewGraphData_allParticipants_V3-------------------------
% script written by Jasmin Walter

% collects graph data of all participants and saves in struct
% overviewGraphData_allParticipants_V3

clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\weightedGraphs\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\graphs_weighted\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

overviewGraphData = struct;

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph_weighted_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        % load graph      
        graphyW = load(file);
        graphyW= graphyW.graphyW;
        
        nodeTable = graphyW.Nodes;
        edgeTable = graphyW.Edges;
        edgeCell = edgeTable.EndNodes;
        weights = edgeTable.Weight;
        
        overviewGraphData(ii).Participant = currentPart;
        overviewGraphData(ii).NodeNr = height(nodeTable);
        overviewGraphData(ii).NodeTable = nodeTable;
        overviewGraphData(ii).EdgeNr = height(edgeTable);
        overviewGraphData(ii).EdgeTable = edgeTable;
        overviewGraphData(ii).EdgeCell = edgeCell;
        overviewGraphData(ii).Weights = weights;
        overviewGraphData(ii).AvgWeight = mean(weights);
        
      
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath,'overviewGraphData_allParticipants.mat'],'overviewGraphData')
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');