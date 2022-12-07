%% ------------------ triangulation_development_V3-------------------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\triangulation\DevelopmentAnalysis\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

triOverview = struct;

% define grid and do hist count
% load map
map = imread ('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');
[rows, columns, numberOfColorChannels] = size(map);

edgesRows = linspace(1,rows,125);
edgesCol = linspace(1,columns,112);

triMap = load('E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\triangulation\logicalTriangulationMapArray.mat');
triMap = triMap.sumAll3cut';

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_gazes_data_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        gazedObjects = load(file);
        gazedObjects = gazedObjects.gazedObjects;
        
        %%  transformation - 2 factors (mulitply and additive factor)
        xT = 6.05;
        zT = 6.1;
        xA = -1100;
        zA = -3290;
        session1 = strcmp({gazedObjects.Session}, 'Session1');
        session2 = strcmp({gazedObjects.Session}, 'Session2');
        session3 = strcmp({gazedObjects.Session}, 'Session3');
        
        positions1 = table;
        positions1.X = [gazedObjects(session1).PosX]'*xT+xA;
        positions1.Z = [gazedObjects(session1).PosZ]'*zT+zA;
        
        positions2 = table;
        positions2.X = [gazedObjects(session2).PosX]'*xT+xA;
        positions2.Z = [gazedObjects(session2).PosZ]'*zT+zA;
        
        positions3 = table;
        positions3.X = [gazedObjects(session3).PosX]'*xT+xA;
        positions3.Z = [gazedObjects(session3).PosZ]'*zT+zA;
        
%         figure(1)
%         imshow(map)
%         alpha(0.5)
%         hold on
%         plotty1 = plot(positions.Z, positions.X);
%         pause
        
        logicPos1 = nan([1, height(positions1)]);
        logicPos2 = nan([1, height(positions2)]);
        logicPos3 = nan([1, height(positions3)]);
        
        for indexRow= 1: (length(edgesRows)-1)
            row1 = edgesRows(indexRow);
            row2 = edgesRows(indexRow+1);
            for indexCol = 1:(length(edgesCol)-1)
               col1 = edgesCol(indexCol);
               col2 = edgesCol(indexCol+1);
               
               %%
%                selectRow1 = (positions1.Z >= row1) & (positions1.Z < row2); 
%                selectCol1 = (positions1.X >= col1) & (positions1.X < col2);
%                both1 = selectRow1 & selectCol1;
%                logicPos1(both1) = triMap(indexRow,indexCol);
%                
%                selectRow2 = (positions2.Z >= row1) & (positions2.Z < row2); 
%                selectCol2 = (positions2.X >= col1) & (positions2.X < col2);
%                both2 = selectRow2 & selectCol2;
%                logicPos2(both2) = triMap(indexRow,indexCol);
%                
%                selectRow3 = (positions3.Z >= row1) & (positions3.Z < row2); 
%                selectCol3 = (positions3.X >= col1) & (positions3.X < col2);
%                both3 = selectRow3 & selectCol3;
%                logicPos3(both3) = triMap(indexRow,indexCol);
               %%
                selectRow1 = (positions1.X >= row1) & (positions1.X < row2); 
                selectCol1 = (positions1.Z >= col1) & (positions1.Z < col2);
                both1 = selectRow1 & selectCol1;
                logicPos1(both1) = triMap(indexRow,indexCol);
               
               selectRow2 = (positions2.X >= row1) & (positions2.X < row2); 
               selectCol2 = (positions2.Z >= col1) & (positions2.Z < col2);
               both2 = selectRow2 & selectCol2;
               logicPos2(both2) = triMap(indexRow,indexCol);
               
               selectRow3 = (positions3.X >= row1) & (positions3.X < row2); 
               selectCol3 = (positions3.Z >= col1) & (positions3.Z < col2);
               both3 = selectRow3 & selectCol3;
               logicPos3(both3) = triMap(indexRow,indexCol);
            end
            
            
        end
        triOverview(ii).Participant = currentPart;
        triOverview(ii).Session1 = logicPos1;
        triOverview(ii).Session2 = logicPos2;
        triOverview(ii).Session3 = logicPos3;
        
        
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath 'triOverviewDevelopment'],'triOverview')
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');

