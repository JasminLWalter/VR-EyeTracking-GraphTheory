%% ------------------analysis_clusterLenghtWithoutNH.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses data file interpolatedColliders_3Sessions_V3

% Output: 
%



clear all;
%% adjust the following variables: savepath, current folder and participant list!-----------

savepath = 'F:\WestbrookProject\Spa_Re\control_group\Analysis\cluster_length\more\';

cd 'F:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\interpolatedColliders\'

% participant list of 90 min VR - only with participants who have lost less than 30% of
% their data (after running script cleanParticipants_V2)

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedPart= 0;


overviewGazes= table;

allDurations_buildings = [];

% allInterpData = struct;


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
    
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        tic
        countAnalysedPart = countAnalysedPart +1;
        % load data
        interpolatedData = load(file);
        interpolatedData = interpolatedData.interpolatedData;
        
        % save all data into one struct --> allInterpData
        % copy the data to the struct if it is empty (first participant)
%         if(size(allInterpData) == [1 1])
%             allInterpData = interpolatedData;
%         end
%         allInterpData = [allInterpData, interpolatedData];

        dataTable_all = table;
        dataTable_all.hitObjectColliderName = [interpolatedData(:).hitObjectColliderName]';
        dataTable_all.durations = [interpolatedData(:).clusterDuration]';

        % remove the new session marker
        newSess = strcmp(dataTable_all.hitObjectColliderName(:),{'newSession'});
        dataTable_all(newSess,:) = [];

        % identify and save noData data
                
        dataTable = dataTable_all;

        noData=strcmp(dataTable.hitObjectColliderName(:),{'noData'});
        noDataTable = dataTable_all(noData,:);
        
        dataTable(noData,:)=[];

        
        % remove all NH and sky elements and save data into house table
        nohouse=strcmp(dataTable.hitObjectColliderName(:),{'NH'});
        housesTable = dataTable;
        housesTable(nohouse,:)=[];
        

        
        allDurations_buildings = [allDurations_buildings; housesTable.durations];
        
        % save information about distribution of gazes and noise
        % something was fixated when having more than 7 samples

        gazes_all = dataTable.durations > 266.6;
        gazes_buildings = housesTable.durations > 266.6;

        gazedObjects = dataTable(gazes_all,:);
        noisyObjects = dataTable(not(gazes_all),:);
              
        
        gazedObjects_buildings = housesTable(gazes_buildings,:);
        noisyObjects_buildings = housesTable(not(gazes_buildings),:);
              
        overviewGazes.Participant(ii) = currentPart;

        overviewGazes.gaze_samples_all(ii) = height(gazedObjects);
        overviewGazes.noise_samples_all(ii) = height(noisyObjects);
        overviewGazes.noData_samples_all(ii) = height(noDataTable);
        overviewGazes.dataLength_all(ii) = height(dataTable_all);

        overviewGazes.Sum_GazeDuration_all(ii) = sum([gazedObjects.durations],'omitnan');
        overviewGazes.Sum_NoiseDuration_all(ii) = sum([noisyObjects.durations],'omitnan');
        overviewGazes.Sum_NoDataDuration_all(ii) = sum([noDataTable.durations],'omitnan');
        overviewGazes.Sum_AllDurations_all(ii) = sum([dataTable_all.durations],'omitnan');

        overviewGazes.gaze_samples_buildings(ii) = height(gazedObjects_buildings);
        overviewGazes.noise_samples_buildings(ii) = height(noisyObjects_buildings);
        overviewGazes.dataLength_buildings(ii) = height(housesTable);

        overviewGazes.SumGazeDuration_buildings(ii) = sum([gazedObjects_buildings.durations],'omitnan');
        overviewGazes.SumNoiseDuration_buildings(ii) = sum([noisyObjects_buildings.durations],'omitnan');
        overviewGazes.SumAllDurations_buildings(ii) = sum([housesTable.durations],'omitnan');
        
%         figure(1)
%         pieplot= pie([sumG,sumN]);
%         legend({'gazes / bigger 7 samples','noise / smaller/equal 7 samples'},'Location','northeastoutside')
%         title(strcat('gazes noise distribution - participant: ', num2str(currentPart)))
%         savefig(gcf, strcat(savepath, num2str(currentPart) ,'_gazes_noise_distr.fig'));
%         
%         %saveas(gcf,strcat(savepath, num2str(currentPart) ,'_gazes_noise_distr.png'),'png');
%         print(gcf,strcat(savepath, num2str(currentPart) ,'_gazes_noise_distr.png'),'-dpng','-r300'); 
%         

     
  
        toc
        
    else
        disp('something went really wrong with participant list');
    end

