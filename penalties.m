%Emma Burgess 11-23-19
%This scores a matrix according to 4 penalty rules. 
%INPUTS: 21x21x8 matrix of 1s and 0s. (8 layers of the QR code, masked 8 
%different ways.
%OUTPUTS: 1x8 matrix of the scores. 

function score = penalties(matrix)
[height,width,~] = size(matrix);
score = zeros(1,8);

for n = 1:8
    % Rule 1
        % The first rule gives the QR code a penalty for each group of five or more same-colored modules in a row (or column).

    % Horizontal Penalties
    score_hz = 0;    
    for h = 1:height
        count = 1;
        for w = 1:width-1
            if (matrix(h,w,n) == matrix(h,w+1,n))
                count = count+1;
            else
                if (count >= 5)
                    score_hz = score_hz + count-2;
                end 
                count = 1;
            end 
        end
        if (count >= 5)
            score_hz = score_hz + count-2;
        end
    end

    % Vertical Penalties
    score_v = 0;
    for w = 1:width
        count = 1;
        for h = 1:height-1
            if (matrix(h,w,n) == matrix(h+1,w,n))
                count = count+1;
            else
                if (count >= 5)
                    score_v = score_v + count-2;
                end 
                count = 1;
            end 
        end
        if (count >= 5)
            score_v = score_v + count-2;
        end
    end

    score_1 = score_hz + score_v;


    % Rule 2
        % The second rule gives the QR code a penalty for each 2x2 area of same-colored modules in the matrix.
    score_2 = 0;    
    for h = 1:height-1
        for w = 1:width-1
            if (matrix(h,w,n) == matrix(h,w+1,n) && matrix(h,w,n) == matrix(h+1,w,n) && matrix(h,w,n) == matrix(h+1,w+1,n) )
                score_2 = score_2 + 3;
            end 
        end
    end

    % Rule 3
        % The third rule gives the QR code a large penalty if there are patterns that look similar to the finder patterns.
    score_3 = 0;
    % Horizontally
    pattern1 = [1 0 1 1 1 0 1 0 0 0 0];
    pattern2 = [0 0 0 0 1 0 1 1 1 0 1];
   
    for h = 1:height
        idx1h = strfind(matrix(h,:,n),pattern1);
        idx2h = strfind(matrix(h,:,n),pattern2);
        score_3 = score_3 + 40*nnz(idx1h) + 40*nnz(idx2h);
    end
    
    %Vertically
    matrix_t = matrix(:,:,n)';
    for w = 1:width
        idx1v = strfind(matrix_t(w,:),pattern1);
        idx2v = strfind(matrix_t(w,:),pattern2);
        score_3 = score_3 + 40*nnz(idx1v) + 40*nnz(idx2v);
    end


    % Rule 4
        % The fourth rule gives the QR code a penalty if more than half of the modules are dark or light, with a larger penalty for a larger difference.

    total = height*width;
    black = total - sum(sum(matrix(:,:,n)));
    percent_black = black/total*100;
    percent_down = 5*floor(percent_black/5);
    percent_up = percent_down + 5;
    down_num = abs(percent_down-50)/5;
    up_num = abs(percent_up-50)/5;
    score_4 = min(down_num,up_num)*10;

    score(n) = score_1 + score_2 + score_3 + score_4;
end
end