function [conv_hullX, conv_hullY, offsetVal] = get_conv_hull(binaryImage, length_50_pixel)
    % Find boundaries of objects in the binary image
    boundaries = bwboundaries(binaryImage);
    
    % Create a combined list of all boundary points
    allBoundaryPoints = cat(1, boundaries{:});
    
    % Calculate the convex hull of all boundary points
    convex_hull = convhull(allBoundaryPoints(:, 2), allBoundaryPoints(:, 1));
    
    % Extract the convex hull points
    conv_hullX = allBoundaryPoints(convex_hull, 1);
    conv_hullY = allBoundaryPoints(convex_hull, 2);
    
    % figure();
    % imshow(binaryImage); hold on;
    % plot(conv_hullY, conv_hullX, 'r', 'LineWidth', 2);

    % Assuming 'convexHullX' and 'convexHullY' contain the convex hull points
    % Extract the convex hull points
   
    % Calculate the dimensions of the convex hull
   % Calculate the dimensions of the convex hull
    minX = min(conv_hullY); % here X and Y are inverted
    maxX = max(conv_hullY);
    minY = min(conv_hullX);
    maxY = max(conv_hullX);

    % Define the bounding box coordinates
    boundingBox = [minX, minY, maxX - minX, maxY - minY];

    num_offsets = ceil(min(abs(boundingBox(1)-boundingBox(3)), ...
        abs(boundingBox(2)-boundingBox(4)))/(-length_50_pixel)); 
    for i=1:num_offsets
        offsetVal(i) = length_50_pixel*i;
    end
end