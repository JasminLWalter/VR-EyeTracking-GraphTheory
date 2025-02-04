%% --------------------- step0_dataPreparation_2023_HA.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses 1004_Expl_S_1_ET_1_flattened.csv file
% Output: 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

% datapaths Living Transformation harddrive
savepath = 'E:\WestbrookProject\Human_A_Data\Experiment1\Exploration_short\pre-processing\step0_preparation\';

cd 'E:\WestbrookProject\Human_A_Data\Experiment1\Exploration_short\pre-processing\unflattening\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city of the Human_A Variation

PartList = {0365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7264 7412 7842 8007 8469 8673 9472 9502 9586 9601};
% PartList = {0365};


colliderList = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');

changedColliders = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\list_collider_changes.csv');


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;

overviewAllColliders = table;
overviewProcessedColliders = table;
overviewProcessedColliders_NH = table;
overviewRenamedGraffiti = table;
overviewAgents = table;

% overviewDistanceCheck = table;


% loop code over all participants in participant list

for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = PartList{indexPart};
    
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        tic
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        if(currentPart<1000)
            dirSess = dir(['0' num2str(currentPart) '_Expl_S_' num2str(indexSess) '*_flattened.csv']);
        else
            dirSess = dir([num2str(currentPart) '_Expl_S_' num2str(indexSess) '*_flattened.csv']);
        end
        
        
        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                % data = readtable('0365_Expl_S_1_ET_1_flattened.csv');
                data = readtable(dirSess(indexET).name);
        
                totalRows = height(data);
                
                overviewAllColliders = [overviewAllColliders; unique(data.hitObjectColliderName_1); unique(data.hitObjectColliderName_2)];
                
                %% Remove empty variable rows (true for exploration phase)
                % single eye raycasts were not saved in explorations
                % left controller was not used - shows always the same
                % value
                % right hand scale does not change throughout the
                % experiment - always same value
                data = removevars(data,...
                    {'rayCastHitsLeftEye';
                    'rayCastHitsRightEye';                    
                    'handLeftRotation_x';
                    'handLeftRotation_y';
                    'handLeftRotation_z';
                    'handLeftScale_x';
                    'handLeftScale_y';
                    'handLeftScale_z';
                    'handLeftDirectionForward_x';
                    'handLeftDirectionForward_y';
                    'handLeftDirectionForward_z';
                    'handLeftDirectionRight_x';
                    'handLeftDirectionRight_y';
                    'handLeftDirectionRight_z';
                    'handLeftDirectionUp_x';
                    'handLeftDirectionUp_y';
                    'handLeftDirectionUp_z';
                    'handRightScale_x';
                    'handRightScale_y';
                    'handRightScale_z'});
                
                %% Rename all collider names, that are empty - due to no collider being hit in the raycast to "noHit"
                empty1 = strcmp({''}, data.hitObjectColliderName_1);
                empty2 = strcmp({''}, data.hitObjectColliderName_2);
                
                % collider hit 1
                data.hitObjectColliderName_1(empty1) = {'noHit'};
                
                data.ordinalOfHit_1(empty1) = NaN;
                data.hitColliderType_1(empty1) = {'noHit'};
                
                data.hitPointOnObject_x_1(empty1) = NaN;
                data.hitPointOnObject_y_1(empty1) = NaN;
                data.hitPointOnObject_z_1(empty1) = NaN;
                
                data.hitObjectColliderBoundsCenter_x_1(empty1) = NaN;
                data.hitObjectColliderBoundsCenter_y_1(empty1) = NaN;
                data.hitObjectColliderBoundsCenter_z_1(empty1) = NaN;

                % collider hit 2
                data.hitObjectColliderName_2(empty2) = {'noHit'};
                
                data.ordinalOfHit_2(empty2) = NaN;
                data.hitColliderType_2(empty2) = {'noHit'};
                
                data.hitPointOnObject_x_2(empty2) = NaN;
                data.hitPointOnObject_y_2(empty2) = NaN;
                data.hitPointOnObject_z_2(empty2) = NaN;
                
                data.hitObjectColliderBoundsCenter_x_2(empty2) = NaN;
                data.hitObjectColliderBoundsCenter_y_2(empty2) = NaN;
                data.hitObjectColliderBoundsCenter_z_2(empty2) = NaN;
                
                %% Rename Colliders etc - everything related to Westbrook's design
                
                % go through list that identifies which collider must be
                % renamed to another name (source name rename to target
                % name)
                % do this for both first and second order hit points
                for indexCC = 1: height(changedColliders)
                    
                    sourceName = changedColliders.source_collider_name(indexCC);
                    
                    locData1 = strcmp(sourceName, data.hitObjectColliderName_1);
                    locData2 = strcmp(sourceName, data.hitObjectColliderName_2);
                    
                    % now rename name all relevant variable at these locations
                    % orginal hit 1
                    data.hitObjectColliderName_1(locData1) = changedColliders.target_collider_name(indexCC);
                    data.hitObjectColliderBoundsCenter_x_1(locData1) = changedColliders.ColliderBoundsCenter_x(indexCC);
                    data.hitObjectColliderBoundsCenter_y_1(locData1) = changedColliders.ColliderBoundsCenter_y(indexCC);
                    data.hitObjectColliderBoundsCenter_z_1(locData1) = changedColliders.ColliderBoundsCenter_z(indexCC);
                    
                    % orginal hit 2
                    data.hitObjectColliderName_2(locData2) = changedColliders.target_collider_name(indexCC);
                    data.hitObjectColliderBoundsCenter_x_2(locData2) = changedColliders.ColliderBoundsCenter_x(indexCC);
                    data.hitObjectColliderBoundsCenter_y_2(locData2) = changedColliders.ColliderBoundsCenter_y(indexCC);
                    data.hitObjectColliderBoundsCenter_z_2(locData2) = changedColliders.ColliderBoundsCenter_z(indexCC);                    
                    
                end
                
                %% Rename Graffi hits to the building but keep information in extra var
                
                findGr1 = contains(data.hitObjectColliderName_1,'Graffity');
                findGr2 = contains(data.hitObjectColliderName_2,'Graffity');
                
                data.hitObjectColliderisGraffiti_1 = findGr1;
                data.hitObjectColliderisGraffiti_2 = findGr2;
                
                graffitiNames = unique([unique(data.hitObjectColliderName_1(findGr1));unique(data.hitObjectColliderName_2(findGr2))]);
                helperG = table;
                helperG.GraffitiNames = graffitiNames;
                
                %now go through all Graffiti names and rename them using
                %the house list
                
                for indexGR = 1:length(graffitiNames)
                   
                    nameG = graffitiNames(indexGR);
                    locG1 = strcmp(nameG, data.hitObjectColliderName_1);
                    locG2 = strcmp(nameG, data.hitObjectColliderName_2);
                    
                    % identify the name of the belonging collider and
                    % ColliderBounds Koordinates
                    splitName = split(nameG, "_");
                    nr = splitName{2,1};
                    
                    % if the number is below 10, remove the 0 in front of it to match house names!
                    if startsWith(nr,'0')
                        nr = nr(2:end);
                    end
                    
                    % identify all the house info for renaming
                    graffBuilding = {strcat('TaskBuilding_', nr)};
                    
                    locList = find(strcmp(graffBuilding, colliderList.target_collider_name),1);
                    collBoundsCenter_x = colliderList.ColliderBoundsCenter_x(locList);
                    collBoundsCenter_y = colliderList.ColliderBoundsCenter_y(locList);                    
                    collBoundsCenter_z = colliderList.ColliderBoundsCenter_z(locList);
                    
                    % rename all instances of the graffiti collider and
                    % general coordinates 
                    % ordinal hit 1
                    data.hitObjectColliderName_1(locG1) = graffBuilding;
                    data.hitObjectColliderBoundsCenter_x_1(locG1) = collBoundsCenter_x;
                    data.hitObjectColliderBoundsCenter_y_1(locG1) = collBoundsCenter_y;
                    data.hitObjectColliderBoundsCenter_z_1(locG1) = collBoundsCenter_z;
                    
                    % ordinal hit 2
                    data.hitObjectColliderName_2(locG2) = graffBuilding;
                    data.hitObjectColliderBoundsCenter_x_2(locG2) = collBoundsCenter_x;
                    data.hitObjectColliderBoundsCenter_y_2(locG2) = collBoundsCenter_y;
                    data.hitObjectColliderBoundsCenter_z_2(locG2) = collBoundsCenter_z;
                    
                    
                    % save how collider was renamed and add it to overview
                    % only if helperG is not empty
                    
                    if height(helperG) > 0
                        
                        helperG.RenamedTo(indexGR) = graffBuilding;
                        
                    end
    
                end
                % add graffiti info of this file to overview
                % only if helperG is not empty
                
                if height(helperG) > 0
                    
                    overviewRenamedGraffiti = [overviewRenamedGraffiti; helperG];                    
                    
                end
                
                
                
                %% create new collider collumns: collider name, hit point coordinates, collider bounds center coordinates
                
                % first - add 1st order hits, 
                data.processedCollider_name = data.hitObjectColliderName_1;
                
                data.processedCollider_type = data.hitColliderType_1;
               
                data.processedCollider_hitPointOnObject_x = data.hitPointOnObject_x_1;
                data.processedCollider_hitPointOnObject_y = data.hitPointOnObject_y_1;
                data.processedCollider_hitPointOnObject_z = data.hitPointOnObject_z_1;
                
                data.processedCollider_hitObjectColliderBoundsCenter_x = data.hitObjectColliderBoundsCenter_x_1;
                data.processedCollider_hitObjectColliderBoundsCenter_y = data.hitObjectColliderBoundsCenter_y_1;
                data.processedCollider_hitObjectColliderBoundsCenter_z = data.hitObjectColliderBoundsCenter_z_1;
                
                          
                %% then verify 1st order via euclidean distance
