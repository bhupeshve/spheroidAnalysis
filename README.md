# spheroidAnalysis
Analysis of spheroid images for varying intensity

% MATLAB Script -> SpheroidAnalysis_input.m

% Author: Bhupesh Verma, Anwesha Sarkar

% Date: September 22, 2023
%
% Description: This script analyses the spheroids and outputs Offset value (in μm),

% Area of ROI (in pixels), Total (Integrated) intensity, Mean

% Intensity, Median intensity, Std. Deviation of Intensity, Maximum

% intensity in the excel sheet
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

% - This code is prepared for spheroid analysis for Anwesha Sarkar's PhD

% thesis at University College Dublin (UCD)

% ------------------------------------------------------------------------
