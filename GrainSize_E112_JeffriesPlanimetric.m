function [G_N, N_A, N] = GrainSize_E112_JeffriesPlanimetric(ebsd, varargin)
% Jeffries' Planimetric: Count of grains in a test circle
% Grains completely enclosed count as 1, those intercepted by the circle count by half. 

%%
% Make a circle
offset = 0.02; % 2pct inset from edges
xcenter = 0.5 * (max(ebsd.x) - min(ebsd.x));
ycenter = 0.5 * (max(ebsd.y) - min(ebsd.y));
thetas = 0.0:pi/100.0:2.0*pi;
xres = 2.0 * xcenter / length(ebsd.x);
yres = 2.0 * ycenter / length(ebsd.y);
radius = 0.5 * min(max(ebsd.x) - min(ebsd.x), ...
               max(ebsd.y) - min(ebsd.y));
inset = max(numel(ebsd.x) * offset * xres, numel(ebsd.y) * offset * yres);
radius = radius - inset;
circ_x = radius * cos(thetas) + xcenter;
circ_y = radius * sin(thetas) + ycenter;
polygon = [circ_x' circ_y']; % Final circle

% Segment the grains and calculate grain size
[G_N, ~, N_A, N, ~, ~, inside_grains, edge_grains, ~] = grainsize_areas_planimetric(ebsd, polygon, varargin{:});

if ismember('exclude_twins', varargin)
    inside_grains = exclude_twins(inside_grains);
    edge_grains = exclude_twins(edge_grains);
end

% plotting subfunction
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
    plot(polygon(:,1), polygon(:,2), 'k', 'linewidth', 3); % Plot circle
    plot(edge_grains.boundary, 'linewidth', 2, 'lineColor', 'black'); % Plot grains not included in count
    plot(inside_grains.boundary, 'linewidth', 3, 'lineColor', 'white'); % Plot grains included in count
    hold off;
end
end % parse varargin