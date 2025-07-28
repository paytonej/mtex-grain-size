function [tP_x, tP_y, N_tP, qP_x, qP_y, N_qP] = find_quadruple_points(grains)
% Determine the quadruple points from the list of triple points. Any 1
% quadruple point will inherently contain 2 triple points.

% Extract all triple points
tP = grains.triplePoints;

% Extract triple point coordinates
tP_x_all = tP.x;
tP_y_all = tP.y;

% Combine coordinates into a matrix
tP_coords = [tP_x_all(:), tP_y_all(:)];

% Count triple points
N_total_tP = size(tP_coords, 1);

% Initialize logical array to track quadruple point pairs
same_spot = false(N_total_tP, N_total_tP);

% Find identical triple point coordinates
for i = 1:N_total_tP
    for j = i+1:N_total_tP
        if isequal(tP_coords(i, :), tP_coords(j, :))
            same_spot(i, j) = true;
            same_spot(j, i) = true;
        end
    end
end

% Get indices of points at same spot
[row, ~] = find(triu(same_spot));

% Extract quadruple point coordinates
qP_coords = unique(tP_coords(row, :), 'rows');
qP_x = qP_coords(:, 1);
qP_y = qP_coords(:, 2);
N_qP = size(qP_coords, 1);

% Remove quadruple point coordinates from triple point list
[~, ia] = setdiff(tP_coords, qP_coords, 'rows');
tP_coords_filtered = tP_coords(ia, :);
tP_x = tP_coords_filtered(:, 1);
tP_y = tP_coords_filtered(:, 2);
N_tP = size(tP_coords_filtered, 1);

end
