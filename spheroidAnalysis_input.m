% ------------------------------------------------------------------------
% MATLAB Script -> SpheroidAnalysis_input.m
% Author: Bhupesh Verma, Anwesha Sarkar
% Date: October 11, 2023
%
% Description: This script analyses the spheroids and outputs Offset value (in μm),
% Area of ROI (in pixels), Total (Integrated) intensity, Mean
% Intensity, Median intensity, Std. Deviation of Intensity, Maximum
% intensity in the excel sheet. The excel provides these values in a region
% of length specified by the 'offset length variable'
%
% Usage: This script requires spheroidAnalysis.m, calc_intensity.m and get_conv_hull.m in
% the same folder as this script. User needs to input the name of the image
% to be process ONLY IN TIF format. User also needs to specify the size of
% the spheroids from the experiments and adjust the minComponentSize to
% remove the noise from the image. Also dilation_radius can be increased if
% the image contains larger holes which needs to be filled.
%
% Notes:
% - User input required for physical_size_of_image and offset_length
% - It is advised to first find the minComponentSize and dilation_radius
% variable for an image. Recommended values of minComponentSize are
% 20, 40, 60 and 80 for minComponentSize AND 5, 10, 20 and 30 for dilation_radius.
% In this code, it is assumed that images captured have the same height and
% width (or no. of pixels in both directions)
% - This code is prepared for spheroid analysis for Anwesha Sarkar's PhD
% thesis at University College Dublin (UCD)
% ------------------------------------------------------------------------

close all;
clear all;

%%%%%%%%%%%% User input

image_to_read = '5ugDMSO-ICG-4'; % name of the image to read, it should be specified without '.tif' at the end

physical_size_of_image = 819.2; % physical size of the photographed to be specified in μm. It is assumed here that the photographed area is a square

minComponentSize = 60; % Adjust as needed; 0 means it will not be used

dilation_radius = 10; % can be adjusted if bigger holes need to be filled

offset_length = 50; % this has to be specified in μm

excelFile = 'myfile.xlsx'; % name of the excel sheet required with all the data

spheroidAnalysis(image_to_read, physical_size_of_image, minComponentSize, dilation_radius, offset_length, excelFile);
