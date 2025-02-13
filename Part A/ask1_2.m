%ask1.2
I = imread("lenna.jpg");
whos I

imageBlocks = im2col(image, [32,32], 'distinct');
dctBlocks = dct2(imageBlocks);

numCoefficients = round(32^2); %μεθοδος επιλογής συντελεστών



dctBlocksCompressed = zeros(size(dctBlocks));
dctBlocksCompressed(1:numCoefficients, :) = dctBlocks(1:numCoefficients, :);
reconstructedBlocks = idct2(dctBlocksCompressed);
reconstructedImage = col2im(reconstructedBlocks, [32, 32], size(image), 'distinct');
