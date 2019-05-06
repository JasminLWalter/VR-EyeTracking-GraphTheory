%% ------------------viewingDurationVisualization_individual--------------
% written by Jasmin Walter
% individual
% plots viewing durations in histogram individually for every listed
% participant
% creates histogram for 
% 1. viewing durations on houses, 
% 2. viewing durations on sky and NH objects
% 3. viewing durations on all objects regardless of category


clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\viewingDurations\individual\';

cd 'D:\BA Backup\Data_after_Script\CondenseViewedHouses\'

% old PartList = {7535,5324,2907,4302,7561,6348,4060,6503,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};
PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_condensedViewedHouses.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        % load data
        AllSeen = load(file);
        AllSeen = AllSeen.AllSeen;
        
        % remove all sky and NH elements
        nothouses = strcmp(AllSeen.House(:),'sky') | strcmp(AllSeen.House(:),'NH');             
       
        housesTable=AllSeen;
        housesTable(nothouses,:)=[];
        
        otherObjectsTable = AllSeen(nothouses,:);
        


%% plot histograms for viewing durations on houses
       
        binsize = 1; %( binsize should be one sample, 1 sample = 33 ms duration)
        
        % viewing durations falling on houses
        figure(1)

        hist1 = histogram(housesTable.Looks,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations falling on houses - participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick');                    
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;

        saveas(gcf,strcat(savepath,'viewing durations falling on houses - participant ',num2str(currentPart),'.jpg'),'jpg');


        % combine those durations bigger than 1 sec = bigger 30 samples

        big30_2= housesTable.Looks > 30;

        combBhouses = housesTable.Looks;
        combBhouses(big30_2) = 31;
        totalHouses = length(housesTable.Looks);

        figure(2)

        hist2= histogram(combBhouses,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations falling on houses (>1 sec combined) - participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick'); 
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        grid on
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;
        sameylimit = ylim;
        saveas(gcf,strcat(savepath,'viewing durations falling on houses(bigger 1sec combined)-participant',num2str(currentPart),'.jpg'),'jpg');
 
        
       % viewing durations falling on sky and NH
        figure(3)

        hist3 = histogram(otherObjectsTable.Looks,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations falling on sky and NH - participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick');                    
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;

        saveas(gcf,strcat(savepath,'viewing durations falling on skyNH - participant ',num2str(currentPart),'.jpg'),'jpg');


        % combine those durations bigger than 1 sec = bigger 30 samples

        big30_4= otherObjectsTable.Looks > 30;

        combBother = otherObjectsTable.Looks;
        combBother(big30_4) = 31;
        totalOther = length(otherObjectsTable.Looks);

        figure(4)

        hist4= histogram(combBother,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations falling on sky and NH(> 1sec combined)- participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick'); 
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        grid on
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;
        sameylimit = ylim;
        saveas(gcf,strcat(savepath,'viewing durations falling on skyNH(bigger 1sec combined)- participant',num2str(currentPart),'.jpg'),'jpg');

       % viewing durations all objects
        figure(5)

        hist5 = histogram(AllSeen.Looks,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations on all objects - participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick');                    
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;

        saveas(gcf,strcat(savepath,'viewing durations falling on all objects - participant ',num2str(currentPart),'.jpg'),'jpg');


        % combine those durations bigger than 1 sec = bigger 30 samples

        big30_6= AllSeen.Looks > 30;

        combAll = AllSeen.Looks;
        combAll(big30_6) = 31;
        totalAll = length(AllSeen.Looks);

        figure(6)

        hist6= histogram(combAll,'Normalization','probability','BinWidth',binsize);
        title(strcat('viewing durations falling on all objects (>1 sec combined) - participant ',num2str(currentPart)));
        
        yt = get(gca, 'YTick'); 
        set(gca, 'YTick',yt, 'YTickLabel',yt*100);
        grid on
        ax = gca;
        ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
        ax.XLabel.FontSize = 12;
        ax.YLabel.String = 'percentage';
        ax.YLabel.FontSize = 12;
        sameylimit = ylim;
        saveas(gcf,strcat(savepath,'viewing durations falling on all objects(bigger 1sec combined)- participant',num2str(currentPart),'.jpg'),'jpg');

       
        

        
    else
        disp('something went really wrong with participant list');
    end

end



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



