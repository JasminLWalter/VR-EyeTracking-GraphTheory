%% ------------------striking_image_graphPaper_taskVis_Gifm-------------------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;

%% adjust the following variables: 
tic

savepath = 'E:\WestbrookProject\Spa_Re\control_group\Analysis\visualization_graph_plots\gif_strikingImage_Paper\taskPrep\';
imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'E:\WestbrookProject\Spa_Re\TaskData_controlGroup\preProcessing\3_processedGazes\'

% PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004 1005 1008 1017 1018 1021};
% PartList = {1008 1018 1022 1023};
% PartList = {1008 1022 1023};
PartList = {1010};

%-----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

% upper and lower boundaries of map
lowerY = 474.5; 
upperY = 3620.5; 


% prepare some plotting info:
map_min = 20;
map_max = 4000;


% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);
 
% colors = lines(Number);
colorSelect = parula(20);
% colors = colorSelect([2, 8, 16],:);
colors = colorSelect([8, 16, 2],:);

colors(2,1) = colors(2,1) + 0.05;
colors(2,2) = colors(2,2) - 0.05;
colors2 = colors;


for index = 1:height(colors)
    
    hsv        = rgb2hsv(colors(index,:));     % [H S V]

    hsv(3)     = hsv(3)*0.7;     % darken by 40 % (only the Value channel)
    colors2(index,:) = hsv2rgb(hsv);   % back to RGB: 0.0814  0.3789  0.5372


end

%% load data

% data1 = load('1008_interpolatedColliders_5Sessions_WB.mat');
data = readtable('1010_TA_ET2_data_processed_gazes.csv');

p2b = readtable('E:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\overviewTable_P2B_Prep_complete.csv');

part = p2b.SubjectID == 1010;
trial1 = p2b.TrialOrder ==1;
p2b_select = p2b(part&trial1,:);
p2b_select = sortrows(p2b_select, 'TimeStampBegin', 'ascend');

% load raw data as well
rawData_unix = readtable('E:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\df_PTB_Ctrl_Preprocessed_UnixTS_withEndTS.csv');
part2 = rawData_unix.SubjectID == 1010;
rawData_selection = rawData_unix(part2,:);
rawData_selection = sortrows(rawData_selection, 'TimeStampBegin', 'ascend');
trialRows = rawData_selection(1:56,:);



% process and merge data info

processedData = table;

for dIdx = 1:height(trialRows)

    currentTrial = trialRows(dIdx,:);


    startRow = find(data.timeStampDataPointStart >= currentTrial.TimeStampBegin,1,'first');
    endRow = find(data.timeStampDataPointEnd >= currentTrial.TimeStampEnd,1,'first');

    dataSelection = data(startRow:endRow,:);
    dataSelection.trialNr = repmat(dIdx, height(dataSelection), 1);
    dataSelection.TargetBuildingName = repmat(currentTrial.TargetBuildingName, height(dataSelection), 1);
    % dataSelection.TargetBuildingPosition_x = repmat(currentTrial.TargetBuildingPosition_x, height(dataSelection), 1);
    % dataSelection.TargetBuildingPosition_z = repmat(currentTrial.TargetBuildingPosition_z, height(dataSelection), 1);

    dataSelection.PointerPosition_x = repmat(currentTrial.PointerPosition_x, height(dataSelection), 1);
    dataSelection.PointerPosition_z = repmat(currentTrial.PointerPosition_z, height(dataSelection), 1);

    dataSelection.PointerDirection_x = repmat(currentTrial.PointerDirection_x, height(dataSelection), 1);
    dataSelection.PointerDirection_z = repmat(currentTrial.PointerDirection_z, height(dataSelection), 1);



    processedData = [processedData; dataSelection];

end

printTimeInfo = [1,(100:100:height(processedData)), height(processedData)];


% testi = find(p2b_select.TimeStampBegin(1) >= data.timeStampDataPointStart,1,'first');

