%% ----------------------- Rich Club Coefficient --------------------------

% -------------------- written by Lucas Essmann - 2020 --------------------
% ---------------------- lessmann@uni-osnabrueck.de -----------------------

% -----------------adjusted and extended by Jasmin L. Walter---------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Computes the rich-club coefficient for each participant's gaze graph, normalizes by
%          random graphs matched on nodes/edges and degree distribution (via KS selection), and
%          summarizes/visualizes which buildings frequently belong to the rich club.
%
% Usage:
% - Adjust: cd to the graphs folder; set savepath, imagepath, clistpath, nodeDegreePath, and PartList.
% - Optional flags: plotting_wanted (true/false), saving_wanted (true/false).
% - Run the script in MATLAB.
%
% Inputs:
% - Per participant graphs: <ParticipantID>_Graph_WB.mat (variable: graphy; undirected, unweighted)
% - Building list CSV: additional_Files/building_collider_list.csv (names and coordinates)
% - Landmarks list: list_gaze_graph_defined_landmarks.mat (from node-degree analysis)
% - Node-degree overview: Overview_NodeDegree.mat (used to set richClubThresh = mean + std of house means)
% - Map image (for plots): additional_Files/map_natural_white_flipped.png
%
% Outputs (to savepath):
% - Figures:
%   - MeanRichClub.png (rich-club curves per subject + mean)
%   - Number_of_buildings_included_with_increasing_node_degree.png
%   - Map_with_RCbuildings_sized_colored_with_Count.png (.png and 600dpi export)
%   - Map_with_RCbuildings_sized-colored_with_count_markedHighCountBuildings.png (.png and 600dpi)
%   - Map_with_RCbuildings_sized-colored_with_count_markedLandmarks.png (.png and 600dpi)
% - Data:
%   - RichClub_AllSubs.mat and .csv (per-subject RC vs. degree threshold)
%   - Mean_RichClub.mat (mean RC vs. degree threshold)
%   - richClubND15_NodeCountAll.mat/.csv (per-building count across subjects at threshold)
%   - richClubND15_highCountBuildings.mat/.csv (subset exceeding mean+2*std count)
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)


% Method description:
% The rich club coefficient is calculated with the following formula:
% RC(k) = 2E>k / N>k(N>k -1) 
% with k = Node Degree, 
% E>k = the number of edges between the nodes of
% degree larger than or equal to k,
% and N>k = the number of nodes with degree larger than or equal to k
% 
% But since the RichClubCoefficient is an abstract measure, the script
% creates a random graph based on the degree distribution of the original
% graph and calculates the RC of this random graph. Afterwards, it
% divides the RealCoefficient by the RandomCoefficient. Therefore, a value
% above 1 would indicate that high node degree nodes are connected to other
% high node degree nodes above chance level 

% most important variables:

% Figure 2/ MeanRichClub.png = The development of the rich club coefficient 
%                              with increasing node degree. The dot-lines 
%                              are the rich club coefficients of individual 
%                              participants, while the green line is the 
%                              mean across all participants


% RichClub_AllSubs.mat = overview of all rich club values as a function of 
%                        the threshold node degree for each participant.
%                        Note: that the columns correspond to the selection
%                        of the houses included in the rich club based on the
%                        node degree - so column 2 corresponds to the first 
%                        threshold 1 = all nodes of a degree 1 or larger are 
%                        considered. Consequently, column 3 corresponds to
%                        the threshold: all nodes of degree 2 and larger
%                        etc.

% Mean_RichClub.mat = overview of the mean rich club values as a function
%                     of the threshold node degree averaged over all
%                     participants. Here column 1 corresponds to the
%                     threshold of all nodes of a degree of 1 and larger
%                     and column 2 corresponds to the threshold of all
%                     nodes of a degree of 2 and larger etc.

% List_RichClub_Frequency_ofallHouses.mat = overview of all houses and the
%                                           frequency of the houses
%                                           appearing in a rich club across
%                                           participants



clear all;

%% ------------------- adjust the following variables: -------------------------------

plotting_wanted = true; % if you want to plot, set to true
saving_wanted = true; % if you want to save, set to true

path = what;
path = path.path;

% cd into graph folder location
cd 'F:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\graphs\';

savepath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\RichClub\';

imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location
nodeDegreePath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\';

%% -------------------------- Initialisation ------------------------------

 
% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
coordinateList = readtable(listname);

[uhouses,loc1,loc2] = unique(coordinateList.target_collider_name);

houseList = coordinateList(loc1,:);

% load landmark overview

landmarks = load(strcat(nodeDegreePath, 'list_gaze_graph_defined_landmarks'));
landmarks = landmarks.landmarks;

% define rich club threshold (min amount of node degree of nodes considered
% in the final calculation of the adjusted rich club coefficient)

