To execute multifocused image fusion using NSCT, 
1. Add the files in nsct_toolbox to your MATLAB current folder.
2. From add-ons of MATLAB software, search for minGW-w64 compiler and install it. 
To run zconv2.c and atrousc.c, you need to convert zconv2.c to zconv2.mexa64 and atrousc.c to atrousc.mexa64 using mex command. 

>>mex zconv2.c Press Enter
>>mex atrousc.c Press Enter

To use mex command in MATLAB software, minGW-w64 compiler is necessary.
To use mex command in MATLAB online, compiler is not necessary to install.