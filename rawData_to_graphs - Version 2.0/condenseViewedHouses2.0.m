%% ------------------ condense Viewed Houses Version 2.0--------------------------------
% script written by Jasmin Walter

% takes raw viewed houses file and condenses them, so that several
% instances of houses are only listed once together with the amount of time
% looked at them before moving on to sth else
% cleanses data (removes data points in which eyetracker did not track
% pupil

% uses raw ViewedHouses.txt file
% output: condenseHouse.mat file + overview of removed rows in cleaning
% process
clear all;
% adjust savepath, current folder and participant list!
savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\Version2.0\condenseViewedHouses\';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data2019Feb\ViewedHouses\'

PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;
missingData = array2table([]);

overviewAnalysis = array2table(zeros(Number,2),'VariableNames',{'Participant','removed_Rows'});


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('ViewedHouses_VP',num2str(currentPart),'.txt');
    
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(file,' does not exist in folder'));
        
       
%% main code    
    elseif exist(file)==2
        
        %load data
        RawData = readtable(file,'Format','%s %f %f','ReadVariableNames',false);
        RawData.Properties.VariableNames = {'House','Distance','Timestamp'};
        data = RawData;
        
        totalRows = height(data);
        
        %% clean data
        
        % rename NH to sky if they looked into the sky
        
        houses = data.House;
        distances= data.Distance;
        skyHouse = strcmp(houses(:),'NH') & (distances(:)==200);
         
        % store the renamed rows for checking
        skyRows= data(skyHouse,:);
        
        %rename rows to sky
        data.House(skyHouse)= cellstr('sky');
        
     
        % rename rows when pupils were detected with probability lower than 0,5
        
        noD = strcmp(houses(:),'NH') & eq(distances(:),0);
            
%         % store the removed rows
%         removedRows= data(noD,:);
        
        %rename rows
         data.House(noD)= cellstr('noData');
        
%% create the condensed viewed houses list  
        % create AllSeen Table
        NumArray = array2table(zeros(height(data),3));
        SeenHouses = cell(height(data),1);
        AllSeen= [SeenHouses NumArray];
        AllSeen.Properties.VariableNames = {'House','Time','Looks','Distances'};

        % additional variables
        previous = {'empty'};
        time = 1000/30;
        index=0;

        
        % condense viewed houses list

        
        for e= 1: height(data)
            
            % check if same or another house was seen
            % if the same house was seen
            if strcmp(data.House{e},previous)
                if strcmp(AllSeen.House{index}, previous)
                % update values
                AllSeen.Time(index)= AllSeen.Time(index)+time;
                AllSeen.Looks(index)= AllSeen.Looks(index) +1;
                AllSeen.Distances(index) = AllSeen.Distances(index) + data.Distance(e);
                else
                    disp('sth went wrong with the indexessssss');
                end
                
            % if a different house from last time was seen   
            else
                % adjust index
                index = index +1;
                
                % fill AllSeen table
                AllSeen.House(index)= data.House(e);
                AllSeen.Time(index)= AllSeen.Time(index) + time;
                AllSeen.Looks(index)= AllSeen.Looks(index) +1;
                AllSeen.Distances(index) = AllSeen.Distances(index)+ data.Distance(e);
                
                % update previous element
                previous = data.House{e};
                
            end
            
            
        end
        
        % adjust distances (so far they are only sums, now average them)
        AllSeen.Distances= AllSeen.Distances ./ AllSeen.Looks;
        
            % remove all empty lines of AllSeen
            uncutAllSeen = AllSeen;
            AllSeen = head(AllSeen, index);
            
            
            
            % save condensed viewed houses
            
            save([savepath num2str(currentPart) '_condensedViewedHouses.mat'],'AllSeen');
            
%             % update overview
%             
%             overviewAnalysis.Participant(ii)= currentPart;
%             overviewAnalysis.removed_Rows(ii)= height(removedRows);
%             overviewAnalysis.total_Rows(ii)= totalRows;
%             
%             percent = (height(removedRows)*100)/totalRows;
%             
%             overviewAnalysis.percentage(ii) = percent;

           
                
            
        
      
        
        

        
    else
        disp('something went really wrong with participant list');
    end
    
    
    

end
 
disp(strcat(num2str(Number), ' of Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

save([savepath 'OverviewAnalysis.mat'],'overviewAnalysis');
disp('saved overview Analysis ');

disp('done');
