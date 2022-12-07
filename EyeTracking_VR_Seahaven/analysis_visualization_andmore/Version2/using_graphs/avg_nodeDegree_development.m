%% --------------------------avg_nodeDegree_development-------------------

% script written by Jasmin Walter


clear all;


%savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\Plots\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\individual\'


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

% list the max amount of time chunks over all participants
maxNrTimeChunks = 91;
minNrTimeChunks = 76;

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

houseDataRows = NaN(Number,maxNrTimeChunks);

houseList = load('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\HouseList.mat');
houseList = houseList.houseList;

houseData = struct;

for index = 1: length(houseList)
   houseData(1).House(index).name = houseList(index);
   houseData(1).House(index).data = houseDataRows;
        
end


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_degreeDevelopment.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        degreeDevelopment = load(file);
        degreeDevelopment = degreeDevelopment.degreeDevelopment;
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        nrTimeChunks = width(degreeDevelopment) -1;
        

        %houseDataRows = degreeDevelopment{ii,2:end};
        for index = 1: length(houseList)
            
            currentHouse = houseData(1).House(index).name;
            
            matchingRow = strcmp(degreeDevelopment{:,1},cellstr(currentHouse));
            
            if sum(matchingRow) == 1
            
                range = width(degreeDevelopment) -1;
                houseData(1).House(index).data(ii,1:range) = degreeDevelopment{matchingRow,2:end};
            
            end
                
        end

%        save degreeDevelopment Overview
         %save([savepath num2str(currentPart) '_degreeDevelopment.mat'],'degreeDevelopment');
      % saveas(gcf,strcat(savepath,'Time.png'),'png');
      
    
    else
        disp('something went really wrong with participant list');
    end

end

% overviewMeans = NaN(length(houseList),maxNrTimeChunks);
% allData = [];
% 
% for index2 = 1: length(houseList)
%     
%    houseData(1).House(index2).mean = mean(houseData(1).House(index2).data, 'omitnan');% 
%    houseData(1).House(index2).stdev = std(houseData(1).House(index2).data, 'omitnan');% ,'omitnan'
%    
%    overviewMeans(index2,:) =  houseData(1).House(index2).mean;
%    allData = [allData; houseData(1).House(index2).data];
%    
% end
% 
% 
% meanOfMeans = mean(overviewMeans,'omitnan');
% allDMean = mean(allData,'omitnan');
% allDstdev = std(allData, 'omitnan');
% 
% above = allDMean + allDstdev;
% above2 = allDMean + allDstdev*2;
% 
% 
% x = [1:maxNrTimeChunks];
% figure(1)
% plotty1 = plot(x,meanOfMeans,'b',x,allDMean,'g');
% %xline(minNrTimeChunks);
% xlabel('time')
% ylabel('node degree')
% legend({'grandMean','allData'})
% title('variance means')
% saveas(gcf,strcat(savepath,'variance_means.png'),'png');
% 
% 
% for index3 = 1: length(houseList)
%     
%    figure(2)
%    plotty2 = plot(houseData(1).House(index3).mean);%(:,1:minNrTimeChunks)
%    hold on
%    
%         
% end
% 
% plotty3 = plot(meanOfMeans,'r','LineWidth',2.5);
% plotty4 = plot(above,'b','LineWidth',2.5);
% plotty5 = plot(above2,'g','LineWidth',2.5);
% 
% xlabel('time')
% ylabel('node degree')
% title('avg node degree development - all houses')
% saveas(gcf,strcat(savepath,'avg_nodeDegree_development_all_houses.png'),'png');
% 
% hold off
% 
% % plot only outliers
% 
% border1 = above(minNrTimeChunks);
% border2 = above2(minNrTimeChunks);
% indexOutlier1 = [];
% indexOutlier2 = [];
% 
% for index4 = 1: length(houseList)
%     
%    if houseData(1).House(index4).mean(minNrTimeChunks) > border2
%        
%        indexOutlier2 = [indexOutlier2, index4];
%        
%    elseif houseData(1).House(index4).mean(minNrTimeChunks) > border1
%        indexOutlier1 = [indexOutlier1, index4];    
%    end
%  
% end
% 
% 
% 
% for index6 = indexOutlier2 
%    figure(4)
%    plottyOutlier2 = plot(houseData(1).House(index6).mean,'-.','DisplayName',char(houseData(1).House(index6).name));%(:,1:minNrTimeChunks)
%    hold on     
% end
% 
% for index5 = indexOutlier1
% 
%     plottyOutlier1 = plot(houseData(1).House(index5).mean,'DisplayName',char(houseData(1).House(index5).name));%(:,1:minNrTimeChunks)
%      
% end
% 
% plottyO1 = plot(meanOfMeans,'r','LineWidth',2.5, 'DisplayName', 'mean');
% plottyO2 = plot(above,'b','LineWidth',2.5, 'DisplayName', 'standard deviation');
% plottyO3 = plot(above2,'g','LineWidth',2.5, 'DisplayName', '2x standard deviation');
% 
% xlabel('time')
% ylabel('node degree')
% l = legend;
% set(l, 'Interpreter','none')
% 
% title('avg node degree development - houses > mean+std')
% saveas(gcf,strcat(savepath,'avg_nodeDegree_development_outliers.png'),'png');
% 
% hold off
% 
% 
% 
% disp(strcat(num2str(Number), ' Participants analysed'));
% disp(strcat(num2str(countMissingPart),' files were missing'));
% 
%  csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
%  disp('saved missing participant file list');
% 
% disp('done');
% 
