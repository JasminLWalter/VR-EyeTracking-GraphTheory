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


overviewAnalysis= table('size',[Number,13],...
    'VariableTypes',{'string','double','double','double',...
                     'double','double','double',...
                     'double','double','double',...
                     'double','double','double'},...
    'VariableNames',{'Participant','Nodes7','Nodes8','Nodes9',...
                      'NodesDiff78', 'NodesDiff98', 'NodesDiff79',...
                      'Edges7','Edges8','Edges9',...
                      'EdgesDiff78', 'EdgesDiff98', 'EdgesDiff79'});
                  
overviewAnalysis2= table('size',[Number,13],...
    'VariableTypes',{'string','double','double','double',...
                     'double','double','double',...
                     'double','double','double',...
                     'double','double','double'},...
    'VariableNames',{'Participant','Nodes7','Nodes8','Nodes9',...
                      'NodesDiff78', 'NodesDiff98', 'NodesDiff79',...
                      'Edges7','Edges8','Edges9',...
                      'EdgesDiff78', 'EdgesDiff98', 'EdgesDiff79'});



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
    
    %% double check calculations with an additional method
    
    overviewAnalysis2.Edges7(partindex) = height(edges7);
    overviewAnalysis2.Edges8(partindex) = height(edges8);
    overviewAnalysis2.Edges9(partindex) = height(edges9);
    
  
    
    % differences nodes 78
    diff78_1=0;
    diff78_2=0;
    for index78_1 = 1:height(edges7)
        edge1 = edges7(index78_1,1);
        edge2 = edges7(index78_1,2);
        
        member1 = ismember(edges8,[edge1,edge2],'rows');
        member2 = ismember(edges8,[edge2,edge1],'rows');
        
        if(sum(member1) + sum(member2)==0)
            diff78_1 = diff78_1+1;
        end
    end
    
    for index78_2 = 1:height(edges8)
        edge1 = edges8(index78_2,1);
        edge2 = edges8(index78_2,2);
        
        member1 = ismember(edges7,[edge1,edge2],'rows');
        member2 = ismember(edges7,[edge2,edge1],'rows');
        
        if(sum(member1) + sum(member2)==0)
            diff78_2 = diff78_2+1;
        end
    end
    
    diff78_total = diff78_1 + diff78_2;
    
    overviewAnalysis2.EdgesDiff78(partindex) = diff78_total;
    
    % differences nodes 89
    diff98_1=0;
    diff98_2=0;
    for index98_1 = 1:height(edges9)
        edge1 = edges9(index98_1,1);
        edge2 = edges9(index98_1,2);
        
        member1 = ismember(edges8,[edge1,edge2],'rows');
        member2 = ismember(edges8,[edge2,edge1],'rows');
        
        if(sum(member1) + sum(member2)==0)
            diff98_1 = diff98_1+1;
        end
    end
    
    for index98_2 = 1:height(edges8)
        edge1 = edges8(index98_2,1);
        edge2 = edges8(index98_2,2);
        
        member1 = ismember(edges9,[edge1,edge2],'rows');
        member2 = ismember(edges9,[edge2,edge1],'rows');
        
        if(sum(member1) + sum(member2)==0)
            diff98_2 = diff98_2+1;
        end
    end
    
    diff98_total = diff98_1 + diff98_2;
        
    overviewAnalysis2.EdgesDiff98(partindex) = diff98_total;
    %overviewAnalysis.EdgesDiff79(partindex) = totaldiff79;
    
        
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