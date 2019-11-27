%% ------------------ plot_print_Graphs----------------------------------
% script written by Jasmin Walter

% script plots graphs
% script can print graphs to png or pdfs

clear all;

savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\analysis\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\'

%PartList = {1809,5699,6525,2907,5324,3430,4302,7561,4060,6503,7535,1944,8457,3854,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};
PartList = {2907,4302,7561,6503,8457,1119,5287,8517,9430,6468,7953,1171,9471};
Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load house list
housedata= load('E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\HouseList.mat');
houseList= housedata.houseList;

overviewNodeDegree = cell2table(houseList);



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
   
    
    file = strcat(num2str(currentPart),'_Graph.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        %% print graphs to pngs
        namey= strcat(num2str(currentPart),'_Graph');
        figure('Name',namey,'IntegerHandle', 'off')
        graphy = load(file);
        graphy= graphy.graphy;
        plot(graphy)%,'NodeLabelMode','auto')
        
        % print graph as png
        saveas(gcf,strcat('graph_',num2str(currentPart),'.png'));
        % print graph as pdf
%         print('-fillpage',strcat(savepath,namey),'-dpdf')

        
        
    else
        disp('something went really wrong with participant list');
    end

end



disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');