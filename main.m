%Main
clear all
inputText = 'heloo';
errIn = 'H';
stream = encodeData(inputText,errIn);
streamOut = ErrorCorrectionCoding(stream);
matrixOut = modulePlacement(streamOut);
[masked, maskNb] = chooseMask(matrixOut);
formatCode = formatVersion(masked, errIn, maskNb);
colormap(gray)
imagesc(mod(formatCode + 1, 2));
axis square;

