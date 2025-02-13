%1.5.1
I=imread("new_york.png");
Idouble = im2double(I);

s=1.7;
H = fspecial("gaussian",[3 3],s);

G = imfilter(Idouble,H,'conv');

figure("Name","Gaussian smoothing")
imshow(G)
title("Gaussian smoothing")

%1.5.2

Gd = im2double(G);
m=0;
SNRdB=7;

var_I = std2(Gd)^2;
var_gauss = sqrt(var_I/10^(SNRdB/10));

I_noisy = imnoise(Gd, 'Gaussian', m, var_gauss^2);
figure("Name","gaussian noise")
imshowpair(I,I_noisy, "montage")
title('αρχική vs gaussian smouthed & noise')





%wiener με γνωστό SNR
I_wnrSNR = deconvwnr(I_noisy,H,7);

 
figure("Name","SNR γνωστό")
imshowpair(I,I_wnrSNR,"montage")
title("Αρχική εικόνα vs I wnr με γνωστό SNR")

%άγνωστο snr
I_wnr = deconvwnr(I_noisy,H);

figure("Name","SNR άγνωστο")
imshowpair(I_wnrSNR,I_wnr,"montage")
title("Αρχική εικόνα vs I wnr με γνωστό SNR vs Ι wnr άγνωστου SNR")

