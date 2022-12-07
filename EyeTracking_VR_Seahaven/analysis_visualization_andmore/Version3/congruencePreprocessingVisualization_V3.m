%% ------------------ congruencePreprocessingAnalysis-------------------------------------
% script written by Jasmin L. Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing7,9thresholds\analysisResults\';


loadpath7 = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing7,9thresholds\7threshold\graphs7\';
loadpath8 = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\graphs\';
loadpath9 = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing7,9thresholds\9threshold\graphs9\';


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

Number = length(PartList);


overviewAnalysis= table('size',[Number,19],...
    'VariableTypes',{'string','double','double','double',...
                     'double','double','double',...
                     'double','double','double',...
                     'double','double','double',...
                     'double','double','double',...
                     'double','double','double'},...
    'VariableNames',{'Participant','Nodes7','Nodes8','Nodes9',...
                      'NodesDiff78', 'NodesDiff98', 'NodesDiff79',...
                      'Edges7','Edges8','Edges9',...
                      'EdgesDiff78', 'EdgesDiff98', 'EdgesDiff79',...
                      'allNodesNr78','hammingDist78','percentage78',...
                      'allNodesNr98','hammingDist98','percentage98'});
                  
overviewAdjancyMatrizes = struct;



overviewTest = table('size',[2,4],...
    'VariableTypes',{'string','double','double','double'},...
    'VariableNames',{'Participant','AdjDiff78','AdjDiff98','AdjDiff79'});
testindex = 0;
for partindex = 1:Number
    currentPart = cell2mat(PartList(partindex));
    overviewAnalysis.Participant(partindex) = PartList(partindex);
    overviewAnalysis2.Participant(partindex) = PartList(partindex);
        
    %% load data
    graphy7 = load(strcat(loadpath7, num2str(currentPart),'_Graph_V3.mat'));
    graphy7 = graphy7.graphy;

    graphy8 = load(strcat(loadpath8, num2str(currentPart),'_Graph_V3.mat'));
    graphy8 = graphy8.graphy;

    graphy9 = load(strcat(loadpath9, num2str(currentPart),'_Graph_V3.mat'));
    graphy9 = graphy9.graphy;
    %% Nodes analysis
        
    % save number of nodes in overview
    overviewAnalysis.Nodes7(partindex) = height(graphy7.Nodes);
    overviewAnalysis.Nodes8(partindex) = height(graphy8.Nodes);
    overviewAnalysis.Nodes9(partindex) = height(graphy9.Nodes);
    
    overviewAnalysis2.Nodes7(partindex) = height(graphy7.Nodes);
    overviewAnalysis2.Nodes8(partindex) = height(graphy8.Nodes);
    overviewAnalysis2.Nodes9(partindex) = height(graphy9.Nodes);

    % check for differences in the node table
    ndiff1 = setdiff(graphy7.Nodes, graphy8.Nodes);
    ndiff2 = setdiff(graphy8.Nodes, graphy7.Nodes);
    nTotal7 = height(ndiff1)+height(ndiff2);

    ndiff3 = setdiff(graphy9.Nodes, graphy8.Nodes);
    ndiff4 = setdiff(graphy8.Nodes, graphy9.Nodes);
    nTotal8 = height(ndiff3)+height(ndiff4);

    ndiff5 = setdiff(graphy7.Nodes, graphy9.Nodes);
    ndiff6 = setdiff(graphy9.Nodes, graphy7.Nodes);
    nTotal79 = height(ndiff5)+height(ndiff6);

    overviewAnalysis.NodesDiff78(partindex) = nTotal7;
    overviewAnalysis.NodesDiff98(partindex) = nTotal8;
    overviewAnalysis.NodesDiff79(partindex) = nTotal79;

    %% Edges analysis
    edges7 = cell2table(graphy7.Edges.EndNodes);
    edges8 = cell2table(graphy8.Edges.EndNodes);
    edges9 = cell2table(graphy9.Edges.EndNodes);

    diff1 = setdiff(edges7, edges8);
    diff2 = setdiff(edges8, edges7);

    diff3 = setdiff(edges9, edges8);
    diff4 = setdiff(edges8, edges9);

    totaldiff7 = height(diff1) + height(diff2);
    totaldiff9 = height(diff3) + height(diff4);

    totaldiff79 = height(setdiff(edges7, edges9)) + height(setdiff(edges9, edges7));

    overviewAnalysis.Edges7(partindex) = height(edges7);
    overviewAnalysis.Edges8(partindex) = height(edges8);
    overviewAnalysis.Edges9(partindex) = height(edges9);

    overviewAnalysis.EdgesDiff78(partindex) = totaldiff7;
    overviewAnalysis.EdgesDiff98(partindex) = totaldiff9;
    overviewAnalysis.EdgesDiff79(partindex) = totaldiff79;
        
    %% check alternative computing for particpants 28,43 as they have 
    %  no differences in seen nodes    
        
    
    if(currentPart == 28 | currentPart == 43)
        testindex = testindex+1;
        adj7 = full(adjacency(graphy7));
        adj8 = full(adjacency(graphy8));
        adj9 = full(adjacency(graphy9));
        
        diff78 = adj7 == adj8;
        zeros78 = diff78 == 0;
        sum78 = sum(zeros78,'all');
        
        diff98 = adj9 == adj8;
        zeros98 = diff98 == 0;
        sum98 = sum(zeros98,'all');
        
        diff79 = adj7 == adj9;
        zeros79 = diff79 == 0;
        sum79 = sum(zeros79,'all');
        
        overviewTest.Participant(testindex) = PartList(partindex);
        overviewTest.AdjDiff78(testindex) = sum78/2;
        overviewTest.AdjDiff98(testindex) = sum98/2;
        overviewTest.AdjDiff79(testindex) = sum79/2;
        
    end
    
    %% visualization 78 difference
    allNodes78 = union(graphy7.Nodes,graphy8.Nodes);
    allNodesNr78 = height(allNodes78);
    allNodes78.Number = [1:1:allNodesNr78]';
    
    overviewAnalysis.allNodesNr78(partindex) = allNodesNr78;
    
    % visualize adj 7 matrix
    adjM7 = zeros(allNodesNr78);
    
    for index7=1:height(edges7)
        node1 = edges7{index7,1};
        node2 = edges7{index7,2};
        
        find1 = ismember(allNodes78.Name,node1);
        find2 = ismember(allNodes78.Name, node2);
        
        i1 = allNodes78{find1,2};
        i2 = allNodes78{find2,2};
        
        adjM7(i1,i2) = 1;
        adjM7(i2,i1) = 1;
        
    end