% %% 
% % ---------- figure and video ---------------------------------------
% fig = figure('Visible','off', ...
%              'Color','w', ...
%              'Position',[100 100 900 900]);   % fixed pixel size
% ax  = axes('Parent',fig);
% 
% % mapHandle = imshow(map,'Parent',ax);        % background image
% % alpha(mapHandle,0.3)
% % 
% % fig = figure('Visible','off','Color','w','Position',[100 100 W H]);
% % ax  = axes('Parent',fig);
% hold(ax,'on')
% 
% % Make axes fill the figure and hide ticks/border (add these lines here)
% set(ax,'Units','normalized','Position',[0 0 1 1], ...
% 'ActivePositionProperty','position', ...
% 'LooseInset',[0 0 0 0], ...
% 'XTick',[],'YTick',[],'Box','off','Color','none');
% 
% % Lock limits to the map so imshow doesn't change them
% % set(ax,'XLim',[0.5, W+0.5], 'YLim',[0.5, H+0.5]);
% % axis(ax,'manual')
% 
% 
% v = VideoWriter(fullfile(savepath,'gazeGraphs.mp4'),'MPEG-4');
% v.FrameRate = 30;
% open(v)
% 
% % Participant colors (marker and gaze graph use the same color per participant)
% names  = {'A','B','C'};

% % ---------- figure and video ---------------------------------------
% fig = figure('Visible','off','Color','w','Position',[100 100 900 900]);
% % fig = figure('Units','pixels','Position',[100 100 1350 1350]); % [left, bottom, width, height]
% ax  = axes('Parent',fig,'Units','normalized','Position',[0 0 1 1]);
% hold(ax,'on')


% % Fill the figure area and remove outer white frame
% set(ax,'Units','normalized','Position',[0 0 1 1], 'LooseInset',[0 0 0 0], ...
% 'XTick',[],'YTick',[],'Box','off','Color','none');
% axis(ax,'manual')   % lock limits (do NOT flip here)

% names  = {'A','B','C'};

% ---------- figure and video ---------------------------------------
fig = figure('Visible','off','Color','w','Position',[100 100 900 900]);
ax  = axes('Parent',fig);
hold(ax,'on')

% Fill the figure area and remove outer white frame
set(ax,'Units','normalized','Position',[0 0 1 1], 'LooseInset',[0 0 0 0], ...
'XTick',[],'YTick',[],'Box','off','Color','none');
axis(ax,'manual')   % lock limits (do NOT flip here)



%% video info----------------------------------------------------------------------------
% 
%-----------------------------------------------------------------------------------------
v = VideoWriter(fullfile(savepath,'taskVisualization2.mp4'),'MPEG-4');
v.FrameRate = 30;
open(v)


% Participant labels and colors
names  = {'A','B','C'};

% Precompute image size to lock axes limits
[H,W,~] = size(map);
set(ax,'XLim',[0.5, W+0.5],'YLim',[0.5, H+0.5])

% legend specs
%    % ================= Legend (bottom-right) =================
% Tweak these
rectX = 0.76;   % left of rectangle (normalized 0..1)
rectY = 0.02;   % bottom of rectangle
rectW = 0.32;   % width of rectangle
rectH = 0.23;   % height of rectangle

rowStep   = 0.02; % vertical spacing per row
padBottom = 0.11; % bottom padding inside rectangle
fontSz    = 8;
markSz    = 8;
markerYFracInRow = 0.4; % 0=bottom, 0.5=center, 1=top of row

% Columns inside rectangle (as fraction of its width)
colLabel  = 0.03; % "Participant X: position"
colMarker = 0.10; % marker center
colAnd    = 0.20; % " and "
colGG     = 0.54; % "gaze graph"
colL1     = 0.045;
colL2     = 0.15;

speedGapAbove = 0.008;      % vertical gap between rect and speed line
% speedXNorm    = 0.77;       % horizontal position of the ⏩ symbol
colSpeed = 0.51;

titleXNorm = 0.50;          % 0 = left edge of map, 1 = right edge
titleYNorm = 0.95;          % 0 = bottom, 1 = top of map


% Convert the rectangle from normalized to data units and draw it
xl = get(ax,'XLim'); yl = get(ax,'YLim'); ydir = get(ax,'YDir');
x1 = xl(1) + (xl(2)-xl(1)) * rectX;
x2 = xl(1) + (xl(2)-xl(1)) * (rectX + rectW);

