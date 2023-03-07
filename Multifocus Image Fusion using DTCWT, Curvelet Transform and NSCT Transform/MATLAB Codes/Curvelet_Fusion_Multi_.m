% This is a program for Multifocus Image Fusion using Curvelet Transform.
% Input is .jpg, .png, .tif which is a multifocused image.
% Two inputs should be given.
% Output is a fused image of multifocused input images.
% Tulasi Bharathi, JNTUK, 2019.


clear all;
close all;
home;
%READ INPUT1 IMAGE:
[file path]=uigetfile('*.jpg;*.png;*.tif');
im1=imread([path file]);
im1=imresize(im1,[256 256]);I1=double(im1);
figure,imshow(uint8(I1),[]),title('input1');
%READ INPUT2 IMAGE:
[file1 path1]=uigetfile('*.jpg;*.png;*.tif');
im2=imread([path1 file1]);
im2=imresize(im2,[256 256]);I2=double(im2);
figure,imshow(uint8(I2),[]),title('input2');
I1=I1(:,:,1);
I2=I2(:,:,1);
%I1 = I1+6*randn(size(im1));
%I2 = I2+8*randn(size(im2));

%FDCT WRAPPING:
C1 = fdct_wrapping (I1, 1, 2);
C2 = fdct_wrapping (I2, 1, 2);
%C {1}{1} =(C1{1}{1} +C2{1}{1})/2;
I=C1{1}{1}.*(C1{1}{1}<=C2{1}{1})+C2{1}{1}.*(C2{1}{1}<C1{1}{1});
C {1}{1}=I+C1{1}{1}-I+C2{1}{1}-I;
block=2;
for i=1:length(C1)
for j=1:length(C1{i})
b_im1=C1{i}{j};
b_im2=C2{i}{j};
rr=ceil(size(b_im1,1)/block)*block-size(b_im1,1);
b_im1=wextend('ar','zpd',b_im1,ceil(size(b_im1,1)/block)*block-size(b_im1,1),'l');
ll=ceil(size(b_im1,2)/block)*block-size(b_im1,2);
b_im1=wextend('ac','zpd',b_im1,ceil(size(b_im1,2)/block)*block-size(b_im1,2),'l');
b_im2=wextend('ar','zpd',b_im2,ceil(size(b_im2,1)/block)*block-size(b_im2,1),'l');
b_im2=wextend('ac','zpd',b_im2,ceil(size(b_im2,2)/block)*block-size(b_im2,2),'l');
b_f_im=b_im1;
for m=1:size(b_im1,1)/block
for n=1:size(b_im1,2)/block
a_b=b_im1(((m-1)*block+1):m*block,((n-1)*block+1):n*block);
b_b=b_im2(((m-1)*block+1):m*block,((n-1)*block+1):n*block);
if mean2(a_b.^2)>mean2(b_b.^2)
b_f_im(((m-1)*block+1):m*block,((n-1)*block+1):n*block)=a_b;
else
b_f_im(((m-1)*block+1):m*block,((n-1)*block+1):n*block)=b_b;
end
end
end

C{i}{j}=b_f_im(rr+1:end,ll+1:end);
end
end 
imf = wfusimg (I1, I2,'coif3', 5,'min','max');

figure,imshow(uint8(imf),[]);
%Evaluation parameters
Corr_coef_C=corr2(I1,imf);

Entropy_C=entropy(imf);

Standard_dev_C=std2(imf);
 
Rmse_C=sqrt(immse(I1,imf));

AGmag_C=mean(imgradient(imf),'all');

M= size(imf,1); 
N= size(imf,2);
% calculate Raw Frequency RF 
SumRF=0;

for i=1:M 
    for j=2:N
      SumRF = SumRF + (imf(M,N)-imf(M,N-1)^2);  
    end
end

RF=sqrt(SumRF/(M*N)); 
    
% calculate Column Frequency CF 
SumCF=0;

for i=1:N 
    for j=2:M
      SumCF = SumCF + (imf(M,N)-imf(M-1,N)^2);  
end
end

CF=sqrt(SumCF/(M*N));  

% calculate Spatial Frequency SF output

SF=sqrt(RF^2+CF^2);
SpatialFrequency=abs(SF);
