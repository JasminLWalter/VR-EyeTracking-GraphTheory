%% ------------------ analysis_time_development-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\Plots\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\individual\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

overviewTime = table;


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
        
        
        
        overviewTime.Participant(ii) = currentPart;
        overviewTime.Time(ii) = width(degreeDevelopment) -1;
        
        
        
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath 'overviewTime.mat'],'overviewTime');

figure(1)
plotty = boxplot(overviewTime.Time);

saveas(gcf,strcat(savepath,'Time.png'),'png');
  

disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');

