%% ------------------ create_Graphs_C----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'F:\Cyprus_project_overview\data\graphs\';


cd 'F:\Cyprus_project_overview\data\et_data_labled_buildings\';

clistpath = 'F:\Cyprus_project_overview\data\buildings\';
colliderList = readtable(strcat(clistpath, "building_coordinate_list.csv"));

s1_et1 = 'fixation_GPS_Expl_1_ET_1 - fixation_GPS_Expl_1_ET_1.csv';
s1_et2 = 'fixation_GPS_Expl_1_ET_2 - fixation_GPS_Expl_1_ET_2.csv';
s1_et3 = 'fixation_GPS_Expl_1_ET_3 - fixation_GPS_Expl_1_ET_3.csv';
s2_et1 = 'fixation_GPS_Expl_2_ET_1 - fixation_GPS_Expl_2_ET_1.csv';


fileList = {s1_et1; s1_et2; s1_et3; s2_et1};
% 
% data11 = readtable(fileList{1});
% data12 = readtable(fileList{2});
% data13 = readtable(fileList{3});
% data21 = readtable(fileList{4});
gazesData = table;
for fileIndex = 1: length(fileList)
    if fileIndex == 1

        buildingData = string(readtable(fileList{fileIndex}).HouseNr_);

    else

        buildingData = string(readtable(fileList{fileIndex}).house_nr);
    end


    gazesTable = table;
    gazesTable.name = buildingData;
    gazesTable.name(end+1) ={'newSession'};
    
    gazesData = [gazesData; gazesTable];


end

gazesData.name = cellstr(gazesData.name);
% remove missing values and remove 0s

isMissing = ismissing(gazesData.name);
isZero = strcmp(gazesData.name, '0');
remove = isMissing | isZero;

gazesData(remove,:) = [];


%-------------------------------------------------------------------------------
% create the graph

% remove all elements that are not a building 
% and not the new session and noData markers


% create nodetable
uniqueHouses= unique(gazesData.name(:));
NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

% create edge table

fullEdgeT= cell2table(gazesData.name,'VariableNames',{'Column1'});

% prepare second column to add to specify edges
secondColumn = fullEdgeT.Column1;
% remove first element of 2nd column
secondColumn(1,:)=[];  
% remove last element of 1st column
fullEdgeT(end,:)= [];

% add second column to table
fullEdgeT.Column2 = secondColumn;


% remove all repetitions
% 1st round- using unique

uniqueTable= unique(fullEdgeT);

% 2nd round using for loop

%check if first entry is a self-reference
%create edgetable

if (strcmp(uniqueTable{1,1},uniqueTable{1,2}))
    % if self-reference start noRepsTable with second entry
     noRepsTable= uniqueTable(2,:);
     noRepsTable.Properties.VariableNames = {'Column1','Column2'};

     repetitions={};
     selfReferences={};
     start = 3;
else

     noRepsTable= uniqueTable(1,:);
     noRepsTable.Properties.VariableNames = {'Column1','Column2'};

     repetitions={};
     selfReferences={};
     start = 2;
end

for n=start:height(uniqueTable)

    node1=uniqueTable{n,1};
    node2=uniqueTable{n,2};
    combi2= cell2table([node2,node1],'VariableNames',{'Column1','Column2'});

    % check if there is a self-reference and don't add it
    if strcmp(node1,node2)
        selfReferences=[selfReferences;[node1,node2]];

    % check if node is already in edgetable (should not be the case
    % if unique worked correctly)                    
    elseif sum(ismember(noRepsTable,uniqueTable(n,:),'rows')) == 0

        % check if other combination of node is in edgetable
        % if it is not as well, add first combination of node to edgetable 
        % else, add it to repetition list

        if sum(ismember(noRepsTable,combi2,'rows')) == 0          
           noRepsTable=[noRepsTable;uniqueTable(n,:)]; 

        else    
            repetitions=[repetitions;uniqueTable(n,:)];

        end
    else
        disp('something went wrong with unique');
    end

end


% create edgetable in merging column 1 and 2 into one variable EndNodes
EdgeTable= mergevars(noRepsTable,{'Column1','Column2'},'NewVariableName','EndNodes');

%% create graph

graphyNoData = graph(EdgeTable,NodeTable);


%% remove node noData and newSession from graph

% graphy = rmnode(graphyNoData, 'noData');
graphy = rmnode(graphyNoData, 'newSession');

%% save graph
save([savepath 'graph_limassol.mat'],'graphy');

