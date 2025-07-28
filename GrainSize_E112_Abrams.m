function [G_PL, abramsIntCount, abrams_lbar, abramsCircumference_tot] = GrainSize_E112_Abrams(ebsd, varargin)
% Abrams Three-Circle Procedure: Three concentric and equally spaced circles.
% Placement of the three-circle test grid should yield 40-100 intersection counts per slice tested.
% If the circle intersects a triple point, the count is 2.
% The ratio of circumference is 3:2:1

%%
% Populate the grains
[grains, ebsd.grainId] = calcGrains(ebsd('indexed'), 'angle', 5*degree, 'unitcell');

if ismember('exclude_twins', varargin)
    grains = exclude_twins(grains);
end

% Calculate step size for triple point calculations
stepsize = abs(ebsd.unitCell(1,1)); 

% Extract triple points
tP = grains.triplePoints;
tpoint = [tP.x, tP.y];

% Define inset
offset = 0.02; % 2% inset from edges
xcenter = mean(ebsd.x);
ycenter = mean(ebsd.y);
xres = 2.0 * xcenter / length(ebsd.x);
yres = 2.0 * ycenter / length(ebsd.y);
inset = max(numel(ebsd.x) * offset * xres, numel(ebsd.y) * offset * yres);

% Plotting the largest circle:
thetas = 0:pi/100:2*pi;
radius_lg = 0.5 * min(range(ebsd.x), range(ebsd.y)) - inset;
circumference_lg = 2 * pi * radius_lg;
circ_x_lg = radius_lg * cos(thetas) + xcenter;
circ_y_lg = radius_lg * sin(thetas) + ycenter;
polygon_lg = [circ_x_lg' circ_y_lg'];

% Extract the grain boundary/circle intersection data
[num_int_lg, intersect_coords_lg] = calculate_intersections(polygon_lg, grains.boundary);

% Plotting the medium circle:
circumference_med = circumference_lg / 1.5;
radius_med = circumference_med / (2 * pi) - inset;
circ_x_med = radius_med * cos(thetas) + xcenter;
circ_y_med = radius_med * sin(thetas) + ycenter;
polygon_med = [circ_x_med' circ_y_med'];
[num_int_med, intersect_coords_med] = calculate_intersections(polygon_med, grains.boundary);

% Plotting the smallest circle:
circumference_sm = circumference_lg / 3;
radius_sm = circumference_sm / (2 * pi) - inset;
circ_x_sm = radius_sm * cos(thetas) + xcenter;
circ_y_sm = radius_sm * sin(thetas) + ycenter;
polygon_sm = [circ_x_sm' circ_y_sm'];
[num_int_sm, intersect_coords_sm] = calculate_intersections(polygon_sm, grains.boundary);

% Count triple point intersections
[count, included_points] = count_triple_points(tpoint, [polygon_sm; polygon_med; polygon_lg], stepsize);

% Remove triple points from intersection lists to avoid double counting
intersect_coords_sm  = remove_nearby_points(intersect_coords_sm,  included_points, stepsize);
intersect_coords_med = remove_nearby_points(intersect_coords_med, included_points, stepsize);
intersect_coords_lg  = remove_nearby_points(intersect_coords_lg,  included_points, stepsize);

% Recalculate intersection counts without triple points
abramsIntCount_sm  = size(intersect_coords_sm, 1);
abramsIntCount_med = size(intersect_coords_med, 1);
abramsIntCount_lg  = size(intersect_coords_lg, 1);

% Combine intersections
abramsIntCount = abramsIntCount_sm + abramsIntCount_med + abramsIntCount_lg + 2 * count;

% Total circumference of all circles
abramsCircumference_tot = circumference_lg + circumference_med + circumference_sm;

% Calculate mean intercept length and grain size number
N_L = abramsIntCount / abramsCircumference_tot;
abrams_lbar = 1 / N_L;
G_PL = G_meanintl(abrams_lbar);

% Plotting if required
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
    plot(grains.boundary, 'linewidth', 2, 'lineColor', 'black'); % plot grain boundaries
    plot(polygon_sm(:,1), polygon_sm(:,2), 'k', 'linewidth', 3); % plot circles
    plot(polygon_med(:,1), polygon_med(:,2), 'k', 'linewidth', 3);
    plot(polygon_lg(:,1), polygon_lg(:,2), 'k', 'linewidth', 3);
    % Plot intersecting points (white) without triple points
    scatter(intersect_coords_sm(:,1), intersect_coords_sm(:,2), 'w', 'linewidth', 2); hold on
    scatter(intersect_coords_med(:,1), intersect_coords_med(:,2), 'w', 'linewidth', 2); hold on
    scatter(intersect_coords_lg(:,1), intersect_coords_lg(:,2), 'w', 'linewidth', 2); hold on
    % Plot triple points that intersect circles (red)
    if ~isempty(included_points)
        scatter(included_points(:,1), included_points(:,2), 'r', 'linewidth', 2);
    end
    hold off;
end
end

function [num_int, intersect_coords] = calculate_intersections(polygon, boundary)
num_int = zeros(size(polygon, 1) - 1, 1);
intersect_coords = [];
for n = 1:length(num_int)
    [xi, yi] = boundary.intersect(polygon(n, :), polygon(n + 1, :));
    x1 = xi(~isnan(xi));
    y1 = yi(~isnan(yi));
    intersect_coords = cat(1, intersect_coords, [x1', y1']);
    num_int(n) = numel(x1);
end
end

function [count, included_points] = count_triple_points(triple_points, intersections, stepsize)
count = 0;
included_points = [];
for i = 1:size(triple_points, 1)
    dist = sqrt((triple_points(i, 1) - intersections(:, 1)).^2 + (triple_points(i, 2) - intersections(:, 2)).^2);
    if any(dist < stepsize)
        count = count + 1;
        included_points = [included_points; triple_points(i, :)];
    end
end
end

function cleaned_coords = remove_nearby_points(coords, points_to_remove, threshold)
if isempty(points_to_remove)
    cleaned_coords = coords;
    return
end
keep = true(size(coords,1),1);
for i = 1:size(points_to_remove,1)
    dist = sqrt((coords(:,1) - points_to_remove(i,1)).^2 + (coords(:,2) - points_to_remove(i,2)).^2);
    keep = keep & (dist >= threshold);
end
cleaned_coords = coords(keep,:);
end
