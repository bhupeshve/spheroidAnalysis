%%% required data fields
%%%% data_fields = {'Offset value (in μm)', 'Area of ROI (in pixels)' 'Total (Integrated) intensity', 'Mean Intensity',...
%%%% Median intensity', 'Std. Deviation of Intensity'};

function [boundary, intensity_inside, intensity_between] = calc_intensity(orig_image, convexHullX, convexHullY, offsetVal, k, excelFile, offset_length)

    %initializing all the outputs
    boundary = []; intensity_inside = 0; intensity_between=0; 

    % Offset value (adjust as needed)
    offset = offsetVal; % Number of pixels to expand (use negative value to shrink)

    % Correct the rotation by swapping X and Y coordinates
    offsetConvexHullPoints = [convexHullY, convexHullX];
    
    % Create a polyshape object from the corrected convex hull points
    offsetPolygon = polyshape(offsetConvexHullPoints);
    
    % Buffer (expand) or erode (shrink) the polyshape
    offsetPolygon = polybuffer(offsetPolygon, offset, 'JointType', 'round');
    boundary = offsetPolygon;

    %%%%%Display the binary image
    % figure();
    % title('Convex hull and offset cuve')
    % imshow(orig_image);
    % hold on; % Allow superimposing the boundary on the image
    % 
    % %%%%%plot the polygon
    % plot(convexHullY, convexHullX, 'r', 'LineWidth', 2);
    % hold on;
    % % Plot the offset polygon in red
    % plot(offsetPolygon, 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2);

    % hold off; % Release the hold on the image
    
    
    %%% This part of the code deals with ROI
    % Create a binary mask of the ROI INSIDE the offset polygon
    roiMaskInside = poly2mask(offsetPolygon.Vertices(:, 1), offsetPolygon.Vertices(:, 2), size(orig_image, 1), size(orig_image, 2));
    % Compute the area of the ROI using regionprops
    stats = regionprops(roiMaskInside, 'Area'); % stats.Area gives the area in pixels of ROI


    % Extract the pixels within the ROI from the grayscale image
    roiPixels = orig_image(roiMaskInside);
    
    % Assign a colormap for visualizing the ROI
    % coloredImage = orig_image;
    % coloredImage(roiMaskInside) = 200; % Assign a color (white) to the ROI pixels
    
    %%%%%Display the grayscale image with the ROI overlay
    % figure();
    % imshow(coloredImage);
    % title('Grayscale original Image with ROI Overlay inside offset curve');
    
    % Compute intensity statistics (e.g., mean and median) for the ROI
    meanIntensity = mean(roiPixels);
    
    intensity_inside = meanIntensity;

    if isnan(intensity_inside)
        intensity_inside = 0; return;
    end

    medianIntensity = median(roiPixels);
    result_inside = {offset_length*k, stats.Area,sum(roiPixels),mean(roiPixels),median(roiPixels),std(double(roiPixels)), max(roiPixels)};
    location = strcat('A', num2str(k+1));
    writecell(result_inside, excelFile, 'Sheet', 'Inside offset Curve','Range', location);

    % %%%Display the computed intensity statistics
    fprintf('Mean Intensity within the offset cuve for offset value of %.2f μm is: %.2f\n', offset_length*k, meanIntensity);
    fprintf('Median Intensity within the offset curve: %.2f\n', medianIntensity);
    
    %%% Now here I want to compute the intensity BETWEEN the convex hull and
    %%% offset curve
    % Invert the binary mask that represents the convex hull
    convexHullMask = poly2mask(convexHullY, convexHullX, size(orig_image, 1), size(orig_image, 2));
       
    % Combine the two masks using the logical AND operation to get the pixels between offset curve and convex hull
    roiMaskBetweenOffsetAndHull = ~roiMaskInside & convexHullMask;%roiMaskBetweenHullAndOffset;
    
    % Assign a colormap for visualizing the ROI
    % figure();
    % coloredImage = orig_image;
    % coloredImage(roiMaskBetweenOffsetAndHull) = 200; % Assign a color (white) to the ROI pixels
    
    %%%Display the grayscale image with the ROI overlay
    % figure();
    % imshow(coloredImage);
    % title('Grayscale Image with ROI Overlay between offset curve and convex hull');
    
    % Extract the pixels within this ROI from the grayscale image
    roiPixelsBetweenOffsetAndHull = orig_image(roiMaskBetweenOffsetAndHull);
  
    intensity_between = mean(roiPixelsBetweenOffsetAndHull);

    % Compute the area of the ROI using regionprops
    stats = regionprops(roiMaskBetweenOffsetAndHull, 'Area'); % stats.Area gives the area in pixels of ROI
    
    result_between = {offset_length*k, stats.Area,sum(roiPixelsBetweenOffsetAndHull),mean(roiPixelsBetweenOffsetAndHull),...
        median(roiPixelsBetweenOffsetAndHull),std(double(roiPixelsBetweenOffsetAndHull)), max(roiPixelsBetweenOffsetAndHull)};
    location = strcat('A', num2str(k+1));
    writecell(result_between, excelFile, 'Sheet', 'Between offset curve','Range', location);
    
    % Display the computed intensity statistics for the new ROI
    fprintf('Mean Intensity Between Offset and Hull for offset value %.2f μm is: %.2f\n', offset_length*k,mean(roiPixelsBetweenOffsetAndHull));
    fprintf('Median Intensity Between Offset and Hull: %.2f\n', median(roiPixelsBetweenOffsetAndHull));

end
