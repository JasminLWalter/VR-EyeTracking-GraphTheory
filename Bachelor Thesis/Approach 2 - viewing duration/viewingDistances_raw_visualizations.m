%% ------------------ viewingDistances_raw_visualizations--------------
% uses raw viewed houses file
% returns overview of distances bigger than 160 m with percentage, min, max
% uses only samples on houses
% lists all houses, that were viewed from a distance of more than 160 units
% and were seen from further of the far clipping plane (participants didn't
% perceive them)
% plots histograms

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\distanceVisualizations\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data2019Feb\ViewedHouses\'

PartList = {2907,8258,5324,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;

allDistances=[];



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
        distancesHousesNH= data.Distance;
        skyHouse = strcmp(houses(:),'NH') & (distancesHousesNH(:)==200);
         
        
        %rename rows to sky
        data.House(skyHouse)= cellstr('sky');
        
     
        % remove rows when pupils were detected with probability lower than 0,5
        
        rmvHouse = strcmp(houses(:),'NH') & eq(distancesHousesNH(:),0);
        
        %delete rows
        data(rmvHouse,:)=[];
        
        
        %% create house and NH table without all sky elements 
        nosky = strcmp(data.House(:),'sky');             
        housesNHTable = data;
        housesNHTable(nosky,:)=[];
        
        %update all distances
        allDistances=[allDistances; housesNHTable.Distance];
        
        % visualize line graph of distances
        
        housesNHTable= sortrows(housesNHTable,2);
        distancesHousesNH= housesNHTable.Distance;
        

        figure(1);
        histo1= histogram(distancesHousesNH);
        title('Viewing distances of houses and NH');
%         ax= gca;
%         ylim([0 9000]);
%         xlim([0 600]);
%         line([160,160],[-5,9000],'Color','red');
%         hold on

        
%         figure(2);
%         
%         histo2 = histogram(distancesHousesNH);
%         title('Houses+NH');
%         ax = gca;
%         ylim([0 250]);
%         xlim([0 600]);
%         line([160,160],[0,250],'Color','red');
%         hold on
        
        
        
        %% create house table without all sky and NH elements 
        noHouse = strcmp(data.House(:),'sky')| strcmp(data.House(:),'NH');             
        housesTable = data;
        housesTable(noHouse,:)=[];
        
        % visualize line graph of distances
        
        housesTable= sortrows(housesTable,2);
        distancesHouses= housesTable.Distance;
        
        [N,edges]= histcounts(distancesHouses);
        

       
        figure(3);
        histo3= histogram(distancesHouses);
        title('Viewing distances of houses');
%         ax = gca;
%         ylim([0 9000]);
%         xlim([0 600]);
%         line([160,160],[-5,9000],'Color','red');
%         hold on

%         
%         figure(4);
%         
%         histo4 = histogram(distancesHousesNH);
%         title('Houses');
%         ax = gca;
%         ylim([0 250]);
%         xlim([0 600]);
%         line([160,160],[0,250],'Color','red');
%         hold on
        
        
        %% plot just NH catagorie
        
        nh= strcmp(data.House(:),'NH');
        nhTable= data(nh,:);
        
        figure(5);
        
        histo5= histogram(nhTable.Distance);
        title('Viewing distances of NH category objects');
%         ax = gca;
%         ylim([0 9000]);
%         xlim([0 600]);
%         line([160,160],[0,9000],'Color','red');
%         hold on
        
%         figure(6);
%         
%         histo6= histogram(nhTable.Distance);
%         title('just NH category');
%         ax = gca;
%         ylim([0 250]);
%         xlim([0 600]);
%         line([160,160],[0,250],'Color','red');
%         hold on
%         
        
        
        
        
        
        
       
       
        
        
        
        

        
    else
        disp('something went really wrong with participant list');
    end

end

% visualize all distances

figure(7);
        
        histo7= histogram(allDistances,'normalization','probability');
        title('Viewing distances - all participants');
%         ax = gca;
%         line([160,160],[0,9000],'Color','red');
%         yt = get(gca, 'YTick');                    
%         set(gca, 'YTick',yt, 'YTickLabel',yt*(100/length(allDistances)));



disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

% csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
% disp('saved missing participant file list');

disp('done');