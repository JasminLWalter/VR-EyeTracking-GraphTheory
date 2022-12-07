%% ----------------------- Spectral Partitioning --------------------------

% -------------------- written by Lucas Essmann - 2020 --------------------
% ---------------------- lessmann@uni-osnabrueck.de -----------------------


% Requirements:
% undirected, unweighted graphs with Edges and Nodes Table 


%Spectral Graph Analysis consists of three steps
%--------------------------------------------------------------------------
% 1. Pre-Processing: Create the Laplacian Matrix of the graph 
%    (Degree Matrix - Adjacency Matrix) 
%--------------------------------------------------------------------------
% 2. Decomposition: Compute Eigenvalues and eigenvectors of the matrix.
%    Take the second smallest eigenvalue/eigenvector
%--------------------------------------------------------------------------
% 3. Grouping: Split the vector in two (negative and positiv components) 
%    to get two clusters
%--------------------------------------------------------------------------

% At the current state the script checks if the graph is connected or not,
% i.e. if there are nodes with Node Degree = 0. If there is only one not
% connected node, it is removed for the analysis to be able to use the
% second smallest Eigenvalue. Iff there are more than 1 non connected nodes
% the 3rd smallest Eigenvalue will be used. 

% Input: 
% Graph_V3.mat           = the gaze graph object for every participant


% Output: 
% 2ndSmallestEigenvector.png = The second smallest eigenvector of the Laplacian 
                               % matrix is sorted ascendingly and color coded 
                               % into two clusters. (Fig 4c in the paper)
                               
% Cluster.png = cluster visualization of the graph

% Spy_AdjacencyMatrix.png   = The sparsity pattern of the graph’s adjacency 
%                             matrix sorted by the entries in second smallest
%                             eigenvector. Color coded into edges between 
%                             nodes of one cluster (green), edges between 
%                             nodes of the other cluster (red), edges between 
%                             nodes of the two clusters (black) and a distinction 
%                             between the clusters (yellow) (Fig 4a in the
%                             paper)
%                                    

% Histogram_2nd_Smallest_EigentvectorL = Histogram of the distribution of
%                                        second smallest eigenvector for
%                                        each participant

% eig_neg.mat = negative part of the eigenvector

% eig_pos.mat = positive part of the eigenvector

% EigenvalueSpectrumL = all Eigenvalues

% SpectralDocumentation.mat = overview of Eigenvalue statistics over all
%                             participants



clear all;

%% ---------- adjust the following variables: --------------------------------

path = what;
path = path.path;

%savepath
savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\SpectralPartitioning\';


% cd into graph folder location
cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs\';

plotting_wanted = true; % if you want to plot, set to true
saving_wanted = true; % if you want to save, set to true

%% -------------------------- Initialisation ------------------------------

%graphfolder
% PartList = dir();
% PartList = struct2cell(PartList);

partList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%reduce the folder to the graphs only
% PartList = PartList(1,3:end);
% amount of graphs
totalgraphs = length(partList);

%Documentation Table
Doc = table();
Cut_Edges = table();



%% ----------------------------- Main -------------------------------------

% note, if you have a missing participant file in the graph folder, you
% need to remove this from reading into the for loop - e.g. an easy fix is: 
% for part = 1:totalgraphs-1

for partIndex = 1:totalgraphs 
    tic
    disp(partIndex)
    %load graph
    currentPart = cell2mat(partList(partIndex));
    graphy = load(strcat(num2str(currentPart),'_Graph_WB.mat'));
    graphy = graphy.graphy;

    
%First of all check whether the graph is fully connected or not! IFF the
%graph has ONE node that is not connected, delete/ignore the node for
%partitioning! Else (2 or more single nodes) proceed the script

%Search for nodes with degree zero!
    cent = centrality(graphy,'degree');
    k = find(cent==0);
    %Iff k has only one entry: create a subgraph without the one node
    if length(k) <= 1 
        node2rmv = table2array(graphy.Nodes(k,:));
        OG_graphy = graphy;
        graphy = rmnode(graphy,node2rmv);
    else 
        disp('Graph is not fully connected, 3rd smallest EV will be used');
    end
%% ----------------------------- Step 1 -----------------------------------

DegreeMatrix = diag(degree(graphy));

AdjacencyMatrix = full(adjacency(graphy));

LaplacianMatrix = DegreeMatrix - AdjacencyMatrix;


%% ----------------------------- Step 2 -----------------------------------
%Step 2 and 3 are executed twice depending on the graph being connected or
%not! 
[EigenvectorL,EigenvalueL] = eig(LaplacianMatrix);
[EigenvectorA,EigenvalueA] = eig(AdjacencyMatrix);
eigenvector2L = [];
eigenvector3L = [];
eigenvalue2L = [];
eigenvalue3L = [];


