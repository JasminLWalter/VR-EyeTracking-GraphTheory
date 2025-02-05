%% ------------------ draw_all_walkingPaths_HA----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 5th and last step of prepreocessing pipeline.
% The script creates the gaze graphs from the gaze events
% This step is unnecessary if analysis does not involve graphs
% The script creates unweighted and binary graph objects the gaze events. 
% To achieve this it removes all repetition and self references from graphs
% and removes noData node after creation of graph

% Input:  
% gazes_data_V3.mat = a new data file containing all gazes

% Output:
% Graph_V3.mat = the gaze graph object for every participant
% Missing_Participant_Files.mat = contains all participant numbers where the
%                                  data file could not be loaded


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'F:\Cyprus_project_overview\data\comparison2VR\walkingPaths_HA\';


cd 'F:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\pre-processing\velocity_based\step3_gazeProcessing\';

imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location



% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7264 7412 7842 8007 8469 8673 9472 9502 9586 9601};

%-------------------------------------------------------------------------------

overview_coordinates = table;

Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;



for indexPart = 1:Number
    tic
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));

    gazesData = table;

    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);
        

        if isempty(dirSess)
            
            disp('missing session file !!!!!!!!!!!!')
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data  

            for indexET = 1:length(dirSess)
                tic
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                % data = readtable([num2str(1004) '_Session_1_ET_1_data_correTS_mad_wobig.csv']);
                data = readtable(dirSess(indexET).name);

               

                helperTable = table;
                helperTable.X = data.playerBodyPosition_x;
                helperTable.Y = data.playerBodyPosition_y;
                helperTable.Z = data.playerBodyPosition_z;


                overview_coordinates = [overview_coordinates; helperTable];


            end
        end
    end

end


%%


% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

imshow(map);
alpha(0.6)
hold on;
    
scatter(overview_coordinates.X*4.2+2050,overview_coordinates.Z*4.2+2050,0.5, [0.24,0.15,0.66],'filled');        


   
set(gca,'xdir','normal','ydir','normal')

%                         saveas(gcf, strcat(savepath, num2str(currentPart),'_gif_graph_creation_', num2str(index),'.jpg'));
ax = gca;
exportgraphics(ax,strcat(savepath, 'all_walkingPaths_VR.png'),'Resolution',140)
hold off 
    



%%

if(height(missingFiles)<1)
    disp('no files were missing')
else
    disp(missingFiles)
end


disp('done');