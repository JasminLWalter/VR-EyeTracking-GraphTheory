%% ------------------ node_degree_development_plot-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\Plots\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\individual\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;



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
        
        degreeNan = degreeDevelopment;


        for index1 = 2: width(degreeDevelopment)
            degreeZeros = degreeDevelopment{:,index1} == 0;
            degreeNan{degreeZeros,index1} = NaN;
        end

        meanRow = mean(degreeNan{:,2:end},'omitnan');
        stdRow = std(degreeNan{:,2:end},'omitnan');
        above = meanRow + stdRow;
        below = meanRow - stdRow;

        above2 = meanRow + stdRow*2;
        below2 = meanRow - stdRow*2;

        figure(1)
        plotty1 = plot(meanRow);


        % for index = 1:height(degreeDevelopment)
        %    
        %    figure(2)
        %    plotty = plot(degreeDevelopment{index,2:end});
        %    hold on; 
        %     
        % end
        % 
        % plotty1 = plot(meanRow,'r','LineWidth',2);
        % plotty2 = plot(above,'b','LineWidth',2);
        % plotty3 = plot(below,'b','LineWidth',2);
        % 
        % plotty4 = plot(above2,'g','LineWidth',2);
        % %plotty5 = plot(below2,'g','LineWidth',2);

        border = above2(end);
        outlier = degreeDevelopment;

        biggerBorder = degreeDevelopment{:,end} < border;
        outlier(biggerBorder,:) = [];

        for index = 1:height(outlier)
            figure(4)
            plotty30 = plot(outlier{index,2:end},'--','LineWidth',1);
            hold on

        end



        plotty1 = plot(meanRow,'r','LineWidth',2);
        plotty2 = plot(above,'b','LineWidth',2);
        plotty3 = plot(below,'b','LineWidth',2);

        plotty4 = plot(above2,'g','LineWidth',2);

%        save degreeDevelopment Overview
         %save([savepath num2str(currentPart) '_degreeDevelopment.mat'],'degreeDevelopment');
      % saveas(gcf,strcat(savepath,'Time.png'),'png');
    else
        disp('something went really wrong with participant list');
    end

end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');

