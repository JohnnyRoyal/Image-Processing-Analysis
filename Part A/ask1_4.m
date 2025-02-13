%1.4.1

I_1 =imread("dark_road_1.jpg");
G_1 =im2gray(I_1);
I_2 =imread("dark_road_2.jpg");
G_2 =im2gray(I_2);
I_3 =imread("dark_road_3.jpg");
G_3 =im2gray(I_3);

figure("Name","dark_road_1")
imhist(G_1)
title("dark road 1")

figure("Name","dark_road_2")
imhist(G_2)
title("dark road 2")

figure("Name","dark_road_3")
imhist(G_3)
title("dark road 3")

%1.4.2

J_1 = histeq(G_1,256);
figure('Name',"global equalization histogram 1")
imhist(J_1)
title("global equalization histogram 1")

J_2 = histeq(G_2,256);
figure('Name',"global equalization histogram 2")
imhist(J_2)
title("global equalization histogram 2")

J_3 = histeq(G_3,256);
figure('Name',"global equalization histogram 3")
imhist(J_3)
title("global equalization histogram 3")

figure("Name","σύγκριση 1 global equalization")
imshow([I_1 J_1])
title("σύγκριση 1 global equalization")

figure("Name","σύγκριση 2 global equalization")
imshow([I_2 J_2])
title("σύγκριση 2 global equalization")

figure("Name","σύγκριση 3 global equalization")
imshow([I_3 J_3])
title("σύγκριση 3 global equalization")

%1.4.3

m1=10; m2=12; m3=12;
n1=10; n2=12; n3=12;

A_1 = adapthisteq(G_1);
figure('Name',"local equalization histogram 1")
imhist(A_1)
title("local equalization histogram 1")

A_2 = adapthisteq(G_2,"NumTiles",[m1 n1]);
figure('Name',"local equalization histogram 2")
imhist(A_2)
title("local equalization histogram 2")

A_3 = adapthisteq(G_3);
figure('Name',"local equalization histogram 3")
imhist(A_3)
title("local equalization histogram 3")

figure("Name","σύγκριση 1 local equalization")
imshow([I_1 A_1])
title("σύγκριση 1 local equalization")

figure("Name","σύγκριση 2 local equalization")
imshow([I_2 A_2])
title("σύγκριση 2 local equalization")

figure("Name","σύγκριση 3 local equalization")
imshow([I_3 A_3])
title("σύγκριση 3 local equalization")