%                 
%                 euclDist1 = sqrt((data.eyePositionCombinedWorld_x - data.hitPointOnObject_x_1).^2 +(data.eyePositionCombinedWorld_y -data.hitPointOnObject_y_1).^2 +(data.eyePositionCombinedWorld_z - data.hitPointOnObject_z_1).^2);
%                 euclDist2 = sqrt((data.eyePositionCombinedWorld_x - data.hitPointOnObject_x_2).^2 +(data.eyePositionCombinedWorld_y -data.hitPointOnObject_y_2).^2 +(data.eyePositionCombinedWorld_z - data.hitPointOnObject_z_2).^2);
%                 % check distance calculation with body information
%                 euclDist1_B = sqrt((data.playerBodyPosition_x - data.hitPointOnObject_x_1).^2 +(data.playerBodyPosition_y -data.hitPointOnObject_y_1).^2 +(data.playerBodyPosition_z - data.hitPointOnObject_z_1).^2);
%                 euclDist2_B = sqrt((data.playerBodyPosition_x - data.hitPointOnObject_x_2).^2 +(data.playerBodyPosition_y -data.hitPointOnObject_y_2).^2 +(data.playerBodyPosition_z - data.hitPointOnObject_z_2).^2);
%                 
%                 
%                 % identify all NaN rows of the colliders and exclude it
%                 % from the calculation - 
%                 notNan = not(isnan(euclDist2));
%                 
%                 % also exclude if 1. and 2. hit have the same collider name
%                 notSame = not(strcmp(data.hitObjectColliderName_1,data.hitObjectColliderName_2));
%                 
%                 selection = notNan & notSame;
%                 
%                 distanceCheck = not(euclDist1(selection) <= euclDist2(selection ));
%                 distanceCheck_B = not(euclDist1_B(selection) <= euclDist2_B(selection ));
%                 
%                 % save distance check info
%                 helper = table;
%                 helper.File = dirSess(indexET).name;
%                 helper.SumNotMatchingDistance = sum(distanceCheck);
%                 helper.BodySumNotMatchingDistance = sum(distanceCheck_B);
%                 overviewDistanceCheck = [overviewDistanceCheck; helper];               
                
                %% replace see-through colliders with 2nd hit
                % replace 1st hit with second it,
                    % if 1st hit is collider from see-through list
                    % and 2nd hit is not a collider from see-through list
                    % and 2nd hit is not empty - no collider was hit
                seeThroughCols = {'scaffold_base_02_LOD0', 'scaffold_topboard_01_LOD0', 'barbwire0', 'cyclone0', 'posts0', 'Basketball_Court-3D'};
                
                notEmpty2Hit = not(strcmp({'noHit'}, data.hitObjectColliderName_2));
                locSHCollider = zeros(height(data),1);
                
                for indexSH = 1: length(seeThroughCols)
                    loc = strcmp(seeThroughCols(indexSH), data.processedCollider_name) & not(strcmp(seeThroughCols(indexSH), data.hitObjectColliderName_2)) & notEmpty2Hit;
                    locSHCollider = locSHCollider | loc;
                end
                
                
                data.processedCollider_name(locSHCollider) = data.hitObjectColliderName_2(locSHCollider);

                data.processedCollider_type(locSHCollider) = data.hitColliderType_2(locSHCollider);

                
                data.processedCollider_hitPointOnObject_x(locSHCollider) = data.hitPointOnObject_x_2(locSHCollider);
                data.processedCollider_hitPointOnObject_y(locSHCollider) = data.hitPointOnObject_y_2(locSHCollider);
                data.processedCollider_hitPointOnObject_z(locSHCollider) = data.hitPointOnObject_z_2(locSHCollider);
                               
                data.processedCollider_hitObjectColliderBoundsCenter_z(locSHCollider) = data.hitObjectColliderBoundsCenter_x_2(locSHCollider);
                data.processedCollider_hitObjectColliderBoundsCenter_z(locSHCollider) = data.hitObjectColliderBoundsCenter_y_2(locSHCollider);
                data.processedCollider_hitObjectColliderBoundsCenter_z(locSHCollider) = data.hitObjectColliderBoundsCenter_z_2(locSHCollider);
                
                % mark replaced rows
                data.replacedRows = cell(height(data),1);
                data.replacedRows(:) = {'notReplaced'};
                data.replacedRows(locSHCollider) = {'seeThrough'};
                
                %% Replace body hits if possible
                % if the invisible player avatar was hit, 
                % replace the 1st order hit point with the 2nd hit point, if
                % 2nd hit point is not a body hit 
                % and 2nd hit point is not empty --> noHit
                % note, there are 2 body name colliders "Body and body",
                % make sure to take care of both - also check 2nd hit for
                % both names!
                
                locBody1 = strcmp({'Body'}, data.processedCollider_name) & not(strcmp({'Body'}, data.hitObjectColliderName_2)) & not(strcmp({'body'}, data.hitObjectColliderName_2)) & notEmpty2Hit;
                locBody2 = strcmp({'body'}, data.processedCollider_name) & not(strcmp({'Body'}, data.hitObjectColliderName_2)) & not(strcmp({'body'}, data.hitObjectColliderName_2)) & notEmpty2Hit;
                