if strcmpi(ydir,'reverse')
    y1 = yl(2) - (yl(2)-yl(1)) * (rectY + rectH);
    y2 = yl(2) - (yl(2)-yl(1)) *  rectY;
else
    y1 = yl(1) + (yl(2)-yl(1)) *  rectY;
    y2 = yl(1) + (yl(2)-yl(1)) * (rectY + rectH);
end

% Precompute normalized x positions inside the rectangle
xLabel  = rectX + rectW*colLabel;
xMarker = rectX + rectW*colMarker;
xAnd    = rectX + rectW*colAnd;
xL1     = rectX + rectW*colL1;
xL2     = rectX + rectW*colL2;
speedXNorm = rectX + rectW*colSpeed;

% Row baselines (normalized). Bottom row = time, then A, B, C
% yTime = rectY + padBottom;
% yA    = yTime + rowStep;
% yB    = yA    + rowStep;
% yC    = yB    + rowStep;

yD = rectY + padBottom;
yC = yD + rowStep;
yB    = yC + rowStep;
yA    = yB    + rowStep;
yTime    = yA    + rowStep*1.5;

% y-position of speed line
ySpeed = rectY + rectH + speedGapAbove;


% % ---------------------------------------------------------------
% % video speed text info
% gapAbove    = 0.008;        % vertical gap between rectangle and new row
% ySpeed      = rectY + rectH + gapAbove;      % normalised y-coord
% xSpeed      = 0.77;       % align with legend's text column
% 
% % ---------------------------------------------------------------
% title position vars
titleXNorm  = 0.50;     % 0 = left, 1 = right    (tweak freely)
titleYNorm  = 0.935;     % 0 = bottom, 1 = top    (tweak freely)

% Participant rows (A, B, C)
names = {'A','B','C'};
yRows = [yA, yB, yC, yD];
colorIdx = [2 1 3]; 



% ---------- main loop ----------------------------------------------
disp('start plotting frames')

speedFactor = 5;
time = ([processedData.timeStampRS] - processedData.timeStampRS(1))*1000;

