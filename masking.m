%Emma Burgess 11-23-19
%This applies 8 different masks to a matrix.
%INPUTS: NxM Matrix of 1s and 0s. 
%OUTPUTS: NxMx8 matrix of 1s and 0s. 

function maskedCode = masking(matrix)

[height,width] = size(matrix);
maskTotal = zeros(height,width,8);
change = 1;
noChange = 0;

% Mask pattern 1: (row + column) mod 2 == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh,ww,1) = mod(hh+ww,2);
    end
end

% Mask pattern 2: (row) mod 2 == 0
for hh = 1:height
    maskTotal(hh, :, 2) = mod(hh, 2);
end

% Mask pattern 3: (column) mod 3 == 0
for ww = 1:width
    maskTotal(:, ww, 3) = mod(ww, 3);
end

% Mask pattern 4: (row + column) mod 3 == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh, ww, 4) = mod(hh + ww,3);
    end
end

% Mask pattern 5: ( floor(row / 2) + floor(column / 3) ) mod 2 == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh, ww, 5) = mod(floor(hh/2) + floor(ww/3),2);
    end
end

% Mask pattern 6: ((row * column) mod 2) + ((row * column) mod 3) == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh, ww, 6) = mod(hh * ww, 2) + mod(hh * ww, 3);
    end
end

% Mask pattern 7: ( ((row * column) mod 2) + (row * column) mod 3) ) mod 2 == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh, ww, 7) = mod(mod(hh * ww, 2) + mod(hh * ww, 3), 2);
    end
end

% Mask pattern 8: ( ((row + column) mod 2) + ((row * column) mod 3) ) mod 2 == 0
for hh = 1:height
    for ww = 1:width
        maskTotal(hh, ww, 8) = mod(mod(hh + ww, 2) + mod(hh * ww, 3), 2);
    end
end
maskTotal(maskTotal ~= 0) = change;
maskTotal = mod(maskTotal + 1, 2);



maskFormatted = maskTotal .*pattern();

layeredMatrix = zeros(21, 21, 8);
for m = 1:8
    layeredMatrix(:, :, m) = matrix;
end
maskedCode = mod(layeredMatrix + maskFormatted, 2);


end
