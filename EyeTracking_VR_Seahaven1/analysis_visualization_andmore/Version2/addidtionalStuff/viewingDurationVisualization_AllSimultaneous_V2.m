%% ------------------viewingDurationVisualization_AllSimultaneous--------------
% written by Jasmin Walter

% plottes viewing durations in histograms for all participants
% simultaneously over each other in plots
% best to observe if plots are placed on different positions of the screen
% so that when running the script, changes can be observed visually

clear all;

savepath = 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\analysis_viewingDurations\';

cd 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\interpolateLostData\'

% old PartList = {7535,5324,2907,4302,7561,6348,4060,6503,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};
%PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;


%allDurations = array2table([]);
allSamples= [];
allHouses= [];


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_interpolatedViewedHouses.mat');
    
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        % load data
        interpolatedData = load(file);
        interpolatedData = interpolatedData.interpolatedData;
        
        % remove all sky and NH elements
        houses = strcmp(interpolatedData.House(:),'sky') | strcmp(interpolatedData.House(:),'NH');             
       
        housesTable=interpolatedData;
        housesTable(houses,:)=[];
              
        
        % add samples durations and houses to lists
        
        %allDurations=[allDurations;array2table(housesTable.Time)];
        allSamples=[allSamples;housesTable.Samples];
        allHouses= [allHouses;length(housesTable.House)];  
        
        %% plot histogram
        %binsize = 1000/30; (not good when using durations)
        binsize = 1; %( binsize should be one sample, 1 sample = 33,333ms duration)
        
        figure(1)
        
        hist1 = histogram(housesTable.Samples,'BinWidth',binsize,'DisplayStyle','stairs');
        title('All Durations over Participants');
        %line([250,250],[0,100],'Color','red');

        
        hold on
        
       
        
        % zoom in
        
          
        figure(2)  
        hist2 = histogram(housesTable.Samples,'BinWidth',binsize,'DisplayStyle','stairs');
        title('All Durations over Participants - zoomed in (1 sec)');
        ax= gca;
        xlim([0 30]);

        hold on
        
        % combine all durations <1s (1000ms)
        
        big30 = housesTable.Time(:) > 30;
        
        combineDursT= housesTable;
        combineDursT.Time(big30)= 31;
          
          figure(3);
          hist3= histogram(combineDursT.Samples, 'BinWidth',binsize,'DisplayStyle','stairs');
          title('All Durations over Participants -in bins 0-1s and <1s');
          %line([250,250],[0,9000],'Color','red');          
          hold on
%           
%           testi= [0:(1000/30):45000];
%           [N edges]= histcounts(housesTable.Time, possibleDurations);
%           yt = get(gca, 'YTick');                    
% set(gca, 'YTick',yt, 'YTickLabel',yt*(100/164));
        
  %         
%            testi= [0:(1000/30):45000];
%           [Niu edgenges]= histcounts(housesTable.Time, testi);
%           
          %possibleDurations= [possibleDurations 60000];

        
    else
        disp('something went really wrong with participant list');
    end

end
%% histogram with all durations

figure(4)

hist4= histogram(allSamples,'BinWidth',binsize);
title('all Durations of all Participants');
          %line([250,250],[0,9000],'Color','red');
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*(100/length(allSamples)));


% combine those durations bigger than

%big1000= allSamples > 1000;
big30= allSamples > 30;

combAllDurs = allSamples;
combAllDurs(big30) = 31;
totalAmount = length(allSamples);

figure(5)

hist5= histogram(combAllDurs,'BinWidth',binsize);
title('all Durations of all Participants, <1s combined');
          %line([250,250],[0,9000],'Color','red');
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*(100/totalAmount));
grid on

zzzzzzzz= array2table(allSamples);

% trying out

% less150 = allSamples < 151;
% big450 = allSamples > 450;
% 
% crazyDurs = allSamples;
% crazyDurs(less150) = 150;
% crazyDurs(big450) = 450;
% 
% CcrazyDurs= categorical(crazyDurs);
% 
% figure(6)
% 
% hist6= histogram(CcrazyDurs);
% title('new try to plot');
%           %line([250,250],[0,9000],'Color','red');
% yt = get(gca, 'YTick');                    
% set(gca, 'YTick',yt, 'YTickLabel',yt*(100/totalAmount));
% ax= gca;
% 
% grid on
% grid minor



%% now using plot again

% uniqueDurs = unique(allDurations);
% 
% uniqueTable = array2table(uniqueDurs,'VariableNames',{'Durations'});
% 
% for n = 1:length(uniqueDurs)
%     helper = uniqueTable.Durations(n)==allDurations(:);
%     nrHouses = sum(helper);
%     
%     uniqueTable.NrHouse(n)= nrHouses;
% end
% 
% figure(7)
% 
% plot(uniqueTable.Durations,uniqueTable.NrHouse);


          




        






%% end part

disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));
% 
% csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
% disp('saved missing participant file list');
% 
% save([savepath 'Overview_Time.mat'],'overviewTime');
% disp('saved Overview Time');


disp('done');




%% not used stuff anymore

% using plot function instead of histagram

% % create vector with all possible durations
%           possibleDurations=zeros(1,1800);
%           for n=1:1800
%               possibleDurations(n)= (n*1000)/30;
%           end
%           
%           durationTable = array2table(possibleDurations','VariableNames',{'Durations'});
%           
%           for n= 1:length(possibleDurations)
%               helper = possibleDurations(n)==housesTable.Time(:);
%               nrHouses= sum(helper);
%               durationTable.amountHouses(n)= nrHouses;
%               
%           end
%           
%           figure(1)
%           plot(durationTable.Durations, durationTable.amountHouses);
%           title('testi')
%           ax= gca;
%           xlim([0,1000]);
%           
%           
%          
%           hold on




% using unique durations:

        % calculate counts of durations
        
%         durationsPart= housesTable.Time;
%         uniqueDurations = unique(durationsPart);
%         durHouseT= array2table(zeros(length(uniqueDurations),2),'VariableNames',{'Duration','NrHouses'});
%         
%        
%         for e = 1:length(uniqueDurations)
%             
%             durationHouses = housesTable.Time(:) == uniqueDurations(e);
%             nrHouses= sum(durationHouses);
%             durHouseT.Duration(e)= uniqueDurations(e);
%             durHouseT.NrHouses(e)= nrHouses;
%                   
%     end


%% end part unused

%         uniqueDurations = unique(allDurations);
%         durHouseT= array2table(zeros(length(uniqueDurations),2),'VariableNames',{'Duration','NrHouses'});
%         
%         for e = 1:length(uniqueDurations)
%             
%             durationHouses = allDurations(:) == uniqueDurations(e);
%             nrHouses= sum(durationHouses);
%             durHouseT.Duration(e)= uniqueDurations(e);
%             durHouseT.NrHouses(e)= nrHouses;
%                   
%         end
%         

        
        
        %categoricalDurs= categorical(sortedTable.Duration);
        
%         figure(100);
%         plot(sortedTable.Duration,sortedTable.NrHouses)
%         title('All durations over Participants');


%         %create edges vector
%         possibleDurations=zeros(1,30);
%           for n=1:30
%               possibleDurations(n)= (n*1000)/30;
%           end
