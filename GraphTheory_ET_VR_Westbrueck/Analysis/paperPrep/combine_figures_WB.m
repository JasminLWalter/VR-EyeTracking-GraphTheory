%% ------------------ combine_figures_WB----------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear; 

% clc  % keep command history while debugging

savepath = 'E:\WestbrookProject\Spa_Re\control_group\Analysis\figurePanels';

% Open source figures invisibly
fig3a = openfig('E:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\nodeDegree_imageScale.fig','invisible');
fig3b = openfig('E:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\nodeDegree_mean_std_allHouses.fig','invisible');
fig3c = openfig('E:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\correlation_coefficients_histogram.fig','invisible');
fig3d = openfig('E:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\Histogram_distribution_meanNodeDegree_of_each_building.fig','invisible');
fig3f = openfig('E:\WestbrookProject\Spa_Re\control_group\Analysis\NodeDegreeCentrality\GraphVisualization_averageNodeDegree.fig','invisible');

% Build fig 3e in a temporary invisible figure
H = load('E:\WestbrookProject\Spa_Re\control_group\Analysis\HierarchyIndex\HierarchyIndex_Table.mat');
H = H.HierarchyIndex;
fig3e = figure('Visible','off');
axTmp = axes('Parent',fig3e);
histogram(axTmp, H.Slope, 7);
xlabel(axTmp,'Hierarchy Index'); ylabel(axTmp,'Frequency'); title(axTmp,'');

% Pick main axes from each figure
ax3a = pickMainAxes(fig3a);
ax3b = pickMainAxes(fig3b);
ax3c = pickMainAxes(fig3c);
ax3d = pickMainAxes(fig3d);
ax3e = pickMainAxes(fig3e);
ax3f = pickMainAxes(fig3f);

disp('All figures opened and axes selected.')

% ---------------- Global style config (edit once) -----------------
cfg.FontName   = 'Arial';
cfg.AxesFS     = 11;   % tick labels
cfg.LabelFS    = 11;   % axis labels
cfg.TitleFS    = 13;   % titles
cfg.AxisLW     = 1.0;  % axes line width
cfg.LineLW     = 1.0;  % line objects
cfg.MarkerSize = 3;
cfg.TickDir    = 'out';
cfg.TickLength = [0.010 0.010];
cfg.Grid       = 'off';

% Panel label settings
cfg.PanelLabelsOn   = false;
cfg.PanelLabelFS    = 14;
cfg.PanelLabelColor = [0 0 0];
cfg.PanelLabelText  = @(s) sprintf('%s.', s);  % 'a)' style
cfg.PanelLabelWeight = 'normal';   

disp('settings complete)')
% ---------------------------------------------------------------

