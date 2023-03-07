% This is a program for Multifocus Image Fusion using Nonsubsampled Contourlet Transform (NSCT).
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
figure,imshow((I1),[]),title('input1');
%READ INPUT2 IMAGE:
[file1 path1]=uigetfile('*.jpg;*.png;*.tif');
im2=imread([path1 file1]);
im2=imresize(im2,[256 256]);I2=double(im2);
figure,imshow((I2),[]),title('input2');





pfilt = '9-7';
dfilt = 'pkva';
nlevs = [0,1,3,4,4];



yA=nsctdec(I1,nlevs,dfilt,pfilt);
yB=nsctdec(I2,nlevs,dfilt,pfilt);

save yA yA
save yB yB
load yA
load yB
n = length(yA);
Fused=yA;

ALow1= yA{1};
BLow1 =yB{1};
ALow2= yA{2};
BLow2 =yB{2};

Fused{1}=(ALow1+BLow1)/2;
Fused{2}=(ALow2+BLow2)/2;

for l = 3:n

for d = 1:length(yA{l})
Ahigh = yA{l}{d};
Bhigh = yB{l}{d};
decision_map=(abs(Ahigh)>=abs(Bhigh));
Fused{l}{d}=decision_map.*Ahigh + (~decision_map).*Bhigh;
end
end

F=nsctrec(Fused, dfilt, pfilt);

 
figure,imshow(F,[]);

%Evaluation parameters

Corr_coef=corr2(I1,F);
stand_dev=std2(F);
e=entropy(F);
AGmag=mean(imgradient(F),'all');
rmse=sqrt(immse(I1,F));

M= size(F,1); 
N= size(F,2);
% calculate Raw Frequency RF 
SumRF=0;

for i=1:M 
    for j=2:N
      SumRF = SumRF + (F(M,N)-F(M,N-1)^2);  
    end
end

RF=sqrt(SumRF/(M*N)); 
    
% calculate Column Frequency CF 
SumCF=0;

for i=1:N 
    for j=2:M
      SumCF = SumCF + (F(M,N)-F(M-1,N)^2);  
end
end

CF=sqrt(SumCF/(M*N));  

% calculate Spatial Frequency SF output

SF=sqrt(RF^2+CF^2);
SpatialFrequency=abs(SF);
