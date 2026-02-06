%% ------------------ modify_map_WB.m-------------------------------------
% script written by Jasmin Walter


clear all;


imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location



cd 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'


%% ==================== 1. USER SETTINGS ==============================

% Distance marker specs (IDENTICAL to working version)
totalLength_m  = 500;     % total bar length [m]
patchLength_m  = 100;     % patch length [m]
rowHeight_m    = 12;       % row height [m]
marginTop_m    = 115.5;       % distance from top edge [m]

% Map scale (THIS MAP ONLY)
pix_per_m = 4.15;        % pixels per meter (your original value)

%% ==================== 2. LOAD MAP ================================
figure(1)
map = imread (strcat(imagepath,'map_natural_white.png'));
imshow(map); 
hold on;

[rows, columns, ~] = size(map);

%% ==================== 3. DISTANCE MARKER (RECTANGLES) ==============

nPatches = totalLength_m / patchLength_m;

% Horizontal positions (pixels)
xEdges_px = (0:patchLength_m:totalLength_m) * pix_per_m;

% Vertical geometry (pixels)
rowHeight_px    = rowHeight_m * pix_per_m;
yRowUpper_top   = marginTop_m * pix_per_m;
yRowLower_top   = yRowUpper_top + rowHeight_px;

%% Draw marker
for k = 1:nPatches
    if mod(k,2)==1
        colUpper = 'k';
        colLower = 'w';
    else
        colUpper = 'w';
        colLower = 'k';
    end

    xLeft  = xEdges_px(k);
    xWidth = xEdges_px(k+1) - xEdges_px(k);

    % Upper row
    rectangle('Position',[xLeft yRowUpper_top xWidth rowHeight_px], ...
              'FaceColor',colUpper,'EdgeColor','none');

    % Lower row
    rectangle('Position',[xLeft yRowLower_top xWidth rowHeight_px], ...
              'FaceColor',colLower,'EdgeColor','none');
end

%% ==================== 4. EXPORT ===================================
ax = gca;
exportgraphics(ax, ...
    fullfile(imagepath,'map_natural_500mMarker_600dpi_withoutText_newV.png'), ...
    'Resolution',600);

exportgraphics(ax, ...
    fullfile(imagepath,'map_natural_500mMarker_withoutText_newV.png'));

hold off;





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

