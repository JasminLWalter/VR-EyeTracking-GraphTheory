%--------------------- analysis Lost Data ------------------------

clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\analysisLostData\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\condenseViewedHouses\';

% participant list including all participants
%PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

% participant list only with participants who have lost less than 30% of
% their data
PartList = {8580}; %1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

overviewLostData = table;
overviewSameHouse = [];
overviewDifferentHouses = [];
exceptions = [];

allListsDifferent = table;


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
        
        
        % save sample and index information of lost samples between
        % different houses
        indexDifferent =  [];
        sampleDifferent = [];
        
        % check whether missing samples are between same or different
        % houses
               
        for index = 1:height(AllSeen)
                
            % if the row is a noData row
            if strcmp(AllSeen{index,1},'noData')
                
                if index==1
                    
                    exceptions = [exceptions; AllSeen{index,3}];
                    
                    
                elseif index == height(AllSeen)
                    exceptions = [exceptions; AllSeen{index,3}];
                else
                
                    if strcmp(AllSeen{index-1,1},AllSeen{index+1,1})
                    
                        overviewSameHouse = [overviewSameHouse; AllSeen{index,3}];
                    
                    else
                        overviewDifferentHouses = [overviewDifferentHouses; AllSeen{index,3}];
                        indexDifferent = [indexDifferent; index];
                        sampleDifferent = [sampleDifferent; AllSeen{index,3}];

                    
                    end
                end
                
            end
    
        end
                    
                    
        
        
        % create overview of all participants = combine all noDataTables
        % into one table
        
        overviewLostData = [overviewLostData; noDataTable];
        
        % combine sample and index information into table
        
        combineSIDifferent = table;
        combineSIDifferent = [combineSIDifferent; table(indexDifferent),table(sampleDifferent)];
        %sortedSIDifferent = sortrows(combineSIDifferent,2);
        smaller8 = (combineSIDifferent{:,2} > 7);
        
        
        
        infoDifferent = combineSIDifferent;
        infoDifferent(smaller8,:) = []; 
       
        listDifferent = array2table(zeros((height(infoDifferent)*17),3));
        %('Size',[(height(AllSeen)*3),4],'VariableNames',{'House','Sample','Index','Participant'});
        listDifferent.Properties.VariableNames = {'Index','House','Sample'};
        
       
        
        exampleTable = table;
        
        
        for iD = 1: (height(infoDifferent)-1)
            
            indexExample = infoDifferent{iD,1};
            
            
            lowerscope = [(indexExample - 7): 1: indexExample];
            upperscope = [(indexExample +1) : 1: (indexExample + 7)];
            
            totalscope = [lowerscope, upperscope];
            
            Houses = AllSeen.House(totalscope);
            Samples = AllSeen.Looks(totalscope);
            Index = totalscope';
            
            scopeTable = table(Index, Houses, Samples);
            extraRow = table(0,'---------------------',0);
            extraRow.Properties.VariableNames = {'Index','Houses','Samples'};
            
            exampleTable = [exampleTable; scopeTable; extraRow];
        end
        
         
        
        
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

% sums to test whether the script works correctly
sumTotal = sum(overviewLostData.Looks);
sumSame = sum(overviewDifferentHouses(:,1));
sumDifferent = sum(overviewSameHouse(:,1));
sumException= sum(exceptions(:,1));

sumTest = sum(overviewDifferentHouses(:,1)) + sum(overviewSameHouse(:,1))+ sum(exceptions(:,1));

% calculate Tick lables for better plots
totalClusters = height(overviewLostData);
totalTesti = length(overviewSameHouse) + length(overviewDifferentHouses);

