function [G_L, lbar, n, intercept_lengths] = GrainSize_E112_HeynRandomLineMLI(ebsd, varargin)
% Heyn Randon Line Mean Lineal Intercept: Count of grain boundaries that
% intersect randomly placed lines. Single grain boundary intersections
% counts as 1, triple point intersections count as 2.

%%
% Grain sizing and line intersections
min_intercepts = 50;
[G_L, ~, ~, ~, grains, intercept_lengths, gb_intersection_coordinates, line_intersection_results, triplept_intersection_coordinates, ~, ~] = grainsize_linint_random(ebsd, min_intercepts);

lbar = mean(intercept_lengths);
n = length(intercept_lengths);

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
    plot(phase, phase.orientations); hold on
    plot(grains.boundary, 'LineWidth', 2); hold on
    x = gb_intersection_coordinates(:,1);
    y = gb_intersection_coordinates(:,2);
    hold on
    for i=1:size(line_intersection_results, 1)
        line([line_intersection_results(i,1);line_intersection_results(i,3)],[line_intersection_results(i,2);line_intersection_results(i,4)],'linestyle','-','linewidth',4,'color','black')
    end
    % plotting the intersections
    hold on
    scatter(x, y, 'w', 'linewidth', 2)
    % plotting the coordinates considered intersecting a triple point
    xc = triplept_intersection_coordinates(:,1);
    yc = triplept_intersection_coordinates(:,2);
    hold on
    scatter(xc,yc,'r','linewidth',2)
end % parse varargin
end