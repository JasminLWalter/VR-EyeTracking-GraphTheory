%% ------------------- node_degree_centrality_analysis.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% Creates an image scale (pseudo 3D plot) color coding the node degree 
% centrality values for every house and every participant (Fig. 5c). Also 
% creates corresponding box plots with error bars: the individual mean node 
% degrees of all subjects (Fig. 5a) and the individual mean node degree of
% each house (Fig. 5e)

% Input: 
% Overview_NodeDegree.mat  =  table consisting of all node degree values
%                             for all participants
% Output: 
% nodeDegree_imageScale.png = pseudo 3D plot color coding the node degree 
%                             centrality values for every house and every 
%                             participant (Fig. 5c)
% nodeDegree_mean_std_allHouses.png = error bar plot of mean and std for 
%                                     all houses (Fig. 5e)
% nodeDegree_mean_std_allParticipants.png = error bar plot of mean and std
%                                           for each participant (Fig. 5b)


clear all;

%% adjust the following variables: savepath and current folder!-----------

savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\';

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\'

%--------------------------------------------------------------------------

overviewDegree= load('Overview_NodeDegree.mat');

overviewDegree= overviewDegree.overviewNodeDegree;
%% calculate mean over houses and sort table according to ascending mean ND of each house

meanNDofHouses = mean(overviewDegree{:,2:end},2);

% sort overview based on mean value of each house (sort columns)

overviewDegree.meanOfHouses = meanNDofHouses;

sortedbyH = sortrows(overviewDegree,'meanOfHouses');

%% sort overview based on mean value of each participant and arrange columns accordingly (ascending)
meanNDofParticipants = mean(sortedbyH{:,2:end-1});

columnN = sortedbyH.Properties.VariableNames;

partT = [array2table(meanNDofParticipants'),cell2table(columnN(2:end-1)','VariableNames',{'names'})];
sortPT = sortrows(partT,'Var1','descend');

sParts = sortPT{:,2};

sortedbyParts = sortedbyH;
for index = 1:length(sParts)  
    position = index+1;
    sortedbyParts = movevars(sortedbyParts,sParts(index),'before',position);
    
end

