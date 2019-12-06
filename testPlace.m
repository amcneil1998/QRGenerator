function a=testPlace(matrix)
    matrix = mod(matrix-1, 2);
    colormap(gray)
    imagesc(mod(matrix+1, 2));