%-------------------- Step 2 - Graph Connected ----------------------------
%Check whether the graph is connected or not 
%Iff connected, eig2 > 0, else eig2 = 0, then use eig3!

% Graph is connected (if not: go to line 260)
    if EigenvalueL(2,2) > 1e-10

        eigenvalue2L = EigenvalueL(2,2);
        eigenvector2L = EigenvectorL(:,2);
        AllEigValuesL(:,partIndex) = eigenvalue2L;

%---------------------------- Controls ------------------------------------
        %Checking whether the Eigenvalues and Eigenvectors have the right
        %corresponding arrangement
        [d,ind] = sort(diag(EigenvalueL));
        Vs = EigenvectorL(:,ind);
        control_square(partIndex,1) = sum(eigenvector2L);
        control_square(partIndex,2) = sum(eigenvector2L.^2);

            if isequal(EigenvectorL,Vs)  ...
                    && sum(eigenvector2L) ...
                    < 1e-10 && sum(eigenvector2L.^2) ...
                    > 1-1e-10
                disp(strcat('Participant_',num2str(currentPart),' is valid'));
            else
                disp(strcat('Something went wrong, ', ...
                    'the Eigenvector might be the wrong one - Part_',...
                    currentPart) );
            end

%-------------------- Step 3 - Graph Connected ----------------------------
    %Sort the eigenvector
    [eigenvector2_sort,index] = sort(eigenvector2L,'ascend');
    %Split it into positive and negative part
    eig_pos = eigenvector2_sort(eigenvector2_sort > 0);
    eig_neg = eigenvector2_sort(eigenvector2_sort < 0);
    %
    eig_posT = table();
    eig_negT = table();
    eig_posT.eig_pos = eig_pos;
    eig_posT.index = index(1:length(eig_pos));
    eig_posT.house = graphy.Nodes{eig_posT.index,:};
    eig_negT.eig_neg = eig_neg;
    eig_negT.index = index(length(eig_pos)+1:end);
    eig_negT.house = graphy.Nodes{eig_negT.index,:};

    %Documentation:
    Doc.meanEigVec(partIndex,:) = mean(eigenvector2L);
    Doc.stdEigVec(partIndex,:) = std(eigenvector2L);
    Doc.Eigenvalue2L(partIndex,:) = eigenvalue2L;
  
    Cut_Edges.Part(partIndex,:) = currentPart;
    Cut_Edges.TotalEdges(partIndex,:) = numedges(graphy);
    
    Cut_Edges.C1_Edges(partIndex,:) = ...
        sum(AdjacencyMatrix(eig_posT.index,eig_posT.index),'all')/2;
    
    Cut_Edges.C2_Edges(partIndex,:) = ...
        sum(AdjacencyMatrix(eig_negT.index,eig_negT.index),'all')/2;
    
    Cut_Edges.CutEdges(partIndex,:) = ...
        Cut_Edges.TotalEdges(partIndex,:) ...
        - (Cut_Edges.C1_Edges(partIndex,:) ...
        + Cut_Edges.C2_Edges(partIndex,:));
    
    Cut_Edges.Portion(partIndex,:) = ...
        Cut_Edges.CutEdges(partIndex,:)/Cut_Edges.TotalEdges(partIndex,:);
    
    Cut_Edges.DensityGraph(partIndex,:) = ...
        numedges(graphy)/nchoosek(numnodes(graphy),2);
    
    NodesC1 = ...
        length(AdjacencyMatrix(eig_posT.index,eig_posT.index));
    
    NodesC2 = ...
        length(AdjacencyMatrix(eig_negT.index,eig_negT.index));
    
    Cut_Edges.DensityC1(partIndex,:) = ...
        Cut_Edges.C1_Edges(partIndex,:)/nchoosek(NodesC1,2);
    
    Cut_Edges.DensityC2(partIndex,:) = ...
        Cut_Edges.C2_Edges(partIndex,:)/nchoosek(NodesC2,2);
    
    Cut_Edges.AvgDensity(partIndex,:) = ...
        (Cut_Edges.DensityC1(partIndex,:)+Cut_Edges.DensityC2(partIndex,:))/2;
    
    Cut_Edges.CutDensity(partIndex,:) = ...
        Cut_Edges.CutEdges(partIndex,:)/(NodesC1*NodesC2);
    