columnN2 = sortedbyParts.Properties.VariableNames;
sortedbyHP = [sortedbyParts; table({'meanOfPart'},'VariableNames',columnN2(1)), array2table(sortPT{:,1}','VariableNames',columnN2(2:end-1)),table(NaN,'VariableNames',columnN2(end))];


%% create image scale
transpose2plot= sortedbyHP{1:end-1,2:end-1}';

fig = figure(1);
imagescaly = imagesc(transpose2plot);
colorbar
title({'Image Scale Node Degree Centrality - all Participants','     '});
ax = gca;
ax.XTick = 0:10:245;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:245;
ax.XLabel.String = 'Houses';
ax.YLabel.String = 'Participants';

% print(gcf,strcat(savepath,'nodeDegree_imageScale.png'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'nodeDegree_imageScale.fig'));

% fig.PaperPositionMode = 'manual';
% orient(fig,'landscape')
% print(fig,strcat(savepath,'nodeDegree_imageScale_test.pdf'),'-dpdf','-fillpage')

%% create plots with error bars

% calculate and add std to overviews:

stdNDofHouses = std(sortedbyHP{1:end-1,2:end-1},0,2);
stdNDofParts = std(sortedbyHP{1:end-1,2:end-1});

sortedbyHP.stdOfHouses = [stdNDofHouses;NaN];
stdNDofParts = [stdNDofParts, NaN,NaN];

columnN3 = sortedbyHP.Properties.VariableNames;

sortedbyHP = [sortedbyHP;table({'stdOfParts'},'VariableNames',columnN3(1)),array2table(stdNDofParts,'VariableNames',columnN3(2:end))];

% create error bar plots

tbIndex = zeros([height(sortedbyHP),1]);

for index =  1:8
    
    taskB = strcat('TaskBuilding_', num2str(index));
    locTB = strcmp(sortedbyHP.houseNames,taskB);
    tbIndex = tbIndex | locTB;
end



% mean and std for each house
figure(2)

plotty2 = errorbar(sortedbyHP.meanOfHouses(1:end-2), sortedbyHP.stdOfHouses(1:end-2),'b','Linewidth',1);
xlabel('houses')
ylabel('node degree')
xlim([-1 246])
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
hold on

plotty2a = plot(sortedbyHP.meanOfHouses(1:end-2)','b','Linewidth',3);


hold off

% print(gcf,strcat(savepath,'nodeDegree_mean_std_allHouses.png'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'nodeDegree_mean_std_allHouses.fig'));

% mean and std for each participant

forPlotting = [array2table(sortedbyHP{end-1,2:end-2}'),array2table(sortedbyHP{end,2:end-2}','VariableNames',{'Var2'})];
forPlottingS = sortrows(forPlotting);

figure(3)
y = [1:26];
plotty3 = errorbar(forPlottingS{:,1},y, forPlotting{:,2},'horizontal','b','Linewidth',1);
ylim([0,27]);
xlabel('node degree')
ylabel('participants')
hold on
plotty3a = plot(forPlottingS{:,1},y,'b','Linewidth',3);

hold off

% print(gcf,strcat(savepath,'nodeDegree_mean_std_allParticipants.png'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'nodeDegree_mean_std_allParticipants.fig'));



 %saveas(gcf,strcat(savepath,'ImageScale_DegreeCentrality_allParticipants.png'),'png');
 %fig.PaperPositionMode = 'manual';
 %orient(fig,'landscape')
 %print(gcf,'ImageScale_DegreeCentrality_allParticipants.pdf','-dpdf','-fillpage')
 

 
figure(4) 

plotty4 = boxchart(sortedbyHP{1:end-2,2:end-2});

plotty4.JitterOutliers = 'on';
plotty4.MarkerStyle = '.';

hold on

plot(sortedbyHP{end-1,2:end-2}, '-*')

title('Node degree centrality of each participant averaged over buildings')
xlabel('participants');
ylabel('node degree')

% set(gca,'TickLabelInterpreter','none');
% set(gca,'XTickLabel',landmarkNames);

legend({'boxplot + median','mean'},'location','northeast')

saveas(gcf,strcat(savepath,'Boxplot_NDofParticipants_averagedOverBuildings'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Boxplot_NDofParticipants_averagedOverBuildings_600DPI.png'),'Resolution',600)


figure(5) 

plotty5 = boxchart(sortedbyHP{1:end-2,2:end-2}');
plotty5.JitterOutliers = 'on';
plotty5.MarkerStyle = '.';
% plotty5.BoxMedianLineColor = 'green';

hold on

plot(sortedbyHP{1:end-2,end-1}, '.')

title('Node degree centrality of each building averaged over participants')
xlabel('buildings');
ylabel('node degree')

% set(gca,'TickLabelInterpreter','none');
% set(gca,'XTickLabel',landmarkNames);

legend({'boxplot + median','mean'},'location','northwest')

saveas(gcf,strcat(savepath,'Boxplot_NDofBuildings_averagedOverParticipants'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Boxplot_NDofBuildings_averagedOverParticipants_600dpi.png'),'Resolution',600)

%% identify all 8 pointing to building task buildings

tbIndex = zeros([height(sortedbyHP),1]);

for index =  1:8
    
    taskB = strcat('TaskBuilding_', num2str(index));
    locTB = strcmp(sortedbyHP.houseNames,taskB);
    tbIndex = tbIndex | locTB;
end

sortedbyHP.IndexTaskBuildingsP2B = tbIndex;
typeBuilding = categorical(tbIndex(1:end-2,:),logical([1 0]),{'TaskBuilding','Building'});


figure(6)
x = [1:244];
for index = 1:244
    if (tbIndex(index) == 1)
        color = [0.4660 0.6740 0.1880];

    else
        color = [0.75 0.75 0.75];

    end
    
    plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);
 
    hold on
end

xlabel('houses')
ylabel('node degree')
xlim([-1 246])
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
% hold on

plotty2a = plot(sortedbyHP.meanOfHouses(1:end-2)','b','Linewidth',2);


hold off

saveas(gcf,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings'));
ax = gca;
exportgraphics(ax,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings_600dpi.png'),'Resolution',600)


%% --------------------------- combine imagescale and corr. into one panel
% 
% % load correlation coefficient
% 
% corr_array = load('CorrelationArray.mat');
% corr_array = corr_array.corr_array;
% 
% figure(10)
% panel1 = tiledlayout(1,2);
% nexttile
% 
% histogram(corr_array,10);
% xlabel('Correlation Coefficients'); 
% ylabel('Frequency');
% ax = gca;
% ax.XMinorTick = 'on';
% 
% nexttile
% imagescaly = imagesc(transpose2plot);
% colorbar
% title({'Image Scale Node Degree Centrality - all Participants','     '});
% ax = gca;
% ax.XTick = 0:10:245;
% ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:245;
% ax.XLabel.String = 'Houses';
% ax.YLabel.String = 'Participants';



