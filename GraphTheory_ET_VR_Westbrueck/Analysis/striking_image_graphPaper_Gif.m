%% ------------------striking_image_graphPaper_Gifm-------------------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;

%% adjust the following variables: 
tic

savepath = 'E:\WestbrookProject\Spa_Re\control_group\Analysis\visualization_graph_plots\gif_strikingImage_Paper\prep\';
imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'E:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\interpolatedColliders\'

% PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004 1005 1008 1017 1018 1021};
% PartList = {1008 1018 1022 1023};
% PartList = {1008 1022 1023};
PartList = {1010 1022 1023};

%-----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));
% Map size
% [H,W,~] = size(map);

% % % Make dimensions even for H.264 (optional)
% padRight  = mod(W,2) == 1;   % true if W is odd
% padBottom = mod(H,2) == 1;   % true if H is odd
% 
% if padRight || padBottom
%     if ndims(map) == 2
%         map = padarray(map,[padBottom padRight],'replicate','post');
%     else
%         map = padarray(map,[padBottom padRight 0],'replicate','post');
%     end
%         H = size(map,1);
%         W = size(map,2);
% end



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
data1 = load('1010_interpolatedColliders_5Sessions_WB.mat');
data1 = data1.interpolatedData;
durCum1    = cumsum([data1.clusterDuration]);


isNewSession1 = strcmp({data1.hitObjectColliderName}, 'newSession');
% numeric indices of the elements that are "newSession"
idxNewSession1 = find(isNewSession1);      % [] if none exist

tag1 = zeros(1,length(data1));           % initial vector
tag1(1)               = 0;   % label for the very first block
tag1(idxNewSession1)   = idxNewSession1;   % put the session starts in
tag1 = cummax(tag1);          % propagate each start index forward



data2 = load('1022_interpolatedColliders_5Sessions_WB.mat');
data2 = data2.interpolatedData;
durCum2    = cumsum([data2.clusterDuration]);

isNewSession2 = strcmp({data2.hitObjectColliderName}, 'newSession');

% numeric indices of the elements that are "newSession"
idxNewSession2 = find(isNewSession2);      % [] if none exist
tag2 = zeros(1,length(data2));           % initial vector
tag2(1)               = 0;   % label for the very first block
tag2(idxNewSession2)   = idxNewSession2;   % put the session starts in
tag2 = cummax(tag2);          % propagate each start index forward



data3 = load('1023_interpolatedColliders_5Sessions_WB.mat');
data3 = data3.interpolatedData;
durCum3    = cumsum([data3.clusterDuration]);

isNewSession3 = strcmp({data3.hitObjectColliderName}, 'newSession');
% numeric indices of the elements that are "newSession"
idxNewSession3 = find(isNewSession3);      % [] if none exist

tag3 = zeros(1,length(data3));           % initial vector
tag3(1)               = 0;   % label for the very first block
tag3(idxNewSession3)   = idxNewSession3;   % put the session starts in
tag3 = cummax(tag3);          % propagate each start index forward




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

% ---------- figure and video ---------------------------------------
fig = figure('Visible','off','Color','w','Position',[100 100 900 900]);
ax  = axes('Parent',fig);
hold(ax,'on')

% Fill the figure area and remove outer white frame
set(ax,'Units','normalized','Position',[0 0 1 1], 'LooseInset',[0 0 0 0], ...
'XTick',[],'YTick',[],'Box','off','Color','none');
axis(ax,'manual')   % lock limits (do NOT flip here)


