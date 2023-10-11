%%% required data fields
%%%% data_fields = {'Offset value (in μm)', 'Area of ROI (in pixels)' 'Total (Integrated) intensity', 'Mean Intensity',...
%%%% Median intensity', 'Std. Deviation of Intensity'};

function [result_innermost] = calc_intensity_inside(orig_image, boundary, excelFile, j)

  
    %%% This part of the code deals with ROI
    % Create a binary mask of the ROI INSIDE the offset polygon
    roiMaskInside = poly2mask(boundary.Vertices(:, 1), boundary.Vertices(:, 2), size(orig_image, 1), size(orig_image, 2));
    % Compute the area of the ROI using regionprops
    stats = regionprops(roiMaskInside, 'Area'); % stats.Area gives the area in pixels of ROI


    % Extract the pixels within the ROI from the grayscale image
    roiPixels = orig_image(roiMaskInside);
    
    %%%%%% Assign a colormap for visualizing the ROI
    coloredImage = orig_image;
    coloredImage(roiMaskInside) = 200; % Assign a color (white) to the ROI pixels
    
    %%%%Display the grayscale image with the ROI overlay
    figure();
    imshow(coloredImage);
    hold on;
    plot(boundary, 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2);

    title('Grayscale original Image with ROI Overlay for innermost/center region');
    
    % Compute intensity statistics (e.g., mean and median) for the ROI
    meanIntensity = mean(roiPixels);
    
    medianIntensity = median(roiPixels);
    result_innermost = {stats.Area,sum(roiPixels),mean(roiPixels),median(roiPixels),std(double(roiPixels)), max(roiPixels)};
    
    location_write = strcat('A', num2str(j+2));     text_in = {'Result inside'};
    writecell(text_in, excelFile,'Range', location_write);

    location_write = strcat('A', num2str(j+3));    text_in = {'Results at center'};
    writecell(text_in, excelFile,'Range', location_write);

    location_write = strcat('B', num2str(j+3));
    writecell(result_innermost, excelFile, 'Sheet', 'Intensity results', 'Range', location_write);

    % %%%Display the computed intensity statistics
    fprintf('Mean Intensity within the innermost region μm is: %.2f\n', meanIntensity);
    fprintf('Median Intensity within the innermost region: %.2f\n', medianIntensity);
end