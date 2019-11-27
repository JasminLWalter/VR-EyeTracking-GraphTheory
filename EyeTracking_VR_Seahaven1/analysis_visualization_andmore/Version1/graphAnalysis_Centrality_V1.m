%% ------------------ graphAnalysis_Centrality-----------------------------
% script written by Jasmin Walter

% calculates and plots different types of centrality

clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\analysis\centrality\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\'

PartList = {6468};
%,2907,5324,4302,7561,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;





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
    
    % analysis
        %load graph
        graphy = load(file);
        graphy= graphy.graphy;
        
        
        nodetable = graphy.Nodes;
        overviewCentrality = nodetable;
        
        %% ploting centrality nodes
        nameDegree = strcat('Degree Centrality Participant ',num2str(currentPart));
        figure('Name',nameDegree,'IntegerHandle', 'off')
        plotDegree= plot(graphy);
        plotDegree.MarkerSize = 5;
        centdegr= centrality(graphy,'degree');
        plotDegree.NodeCData= centdegr;
        colormap jet
        colorbar
        title(nameDegree)
        print(strcat(savepath,'Degree Centrality Participant ',num2str(currentPart)),'-dpng')
        
        %set(gcf,'resolution','-r0')
        %print(strcat(savepath,'Degree_Centrality_Participant_',num2str(currentPart)),'-dpdf','-bestfit')
        %print(strcat(savepath,'Degree_Centrality_Participant_',num2str(currentPart)),'-dpng')
        
        
        
        % add to overview
        overviewCentrality.Degree= centdegr;

        
      
        %% ploting closeness centrality
        nameCloseness= strcat('Closeness Centrality Participant ',num2str(currentPart));
        figure('Name',nameCloseness,'IntegerHandle', 'off')
        plotCloseness= plot(graphy);
        plotCloseness.MarkerSize = 5;
        ucc = centrality(graphy,'closeness');
        plotCloseness.NodeCData = ucc;
        colormap jet
        colorbar
        title(nameCloseness)
        print(strcat(savepath,'Closeness Centrality Participant ',num2str(currentPart)),'-dpng')
       
        
        % add to overview
        overviewCentrality.Closeness = ucc;
      
       
        
        %% ploting 'betweenness'
        nameBetweenness= strcat('Betweenness Centrality Scores Participant ',num2str(currentPart));
        figure('Name',nameBetweenness,'IntegerHandle', 'off')
        plotBetweenness= plot(graphy);
        plotBetweenness.MarkerSize = 5;
        betweenCent = centrality(graphy,'betweenness');
        plotBetweenness.NodeCData = betweenCent;
        colormap jet
        colorbar
        title(nameBetweenness)
             
        print(strcat(savepath,'Betweenness Centrality Participant ',num2str(currentPart)),'-dpng')
        
        % add to overview
        overviewCentrality.Betweenness = betweenCent;

        
        
        %% ploting paperank
        namePagerank= strcat('Pagerank Centrality Scores Participant ',num2str(currentPart));
        figure('Name',namePagerank,'IntegerHandle', 'off')
        plotPagerank= plot(graphy);
        plotPagerank.MarkerSize = 5;
        paperankCent = centrality(graphy,'pagerank');
        plotPagerank.NodeCData = paperankCent;
        colormap jet
        colorbar
        title(namePagerank)
         print(strcat(savepath,'Pagerank Centrality Participant ',num2str(currentPart)),'-dpng')
        
        % add to overview
        overviewCentrality.Pagerank = paperankCent;

        
        
        %% ploting eigenvector
        nameEigenvector= strcat('Eigenvector Centrality Scores Participant ',num2str(currentPart));
        figure('Name',nameEigenvector,'IntegerHandle', 'off')
        plotEigenvector= plot(graphy);
        plotEigenvector.MarkerSize = 5;
        eigenvectorCent = centrality(graphy,'eigenvector');
        plotEigenvector.NodeCData = eigenvectorCent;
        colormap jet
        colorbar
        title(nameEigenvector)
        print(strcat(savepath,'Eigenvector Centrality Participant ',num2str(currentPart)),'-dpng')
        
        % add to overview
        overviewCentrality.Eigenvector = eigenvectorCent;

        
        
        
    else
        disp('something went really wrong with participant list');
    end

end
% save nodedegree overview
save([savepath 'overviewCentrality_Participant_' num2str(currentPart) '.mat'],'overviewCentrality');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');