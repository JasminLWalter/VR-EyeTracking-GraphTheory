%%%testi:

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

currentData = readtable('1004_Expl_S_2_ET_2_flattened.csv');

figure(1)
% plotty = plot(overviewTimeStamps{:,1:3});
plotty = plot(overviewTimeStamps.timeStampDataPointStart,'DisplayName','Start');
hold on
plotty2 = plot(overviewTimeStamps.timeStampGetVerboseData,'DisplayName','VerboseD');
plotty3 = plot(overviewTimeStamps.timeStampDataPointEnd,'DisplayName','End');

legend

hold off

overviewTimeStamps.Rows = currentData.DataRow;

test1 = overviewTimeStamps.DifStartVerbose == 0;

test1all = overviewTimeStamps(not(test1),:);


figure(2)
plotty4 = plot(test1all.timeStampDataPointStart,'DisplayName','Start');
hold on
plotty5 = plot(test1all.timeStampGetVerboseData,'DisplayName','Verbose');
plotty6 = plot(test1all.timeStampDataPointEnd,'DisplayName','End');
legend



% clear all
% 
% overviewFrameRates = table;
% 
% cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis_controls\checked_raw_files'
% 
% 
% for index = 1:3
%     
%    
%     file= strcat('1004_2_' ,num2str(index), '_overviewTimeStamps.csv');
%     overviewTimeStamps = readtable(file);
%     
%     currentT = table;
%     currentT.FileName = file;
%     currentT.meanDifStartEnd = mean(overviewTimeStamps.DifStartEnd);
%     currentT.meanDifStartVerbose = mean(overviewTimeStamps.DifStartVerbose);
%     currentT.meanDifVerboseEnd = mean(overviewTimeStamps.DifVerboseEnd);
%     currentT.meanRecRateStart = mean(overviewTimeStamps.recRateStart);
%     currentT.meanRecRateEnd = mean(overviewTimeStamps.recRateEnd);
%     currentT.meanRecRateVerboseD = mean(overviewTimeStamps.recRateVerboseD);
% 
%     overviewFrameRates = [overviewFrameRates; currentT];
%     
%     
%     
% end



