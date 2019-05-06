%------------------------DistanceStatisticsAverage--------------------------------
% written by Jasmin walter

% plots distance statistics on average across all participants
% uses totalNum.mat file 
% can only run after running analysis_ViewedHouses_JasminsVersion

clear all;

cd 'D:\BA Backup\Data_after_Script\approach1-distance\analysisViewedHouses\';
savepath = 'D:\BA Backup\Data_after_Script\approach1-distance\DistanceStatistics\average\';
filename = 'totalNum12.06.testi.mat';



    data = load(filename);
    
    tableNumUnSort = data.totalNum;
    %sort table so house names are ascending
    tableNum = sortrows(tableNumUnSort,1);
    
    %extract values from table
    houses = categorical(tableNum.House);
    distance = [tableNum.DistanceMean];



    % plot average Distance in bar visualisation
    figureName= strcat('viewing distances on average across all participants');
    figure('Name',figureName,'IntegerHandle', 'off');

    disfigure= bar(houses,distance);
    title(['viewing distances on average across all participants']);


    %add additional labels to x and y axis
    ax = gca;
    ax.XLabel.String = 'Houses';
    ax.XLabel.FontSize = 12;
    ax.YLabel.String = 'Average Distance';
    ax.YLabel.FontSize = 12;
    saveas(disfigure,strcat(savepath,'Average Distance all Participants.jpg'));
    
    % plot Average Distances in Ascending order
    
    sortDistance = sortrows(distance); 
    figureSortDistance= strcat('viewing distances on average across all participants - in ascending order');
    figure('Name',figureSortDistance,'IntegerHandle', 'off');

    sortDistanceBar= bar(sortDistance);
    title(figureSortDistance);
    
    %add additional labels to x and y axis
    ax = gca;
    ax.XLabel.String = 'Houses';
    ax.XLabel.FontSize = 12;
    ax.YLabel.String = 'Average Distance';
    ax.YLabel.FontSize = 12;
    saveas(sortDistanceBar,strcat(savepath,'Ascending Distance all Participants.jpg'));

    % plot 20 houses with hightes Distance plus how many people saw them
 
      mostDistHouse=sortrows(tableNum,5);
      %extract the 20 houses
      mostDistHouse20=tail(mostDistHouse,20);
      %remove unnecessary variables
      mostDistHouse20var= removevars(mostDistHouse20,{'occ','House','DistanceAllLooks','DistanceVariance'});
      arrayDistHouse20var= table2array(mostDistHouse20var);
     
      %plot it
    fig20Houses= strcat('20 houses seen from the longest distance on average');
    figure('Name',fig20Houses,'IntegerHandle', 'off');

    mostDistHouse20Bar= bar(arrayDistHouse20var);
    title(fig20Houses);
    legend('avg Distance','Amount of Participants','avg time looked at','Location','northwest');
    xlables = mostDistHouse20.House;
    xticklabels(xlables);
    ax = gca;
    ax.XLabel.String = 'House Names';
     
    
    %saveas(mostDistHouse20Bar,strcat(savepath,'Houses longestDistance.jpg'));
    %saveas(sortDistanceBar,strcat(savepath,'Ascending Distance all Participants.jpg'));
    
    
    % extract House list of 4 most seen houses
    
    most4Houses= tail(mostDistHouse,4);
    save([savepath '4Houses_longestDist.mat'],'most4Houses');
    disp('done');
%     totalLooks=zeros(4,1);
%     most4Houses
%     


      


%____________________________________________________________________________
 %Variance stuff   
    
%      % plot average Variance in bar visualisation
%     figure(2)
%     varfigure= bar(houses,variance);
%     
%     title([filename ' - Average Variance']);
% 
%     %add additional labels to x and y axis
%     ax = gca;
%     ax.XLabel.String = 'Houses';
%     ax.XLabel.FontSize = 12;
%     ax.YLabel.String = 'Average Variance';
%     ax.YLabel.FontSize = 12;
%     drawnow
%     saveas(varfigure,strcat(savepath,'\Average Variance all Participants.jpg'));
    