%     figure(1)
%     
%     plotty7 = imagesc(adjM7);
%     title('adjacency matrix k = 7 (78 Diff)');
    
    % visualize adj8 matrix
       
    adjM8 = zeros(allNodesNr78);
    
    for index8=1:height(edges8)
        node1 = edges8{index8,1};
        node2 = edges8{index8,2};
        
        find1 = ismember(allNodes78.Name,node1);
        find2 = ismember(allNodes78.Name, node2);
        
        i1 = allNodes78{find1,2};
        i2 = allNodes78{find2,2};
        
        adjM8(i1,i2) = 1;
        adjM8(i2,i1) = 1;
        
    end
%     figure(2)
%     
%     plotty8 = imagesc(adjM8);
%     title('adjacency matrix k = 8 (78 Diff)');
%     
%     figure(3)
%     plotty78 = imagesc(adjM7+adjM8);
%     title('sum of adjacency matrizes k=7 and k=8)');
    
%% compare 78 matrizes and calculate hamming distance
    hammingDist78 = 0;
    for i = 1: allNodesNr78
       for j = 1:allNodesNr78
          if not(adjM7(i,j) == adjM8(i,j))
              hammingDist78 = hammingDist78 +1;
              
          end
       end
        
    end
    overviewAnalysis.hammingDist78(partindex) = hammingDist78/2;
    % (n(n-1)/2 is the amount of possible edges
    overviewAnalysis.percentage78(partindex) = (hammingDist78/2) /((allNodesNr78 * (allNodesNr78-1))/2);
    
    %% visualization 98 difference
    allNodes98 = union(graphy9.Nodes,graphy8.Nodes);
    allNodesNr98 = height(allNodes98);
    allNodes98.Number = [1:1:allNodesNr98]';
    
    overviewAnalysis.allNodesNr98(partindex) = allNodesNr98;
    
    % visualize adj 9 matrix
    adjM9 = zeros(allNodesNr98);
    
    for index9=1:height(edges9)
        node1 = edges9{index9,1};
        node2 = edges9{index9,2};
        
        find1 = ismember(allNodes98.Name,node1);
        find2 = ismember(allNodes98.Name, node2);
        
        i1 = allNodes98{find1,2};
        i2 = allNodes98{find2,2};
        
        adjM9(i1,i2) = 1;
        adjM9(i2,i1) = 1;
        
    end
%     figure(4)
%     
%     plotty9 = imagesc(adjM9);
%     title('adjacency matrix k = 9 (98 Diff)');
%     % visualize adj8 matrix
       
    adjM8 = zeros(allNodesNr98);
    
    for index8=1:height(edges8)
        node1 = edges8{index8,1};
        node2 = edges8{index8,2};
        
        find1 = ismember(allNodes98.Name,node1);
        find2 = ismember(allNodes98.Name, node2);
        
        i1 = allNodes98{find1,2};
        i2 = allNodes98{find2,2};
        
        adjM8(i1,i2) = 1;
        adjM8(i2,i1) = 1;
        
    end
%     figure(5)
%     
%     plotty8 = imagesc(adjM8);
%     title('adjacency matrix k = 8 (98 Diff)');
%    
%     figure(6)
%     plotty98 = imagesc(adjM9+adjM8);
%     title('sum of adjacency matrizes k=9 and k=8)');
    
    %% calculate hamming distance 89 difference
    
        hammingDist98 = 0;
    for i = 1: allNodesNr98
       for j = 1:allNodesNr98
          if not(adjM9(i,j) == adjM8(i,j))
              hammingDist98 = hammingDist98 +1;
              
          end
       end
        
    end
    overviewAnalysis.hammingDist98(partindex) = hammingDist98/2;
    overviewAnalysis.percentage98(partindex) = (hammingDist98/2) /((allNodesNr98 * (allNodesNr98-1))/2);
%     %% visualization 7-8-9 differences
%     allNodes789 = union(allNodes78, allNodes98);
%     allNodesNr789 = height(allNodes789);
%     allNodes789.Number = [1:1:allNodesNr789]';
%     
%     % visualize k=7 matrix
%     adjM7 = zeros(allNodesNr789);
%     
%     for index7=1:height(edges7)
%         node1 = edges7{index7,1};
%         node2 = edges7{index7,2};
%         
%         find1 = ismember(allNodes789.Name,node1);
%         find2 = ismember(allNodes789.Name, node2);
%         
%         i1 = allNodes789{find1,2};
%         i2 = allNodes789{find2,2};
%         
%         adjM7(i1,i2) = 1;
%         adjM7(i2,i1) = 1;
%         
%     end
%     figure(7)
%     
%     plotty7 = imagesc(adjM7);
%     title('adjacency matrix k = 7 (789 Diff)');
%     
%     
%     % visualize adj8 matrix
%        
%     adjM8 = zeros(allNodesNr789);
%     
%     for index8=1:height(edges8)
%         node1 = edges8{index8,1};
%         node2 = edges8{index8,2};
%         
%         find1 = ismember(allNodes789.Name,node1);
%         find2 = ismember(allNodes789.Name, node2);
%         
%         i1 = allNodes789{find1,2};
%         i2 = allNodes789{find2,2};
%         
%         adjM8(i1,i2) = 1;
%         adjM8(i2,i1) = 1;
%         
%     end
%     figure(8)
%     
%     plotty8 = imagesc(adjM8);
%     title('adjacency matrix k = 8 (789 Diff)');
%     
%     % visualize adj 9 matrix
%     adjM9 = zeros(allNodesNr789);
%     
%     for index9=1:height(edges9)
%         node1 = edges9{index9,1};
%         node2 = edges9{index9,2};
%         
%         find1 = ismember(allNodes789.Name,node1);
%         find2 = ismember(allNodes789.Name, node2);
%         
%         i1 = allNodes789{find1,2};
%         i2 = allNodes789{find2,2};
%         
%         adjM9(i1,i2) = 1;
%         adjM9(i2,i1) = 1;
%         
%     end
%     figure(9)
%     
%     plotty9 = imagesc(adjM9);
%     title('adjacency matrix k = 9 (789 Diff)');
%    
%     %visualize all k=7,8,9 together
%     adjM789 = adjM7+adjM8+adjM9;
%     figure(10)
%     plotty789 = imagesc(adjM789);
%     title('sum of adjacency matrizes k=7 and k=8 and k=9)');
%     colormap(hot)
%         
end

meanRow = mean(overviewAnalysis{:,2:end});
stdRow = std(overviewAnalysis{:,2:end});

helper = [table({'Mean'}),array2table(meanRow)];
helper.Properties.VariableNames = overviewAnalysis.Properties.VariableNames;

helper2 = [table({'Std'}),array2table(stdRow)];
helper2.Properties.VariableNames = overviewAnalysis.Properties.VariableNames;
overviewAnalysis = [overviewAnalysis; helper;helper2];

%% save the overview

save([savepath 'overviewAnalysisPreprocessing'],'overviewAnalysis');
writetable(overviewAnalysis,[savepath 'overviewAnalysisPreprocessing.csv'],'Delimiter',',');


disp('done');