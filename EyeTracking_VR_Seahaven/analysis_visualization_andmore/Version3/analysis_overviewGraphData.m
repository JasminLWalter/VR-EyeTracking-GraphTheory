%% ---------------------- analysis Graph Data ----------------------------------
% script written by Jasmin Walter


clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\weightedGraphs\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\weightedGraphs\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;



% load graph      
overviewGD = load('overviewGraphData_allParticipants.mat');
overviewGD = overviewGD.overviewGraphData;

% lets get some stats:

avgNodeNr = mean([overviewGD.NodeNr]);
avgEdgeNr = mean([overviewGD.EdgeNr]);
avgWeights = mean([overviewGD.AvgWeight]);

completeOverviewEdges = table;
completeOverviewEdges.Node1 = cell2table(overviewGD(1).EdgeCell(:,1));
completeOverviewEdges.Node2 = cell2table(overviewGD(1).EdgeCell(:,2));
completeOverviewEdges.Weight = overviewGD(1).Weights;

for index = 2:length(overviewGD)
    helperE = cell2Table(overviewGD(index).EdgeCell);
    helperW = overviewGD(index).Weights;
    
    for index2 = 1:height(helperE)
        % look for 1st combination
        
        edge1 = helperE(index2,1);
        edge2 = helperE(index2,2); 
        
        find1 = ismember(fullEdgeT, helperT);
            sum1 = sum(find1);
            
            % find second edge direction
            helperT.Column1 = edge2;
            helperT.Column2 = edge1;
            find2 = ismember(fullEdgeT, helperT);
            sum2 = sum(find2);
        
        
    end
    
    
end



disp('done');