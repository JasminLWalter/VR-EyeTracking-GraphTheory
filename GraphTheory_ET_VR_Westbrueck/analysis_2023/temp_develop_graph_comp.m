%% ------------------ comparison_graphs_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 
% 

% Output: 



clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


graphPath1 =  'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';
graphPath2 = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\tempDevelopment\1minSections\graphs\';
%--------------------------------------------------------------------------

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load coordinate list

graphComp_overview = table;

graphComp_overview.Participants = PartList';




for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));   
    
    file1 = strcat(graphPath1, num2str(currentPart),'_Graph_WB.mat');

    %load graph
    graphy1 = load(file1);
    graphy1= graphy1.graphy;



    file2 = strcat(graphPath2, num2str(currentPart),'_Graph_WB.mat');

    %load graph
    graphy2 = load(file2);
    graphy2= graphy2.graphy;

    graphComp_overview.SameNodes(ii) = isequal(graphy1.Nodes, graphy2.Nodes);
    graphComp_overview.SameEdges(ii) = isequal(graphy1.Edges.EndNodes, graphy2.Edges.EndNodes);




end