%                 % check if 2nd hit is empty
%                 locBody1e = locBody1 & notEmpty2Hit;
%                 locBody2e = locBody2 & notEmpty2Hit;

                locBodyV = locBody1 | locBody2;
                
                % now replace all first order hits with the second order
                % hit information
                
                data.processedCollider_name(locBodyV) = data.hitObjectColliderName_2(locBodyV);

                data.processedCollider_type(locBodyV) = data.hitColliderType_2(locBodyV);

                
                data.processedCollider_hitPointOnObject_x(locBodyV) = data.hitPointOnObject_x_2(locBodyV);
                data.processedCollider_hitPointOnObject_y(locBodyV) = data.hitPointOnObject_y_2(locBodyV);
                data.processedCollider_hitPointOnObject_z(locBodyV) = data.hitPointOnObject_z_2(locBodyV);
                               
                data.processedCollider_hitObjectColliderBoundsCenter_z(locBodyV) = data.hitObjectColliderBoundsCenter_x_2(locBodyV);
                data.processedCollider_hitObjectColliderBoundsCenter_z(locBodyV) = data.hitObjectColliderBoundsCenter_y_2(locBodyV);
                data.processedCollider_hitObjectColliderBoundsCenter_z(locBodyV) = data.hitObjectColliderBoundsCenter_z_2(locBodyV);
                
                % mark rows where body hits were swapped
                
                data.replacedRows(locBodyV) = {'body'};
                
                
                %% Mark everything that is not in the house list and is not an agent to NH in second column data            
                
                % identify all agents

                activeA = contains(data.processedCollider_name, '_Cma');
                passiveA = contains(data.processedCollider_name, '_Sa');

                isAgent = activeA | passiveA;


                activeA2 = contains(data.hitObjectColliderName_2, '_Cma');
                passiveA2 = contains(data.hitObjectColliderName_2, '_Sa');

                isAgentin2 = activeA2 | passiveA2;



                % identify all noHouse(not a relevant house/building) colliders based on
                % collider list

                uniqueBuildingNames = unique(colliderList.target_collider_name);
                
                isInColliderList1 = false(height(data),1);
                isInColliderList2 = false(height(data),1);
                
                for indexNH = 1: length(uniqueBuildingNames)
                    
                    currentB = uniqueBuildingNames(indexNH);
                    locBuilding1 = strcmp(currentB, data.processedCollider_name);
                    
                    isInColliderList1 = isInColliderList1 | locBuilding1;
                    
                    locBuilding2 = strcmp(currentB, data.hitObjectColliderName_2);
                    
                    isInColliderList2 = isInColliderList2 | locBuilding2;
                    
                end
                
                % mark all noHouse rows in the processed collider variable
                % all rows that are not a building and not an agent
                data.processedColliderIsNH = not(isInColliderList1 | isAgent);
                
                
                % doublicate the processed collider data

                data.processedCollider_NH_name = data.processedCollider_name;
               
                data.processedCollider_NH_type = data.processedCollider_type;

                data.processedCollider_NH_hitPointOnObject_x = data.processedCollider_hitPointOnObject_x ;
                data.processedCollider_NH_hitPointOnObject_y = data.processedCollider_hitPointOnObject_y;
                data.processedCollider_NH_hitPointOnObject_z = data.processedCollider_hitPointOnObject_z;
                
                data.processedCollider_NH_hitObjectColliderBoundsCenter_x = data.processedCollider_hitObjectColliderBoundsCenter_x;
                data.processedCollider_NH_hitObjectColliderBoundsCenter_y = data.processedCollider_hitObjectColliderBoundsCenter_y;
                data.processedCollider_NH_hitObjectColliderBoundsCenter_z = data.processedCollider_hitObjectColliderBoundsCenter_z;
                

                

                % replace all 1st hits, if the 1st hit is a noHouse hit
                % and the 2nd hit is not a noHouse hit
                
                replace = (not(isInColliderList1 | isAgent)) & (isInColliderList2 | isAgentin2);
                
                data.processedCollider_NH_name(replace) = data.hitObjectColliderName_2(replace);

                data.processedCollider_NH_type(replace) = data.hitColliderType_2(replace);
                
                data.processedCollider_NH_hitPointOnObject_x(replace) = data.hitPointOnObject_x_2(replace);
                data.processedCollider_NH_hitPointOnObject_y(replace) = data.hitPointOnObject_y_2(replace);
                data.processedCollider_NH_hitPointOnObject_z(replace) = data.hitPointOnObject_z_2(replace);
                               
                data.processedCollider_NH_hitObjectColliderBoundsCenter_z(replace) = data.hitObjectColliderBoundsCenter_x_2(replace);
                data.processedCollider_NH_hitObjectColliderBoundsCenter_z(replace) = data.hitObjectColliderBoundsCenter_y_2(replace);
                data.processedCollider_NH_hitObjectColliderBoundsCenter_z(replace) = data.hitObjectColliderBoundsCenter_z_2(replace);
                
                % mark the replaced rows
                
                data.replacedRows_NH = data.replacedRows;
                data.replacedRows_NH(replace) = {'noHouse_noAgent'};
                 
                % mark which rows in this variable contain noHouse
                % colliders
                
                data.processedCollider_NH_IsNH  = not(isInColliderList1 | replace);

                %% update overviews & save data
               
                overviewProcessedColliders = [overviewProcessedColliders; unique(data.processedCollider_name)];
                overviewProcessedColliders_NH = [overviewProcessedColliders_NH; unique(data.processedCollider_NH_name)];
                
                overviewAgents = [overviewAgents; unique(data.processedCollider_name(isAgent)); unique(data.hitObjectColliderName_2(isAgentin2))];

                % save the processed data file
                
                writetable(data, [savepath num2str(currentPart) '_Session_' num2str(indexSess) '_ET_' num2str(indexET) '_data_prepared.csv']);
                
   
            end
            toc 
            
        end

    end

end            
            
%% save overviews

save([savepath 'overviewRenamedGraffiti'], 'overviewRenamedGraffiti');
save([savepath 'overviewAllColliders'], 'overviewAllColliders');
% save([savepath,'overviewDistanceCheck'], 'overviewDistanceCheck');

% identify uniqure processed colliders & save them
overviewProcessedColliders = unique(overviewProcessedColliders);
overviewProcessedColliders_NH = unique(overviewProcessedColliders_NH);

overviewAgents = unique(overviewAgents);

save([savepath 'overviewProcessedColliders'], 'overviewProcessedColliders');
save([savepath 'overviewProcessedColliders_NH'], 'overviewProcessedColliders_NH');
save([savepath 'overviewAgents'], 'overviewAgents');

disp('saved overviews');

% save missing data info
if height(missingFiles) > 0
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------');
    
    disp(strcat(height((missingFiles),' files were missing')));

    writetable(missingFiles, [savepathNewData 'missingFiles.csv']);
    writetable(missingFiles, [savepathCondensedData 'missingFiles.csv']);
    disp('saved missing file list');
    
else
    
    disp('all files were found');
    
end


disp('done');