%---------------------------- Plotting ------------------------------------
    if plotting_wanted == true
        
        
      % Plotting the second smallest Eigenvector (sorted)
        figure('Name',strcat('Part_',currentPart,'_Eig2'));
        plot(sort(eigenvector2L),'.-');
        if saving_wanted == true
            saveas(gcf,strcat(savepath,'2rdSmallestEigenvector_',...
                currentPart,'.png'),'png');
        end
        
      % Investigating the Adjacency Matrix:
      % Plotting the Adjacency Matrix based on the sorting distribution of  
      % the second smallest Eigenvector 
      % (Spy Matrix or Sparse Pattern Matrix)
      %%
%         [ignore, path] = sort(eigenvector2L);
%         figure('Name',strcat('Part_',currentPart,'_AdjacencySpy'));
%         sortedAdj = AdjacencyMatrix(path,path);
%         spy(sortedAdj);
%         
%       % Split into pos and neg part 
%         p_neg = path(ignore<=0);
%         p_pos = path(ignore>0);
%         
%         Adj_neg = sortedAdj;
%         Adj_neg(p_pos,p_pos) = 0;
%         Adj_pos = sortedAdj;
%         Adj_pos(p_neg,p_neg) = 0;
%         
%         spy(Adj_pos,'r',20);
%         hold on;
%         spy(Adj_neg,'g',20);
%         xlabel('Matrix Entries');
%         ylabel('Matrix Entries');
%         xticks([0 100 200]);
%         yticks([0 100 200]);
%         set(gca,'FontSize',40,'FontWeight','bold','Box','off');
%         rectangle('Position',[0 0 212 212],'LineWidth',1.5);
%         
%         cmap = [0.40 0.80 0.42   %green
%                 0.27 0.38 0.99]; %blue

            %%
%second smallest Eigenvector
        [ignore, path] = sort(eigenvector2L);
        figure('Name',strcat('Part_',currentPart,'_AdjacencySpy'));
        sortedAdj = AdjacencyMatrix(path,path);
        
        %Split into pos and neg part 
        p_neg = path(ignore<=0);
        p_pos = path(ignore>0);
        
        if length(p_neg) < length(p_pos)
            cut_index = length(p_neg);
        else
            cut_index = length(p_pos);
        end
        
        
        Adj_neg = AdjacencyMatrix;
        Adj_neg(p_pos,p_pos) = 0;
        Adj_neg = Adj_neg(path,path);
        Adj_pos = AdjacencyMatrix;
        Adj_pos(p_neg,p_neg) = 0;
        Adj_pos = Adj_pos(path,path);
        
        Adj_between = AdjacencyMatrix;
        Adj_between(p_neg,p_neg) = 0;
        Adj_between(p_pos,p_pos) = 0;
        Adj_between = Adj_between(path,path);
        
        spy(Adj_pos,'r',20);
        hold on;
        spy(Adj_neg,'g',20);
        hold on;
        spy(Adj_between, 'k', 20);
        xlabel('Matrix Entries');
        ylabel('Matrix Entries');
        xticks([0 100 200]);
        yticks([0 100 200]);
        set(gca,'FontSize',40,'FontWeight','bold','Box','off');
        rectangle('Position',[0 0 212 212],'LineWidth',1.5);
        
        hold on;
        x1 = [0 max(path)];
        y1 = [cut_index cut_index];
        line(x1,y1,'Color',[0.96,0.73,0.23],'LineStyle','-', 'LineWidth',7);
        
        hold on;
        x2 = [cut_index cut_index];
        y2 = [0 max(path)];
        line(x2,y2,'Color',[0.96,0.73,0.23],'LineStyle','-', 'LineWidth',7);

            
        if saving_wanted == true
            saveas(gcf,strcat(savepath,'Spy_AdjacencyMatrix_Part',...
                currentPart,'.png'),'png'); 
        end
        
      % Highlighting the graph partitions in the graph
        figure('Name',strcat('Part_',currentPart,'_Clusters'));
        plotty = plot(graphy,'MarkerSize',4,'LineWidth',1.5);
        highlight(plotty,index(1:length(eig_neg)),'NodeColor','r');
        highlight(plotty,index(length(eig_neg)+1:end),'NodeColor','g');
        if saving_wanted == true
            saveas(gcf,strcat(savepath,'Clusters_Part_',...
                currentPart,'.png'),'png');
        end
        
      % Plot the Eigenvalue Histogram and save the Eigenvalue Spectrum
        save([savepath 'Part_' currentPart '_EigenvalueSpectrumL,mat'],...
            'EigenvalueL');
        figure('Name', ...
            strcat('Part_',currentPart,'__2nd_Smallest_EigenvectorL'));
        histogram(eigenvector2L);
        xlabel('Eigenvector entry value'); ylabel('Count');
        if saving_wanted == true
            saveas(gcf,strcat(savepath,...
                'Part_',currentPart,...
                '_Histogram_2nd_Smallest_EigenvectorL.png'),'png');
        end

    end
    
