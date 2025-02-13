%1.3.1

I = im2double(imread('board.png'));

m=0;
SNRdB=15;

var_I = std2(I)^2
var_gauss = sqrt(var_I/10^(SNRdB/10))

I_noisy = imnoise(I, 'Gaussian', m, var_gauss^2);

figure("Name","gaussian")
imshow(I_noisy)
title("ενθόρυβη εικόνα ")


%median filter
J_3 = medfilt2(I_noisy,[3 3]);

figure("Name","median 3x3 gaussian")
imshowpair(I_noisy,J_3,"montage")
title(' median filter παράθυρο 3χ3 vs gaussian')

J_9 = medfilt2(I_noisy,[9 9]);

figure("Name","median 9x9")
imshowpair(I_noisy,J_9,"montage")
title(' median filter παράθυρο 9χ9 vs gaussian')

%moving average
h_3 = fspecial('average',[3 3]);
A_3 = imfilter(I_noisy,h_3,"symmetric");


figure
imshowpair(A_3,I_noisy,"montage")
title("moving average filter παράθυρο 3χ3 vs gaussian")

h_9 = fspecial('average',[9 9]);
A_9 = imfilter(I_noisy,h_9,"symmetric");

figure
imshowpair(A_9,I_noisy,"montage")
title("moving average filter παράθυρο 9χ9 vs gaussian")

%1.3.2

d=0.3;
I_pepper = imnoise(I,'salt & pepper',d);

%median filter
J_3 = medfilt2(I_pepper,[3 3]);

figure("Name","median 3x3 salt&pepper")
imshow([I_pepper J_3])
title(' median filter παράθυρο 3χ3 vs salt&pepper')
 
J_9 = medfilt2(I_pepper,[9 9]);

figure("Name","median 9x9 salt&pepper")
imshow([I_pepper J_9])
title(' median filter παράθυρο 9χ9 vs salt&pepper')

%moving average
P_3 = imfilter(I_pepper,h_3,"symmetric");
P_9 = imfilter(I_pepper,h_9,"symmetric");

figure
imshowpair(I_pepper,P_3,"montage")
title("moving average 3χ3 vs salt&pepper")

figure
imshowpair(I_pepper,P_9,"montage")
title("moving average 9χ9 vs salt&pepper")