overviewDegree= load(strcat(nodeDegreePath,'Overview_NodeDegree.mat'));

overviewDegree= overviewDegree.overviewNodeDegree;

meanNDofHouses = mean(overviewDegree{:,2:end},2);
grandMean = mean(meanNDofHouses);
grandStd = std(meanNDofHouses);

% mean + std, that defines the min amount of node degree values of nodes 
% considered for the final calculation of the adjusted rich club coefficient, 
richClubThresh = fix(grandMean + grandStd); 
disp(['rich club node degree threshold = ', num2str(richClubThresh)])


%graphfolder
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


totalgraphs = length(PartList);

%Rich Club Table
RichT = zeros(length(PartList),36);
NodeCountAll = zeros(height(houseList),length(PartList));

RC_Num = zeros(length(PartList),36);
%% ----------------------------Main Part-----------------------------------

for partIndex = 1:totalgraphs
    currentPart = PartList{partIndex};
  % load graph
    graphy = load(strcat(num2str(currentPart),'_Graph_WB.mat'));
    graphy = graphy.graphy;

    % Calculate the Adjacency Matrix 
    A = full(adjacency(graphy));
    % the NodeDegree
    ND = degree(graphy);
    
%% ------------------creating the random graph-----------------------------

% Firstly calculate the distribution (assume normal) of the degree data by
ND_Dist = fitdist(ND,'normal');
mu = ND_Dist.mu;
sigma = ND_Dist.sigma;
% Then create the probability distribution function according to the 
% Degrees

% Afterwards, create 1000 random graphs with the same amount of nodes and 
% edges and compare the Node Degree Distributions. 
n = height(graphy.Nodes);
E = numedges(graphy);
count = 1000;
Kolmo = [];

