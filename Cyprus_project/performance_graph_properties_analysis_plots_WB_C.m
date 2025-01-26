%% ------------------ performance_graph_properties_analysis_plots_WB_C.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'F:\Cyprus_project_overview\data\comparison2VR\40min\graphMeasuresHA\';

cd 'F:\Cyprus_project_overview\data\comparison2VR\40min\graphs_HA\';


PartList = {365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7264 7412 7842 8007 8469 8673 9472 9502 9586 9601};


%% load graphs and calculate missing measures

% %load coordinate list
% 
% listname = strcat(clistpath,'building_collider_list.csv');
% coordinateList = readtable(listname);
% 
% houseNames = unique(coordinateList.target_collider_name);
% 
% overviewNodeDegreeW = cell2table(houseNames);

overviewGraphMeasures = table; 
overviewGraphMeasures.Participants = PartList';



for index = 1:length(PartList)
    currentPart = PartList{index};   
    
    file = strcat(num2str(currentPart),'_Graph_WB.mat');
   
    %load graph
    graphy = load(file);
    graphy= graphy.graphy;
    
    % calculate graph measures
    nrNodes = height(graphy.Nodes);
    nrEdges = height(graphy.Edges);
    maxEdges = (nrNodes * (nrNodes -1)) / 2;
    density = height(graphy.Edges) / maxEdges;
    
    % get diameter
    distanceM = distances(graphy);
    checkInf = isinf(distanceM);
    distanceM(checkInf) = 0;
    diameter = max(max(distanceM));
    avgShortestPath = mean(distanceM, "all");
    
    
    % add data to overview
    
    overviewGraphMeasures.nrViewedHouses(index) = nrNodes;
    overviewGraphMeasures.nrEdges(index) = nrEdges;
    overviewGraphMeasures.density(index) = density;
    overviewGraphMeasures.diameter(index) = diameter;
    overviewGraphMeasures.avgShortestPath(index) = avgShortestPath;

    

end

%% save overviews
save([savepath 'overviewGraphMeasures'],'overviewGraphMeasures');
writetable(overviewGraphMeasures, [savepath, 'overviewGraphMeasures.csv']);

