%ασκ1.1
I=imread("leaf.jpg");
whos("I")

%1.1.1

Igray=im2gray(I);
%figure("Name","grayscale")
%imshow(Igray)
whos("Igray")
%κατωφλίωση
BW = imbinarize(Igray);

figure("Name","binary")
imshow(BW)
impixelinfo

figure("Name","erwthma1.1")
imshowpair(Igray,BW,'montage')

%1.1.2

P=[101 162]; %αρχικό πίξελ
B = bwtraceboundary(BW,[162 101],"N"); %έβρεση περιγράμαμτος με τον Moore-Neighbor tracing algorithm modified by Jacob's stopping criteria

figure("Name","Αποτύπωμα Περιγράμματος");
imshow(I)
hold on
plot(B(:,2),B(:,1),'r','LineWidth',2)

%1.1.3
Y = fft2(B);

%1.1.4
% x=100%
anakataskebh_B = ifft2(Y);
figure("Name","x=100%")
subplot(2,1,1)
title("Αρχική εικόνα")
plot(B(:,2),B(:,1),'r');
subplot(2,1,2)
title("Ανακατασκευή")
plot(anakataskebh_B(:,2),anakataskebh_B(:,1),'g');


% x=50%
x=2;
Y_vec = reshape(Y,[],1);
Y_length = length(Y_vec)/x; 
Y_2 = sort(abs(Y_vec),"descend");
Y_2(Y_length:end)=0;



%1.1.5

%rotated_I = imrotate(Igray,60,"crop"); %περιστροφή
%I_translated = imtranslate(rotated_I,[100 60],OutputView="full",FillValues=255); %μετακίνηση

tform = rigidtform2d(60,[100,60]);
sameAsInput = affineOutputView(size(BW),tform,"BoundsStyle","SameAsInput");
A = imwarp(BW, tform, FillValues=255,OutputView=sameAsInput);


figure
imshowpair(Igray,A,"montage")
title("αρχική, περιστραμένη εικόνα και μετατοπισμένη")


figure
imshow(A)
impixelinfo

P=[103 230]; %αρχικό πίξελ
B_allo = bwtraceboundary(A,[230 103],"W"); %έβρεση περιγράμαμτος με τον Moore-Neighbor tracing algorithm modified by Jacob's stopping criteria


Y_allo = fft2(B_allo);

anakataskebh_B_allo = ifft2(Y_allo);

figure("Name","x_allo=100%")
subplot(2,1,1)
title("Αρχική εικόνα")
plot(B_allo(:,2),B_allo(:,1),'r');
subplot(2,1,2)
title("Ανακατασκευή")
plot(anakataskebh_B_allo(:,2),anakataskebh_B_allo(:,1),'g');