isLastSample = false;
% for frameI = 1:length(tau_ms)
for frameI = 1:1800
    % msWanted  = tau_ms(frameI); % elapsed ms
    msWanted = (frameI*(1000/30))*speedFactor;   
    checkNext =  ((frameI+1)*(1000/30))*speedFactor;   


    cla(ax)                         % erase previous foreground
    % fig = figure('Visible', 'off');
    % imshow(map, 'Border','tight');
    % alpha(0.3)
    % hold on;
    % cla(ax)                         % erase previous foreground
    % mapHandle = imshow(map,'Parent',ax);   %  ← draw background again
    % alpha(mapHandle,0.3)
    % hold(ax,'on')  


    % Draw background map
    % mapHandle = imshow(map,'Parent',ax);   % this won't change limits (axis manual)
    % set(mapHandle,'AlphaData',0.3)
    mapH = imshow(map,'Parent',ax,'Border','tight');  % draws edge-to-edge
    set(mapH,'AlphaData',0.3)
    uistack(mapH,'bottom')



    dataIndex = find(time >= msWanted,1,'first');
    dataNext = find(time >= checkNext,1,'first');


    if dataIndex >= height(processedData) | isempty(dataIndex) | isempty(dataNext)
        isLastSample = true;
        % disp('end of data')
    elseif ~(processedData.trialNr(dataIndex) == processedData.trialNr(dataNext))
        % disp('switch trials')
        isLastSample = true;
    end

    % 
    % figure(frameI)
    % 
    % mapH = imshow(map);  % draws edge-to-edge
    % set(mapH,'AlphaData',0.3)
    % hold on


    % plot target building   

    % % add controller info
    % mapX = dataSelection.handRightPosition_x*4.2 + 2050;
    % mapZ = dataSelection.handRightPosition_z*4.2 + 2050;

     % target building information
    house = ismember(houseList.target_collider_name, processedData.TargetBuildingName(dataIndex));
    xH = houseList.transformed_collidercenter_x(house);
    yH = houseList.transformed_collidercenter_y(house);

    % % add line from last controller position to target building
    Px = processedData.handRightPosition_x(dataIndex)*4.2 + 2050;
    Pz = processedData.handRightPosition_z(dataIndex)*4.2 + 2050;
    % plot(ax, [Px xH], [Pz yH], '--','Color','red', 'LineWidth', 0.1);
     % plot(ax, [Px xH], [Pz yH], 'LineStyle','none', 'Marker','.', 'MarkerEdgeColor','red', 'MarkerSize',5);
    line(ax, [Px, xH], [Pz, yH], 'Color', 'red', 'LineWidth', 0.1, 'LineStyle', ':');


    % plot target building target
    scatter(ax, xH, yH, 30, 'red', 'filled');
    scatter(ax, xH, yH, 15, 'white', 'filled');
    scatter(ax, xH, yH, 5, 'red', 'filled');

    % 
    % 
    % plot pointing line

    if isLastSample

            Px = processedData.PointerPosition_x(dataIndex)*4.2 + 2050;
            Pz = processedData.PointerPosition_z(dataIndex)*4.2 + 2050;
            Dx = processedData.PointerDirection_x(dataIndex);
            Dz = processedData.PointerDirection_z(dataIndex);
        
        
            % Use new boundaries!
            [xEnd, zEnd] = extend_to_map_edge(Px, Pz, Dx, Dz, 1, 4096, lowerY, upperY);
        
            % plot pointing vector
            % plot(ax,[Px xEnd], [Pz zEnd], 'Color', colorMap(i,:), 'LineWidth', 1);
            plot(ax,[Px xEnd], [Pz zEnd], '-', 'Color', 'green', 'LineWidth', 1);


    else
        Px = processedData.handRightPosition_x(dataIndex)*4.2 + 2050;
        Pz = processedData.handRightPosition_z(dataIndex)*4.2 + 2050;
        Dx = processedData.handRightDirectionForward_x(dataIndex);
        Dz = processedData.handRightDirectionForward_z(dataIndex);
    
    
        % Use new boundaries!
        [xEnd, zEnd] = extend_to_map_edge(Px, Pz, Dx, Dz, 1, 4096, lowerY, upperY);
    
        % plot pointing vector
        % plot(ax,[Px xEnd], [Pz zEnd], 'Color', colorMap(i,:), 'LineWidth', 1);
        plot(ax,[Px xEnd], [Pz zEnd], '--', 'Color', 'green', 'LineWidth', 1);

    end

    % plot scatter location
    scatter(ax, processedData.hmdPosition_x(dataIndex)*4.2+2050,processedData.hmdPosition_z(dataIndex)*4.2+2050, 20, colors2(1,:),'filled');


    % 
    % % for index = 1:height(dataSelection)
    % % 
    % %     scatter(dataSelection.handRightDirectionForward_x*4.2+2050,dataSelection.handRightDirectionForward_z*4.2+2050, 15, colors2(1,:),'filled');
    % % 
    % % 
    % % end

    set(gca,'xdir','normal','ydir','normal')

    % hold off
    % figure(trialIdx+5)
    % scatter(dataSelection.handRightDirectionForward_x,dataSelection.handRightDirectionForward_z,15,dataSelection.timeStampRS, 'filled');

    %% double check angle calculations: 
    % 
    % 
    % Dx = dataSelection.handRightDirectionForward_x(end);
    % Dz = dataSelection.handRightDirectionForward_z(end);
    % vecToTarget = [xH - Px, yH - Pz];    % From controller to target
    % 
    % % (Assuming row vectors)
    % a = [Dx, Dz];
    % b = vecToTarget;
    % 
    % % Normalize (optional but recommended for numerical stability)
    % a = a / norm(a);
    % b = b / norm(b);
    % 
    % % Clamp dot product to [-1,1] to avoid domain errors from numerical noise
    % cosTheta = max(-1, min(1, dot(a, b)));
    % 
    % % Angle in radians:
    % theta_rad = acos(cosTheta);
    % 
    % % If you want degrees:
    % theta_deg = rad2deg(theta_rad);