%% video info----------------------------------------------------------------------------
% ------------------------------------------------------------------
% wanted timing  (ALL milliseconds)
% ------------------------------------------------------------------
% fps        = 30;                    % 30 frames / second
% Tv_ms      = 60 * 1000;             % video = 60 000 ms
% T1_ms      = 20 * 1000;             % first checkpoint = 20 000 ms
% Tr1_ms     = 15 * 60 * 1000;        % 900 000  ms  (15 real min)
% TrTot_ms   = 150* 60 * 1000;        % 9 000 000 ms  (150 real min)
% 
% A          = TrTot_ms - Tv_ms;      % linear-base amplitude  (eq. 2)
% 
% % ------------------------------------------------------------------
% % solve for p  in  eq. (3)
% % ------------------------------------------------------------------
% f = @(p) T1_ms + A*(T1_ms/Tv_ms).^p - Tr1_ms;
% p = fzero(f,2);                     % good initial guess ≈ 2
% % p ≈ 2.53 with the numbers above
% 
% % ------------------------------------------------------------------
% % build the accelerating τ-vector (one value per video frame)
% % ------------------------------------------------------------------
% F          = round( Tv_ms/1000 * fps );   % 1800 frames
% t_ms       = (0:F-1) * 1000 / fps;        % 0, 33.3, 66.7, ...
% tau_ms     = t_ms + A * (t_ms / Tv_ms) .^ p;
% 
% % ------------ slightly new (longer timing, slower beginning)
% 
% fps        = 30;
% Tv_ms      = 65*1000;            % total video length 65 s   (changed)
% T1_ms      = 35*1000;            % 35 s covers first 30 min
% Tr1_ms     = 30*60*1000;         % 1 800 000 ms
% TrTot_ms   = 150*60*1000;        % 9 000 000 ms
% 
% A          = TrTot_ms - Tv_ms;
% % ------------------------------------------------------------------
% % solve for p  in  eq. (3)
% % ------------------------------------------------------------------
% f = @(p) T1_ms + A*(T1_ms/Tv_ms).^p - Tr1_ms;
% p = fzero(f, 2);                 % ≈ 2.96   (gentler curve)
% 
% % ------------------------------------------------------------------
% % build the accelerating τ-vector (one value per video frame)
% % ------------------------------------------------------------------
% 
% F       = round(Tv_ms/1000 * fps);       % 1950 frames
% t_ms    = (0:F-1)*1000/fps;
% tau_ms  = t_ms + A*(t_ms/Tv_ms).^p;
% tau_ms(end) = TrTot_ms;


% % sanity check
% fprintf('tau(0)      = %8.0f ms\n',tau_ms(1));
% fprintf('tau(20s)    = %8.0f ms  (target 900 000)\n', ...
%         tau_ms(t_ms==T1_ms));
% fprintf('tau(60s)    = %8.0f ms  (target 9 000 000)\n', ...
%         tau_ms(end));
% fprintf('initial speed dτ/dt  ≈ %.1f × real-time\n', ...
%         1);        
%% ---------------------------------------------------------------
%  Smooth time-mapping  (all units = milliseconds)
%  – first 30 real minutes at video-time 35 s
%  – full 150 real minutes at video-time 65 s
% ---------------------------------------------------------------
fps        = 30;                       % frames per second
Tv_ms      = 65 * 1000;               % total clip length 65 000 ms  (← change to 60000 if you must stay at 60 s)
T1_ms      = 35 * 1000;               % video time where 30 min should be finished
Tr1_ms     = 30 * 60 * 1000;          % 1 800 000 ms  (30 min)
TrTot_ms   = 150* 60 * 1000;          % 9 000 000 ms  (150 min)

B          = 10;                       % initial speed multiplier (1 × real-time).
                                       % Put e.g. 1.5 or 2 if you want
                                       % the very first frames to run
                                       % faster than real-time.

A          = TrTot_ms - B*Tv_ms;      % linear-plus-power model  τ = B·t + A·(t/Tv)^p

% Solve for exponent  p  so that τ(T1) = Tr1
f  = @(p) B*T1_ms + A*(T1_ms/Tv_ms).^p - Tr1_ms;
p  = fzero(f,2);                      % good initial guess = 2
% p ≈ 2.96 for the numbers above

% Build τ-vector (one desired experiment-time for every video frame)
F       = round(Tv_ms/1000 * fps);    % number of movie frames (≈ 1950)
t_ms    = (0:F-1) * 1000 / fps;       % 0, 33.3, 66.7, …
tau_ms  = B*t_ms + A * (t_ms/Tv_ms).^p;
tau_ms(end) = TrTot_ms;               % exact last value (numerical guard)


