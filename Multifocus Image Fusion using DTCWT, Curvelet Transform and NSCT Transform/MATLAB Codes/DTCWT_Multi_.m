% This is a program for Multifocus Image Fusion using DTCWT.
% Input is any .jpg, .png, .tiff file which is a multifocused image
% Two multifocused images should be given as inputs.
% Output is a fused image of two multifocused input images
% Tulasi Bharathi, JNTUK, 2019



clear all;
close all;
home;
J=6;
[Faf,Fsf] = FSfarras; % first stage filters
[af,sf] = dualfilt1;  % second stage filters
%READ INPUT1 IMAGE:
[file path]=uigetfile('*.jpg;*.png;*.tiff');
I1=imread([path file]);I1=double(I1);

figure,imshow((I1),[]),title('input1');
%READ INPUT2  IMAGE:
[file1 path1]=uigetfile('*.jpg;*.png;*.tiff');
I2=imread([path1 file1]);I2=double(I2);

figure,imshow(double(I2),[]),title('input2');


w1 = cplxdual2D(I1,J,Faf,af);
w2 = cplxdual2D(I2,J,Faf,af);
% Image fusion process start here
for j=1:J % number of stages
    for p=1:2 %1:real part & 2: imaginary part
        for d1=1:2 % orientations
            for d2=1:3
                x = w1{j}{p}{d1}{d2};
                y = w2{j}{p}{d1}{d2};
                D  = (abs(x)-abs(y)) >= 0; 
                wf{j}{p}{d1}{d2} = D.*x + (~D).*y; % image fusion
            end
        end
    end
end
for m=1:2 % lowpass subbands
    for n=1:2
        wf{J+1}{m}{n} = 0.5*(w1{J+1}{m}{n}+w2{J+1}{m}{n}); % fusion of lopass subbands
    end
end
% fused image
imf = icplxdual2D(wf,J,Fsf,sf);
figure; imshow(imf,[]);