for random = 1:count
    adj = [];
    idx = [];
    matrix = [];
    Deg = [];
    h = [];


    adj = spalloc(n, n, E);
    idx = randperm(n * n, E+n);
    idx(ismember(idx, 1:n+1:n*n)) = [];
    idx = idx(1:E);
    adj(idx) = 1;
  % With at least one 1 per column
    adj = min( adj + adj.', 1);
    matrix = full(adj);
    Deg = sum(matrix)';

  % Create the random graph based on the random adjacency matrix
    rgraphy = graph(adj);

  % Now calculate the degree distribution
    Random_Dist = fitdist(Deg,'normal');
    mu_rnd = Random_Dist.mu;
    sigma_rnd = Random_Dist.sigma;

   % Comparing the two distributions. Here, I used the 
   % Kolmogornov-Smirnov-test for continuous datasets with H0 = the two 
   % datasets follow the same distribution. 
   % With h=1 the test rejects the H0, however, we are interested in the 
   % same distribution. This can never be proven though. It only shows that
   % the two sets are consistent with a single distribution.

    [h,p,stat] = kstest2(ND,Deg,'Alpha',0.01);
    Kolmo(random,1) = h;
    Kolmo(random,2) = p;
    Kolmo(random,3) = stat;

    graphs{random,:} = rgraphy;

end

graphs = graphs(~cellfun('isempty',graphs));

[Sorted, index] = sort(Kolmo(:,1),'ascend');
Sorted(:,2) = index;

Top10R = Sorted(1:10,2);


%% ---------------------RichClub Calculation-------------------------------

for Rgraphs = 1:10
          
    randomgraphy = graphs{Top10R(Rgraphs),:};
    
    RandomND = degree(randomgraphy);
    
    x = 1;
    y = 35;
    
    currentRich = [];
    for k = x:y
        
        
      % the number of nodes with higher or equal node degree than k
        ND_largerK_bool = ND>=k;
        ND_largerK = ND(ND_largerK_bool);
        RandomND_largerK_bool = RandomND>=k;
        RandomND_largerK = RandomND(RandomND_largerK_bool);
        
      % The number of nodes with higher node degree:
        N_largerK = length(ND_largerK);
        RandomN_largerK = length(RandomND_largerK);
        
      % the number of edges between those nodes
      % Firstly find out which nodes are larger
        [ND_largerK_sort, index] = sort(ND_largerK_bool,'descend');
        [RandomND_largerK_sort, random_index] = ...
            sort(RandomND_largerK_bool,'descend');
        
      % Then create a subgraph consisting of those nodes
        graphy_largerK = subgraph(graphy,index(1:length(ND_largerK)));
        randomgraphy_largerK =...
           subgraph(randomgraphy,random_index(1:length(RandomND_largerK)));
        
      % Number of edges
        E_largerK = numedges(graphy_largerK);
        E_RandomlargerK = numedges(randomgraphy_largerK);
        
      % Insert everything into the formula:
        RealRichClubCoeff = ...
            (2*E_largerK) / (N_largerK*(N_largerK-1));
        RandomRichClubCoeff = ...
            (2*E_RandomlargerK) / (RandomN_largerK*(RandomN_largerK-1));
        RichClubCoeff = RealRichClubCoeff / RandomRichClubCoeff;
        
        currentRich(1,k) = RichClubCoeff;
        
        current_ND_largerK(1,k) = length(ND_largerK);

    end
    RC_Sub(Rgraphs,:) = currentRich;
    
    
    
end
    RC_Sub(arrayfun(@isinf,RC_Sub)) = NaN;
    
       % Fill the table of subjects
         RichT(partIndex,1) = currentPart;
         RichT(partIndex,2:end) = nanmean(RC_Sub);
         
         RC_Num(partIndex,1) = currentPart;
         RC_Num(partIndex,2:end) = current_ND_largerK;

         
         
       % Are always the same houses in the repective rich club? 
         DegreeOver10 = ND>=richClubThresh;

         NodeCountSub = ...
             ismember(houseList.target_collider_name,graphy.Nodes.Name(DegreeOver10));
%          NodeCountSub = double(NodeCountSub);
         
%          NodeCountAll = NodeCountAll + NodeCountSub;
          NodeCountAll(:,partIndex) = NodeCountSub;
end

partList2 = cell([1,length(PartList)]);
for index = 1:length(PartList)
    num = PartList{index};
    partList2(index) = {strcat('Part_', num2str(num))};
end
richClubND15_NodeCountAll = array2table(NodeCountAll,'VariableNames',partList2);
richClubND15_NodeCountAll.SumOverParticipants = sum(NodeCountAll, 2);
richClubND15_NodeCountAll.BuildingNames = houseList.target_collider_name;


% Take the mean over all subjects
MeanRichClub = mean(RichT(:,2:end),"omitmissing");



% identify the buildings that occur in a rich club with at least 15 node
% degree more often than the threshold of mean + std node degree
% then calculate mean and std of this count variable and identify threshold
% for rich club buildings

    
meanCountAll = mean(richClubND15_NodeCountAll.SumOverParticipants);
stdCountAll = std(richClubND15_NodeCountAll.SumOverParticipants);

thresholdHighRCCount = meanCountAll + (2*stdCountAll);

disp(strcat(num2str(meanCountAll), ' = mean of count how often the buildings appear in the rich club with at least 15 node degree centrality'))

disp(strcat(num2str(stdCountAll), ' = std of count how often the buildings appear in the rich club with at least 15 node degree centrality'))

disp(strcat(num2str(max(richClubND15_NodeCountAll.SumOverParticipants)), ' = max count how often the buildings appear in the rich club with at least 25 node degree centrality'))

disp(strcat(num2str(thresholdHighRCCount), ' = threshold for rich club buildings')) 

highCountIndex = richClubND15_NodeCountAll.SumOverParticipants > thresholdHighRCCount;

richClubND15_highCountBuildings = richClubND15_NodeCountAll(highCountIndex,:);

% check whether landmarks are present in high count rich club buildings 

allLandmarksInRichClub = ismember(landmarks.houseNames, richClubND15_highCountBuildings.BuildingNames);

disp(strcat('number of all rich club buildings = ' , num2str(length(richClubND15_highCountBuildings.BuildingNames))))

disp(strcat('number of landmark buildings in rich club buildings = ' , num2str(sum(allLandmarksInRichClub))))

disp(strcat('number all landmarks = ',num2str(height(landmarks))))


    
%% --------------------------- Plotting -----------------------------------

if plotting_wanted == true

%     figure('Position',[0,0,900,900]);
    figure(1)
    plot(RichT(:,2:end)','LineStyle',':','Linewidth',1);
    hold on;
    plot(MeanRichClub(1,1:richClubThresh),'LineWidth',4);
    xlabel('Node Degree')
    ylabel('Mean Rich Club (Real/Random)');
    xlim([1,richClubThresh]);
    xticks([1:2:richClubThresh]);
    ylim([0.7,2.5]);
    set(gca,'FontName','Helvetica','FontWeight','bold')
    % xline(richClubThresh,'-r') % for visualizations sometimes usesful
%     set(gca,'FontName','Helvetica','FontSize',40,'FontWeight','bold')

    pbaspect([1 1 1]);

    if saving_wanted == true
        saveas(gcf,strcat(savepath,'MeanRichClub.png'),'png');
    end
    hold off
    
    
    figure(2)
    
    plotty2 = plot(RC_Num(:,2:end)','Linewidth',1);
    
    title('Number of buildings included with increasing node degree')
    xlabel('Node degree')
    ylabel('Number of nodes');
    
    xline(richClubThresh,'-r')

    
    if saving_wanted == true
        saveas(gcf,strcat(savepath,'Number_of_buildings_included_with_increasing_node_degree.png'),'png');
    end

    
    maxNum15 = max(RC_Num(:,richClubThresh)');
    minNum15 = min(RC_Num(:,richClubThresh)');
    
    disp(strcat('Max number of included building at rich club threshold ND = ', num2str(maxNum15)));
    disp(strcat('Min number of included building at rich club threshold ND = ' , num2str(minNum15)));
   
    
    
    
% map plot of rich club count1
    map = imread (strcat(imagepath,'map_natural_white_flipped.png'));
    
    figure(3)
    imshow(map);
    alpha(0.2)
    hold on;

    markerInfo = richClubND15_NodeCountAll.SumOverParticipants;

    % plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,meanNDofHouses*2 +16,meanNDofHouses,'filled');
    plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,markerInfo*1.2+14,markerInfo,'filled');

    colorbar
    set(gca,'xdir','normal','ydir','normal')

    climits = caxis;
    title({'Buildings sized and colored according to how often they appear', 'in the rich club with at least 15 node degree centrality nodes'})

    hold off
    
    if saving_wanted == true
        saveas(gcf,strcat(savepath,'Map_with_RCbuildings_sized_colored_with_Count.png'),'png');
        ax = gca;
        exportgraphics(ax,strcat(savepath,'Map_with_RCbuildings_sized-colored_with_count_600dpi.png'),'Resolution',600)

    end

    
    % plot the same plots, but mark the interesting buildings
    % mark buildings with rc count exceeding the threshold of mean + std

    figure(4)
    imshow(map);
    alpha(0.2)
    hold on;

    markerInfo = richClubND15_NodeCountAll.SumOverParticipants;

    % plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,meanNDofHouses*2 +16,meanNDofHouses,'filled');
    plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,markerInfo*1.2+13,markerInfo,'filled');
    plotty2 = scatter(houseList.transformed_collidercenter_x(highCountIndex), houseList.transformed_collidercenter_y(highCountIndex),markerInfo(highCountIndex)*1.2+15,'red');

    colorbar
    set(gca,'xdir','normal','ydir','normal')

    climits = caxis;
    title({'Buildings sized and colored according to how often they appear', 'in the rich club with at least 15 node degree centrality nodes','high count buildings circled red'})

    hold off

   if saving_wanted == true
        saveas(gcf,strcat(savepath,'Map_with_RCbuildings_sized-colored_with_count_markedHighCountBuildings.png'),'png');
        ax = gca;
        exportgraphics(ax,strcat(savepath,'Map_with_RCbuildings_sized-colored_with_count_markedHighCountBuildings_600dpi.png'),'Resolution',600)

   end

    % mark the gaze-graph-defined landmarks
    landmarkIndex = ismember(houseList.target_collider_name,landmarks.houseNames);     

    figure(5)
    imshow(map);
    alpha(0.2)
    hold on;

    markerInfo = richClubND15_NodeCountAll.SumOverParticipants;

    % plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,meanNDofHouses*2 +16,meanNDofHouses,'filled');
    plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,markerInfo*1.2+13,markerInfo,'filled');
    plotty2 = scatter(houseList.transformed_collidercenter_x(landmarkIndex), houseList.transformed_collidercenter_y(landmarkIndex),markerInfo(landmarkIndex)*1.2+15,'red');

    colorbar
    set(gca,'xdir','normal','ydir','normal')

    climits = caxis;
    title({'Buildings sized and colored according to how often they appear', 'in the rich club with at least 15 node degree centrality nodes', 'landmarks circled red'})

    hold off
    
   if saving_wanted == true
        saveas(gcf,strcat(savepath,'Map_with_RCbuildings_sized-colored_with_count_markedLandmarks.png'),'png');
        ax = gca;
        exportgraphics(ax,strcat(savepath,'Map_with_RCbuildings_sized-colored_with_count_markedLandmarks_600dpi.png'),'Resolution',600)

    end
end 

%% ---------------------------- Saving ------------------------------------

if saving_wanted == true
    
    save([savepath 'RichClub_AllSubs.mat'],'RichT');
    writetable(array2table(RichT), [savepath, 'RichClub_AllSubs.csv']);
    
    save([savepath 'Mean_RichClub.mat'],'MeanRichClub');
    
    save([savepath 'richClubND15_NodeCountAll'],'richClubND15_NodeCountAll');
    writetable(richClubND15_NodeCountAll, [savepath, 'richClubND15_NodeCountAll.csv']);
    
    save([savepath 'richClubND15_highCountBuildings'],'richClubND15_highCountBuildings');  
    writetable(richClubND15_highCountBuildings, [savepath, 'richClubND15_highCountBuildings.csv']);

end


disp('Done');
