%This function deals with the version and format information
%It takes in three inputs: A 2D matrix which is the QR code,
%the error level we are using, and the mask pattern
%I am assuming the error level is a character and the mask pattern a double
%The output is the QR code with the format and version info.

function [formatCode] = formatVersion(qrCode, errorLevel, maskPattern)

%Switch statement to determine binary for errorLevel
switch errorLevel
    case 'L'
        binaryErrorLevel = '01';
    case 'M'
        binaryErrorLevel = '00';
    case 'Q'
        binaryErrorLevel = '11';
    case 'H' 
        binaryErrorLevel = '10';
end

%Creates the appropriate message polynomial by converting it from doubles
%to arrays with the binary representation.

binaryMaskPattern = dec2bin(maskPattern, 3);
errorMask = strcat(binaryErrorLevel, binaryMaskPattern);
xp = '0000000000';
mx = strcat(errorMask, xp);
asciiArrayMx = double(mx);
asciiArrayVersion = double(errorMask);

%It is a string right now, so make into an array.
mxArray = zeros(1, length(asciiArrayMx));
for i = 1:length(asciiArrayMx)
    mxArray(i) = sscanf(char(asciiArrayMx(i)), '%f');
end

%Rotate it to go ascending for gfdeconv
mxArray = rot90(mxArray);
mxArray = rot90(mxArray);


%Generator polynomial x^10 + x^8 + x^5 + x^4 + x^2 + x + 1
gx = [1 0 1 0 0 1 1 0 1 1 1];
%Rotate it for gfdeconv. I know...I could have declared it like that from
%the start. 
gx = rot90(gx);
gx = rot90(gx);

%Error correction polynomial. Remainder contains what we need. 
[~, r] = gfdeconv(mxArray, gx);

%If string make into array
versionArray = zeros(1, length(asciiArrayVersion));
for i = 1:length(asciiArrayVersion)
    versionArray(i) = sscanf(char(asciiArrayVersion(i)), '%f');
end

%Put version and error correction together
versionArray = rot90(versionArray);
versionArray = rot90(versionArray);
versionError = horzcat(r, versionArray);

%Masking
mask = [1 0 1 0 1 0 0 0 0 0 1 0 0 1 0];
mask = rot90(mask);
mask = rot90(mask);

finalArray = xor(mask, versionError);

%Put it in the qr code
formatCode = qrCode;

%Fill up the 9th column
for i = 1:1:11
    if (i < 7)
        formatCode(i, 9) = finalArray(i);
    elseif (i == 7)
        formatCode(i, 9) = 1;
    elseif (i > 7 && i < 10)
        formatCode(i, 9) = finalArray(i-1);
    elseif (i == 10)
            formatCode(i+4, 9) = 1;
    elseif (i == 11)
        for n = 1:1:7
            formatCode(14+n, 9) = finalArray(8+n);
        end
    end      
end

temp = rot90(finalArray);
temp = rot90(temp);

%Fill up the 9th row
for i = 1:1:11
    if (i < 7)
        formatCode(9, i) = temp(i);
    elseif (i == 7)
        formatCode(9, i) = 1;
    elseif (i > 7 && i < 10)
        formatCode(9, i) = temp(i-1);
    elseif (i == 10)
        for n = 1:1:8
            formatCode(9, 13+n) = temp(7+n);
        end
    end      
end
 
%Image check, although it has to be inverted for correct colors
imagesc(formatCode)
colormap(gray)

end
