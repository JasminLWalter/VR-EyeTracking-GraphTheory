%% ------------------viewingDurationVisualization_allParticipants--------------
% written by Jasmin Walter
% lists all condensed viewed houses files in one overview and visualizes
% viewing durations in histograms of this complete overview
% creates histogram for 
% 1. viewing durations on houses, 
% 2. viewing durations on sky and NH objects
% 3. viewing durations on all objects regardless of category


clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\analysis_viewingDurations\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\interpolateLostData\'

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

overviewAllHouses = table;
overviewAllOther = table;
overviewAll = table;


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
        
        noData = strcmp(interpolatedData.House(:),'noData');
        interpolatedData(noData,:) = [];
        
        
        % remove all sky and NH elements
        nothouses = strcmp(interpolatedData.House(:),'sky') | strcmp(interpolatedData.House(:),'NH');             
       
        housesTable=interpolatedData;
        housesTable(nothouses,:)=[];
        
        otherObjectsTable = interpolatedData(nothouses,:);
        
        % add samples durations and houses to lists
        
        %allDurations=[allDurations;array2table(housesTable.Time)];
        allSamples=[allSamples;housesTable.Samples];
        allHouses= [allHouses;length(housesTable.House)];  
        
%% add data of participant to overviews:

        overviewAllHouses = [overviewAllHouses;housesTable];
        overviewAllOther = [overviewAllOther;otherObjectsTable];
        overviewAll = [overviewAll;interpolatedData];


        
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath 'overviewViewingDuration_all.mat'],'overviewAll');
save([savepath 'overviewViewingDuration_houses.mat'],'overviewAllHouses');
save([savepath 'overviewViewingDuration_skyNH.mat'],'overviewAllOther');
%% histogram of all viewing durations every participant
binsize = 1;

% all

figgy5 = figure('Position', get(0, 'Screensize'));
F = getframe(figgy5);

hist5= histogram(overviewAll.Samples,'Normalization','probability','BinWidth',binsize);
title('all viewing durations of all Participants (all objects)');
          %line([250,250],[0,9000],'Color','red');
ylim([0 0.25]);
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

figgy5.WindowState = 'fullscreen';
saveas(gcf,strcat(savepath,'all viewing durations of all Participants (all objects).jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations of all Participants (all objects).png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations of all Participants (all objects).fig'));

close(figgy5)

% combine those durations bigger than

%big1000= allSamples > 1000;
big30_6= overviewAll.Samples > 30;

combAllDurs6 = overviewAll.Samples;
combAllDurs6(big30_6) = 31;
totalAmount6 = length(overviewAllHouses.Samples);

figgy6 = figure('Position', get(0, 'Screensize'));
F = getframe(figgy6);

hist6= histogram(combAllDurs6,'Normalization','probability','BinWidth',binsize);
title('all viewing durations of all Participants (all objects), <1sec combined');
ylim([0 0.25]);         
yt = get(gca, 'YTick'); 
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
grid on
ax = gca;
ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;
sameylimit = ylim;

figgy6.WindowState = 'fullscreen';
saveas(gcf,strcat(savepath,'all viewing durations of all Participants (all objects)(long durations combined).jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations of all Participants (all objects)(long durations combined).png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations of all Participants (all objects)(long durations combined).fig'));


close(figgy6)

% viewing durations on house objects
figgy1 = figure('Position', get(0, 'Screensize'));
F = getframe(figgy1);

hist1= histogram(overviewAllHouses.Samples,'Normalization','probability','BinWidth',binsize);
title('all viewing durations on houses of all Participants');
ylim([0 0.25]);
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

figgy1.WindowState = 'fullscreen';
saveas(gcf,strcat(savepath,'all viewing durations on houses of all Participants.jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations on houses of all Participants.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations on houses of all Participants.fig'));

% combine those durations bigger than 1 sec to one bin - > 30 samples

close(figgy1)


%big1000= allSamples > 1000;
big30= overviewAllHouses.Samples > 30;

combAllDurs = overviewAllHouses.Samples;
combAllDurs(big30) = 31;
totalAmount = length(overviewAllHouses.Samples);

figure(2)

hist2= histogram(combAllDurs,'Normalization','probability','BinWidth',binsize);
title('all viewing durations on houses of all Participants, <1sec combined');
          %line([250,250],[0,9000],'Color','red');
ylim([0 0.25]);                  
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
grid on
ax = gca;
ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;
saveas(gcf,strcat(savepath,'all viewing durations on houses of all Participants (long durations combined).jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations on houses of all Participants (long durations combined).png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations on houses of all Participants (long durations combined).fig'));

% viewing durations on all sky and NH objects

figure(3)

hist3= histogram(overviewAllOther.Samples,'Normalization','probability','BinWidth',binsize);
title('all viewing durations on sky and NH of all Participants');
ylim([0 0.25]);
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'all viewing durations on sky and NH of all Participants.jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations on sky and NH of all Participants.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations on sky and NH of all Participants.fig'));


% combine those durations bigger than

%big1000= allSamples > 1000;
big30_4= overviewAllOther.Samples > 30;

combAllDurs4 = overviewAllOther.Samples;
combAllDurs4(big30_4) = 31;
totalAmount4 = length(overviewAllHouses.Samples);