% ---------------- Panel 1: Left (3a over 3b) ---------------------
% figLeft = figure('Color','w','Units','normalized','Position',[0.08 0.1 0.28 0.78]);
% 
% % Margins and gap
% L1 = 0.12; R1 = 0.06; T1 = 0.08; B1 = 0.12;   % outer margins for the panel
% GY = 0.04;                                     % vertical gap between 3a and 3b
% 
% % Reserve space on the right for 3a's colorbar
% cbGap   = 0.015;   % gap between axes and colorbar
% cbWidth = 0.022;   % colorbar width
% 
% Waxes = 1 - L1 - R1 - cbGap - cbWidth;  % axes width for both 3a and 3b
% Htot  = 1 - T1 - B1;
% h2    = (Htot - GY)/2;
% 
% posA = [L1, B1 + h2 + GY, Waxes, h2];   % 3a
% posB = [L1, B1,            Waxes, h2];   % 3b
% 
% % Copy axes; use outerposition so labels stay inside allocated rectangles
% a3a = copyAxesInto(figLeft, ax3a, posA, cfg, true);
% a3b = copyAxesInto(figLeft, ax3b, posB, cfg, true);
% applyStyle([a3a a3b], cfg);
% a3a.Title.String  = '';  
% xlabel(a3a, 'Buildings', 'FontSize', cfg.LabelFS);
% xlabel(a3b, 'Buildings', 'FontSize', cfg.LabelFS);
% ylabel(a3b, 'Node degree', 'FontSize', cfg.LabelFS);
% 
% % Make 3b error bars thinner
% eb = findobj(a3b, 'Type', 'errorbar');   % find ErrorBar objects
% if ~isempty(eb)
% set(eb, 'LineWidth', 0.1, 'CapSize', 5);  % tweak values to taste
% else
% % Fallback for very old MATLAB versions where errorbar returns a line
% ebAlt = findobj(a3b, '-property', 'UData');
% set(ebAlt, 'LineWidth', 0.75);
% end
% 
% % Align x-axes and optionally hide top x tick labels
% linkaxes([a3a a3b], 'x');
% % set(a3a, 'XTickLabel', []);
% 
% % Limits and custom ticks
% xlim([a3a a3b], [1 244]);                 % shared limits
% ticks = [1 50 100 150 200 244];
% set([a3a a3b], 'XTick', ticks);           % same ticks on both axes
% set(a3a, 'XTickLabel', []);               % hide top labels, keep bottom visible
% xtickformat(a3b, '%d');   
% set([a3a a3b], 'XMinorTick','off');
% % optional: rotate labels a bit if needed
% % xtickangle(a3b, 0);
% 
% % Add 3a colorbar outside, without shrinking the axes
% set([a3a a3b], 'PositionConstraint','innerposition', ...
% 'ActivePositionProperty','position');
% 
% % Re-apply your target positions (same left x and width for both)
% a3a.Position = posA;   % [L1, B1 + h2 + GY, Waxes, h2]
% a3b.Position = posB;   % [L1, B1,            Waxes, h2]
% 
% % Now add the external colorbar for 3a (do this AFTER alignment)
% addExternalColorbar(figLeft, a3a, ax3a, cfg, cbGap, cbWidth);
% 
% % Panel labels (if you use them)
% if cfg.PanelLabelsOn
% addPanelLabelOutside(figLeft, a3a, 'a', cfg);
% addPanelLabelOutside(figLeft, a3b, 'b', cfg);
% end
% 
% dpi = 300;
% setFigurePixels(figLeft, 1310, 1510, dpi);
% % setFigureSize(figLeft, 9, 12);    % width=9 cm, height=12 cm  -> aspect 0.75
% exportgraphics(figLeft, fullfile(savepath,'Figure3_left.pdf'), 'ContentType','vector');
% exportgraphics(figLeft, fullfile(savepath,'Figure3_left.png'), 'Resolution',300);
% 
% disp("panel 1 done")

