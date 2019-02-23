%% Toby Thomas k1504195 Signal and Image proc. CW1 2016
%% 1. 
%% a) 
% The purposes of Histogram equalization are:
% "-to equally make use of all available gray levels in the dynamic range;
% -for further histogram specification." (http://fourier.eng.hmc.edu,
% 01/03/2017)
% Since this image is mostly black and the detail (Llama) only occupies a
% small part of the entire image, histogram equalisation reduces the
% contrast of the Llama itself.

%% b)
% Local histogram encancement will be the most appropriate method to use
% since it can be used to enhance only the area of interest (the Llama) and
% not the the surrounding backround which is not of interest and will
% remain dark.

%% c) 
clear; clc; close all;

I = imread('Llama.tif');
I_histeq = histeq(I);

%
figure;
%Original Image
subplot(2,2,1);
imshow(I)
title('Original')

%Hist equalisation
subplot(2,2,2);
imshow(I_histeq)
title('Histogram equalisation')

%% d)

ref = ones(1,256)/(256*30);
ref(1) = 1/256*30;

spec = histeq(I, ref);

subplot(2,2,3)
imshow(spec)
title('Specification')

%% e)
local = adapthisteq(I);

subplot(2,2,4);
imshow(local)
title('Local Histogram Enhancement')

%% f)

% The histogram equalisation caused a significant loss of contrast over the
% entire image and the Llama was more difficult to make out than in the
% original. The Image created using a spesification is more appropriate
% than the first enhancement and as a reault the Llama is easier to see,
% however the backround of the image is much lighter than the original
% image. The local histogram enhancement produced by increacing the 
% contrast within the Llama without effecting the background colour.

%% 2. 
% read image
figure()
im = imread('tumour_pet.tif');

%blur image
im_blur = imgaussfilt(im,3,'FilterSize', [5 5]);

% Apply a histogram equalisation
im_histeq = adapthisteq(im_blur, 'ClipLimit', 0.02,'Distribution', 'rayleigh','NumTiles', [4 4]);
 

%choose threshold to be 150 and create black/white image
for i = 1:(size(im_histeq,1))
    for j = 1:(size(im_histeq,2))
        if im(i,j) > 150
            tum (i,j) = 255;
        else
            tum(i,j) = 0;
        end
    end
end

%edge finder
edge = fspecial('sobel');

%apply sobel mask and find border
mask_x = imfilter(tum,edge);
mask_y = imfilter(tum,edge');

border = sqrt(mask_x.^2 + mask_y.^2);

%plot all graphs

subplot(2,4,1)
imshow(im)
title('Origial')

subplot(2,4,2)
imshow(im_blur)
title('Gaussian blur')

subplot(2,4,3)
imshow(im_histeq)
title('Equalisation')

subplot(2,4,4)
imhist(im_histeq)
title('Histogram Equalisation')
axis([0 255  0 250])


subplot(2,4,5);
imshow(tum)
title('Threshold = 150')

subplot(2,4,6)
imshow(border)
title('Border')

subplot(2,4,[7 8])
imshow(im, [])
hold on;
imagesc(border,'AlphaData', border>0);
hold off;
title('Edited image')

