%------------------distanceBoxplot-----------------------------
% written by Jasmin Walter

% creates boxplots for every individual participant listed
% devides houses into 6 parts for better readability before creating
% boxplots - so it creates 6 boxplot figures for every participant
% individually

clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\boxplots\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data2019Feb\ViewedHouses\'


PartList = {1882};
%,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;
missingData = array2table([]);
noHouse = array2table([]);


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('ViewedHouses_VP',num2str(currentPart),'.txt');
    
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
        
       
    
    elseif exist(file)==2
        %load house list
        houseList= load('E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\HouseList.mat');
        houseList= houseList.houseList;
        
        
        %load data
        data = readtable(file,'Format','%s %f %f','ReadVariableNames',false);
        data.Properties.VariableNames = {'House','Distance','Timestamp'};
        
%         % sort table according to house names
%         dataDistances = sortrows(data);
%         
%         houses= dataDistances.House;
%         
%         NH = strcmp(houses(:),'NH');
%         noHouse= dataDistances(NH,:);
%         dataDistances(NH,:)=[];

        % remove all NoHouses category rows from data
        dataSeenHouses = data;
        
        houses= dataSeenHouses.House;
        
        NH = strcmp(houses(:),'NH');
        
        %store NH rows in noHouse
        noHouse= dataSeenHouses(NH,:);
        %delete NH rows
        dataSeenHouses(NH,:)=[];
        
        % which houses were seen?
        
        seenH = unique(dataSeenHouses.House);
        
        % which houses were not looked at
        missing= not(ismember(houseList,seenH));
        
        missingHouses= houseList(missing);
        
        addmissing= array2table(zeros(length(missingHouses),2));
        addmissing.Properties.VariableNames={'House','Distance'};
        addmissing.House=missingHouses;
        
        
        
        boxPlotTable= dataSeenHouses;
        boxPlotTable= removevars(boxPlotTable,'Timestamp');
        boxPlotTable= [boxPlotTable; addmissing];
        
        boxPlotTable= sortrows(boxPlotTable);
        
        maxDist = max(boxPlotTable.Distance);
        
        % devide table into 6 parts
        Part1= houseList(1:36,1);
        Part2= houseList(37:72,1);
        Part3 = houseList(73:108,1);
        Part4 = houseList(109:143,1);
        Part5 = houseList(144:178,1);
        Part6 = houseList(179:213,1);
        
        %create Part1
        truePart1= ismember(boxPlotTable.House(:),Part1);
        tablePart1= boxPlotTable(truePart1,:);
        
        %create Part2
        truePart2= ismember(boxPlotTable.House(:),Part2);
        tablePart2= boxPlotTable(truePart2,:);
        
        %create Part3
        truePart3= ismember(boxPlotTable.House(:),Part3);
        tablePart3= boxPlotTable(truePart3,:);
        %create Part4
        truePart4= ismember(boxPlotTable.House(:),Part4);
        tablePart4= boxPlotTable(truePart4,:);
        %create Part5
        truePart5= ismember(boxPlotTable.House(:),Part5);
        tablePart5= boxPlotTable(truePart5,:);
        %create Part6
        truePart6= ismember(boxPlotTable.House(:),Part6);
        tablePart6= boxPlotTable(truePart6,:);
        
        
        %plot Part 1
        houses1= categorical(tablePart1.House);
        distances1= tablePart1.Distance;
        
        name1= strcat(num2str(currentPart),'- Distances - Part1');
        
        figure('Name',name1,'IntegerHandle', 'off');
        plot1 = boxplot(distances1,houses1);
                
                
        

        %add additional labels to x and y axis
        ax = gca;
        
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name1,'FontSize',12);
        testi= strcat(savepath,name1,'.jpg');
        saveas(gcf,strcat(savepath,name1,'.jpg'),'jpg');
        %saveas(plot1,strcat(name1,'.jpg'));
       
        
        %plot Part 2
        houses2= categorical(tablePart2.House);
        distances2= tablePart2.Distance;
        
        name2= strcat(num2str(currentPart),' - Distances - Part 2');
        
        figure('Name',name2,'IntegerHandle', 'off');
        plot2 = boxplot(distances2,houses2);
                
        

        %add additional labels to x and y axis
        ax = gca;
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name2,'FontSize',12);
        %saveas(plot2,strcat(savepath,name2,'.jpg'));
        
        %plot Part 3
        houses3= categorical(tablePart3.House);
        distances3= tablePart3.Distance;
        
        name3= strcat(num2str(currentPart),' - Distances - Part 3');
        
        figure('Name',name3,'IntegerHandle', 'off');
        plot3 = boxplot(distances3,houses3);
                
        

        %add additional labels to x and y axis
        ax = gca;
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name3,'FontSize',12);
        %saveas(plot3,strcat(savepath,name3,'.jpg'));
       
        %plot Part 4
        houses4= categorical(tablePart4.House);
        distances4= tablePart4.Distance;
        
        name4= strcat(num2str(currentPart),' - Distances - Part 4');
        
        figure('Name',name4,'IntegerHandle', 'off');
        plot4 = boxplot(distances4,houses4);
                
        title(name4,'FontSize',12);

        %add additional labels to x and y axis
        ax = gca;
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name4,'FontSize',12);

        %saveas(plot4,strcat(savepath,name4,'.jpg'));
        
        %plot Part 5
        houses5= categorical(tablePart5.House);
        distances5= tablePart5.Distance;
        
        name5= strcat(num2str(currentPart),' - Distances - Part 5');
        
        figure('Name',name5,'IntegerHandle', 'off');
        plot5 = boxplot(distances5,houses5);
                
        title(name5,'FontSize',12);

        %add additional labels to x and y axis
        ax = gca;
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name5,'FontSize',12);
        %saveas(plot5,strcat(savepath,name5,'.jpg'));
        
        %plot Part 6
        houses6= categorical(tablePart6.House);
        distances6= tablePart6.Distance;
        
        name6= strcat(num2str(currentPart),' - Distances - Part 6');
        
        figure('Name',name6,'IntegerHandle', 'off');
        plot6 = boxplot(distances6,houses6);
                
        title(name6,'FontSize',12);

        %add additional labels to x and y axis
        ax = gca;
        ylim([0 180]);
        ax.FontSize= 6;
        ax.XLabel.String = 'Houses';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'Distance';
        ax.YLabel.FontSize = 12;
        title(name6,'FontSize',12);
        %saveas(plot6,strcat(savepath,name6,'.jpg'));

        
        

       %%%% devide boxPlotTable into at least 3 parts
       % use houseList to define which houses belong to which part
       % also save this categorization
       % make sure the axes of the plot are consistent accros Participants
       
