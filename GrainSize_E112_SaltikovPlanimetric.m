function [G_N, N_A, N] = GrainSize_E112_SaltikovPlanimetric(ebsd, varargin)
% Saltikov's Planimetric: Count of grains in a test rectangle
% Grains completely enclosed count as 1, those intercepted by the rectangle
% count by half, and corners count as one-quarter.

%%
% Make a rectangle
offset = 0.02; % 2pct inset from edges
xres = (max(ebsd.x) - min(ebsd.x)) / length(ebsd.x);
yres = (max(ebsd.y) - min(ebsd.y)) / length(ebsd.y);
xinset = numel(ebsd.x) * offset * xres;
yinset = numel(ebsd.y) * offset * yres;
polygon = [min(ebsd.x)+xinset, min(ebsd.y)+yinset;
    min(ebsd.x)+xinset, max(ebsd.y)-yinset;
    max(ebsd.x)-xinset, max(ebsd.y)-yinset;
    max(ebsd.x)-xinset, min(ebsd.y)+yinset];
polygon = [polygon; polygon(1,:)]; % Final rectangle

% Segment the grains and calculate grain size
include_corner_grains = true; % Will ensure corner grains are counted in segmentation functions
[G_N, ~, N_A, N, ~, ~, inside_grains, edge_grains, corner_grains] = grainsize_areas_planimetric(ebsd, polygon, varargin{:}, 'corner_grains', include_corner_grains);

if ismember('exclude_twins', varargin)
    inside_grains = exclude_twins(inside_grains);
    edge_grains = exclude_twins(edge_grains);
end

% Plotting subfunction
if ismember('PlotResults', varargin)
    if ismember('FCC', varargin)
        phase = ebsd('face centered cubic');
    elseif ismember('BCC', varargin)
        phase = ebsd('body centered cubic');
    else
        phase = ebsd;
    end
    figure
    plot(phase, phase.orientations); hold on % plot ebsd map
    plot(polygon(:,1), polygon(:,2), 'k', 'linewidth', 3); % Plot rectangular area
    for i = 1:length(corner_grains)
        plot(corner_grains(i).boundary, 'linewidth', 3, 'lineColor', 'red'); % Plot corner touching grains
    end
    plot(edge_grains.boundary, 'linewidth', 2, 'lineColor', 'black'); % Plot grains not included in count
    plot(inside_grains.boundary, 'linewidth', 3, 'lineColor', 'white'); % Plot grains included in count
    hold off;
end
end