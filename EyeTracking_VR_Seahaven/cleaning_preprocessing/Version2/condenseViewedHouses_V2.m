%% ------------------ condense Viewed Houses Version 2.0--------------------------------
% script written by Jasmin Walter

% takes raw viewed houses file and condenses them, so that several
% instances of houses are only listed once together with the amount of time
% looked at them before moving on to sth else


% uses raw ViewedHouses.txt file
% output: condenseHouse.mat file 
clear all;
% adjust savepath, current folder and participant list!
savepath = 'E:\SeahavenEyeTrackingData\duringProcessOfCleaning\condenseViewedHouses\';

cd 'E:\SeahavenResults\ViewedHouses\'


% Participant list of all participants that participated at least 3
% sessions in the experiment in Seahaven - 90min (no belt participants)
PartList = {1909 3668 8466 3430 6348 2151 4502 7670 8258 3377 1529 9364 6387 2179 4470 6971 5507 8834 5978 1002 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 2011 2098 3856 7942 6594 4510 3949 9748 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 5239 8936 9961 9017 1089 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593 9848};



Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;
missingData = array2table([]);

overviewAnalysis = array2table(zeros(Number,4));
overviewAnalysis.Properties.VariableNames = {'Participant','noData_Rows','total_Rows','percentage'};


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
            
        
        %rename rows
         data.House(noD)= cellstr('noData');
         
        % calculate amount of noData rows
        NRnoDataRows = sum(noD);
        
%% create the condensed viewed houses list  
        % create AllData Table
        NumArray = array2table(zeros(height(data),3));
        SeenHouses = cell(height(data),1);
        AllData= [SeenHouses NumArray];
        AllData.Properties.VariableNames = {'House','Time','Samples','Distances'};

        % additional variables
        previous = {'empty'};
        time = 1000/30;
        index=0;

        
        % condense viewed houses list

        
        for e= 1: height(data)
            
            % check if same or another house was seen
            % if the same house was seen
            if strcmp(data.House{e},previous)
                if strcmp(AllData.House{index}, previous)
                % update values
                AllData.Time(index)= AllData.Time(index)+time;
                AllData.Samples(index)= AllData.Samples(index) +1;
                AllData.Distances(index) = AllData.Distances(index) + data.Distance(e);
                else
                    disp('sth went wrong with the indexessssss');
                end
                
            % if a different house from last time was seen   
            else
                % adjust index
                index = index +1;
                
                % fill AllData table
                AllData.House(index)= data.House(e);
                AllData.Time(index)= AllData.Time(index) + time;
                AllData.Samples(index)= AllData.Samples(index) +1;
                AllData.Distances(index) = AllData.Distances(index)+ data.Distance(e);
                
                % update previous element
                previous = data.House{e};
                
            end
            
            
        end
        
        % adjust distances (so far they are only sums, now average them)
        AllData.Distances= AllData.Distances ./ AllData.Samples;
        
            % remove all empty lines of AllData
            uncutAllData = AllData;
            AllData = head(AllData, index);
            
            
            
            % save condensed viewed houses
            
            save([savepath num2str(currentPart) '_condensedViewedHouses.mat'],'AllData');
            
            % update overview
            
            overviewAnalysis.Participant(ii)= currentPart;
            overviewAnalysis.noData_Rows(ii)= NRnoDataRows;
            overviewAnalysis.total_Rows(ii)= totalRows;
            
            percent = (NRnoDataRows*100)/totalRows;
            
            overviewAnalysis.percentage(ii) = percent;

           
                
            
        
      
        
        

        
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
