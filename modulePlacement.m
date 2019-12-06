function matrixOut = modulePlacement(inputBitString)
    %first is row, 2nd is column
    %black is represented by 2, white by 1, reserve by 3
    %at the end this is reset by first subtracting 1, then modding by 2,
    %resulting in a matrix with just 0s and 1s.  This makes preventing me
    %from walking on what i have already set easy.
    %create the empty matrix    
    matrixOut = zeros(21,21);
    %apply standard to inputBitString
    inputBitString = inputBitString + 1;
    cornerMarkers = [2, 2, 2, 2, 2, 2, 2;
                     2, 1, 1, 1, 1, 1, 2;
                     2, 1, 2, 2, 2, 1, 2;
                     2, 1, 2, 2, 2, 1, 2;
                     2, 1, 2, 2, 2, 1, 2;
                     2, 1, 1, 1, 1, 1, 2;
                     2, 2, 2, 2, 2, 2, 2];
    separator = [1, 1, 1, 1, 1, 1, 1, 1];
    %place the corner markers
    matrixOut(1:7,1:7) = cornerMarkers;
    matrixOut(1:8, 8) = separator;
    matrixOut(8, 1:8) = separator;
    matrixOut(15:21, 1:7) = cornerMarkers;
    matrixOut(14, 1:8) = separator;
    matrixOut(14:21, 8) = separator;
    matrixOut(1:7, 15:21) = cornerMarkers;
    matrixOut(1:8, 14) = separator;
    matrixOut(8, 14:21) = separator;
    %put the timing modules in
    matrixOut(9:13, 7) = [2, 1, 2, 1, 2];
    matrixOut(7, 9:13) = [2, 1, 2, 1, 2];
    %place the given
    matrixOut(14, 9) = 2;
    %place the reserve areas
    matrixOut(9, 1:6) = [3, 3, 3, 3, 3, 3];
    matrixOut(9, 8:9) = [3, 3];
    matrixOut(8, 9) = 3;
    matrixOut(1:6, 9) = [3, 3, 3, 3, 3, 3];
    matrixOut(9, 14:21) = [3, 3, 3, 3, 3, 3, 3, 3];
    matrixOut(15:21, 9) = [3, 3, 3, 3, 3, 3, 3];
    %current location in inputstream
    i = 1;
    %decrement columns
    k = 21;
    while k > 0
        %decrement rows
        for j = 1:21
            if matrixOut(22-j, k) == 0 && matrixOut(22-j, k-1) == 0
                matrixOut(22-j,k) = inputBitString(i);
                matrixOut(22-j,k - 1) = inputBitString(i + 1);
                i = i + 2;
            end

        end
        %adjust k
        if k == 9
            k = k - 1;
        end
        %increment rows
        for j = 1:21
            if matrixOut(j, k - 2) == 0 && matrixOut(j, k - 3) == 0
                matrixOut(j,k - 2) = inputBitString(i);
                matrixOut(j,k - 3) = inputBitString(i + 1);
                %walk down
                i = i + 2;
            end
        end
        k = k - 4;
    end
    %fix data to make it apply to standard 0 and 1 convention
    matrixOut = matrixOut - 1;
    matrixOut = mod(matrixOut, 2);
end
