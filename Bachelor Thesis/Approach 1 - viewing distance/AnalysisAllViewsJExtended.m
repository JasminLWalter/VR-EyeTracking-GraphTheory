%% ----------------Analyze Raw ViewedHouses Files (1st Level)----------------
% written by Vivianne Kakerbeck
% adjusted by Jasmin Walter
% Adjustments: 
% has error management if files listed in Participant list are missing
% lists amount of Participants analysed and amount of missing files
% prevents matlab from crashing because of too many open files
% saves NumViews with all distances for each house
clear all;

%savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\AnalysisAllViews\';
savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\analysisAllViewsJExtended\';
cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data2019Feb\ViewedHouses\'
%--------------------------------------------------------------------------
%participant list
%PartList = {2907,5324,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};
PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

Number = length(PartList);
noFilePartList = [Number];
countMissingPart = 0;

avgdist = cell(1,Number);

for ii = 1:Number
    suj_num = cell2mat(PartList(ii));
    file = strcat('ViewedHouses_VP',num2str(suj_num),'.txt');
    
    % if the file doesn't exist, error catch
    % check noFilePartList for a list of all missing files after running
    % the script!
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = suj_num;
        disp(strcat(file,' does not exist in folder'));
    
    % if the file exists - main 
    elseif exist(file)==2
        %open file
        RawData = fopen(file);
        %read file into data array
        data = textscan(RawData,'%s','delimiter', '\n');
        %close file to prevent Matlab from collapsing
        fclose(RawData);
        
        % read array into table
        data = data{1};
        data = table2array(cell2table(data));
        
        %initialize fields
        len = int32(length(data));
        houses = cell(1,len);
        distance = zeros(1,len);
        timestamps = zeros(1,len);
        
        for a = 1:double(len)
            line = textscan(data{a},'%s','delimiter', ',');line = line{1};
            houses{a} = char(line{1});
            distance(a) = str2num(cell2mat(line(2)));
            timestamps(a) = str2num(cell2mat(line(3)));
        end
        avgdist{Number} = mean(distance);
        clear data;
        
        %calculate how often one house was looked at:
        [uniqueX, ~, J]=unique(cellstr(houses)); 
        %uniqueX = which elements exist in houses, 
        %J = to which of the elements in uniqueX does the element in houses correspond 
        occ = histc(J, 1:numel(uniqueX))/30; 
        %histogram bincounts to count the # of occurances of each house
        NumViews = table(uniqueX',occ);
        
    %% NumView creation
    %Calculate average distance from which each house was looked at and
    %variance in the distance:
        lenHouses = length(uniqueX);
        distances = cell(lenHouses,3);
        distances(1:lenHouses) = uniqueX;
        ix=cellfun('isempty',distances);
        distances(ix)={[0]};
        for a = 1:len
            houseN = J(a);
            distances{houseN,2}=[distances{houseN,2},distance(a)];
        end
        for a = 1:lenHouses
            distances{a,2}=distances{a,2}(distances{a,2}~=0);
            distances{a,3}=var(distances{a,2});
            distances{a,4}=mean(distances{a,2});
        end
    %Save everything in NumViews:------------------------------------------
        NumViews = [NumViews distances];
        NumViews(:,[3])=[];
        
        %remove houses that we're 'seen' from further away than the far clip plane
        remove = isnan(NumViews.Var6);
        NumViews(remove,:)=[];
        NumViews.Properties.VariableNames{'Var1'}='House';
        NumViews.Properties.VariableNames{'Var4'}='DistanceAllLooks';
        NumViews.Properties.VariableNames{'Var5'}='DistanceVariance';
        NumViews.Properties.VariableNames{'Var6'}='DistanceMean';
        %clear uniqueX;clear occ;clear J;
        
        %Save NumViews as a matlab table:
        current_name = strcat(savepath,'NumViewsD_','VP_',num2str(suj_num),'.mat');
        save(current_name,'NumViews')

        
    else
        disp('Error! something went really wrong with participant list files in folder');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));
