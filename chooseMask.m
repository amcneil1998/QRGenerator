%Emma Burgess 11-23-19
%This runs all of the masking process
%INPUTS: 21x21 matrix of 1s and 0s that represent the unmasked QR code
%OUTPUTS: 21x21 matrix of 1s and 0s of the masked QR code, mask used (1-8)

function [masked,maskNb] = chooseMask(matrix)
maskedCode = masking(matrix);
score = penalties(maskedCode);
[~,maskNb] = min(score);
masked = maskedCode(:,:,maskNb);
end
