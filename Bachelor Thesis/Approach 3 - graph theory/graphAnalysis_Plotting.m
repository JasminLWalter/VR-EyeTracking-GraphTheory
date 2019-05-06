%%-----------------------graph Analysis Plotting-------------------------
% plots overview of node degrees created in scr9ßt graph analysis degree

clear all;
savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\'

% load overview node degree
overviewNodeDegree= load('Overview_NodeDegree.mat');
overviewNodeDegree= overviewNodeDegree.overviewNodeDegree;


%% boxplot for houses over degrees

matOverview= table2array(overviewNodeDegree(:,2:end))';

% plot boxplot 
name1= 'Boxplot distribution of node degrees centrality over all Participants';
figure('Name',name1,'IntegerHandle', 'off');
plot1= boxplot(matOverview);
%plot1= boxplot(matOverview(:,1:107),'Labels',houses(1,1:107));
title(name1);
ax = gca;
ax.XLabel.String = 'Nodes / Houses';
ax.YLabel.String = 'Number Degrees';
% save it
%saveas(gcf,strcat(savepath,name1,'.jpg'),'jpg');


% plot boxplot style compact
name2= 'Boxplot-distribution of degrees - style compact';
figure('Name',name1,'IntegerHandle', 'off');
plot2= boxplot(matOverview,'PlotStyle','compact');
%plot1= boxplot(matOverview(:,1:107),'Labels',houses(1,1:107));
title(name2);
ax = gca;
ax.XLabel.String = 'Nodes / Houses';
ax.YLabel.String = 'Degrees';

% save it
%saveas(gcf,strcat(savepath,name2,'.jpg'),'jpg');

% %% bar graph of degree distribution
% 
% catHouse = categorical(overviewNodeDegree{:,1})';
% for n= 2:width(overviewNodeDegree)
%   
%     figure(3)
%     ploty= bar(catHouse,overviewNodeDegree{:,n});
%     ploty.FaceColor = rand(1,3);
%     title('bar plot of degrees over participants');
%     ax = gca;
%     ax.XLabel.String = 'Nodes / Houses';
%     ax.YLabel.String = 'Degrees';
%     hold on
% 
% end

%saveas(gcf,strcat(savepath,'Bar-Plot.jpg'),'jpg');

%% add min, max, sum of houses to overview
overviewNodeDegree.MinHouses = min(overviewNodeDegree{:,2:end},[],2);
overviewNodeDegree.MaxHouses = max(overviewNodeDegree{:,2:end},[],2);
overviewNodeDegree.MeanHouses= mean(overviewNodeDegree{:,2:end},2);
overviewNodeDegree.SumHouses = sum(overviewNodeDegree{:,2:end},2);

%% add min max sum of participants to overview
helper = overviewNodeDegree{:,2:end};
minrow = min(helper);
maxrow = max(helper);
meanrow = mean(helper);
sumrow = sum(helper);

varnames2= overviewNodeDegree.Properties.VariableNames(2:end);
extra = cell2table({'Extra'},'VariableNames',{'Houses'});
minrowT = array2table(minrow,'VariableNames',varnames2);
maxrowT= array2table(maxrow,'VariableNames',varnames2);
meanrowT = array2table(meanrow,'VariableNames',varnames2);
sumrowT = array2table(sumrow,'VariableNames',varnames2);
extratable = [extra,minrowT;extra,maxrowT;extra,meanrowT;extra,sumrowT];

varnames= overviewNodeDegree.Properties.VariableNames;

extratable.Properties.VariableNames = varnames;

overivewNodeDegree = [overviewNodeDegree;extratable];



% 
% % add total degree of people
% totalDegree= sum(overviewNodeDegree{1:213,2:end});
% 
% %overviewNodeDegree=[overviewNodeDegree;[cellstr('totalDegree'),totalDegree]];
% 
% %% top 10 with most degrees
% 
% sortedOverview= sortrows(overviewNodeDegree,width(overviewNodeDegree));
% sortbar = bar(sortedOverview.Sum);
% 
% most30= tail(sortedOverview,30);
% 
% house8= array2table(totalDegree);
% house8=[cellstr('totalDegree'), house8];
% house8.Properties.VariableNames= overviewNodeDegree.Properties.VariableNames;
% 
% house8(2,:)=overviewNodeDegree(8,:);
% 
% house8(3,1)= cellstr('percentage');
% %house8= [house8;array2table(zeros(1,width(house8)))];
% 
% for k=2:width(house8)
%     
%     house8{3,k}= (house8{2,k}/house8{1,k})*100;
%     
% end
% 
% 
