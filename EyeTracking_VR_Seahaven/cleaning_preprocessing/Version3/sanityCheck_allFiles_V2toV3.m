%% SanityCheck_allFiles_V2toV3 - calculates different sanity checks 
% sanity checks to compare Version2 and Version 3 preprocessing steps 
% Sanity checks on all levels implemented:
% (Raycast3.0, 
% condensedHouses,
% join3Sessions
% interpolatedData
% gazes_vs_noise
% graphs)

% script written by Jasmin Walter

%% sanity check - Raycast3.0 files and ViewedHouses files (raw data directly from Unity Raycast)
% clear all;
% % adjust savepath, current folder and participant list!
% savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';
% 
% cd 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\Raycast3.0\'
% 
% filesR = dir('Raycast3.0_VP*.txt');
% 
% nrFiles = length(filesR);
% 
% overviewAnalysis = table;
% summary = [];
% 
% 
% for index = 1:nrFiles
%     
%     %fileRC = strcat('Raycast3.0_VP1012.txt');
% 
%     rawDRayC = readtable(filesR(nrFiles).name, 'Delimiter',',', 'Format','%f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%     %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
%     dataRC = [rawDRayC(:,2), rawDRayC(:,3), rawDRayC(:,1)];
% 
%     
%     % viewed houses raw
%     VPnr = filesR(nrFiles).name(end-7:end-4);
% 
%     fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\rawData\ViewedHouses\ViewedHouses_VP',VPnr , '.txt');
%     rawDVH = readtable(fileVH,'Format','%s %f %f','ReadVariableNames',false);
%     rawDVH.Properties.VariableNames = {'Collider','Distance','TimeStamp'};
%     dataVH = rawDVH;
%     %dataVH(1,:) = [];
% 
%     isSame = isequal(dataRC, dataVH);
%     isDifferent = setdiff(dataRC, dataVH);
%     
%     overviewAnalysis = [overviewAnalysis; isDifferent];
%     summary = [summary; isSame];
%     
%     
%     
% end
% 
%% Sanity check for files directly after the first condensation scripts in V2 and V3
% checks if condensedViewedHouses and condensedColliders are identical

% clear all;
% % adjust savepath, current folder and participant list!
% %savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';
% 
% cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\condensedColliders\'
% 
% filesCC = dir('*_condensedColliders_V3.mat');
% 
% nrFiles = length(filesCC);
% 
% overviewAnalysis = table;
% summary = [];
% 
% 
% for index = 1:nrFiles
%     
%     %fileRC = strcat('Raycast3.0_VP1012.txt');
% 
%     condensedData = load(filesCC(index).name);
%     condensedData = condensedData.condensedData;
%     %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
%     %dataRC = [condensedData(:,2), condensedData(:,3), condensedData(:,1)];
%     tableCD = table;
%     tableCD.Samples = [condensedData.Samples]';
%     tableCD.Houses = {condensedData.Collider}';
%     
%     % viewed houses raw
%     VPnr = filesCC(index).name(1:4);
% 
%     fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\condenseViewedHouses\',VPnr,'_condensedViewedHouses.mat');
%     allData = load(fileVH);
%    % allData.Properties.VariableNames = {'Collider','Distance','TimeStamp'};
%     allData = allData.AllData;
%     tableVH = table;
%     tableVH.Samples = allData.Samples;
%     tableVH.Houses = allData.House;
% 
%     %dataVH(1,:) = [];
% 
%     isSame = isequal(tableCD, tableVH);
%     isDifferent = setdiff(tableCD, tableVH);
%     if(not(isSame))
%         disp(strcat('fileVH_',fileVH));
%         disp(strcat('fileCC', filesCC(index).name));
%     end
%     
%     overviewAnalysis = [overviewAnalysis; isDifferent];
%     summary = [summary; isSame];
%     
%     
%     
% end

%% Sanity check for combined 3 session files
% checks if condensedViewedHouses and condensedColliders are identical

% clear all;
% % adjust savepath, current folder and participant list!
% %savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';
% 
% cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\combined3sessions\'
% 
% filesCC = dir('*condensedColliders_3Sessions_V3.mat');
% 
% nrFiles = length(filesCC);
% 
% overviewAnalysis = table;
% summary = [];
% 
% 
% for index = 1:nrFiles
%     
%     %fileRC = strcat('Raycast3.0_VP1012.txt');
% 
%     condensedColliders3 = load(filesCC(index).name);
%     condensedColliders3 = condensedColliders3.condensedColliders3S;
%     %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
%     %dataRC = [condensedData(:,2), condensedData(:,3), condensedData(:,1)];
%     tableCD = table;
%     tableCD.Samples = [condensedColliders3.Samples]';
%     tableCD.Houses = {condensedColliders3.Collider}';
%     
%     change = strcmp(tableCD.Houses, 'newSession');
%     tableCD.Houses(change)= {'noData'};
%     tableCD.Samples(change) = 10;
%     
%     % load matching interpolated file from V2
%     VPnr = filesCC(index).name(1:2);
% 
%     fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\combined3Sessions\condensedViewedHouses3_Part',VPnr,'.mat');
%     viewedHouses3 = load(fileVH);
%    % allData.Properties.VariableNames = {'Collider','Distance','TimeStamp'};
%     viewedHouses3 = viewedHouses3.viewedHouses3;
%     tableVH = table;
%     tableVH.Samples = viewedHouses3.Samples;
%     tableVH.Houses = viewedHouses3.House;
% 
%     %dataVH(1,:) = [];
% 
%     isSame = isequal(tableCD, tableVH);
%     isDifferent = setdiff(tableCD, tableVH);
%     if(not(isSame))
%         disp(strcat('fileVH_',fileVH));
%         disp(strcat('fileCC', filesCC(index).name));
%     end
%     
%     overviewAnalysis = [overviewAnalysis; isDifferent];
%     summary = [summary; isSame];
%     
%     
%     
% end

%% Sanity check for files interpolated in V2 and V3
% checks if condensedViewedHouses and condensedColliders are identical

% clear all;
% % adjust savepath, current folder and participant list!
% %savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';
% 
% cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\interpolatedColliders\'
% 
% filesCC = dir('*_interpolatedColliders_3Sessions_V3.mat');
% 
% nrFiles = length(filesCC);
% 
% overviewAnalysis = table;
% summary = [];
% 
% 
% for index = 1:nrFiles
%     
%     %fileRC = strcat('Raycast3.0_VP1012.txt');
% 
%     interpolatedData3 = load(filesCC(index).name);
%     interpolatedData3 = interpolatedData3.interpolatedData;
%     %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
%     %dataRC = [condensedData(:,2), condensedData(:,3), condensedData(:,1)];
%     tableCD = table;
%     tableCD.Samples = [interpolatedData3.Samples]';
%     tableCD.Houses = {interpolatedData3.Collider}';
%     
%     change = strcmp(tableCD.Houses, 'newSession');
%     tableCD.Houses(change)= {'noData'};
%     tableCD.Samples(change) = 10;
%     
%     % load matching interpolated file from V2
%     VPnr = filesCC(index).name(1:2);
% 
%     fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\interpolateLostData\',VPnr,'_interpolatedViewedHouses.mat');
%     interpolatedData2 = load(fileVH);
%    % allData.Properties.VariableNames = {'Collider','Distance','TimeStamp'};
%     interpolatedData2 = interpolatedData2.interpolatedData;
%     tableVH = table;
%     tableVH.Samples = interpolatedData2.Samples;
%     tableVH.Houses = interpolatedData2.House;
% 
%     %dataVH(1,:) = [];
% 
%     isSame = isequal(tableCD, tableVH);
%     isDifferent = setdiff(tableCD, tableVH);
%     if(not(isSame))
%         disp(strcat('fileVH_',fileVH));
%         disp(strcat('fileCC', filesCC(index).name));
%     end
%     
%     overviewAnalysis = [overviewAnalysis; isDifferent];
%     summary = [summary; isSame];
%     
%     
%     
% end

%% Sanity check for files gaze_vs_noise in V2 and V3
% 

% clear all;
% % adjust savepath, current folder and participant list!
% %savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';
% 
% cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'
% 
% filesCC = dir('*_gazes_data_V3.mat');
% 
% nrFiles = length(filesCC);
% 
% overviewAnalysis = table;
% summary = [];
% 
% 
% for index = 1:nrFiles
%     
%     %fileRC = strcat('Raycast3.0_VP1012.txt');
% 
%     gazesV3 = load(filesCC(index).name);
%     gazesV3 = gazesV3.gazedObjects;
%     %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
%     %dataRC = [condensedData(:,2), condensedData(:,3), condensedData(:,1)];
%     tableCD = table;
%     tableCD.Samples = [gazesV3.Samples]';
%     tableCD.Houses = {gazesV3.Collider}';
%     
%     change = strcmp(tableCD.Houses, 'newSession');
%     tableCD.Houses(change)= {'noData'};
%     tableCD.Samples(change) = 10;
%     
%     % load matching interpolated file from V2
%     VPnr = filesCC(index).name(1:2);
% 
%     fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\gazes_vs_noise\gazes_data_',VPnr,'.mat');
%     gazesV2 = load(fileVH);
%    % allData.Properties.VariableNames = {'Collider','Distance','TimeStamp'};
%     gazesV2 = gazesV2.gazedObjects;
%     tableVH = table;
%     tableVH.Samples = gazesV2.Samples;
%     tableVH.Houses = gazesV2.House;
% 
%     %dataVH(1,:) = [];
% 
%     isSame = isequal(tableCD, tableVH);
%     isDifferent = setdiff(tableCD, tableVH);
%     if(not(isSame))
%         disp(strcat('fileVH_',fileVH));
%         disp(strcat('fileCC', filesCC(index).name));
%     end
%     
%     overviewAnalysis = [overviewAnalysis; isDifferent];
%     summary = [summary; isSame];
%     
%     
%     
% end
% 


%% Sanity check for graphs in V2 and V3
% 

clear all;
% adjust savepath, current folder and participant list!
%savepath = 'E:\NBP\SeahavenEyeTrackingData\rawData\BackUp_31.05.2020\workingwithRayCast\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\graphs\'

filesCC = dir('*_graph_V3.mat');

nrFiles = length(filesCC);

overviewAnalysisN = table;
overviewAnalysisE = table;
summaryN = [];
summaryE = [];


for index = 1:nrFiles
    
    %fileRC = strcat('Raycast3.0_VP1012.txt');

    graphyV3 = load(filesCC(index).name);
    graphyV3 = graphyV3.graphy;
    %dataRay.Properties.VariableNames = {'House','Distance','Timestamp'};
    %dataRC = [condensedData(:,2), condensedData(:,3), condensedData(:,1)];
    nodeTableV3 = graphyV3.Nodes;
    edgeTableV3 = graphyV3.Edges;
    edgeTableV3 = splitvars(edgeTableV3);
    
    % load matching interpolated file from V2
    VPnr = filesCC(index).name(1:2);

    fileVH = strcat('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\graphs\',VPnr,'_Graph.mat');
    graphyV2 = load(fileVH);
    graphyV2 = graphyV2.graphy;
    
    nodeTableV2 = graphyV2.Nodes;
    edgeTableV2 = graphyV2.Edges;
    edgeTableV2 = splitvars(edgeTableV2);

    %dataVH(1,:) = [];

    isSameN = isequal(nodeTableV3, nodeTableV2);
    isDifferentN = setdiff(nodeTableV3, nodeTableV2);
    if(not(isSameN))
        disp(strcat('fileVH_',fileVH));
        disp(strcat('fileCC', filesCC(index).name));
    end
    
    overviewAnalysisN = [overviewAnalysisN; isDifferentN];
    summaryN = [summaryN; isSameN];
    
    isSameE = isequal(edgeTableV3, edgeTableV2);
    isDifferentE = setdiff(edgeTableV3, edgeTableV2);
    if(not(isSameE))
        disp(strcat('fileVH_',fileVH));
        disp(strcat('fileCC', filesCC(index).name));
    end
    
    overviewAnalysisE = [overviewAnalysisE; isDifferentE];
    summaryE = [summaryE; isSameE];
    
    
    
end



 


 
 


 
