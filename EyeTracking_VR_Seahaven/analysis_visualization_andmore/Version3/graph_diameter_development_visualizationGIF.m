%% ------------------ graph_diameter_development_visualizationGIF-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\GIF_diameter_development\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\time_development\diameter\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};



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


structDataSess1.Data = NaN(Number,31);
        
structDataSess2.Data = NaN(Number,31);
       
structDataSess3.Data = NaN(Number,31);

for ii = 1:Number
    
    currentPart = cell2mat(PartList(ii));
    

        
    % load data
    sess1 = load(strcat(num2str(currentPart),'_diameterDevelopment_Session1.mat')).diameterDevelopment;
    sess2 = load(strcat(num2str(currentPart),'_diameterDevelopment_Session2.mat')).diameterDevelopment;
    sess3 = load(strcat(num2str(currentPart),'_diameterDevelopment_Session3.mat')).diameterDevelopment;

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
       
    structDataSess1.Data(ii,:)= [sess1{2, 1:30}, sess1{2, end}];
    structDataSess2.Data(ii,:)= [sess2{2, 1:30}, sess2{2, end}];
    structDataSess3.Data(ii,:)= [sess3{2, 1:30}, sess3{2, end}];

    
    
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


meanDiameter1 = mean(structDataSess1.Data);
meanDiameter2 = mean(structDataSess2.Data);
meanDiameter3 = mean(structDataSess3.Data);

for index2 = 1: Number    
    col = rand(1);
    while (col < 0.25 | col > 0.8)
        col = rand(1);
    end
    plotty = plot([1:1:93],[structDataSess1.Data(index2,:),structDataSess2.Data(index2,:),structDataSess3.Data(index2,:)],'Color',[col col col],'LineWidth',0.1);    
    hold on
    plotty2 = plot([1:1:93], [meanDiameter1, meanDiameter2, meanDiameter3], 'red','LineWidth',1);
        
end

hold off

allSessData = [structDataSess1.Data,structDataSess2.Data,structDataSess3.Data];

for index3 = 1: Number
    plotT = allSessData;
    plotT(index3,:) = [];
    
    figure(2)
    for index2 = 1: height(plotT)
        plotty3 = plot([1:1:93],plotT(index2,:),'color',[0.75,0.75,0.75],'LineWidth',0.1);
        hold on
        
    end
    
    plotty4 = plot(allSessData(index3,:),'blue','LineWidth',1);
    
    plotty2 = plot([1:1:93], [meanDiameter1, meanDiameter2, meanDiameter3], 'red','LineWidth',1);
        
    
    saveas(gcf, strcat(savepath, num2str(index3),'_img.png')); 
    hold off
    
end



