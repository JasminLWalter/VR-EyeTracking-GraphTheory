%% ------------------ triangulation_development_visualization_V3-------------------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\triangulation\DevelopmentAnalysis\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\triangulation\DevelopmentAnalysis\'

triOverview = load('triOverviewDevelopment');
triOverview = triOverview.triOverview;

length1 = [];
length2 = [];
length3 = [];
for index = 1:length(triOverview)
    length1 = [length1,length(triOverview(index).Session1)];
    length2 = [length2,length(triOverview(index).Session2)];
    length3 = [length3,length(triOverview(index).Session3)];
end

max1 = max(length1);
max2 = max(length2);
max3 = max(length3);

array1 = zeros(length(triOverview), max1);
array2 = zeros(length(triOverview), max2);
array3 = zeros(length(triOverview), max3);

for index2 = 1:length(triOverview)
    array1(index2, 1:length(triOverview(index2).Session1)) = triOverview(index2).Session1 +1;
    array2(index2, 1:length(triOverview(index2).Session2)) = triOverview(index2).Session2 +1;
    array3(index2, 1:length(triOverview(index2).Session3)) = triOverview(index2).Session3 +1;
end

allSessions = [array1, array2, array3];

colormap3 = [
    0.15,0.15,0.15
    0.24,0.15,0.66
    0.18,0.77,0.64
    0.97,0.85,0.17];

figure(1)
plotty = imagesc(allSessions);
colormap(colormap3);
colorbar('Ticks',[0.35,1,2, 2.65], 'TickLabels',{'no data','0 houses','1 house','2 or more houses'})
xlabel('Time (samples)')
ylabel('Participants')