end

%% plot pie plot of distribution gazes vs noise


%% all data pies
% Define the labels for the pie chart
labels = {'Gazes Nr', 'notGazes Nr', 'Invalid Nr'};

% Define the colors for the pie chart
colors = [
    1, 0.6, 0.6;   % #ff9999 (light red)
    0.4, 0.7, 1;   % #66b3ff (light blue)
    0.5, 0.5, 0.5  % grey
];

plotData = sum(overviewGazes{:,2:4});
% Plot the pie chart
figure(1)

pieplot1 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise noData sample number distribution (sum) - all data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot1(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end

saveas(gcf,strcat(savepath,'gazes noise noData sample number distribution (sum) - all data.png'),'png');



% mean all data
plotData = mean(overviewGazes{:,2:4});

figure(2)

pieplot2 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise noData sample number distribution (mean) - all data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot2(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end
saveas(gcf,strcat(savepath,'gazes noise noData sample number distribution (mean) - all data.png'),'png');


%% duration data pies all data
% Define the labels for the pie chart
labels = {'Gazes durations', 'notGazes durations', 'Invalid durations'};

% Define the colors for the pie chart
colors = [
    1, 0.6, 0.6;   % #ff9999 (light red)
    0.4, 0.7, 1;   % #66b3ff (light blue)
    0.5, 0.5, 0.5  % grey
];

plotData = sum(overviewGazes{:,6:8});
% Plot the pie chart
figure(3)

pieplot3 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise noData sample duration distribution (sum) - all data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot3(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end
saveas(gcf,strcat(savepath,'gazes noise noData sample duration distribution (sum) - all data.png'),'png');



% mean all data
plotData = mean(overviewGazes{:,6:8});

figure(4)

pieplot4 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise noData sample duration distribution (mean) - all data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot4(2*i-1).FaceColor = colors(i,:);
    % pieplot4(2*i).String = sprintf('%s (%.1f%%)', labels{i}, plotData(i));
end
saveas(gcf,strcat(savepath,'gazes noise noData sample duration distribution (mean) - all data.png'),'png');


%%  now only considering gazes on buildings - start with sample numbers

labels = {'Gazes Nr', 'notGazes Nr'};

plotData = sum(overviewGazes{:,10:11});
% Plot the pie chart
figure(5)

pieplot5 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise sample number distribution (sum) - only building data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot5(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end

saveas(gcf,strcat(savepath,'gazes noise sample number distribution (sum) - only building data.png'),'png');


% mean all data
plotData = mean(overviewGazes{:,10:11});

figure(6)

pieplot6 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise sample number distribution (mean) - only building data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot6(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end
saveas(gcf,strcat(savepath,'gazes noise sample number distribution (mean) - only building data.png'),'png');



%% duration data pies only building data
% Define the labels for the pie chart
labels = {'Gazes durations', 'notGazes durations'};


plotData = sum(overviewGazes{:,13:14});
% Plot the pie chart
figure(7)

pieplot7 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise sample duration distribution (sum) - only building data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot7(2*i-1).FaceColor = colors(i,:);
    % h(2*i).String = sprintf('%s (%.1f%%)', labels{i}, mean_sums(i));
end

saveas(gcf,strcat(savepath,'gazes noise sample duration distribution (sum) - only building data.png'),'png');


% mean all data
plotData = mean(overviewGazes{:,13:14});

figure(8)

pieplot8 = pie(plotData);

legend(labels, 'Location','southoutside')
title('gazes noise sample duration distribution (mean) - only building data')

% Customize the colors and labels
for i = 1:length(plotData)
    pieplot8(2*i-1).FaceColor = colors(i,:);
    % pieplot4(2*i).String = sprintf('%s (%.1f%%)', labels{i}, plotData(i));
end
saveas(gcf,strcat(savepath,'gazes noise sample duration distribution (mean) - only building data.png'),'png');


%%

% 
% 
% avgG = mean(overviewGazes.SumGazeDuration);
% avgN = mean(overviewGazes.SumNoiseDuration);
% 
% figure(2)
% pieplot2 = pie([avgG, avgN]);
% legend({'gazes - no NH, nodata / bigger 266,6 samples','noise / smaller/equal 266,6 samples'},'Location','northeastoutside')
% title('mean gazes noise distribution')
% 
% saveas(gcf,strcat(savepath,'mean_gazes_noise_distr_NHND.png'),'png');
% print(gcf,strcat(savepath,'mean_gazes_noise_distr.png_NHND'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'mean_gazes_noise_distr_NHND.fig'));
% 
% percentage = NaN(Number,2);
% 
% percentage(:,1) = (overviewGazes.SumGazeDuration*100) ./ overviewGazes.SumAllDurations;
% percentage(:,2) = (overviewGazes.SumNoiseDuration*100) ./ overviewGazes.SumAllDurations;
% 
figure(9)

plotty3 = bar(overviewGazes.Sum_NoDataDuration_all ./ overviewGazes.Sum_AllDurations_all);
title('percentage of invalid data distribution over all participants')
ylabel('percentage')

saveas(gcf,strcat(savepath,'percentage of invalid data distribution over all participants.png'),'png');

% 
% saveas(gcf,strcat(savepath,'perc_noisy_data_distr_allParts.png'),'png');
% 
% print(gcf,strcat(savepath,'perc_noisy_data_distr_allParts.png'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'perc_noisy_data_distr_allParts.fig'));


%% distribution of cluster sizes over all participants
figure(10)

binWidth = 1/90;
histyAll = histogram(allDurations_buildings, 'Normalization', 'probability');
yt = get(gca, 'YTick');  
xt = get(gca, 'XTick');
% set(gca, 'YTick',yt, 'YTickLabel',yt*100);
% set(gca, 'XTick',xt, 'XTickLabel',xt*33.33);

ax = gca;
ax.XLabel.String = 'Distribution of hit point clusters (time in ms)';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'Probability';
ax.YLabel.FontSize = 12;
xlim([0,1000])
xline(266.6, 'r--', 'LineWidth', 2);

title('Distribution of hit point clusters - building data')

saveas(gcf,strcat(savepath,'Distribution of hit point clusters - building data.png'),'png');


%% matching boxplot to new processing

data2plot = sum(overviewGazes.dataLength_all);

figure(11)

% Create the boxchart
plotty10 = boxchart([overviewGazes.dataLength_all, overviewGazes.gaze_samples_all, overviewGazes.gaze_samples_buildings]);

% Change the y-axis tick format to display full numbers
ax = gca;
yticks = ax.YTick;
ax.YTickLabel = arrayfun(@(y) num2str(y, '%.0f'), yticks, 'UniformOutput', false);

% Adjust x-ticks to match the categories
xticklabels({'data length', 'gazes all', 'gazes buildings'});

% Optionally add labels and title
xlabel('Samples/Clusters');
title('All Prarticipants data length and gaze samples/clusters');

saveas(gcf,strcat(savepath,'All Prarticipants data length and gaze samples clusters.png'),'png');


% saveas(gcf,strcat(savepath,'viewing_duration_all_NHND.png'),'png');
% 
% print(gcf,strcat(savepath,'viewing_duration_all_NHND.png'),'-dpng','-r300'); 
% savefig(gcf, strcat(savepath,'viewing_duration_all_NHND.fig'));
% 
% %% plot durations
% 
% % big30= allSamples > 1000;
% % 
% % combSamples = allSamples;
% % combSamples(big30) = 1001;
% % 
% % figure(5)
% % 
% % histyCombined = histogram(combSamples,'Normalization','probability');
% % yt = get(gca, 'YTick');                    
% % % set(gca, 'YTick',yt, 'YTickLabel',yt*100);
% % % xt= [1:3:31];
% % % set(gca, 'XTick',xt, 'XTickLabel',xt*33.33);
% % 
% % ax = gca;
% % ax.XLabel.String = 'Distribution of hit point clusters (time in ms)';
% % ax.XLabel.FontSize = 12;
% % ax.YLabel.String = 'Probability';
% % ax.YLabel.FontSize = 12;
% 
% % saveas(gcf,strcat(savepath,'viewing_duration_bigCombined.png'),'png');
% 
% % print(gcf,strcat(savepath,'viewing_duration_bigCombined.png'),'-dpng','-r300'); 
% % savefig(gcf, strcat(savepath,'viewing_duration_bigCombined.fig'));
% 
% save overviews
save([savepath 'Overview_Gazes_NHND.mat'],'overviewGazes');
% save([savepath 'allInterpolatedData.mat'],'allInterpData');
save([savepath 'allSamples_int_NHND.mat'],'allDurations_buildings');





disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countAnalysedPart), ' Participants analyzed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');



disp('done');