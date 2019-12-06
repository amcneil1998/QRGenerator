%Main
clear all
inputText = 'E';
errIn = 'L';
[stream] = encodeData(inputText,errIn);
[streamOut] = ErrorCorrectionCoding(stream);
matrixOut = modulePlacement(streamOut);
[masked,maskNb] = chooseMask(matrixOut);
[formatCode] = formatVersion(masked, errIn, maskNb);
imagesc(formatCode);