% 
% 
%     % Preallocate
% 
%         % 1. Get the controller's pointing (forward) vector (projected to XZ)
%         % forwardVec = [ ...
%         %     dataSelection.handRightDirectionForward_x(end), ...
%         %     dataSelection.handRightDirectionForward_z(end)];
% 
%         forwardVec = [ ...
%             currentTrial.PointerDirection_x(end), ...
%             currentTrial.PointerDirection_z(end)];
% 
%         % 2. Controller/participant position (XZ)
%         % pos = [ ...
%         %     dataSelection.handRightPosition_x(end), ...
%         %     dataSelection.handRightPosition_z(end)];
%         % pos = [ ...
%         %     dataSelection.hmdPosition_x(end), ...
%         %     dataSelection.hmdPosition_z(end)];
%         pos = [ ...
%             currentTrial.PointerPosition_x(end), ...
%             currentTrial.PointerPosition_z(end)];
% 
%         % 3. Target building position (XZ)
%         % targetPos = [ ...
%         %     houseList.ColliderBoundsCenter_x(house), ...
%         %     houseList.ColliderBoundsCenter_z(house)];
%         targetPos = [ ...
%             currentTrial.TargetBuildingPosition_x, ...
%             currentTrial.TargetBuildingPosition_z];
% 
%         % 4. Vector from controller to target (XZ)
%         toTarget = targetPos - pos;  % target - controller pos
% 
%         % 5. Normalize both vectors
%         fwdNorm = forwardVec / norm(forwardVec);
%         tgtNorm = toTarget / norm(toTarget);
% 
%         % 6. Dot product and clamp for acos (for safety)
%         dp = dot(fwdNorm, tgtNorm);
%         dp = max(-1, min(1, dp));  % clamp due to FP precision
% 
%         % 7. Calculate unsigned (absolute) angle in degrees
%         angleDeg = acosd(dp);
% 
%         % 8. Store
%         recalculatedAngle = angleDeg;
% 
% % Now recalculatedAngle(i) matches your R RecalculatedAngle column
% 
% 
%     disp('------------')
%     fprintf('P2B Recalculated error: %.2f degrees\n', currentTrial.RecalculatedAngle);
%     fprintf('newly calculated error: %.2f degrees\n', recalculatedAngle);
% 
%     % Let's say your hypothesis angle is 'expected_deg'
%     error = abs(recalculatedAngle - currentTrial.RecalculatedAngle);
%     fprintf('difference in error: %.2f degrees\n', error);
% 
% 
%     fprintf('difference in time: %.6f s\n', currentTrial.TimeStampEnd - dataSelection.timeStampDataPointStart(end));
%     fprintf('difference in time: %.6f s\n', currentTrial.TimeStampEnd - dataSelection.timeStampDataPointEnd(end));
% 
% 
% 

            
%% add legend and text descriptions
    set(gca,'xdir','normal','ydir','normal')

    xl = get(ax,'XLim');
    yl = get(ax,'YLim');
    ydir = get(ax,'YDir');

    x1 = xl(1) + (xl(2)-xl(1)) * rectX;
    x2 = xl(1) + (xl(2)-xl(1)) * (rectX + rectW);

    y1 = yl(1) + (yl(2)-yl(1)) *  rectY;
    y2 = yl(1) + (yl(2)-yl(1)) * (rectY + rectH);

    rectangle(ax, 'Position',[x1, y1, x2-x1, y2-y1], ...
    'FaceColor','w', 'EdgeColor','none', 'Clipping','off');

    % Time row
    totalSec = floor((msWanted/1000) + (60*150));
    hh = floor(totalSec/3600);
    mm = floor(mod(totalSec,3600)/60);
    ss = mod(totalSec,60);

    tnr = processedData.trialNr(dataIndex);

    text(ax, xLabel, yTime, sprintf('Trial %02d (exp. time: %02d:%02d:%02d)', tnr, hh, mm, ss), ...
    'Units','normalized','Interpreter','none', ...
    'HorizontalAlignment','left','VerticalAlignment','bottom', ...
    'FontSize',(fontSz+3),'Color','k','Clipping','off');


    % legend text and markers
    
    lineLen = 14; %

    text(ax, xAnd, yRows(1), sprintf('Position of participant %s', names{2}), ...
        'Units','normalized','Interpreter','none', ...
        'HorizontalAlignment','left','VerticalAlignment','bottom', ...
        'FontSize',fontSz,'Color','k','Clipping','off');
        % Marker (convert normalized -> data)
    
    mx1Norm = xMarker;
    myNorm = yRows(1) + markerYFracInRow*rowStep;
    mxData = xl(1) + (xl(2)-xl(1)) * mx1Norm;
    myData = yl(1) + (yl(2)-yl(1)) * myNorm;

    plot(ax, mxData, myData, 'o', ...
         'MarkerFaceColor', colors2(colorIdx(2), :), ...
         'MarkerEdgeColor','none', ...
         'MarkerSize', 5);

    % ------------------------------
        text(ax, xAnd, yRows(2), sprintf('Controller direction', names{2}), ...
        'Units','normalized','Interpreter','none', ...
        'HorizontalAlignment','left','VerticalAlignment','bottom', ...
        'FontSize',fontSz,'Color','k','Clipping','off');
        % Marker (convert normalized -> data)
        mx1Norm = xL1;
        mxData1 = xl(1) + (xl(2)-xl(1)) * mx1Norm;
        myData1 = 3.170;
        mx2Norm = xL2;
        mxData2 = xl(1) + (xl(2)-xl(1)) * mx2Norm;

        myNorm = yRows(2) + markerYFracInRow*rowStep;
        myData = yl(1) + (yl(2)-yl(1)) * myNorm;

    % plot(ax, mxData,myData, '--', ...
    %      'MarkerFaceColor', 'green', ...
    %      'MarkerEdgeColor','none', ...
    %      'MarkerSize',markSz);
    plot(ax, [mxData1 mxData2], [myData myData], '--', ...
        'Color', 'g', 'LineWidth', 1);

    % --------

    text(ax, xAnd, yRows(3), sprintf('Submitted pointing direction', names{2}), ...
        'Units','normalized','Interpreter','none', ...
        'HorizontalAlignment','left','VerticalAlignment','bottom', ...
        'FontSize',fontSz,'Color','k','Clipping','off');
        % Marker (convert normalized -> data)
        mx1Norm = xMarker;
        myNorm = yRows(3) + markerYFracInRow*rowStep;
        mxData = xl(1) + (xl(2)-xl(1)) * mx1Norm;
        myData = yl(1) + (yl(2)-yl(1)) * myNorm;

    % plot(ax, mxData, myData, '-', ...
    %      'MarkerFaceColor', 'green', ...
    %      'MarkerEdgeColor','none', ...
    %      'MarkerSize',markSz);

    myNorm2 = yRows(3) + markerYFracInRow*rowStep;
    myData2 = yl(1) + (yl(2)-yl(1)) * myNorm2;

    plot(ax, [mxData1 mxData2], [myData2 myData2], '-', ...
        'Color', 'g', 'LineWidth', 1);

    % plot target building info

    text(ax, xAnd, yRows(4), sprintf('Target building', names{2}), ...
        'Units','normalized','Interpreter','none', ...
        'HorizontalAlignment','left','VerticalAlignment','bottom', ...
        'FontSize',fontSz,'Color','k','Clipping','off');

    myNorm4 = yRows(4) + markerYFracInRow*rowStep;
    myData4 = yl(1) + (yl(2)-yl(1)) * myNorm4;
    
    plot(ax, [mxData1 mxData2], [myData4 myData4], ':', ...
        'Color', 'r', 'LineWidth', 0.1);
    
    plot(ax, mxData, myData4, 'o', ...
         'MarkerFaceColor', 'r', ...
         'MarkerEdgeColor','none', ...
         'MarkerSize', 8);
    plot(ax, mxData, myData4, 'o', ...
         'MarkerFaceColor', 'w', ...
         'MarkerEdgeColor','none', ...
         'MarkerSize', 5);
    plot(ax, mxData, myData4, 'o', ...
         'MarkerFaceColor', 'r', ...
         'MarkerEdgeColor','none', ...
         'MarkerSize', 3);


    % Let's pick 3 y's in normalized units:
   % ---- Custom Legend Block (just plot+text for 3 rows, loop style) ----

    % Marker/line x-position and text x position (normalized, to data units)