goodTickLables = (0:5:45);
goodTicks = (goodTickLables*totalClusters)/100;

 % all samples > 10 are renamed 12
 % sameHouse
 top10Same = overviewSameHouse;
 sortSame= sort(top10Same,'ascend');
 
 bigger10Same = (sortSame > 10);
 sortSame(bigger10Same) = 12;
 
 % different Houses
 top10Different = overviewDifferentHouses;
 sortDifferent= sort(top10Different,'ascend');
 
 bigger10Different = (sortDifferent > 10);
 sortDifferent(bigger10Different) = 12;
 
 % plot lostData of same and different houses into one figure
 figure(1)
 
 hist1 = histogram(sortSame,'FaceColor','b');
 
 hold on
 
 hist2 = histogram(sortDifferent,'FaceColor','g');

 set(gca, 'YTick',goodTicks, 'YTickLabel',goodTickLables);
 ylabel('Percentage');
 xlabel('amount of consecutive samples');
 
 title({'Distribution of consecutive lost data samples ',' - depending on house before/after lost sample -','all cons. samples > 10 are named 12'})

 hold off
 legend('same house','different houses')
 saveas(gcf,strcat(savepath,'DistributionLostData_House_before-after.png'),'png');

 
 % plot only outlines of histograms
 
 figure(2)
 
 hist3 = histogram(sortSame,'DisplayStyle','stairs');
 
 hold on
 
 hist4 = histogram(sortDifferent,'DisplayStyle','stairs');

 set(gca, 'YTick',goodTicks, 'YTickLabel',goodTickLables);
 ylabel('Percentage');
 xlabel('amount of consecutive samples');
 
 title({'Distribution of consecutive lost data samples ',' - depending on house before/after lost sample -','all cons. samples > 10 are named 12'})

 hold off
 legend('same house','different houses')
 saveas(gcf,strcat(savepath,'DistributionLostData_House_before-after_stairs.png'),'png');


% visualizations
figure(3)
plotHist = histogram(overviewLostData.Looks);
 ylabel('occurence');
 xlabel('amount of consecutive samples');
title('distribution of consecutive lost data samples')
saveas(gcf,strcat(savepath,'DistributionLostData_all.png'),'png');



%statistics
 sumAll = sum(overviewLostData.Looks);
 maxAll = max(overviewLostData.Looks);
 

 
 % create histogram that contains only 10 slices - all samples > 10 are renamed
 top10Overview = overviewLostData;
 sortTop10 = sortrows(top10Overview,'Looks','ascend');
 
 bigger10 = (sortTop10.Looks > 10);
 sortTop10{bigger10,3} = 12;
 
 %plotpie = pie(sortTop10.Looks); - does not work with size of table
 figure(4)
 plotHist2 = histogram(sortTop10.Looks,'Normalization','probability');
 ytix = get(gca, 'YTick');
 set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
 ylabel('Percentage');
 xlabel('amount of consecutive samples');
 title({'distribution of consecutive lost data samples','all cons. samples > 10 are named 12'})

 saveas(gcf,strcat(savepath,'DistributionLostData_bigger10combined ',num2str(currentPart),'.png'),'png');
%   
% all combined summarized:

sameSmaller8 = overviewSameHouse < 8;
samebigger7= overviewSameHouse >7;

differentSmaller8 = overviewDifferentHouses < 8;
differentbigger7= overviewDifferentHouses >7;

sumSameSmaller8 = sum(sameSmaller8);
sumSamebigger7 = sum(samebigger7);
sumDifferentSmaller8 = sum(differentSmaller8);
sumDifferentbigger7 = sum(differentbigger7);
sumTest = sumSameSmaller8 + sumDifferentSmaller8 + sumSamebigger7 + sumDifferentbigger7;


goodTickLables5 = (0:10:100);
goodTicks5 = (goodTickLables5*totalClusters)/100;
figure(5)

plot5 = bar([sumSameSmaller8,sumDifferentSmaller8,sumSamebigger7,sumDifferentbigger7]);
 set(gca, 'YTick',goodTicks5, 'YTickLabel',goodTickLables5);
 set(gca,'XTickLabel',{'same <= 7','different <= 7','same > 7','different > 7'})
 ylabel('Percentage');
 
 title({'distribution of consecutive lost data samples - summary'})

 saveas(gcf,strcat(savepath,'DistributionLostData_summary.png'),'png');
% 





disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');
