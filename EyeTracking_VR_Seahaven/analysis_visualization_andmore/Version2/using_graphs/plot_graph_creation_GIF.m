%% ------------------ plot_graph_creation GIF-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\graph_creation_plot_GIF\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {35};%21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

scope = 600;

% load map

map = imread ('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_New.png');



% load house list with coordinates

listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat('gazes_data_',num2str(currentPart),'.mat');
 
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
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        lastsum = 0;
        housesYaxis = 0;
        rowsAHouses = 0;
        
        xlist = [];
        ylist = [];
        appearedHouses = table;
        appearedEdges = table;
        
        
      %% Plot map to start with
        figure(4)

        imshow(map);
        alpha(0.1)
        hold on;
        
        for index = 1: height(gazedObjects)
            currentCollider = gazedObjects{index,1};
            

                        
            % what is the data point? noData? NH/Sky? House?
            
            noData = strcmp(currentCollider,'noData');
            other = strcmp(currentCollider,'sky')||strcmp(currentCollider,'NH');
            house = not(noData | other);
             

                % else if object is a house    
                 if house 
                    
                    % if it is the first item in the appeaerdHouses List
                    if width(appearedHouses) == 0
                    % if it is the first house to occur, just add house - 
                    % and just and plot it

                        hlocation= strcmp(currentCollider,coordinateList{:,1});
                        scatter(coordinateList{hlocation,2},coordinateList{hlocation,3}, 'filled', 'black');


                        appearedHouses = [appearedHouses,currentCollider];
                        saveas(gcf, strcat(savepath, 'img_', num2str(index),'.png'));

                        
                    else                        
                    % check whether it is a new house or it was already
                    % seen
                    
                            % if the house was already seen 
                            if any(strcmp(currentCollider,appearedHouses{:,:})) 
                                % & is not identical to the last one
                                if not(strcmp(currentCollider, appearedHouses{1,end}))
                                
                                    % check if edge is new - if it new, add it
                                    if not(ismember(table(appearedHouses{1,end}, currentCollider),appearedEdges))

                                        % add edge to appearedEdges in both
                                        % variations
                                        appearedEdges = [appearedEdges; appearedHouses{1,end}, currentCollider; currentCollider, appearedHouses{1,end}];

                                        % plus draw it into image
                                        coordinate1 = strcmp(appearedHouses{1,end},coordinateList{:,1});
                                        coordinate2 = strcmp(currentCollider,coordinateList{:,1});
                                        x1 = coordinateList{coordinate1,2};
                                        y1 = coordinateList{coordinate1,3};

                                        x2 = coordinateList{coordinate2,2};
                                        y2 = coordinateList{coordinate2,3};

                                        line([x1,x2],[y1,y2],'Color','k');
                                        saveas(gcf, strcat(savepath, 'img_', num2str(index),'.png'));
                                    end
                                end




                            else
                                % loop if the house was not yet seen
                                % add edge to appearedEdges in both
                                % variations
                                appearedEdges = [appearedEdges; appearedHouses{1,end}, currentCollider; currentCollider, appearedHouses{1,end}];

                                % plus draw it into image
                                coordinate1 = strcmp(appearedHouses{1,end},coordinateList{:,1});
                                coordinate2 = strcmp(currentCollider,coordinateList{:,1});
                                x1 = coordinateList{coordinate1,2};
                                y1 = coordinateList{coordinate1,3};

                                x2 = coordinateList{coordinate2,2};
                                y2 = coordinateList{coordinate2,3};

                                line([x1,x2],[y1,y2],'Color','k');
                                
                                % and add the house and draw it
                                hlocation= strcmp(currentCollider,coordinateList{:,1});
                                scatter(coordinateList{hlocation,2},coordinateList{hlocation,3}, 'filled', 'black');


                                appearedHouses = [appearedHouses,currentCollider];   
                                saveas(gcf, strcat(savepath, 'img_', num2str(index),'.png'));

                            end

                    end
                    
                 end
        end
            

    else
        disp('something went really wrong with participant list');
    end
end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

%csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');