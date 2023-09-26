# spheroidAnalysis
Analysis of spheroid images for varying intensity

MATLAB Script -> SpheroidAnalysis_input.m

Author: Bhupesh Verma, Anwesha Sarkar

Date: September 26, 2023

Description: This script analyses the spheroids and outputs Offset value (in μm), Area of ROI (in pixels), Total (Integrated) intensity, Mean Intensity, Median intensity, Std. Deviation of Intensity, Maximum intensity in the excel sheet. The excel provides these values in a region of length specified by the 'offset length' variable.

Usage: This script requires spheroidAnalysis.m, calc_intensity.m and get_conv_hull.m in the same folder as this script. User needs to input the name of the image to be process ONLY IN TIF format. User also needs to specify the size of the spheroids from the experiments and adjust the minComponentSize to remove the noise from the image. Also dilation_radius can be increased if the image contains larger holes which needs to be filled.

Notes:

- User input required for physical_size_of_image and offset_length

- It is advised to first find the minComponentSize and dilation_radius variable for an image. Recommended values of minComponentSize are 20, 40, 60 and 80 for minComponentSize AND 5, 10, 20 and 30 for dilation_radius.

- This code is prepared for spheroid analysis for Anwesha Sarkar's PhD thesis at University College Dublin (UCD)

  ![Screenshot 2023-09-26 202029](https://github.com/bhupeshve/spheroidAnalysis/assets/146075582/6d6856e1-111d-4f62-8ed5-359806a22c22)
![Screenshot 2023-09-26 202142](https://github.com/bhupeshve/spheroidAnalysis/assets/146075582/48b40185-9a23-46b8-9da6-52f82b6aa57a)


![Screenshot 2023-09-26 202113](https://github.com/bhupeshve/spheroidAnalysis/assets/146075582/44516e8a-5462-467c-97da-77b76fb8c1e8)
