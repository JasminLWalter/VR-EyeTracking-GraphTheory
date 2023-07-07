%% ------------------ draw_walkingPaths_GIF_WB_Part2-------------------------------------
% script written by Jasmin Walter


clear all;


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif_walkingPaths\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif_walkingPaths\'

map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

overviewWalkingPathsX = load('overviewWalkingPathsX').overviewWalkingPathsX;
overviewWalkingPathsZ = load('overviewWalkingPathsZ').overviewWalkingPathsZ;

colors = lines(26);

for row = 1:4:1000
    
    imshow(map);
    alpha(0.3)
    hold on;
            
    for column = 1:26
        
        scatter(overviewWalkingPathsX(row,column)*4.2+2050,overviewWalkingPathsZ(row,column)*4.2+2050,15, colors(column),'filled');        
        
    end
    
    
    
   set(gca,'xdir','normal','ydir','normal')

%                         saveas(gcf, strcat(savepath, num2str(currentPart),'_gif_graph_creation_', num2str(index),'.jpg'));
   ax = gca;
   exportgraphics(ax,strcat(savepath, 'gif_walkingPaths_', num2str(row),'.png'),'Resolution',140)
   hold off 
    
        
end
