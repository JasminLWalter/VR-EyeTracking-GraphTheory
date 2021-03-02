%% ------------------ evaluate viewing space Version 3-------------------------------------
% script written by Jasmin Walter

% evaluates viewing space overview created in measure_viewing_space_V3

clear all;

savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\viewingSpace\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\viewingSpace\'

% load overview
overviewVS = load('overview_ViewingSpaceV3.mat');
overviewVS = overviewVS.overviewVS;

% load top 10 house list
RCHouseList = readtable("E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\RC_HouseList.csv");

sortedRCL = sortrows(RCHouseList,'RCCount','ascend');

housesTop10RC = sortedRCL{end-9:end,1};

% create percentage overview
overviewPct = overviewVS;
overviewPct{1:end-1,2} = overviewPct{1:end-1,2}/overviewPct{end,2};
overviewPct{1:end-1,3} = overviewPct{1:end-1,3}/overviewPct{end,3};
overviewPct{1:end-1,4} = overviewPct{1:end-1,4}/overviewPct{end,4};
overviewPct{1:end-1,5} = overviewPct{1:end-1,5}/overviewPct{end,5};

% plot boxplots
figure(1)
plottyAll = boxplot(overviewPct{1:end-1,2:end});

x = rand([1,height(overviewPct)-1]);
x2 = ones([1,height(overviewPct)-1]);

h10 = ismember(overviewPct.House(1:end-1),housesTop10RC);
c = x2;
c(h10) = 2;

% plot scatter plots

figure(2)
plotty2 = scatter(x2,overviewPct{1:end-1,2},30,c,'filled', 'jitter', 'on', 'jitterAmount', 0.5);
xlim([0,11]);
hold on

plotty3 = scatter(x2+3,overviewPct{1:end-1,3},30,c,'filled', 'jitter', 'on', 'jitterAmount', 0.5);

plotty4 = scatter(x2+6,overviewPct{1:end-1,4},30,c,'filled', 'jitter', 'on', 'jitterAmount', 0.5);

plotty5 = scatter(x2+9,overviewPct{1:end-1,5},30,c,'filled', 'jitter', 'on', 'jitterAmount', 0.5);