printTimeInfo = [1,(100:100:1800), length(tau_ms)];


idx1 = arrayfun(@(t) find(durCum1  >= t, 1, 'first'), tau_ms);
idx2 = arrayfun(@(t) find(durCum2 >= t, 1, 'first'), tau_ms);
idx3 = arrayfun(@(t) find(durCum3 >= t, 1, 'first'), tau_ms);

%% 1.  speed vector for video visualization ----------------------------------------------
dtVideo_ms  = 1000/fps;                 % 33.33 ms at 30 fps
dTau_ms     = [tau_ms(1)  diff(tau_ms)];
speedFactor = dTau_ms / dtVideo_ms;     % 1 × … n ×

%%-----------------------------------------------------------------------------------------
v = VideoWriter(fullfile(savepath,'gazeGraphs.mp4'),'MPEG-4');
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
rectH = 0.21;   % height of rectangle

rowStep   = 0.02; % vertical spacing per row
padBottom = 0.11; % bottom padding inside rectangle
fontSz    = 8;
markSz    = 8;
markerYFracInRow = 0.4; % 0=bottom, 0.5=center, 1=top of row

% Columns inside rectangle (as fraction of its width)
colLabel  = 0.03; % "Participant X: position"
colMarker = 0.43; % marker center
colAnd    = 0.45; % " and "
colGG     = 0.54; % "gaze graph"

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
xGG     = rectX + rectW*colGG;

% Row baselines (normalized). Bottom row = time, then A, B, C
% yTime = rectY + padBottom;
% yA    = yTime + rowStep;
% yB    = yA    + rowStep;
% yC    = yB    + rowStep;

yC = rectY + padBottom;
yB    = yC + rowStep;
yA    = yB    + rowStep;
yTime    = yA    + rowStep*1.5;



% Participant rows (A, B, C)
names = {'A','B','C'};
yRows = [yA, yB, yC];
colorIdx = [2 1 3]; 



