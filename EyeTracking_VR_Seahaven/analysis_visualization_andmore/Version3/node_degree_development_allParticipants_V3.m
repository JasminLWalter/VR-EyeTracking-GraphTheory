%% ------------------ node_degree_development_allParticipants_V3-------------------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\time_development\nodeDegree_development\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\time_development\nodeDegree_development\individual_files\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

houseList = load('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\HouseList.mat');
houseList = houseList.houseList;


RCHouseList = readtable("E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\RC_HouseList.csv");

sortedRCL = sortrows(RCHouseList,'RCCount','ascend');

housesTop10RC = sortedRCL{end-9:end,1};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

% variables to analyse file length, synchronization points etc.
nrVariables = [];
endPoints = [];
normAvgPoints = [];
normAvgEndPoints = [];

% struct to store all degree development data from all participants
structDataSess1 = struct;
structDataSess2 = struct;
structDataSess3 = struct;

 for index = 1: length(houseList)
        structDataSess1(index).House = houseList(index);
        structDataSess1(index).Data = NaN(Number,31);
        structDataSess1(index).Avg = NaN(1,31);
        
        structDataSess2(index).House = houseList(index);
        structDataSess2(index).Data = NaN(Number,31);
        structDataSess2(index).Avg = NaN(1,31);
        
        structDataSess3(index).House = houseList(index);
        structDataSess3(index).Data = NaN(Number,31);
        structDataSess3(index).Avg = NaN(1,31);
 end


for ii = 1:Number
    
    currentPart = cell2mat(PartList(ii));
    

        
    % load data
    sess1 = load(strcat(num2str(currentPart),'_degreeDevelopment_Session1.mat')).degreeDevelopment;
    sess2 = load(strcat(num2str(currentPart),'_degreeDevelopment_Session2.mat')).degreeDevelopment;
    sess3 = load(strcat(num2str(currentPart),'_degreeDevelopment_Session3.mat')).degreeDevelopment;

    nrVariables = [nrVariables, width(sess1)-1, width(sess2)-1, width(sess3)-1];
    endPoints = [endPoints, sess1{1,end},sess2{1,end},sess3{1,end}];

    for index = 2:width(sess1)
        time = 60*(index-1);
        normEndPoint = sess1{1,index} - time;

        if (index == width(sess1))
            normAvgEndPoints = [normAvgEndPoints, normEndPoint];
        else
            normAvgPoints = [normAvgPoints, normEndPoint];
        end
    end

    for index = 2:width(sess2)
        time = 60*(index-1);
        normEndPoint = sess2{1,index} - time;

        if (index == width(sess2))
            normAvgEndPoints = [normAvgEndPoints, normEndPoint];
        else
            normAvgPoints = [normAvgPoints, normEndPoint]; 
        end
    end
    for index = 2:width(sess3)
        time = 60*(index-1);
        normEndPoint = sess3{1,index} - time;

        if (index == width(sess3))
            normAvgEndPoints = [normAvgEndPoints, normEndPoint];
        else
            normAvgPoints = [normAvgPoints, normEndPoint];  
        end
    end

    %% save all node degree development values
    % every session has 30 synchronization points, and all data exceeding 30
    % will be summarized in a 31 synchronization point
    
    for index = 1: length(houseList)
       
        structDataSess1(index).Data(ii,:)= [sess1{index+1, 2:31}, sess1{index+1, end}];
        structDataSess2(index).Data(ii,:)= [sess2{index+1, 2:31}, sess2{index+1, end}];
        structDataSess3(index).Data(ii,:)= [sess3{index+1, 2:31}, sess3{index+1, end}];
        
    end
    
    
    
end

%% plot the file length analysis
figure(1)
plotty1 = histogram(nrVariables, 'FaceColor',[0.27,0.38,0.99]);
%title('Number of synchronization markers')
xlabel('synchronization marker')
ylabel('occurance')

figure(2)
plotty2 = histogram(endPoints/60,'FaceColor',[0.27,0.38,0.99]);
%title('Session length in minutes')
xlabel('session length (min)')
ylabel('occurrence')

figure(3)
plotty3 = histogram(normAvgPoints,'FaceColor',[0.27,0.38,0.99],'Normalization','probability');
%title('Accuracy of synchronization')
xlabel('difference to synchronization marker (seconds)')
ylabel('probability')





%% average all node degree values

avgOverviewSess1 = nan(213,31);
avgOverviewSess2 = nan(213,31);
avgOverviewSess3 = nan(213,31);

for index = 1: length(houseList)

    structDataSess1(index).Avg= mean(structDataSess1(index).Data,'omitnan');
    structDataSess2(index).Avg= mean(structDataSess2(index).Data,'omitnan');
    structDataSess3(index).Avg= mean(structDataSess3(index).Data,'omitnan');
    
    avgOverviewSess1(index,:) = mean(structDataSess1(index).Data,'omitnan');
    avgOverviewSess2(index,:) = mean(structDataSess2(index).Data,'omitnan');
    avgOverviewSess3(index,:) = mean(structDataSess3(index).Data,'omitnan');

end

overallMean1 = mean(avgOverviewSess1, 'omitnan');
overallMean2 = mean(avgOverviewSess2, 'omitnan');
overallMean3 = mean(avgOverviewSess3, 'omitnan');

overallStd1 = std(avgOverviewSess1, 'omitnan');
overallStd2 = std(avgOverviewSess2, 'omitnan');
overallStd3 = std(avgOverviewSess3, 'omitnan');

above1 = overallMean1  + overallStd1;
below1 = overallMean1  - overallStd1;

above2 = overallMean2  + overallStd2;
below2 = overallMean2  - overallStd2;

above3 = overallMean3  + overallStd3;
below3 = overallMean3  - overallStd3;

above2x1 = overallMean1  + (2*overallStd1);
below2x1 = overallMean1  - (2*overallStd1);

above2x2 = overallMean2  + (2*overallStd2);
below2x2 = overallMean2  - (2*overallStd2);

above2x3 = overallMean3  + (2*overallStd3);
below2x3 = overallMean3  - (2*overallStd3);

figure(4)

for index = 1:length(houseList)
    
    if (ismember(structDataSess1(index).House,housesTop10RC))
        plotty4 = plot([structDataSess1(index).Avg,structDataSess2(index).Avg,structDataSess3(index).Avg],'LineWidth',0.7);    
        hold on
        
    else
    
        col = rand(1);
        while (col < 0.25 | col > 0.8)
            col = rand(1);
        end
        plotty4 = plot([structDataSess1(index).Avg,structDataSess2(index).Avg,structDataSess3(index).Avg],'Color',[col col col],'LineWidth',0.1);    
        hold on
    end
end

plotty5 = plot([overallMean1,overallMean2,overallMean3],'Color', [1.00,0.58,0.00],'LineWidth',2);
plotty6 = plot([above1,above2,above3],'Color', [0.27,0.38,0.99 ],'LineWidth',2);
plotty7 = plot([below1,below2,below3],'Color', [0.27,0.38,0.99 ],'LineWidth',2);

plotty8 = plot([above2x1,above2x2,above2x3],'Color', [0.40,0.80,0.42],'LineWidth',2);

plotty9 = plot([31,31],[0,25],'k','LineWidth',1, 'LineStyle','--');
plotty10 = plot([62,62],[0,25],'k','LineWidth',1, 'LineStyle','--');

%plotty5 = plot(below2,'g','LineWidth',2);
xlabel('time (min)')
ylabel('mean node degree')
title('Average node degree development of all houses')


        
        
        
        
        
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');