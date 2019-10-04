%--------------------- analysis Lost Data ------------------------

clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\analysisLostData\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\condenseViewedHouses\';

% participant list including all participants
%PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

% participant list only with participants who have lost less than 30% of
% their data
PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

overviewLostData = table;


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_condensedViewedHouses.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        % load data
        AllSeen = load(file);
        AllSeen = AllSeen.AllSeen;

        noData = strcmp(AllSeen{:,1},'noData');
        
        noDataTable = AllSeen(noData,:);
        
        
        % create overview of all participants = combine all noDataTables
        % into one table
        
        overviewLostData = [overviewLostData; noDataTable];
%         figure(1)
%         plotHist = histogram(noDataTable.Looks);
%         
%         
%         figure(2)
%         plotPie = pie(noDataTable.Looks);
        
        
    else
        disp('something went really wrong with participant list');
    end

end
% visualizations
figure(1)
plotHist = histogram(overviewLostData.Looks);
 ylabel('occurence');
 xlabel('amount of consecutive samples');
title('distribution of consecutive lost data samples')
saveas(gcf,strcat(savepath,'DistributionLostData',num2str(currentPart),'.png'),'png');



%statistics
 sumAll = sum(overviewLostData.Looks);
 maxAll = max(overviewLostData.Looks);
 

 
 % create histogram that contains only 10 slices - all samples > 10 are renamed
 top10Overview = overviewLostData;
 sortTop10 = sortrows(top10Overview,'Looks','ascend');
 
 bigger10 = (sortTop10.Looks > 10);
 sortTop10{bigger10,3} = 12;
 
 %plotpie = pie(sortTop10.Looks); - does not work with size of table
 figure(2)
 plotHist2 = histogram(sortTop10.Looks,'Normalization','probability');
 ytix = get(gca, 'YTick');
 set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
 ylabel('Percentage');
 xlabel('amount of consecutive samples');
 title({'distribution of consecutive lost data samples','all cons. samples > 10 are named 12'})
saveas(gcf,strcat(savepath,'DistributionLostData_bigger10combined ',num2str(currentPart),'.png'),'png');
  
 
 
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');