figure(4)

hist4= histogram(combAllDurs4,'Normalization','probability','BinWidth',binsize);
title('all viewing durations on sky and NH of all Participants, <1sec combined');
ylim([0 0.25]);
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
grid on

ax = gca;
ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'all viewing durations on sky and NH of all Participants(long durations combined).jpg'),'jpg');

print(gcf,strcat(savepath,'all viewing durations on sky and NH of all Participants(long durations combined).png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'all viewing durations on sky and NH of all Participants(long durations combined).fig'));



%% separate samples like script will later do (samples 8 and more)

more7houses = overviewAllHouses.Samples >7;

housesTableSep7 = overviewAllHouses.Samples;
housesTableSep7(more7houses) = 8;
housesTableSep7(not(more7houses)) = 7;
cHousesSep7 = categorical(housesTableSep7,[7 8],{'up to 7 samples' 'more than 7 samples'});

figure(7)

hist7= histogram(cHousesSep7,'Normalization','probability');
title({'distribution of fixations and non-fixations - only data of houses ','  '});

yt = get(gca, 'YTick'); 
set(gca, 'YTick',yt, 'YTickLabel',yt*100);


ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'distribution fixations on houses.jpg'),'jpg');

print(gcf,strcat(savepath,'distribution fixations on houses.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'distribution fixations on houses.fig'));

                  
% now with nh and sky

more7other = overviewAllOther.Samples >7;

otherTableSep7 = overviewAllOther.Samples;
otherTableSep7(more7other) = 8;
otherTableSep7(not(more7other)) = 7;
cOtherSep7 = categorical(otherTableSep7,[7 8],{'up to 7 samples' 'more than 7 samples'});

figure(8)

hist8= histogram(cOtherSep7,'Normalization','probability');
title({'distribution of fixations and non-fixations - only data of sky and NH objects','  '});

yt = get(gca, 'YTick'); 

set(gca, 'YTick',yt, 'YTickLabel',yt*100);

ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'distribution fixations on sky and NH objects.jpg'),'jpg');

print(gcf,strcat(savepath,'distribution fixations on sky and NH objects.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'distribution fixations on sky and NH objects.fig'));



% now with all objects
more7all = overviewAll.Samples >7;

allTableSep7 = overviewAll.Samples;
allTableSep7(more7all) = 8;
allTableSep7(not(more7all)) = 7;
cAllSep7 = categorical(allTableSep7,[7 8],{'up to 7 samples' 'more than 7 samples'});

figure(9)

hist9= histogram(cAllSep7,'Normalization','probability');
title({'distribution of fixations and non-fixations - all data','  '});
yt = get(gca, 'YTick'); 
set(gca, 'YTick',yt, 'YTickLabel',yt*100);

ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'viewing durations on all objects.jpg'),'jpg');

print(gcf,strcat(savepath,'viewing durations on all objects.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'viewing durations on all objects.fig'));

% %% same as subplots        
% 
% figure(10)
% 
% title('viewing durations');
% 
% % subplot houses
% subplot(1,3,1)
% 
% hist10= histogram(cHousesSep7);
% title('houses');
% helper1 = [20 40 50 60] *(length(housesTableSep7)/100);
% 
% set(gca, 'YTick',helper1, 'YTickLabel',[20 40 50 60]);
% ylim([0 60]);
% 
% % subplot sky and NH objects
% subplot(1,3,2)
% 
% hist11= histogram(cOtherSep7);
% title('sky and NH objects');
% 
% helper2 = [20 40 50 60] *(length(otherTableSep7)/100);
% 
% set(gca, 'YTick',helper2, 'YTickLabel',[20 40 50 60]);
% ylim([0 60]);
% % subplot all objects
% subplot(1,3,3)
% 
% hist12= histogram(cAllSep7);
% title('all objects');
% helper3= [20 40 50 60] *(length(allTableSep7)/100);
% ylim([0 60]);
% set(gca, 'YTick',helper3, 'YTickLabel',[20 40 50 60]);
% 

%% pie plots instead
figure(20)
pieHouses = pie(cHousesSep7);
title({'distribution of fixations and non-fixations - only data of houses ','  '});
saveas(gcf,strcat(savepath,'Pie-fixation distribution of houses.jpg'),'jpg');


print(gcf,strcat(savepath,'Pie-fixation distribution of houses.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'Pie-fixation distribution of houses.fig'));

 
 figure(21)
 pieOther = pie(cOtherSep7);
 title({'distribution of fixations and non-fixations - only data of sky and NH objects','  '});
 saveas(gcf,strcat(savepath,'Pie-fixation distribution of skyNH.jpg'),'jpg');
 
 print(gcf,strcat(savepath,'Pie-fixation distribution of skyNH.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'Pie-fixation distribution of skyNH.fig'));
 
 figure(22)
 
 pieAll = pie(cAllSep7);
 title({'distribution of fixations and non-fixations - all data','  '});
 saveas(gcf,strcat(savepath,'Pie-fixation distribution of all.jpg'),'jpg');
 
print(gcf,strcat(savepath,'Pie-fixation distribution of all.png'),'-dpng','-r300'); 
savefig(gcf, strcat(savepath,'Pie-fixation distribution of all.fig'));

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




