%% ------------------ task_repetition_variance_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables:  

savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\RepetitionAnalysis\';

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];
%% load data

dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
dataP2B_withoutRep = readtable('overviewTable_P2B_Prep_complete_withoutReps.csv');

dataP2B.TrialTime = dataP2B.TimeStampBegin;

% load trial id table

stCombiIds = load('uniqueTrials_routeID.mat');
stCombiIds = stCombiIds.uniqueTrials;

% overall mean in pointing error / in duration for each participant
overviewDiffReps = table;


% how error and duration changes over the time of the task


for index = 1:length(PartList)
    
     currentPart = PartList(index);   
    
     selectionPart = currentPart == dataP2B.SubjectID;
     
     
     selectionTrial1 = dataP2B.TrialOrder == 1;
     selectionTrial2 = dataP2B.TrialOrder == 2;
     
     overviewDiffReps.Participant(index) = currentPart;
     
     % trial 1
     overviewDiffReps.MeanError_Trial_1(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceError_Trial_1(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));

     overviewDiffReps.MeanDuration_Trial_1(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceDuration_Trial_1(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial1));

     % trial 2
     overviewDiffReps.MeanError_Trial_2(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceError_Trial_2(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));

     overviewDiffReps.MeanDuration_Trial_2(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceDuration_Trial_2(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial2));
   
     
     startTS = min(dataP2B.TimeStampBegin(selectionPart));
     dataP2B.TrialTime(selectionPart) = dataP2B.TrialTime(selectionPart)-startTS; 
     
     
     for indexTrial = 1:112
         
         minTrial = min(dataP2B.TrialTime(selectionPart));
         minIndex = dataP2B.TrialTime == minTrial;
         
         dataP2B.TrialSequence(minIndex) = indexTrial;
         
         selectionPart = selectionPart & not(minIndex); 
         
     end

     
end

for index2 = 1:height(dataP2B_withoutRep)
   
    currentPart = dataP2B_withoutRep.SubjectID(index2);
    currentSTcombi = dataP2B_withoutRep.RouteID(index2);
    
    selectionPart = dataP2B.SubjectID == currentPart;
    selectionSTC = strcmp(dataP2B.RouteID, currentSTcombi);
    selectionOrder1 = dataP2B.TrialOrder == 1;
    selectionOrder2 = dataP2B.TrialOrder == 2;
    
    error1 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder1);
    error2 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder2);

    dataP2B_withoutRep.ErrorDiff(index2) = error1-error2;

end

%% distribution differences between first and second task trial reps
% figure 1
figure(1)


plotty1 = histogram(dataP2B_withoutRep.ErrorDiff);
title({'Difference in pointing error between repetitions', 'error 1 - error 2'})

ylabel('frequency')
xlabel('angular error difference')

saveas(gcf, strcat(savepath, 'Difference in pointing error between repetitions', 'error 1 - error 2.png'));


