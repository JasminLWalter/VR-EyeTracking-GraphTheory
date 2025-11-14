%% ------------------ combine_figures_WB----------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear; 

% clc  % keep command history while debugging

savepath = 'E:\WestbrookProject\Spa_Re\control_group\Analysis\figurePanels\';


cd 'E:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\';

dataP2B = readtable("overviewTable_P2B_Prep_complete.csv");
overviewPerformance = readtable('E:\WestbrookProject\Spa_Re\control_group\Analysis\P2B_controls_analysis\performance_graph_properties_analysis\overviewPerformance.csv');

performanceDataIndividual = [];

colours = [ 0.24,0.15,0.66;0.01,0.72,0.80;0.96,0.73,0.23];
%% plot boxplot of performance data

% sort the participants according to their mean performance

sortedOverviewPerformance = sortrows(overviewPerformance,2);
sortedParticipantIDs = sortedOverviewPerformance.Participants;

% extract the individual performance and put in matrix

for index2 = 1:length(sortedParticipantIDs)

    currentPart = sortedParticipantIDs(index2);
    selection = dataP2B.SubjectID == currentPart;

    % save performance separately
    performanceDataIndividual = [performanceDataIndividual,dataP2B.RecalculatedAngle(selection)];
end    


%% extract the data and sort into matrix
uniqueTrials = unique(dataP2B(:,5:6),'rows');

overviewTrialPerformance = zeros(26,112);

for index3 = 1:length(sortedParticipantIDs)

    currentPart = sortedParticipantIDs(index3);
    selection = dataP2B(dataP2B.SubjectID == currentPart,:);

    firstTrials = selection.TrialOrder == 1;
    secondTrials = selection.TrialOrder ==2;

    trialPerformance = zeros(1,112);

    for index4 = 1: height(uniqueTrials)

        start = strcmp(selection.StartBuildingName, uniqueTrials{index4,1});
        target = strcmp(selection.TargetBuildingName, uniqueTrials{index4,2});


        trial1 = selection.RecalculatedAngle(start & target & firstTrials);
        trial2 = selection.RecalculatedAngle(start & target & secondTrials);


        trialPerformance(1,index4*2-1) = trial1;
        trialPerformance(1,index4*2) = trial2;


    end

    overviewTrialPerformance(index3,:) = trialPerformance;

end

% figure 8a

figure(1)

imagescaly = imagesc(overviewTrialPerformance);
colorbar
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
ax.XLabel.String = 'Trials';
ax.YLabel.String = 'Participants';

ax = gca;

% figure 8b

figure(2)
plotty = boxchart(performanceDataIndividual, 'Notch','on');
xlabel('Participants');
ylabel('Angual error');
% 
hold on
plot(mean(performanceDataIndividual), '-o')  % x-axis is the intergers of position
hold off

% figure 8c and 8d

dataP2B_withoutRep = readtable('overviewTable_P2B_Prep_complete_withoutReps.csv');

dataP2B.TrialTime = dataP2B.TimeStampBegin;

% load trial id table

stCombiIds = load('uniqueTrials_routeID.mat');
stCombiIds = stCombiIds.uniqueTrials;

% overall mean in pointing error / in duration for each participant
overviewDiffReps = table;


% how error and duration changes over the time of the task

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

for index = 1:length(PartList)
    
     currentPart = PartList(index);   
    
     selectionPart = currentPart == dataP2B.SubjectID;
     
     
     selectionTrial1 = dataP2B.TrialOrder == 1;
     selectionTrial2 = dataP2B.TrialOrder == 2;
     
     overviewDiffReps.Participant(index) = currentPart;
     
     % trial 1
     overviewDiffReps.MeanError_Trial_1(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceError_Trial_1(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial1));

     overviewDiffReps.MeanDuration_Trial_1(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial1));
     overviewDiffReps.VarianceDuration_Trial_1(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial1));

     % trial 2
     overviewDiffReps.MeanError_Trial_2(index) = mean(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceError_Trial_2(index) = var(dataP2B.RecalculatedAngle(selectionPart&selectionTrial2));

     overviewDiffReps.MeanDuration_Trial_2(index) = mean(dataP2B.TrialDuration(selectionPart&selectionTrial2));
     overviewDiffReps.VarianceDuration_Trial_2(index) = var(dataP2B.TrialDuration(selectionPart&selectionTrial2));
   
     
     startTS = min(dataP2B.TimeStampBegin(selectionPart));
     dataP2B.TrialTime(selectionPart) = dataP2B.TrialTime(selectionPart)-startTS; 
     
     
     for indexTrial = 1:112
         
         minTrial = min(dataP2B.TrialTime(selectionPart));
         minIndex = dataP2B.TrialTime == minTrial;
         
         dataP2B.TrialSequence(minIndex) = indexTrial;
         
         selectionPart = selectionPart & not(minIndex); 
         
     end

     
end

for index2 = 1:height(dataP2B_withoutRep)
   
    currentPart = dataP2B_withoutRep.SubjectID(index2);
    currentSTcombi = dataP2B_withoutRep.RouteID(index2);
    
    selectionPart = dataP2B.SubjectID == currentPart;
    selectionSTC = strcmp(dataP2B.RouteID, currentSTcombi);
    selectionOrder1 = dataP2B.TrialOrder == 1;
    selectionOrder2 = dataP2B.TrialOrder == 2;
    
    error1 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder1);
    error2 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder2);

    dataP2B_withoutRep.ErrorDiff(index2) = error1-error2;

