function [G_PL, MIC, intersection_count, nlines, total_line_length] = GrainSize_E112_HeynRandomLinePL(ebsd, varargin)
% Heyn Random Line Planimetric: Count of grain boundaries that
% intersect randomly placed lines. Single grain boundary intersections
% counts as 1, triple point intersections count as 2.

%%
% Grain sizing & line intersections
min_intercepts = 50;
[~, G_PL, ~, MIC, grains, ~, gb_intersection_coordinates, line_intersection_results, triplept_intersection_coordinates, nlines, total_line_length] = grainsize_linint_random(ebsd, min_intercepts);
intersection_count = total_line_length / MIC;  

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
    plot(grains.boundary,'LineWidth',2);
    xc = triplept_intersection_coordinates(:,1); % plot triple points
    yc = triplept_intersection_coordinates(:,2);
    scatter(xc,yc,'r','linewidth',2) % plot lines
    x = gb_intersection_coordinates(:,1);
    y = gb_intersection_coordinates(:,2);
    for i=1:size(line_intersection_results,1)
        line([line_intersection_results(i,1);line_intersection_results(i,3)], ...
            [line_intersection_results(i,2);line_intersection_results(i,4)], ...
            'linestyle','-','linewidth',4,'color','black')
    end
    scatter(x,y,'w','linewidth',2); % plot intersections
    xc = triplept_intersection_coordinates(:,1); % plot triple points
    yc = triplept_intersection_coordinates(:,2);
    scatter(xc,yc,'r','linewidth',2)
end
end