% figure 2
edges = [0:10:100];
figure(2)
plotty2 = histogram(overviewDiffReps.MeanError_Trial_1,edges,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty2b= histogram(overviewDiffReps.MeanError_Trial_2,edges,'FaceColor','g', 'FaceAlpha',0.5);
title({'Mean pointing error over trials','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('angular error')

hold off

saveas(gcf, strcat(savepath, 'Mean pointing error over trials','blue = rep 1, green = rep 2.png'));

% figure 3
figure(3)
plotty3 = histogram(overviewDiffReps.MeanDuration_Trial_1,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty3b= histogram(overviewDiffReps.MeanDuration_Trial_2,'FaceColor','g', 'FaceAlpha',0.5);
title({'Mean trial duration over trials','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('trial duration')

hold off

saveas(gcf, strcat(savepath, 'Mean trial duration over trials blue = rep 1, green = rep 2.png'));

% figure 4
figure(4)
edges4 = [0:5:180];
plotty2 = histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 1),edges4,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty2b= histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 2),edges4,'FaceColor','g', 'FaceAlpha',0.5);
title({'All angular pointing error separated by trial order','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('angular error')

hold off

saveas(gcf, strcat(savepath, 'All angular pointing error separated by trial order.png'));


% plot 5

figure(5)
edges5 = [0:1:30];
plotty3 = histogram(dataP2B.TrialDuration(dataP2B.TrialOrder == 1),edges5,'FaceColor','b', 'FaceAlpha',0.5);
hold on

plotty3b= histogram(dataP2B.TrialDuration(dataP2B.TrialOrder == 2),edges5,'FaceColor','g', 'FaceAlpha',0.5);
title({'All trial durations separated by trial order','blue = rep 1, green = rep 2'})
ylabel('frequency')
xlabel('trial duration')

hold off

saveas(gcf, strcat(savepath, 'All trial durations separated by trial order.png'));

%% 

% figure 6
figure(6)
for index3 = 1:26
    
   currentPart = PartList(index3);
   
   selection = dataP2B.SubjectID == currentPart;
   
   plotty4 = scatter(dataP2B.TrialTime(selection),dataP2B.TrialDuration(selection),20,'filled');
   hold on
   
   
   
end
title('Trial duration over task time')

xlim([0,6000])


p = polyfit(dataP2B.TrialTime,dataP2B.TrialDuration, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, dataP2B.TrialTime);

% Add regression line to plot
plot(dataP2B.TrialTime, yfit, 'r-')

hold off

saveas(gcf, strcat(savepath, 'Trial duration over task time.png'));

% figure 7
figure(7)
for index3 = 1:26
    
   currentPart = PartList(index3);
   
   selection = dataP2B.SubjectID == currentPart;
   
   plotty4 = scatter(dataP2B.TrialTime(selection),dataP2B.RecalculatedAngle(selection),20,'filled');
   hold on
   
   
   
end
title('Pointing error over task time')


xlim([0,6000])

p = polyfit(dataP2B.TrialTime,dataP2B.RecalculatedAngle , 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, dataP2B.TrialTime);

% Add regression line to plot
plot(dataP2B.TrialTime, yfit, 'r-')
hold off

saveas(gcf, strcat(savepath, 'Pointing error over task time.png'));

% figure 8
figure(8)
for index3 = 1:26
    
   currentPart = PartList(index3);
   
   selection = dataP2B.SubjectID == currentPart;
   
   plotty4 = scatter(dataP2B.TrialSequence(selection),dataP2B.TrialDuration(selection),20,'filled');
   hold on
   
   
   
end
title('Trial duration over task trial sequence')



p = polyfit(dataP2B.TrialSequence,dataP2B.TrialDuration, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, dataP2B.TrialSequence);

% Add regression line to plot
plot(dataP2B.TrialSequence, yfit, 'k-', 'LineWidth',1.5)

hold off
saveas(gcf, strcat(savepath, 'Trial duration over task trial sequence.png'));


% figure 9 
figure(9)
for index3 = 1:26
    
   currentPart = PartList(index3);
   
   selection = dataP2B.SubjectID == currentPart;
   
   plotty4 = scatter(dataP2B.TrialSequence(selection),dataP2B.RecalculatedAngle(selection),20,'filled');
   hold on
  
   
end
title('Pointing error over task trial sequence')



p = polyfit(dataP2B.TrialSequence,dataP2B.RecalculatedAngle , 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, dataP2B.TrialSequence);

% Add regression line to plot
plot(dataP2B.TrialSequence, yfit, 'k-', 'LineWidth',1.5)
hold off

saveas(gcf, strcat(savepath, 'Pointing error over task trial sequence.png'));


% figure 10

for indexPart2 = 1: length(PartList)
   
    currentPart = PartList(indexPart2);
    selection = dataP2B.SubjectID == currentPart;
    
    for indexStart = 1:height(stCombiIds)
        
       selection2 = strcmp(dataP2B.StartBuildingName(:),stCombiIds{indexStart,1});
       
       selection3 = selection & selection2;
       nrSameStarts = dataP2B.TrialSequence(selection3);
       
       for index4 = 1: length(nrSameStarts)
          
         minTrial = min(dataP2B.TrialSequence(selection3));
         minIndex = dataP2B.TrialSequence == minTrial;
         
         dataP2B.TrialSequence_SameStart14(minIndex) = index4;
         
         selection3 = selection3 & not(minIndex); 
         
       end
    end
end

dataP2B.TrialSequence_SameStart7 = dataP2B.TrialSequence_SameStart14;
dataP2B.TrialSequence_SameStart7(dataP2B.TrialOrder == 2) = dataP2B.TrialSequence_SameStart7(dataP2B.TrialOrder == 2) -7;

groupStats14 = groupsummary(dataP2B,'TrialSequence_SameStart14','mean','RecalculatedAngle');

figure(10)

plotty10 = boxchart(dataP2B.TrialSequence_SameStart14,dataP2B.RecalculatedAngle,'Notch','on');

title('Boxplot pointing errors sorted into trial sequence at the same start location');
xlabel('Trial sequence at same start building / location');
ylabel('pointing error')

hold on
plot(groupStats14.mean_RecalculatedAngle, '-o')  % x-axis is the intergers of position
hold off
%legend(["performance data","performance mean"])
 

saveas(gcf, strcat(savepath, 'Boxplot pointing errors sorted into trial sequence at the same start location.png'));


% figure 11

groupStats7 = groupsummary(dataP2B,'TrialSequence_SameStart7','mean','RecalculatedAngle');


figure(11)

plotty11 = boxchart(dataP2B.TrialSequence_SameStart7,dataP2B.RecalculatedAngle,'Notch','on');

title('Boxplot pointing errors sorted into trial sequence at the same start location');
xlabel('Trial sequence at same start building / location');
ylabel('pointing error')

hold on
plot(groupStats7.mean_RecalculatedAngle, '-o')  % x-axis is the intergers of position
hold off
%legend(["performance data","performance mean"])

saveas(gcf, strcat(savepath, 'Boxplot pointing errors sorted into trial sequence at the same start location.png'));


% figure 12
groupStatsAll = groupsummary(dataP2B,["SubjectID","TrialSequence_SameStart14"],'mean','RecalculatedAngle');


figure(12)

plotty11 = boxchart(dataP2B.TrialSequence_SameStart14,dataP2B.RecalculatedAngle,'Notch','on');

title('Boxplot pointing errors sorted into trial sequence at the same start location');
xlabel('Trial sequence at same start building / location');
ylabel('pointing error')

hold on

for indexPart = 1:length(PartList)
    
    selection = groupStatsAll.SubjectID == PartList(indexPart);
    plotty = plot(groupStatsAll.TrialSequence_SameStart14(selection),groupStatsAll.mean_RecalculatedAngle(selection),'--*');  % x-axis is the intergers of position
% plot(groupStats2.mean_RecalculatedAngle, '-o','k')  % x-axis is the intergers of position
end

plotty = plot(groupStats14.mean_RecalculatedAngle,'-o','Color','k','MarkerFaceColor','k');


hold off

saveas(gcf, strcat(savepath, 'Boxplot pointing errors sorted into trial sequence at the same start location.png'));