end

%% distribution differences between first and second task trial reps
% figure 1
figure(3)


plotty1 = histogram(dataP2B_withoutRep.ErrorDiff, LineWidth=1);

ylabel('Frequency')
xlabel('Pointing difference (angular error)')

saveas(gcf, strcat(savepath, 'histy.png'));


% figure 4
figure(4)
edges3 = [0:5:180];
plotty3 = histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 1),edges3,LineWidth=1);
hold on

plotty3b= histogram(dataP2B.RecalculatedAngle(dataP2B.TrialOrder == 2),edges3,'FaceColor',[0.40,0.80,0.42], 'FaceAlpha',0.5,LineWidth=1);
ylabel('Frequency')
xlabel('Angular error')

hold off



%% 
% ---------------- global style (edit once to affect all) ----------------
cfg.FontName   = 'Arial';
cfg.AxesFS     = 11;   % tick label size
cfg.LabelFS    = 12;   % axis label size
cfg.TitleFS    = 12;   % title size
cfg.AxisLW     = 1.0;
cfg.LineLW     = 1.4;
cfg.MarkerSize = 6;
cfg.TickDir    = 'out';
cfg.TickLength = [0.010 0.010];
cfg.Grid       = 'off';

% Panel labels
cfg.PanelLabelsOn    = true;
cfg.PanelLabelFS     = 13;
cfg.PanelLabelColor  = [0 0 0];
cfg.PanelLabelText   = @(s) sprintf('%s.', s);
cfg.PanelLabelWeight = 'normal';

% ---------------- build each source plot invisibly ----------------------
% 8a: heatmap of overviewTrialPerformance
f8a = figure('Visible','off'); ax8a_src = axes('Parent',f8a);
imagesc(ax8a_src, overviewTrialPerformance);
cb8a = colorbar(ax8a_src); %#ok<NASGU>
xlabel(ax8a_src,'Trials'); ylabel(ax8a_src,'Participants');
set(ax8a_src, 'XTick',0:20:244, 'TickDir','out', 'XMinorTick','off');
ax8a_src.XAxis.MinorTickValues = 1:1:244;

% 8b: boxcharts per participant, plus mean line
f8b = figure('Visible','off'); ax8b_src = axes('Parent',f8b);
boxchart(ax8b_src, performanceDataIndividual, 'Notch','on');
hold(ax8b_src,'on');
plot(ax8b_src, mean(performanceDataIndividual,1), '-o', 'LineWidth',1.0, 'Color',[0.3 0.5 0.9]);
hold(ax8b_src,'off');
xlabel(ax8b_src,'Participants'); ylabel(ax8b_src,'Angular error');

% 8c: histograms trial 1 vs 2
f8c = figure('Visible','off'); ax8c_src = axes('Parent',f8c);
edges3 = 0:5:180;
histogram(ax8c_src, dataP2B.RecalculatedAngle(dataP2B.TrialOrder==1), edges3, 'FaceColor',[0.2 0.4 0.9], 'FaceAlpha',0.5);
hold(ax8c_src,'on');
histogram(ax8c_src, dataP2B.RecalculatedAngle(dataP2B.TrialOrder==2), edges3, 'FaceColor',[0.2 0.8 0.3], 'FaceAlpha',0.5);
hold(ax8c_src,'off');
xlabel(ax8c_src,'Angular error'); ylabel(ax8c_src,'Frequency');

% 8d: histogram of differences
f8d = figure('Visible','off'); ax8d_src = axes('Parent',f8d);
histogram(ax8d_src, dataP2B_withoutRep.ErrorDiff, 'FaceColor',[0.2 0.5 0.9], 'FaceAlpha',0.8);
xlabel(ax8d_src,'Angular error difference'); ylabel(ax8d_src,'Frequency');

% ---------------- assemble into one 2×2 panel --------------------------
fig8 = figure('Color','w','Units','normalized','Position',[0.2 0.15 0.58 0.72]);

% Layout: reserve a gap for 8a colorbar between columns
L=0.10; R=0.06; T=0.08; B=0.12;  % outer margins
GY=0.02;                         % vertical gap
cbGap=0.012; cbWidth=0.022;      % colorbar gap/width for 8a
GX = cbGap + cbWidth + 0.03;     % inter-column gap (includes space for cb)

