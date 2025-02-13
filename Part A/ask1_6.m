%1.6.1
I = imread("hallway.png");
G = im2gray(I);

thresOutNew = 0.025;
[BW,thresOut,Gx,Gy,] = edge(G,"sobel");


figure("Name","greyscale vs sobel")
imshowpair(G,BW,"montage")
title(sprintf('greyscale vs sobel με %f threshold',thresOut));

Gy_eq = adapthisteq(Gy,"NumTiles",[14 8]);
Gx_eq = adapthisteq(Gx,"NumTiles",[8 14]);
 
figure("Name","Gx,Gy")
imshowpair(Gx_eq,Gy_eq,"montage")
title("Gx,Gy")

GxGy =imfuse(Gx_eq,Gy_eq,"blend");

figure("Name","GxGy")
imshow(GxGy)
title("GwGy")

%1.6.2

Gy_bw = imbinarize(Gy);
Gx_bw = imbinarize(Gx);
GxGy_bw = imbinarize(GxGy);

[counts,binLocations] = imhist(Gy);
thresh_y = otsuthresh(counts)
[counts,binLocations] = imhist(Gy);
thresh_x = otsuthresh(counts)
[counts,binLocations] = imhist(GxGy);
thresh_xy = otsuthresh(counts)

figure
histogram(Gy_bw)
title('Gy binary histogram')
figure
histogram(Gx_bw)
title('Gx binary histogram')
figure
histogram(GxGy_bw)
title('GxGy binary histogram')

figure
imshow(GxGy_bw)
title(sprintf('GxGy binary με otsu threshold %f',thresh_xy));
figure
imshowpair(Gx_bw,Gy_bw,"montage")
title(sprintf("Gx με otsu threshold %f",thresh_x,", Gy και %f ",thresh_y, " bianries"))

%1.6.3
%close all
[H,theta,rho] = hough(BW);

figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)

P = houghpeaks(H,1000,'threshold',ceil(0.09*max(H(:))));
length(P)
enwsh_kenwn = 12;
elaxisto_mhkos_grammwn = 50;
lines = houghlines(BW,theta,rho,P,'FillGap',enwsh_kenwn,'MinLength',elaxisto_mhkos_grammwn);
length(lines)
figure, imshow(I), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