% mxNorm = xMarker;
% txNorm = xLabel;
% 
% mxData = xl(1) + (xl(2)-xl(1)) * mxNorm;   % marker x (data)
% txData = xl(1) + (xl(2)-xl(1)) * txNorm;   % text x (data)
% 
% % for each row, y-position for marker/line (normalized, to data units)
% myNorm1 = yRows(1) + markerYFracInRow*rowStep;
% myNorm2 = yRows(2) + markerYFracInRow*rowStep;
% myNorm3 = yRows(3) + markerYFracInRow*rowStep;
% 
% myData1 = yl(1) + (yl(2)-yl(1)) * myNorm1;
% myData2 = yl(1) + (yl(2)-yl(1)) * myNorm2;
% myData3 = yl(1) + (yl(2)-yl(1)) * myNorm3;
% 
% tyData1 = yl(1) + (yl(2)-yl(1)) * yRows(1);
% tyData2 = yl(1) + (yl(2)-yl(1)) * yRows(2);
% tyData3 = yl(1) + (yl(2)-yl(1)) * yRows(3);
% 
% markSz = 8;
% lineLen = 14; % Length of green lines (data units)
% 
% % ===== ROW 1: PARTICIPANT MARKER, Your Color =====
% plot(ax, mxData, myData1, 'o', ...
%     'MarkerFaceColor', colors2(colorIdx(2), :), ...
%     'MarkerEdgeColor', 'none', ...
%     'MarkerSize', markSz);
% 
% text(ax, txData, tyData1, sprintf('Participant %s: location', names{2}), ...
%     'Units', 'data', 'Interpreter', 'none', ...
%     'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
%     'FontSize', fontSz, 'Color', 'k', 'Clipping', 'off');
% 
% % ===== ROW 2: GREEN DASHED LINE =====
% lx1 = mxData - lineLen/2;
% lx2 = mxData + lineLen/2;
% plot(ax, [lx1 lx2], [myData2 myData2], '--', ...
%     'Color', 'g', 'LineWidth', 2);
% 
% text(ax, txData, tyData2, 'Direction of pointing controller', ...
%     'Units', 'data', 'Interpreter', 'none', ...
%     'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
%     'FontSize', fontSz, 'Color', 'k', 'Clipping', 'off');
% 
% % ===== ROW 3: GREEN SOLID LINE =====
% lx1 = mxData - lineLen/2;
% lx2 = mxData + lineLen/2;
% plot(ax, [lx1 lx2], [myData3 myData3], '-', ...
%     'Color', 'g', 'LineWidth', 2);
% 
% text(ax, txData, tyData3, 'Pointing choice', ...
%     'Units', 'data', 'Interpreter', 'none', ...
%     'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
%     'FontSize', fontSz, 'Color', 'k', 'Clipping', 'off');



    %% add additional row
    % extra row above the rectangle   (row "0")

    % ----- string that shows speed (example uses the LaTeX triangles) ---

    rowString = sprintf('$\\triangleright\\!\\triangleright\\; %.0fx$', ...
                    speedFactor);


    text(ax, speedXNorm, ySpeed, rowString, ...
         'Units','normalized','Interpreter','latex', ...
         'HorizontalAlignment','left','VerticalAlignment','bottom', ...
         'FontSize', (fontSz+3), 'FontWeight','bold', ...
         'Color','k','Clipping','off');


    %% ---------------------------------------------------------------
    % centred title inside the map

    % text(ax, titleXNorm, titleYNorm, ...
    %      'Free exploration of the VR city (2.5 hours)', ...
    %      'Units','normalized', ...
    %      'HorizontalAlignment','center','VerticalAlignment','top', ...
    %      'FontSize', 14, 'FontWeight','bold', ...
    %      'Interpreter','none', 'Color','k', 'Clipping','off');

    xTitle = xl(1) + (xl(2)-xl(1))*titleXNorm;

    if strcmpi(ydir,'reverse')
        yTitle = yl(2) - (yl(2)-yl(1))*titleYNorm;
    else
        yTitle = yl(1) + (yl(2)-yl(1))*titleYNorm;
    end
    % 
    text(ax, xTitle, yTitle, ...
         'Pointing-to-building task (participant B)', ...
         'HorizontalAlignment','center','VerticalAlignment','top', ...
         'FontWeight','bold','FontSize',14,'Color','k', ...
         'Clipping','off');
    % 
    % text(ax, xTitle, yTitle, ...
    %      'VR setup - pointing task - (real-time)', ...
    %      'HorizontalAlignment','center','VerticalAlignment','top', ...
    %      'FontWeight','bold','FontSize',10,'Color','k', ...
    %      'Clipping','off');


    % saveas(gcf, strcat(savepath, '3Parts_gazeGraphs_+Walking5min.jpg'));
    % ax = gca;
    % exportgraphics(ax,strcat(savepath, num2str(frameI),'_3Parts_test.jpg'),'Resolution',200)

    if isLastSample

        drawnow limitrate nocallbacks
        % writeVideo(v,getframe(fig))

        for i = 1:30
            writeVideo(v,getframe(fig))
        end
        isLastSample = false;

    else

        drawnow limitrate nocallbacks
        writeVideo(v,getframe(fig))

    end

    % hold off 
    if ismember(frameI, printTimeInfo)

        fprintf('Frame %4d | elapsed %6.2f min | %s\n', ...
        frameI, toc/60, string(datetime('now','Format','yyyy-MM-dd HH:mm:ss')));
    end

