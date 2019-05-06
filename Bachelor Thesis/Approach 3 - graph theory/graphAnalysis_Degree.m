%% ------------------ graphAnalysis_Degree---------------------------------
% script written by Jasmin Walter

% saves graph plots 
% created overview table of node degree information of all participants

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\graphs\'

PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load house list
housedata= load('D:\BA Backup\Data_after_Script\HouseList.mat');
houseList= housedata.houseList;

overviewNodeDegree = cell2table(houseList);



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        %% print graphs to pdfs
%         namey= strcat(num2str(currentPart),'_Graph');
%         figure('Name',namey,'IntegerHandle', 'off')
%         graphy = load(file);
%         graphy= graphy.graphy;
%         plot(graphy,'NodeLabelMode','auto')
%         print('-fillpage',strcat(savepath,namey),'-dpdf')
%% analysis
        %load graph
        graphy = load(file);
        graphy= graphy.graphy;
        plot(graphy)
        
        % save degree nodes, edge nodes
        
        % create table with houses and node degree info
        degreeG= degree(graphy);
        
        nodeDegreeTable = graphy.Nodes;
        nodeDegreeTable.Edges = degreeG;
        
        % update overview NodeDegree
        
        currentPartName= strcat('Part_',num2str(currentPart));
        extraVar= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});

        
       for n= 1: height(nodeDegreeTable)
           changer = strcmp(overviewNodeDegree.houseList(:),nodeDegreeTable{n,1});
           
           extraVar(changer,1)= nodeDegreeTable(n,2);        
            
       end
        
        % concatinage extraVar and overview
        overviewNodeDegree= [overviewNodeDegree extraVar];
             
        
        
    else
        disp('something went really wrong with participant list');
    end

end


% save nodedegree overview
save([savepath 'Overview_NodeDegree.mat'],'overviewNodeDegree');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');