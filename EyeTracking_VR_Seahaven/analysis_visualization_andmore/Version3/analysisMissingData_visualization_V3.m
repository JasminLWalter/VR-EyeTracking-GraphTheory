%% -----------------analyseMissingData_visualization----------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------




clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\missingData\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\missingData\'

beforeInterpolation = load('missingDataOverview_beforeInterpolation').missingDataOverview;
afterInterpolation = load('missingDataOverview_afterInterpolation').missingDataOverview;

%------------------------ before Interpolation analysis---------------
bigger31 = beforeInterpolation.Samples > 10;
beforeInterpolation{bigger31, 1} = 11;

bdiff = strcmp(beforeInterpolation.SameDiff, 'diff');

bDiffOverview = beforeInterpolation(bdiff,:);
bSameOverview = beforeInterpolation(not(bdiff),:);

bDiffArray = zeros(2,31);
bSameArray= zeros(2,31);

for index = 1: 31
    
    countDiff= bDiffOverview.Samples == index;
    numDiff = sum(countDiff);
    bDiffArray(1,index) = index;
    bDiffArray(2,index) = numDiff;
    
    countSame= bSameOverview.Samples == index;
    numSame = sum(countSame);
    bSameArray(1,index) = index;
    bSameArray(2,index) = numSame;
end

figure(1)
plotty1 = bar([bSameArray(2,:)',bDiffArray(2,:)'],'stacked');
legend('cluster between same colliders', 'cluster between different colliders');
xlim([0, 12]);
%title('Distribution of missing data clusters before interpolation')
xlabel('cluster size')
ylabel('occurrence - sum all participants')

%------------------------ after Interpolation analysis---------------
bigger31 = afterInterpolation.Samples > 10;
afterInterpolation{bigger31, 1} = 11;

adiff = strcmp(afterInterpolation.SameDiff, 'diff');

aDiffOverview = afterInterpolation(adiff,:);
aSameOverview = afterInterpolation(not(adiff),:);

aDiffArray = zeros(2,31);
aSameArray= zeros(2,31);

for index = 1: 31
    
    countDiff= aDiffOverview.Samples == index;
    numDiff = sum(countDiff);
    aDiffArray(1,index) = index;
    aDiffArray(2,index) = numDiff;
    
    countSame= aSameOverview.Samples == index;
    numSame = sum(countSame);
    aSameArray(1,index) = index;
    aSameArray(2,index) = numSame;
end

figure(2)
plotty2 = bar([aSameArray(2,:)',aDiffArray(2,:)'],'stacked');
legend('cluster between same colliders', 'cluster between different colliders');
ylim([0,120000]);
xlim([0, 12]);
%title('Distribution of missing data clusters after interpolation')
xlabel('cluster size')
ylabel('occurrence - sum all participants')

disp('done');