% ---------- main loop ----------------------------------------------
for frameI = 1:20
    msWanted  = tau_ms(frameI); %frameI*((1000/30)*2);   % elapsed ms
    cla(ax)                         % erase previous foreground
    % mapHandle = imshow(map,'Parent',ax);   %  ← draw background again
    % alpha(mapHandle,0.3)
    % hold(ax,'on')  

    % Draw background map
    % mapHandle = imshow(map,'Parent',ax);   % this won't change limits (axis manual)
    % set(mapHandle,'AlphaData',0.3)
    mapH = imshow(map,'Parent',ax,'Border','tight');  % draws edge-to-edge
    set(mapH,'AlphaData',0.3)
    uistack(mapH,'bottom')
    
   
    % 
    % if(frameI == 1)
    %     scatter(ax,data1(1).playerBodyPosition_x(1)*4.2+2050,data1(1).playerBodyPosition_z(1)*4.2+2050, 15, colors2(1,:),'filled');
    %     scatter(ax,data2(1).playerBodyPosition_x(1)*4.2+2050,data2(1).playerBodyPosition_z(1)*4.2+2050, 15, colors2(2,:),'filled');
    %     scatter(ax,data3(1).playerBodyPosition_x(1)*4.2+2050,data3(1).playerBodyPosition_z(1)*4.2+2050, 15, colors2(3,:),'filled');
    % 
    % else

        for ii = 1:Number
            % choose dataset ------------------------------------------------
            switch ii
                case 1
                    data = data1;
                    durCum = durCum1;
                    dataI = idx1;
                    widthL = 0.5;
                    addF = -2;
                    tag = tag1;
                case 2
                    data = data2;
                    durCum = durCum2;
                    dataI = idx2;
                    widthL = 1 ;
                    addF = 0;
                    tag = tag2;
                otherwise
                    data = data3;
                    durCum = durCum3;
                    dataI = idx3;
                    widthL = 0.1;
                    addF = 2;
                    tag = tag3;
            end
            
    
            % -------- determine end index for this frame ------------------
           
    
            % findIndex = find(durCum > msWanted,1,'first');
            % 

            findIndex = dataI(frameI);
            if strcmp(data(findIndex).hitObjectColliderName,'newSession')
                findIndex = findIndex-1;
            end
            
   
            durations = [data(1:findIndex).clusterDuration]';
            isGaze = durations > 266.6;

            % findIndex = find(durCum > msWanted,1,'first');

            sampleTSs = [data(findIndex).timeStampDataPointStart];
            sampleTSs = (sampleTSs - data(tag(findIndex)+1).timeStampDataPointStart(1))*1000;

            walkingIndex = find(sampleTSs >= tau_ms(frameI),1,'first');

            if length(walkingIndex) < 1

                walkingIndex = length(sampleTSs);
            end


            if findIndex == 1
                name = {data(1:findIndex).hitObjectColliderName}';
            else
                name = [data(1:findIndex).hitObjectColliderName]';
            end
    
    
    
    
            scatter(ax,data(findIndex).playerBodyPosition_x(walkingIndex)*4.2+2050,data(findIndex).playerBodyPosition_z(walkingIndex)*4.2+2050, 15, colors2(ii,:),'filled');
    
            
            %% ------------------- gaze graph next:
    
            % remove all NH and sky elements
            gazes = name(isGaze);
            isHouse= ~strcmp(gazes,{'NH'});
            houses = gazes(isHouse);

            % create nodetable
            uniqueHouses= unique(houses);
            if height(uniqueHouses)> 0
                NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});


                % create edge table

                fullEdgeT= cell2table(houses,'VariableNames',{'Column1'});

                % prepare second column to add to specify edges
                secondColumn = fullEdgeT.Column1;
                % remove first element of 2nd column
                secondColumn(1,:)=[];  
                % remove last element of 1st column
                fullEdgeT(end,:)= [];

                % add second column to table
                fullEdgeT.Column2 = secondColumn;


                % remove all repetitions
                % 1st round- using unique

                uniqueTable= unique(fullEdgeT);

                 % create edgetable in merging column 1 and 2 into one variable EndNodes
                EdgeTable= mergevars(uniqueTable,{'Column1','Column2'},'NewVariableName','EndNodes');

                  %% create graph


                graphy = graph(EdgeTable,NodeTable);



                %% remove node noData and newSession from graph


                graphy = rmnode(graphy, 'newSession');
                graphy = rmnode(graphy, 'noData');



                %% next step

                nodeTable = graphy.Nodes;
                edgeTable = graphy.Edges;
                edgeCell = edgeTable.EndNodes;


                % plot houses
                node = ismember(houseList.target_collider_name,nodeTable.Name);
                x = houseList.transformed_collidercenter_x(node);
                y = houseList.transformed_collidercenter_y(node);


                if(ii == 1)
                    scatter(ax,x,y, 30, colors(ii,:), 'filled');

                elseif(ii==2)
                    scatter(ax,x,y, 18, colors(ii,:), 'filled');
                else
                    scatter(ax,x,y, 6, colors(ii,:), 'filled');
                end




                % add edges into map-------------------------------------------------------


                if length(uniqueHouses)> 1

                     % add factor for visualization of all 3


                    for ee = 1:height(edgeCell)
                        [Xhouse,Xindex] = ismember(edgeCell(ee,1),houseList.target_collider_name);

                        [Yhouse,Yindex] = ismember(edgeCell(ee,2),houseList.target_collider_name);

                        x1 = houseList.transformed_collidercenter_x(Xindex) + addF;
                        y1 = houseList.transformed_collidercenter_y(Xindex) + addF;

                        x2 = houseList.transformed_collidercenter_x(Yindex) + addF;
                        y2 = houseList.transformed_collidercenter_y(Yindex) + addF;

                        line(ax,[x1,x2],[y1,y2],'Color',colors(ii,:),'LineWidth', widthL);

                    end
                end
            end       
        
        
        end
    % end
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
    totalSec = floor(msWanted/1000);
    hh = floor(totalSec/3600);
    mm = floor(mod(totalSec,3600)/60);
    ss = mod(totalSec,60);
    text(ax, xLabel, yTime, sprintf('Experiment time: %02d:%02d:%02d', hh, mm, ss), ...
    'Units','normalized','Interpreter','none', ...
    'HorizontalAlignment','left','VerticalAlignment','bottom', ...
    'FontSize',(fontSz+3),'Color','k','Clipping','off');


    for p = 1:3
        % Label (black)
        text(ax, xLabel, yRows(p), sprintf('Participant %s: position', names{p}), ...
        'Units','normalized','Interpreter','none', ...
        'HorizontalAlignment','left','VerticalAlignment','bottom', ...
        'FontSize',fontSz,'Color','k','Clipping','off');
        % Marker (convert normalized -> data)
        mxNorm = xMarker;
        myNorm = yRows(p) + markerYFracInRow*rowStep;
        mxData = xl(1) + (xl(2)-xl(1)) * mxNorm;
        myData = yl(1) + (yl(2)-yl(1)) * myNorm;
        
        plot(ax, mxData, myData, 'o', ...
             'MarkerFaceColor', colors2(colorIdx(p), :), ...
             'MarkerEdgeColor','none', ...
             'MarkerSize',markSz);
        
        % " and " (black)
        text(ax, xAnd, yRows(p), ' and ', ...
             'Units','normalized','Interpreter','none', ...
             'HorizontalAlignment','left','VerticalAlignment','bottom', ...
             'FontSize',fontSz,'Color','k','Clipping','off');
        
        % "gaze graph" (colored)
        text(ax, xGG, yRows(p), 'gaze graph', ...
             'Units','normalized','Interpreter','none', ...
             'HorizontalAlignment','left','VerticalAlignment','bottom', ...
             'FontSize',fontSz,'Color', colors(colorIdx(p), :), 'Clipping','off');
    end

    %% add additional row
    % extra row above the rectangle   (row "0")
    % ---------------------------------------------------------------
    % gapAbove    = 0.008;        % vertical gap between rectangle and new row
    % ySpeed      = rectY + rectH + gapAbove;      % normalised y-coord
    % xSpeed      = xLabel;       % align with legend's text column
    % 
    % % ----- string that shows speed (example uses the LaTeX triangles) ---
    % 
    % rowString = sprintf('$\\triangleright\\!\\triangleright\\; %.0fx$', ...
    %                 speedFactor(frameI));
    % 
    % 
    % text(ax, xSpeed, ySpeed, rowString, ...
    %      'Units','normalized','Interpreter','latex', ...
    %      'HorizontalAlignment','left','VerticalAlignment','bottom', ...
    %      'FontSize', fontSz, 'FontWeight','bold', ...
    %      'Color','k','Clipping','off');

    %% ---------------------------------------------------------------
    % centred title inside the map
    % ---------------------------------------------------------------
    titleXNorm  = 0.50;     % 0 = left, 1 = right    (tweak freely)
    titleYNorm  = 0.9;     % 0 = bottom, 1 = top    (tweak freely)

    text(ax, titleXNorm, titleYNorm, ...
         'Free exploration of the VR city (2.5 hours)', ...
         'Units','normalized', ...
         'HorizontalAlignment','center','VerticalAlignment','top', ...
         'FontSize', 14, 'FontWeight','bold', ...
         'Interpreter','none', 'Color','k', 'Clipping','off');


    % saveas(gcf, strcat(savepath, '3Parts_gazeGraphs_+Walking5min.jpg'));
    % ax = gca;
    % exportgraphics(ax,strcat(savepath, num2str(frameI),'_3Parts_test.jpg'),'Resolution',200)


    drawnow limitrate nocallbacks
    writeVideo(v,getframe(fig))

    % hold off 
    if ismember(frameI, printTimeInfo)

        fprintf('Frame %4d | elapsed %6.2f min | %s\n', ...
        frameI, toc/60, string(datetime('now','Format','yyyy-MM-dd HH:mm:ss')));
    end

end

close(v)



       % ax = gca;
       % exportgraphics(ax,strcat(savepath, num2str(currentPart),'_gazeGraph_5min.png'),'Resolution',140)
       % hold off 







