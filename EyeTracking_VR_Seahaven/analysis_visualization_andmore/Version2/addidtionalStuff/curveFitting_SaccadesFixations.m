%% ------------------analysis_gazes_vs_noise----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\curveFitting\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\gazes_noise_distribution\'


allInterpData = load('allInterpolatedData.mat');

allInterpData = allInterpData.allInterpData;

figure(1)

histy= histogram(allInterpData.Samples,'Normalization','probability');%,'DisplayStyle','stairs'
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);

ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;

%hold on



bigger7 = allInterpData.Samples > 7;

bigger7D = allInterpData.Samples(bigger7);
smaller7D = allInterpData.Samples(not(bigger7));

pdfBigger = gampdf(bigger7D,  1.7898, 13.4959);
xB2 = linspace(8,length(bigger7D),length(pdfBigger));

figure(2)

plotty2 = plot(bigger7D',pdfBigger);

% y = gampdf(x,a,b) 

% pdf=gampdf(X,alpha,beta); % pdf of the gamma distribution
%Plot(pdf,X,'-');



% 
% %% without noData
% 
% noData = strcmp('noData',allInterpData.House);
% 
% cleanD = allInterpData(not(noData),:);
% noiseD = allInterpData(noData,:);
% 
% figure(2)
% histy2= histogram(cleanD.Samples,'Normalization','probability','DisplayStyle','stairs');
% yt = get(gca, 'YTick');                    
% set(gca, 'YTick',yt, 'YTickLabel',yt*100);
% 
% ax = gca;
% ax.XLabel.String = 'amount of consecutive samples';
% ax.XLabel.FontSize = 12;
% ax.YLabel.String = 'percentage';
% ax.YLabel.FontSize = 12;
% 
% histy3= histogram(noiseD.Samples,'Normalization','probability','DisplayStyle','stairs');
% yt = get(gca, 'YTick');                    
% set(gca, 'YTick',yt, 'YTickLabel',yt*100);
% 
% ax = gca;
% ax.XLabel.String = 'amount of consecutive samples';
% ax.XLabel.FontSize = 12;
% ax.YLabel.String = 'percentage';
% ax.YLabel.FontSize = 12;





% %% gamma distr. estimation

sorted = sortrows(allInterpData,3);

sorted.X = [1:1:height(sorted)]';

bigger7 = sorted.Samples > 7;

smallerD = sorted(not(bigger7),:);
biggerD = sorted(bigger7,:);



ybigger = gamfit(biggerD.Samples);
gammaB = gampdf(biggerD.Samples, ybigger(1,1), ybigger(1,2)); 

ysmaller = gamfit(smallerD.Samples);
gammaS = gampdf(smallerD.Samples, ysmaller(1,1), ysmaller(1,2)); 



%pdf = gampdf(allInterpData.Samples, yvalue(1,1), yvalue(1,2)); 
%maxText = max(allInterpData.Samples);
xB = max(biggerD.Samples): 1 : max(allInterpData.Samples);
xS = 1:1:max(smallerD.Samples);

%gammaD = gampdf(x,yvalue(1,1),yvalue(1,2));

figure(3)

plottyB = plot(biggerD.Samples, gammaB);

hold on

plottyS = plot(smallerD.Samples,gammaS);

% 
 disp('done');