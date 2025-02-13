%1.7.1.a
I = imread("coins.png");
[counts,binLocations] = imhist(I);
thresh = otsuthresh(counts)-0.1
BW = imbinarize(I,thresh);

figure("Name",'I histogram')
imhist(I)
title('histogram αρχικής εικόνας')

figure("Name",'bw histogram')
histogram(BW)
title('histogram binary εικόνας')


figure("Name",'BW')
imshow(BW)
title("binary εικόνα")

%1.7.1.b

%maska
BW_mask = uint8(BW);
I_masked = I.*BW_mask;

figure("Name",'Ιmasked')
imshowpair(I_masked,I,"montage")
title('Εικόνα με εφηρμοσμένη την μάσκα , αρχική')

%1.7.1.c
A = bwtraceboundary(BW,[112 8],"N");
B = bwtraceboundary(BW,[54 32],"N");
C = bwtraceboundary(BW,[34 120],"N");
D = bwtraceboundary(BW,[148 67],"N");
E = bwtraceboundary(BW,[211 91],"N");
F = bwtraceboundary(BW,[87 86],"N");
G = bwtraceboundary(BW,[123 146],"N");
H = bwtraceboundary(BW,[72 188],"N");
I = bwtraceboundary(BW,[179 212],"N");
J = bwtraceboundary(BW,[108 241],"N");


figure
imshow(I_masked)
hold on
plot(A(:,2),A(:,1),'r','LineWidth',2)
plot(B(:,2),B(:,1),'g','LineWidth',2)
plot(C(:,2),C(:,1),'b','LineWidth',2)
plot(D(:,2),D(:,1),'r','LineWidth',2)
plot(E(:,2),E(:,1),'g','LineWidth',2)
plot(F(:,2),F(:,1),'b','LineWidth',2)
plot(G(:,2),G(:,1),'r','LineWidth',2)
plot(H(:,2),H(:,1),'g','LineWidth',2)
plot(I(:,2),I(:,1),'b','LineWidth',2)
plot(J(:,2),J(:,1),'r','LineWidth',2)


%1.7.2
%clear
%close all

%I = imread("football.jpg");

%[L2,centers2] = imsegkmeans(I,2);
%[L3,centers3] = imsegkmeans(I,3);
%[L4,centers4] = imsegkmeans(I,4);




%colormap2 = colormap(map);

%L2_colour = ind2rgb(L2, colormap2);
%L3_colour = ind2rgb(L3, colormap3);
%L4_colour = ind2rgb(L4, colormap4);
%B = labeloverlay(I,L2,"Colormap",[1 1 0; 1 0 1]);

%figure
%imshow(B)
%K2 = xrwmatismosKmeans2(L2,200,0);

