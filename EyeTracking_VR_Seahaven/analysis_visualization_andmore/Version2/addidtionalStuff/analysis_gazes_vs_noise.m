%% ------------------analysis_gazes_vs_noise----------------------------------------
% script written by Jasmin Walter

% divides condensed viewed houses list based on a set min sample value into 
% objects that were gazed at and objects that were not gazed at (noisy
% samples)
% in other words: devides condensed viewed houses list into ganzed houses
% and noise

% uses condensedViewedHouses file as input
% output: list with glanced houses per subject -> objects that were gazed at
%         list with noisy sample objects per subject -> objects that were
%         not gazed on
%         overall overview with percentage of gazed/noisy object list


clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\gazes_noise_distribution\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\interpolateLostData\'

% participant list of 90 min VR - only with participants who have lost less than 30% of
% their data (after running script cleanParticipants_V2)
%PartList = {1909 3668 8466 2151 4502 7670 8258 3377 9364 6387 2179 4470 6971 5507 8834 5978 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 3856 7942 6594 4510 3949 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 9961 9017 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593};

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedPart= 0;

overviewGazes = array2table(zeros(Number,4));
overviewGazes.Properties.VariableNames = {'Participant','totalAmount','gazes','noise'};
overviewSums= NaN(Number,3);
allSamples = [];


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_interpolatedViewedHouses.mat');
    
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        countAnalysedPart = countAnalysedPart +1;
        % load data
        interpolatedData = load(file);
        interpolatedData = interpolatedData.interpolatedData;
        
        % something was fixated when having more than 7 samples
        allSamples = [allSamples; interpolatedData.Samples];

        gazes = interpolatedData.Samples > 7;

        
        gazedObjects = interpolatedData(gazes,:);
        
        noisyObjects = interpolatedData(not(gazes),:);
              
        
        sumG = sum(gazedObjects.Samples);
        sumN = sum(noisyObjects.Samples);
        overviewSums(ii,1) = sumG;
        overviewSums(ii,2) = sumN;
        overviewSums(ii,3) = sum(interpolatedData.Samples);
        
        figgy1 = figure('Position', get(0, 'Screensize'));
        F = getframe(figgy1);
        
        pieplot= pie([sumG,sumN]);
        legend({'gazes / bigger 7 samples','noise / smaller/equal 7 samples'},'Location','northeastoutside')
        title(strcat('gazes noise distribution - participant: ', num2str(currentPart)))
        
        %saveas(gcf,strcat(savepath, num2str(currentPart) ,'_gazes_noise_distr.png'),'png');
       

     
  

        
    else
        disp('something went really wrong with participant list');
    end

end

avgG = mean(overviewSums(:,1));
avgN = mean(overviewSums(:,2));

figure(2)
pieplot2 = pie([avgG, avgN]);
legend({'gazes / bigger 7 samples','noise / smaller/equal 7 samples'},'Location','northeastoutside')
title('mean gazes noise distribution')

saveas(gcf,strcat(savepath,'mean_gazes_noise_distr.png'),'png');

percentage = NaN(Number,2);

percentage(:,1) = (overviewSums(:,1)*100) ./ overviewSums(:,3);
percentage(:,2) = (overviewSums(:,2)*100) ./ overviewSums(:,3);

figure(3)

plotty3 = boxplot(percentage(:,2));
title('percentage of noisy data distribution over all participants')
ylabel('percentage')

saveas(gcf,strcat(savepath,'perc_noisy_data_distr_allParts.png'),'png');

%% duration statistics
figure(4)

histy= histogram(allSamples,'Normalization','probability');
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);

ax = gca;
ax.XLabel.String = 'amount of consecutive samples';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'percentage';
ax.YLabel.FontSize = 12;
saveas(gcf,strcat(savepath,'viewing_duration_all.png'),'png');

% big durations combined

big30= allSamples > 30;

combSamples = allSamples;
combSamples(big30) = 31;

figure(5)

histy2 = histogram(combSamples,'Normalization','probability');
yt = get(gca, 'YTick');                    
set(gca, 'YTick',yt, 'YTickLabel',yt*100);
xt= [1:3:31];
set(gca, 'XTick',xt, 'XTickLabel',xt*33.33);

ax = gca;
ax.XLabel.String = 'amount of consecutive samples (all samples > 30 combined in bin 31)';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'frequency';
ax.YLabel.FontSize = 12;

saveas(gcf,strcat(savepath,'viewing_duration_bigCombined.png'),'png');



disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countAnalysedPart), ' Participants analyzed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

save([savepath 'Overview_Gazes.mat'],'overviewGazes');
disp('saved Overview Gazes');

disp('done');