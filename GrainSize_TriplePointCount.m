function [G, A_T, N_A] = GrainSize_TriplePointCount(ebsd, varargin)
% Triple Point Count Method: Uses a circle of known size.
% The number of grain-boundary triple points within the test area is
% counted.
% If four-grain edge junction is observed, it is counted as two,
%%
% approximate a circle as a polygon
offset = 0.02; % 2pct inset from edges
xcenter = 0.5 * (max(ebsd.x) - min(ebsd.x));
ycenter = 0.5 * (max(ebsd.y) - min(ebsd.y));
thetas = 0.0:pi/100.0:2.0*pi;
xres = 2.0 * xcenter / length(ebsd.x);
yres = 2.0 * ycenter / length(ebsd.y);
radius = 0.5 * min(max(ebsd.x) - min(ebsd.x), ...
               max(ebsd.y) - min(ebsd.y));
inset = max(numel(ebsd.x) * offset * xres, numel(ebsd.y) * offset * yres);
radius = radius - inset; % inset from the edges of the scan
circ_x = radius * cos(thetas) + xcenter;
circ_y = radius * sin(thetas) + ycenter;
polygon = [circ_x' circ_y'];

% select only ebsd data within polygon
ind = inpolygon(ebsd, polygon);
inside_ebsd = ebsd(ind); 

% populate grain data
[grains, ~] = calcGrains(ebsd('indexed'), 'angle', 5*degree, 'unitCell');
[inside_grains, ~] = calcGrains(inside_ebsd('indexed'), 'angle', 5*degree, 'unitCell', 'removeQuadruplePoints');

if ismember('exclude_twins',varargin)
    grains = exclude_twins(grains);
    inside_grains = exclude_twins(inside_grains);
end

[tP_x, tP_y, N_tP, qP_x, qP_y, N_qP] = find_quadruple_points(inside_grains);

% Number of grains per unit area
P = N_tP + 2*N_qP; % P = the number of grain-boundary triple points
A_T = polyarea(circ_x,circ_y);
N_A = (0.5*P + 1)/A_T; % N_A = number of grains per unit area
G = G_numgrain(N_A);

if ismember('PlotResults',varargin)
    if ismember('FCC', varargin)
        phase = ebsd('face centered cubic');
    elseif ismember('BCC', varargin)
        phase = ebsd('body centered cubic');
    else
        phase = ebsd;
    end
    figure
    plot(phase, phase.orientations); hold on
    plot(grains.boundary, 'linewidth', 2, 'lineColor', 'black'); hold on
    plot(polygon(:,1), polygon(:,2), 'k', 'linewidth', 3); hold on
    % Plot triple points
    scatter(tP_x,tP_y,'w','linewidth',2); hold on
    % Plot quadruple points
    scatter(qP_x,qP_y,'r','linewidth',2); hold off
end % parse varargin

end