Wtot = 1 - L - R - GX;
Wcol = Wtot/2;
Htot = 1 - T - B;
Hrow = (Htot - GY)/2;

% Positions [x y w h]
posA = [L,            B + Hrow + GY, Wcol, Hrow];
posB = [L + Wcol + GX, B + Hrow + GY, Wcol, Hrow];
posC = [L,            B,             Wcol, Hrow];
posD = [L + Wcol + GX, B,            Wcol, Hrow];

% Copy the axes into the panel and style them
a8a = copyAxesInto(fig8, ax8a_src, posA, cfg, true);
a8b = copyAxesInto(fig8, ax8b_src, posB, cfg, true);
a8c = copyAxesInto(fig8, ax8c_src, posC, cfg, true);
a8d = copyAxesInto(fig8, ax8d_src, posD, cfg, true);
applyStyle([a8a a8b a8c a8d], cfg);

% Top row: hide x tick labels to reduce crowding
set([a8a a8b], 'XTickLabel',[]);

% 8a: add external colorbar between columns, without shrinking axes
addExternalColorbar(fig8, a8a, ax8a_src, cfg, cbGap, cbWidth);
grid(a8a,'off');  % often cleaner for heatmaps

% Panel labels
if cfg.PanelLabelsOn
addPanelLabelOutside(fig8, a8a, 'a', cfg);
addPanelLabelOutside(fig8, a8b, 'b', cfg);
addPanelLabelOutside(fig8, a8c, 'c', cfg);
addPanelLabelOutside(fig8, a8d, 'd', cfg);
end

% ---------------- export (exact pixels) ---------------------------
% dpi = 300;  % choose your DPI
% setFigurePixels(fig8, 1600, 1200, dpi);  % set target pixel size here
% exportgraphics(fig8, fullfile(savepath,'Figure8_panel.png'), 'Resolution', dpi);
% exportgraphics(fig8, fullfile(savepath,'Figure8_panel.pdf'), 'ContentType','vector');

exportgraphics(fig8, fullfile(savepath,'Figure8.pdf'), 'ContentType','vector');
exportgraphics(fig8, fullfile(savepath,'Figure8.png'), 'Resolution',300);

% Close the invisible source figs
close([f8a f8b f8c f8d]);

% ============================== helpers ===============================
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
a.Title.FontSize  = cfg.TitleFS; a.Title.FontWeight = 'normal';
set(findobj(a,'Type','line'),      'LineWidth',cfg.LineLW, 'MarkerSize',cfg.MarkerSize);
set(findobj(a,'Type','scatter'),   'LineWidth',cfg.LineLW, 'SizeData',(cfg.MarkerSize^2));
set(findobj(a,'Type','bar'),       'LineWidth',cfg.LineLW);
set(findobj(a,'Type','histogram'), 'LineWidth',cfg.LineLW);
end
end

function addPanelLabelOutside(fig, ax, letter, cfg)
str = cfg.PanelLabelText(letter);
oldUnits = ax.Units; ax.Units = 'normalized';
op = ax.OuterPosition; ax.Units = oldUnits;
dx = 0.010; dy = 0.005;
pos = [op(1) - dx, op(2) + op(4) - dy, 0.03, 0.03];
annotation(fig, 'textbox', pos, ...
'String', str, 'Units','normalized', ...
'HorizontalAlignment','right', 'VerticalAlignment','top', ...
'LineStyle','none', 'FontName',cfg.FontName, ...
'FontWeight',cfg.PanelLabelWeight, 'FontSize',cfg.PanelLabelFS, ...
'Color',cfg.PanelLabelColor, 'BackgroundColor','none', 'Interpreter','none');
end

function cb = addExternalColorbar(destFig, newAx, srcAx, cfg, gap, width)
if nargin < 5, gap=0.012; end
if nargin < 6, width=0.022; end
% Match colormap and limits from the source axes/figure
try
colormap(destFig, colormap(ancestor(srcAx,'figure')));
catch
colormap(destFig, colormap(srcAx));
end
try caxis(newAx, caxis(srcAx)); end

ap = newAx.Position;
cb = colorbar(newAx); set(cb,'Units','normalized');
newAx.Position = ap;  % restore (avoid shrink)
cb.Position = [ap(1) + ap(3) + gap, ap(2), width, ap(4)];
set(cb, 'LineWidth', cfg.AxisLW, 'FontSize', cfg.AxesFS);

end

function setFigurePixels(fig, width_px, height_px, dpi)
if nargin < 4, dpi = 300; end
w_in = width_px / dpi; h_in = height_px / dpi;
set(fig, 'Units','inches', 'Position',[1 1 w_in h_in]);
end






