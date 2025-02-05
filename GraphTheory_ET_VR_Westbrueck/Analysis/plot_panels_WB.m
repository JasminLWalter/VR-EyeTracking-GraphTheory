%% ------------------ plot_panels_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:



%% start script
clear all;

%% adjust the following variables: 

% savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\graphPropertiesPlots\';

% cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

tes1 = load('E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\Overview_NodeDegree.mat');


% Load saved figures
c=hgload('E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\nodeDegree_imageScale.fig');
k=hgload('E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\correlation_coefficients_histogram.fig');

% Prepare subplots
% figure
% h(1)=subplot(1,2,1);
% h(2)=subplot(1,2,2);
% % Paste figures on the subplots
% copyobj(allchild(get(c,'CurrentAxes')),h(1));
% copyobj(allchild(get(k,'CurrentAxes')),h(2));
% % Add legends
% l(1)=legend(h(1),'LegendForFirstFigure')
% l(2)=legend(h(2),'LegendForSecondFigure')



figure(3)

t = tiledlayout(2,1);
nexttile
plot= get(c);

nexttile
plot = get(k);
