%         houses= categorical(boxPlotTable.House);
%         
%         distances= boxPlotTable.Distance;
%         
%         boxplot(distances,houses)
        
        
        
        

        
%         %clean data
%         for e= 1:height(boxPlotTable)
%             if strcmp(boxPlotTable.House(e),'NH')
%                 noHouse=[noHouse; boxPlotTable.House(e)];
%                 boxPlotTable(e,:) =[];
%             end
%             
%             
%         end
        
             
% 
%             if strcmp(boxPlotTable.House(e),'NH')
%                 % if pupils were detected with probability lower than 0,5
%                 if boxPlotTable.Distance(e)==0
%                     missingData = [missingData;boxPlotTable(e,:)];
%                     boxPlotTable(e,:)=[];
%                 
%                 % if subject was looking into the sky
%                 elseif boxPlotTable{e,2}==200
%                     boxPlotTable{e,1}= cellstr('sky');
%                     noHouse= [noHouse;boxPlotTable(e,:)];
%                     boxPlotTable(e,:)=[];
%                     
%                 % if subject looked not at the sky or house
%                 else
%                     noHouse= [noHouse;boxPlotTable(e,:)];
%                     boxPlotTable(e,:)=[];
%                     
%                 end
%             end
            
        
            
            
            
        
        

%         distanceArray= data.Distance;
%         housesCat=categorical(data.House);
%         boxplot(distanceArray,housesCat)
        
    else
        disp('something went really wrong with participant list');
    end

end