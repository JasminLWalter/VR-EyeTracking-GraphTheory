%% --------------------------- check Collider List---------------------

% check Collider List to identify colliders that need to be renamed
% save the new list
clear all;

cd 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\';




oList = readtable('building_collider_list.csv');



iiColliders = strcmp(oList.source_collider_name, oList.target_collider_name);

newList = oList(not(iiColliders),:);


writetable(newList, 'list_collider_changes.csv');



%% save a list with only the unique city colliders
% 
% [uColls,ia,ic] = unique(oList.target_collider_name);
% 
% 
% keep = ismember(oList.target_collider_name, uColls);
% 
% list1 = oList(keep,:);
% 
% list2 = oList(ia,:);
% 
% 
% unique1 = unique(list1.target_collider_name);
% unique2 = unique(list2.target_collider_name);
% 
% uniqueTest = [unique1; unique2];
% 
% uniqueTestTest = unique(uniqueTest);
