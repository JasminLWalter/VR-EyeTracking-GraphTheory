%------------Analysis Viewed Houses-JasminsVersion--------------------
% written by Vivianne Kakerbeck
% adjusted by Jasmin Walter

% creates overview of individual participants numView files

clear all;

% always needs adjusting
savepath = 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\';
% identifier for name of files created
saveID = '12.06.testi';
cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\approach1-distance\analysisAllViewsJExtended';

%list of subjects that you want to analyze
PartList = {2907,5324,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,8804,7350,3116,7666,8466,3093,9327,3668,1909,1171,9471,5625,2151,4502,2653,7670,7953,1882,1809,5699,1003,3961,6525,3430,1119,5287,3983,7395,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,1181,9430,3251,6468,8665,5823,8222,2006,8258};

%--------------------------------------------------------------------------
% the following code should be free of adjustments
NumberPart = length(PartList);
NumHouses = cell(2,NumberPart);
total = 0;
totalper = 0;


countMissingPart = 0;
noFilePartList = [NumberPart];

for ii = 1: NumberPart
    currentPart = cell2mat(PartList(ii));
    filePart = strcat('NumViewsD_VP_',num2str(currentPart),'.mat');
    % if the file doesn't exist, error catch
    % check noFilePartList for a list of all missing files after running
    % the script!
    if exist(filePart)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList(countMissingPart,1) = currentPart;
        disp(strcat(filePart,' does not exist in folder'));
    
  % if the file exists - main 
  elseif exist(filePart)==2
    % open data file    
    data = load(filePart);
    SeenHouses = (size(data.NumViews,1));
    total=total+SeenHouses;
    percentage = SeenHouses/214;
    totalper = totalper+percentage;

    NumHouses{1,ii}=SeenHouses;
    NumHouses{2,ii}=percentage;
    NumHouses{3,ii}=mean(data.NumViews.occ);%Average seconds looked at one house
    NumHouses{4,ii}=sum(data.NumViews.occ)/60;%minutes looked at houses

    table=array2table(ones(SeenHouses,1));
     
    % running for loop 1st time
    if ii==1
        %create array totalNum
        totalNum=[data.NumViews ];
        table.Properties.VariableNames{'Var1'} = 'numVP';
        totalNum=[totalNum table];
        
        %create array ListVar     
        ListVar = array2table(zeros(SeenHouses,ii+1));
        ListVar.Properties.VariableNames{'Var1'}='House';
        ListVar.Var2 = totalNum.DistanceVariance;
        ListVar.Properties.VariableNames{'Var2'}= strcat('Participant',num2str(currentPart));
        ListVar.House = totalNum.House;
        test1round = ListVar;
        
    else
   
        % add and name Column in Variance List
        
        CurrentVarName = strcat('Participant',num2str(currentPart));
        newVar= array2table(zeros(length(ListVar.House),1),'VariableNames',{CurrentVarName});
        ListVar=[ListVar newVar];
        
        %ListVar.Properties.VariableNames{orginalVarName}= CurrentVarName;
        test00=ListVar;
        % goes through every House in NumView file
        for h=1:SeenHouses
            found=false;
         
            for e=1:size(totalNum)
                % if house in NumViews row and totalNum row are the same
                if strcmp((data.NumViews.House(h)),totalNum.House(e))
                    % add total time of participants looked at a house
                    totalNum.occ(e)=totalNum.occ(e)+data.NumViews.occ(h);
                    % and in numVP how many participants looked at the house
                    totalNum.numVP(e) = totalNum.numVP(e)+1;
                    %add Variance
                    test1= ListVar;
                    ListVar(e,ii+1)= data.NumViews(h,4);
                    test2=ListVar; 
                    
                    found = true;
                end
            end
            % if a house is not yet in totalNum
            if found==false
                totalNum=[totalNum;{data.NumViews.House(h) data.NumViews.occ(h) ...
                     data.NumViews.DistanceAllLooks data.NumViews.DistanceVariance(h) ...
                     data.NumViews.DistanceMean(h) 1}];
                
                %create extra row for Variance Table
                allVars= ListVar.Properties.VariableNames;
                extraRow = array2table(zeros(1,ii+1));
                extraRow.Properties.VariableNames = allVars;
                % fill row with housename and variance
                extraRow.House = data.NumViews.House(h);
                extraRow(1,ii+1)= data.NumViews(h,4);
                % attach row to Variance Table
                ListVar=[ListVar;extraRow];
                
                
            end
        end
    end
    else
        disp('Error! something went really wrong with participant list files in folder');
    end
end
disp(strcat(num2str(NumberPart), ' files of Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

% create average file for seconds of seen houses
avgocc = ones(height(totalNum),1);

for n = 1:height(totalNum)
    avgocc(n) = totalNum.occ(n)/totalNum.numVP(n);
end
% update totalNum
totalNum = [totalNum array2table(avgocc)];


%Statistics and Saving-----------------------------------------------------

% how many houses were looked at on average (all participants)
avg=total/NumberPart;

%how much percent of the houses (all participants)
avgper = totalper/NumberPart;

%how long on average were houses looked at (s) (all participants)
avgTime = mean(avgocc);

%average overall time looked at houses in minutes
avgTotalTime = sum(avgocc)/60;

%sort the table of houseViews in descending order most often viewed houses on top)
totalNum=sortrows(totalNum,2,'descend');

%create ViewStats file
ViewStats=cell2table(NumHouses);
ViewStats.Properties.RowNames={'NumHousesSeen' 'PercentHousesSeen' 'AverageTimeLookedAtOneHouse (s)' 'TimeLookedAtHouses (min)'};
ViewStats.Properties.VariableNames = strcat('VP ',cellfun(@num2str,PartList, 'un',0));

%add overall stas to table
t = array2table([avg,avgper,avgTime,avgTotalTime].');
ViewStats = [ViewStats t];
ViewStats.Properties.VariableNames{'Var1'} = 'Overall';

% save files totalNum and ViewingStats
save([savepath 'totalNum' saveID '.mat'],'totalNum');
disp('created average file totalNum');

%overall subject stats in a table (percentage, num houses looked at, avg duration)
%list of houses looks at with overal duration, average distance etc
save([savepath 'ViewingStats' saveID '.mat'],'ViewStats');
disp('created average file viewing statistics');

% sort and save Variance Table 
sortListVar= sortrows(ListVar);

save([savepath 'VarianceTable' saveID '.mat'],'ListVar');
save([savepath 'sortedVarianceTable' saveID '.mat'],'sortListVar');
disp('created variance Table');

disp('done');

