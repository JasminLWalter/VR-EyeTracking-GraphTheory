%------------------------DistanceStatistics--------------------------------
% plots distance statistics for each individual subject listed in Participant List
% uses NumViews files 
    
clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\DistanceStatistics\individual\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\analysisAllViewsJExtended\'

%PartList = {2907,5324,4302,7561,6348,4060,6503,7535};
%,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};
PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};


Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;
figures=[];

for ii = 1:Number
    
    currentPart= cell2mat(PartList(ii));
    file = strcat('NumViewsD_VP_',num2str(currentPart),'.mat');
    
    %pathfile = strcat('E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data\ViewedHouses\',file);
    
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
    
    elseif exist(file)==2
         
        %load data          
        data = load(file);
    
        tableNumUnSort = data.NumViews;
        %sort table so house names are ascending
        tableNum = sortrows(tableNumUnSort,1);
        %extract values from table

        houses = categorical(tableNum.House);
        distance = [tableNum.DistanceMean];
        variance= [tableNum.DistanceVariance];

         % plot average Distance in bar visualisation
         
        currentDisFig= strcat('Distance',num2str(currentPart));
        figure('Name',currentDisFig,'IntegerHandle', 'off');

        
        disfigure= bar(houses,distance);
        title(['Participant: ' num2str(currentPart) ' - Distance Plot']);


        %add additional labels to x and y axis
        ax = gca;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Average Distance';
        ax.YLabel.FontSize = 12;
        saveas(disfigure,strcat(savepath,'\Distances_',num2str(currentPart),'.jpg'));

    
     % plot average Variance in bar visualisation
        
        currentVarFig= strcat('Variance',num2str(currentPart));
        figure('Name',currentVarFig,'IntegerHandle', 'off');

        varfigure= bar(houses,variance);
    
        title(['Participant: ' num2str(currentPart) ' - Variance Plot']);

        %add additional labels to x and y axis
        ax = gca;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Average Variance';
        ax.YLabel.FontSize = 12;

        saveas(varfigure,strcat(savepath,'\Variances_',num2str(currentPart),'.jpg'));
    
        %figures= [figures figure(1) figure(2)];
        
    else
        disp('something went really wrong with participant list');
    end
    
end

%imshow figures;
disp('done');