function corner_grains = corner_grain_segmentation(edge_grains, polygon)
% Find the 4 grains touching the corners of a rectangle

corners = polygon(1:4, :);
corner_grains = struct('id', {}, 'boundary', {});

% Loop over each corner
for i = 1:4
    cx = corners(i, 1);
    cy = corners(i, 2);

    % Initialize the minimum distance large
    minDist = inf;
    closestGrain = struct('id', NaN, 'boundary', NaN);

    for j = 1:length(edge_grains)
        % Access the boundary points of the grain
        grain_boundary = edge_grains(j).boundary;

        % Check if the boundary has x and y coordinates
        grain_x = grain_boundary.x;
        grain_y = grain_boundary.y;

        % Calculate the distance from the corner to each boundary point
        for k = 1:length(grain_x)
            d = sqrt((grain_x(k) - cx).^2 + (grain_y(k) - cy).^2);

            if d < minDist
                minDist = d;
                closestGrain.id = edge_grains(j).id;
                closestGrain.boundary = edge_grains(j).boundary;
            end
        end
    end

    % Assign the closest grain to the corner
    corner_grains(i) = closestGrain;
end
end