%% Graph is not connected

%------------------- Step 2 - Graph Not Connected--------------------------

% Graph is not fully connected, the third smalles EV will be used (if >0)
    elseif EigenvalueL(3,3) > 1e-10
        
         disp(strcat(currentPart,' has a non-connected graph')) ;
         eigenvalue3L = EigenvalueL(3,3);
         eigenvector3L = EigenvectorL(:,3);

         AllEigValuesL(:,partIndex) = eigenvalue3L;

        [d,ind] = sort(diag(EigenvalueL));
        Vs = EigenvectorL(:,ind);
        control_square(partIndex,1) = sum(eigenvector3L);
        control_square(partIndex,2) = sum(eigenvector3L.^2);

            if isequal(EigenvectorL,Vs)  ...
                    && sum(eigenvector3L) ...
                    < 1e-10 ...
                    && sum(eigenvector3L.^2) ...
                    > 1-1e-10
                disp(strcat('Participant_',currentPart,' is valid'));
            else
                disp(strcat('Something went wrong, ',...
                    'the Eigenvector might be the wrong one - Part_',...
                    currentPart) );
            end
            
%------------------- Step 3 - Graph Not Connected -------------------------
      % Sort the eigenvector
        [eigenvector3_sort,index] = sort(eigenvector3L,'ascend');
      % Split it into positive and negative part
        eig_pos = eigenvector3_sort(eigenvector3_sort > 0);
        eig_neg = eigenvector3_sort(eigenvector3_sort < 0);
        save([savepath 'Part_' currentPart '_eig_pos.mat'],...
            'eig_pos');
        save([savepath 'Part_' currentPart '_eig_neg.mat'],...
            'eig_neg');
        
  % Documentation:
    Doc.meanEigVec(partIndex,:) = mean(eigenvector3L);
    Doc.stdEigVec(partIndex,:) = std(eigenvector3L);
%---------------------------- Plotting ------------------------------------
        if plotting_wanted == true
            figure('Name',strcat('Part_',currentPart,'_Eig3'));
            plot(sort(eigenvector3L),'.-');
            
            if saving_wanted == true
                saveas(gcf,strcat(savepath,...
                    '3rdSmallestEigenvector_',...
                    currentPart,'.png'),'png'); 
            end
            %Investigating the Adjacency Matrix:
            [ignore,path] = sort(eigenvector3L);
            figure('Name',strcat('Part_',currentPart,'_AdjacencySpy'));
            spy(AdjacencyMatrix(path,path));
            
            if saving_wanted == true
                saveas(gcf,strcat(savepath,...
                    'Spy_AdjacencyMatrix_Part',...
                    currentPart,'.png'),'png');
            end
            
           % Highlighting the graph partitions in the graph
            figure('Name',strcat('Part_',currentPart,'_Clusters'));
            plotty = plot(graphy,'MarkerSize',4,'LineWidth',1.5);
            highlight(plotty,index(1:length(eig_neg)),'NodeColor','r');
            highlight(plotty,index(length(eig_neg)+1:end),'NodeColor','g');
            if saving_wanted == true
                saveas(gcf,strcat(savepath,...
                    'Clusters_Part_',...
                    currentPart,'.png'),'png');
            end
            %Plot the Eigenvalue Histogram and save the Eigenvalue Spectrum
            if saving_wanted == true
                save([savepath 'Part_' currentPart...
                    '_EigenvalueSpectrumL,mat'],'EigenvalueL');
            end
            figure('Name', strcat('Part_',...
                currentPart,'_2nd_Smallest_Eigenvector'));
            histogram(eigenvector3L);
            xlabel('Eigenvector entry value'); ylabel('Count');
            if saving_wanted == true
                saveas(gcf,strcat(savepath,...
                    'Part_',currentPart,...
                    '_Histogram_3nd_Smallest_EigenvectorL.png'),'png');
            end
        end
    else 
        disp(strcat(currentPart,...
            'seems to be seperated into three graphs'));
        end 
        
%----------------------------- Saving -------------------------------------
       if saving_wanted == true    
            save([savepath 'Part_' currentPart '_eig_pos.mat'],...
                'eig_posT');
            save([savepath 'Part_' currentPart '_eig_neg.mat'],...
                'eig_negT');
       end


            if saving_wanted == true
                save([savepath 'CutEdges.mat'],'Cut_Edges');
                save([savepath 'SpectralDocumentation.mat'],'Doc');
            end
toc
end

% clearvars '-except' ...
%     Cut_Edges ...
%     Doc;
   
disp('Done');
