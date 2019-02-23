% Toby Thomas, 2017
%% question 1
%% A)
clear; close all;
% load in file
load('mr_data.mat');

%
mr_data_abs = abs(mr_data);
% Plot mad and freq spectrum
figure('Position',get(groot,'ScreenSize'))
subplot(1,3,1)
imshow(mr_data_abs,[])
title('mr data')
mr_data_spectrum = fftshift(fft2(mr_data_abs));
subplot(1,3,2)
imagesc((abs(mr_data_spectrum)))
axis image
title('mr data frequency spectrum (amplitude)')
subplot(1,3,3)
imagesc(log(abs(mr_data_spectrum)))
axis image
title('mr data frequency spectrum (log(amplitude))')

%% B)

N = size(mr_data);
f = linspace(-f_s(1)/2, f_s(1)/2*(1-2/N(1)), N(1)); % mm
figure('Position',get(groot,'ScreenSize'))
subplot(1,2,1)
imagesc(f,f,log(abs(mr_data)))
colormap(gray)
axis image
xlabel('u (mm^{-1})')
ylabel('v (mm^{-1})')
title('Data containing spike noise')
spike_image = ifft2(mr_data);
subplot(1,2,2)
imshow(abs(spike_image),[])
title('Image with spike noise artefacts')
% There is one visibly bright spot apparent in the spectrum, along with
% spatially periodic artefacts in the image that make it difficult to
% interepret.

peak_locations = [(128-round(0.43*128)+1),(128-round(0.24*128))];
% peak_locations = [-0.25,-0.4297];
disp(['The peak is at indices: ', num2str(peak_locations(1,1:2))]);
%The peaks are at indices: 109 114 and: 232 154

[u,v] = meshgrid(f);

% Lowpass Gaussian filter
D = sqrt(u.^2 + v.^2);
Cutoff = 0.1;
idealFilter = exp(-D.^2/(2*Cutoff^2));

% create a notch filter
% idealFilter = double(sqrt(u.^2 + v.^2) < 0.01);
notchFilt1 = zeros(size(mr_data));

% filter at point 1
notchFilt1(peak_locations(1,1),peak_locations(1,2)) = 1; 

% convolve and subtract
notchFilt1 = 1-conv2(abs(notchFilt1),idealFilter,'same'); 

%plot
figure('Position',get(groot,'ScreenSize'));
subplot(1,3,1)
imagesc(f,f,notchFilt1)
axis image
title('Notch filter')
xlabel('u (mm^{-1})')
ylabel('v (mm^{-1})')

% apply filter to the mr_data
notch1FilteredSpec = notchFilt1.*mr_data;
mr_data_mod = ifft2(notch1FilteredSpec);

%plot freq domain
figure('Position',get(groot,'ScreenSize'));
subplot(1,2,1)
imagesc(f,f,log(abs(notch1FilteredSpec)))
axis image
colormap gray;
title('Notch filtered mr data')

%plot notch filtered mr data
subplot(1,2,2)
imshow(abs(mr_data_mod),[]);
title('Notch filtered image');

%% C)
Cutoff = 0.2;
% i.
gauss_filter = exp(-D.^2/(2*Cutoff^2));
figure('Position',get(groot,'ScreenSize'));
subplot(2,3,1); 
imagesc(f,f,gauss_filter), colormap gray;
title('Gauss lowpass filter at 0.2 mm^{-1}')

% ii.
ideal_lowpass = D < 0.2;
subplot(2,3,2); 
imagesc(f,f,ideal_lowpass)
colormap gray;
title('Ideal Lowpass Filter at 0.2 mm^{-1}')

%iii.
order = 0.5;
butterworth = 1-1./(1+(Cutoff./D).^(2*order));
subplot(2,3,3); 
imagesc(f,f,butterworth)
colormap gray;
title('Butterworth filter of order 0.5 and cutoff at 0.2 mm^{-1}');

%% Question 2
%% A)
car = imread('car_blurred.png');

% extract a uniform section of the image to find NSR
%region:
% x: 66 ==> 91
% y: 534 ==> 602
region = car(66:91,534:602);
figure('position', get(groot, 'ScreenSize'));
subplot(1,2,1)
imshow(car(region));
title('section of image used to find NSR')
subplot(1,2,2)
imhist(region(:)), ylim([0 300])
title('Histogram of chosen section')

% The noise has a gaussian distribution.
% Now find mean and standandard deviation of region.
mean_val = mean(region(:));
std_val = std(double(region(:)));

fprintf('The mean value of the gaussian noise is: %.2d\n', mean_val)
fprintf('The standard deviation of the gaussian noise is: %.2d\n', std_val)

% find size of image
[m,n] = size(car);
% create correcting noise
noise =  imnoise2('Gaussian',m,n,0,std_val.^2); % Gaussian noise
Sn = abs(fft2(noise)).^2;
nA = sum(Sn(:))/numel(noise);
Sf = abs(fft2(car)).^2;
fA = sum(Sf(:))/numel(car);
NSR = nA/fA;

% reduce blur - create psf
LEN = sqrt((376-349)^2 + (164-154)^2);
ang_rad = atan((164-154)/(376-352));
THETA = (ang_rad*180)/pi;
psf = fspecial('motion',LEN,THETA);
% restore the number plate so that it can be read
J = car;
J(151:214,333:513) = deconvwnr(car(151:214,333:513),psf,NSR);
figure('Position',get(groot,'ScreenSize'));
subplot(1,2,1); imshow(car,[]);
title('car blurred original')
subplot(1,2,2);
imshow(J);
title('restored image')

% the number plate is: NN43 JJ0 (Figure 7)