% -------------- Panel 2: Middle (3c, 3d, 3e) --------------------
% figMid = figure('Color','w','Units','normalized','Position',[0.38 0.1 0.26 0.78]);
% 
% % Adjustable margins and vertical gap (increase GYmid to spread more)
% Lm = 0.14; Rm = 0.08; Tm = 0.10; Bm = 0.14;  % outer margins
% GYmid = 0.02;                                 % vertical gap between rows (tune)
% 
% Wm   = 1 - Lm - Rm;
% Htot = 1 - Tm - Bm;
% h    = (Htot - 2*GYmid)/3;
% x    = Lm;
% 
% posC = [x, Bm + 2*h + 2*GYmid, Wm, h];   % top (3c)
% posD = [x, Bm + h + GYmid,     Wm, h];   % middle (3d)
% posE = [x, Bm,                 Wm, h];   % bottom (3e)
% 
% 
% % Use OuterPosition so labels/titles sit inside their allocated area
% 
% % 3c
% a3c = copyAxesInto(figMid, ax3c, posC, cfg, true);
% 
% xlabel(a3c, 'Correlation coefficients', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');   % or 'latex'
% ylabel(a3c, 'Frequency', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');
% 
% a3d = copyAxesInto(figMid, ax3d, posD, cfg, true);
% xlabel(a3d, 'Mean node degree', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');   % or 'latex'
% ylabel(a3d, 'Frequency', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');
% 
% % remove title on 3d
% a3d.Title.String = '';
% 
% a3e = copyAxesInto(figMid, ax3e, posE, cfg, true);
% xlabel(a3e, 'Hierarchy index', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');   % or 'latex'
% ylabel(a3e, 'Frequency', 'FontSize', cfg.LabelFS, ...
% 'FontWeight','normal', 'Interpreter','tex');
% 
% 
% applyStyle([a3c a3d a3e], cfg);
% 
% % Reduce crowding: hide X tick labels on top and middle
% % set([a3c a3d], 'XTickLabel',[]);
% 
% if cfg.PanelLabelsOn
% addPanelLabelOutside(figMid, a3c, 'c', cfg);
% addPanelLabelOutside(figMid, a3d, 'd', cfg);
% addPanelLabelOutside(figMid, a3e, 'e', cfg);
% end
% exportgraphics(figMid, fullfile(savepath,'Figure3_middle.pdf'), 'ContentType','vector');
% exportgraphics(figMid, fullfile(savepath,'Figure3_middle.png'), 'Resolution',300);

% ---------------- Panel 3: Right (3f only) ----------------------
figRight = figure('Color','w','Units','normalized','Position',[0.68 0.1 0.26 0.78]);
% Fill most of the area but leave margins for colorbar
Lr = 0.10; Rr = 0.10; Tr = 0.08; Br = 0.12;
posF = [Lr, Br, 1 - Lr - Rr, 1 - Tr - Br];
a3f = copyAxesInto(figRight, ax3f, posF, cfg, true);
applyStyle(a3f, cfg);
addColorbarFromSource(figRight, a3f, ax3f, cfg, false); % 3f has colorbar

% If 3f needs its colorbar: recreate it here (copyobj won't bring it)
% cb = colorbar(a3f); set(cb,'LineWidth',cfg.AxisLW,'FontSize',cfg.AxesFS);

if cfg.PanelLabelsOn
addPanelLabelOutside(figRight, a3f, 'f', cfg);
end
exportgraphics(figRight, fullfile(savepath,'Figure3_right.pdf'), 'ContentType','vector');
exportgraphics(figRight, fullfile(savepath,'Figure3_right.png'), 'Resolution',300);

% ------------------------ helper functions ----------------------
function ax = pickMainAxes(fig)
% Return the largest axes (by Position area) from a figure
axList = [findall(fig,'Type','axes'); findall(fig,'Type','polaraxes')];
if isempty(axList), ax = []; return; end
areas = zeros(numel(axList),1);
for k = 1:numel(axList)
p = get(axList(k),'Position');
areas(k) = prod(p(3:4));
end
[~,i] = max(areas);
ax = axList(i);
end

function a = copyAxesInto(destFig, srcAx, pos, cfg, useOuter)
if nargin < 5, useOuter = false; end
a = copyobj(srcAx, destFig);
set(a, 'Units','normalized');
if useOuter
set(a, 'ActivePositionProperty','outerposition', 'OuterPosition', pos);
else
set(a, 'ActivePositionProperty','position', 'Position', pos);
end
try, grid(a, cfg.Grid); end
end

function applyStyle(axs, cfg)
set(axs, 'FontName',cfg.FontName, 'FontSize',cfg.AxesFS, ...
'LineWidth',cfg.AxisLW, 'TickDir',cfg.TickDir, ...
'TickLength',cfg.TickLength, 'Box','off', 'Layer','top');
for a = axs(:)'
a.XLabel.FontSize = cfg.LabelFS;
a.YLabel.FontSize = cfg.LabelFS;
a.Title.FontSize  = cfg.TitleFS;
a.Title.FontWeight = 'normal';
set(findobj(a,'Type','line'),      'LineWidth',cfg.LineLW, 'MarkerSize',cfg.MarkerSize);
set(findobj(a,'Type','scatter'),   'LineWidth',cfg.LineLW, 'SizeData',(cfg.MarkerSize^2));
set(findobj(a,'Type','bar'),       'LineWidth',cfg.LineLW);
set(findobj(a,'Type','histogram'), 'LineWidth',cfg.LineLW);
end
end

function addPanelLabelOutside(fig, ax, letter, cfg)
% Place label left/top outside the axes using a figure annotation
str = cfg.PanelLabelText(letter);
oldUnits = ax.Units; ax.Units = 'normalized';
op = ax.OuterPosition; ax.Units = oldUnits;
dx = 0.010;  % horizontal offset into left gutter
dy = 0.005;  % vertical inset
pos = [op(1) - dx, op(2) + op(4) - dy, 0.03, 0.03]; % [x y w h]
annotation(fig, 'textbox', pos, ...
'String', str, 'Units','normalized', ...
'HorizontalAlignment','right', 'VerticalAlignment','top', ...
'LineStyle','none', ...
'FontName',cfg.FontName, 'FontWeight','bold', ...
'FontSize',cfg.PanelLabelFS, 'Color',cfg.PanelLabelColor, ...
'BackgroundColor','none', 'Interpreter','none');
end


function cb = addColorbarFromSource(destFig, newAx, srcAx, cfg, keepOuter)
if nargin < 5, keepOuter = false; end
% Remember target axes outer position (so we can restore if desired)
origOuter = newAx.OuterPosition;
% Match colormap and color limits
try
    srcFig = ancestor(srcAx,'figure');
    colormap(destFig, colormap(srcFig));   % figure-scoped colormap
catch
    % Fallback: set on the axes (works in newer MATLAB as per-axes colormap)
    colormap(newAx, colormap(srcAx));
end
try caxis(newAx, caxis(srcAx)); end

% Find the source colorbar that belongs to srcAx (if any)
cbSrc = [];
try
    srcCBs = findall(ancestor(srcAx,'figure'), 'Type','ColorBar');
    for k = 1:numel(srcCBs)
        if any(srcCBs(k).Axes == srcAx)
            cbSrc = srcCBs(k); break;
        end
    end
end

% Create a new colorbar for the copied axes
cb = colorbar(newAx);
set(cb, 'LineWidth', cfg.AxisLW, 'FontSize', cfg.AxesFS);

% Copy a few useful properties from the source colorbar (if available)
if ~isempty(cbSrc)
    % Location (eastoutside, westoutside, etc.)
    try, cb.Location = cbSrc.Location; end
    % Ticks and labels
    try, cb.Ticks = cbSrc.Ticks; end
    try, cb.TickLabels = cbSrc.TickLabels; end
    try, cb.TickLabelInterpreter = cbSrc.TickLabelInterpreter; end
    % Label text (newer MATLAB: cb.Label is a Text object)
    try
        cb.Label.String = cbSrc.Label.String;
        cb.Label.Interpreter = cbSrc.Label.Interpreter;
        cb.Label.FontSize = cfg.AxesFS;
    end
end

% If adding the colorbar shrank/moved the axes undesirably,
% restore the original outer position.
if keepOuter
    newAx.OuterPosition = origOuter;
end
end


function cb = addExternalColorbar(destFig, newAx, srcAx, cfg, gap, width)
if nargin < 5, gap = 0.015; end
if nargin < 6, width = 0.022; end
% Match colormap + limits from the source figure/axes
try
colormap(destFig, colormap(ancestor(srcAx,'figure')));
catch
colormap(destFig, colormap(srcAx));
end
try caxis(newAx, caxis(srcAx)); end
% Save the axes inner position (the one colorbar tries to shrink)
ap = newAx.Position;

% Create colorbar and immediately restore the axes position
cb = colorbar(newAx); set(cb, 'Units','normalized');
newAx.Position = ap;

% Place the colorbar manually to the right of the axes
cb.Position = [ap(1) + ap(3) + gap, ap(2), width, ap(4)];

% Style and copy useful properties (ticks/labels) from the source cb
set(cb, 'LineWidth', cfg.AxisLW, 'FontSize', cfg.AxesFS);
try
    srcCBs = findall(ancestor(srcAx,'figure'), 'Type','ColorBar');
    for k = 1:numel(srcCBs)
        if any(srcCBs(k).Axes == srcAx)
            try, cb.Ticks = srcCBs(k).Ticks; end
            try, cb.TickLabels = srcCBs(k).TickLabels; end
            try, cb.TickLabelInterpreter = srcCBs(k).TickLabelInterpreter; end
            try
                cb.Label.String = srcCBs(k).Label.String;
                cb.Label.Interpreter = srcCBs(k).Label.Interpreter;
                cb.Label.FontSize = cfg.AxesFS;
            end
            break;
        end
    end
end

end


function setFigureSize(fig, width_cm, height_cm)
% Sets the on-screen size and export size (PDF/PNG) in centimeters
set(fig, 'Units','centimeters');
pos = get(fig, 'Position'); pos(3) = width_cm; pos(4) = height_cm; set(fig,'Position',pos);
set(fig, 'PaperUnits','centimeters', 'PaperPosition',[0 0 width_cm height_cm]);
end

function setFigurePixels(fig, width_px, height_px, dpi)
if nargin < 4, dpi = 300; end
w_in = width_px / dpi;
h_in = height_px / dpi;
set(fig, 'Units','inches', 'Position', [1 1 w_in h_in]);  % on-screen size for export
% Optional: remove UI chrome (not exported anyway)
% set(fig,'MenuBar','none','ToolBar','none');
end