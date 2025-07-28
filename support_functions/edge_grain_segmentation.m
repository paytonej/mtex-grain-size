function [inside_grains, edge_grains, corner_grains] = edge_grain_segmentation(ebsd, polygon, include_corner_grains, varargin)
% Segments inside grains from grains touching the edge of a polygon

% Select only ebsd data within polygon
ind = inpolygon(ebsd, polygon);
ebsd = ebsd(ind);

% Detect grains
[inside_grains, ebsd.grainId] = calcGrains(ebsd('indexed'), 'angle', 5*degree, 'unitcell');

% Check for 'exclude_twins' in varargin
if any(strcmp(varargin, 'exclude_twins'))
    inside_grains = exclude_twins(inside_grains);
end

% Detect edge grains
outerBoundary_id = any(inside_grains.boundary.grainId == 0, 2);
grain_id = inside_grains.boundary(outerBoundary_id).grainId;
edge_grains = inside_grains(grain_id(:, 2));

% Remove the edge grains from inside_grains
inside_grains(grain_id(:, 2)) = [];

% Perform corner grain segmentation if required
if include_corner_grains
    corner_grains = corner_grain_segmentation(edge_grains, polygon);
else
    corner_grains = [];
end

% Remove the corner grains from edge_grains list
if ~isempty(corner_grains)
    corner_grain_ids = [corner_grains.id];
    edge_grains = edge_grains(~ismember([edge_grains.id], corner_grain_ids));
end
end
