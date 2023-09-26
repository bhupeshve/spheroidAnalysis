function spheroidAnalysis(image_to_read, physical_size_of_image, minComponentSize, dilation_radius, offset_length, excelFile)

    %%%%%%%%%%%%%%%%%% Preparing for the output excel sheet
    data_fields = {'Offset value (in μm)', 'Area of ROI (in pixels)', 'Total (Integrated) intensity', 'Mean Intensity',...
        'Median intensity', 'Std. Deviation of Intensity', 'Maximum intensity'}; % more variables can be added if needed and they should be calculated in calc_intensity function
    writecell(data_fields, excelFile, 'Sheet', 'Between offset curve');
    writecell(data_fields, excelFile, 'Sheet', 'Inside offset Curve');
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%% This part of the code changes the image to a binary grey
    %%%%%%%%%%%%% scale image
    % Read the 16-bit grayscale image
    originalImage = imread(image_to_read,"tif");
    
    % Use the size function to get the dimensions of the image
    [imageHeight, imageWidth] = size(originalImage);
    length_per_pixel = imageHeight/physical_size_of_image; % this is in pixel per μm
    
    offsetVal_per_50 = -offset_length*length_per_pixel; % pixels for 50μm
    
    % Normalize the 16-bit image to the range [0, 1]
    normalizedImage = double(originalImage) / double(max(originalImage(:)));
    
    % Calculate Otsu's threshold - Automatic threshold calculation
    threshold = graythresh(normalizedImage);
    
    % Thresholding: Convert the normalized image to binary
    binaryImage = imbinarize(normalizedImage, threshold);
    
    % Convert the binary image to 8-bit (0 and 255)
    binaryImage8Bit = uint8(binaryImage) * 255;
    
    %%%%% Cleaning up the image
    % Example: Remove components smaller than a threshold
    cc = bwconncomp(binaryImage8Bit);
    binaryImageCleaned = bwareaopen(binaryImage8Bit, minComponentSize);
    binaryImageCleaned_8bit = uint8(binaryImageCleaned) * 255;
    %%%%%%%%%%%%
    
    % Define a structuring element for dilation (e.g., a disk)
    se = strel('disk', dilation_radius); % Adjust 'radius' as needed
    
    % Dilate the binary image to close the holes
    dilatedImage = imdilate(binaryImageCleaned_8bit, se);
    
    % Erode the dilated image to bring it back to the original size
    erodedImage = imerode(dilatedImage, se);
    
    filledImage = imfill(binaryImageCleaned_8bit, 'holes');
    
    [conv_hullX, conv_hullY, offsetVal] = get_conv_hull(filledImage, offsetVal_per_50);
    orig_convHullX = conv_hullX; orig_convHullY = conv_hullY;
    
        % Display the eroded image with filled holes
    figure();
    imshow(filledImage);
    hold on;
    plot(orig_convHullY, orig_convHullX, 'r', 'LineWidth', 2);
    title('Binary Image with Holes Filled and computed convex hull');

    %%%%Saving the binary image used for further calculation
    %%%%imwrite(filledImage, imageName)
    
    %%%%% This calls the function to calculate the intensity of the variables
    %%%%% using the original image
    j = 1;
    for i = offsetVal
        [boundary(j), inside(j), between(j)] = calc_intensity(originalImage,conv_hullX,conv_hullY, offsetVal_per_50,j, excelFile, offset_length);
        if(inside(j)==0)
            break;
        end
        conv_hullY = boundary(j).Vertices(:,1); conv_hullX = boundary(j).Vertices(:,2);
        j= j+1;
    end
    
    % calculation of final mean intensity
    final_inside = inside(inside~=0); final_between = between(between~=0);
    offsetVal = offsetVal(1:length(final_inside));
    
    %%%% The following line deletes all the non-required variables
    clearvars('-except','final_between', 'offset_length', 'final_inside','gray16BitImage','orig_convHullX','orig_convHullY','boundary','normalizedImage')
    
    %%%% This figure plots all the considered offset curves
    figure();
    imshow(normalizedImage);
    hold on; % Allow superimposing the boundary on the image
    
    %%%%%plot the polygon
    plot(orig_convHullY, orig_convHullX, 'g', 'LineWidth', 2);
    hold on;
    %%%%Plot the offset polygon in red
    for i=1:length(final_inside)
        plot(boundary(i), 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2);
        offset(i) = offset_length*i;
        hold on
    end
    title('All considered offset cuves and hull plotted on original image')
    hold off;
    %%%%%%%%%%%%%%%%
    
    %%%%%%%%% This figure plots the variation of mean instensity
    figure();
    plot(offset,final_inside,'*-', 'color','blue')
    hold on;
    plot(offset,final_between,'+-', 'color', 'red')
    legend('Inside the offset curve', 'In-between offset curve and convex hull','Location','southeast')
    title('Mean intensity variation')
    xlabel('Offset value [in μm]')
    ylabel('Mean intensity')
end
