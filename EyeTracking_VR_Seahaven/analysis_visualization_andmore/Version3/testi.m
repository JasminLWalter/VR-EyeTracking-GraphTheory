%--------------------------join3SessionsVR------------------------------
% script written by Jasmin Walter

% step 2 in pipeline if necessary
% combines condensedColliders files of different VR sessions into one file
% here combines the 3 sessions of one participant into one file


clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\Raycast3.0\90minData\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\Raycast3.0\90minData\';

% participant list including all participants
%PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};

% participant list only with participants who have lost less than 30% of
% their data - 3 sessions per participant - 90min VR batch
PartList = {1909 3668 8466 3430 6348 2151 4502 7670 8258 3377 1529 9364 6387 2179 4470 6971 5507 8834 5978 1002 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 2011 2098 3856 7942 6594 4510 3949 9748 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 5239 8936 9961 9017 1089 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593 9848};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
%% comment this part if the list combined Sessions (with the new participant numbers for the 
%% combined 3 session) already exists
% % open list that contains the information about which sessions belong to
% % one participant
% overallList = open('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\overallList.mat');
% overallList = overallList.overallList;
% 
% % bigger3 = overallList{:,2} >3;
% % 
% % session3List = overallList;
% % session3List(bigger3,:) = [];
% 
% newList = table('Size',[height(overallList),3],'VariableTypes',{'double','double','cell'});
% newList.Properties.VariableNames = {'PartNum','Session','Specs'};
% 
% 
% for index = 1: height(overallList)
%     newList.PartNum(index) = overallList.PartNum{index,1};
%     newList.Session(index) = overallList.Session{index,1};
%     newList.Specs(index) = overallList.Specs(index,1);
% 
% end
% letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
% noIDs = {};
% combinedSessions = table;
% for in = 1: length(letters)
%     
%     id = letters(in);
%     session1 = newList{strcmp(newList.Specs,strcat('1',id)),1};
%     session2 = newList{strcmp(newList.Specs,strcat('2',id)),1};
%     session3 = newList{strcmp(newList.Specs,strcat('3',id)),1};
%     
%     if (isempty(session1)|| session1==0)
%         noIDs = [noIDs,id];
%     elseif (isempty(session2)|| session2==0)
%         noIDs = [noIDs,id];
%     elseif(isempty(session3)|| session3==0)
%         noIDs = [noIDs,id];
%         
%     else
%         newRow = table('Size',[1,5],'VariableTypes',{'double','double','double','double','cell'});
%         newRow.Properties.VariableNames = {'newPartNumber','Session1','Session2','Session3','Identifier'};
%         
%         newRow.newPartNumber = in + 20;
%         newRow.Session1 = session1;
%         newRow.Session2 = session2;
%         newRow.Session3 = session3;
%         newRow.Identifier = id;
%         combinedSessions = [combinedSessions;newRow];
%     end
%     
%     
% end

%writetable(combinedSessions,strcat(savepath,'combinedSessions_newPartNumbers.csv'));
%save(strcat(savepath,'combinedSessions_newPartNumbers_matlab'),'combinedSessions');
%all22PartList = combinedSessions.newPartNumber';
%save(strcat(savepath,'all22PartList'),'all22PartList');

%% here the 3 sessions belonging together are combined into one file
% not that there is a row with values.... that sepparates the sessions -
% for later identification of the sessions if necessary


% comment this line, if you create the combinedSessions here in the script
combinedSessions = readtable('E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\combined3Sessions\combinedSessions_newPartNumbers.csv');
for part = 1: height(combinedSessions)

    file1 = strcat('Raycast3.0_VP',num2str(combinedSessions.Session1(part)),'.txt');
    file2 = strcat('Raycast3.0_VP',num2str(combinedSessions.Session2(part)),'.txt');
    file3 = strcat('Raycast3.0_VP',num2str(combinedSessions.Session3(part)),'.txt');
    
    if exist(file1)==0
        disp(file1);
    elseif exist(file2) ==0
        disp(file2);
    elseif exist(file3) == 0
        disp(file2);
    else
        disp(strcat(num2str(part), ' row is fine'));
    end
    

end