end

disp('saving')

close(v) %34.064 current file

disp('done')
fprintf('Elapsed %6.2f min | %s\n', ...
         toc/60, string(datetime('now','Format','yyyy-MM-dd HH:mm:ss')));



       % ax = gca;
       % exportgraphics(ax,strcat(savepath, num2str(currentPart),'_gazeGraph_5min.png'),'Resolution',140)
       % hold off 








%% convert videos
% convert videos to fixed 30 fps frame rate (while the script is designed
% like that, other programs might not recognize this and want to do their
% own less accurace conversion
% 
% inputFile  = fullfile(savepath, 'taskVisualization2.mp4');
% outputFile = fullfile(savepath, 'taskVisualization2_fixed.mp4');
% system(sprintf('ffmpeg -y -i "%s" -r 30 -vf fps=30 -c:v libx264 -preset fast -c:a aac -ar 48000 "%s"', ...
%                inputFile, outputFile));
% 
% 



function [xEnd, zEnd] = extend_to_map_edge(x0, z0, dx, dz, map_minX, map_maxX, lowerY, upperY)
    t = [];
    % Vertical edges: x = map_minX and x = map_maxX
    if abs(dx) > 1e-8
        t1 = (map_minX - x0)/dx;
        t2 = (map_maxX - x0)/dx;
        z1 = z0 + t1*dz;
        z2 = z0 + t2*dz;
        if t1 > 0 && lowerY <= z1 && z1 <= upperY; t(end+1)=t1; end
        if t2 > 0 && lowerY <= z2 && z2 <= upperY; t(end+1)=t2; end
    end
    % Horizontal edges: z = lowerY and z = upperY
    if abs(dz) > 1e-8
        t3 = (lowerY - z0)/dz;
        t4 = (upperY - z0)/dz;
        x3 = x0 + t3*dx;
        x4 = x0 + t4*dx;
        if t3 > 0 && map_minX <= x3 && x3 <= map_maxX; t(end+1)=t3; end
        if t4 > 0 && map_minX <= x4 && x4 <= map_maxX; t(end+1)=t4; end
    end
    if isempty(t)
        xEnd = NaN; zEnd = NaN;
    else
        tmin = min(t);
        xEnd = x0 + tmin*dx;
        zEnd = z0 + tmin*dz;
    end
end

%% figure out lower and upper map boundaries

% figure(100)
% mapH = imshow(map);
% set(mapH,'AlphaData',0.3)
% hold on
% 
% lowerY = 474.5; 
% upperY = 3620.5; 
% 
% xLims = xlim/2;  % Get the horizontal range of your map axes
% 
% % Draw two horizontal lines
% plot(xLims, [lowerY lowerY], 'r-', 'LineWidth', 1)
% plot(xLims, [upperY upperY], 'r-', 'LineWidth', 1)
% hold off
%%