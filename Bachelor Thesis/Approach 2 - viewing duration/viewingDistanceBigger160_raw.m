%% ------------------ viewingDistanceBigger160_raw--------------
% uses raw viewed houses files
% returns overview of distances bigger than 160 m with percentage, min, max
% 
% lists all houses, that were viewed from a distance of more than 160 units
% and were seen from further of the far clipping plane (participants didn't
% perceive them)
% creates overview for each participant
% collects all houses and distances in table
% plots this overview of houses and distances in bar an pie plot



clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\distanceVisualizations\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data2019Feb\ViewedHouses\'

% old PartList = {2907,5324,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};
PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;

overviewDistanceHouses = array2table([]);
allHousesTable = table;

allGood2=[];




for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('ViewedHouses_VP',num2str(currentPart),'.txt');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        %load data
        RawData = readtable(file,'Format','%s %f %f','ReadVariableNames',false);
        RawData.Properties.VariableNames = {'House','Distance','Timestamp'};
        data = RawData;
        
        %% clean data
        
        % rename NH to sky if they looked into the sky
        
        houses = data.House;
        distances= data.Distance;
        skyHouse = strcmp(houses(:),'NH') & (distances(:)==200);
         
        
        %rename rows to sky
        data.House(skyHouse)= cellstr('sky');
        
     
        % remove rows when pupils were detected with probability lower than 0,5
        
        rmvHouse = strcmp(houses(:),'NH') & eq(distances(:),0);
        
        %delete rows
        data(rmvHouse,:)=[];
        
        
        % remove all sky and NH elements 
        noHouse = strcmp(data.House(:),'sky')| strcmp(data.House(:),'NH');             
        housesTable = data;
        housesTable(noHouse,:)=[];
        
        
        % distances bigger than 160
        bigDis = housesTable.Distance(:) > 160;
        
        bigHouses2=housesTable;
        bigHouses2(not(bigDis),:)= [];
        
       if not(height(bigHouses2)==0)
            
           % update all houses overview Table
           
           allHousesTable = [allHousesTable;bigHouses2];
        
        % updates overview houses table
        
      
        helperTable = array2table(zeros(3,1));
        helperTable.Properties.VariableNames = cellstr(strcat('Part_',num2str(currentPart)));
        
        perc = (height(bigHouses2)*100)/ height(housesTable);
        
        helperTable{1,1}= perc;
        
        helperTable{2,1} = height(bigHouses2);
        helperTable{3,1}= height(housesTable);
        
        overviewDistanceHouses = [overviewDistanceHouses helperTable];
        
        
        %overviewTable.distanceT(currentPart) = [bigHouses.Distances];
        
        else
            allGood2=[allGood2 currentPart];
        end

       
        
        
        
        

        
    else
        disp('something went really wrong with participant list');
    end

end

% calculate min, max and mean




overviewDistanceHouses.Min(1)= min(overviewDistanceHouses{1,:});
overviewDistanceHouses.Min(2)= min(overviewDistanceHouses{2,1:end-1});
overviewDistanceHouses.Min(3)= min(overviewDistanceHouses{3,1:end-1});

overviewDistanceHouses.Max(1)= max(overviewDistanceHouses{1,:});
overviewDistanceHouses.Max(2)= max(overviewDistanceHouses{2,1:end-1});
overviewDistanceHouses.Max(3)= max(overviewDistanceHouses{3,1:end-1});
overviewDistanceHouses.Mean(1)= mean(overviewDistanceHouses{1,:},2);
overviewDistanceHouses.Mean(2)= mean(overviewDistanceHouses{2,1:end-1},2);
overviewDistanceHouses.Mean(3)= mean(overviewDistanceHouses{3,1:end-1},2);
%name rows

overviewDistanceHouses.Properties.RowNames={'Percentage','data<160','total'};

save([savepath 'bigDistancesHouses'],'overviewDistanceHouses');
disp('saved overview Houses');
save([savepath 'allGood2'],'allGood2');
disp('saved allGood');


% plot houses


[uniqueHouses,iaD,icD] = unique(allHousesTable.House);
occCountsD = accumarray(icD,1);
sum_countsDis = table;
sum_countsDis.MaxElements = uniqueHouses;
sum_countsDis.CountsOcc = occCountsD;
sortSumDur = sortrows(sum_countsDis,2,'descend');


figure(2)
pieDis = pie(sortSumDur.CountsOcc);
legend(sortSumDur.MaxElements,'interpreter','none','location','bestoutside')
title({'Distribution of viewing distance longer than 160 units on houses','               '});

cat = categorical(sum_countsDis.MaxElements);
figure(4)

barplotcat = bar(cat,sum_countsDis.CountsOcc);
title({'Houses with viewing distance longer than 160 units','               '});
ax = gca;
ax.XLabel.String = 'Houses';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'nr samples / data points';
ax.YLabel.FontSize = 12;


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');