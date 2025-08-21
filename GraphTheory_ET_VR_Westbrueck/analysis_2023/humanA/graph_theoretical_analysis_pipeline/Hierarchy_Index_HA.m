%% -------------------- Hierarchy_Index -----------------------

% -------------------- written by Lucas Essmann - 2020 --------------------
% ---------------------- lessmann@uni-osnabrueck.de -----------------------

%-----------------adjusted and extended by Jasmin L. Walter, 2022/23-------
%---------------------------jawalter@uos.de--------------------------------

%Hierarchy index 

% Requirements:
% undirected, unweighted graphs with Edges and Nodes Table 

%--------------------------------------------------------------------------
%Procedure: 
%Plotting all occuring degree values against their frequency
%Afterwards fitting a power law function (a*x^b). 
%The inverse of b is the Hierarchy Index, the higher the index, the
%stronger the hierarchy. Values below 1 are considered as no existing
%hierarchy.

clear all;

plotting_wanted = true; %if you want to plot, set to true
saving_wanted = true; %if you want to save, set to true


%% -------------------------- Initialisation ------------------------------
path = what;
path = path.path;

%savepaths
savepath = 'F:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\graph-theoretical-analysis\hierarchyIndex\';


% cd into graph folder location
cd 'F:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\pre-processing\velocity_based\step4_graphs\';


PartList = {365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7412 7842 8007 8469 8673 9472 9502 9586 9601};


totalgraphs = length(PartList);
% amount of graphs
HierarchyIndex = table();

    
%% ----------------------------- Main -------------------------------------
for partIndex = 1:totalgraphs
    currentPart = PartList{partIndex};
    
    %Create and reset the variables in the loop
    NodeDegree = [];
    UniqueDegree = [];
    NodeDegreeMed = [];
    UniqueDegreeMed = [];
    DegreeFrequency = [];
    DegreeFrequencyMed = [];

   %load graph
    graphy = load(strcat(num2str(currentPart),'_Graph_WB.mat'));
    graphy = graphy.graphy;


   %Calculate the degree
    NodeDegree = degree(graphy); 
    
%% ------------------------- Hierarchy Index ------------------------------
   %Delete 0 degrees (non connected nodes)
    NodeDegree(NodeDegree == 0) = [];
    UniqueDegree = unique(NodeDegree);
    UniqueDegree = sort(UniqueDegree);
   %do another fit only for the NDs > median(NodeDegree) 
    NodeDegreeMed = NodeDegree(NodeDegree>median(NodeDegree));
    UniqueDegreeMed = unique(NodeDegreeMed);
    UniqueDegreeMed = sort(UniqueDegreeMed);
    
    
   %Count how often each degree exists for all nodes (Degree Frequency)
    for ndfreq = 1:length(UniqueDegree)
        DegreeFrequency(ndfreq,:) = ...
            sum(NodeDegree(:) == UniqueDegree(ndfreq,1));
    end
    
   %Same for the meds
    for medfreq = 1:length(UniqueDegreeMed)
        DegreeFrequencyMed(medfreq,:) = ...
            sum(NodeDegreeMed(:) == UniqueDegreeMed(medfreq,1));
    end
    
   %log the axis
    UniqueDegreeMed_log = log(UniqueDegreeMed);
    DegreeFrequencyMed = log(DegreeFrequencyMed);
   %Fit a curve to the log data above the median with an exponential fit
   %(ax+b)
    ft2 = fittype(@(a,b,x) a*x+b);
    f2 = fit(UniqueDegreeMed_log,DegreeFrequencyMed,ft2);
    HierarchyIndex.Part(partIndex,:) = currentPart;
    HierarchyIndex.Slope(partIndex,:) = f2.a;
    
   %Fit a curve to the data with a Power Fit
    ft = fittype(@(a,b,x)a*x.^b);
    f = fit(UniqueDegree,DegreeFrequency,ft);
   %The hierarchy index is the inverse exponent of x
    HierarchyIndex.HierarchyIndex(partIndex,:) = -f.b;

    
%% -------------------------- Plotting ------------------------------------

    if plotting_wanted == true
    
        figgy = figure();
        scatter(log(UniqueDegree),...
            log(DegreeFrequency),...
            300,...
            [0.24,0.15,0.66],...
            'filled');
        hold on;
        plotty = fplot(@(x) f2.a*x+f2.b,...
            [min(UniqueDegreeMed_log),max(UniqueDegreeMed_log)],...
            'LineWidth',3,'Color',[0.96,0.73,0.23]);
        xlim([0 4]); ylim([0 4]);
        xticks([0,1,2,3,4]);
        yticks([0,1,2,3,4]) 
        rectangle('Position',[0 0 4 4],'LineWidth',1.5);


%         plotty2 = plot(f2,...
%             log(UniqueDegree),...
%             log(DegreeFrequency),...
%             [min(DegreeFrequencyMed),max(DegreeFrequencyMed)]);
%         xlabel('Degree'); ylabel('Frequency');
%         set(gca,'FontName','Helvetica','FontSize',40,'FontWeight','bold')
        
    if saving_wanted == true
         saveas(gcf,strcat(savepath,...
             'Med_Hierarchy_Fit_Part',...
             num2str(currentPart),'.png'),'png');
    end

         close(figgy);   
   
    end
     
end

histy = histogram(HierarchyIndex.Slope,7);
xlabel('Hierarchy Index'); 
ylabel('Frequency');
%     ylim([0 6.5]);
set(gca,'FontName','Helvetica')%,'FontSize',40)
saveas(gcf,strcat(savepath,...
             'Histogram_HierarchyIndex.png'),'png');
         
%% --------------------------- Saving -------------------------------------

if saving_wanted == true
    
    save([savepath 'HierarchyIndex_Table.mat'],'HierarchyIndex');
    disp('Saved HierarchyIndex_Table');
    
end

disp(['min hierarchy index = ', num2str(min(HierarchyIndex.Slope))])
disp(['max hierarchy index = ', num2str(max(HierarchyIndex.Slope))])
disp(['mean hierarchy index = ', num2str(mean(HierarchyIndex.Slope))])
disp(['std hierarchy index = ', num2str(std(HierarchyIndex.Slope))])


disp('Done');

% clearvars '-except' ...
%     HierarchyIndex;
