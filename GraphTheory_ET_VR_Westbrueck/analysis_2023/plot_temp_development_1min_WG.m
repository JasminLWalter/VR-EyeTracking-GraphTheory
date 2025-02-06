%% ------------------ plot_temp_development_1min_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
% Input:  
% gazes_data_V3.mat = a new data file containing all gazes

% Output:
% 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

savepathDensity = 'D:\Jasmin\SpaReControlData\analysis2023\tempDevelopment\1minSections\plotsDensity\';
savepathDiameter = 'D:\Jasmin\SpaReControlData\analysis2023\tempDevelopment\1minSections\plotsDiameter\';
savepathNrEdges = 'D:\Jasmin\SpaReControlData\analysis2023\tempDevelopment\1minSections\plotsNrEdges\';
savepathNrNodes = 'D:\Jasmin\SpaReControlData\analysis2023\tempDevelopment\1minSections\plotsNrNodes\';

cd 'D:\Jasmin\SpaReControlData\analysis2023\tempDevelopment\1minSections\';



% overviews
% overviewClusterDuration = load('overviewClusterDuration.mat');
overviewNrViewedBuildings = load('overviewNrViewedBuildings_1min');
overviewNrEdges = load('overviewNrEdges_1min');
overviewDensity = load('overviewDensity_1min');
overviewDiameter = load('overviewDiameter_1min');

% overviewClusterDuration = overviewClusterDuration.overviewClusterDuration;
overviewNrViewedBuildings = overviewNrViewedBuildings.overviewNrViewedBuildings;
overviewNrEdges = overviewNrEdges.overviewNrEdges;
overviewDensity = overviewDensity.overviewDensity;
overviewDiameter = overviewDiameter.overviewDiameter;

meanNrNodes = mean(overviewNrViewedBuildings);
meanNrEdges = mean(overviewNrEdges);
meanDensity = mean(overviewDensity);
meanDiameter = mean(overviewDiameter);

color = parula(26); 

for index = 1:26
    % nr of nodes/viewed buildings
    figure(1)
    
    plot1 = plot(overviewNrViewedBuildings(index,1:150),'Color',color(index,:));
    ylim([0,250])
    hold on
    plot1m = plot(meanNrNodes(1:150),'black');
    xlabel('time')
    ylabel('number of nodes')
    hold off
    
    saveas(gcf, strcat(savepathNrNodes, num2str(index), 'tempDevl_nrViewedBuildings.png'));
    
    % nr of edges
    figure(2)
    
    plot2 = plot(overviewNrEdges(index,1:150),'Color',color(index,:));
    ylim([0,1710])
    hold on
    plot2m = plot(meanNrEdges(1:150),'black');
    xlabel('time')
    ylabel('number of edges')
    hold off
    
    saveas(gcf, strcat(savepathNrEdges, num2str(index), 'tempDevl_nrEdges.png'));
    
    % density
    figure(3)
    
    plot3 = plot(overviewDensity(index,1:150),'Color',color(index,:));
    ylim([0,0.33])
    hold on
    plot3m = plot(meanDensity(1:150),'black');
    xlabel('time')
    ylabel('density')
    hold off
    
    saveas(gcf, strcat(savepathDensity, num2str(index), 'tempDevl_density.png'));
    
    % diameter
    figure(4)
    
    plot4 = plot(overviewDiameter(index,1:150),'Color',color(index,:));
    ylim([0,41])
    hold on
    plot1m = plot(meanDiameter(1:150),'black');
    xlabel('time')
    ylabel('diameter')
    hold off
    
    saveas(gcf, strcat(savepathDiameter, num2str(index), 'tempDevl_diameter.png'));
    
end


% nr of nodes/viewed buildings
figure(5)

plot5 = plot(overviewNrViewedBuildings(:,1:150)');
set(plot5,{'color'}, num2cell(parula(26),2));
ylim([0,250])
hold on
plot5m = plot(meanNrNodes(1:150),'black','LineWidth',1.2);
xlabel('time')
ylabel('number of nodes')
hold off
title('temporal development of the number of nodes');
saveas(gcf, 'tempDevl_nrViewedBuildings.png');

% nr of edges
figure(6)

plot6 = plot(overviewNrEdges(:,1:150)');
set(plot6,{'color'}, num2cell(parula(26),2));
ylim([0,1710])
hold on
plot6m = plot(meanNrEdges(1:150),'black','LineWidth',1.2);
xlabel('time')
ylabel('number of edges')
hold off
title('temporal development of number of edges');
saveas(gcf,'tempDevl_nrEdges.png');

% density
figure(7)

plot7 = plot(overviewDensity(:,1:150)');
set(plot7,{'color'}, num2cell(parula(26),2));
ylim([0,0.33])
hold on
plot7m = plot(meanDensity(1:150),'black','LineWidth',1.2);
xlabel('time')
ylabel('density')
hold off
title('temporal development of the graph density');
saveas(gcf, 'tempDevl_density.png');

% diameter
figure(8)

plot8 = plot(overviewDiameter(:,1:150)');
set(plot8,{'color'}, num2cell(parula(26),2));
ylim([0,41])
hold on
plot8m = plot(meanDiameter(1:150),'black','LineWidth',1.2);
xlabel('time')
ylabel('diameter')
hold off
title('temporal development of the graph diameter');
saveas(gcf,'tempDevl_diameter.png');





