%% ------------------ modify_map_WB.m-------------------------------------
% script written by Jasmin Walter


clear all;


imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location



cd 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'

figure(1)
map = imread (strcat(imagepath,'map_natural_white.png'));

[rows, columns, numberOfColorChannels] = size(map);

imshow(map);
% alpha(0.3)
hold on;

m100 = 4.15*100;
yHeight1 = 505;
yHeight2 = 555;

line([0,m100],[yHeight1,yHeight1],'Color','k','LineWidth',5);   
line([m100,m100*2],[yHeight1,yHeight1],'Color','w','LineWidth',5);    
line([m100*2,m100*3],[yHeight1,yHeight1],'Color','k','LineWidth',5);   
line([m100*3,m100*4],[yHeight1,yHeight1],'Color','w','LineWidth',5);   
line([m100*4,m100*5],[yHeight1,yHeight1],'Color','k','LineWidth',5);   
% 
line([0,m100],[yHeight2,yHeight2],'Color','w','LineWidth',5);   
line([m100,m100*2],[yHeight2,yHeight2],'Color','k','LineWidth',5);    
line([m100*2,m100*3],[yHeight2,yHeight2],'Color','w','LineWidth',5);   
line([m100*3,m100*4],[yHeight2,yHeight2],'Color','k','LineWidth',5);   
line([m100*4,m100*5],[yHeight2,yHeight2],'Color','w','LineWidth',5); 

% text(m100*5 + 50,yHeight2-25,'500 m','FontSize',8, 'FontName', 'Helvetica');


% find height of the map with markers
% scatter(columns,476,'r')
% scatter(columns,476.5,'b')
% scatter(columns,477,'g')
% 
% 
% scatter(columns,3622,'r')
% scatter(columns,3622.5,'b')
% scatter(columns,3623,'g')

% saveas(gcf,strcat(imagepath,'map_natural_500mMarker.png'));
width = columns/4.15;
height = (3622.5 - 476.5)/4.15;
disp('width of map')
disp(width)
disp('height of map')
disp(height)

% text(100,3770,{'Map width =  ','Map height =  '},'FontSize',8, 'FontName', 'Helvetica');
% text(700,3770,{strcat(num2str(width),'m'),strcat(num2str(height),'m')},'FontSize',8, 'FontName', 'Helvetica');
% 



ax = gca;
exportgraphics(ax,strcat(imagepath,'map_natural_500mMarker_600dpi_withoutText.png'),'Resolution',600)
exportgraphics(ax,strcat(imagepath,'map_natural_500mMarker_withoutText.png'))


hold off
