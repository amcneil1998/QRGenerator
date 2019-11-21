

% This function performs all operations described in the data Analysis
% and data encoding Portions of the QR Code Tutorial on Thonky.com
% https://www.thonky.com/qr-code-tutorial/introduction
% This function takes two inputs. The first is the text that will
% eventualy becomee embeded in the QR code.
% The second describes the Error Correction Level.
% Note this function assumes a version 1, 21 X 21 Alphanumeric QR code
% The output of this function is a double array of bytes to be used in the
% Error Correction Coding portion of the QR Code Tutorial

function [stream] = encodeData(inputText,errIn)


% Determine the maximum allowable characters for the given Error
% Correction Level. As well as the number of data codewords.
switch errIn
    case "L"
        max_Char = 25;
        dataCodewordNum = 19;
    case "M"
        max_Char = 20;
        dataCodewordNum = 16;
    case "Q"
        max_Char = 16;
        dataCodewordNum = 13;
    case "H"
        max_Char = 10;
        dataCodewordNum = 9;
    otherwise
        ME = MException('MyComponent:noSuchVariable', ...
            strcat('The imputed error level is invalid please',...
            ' use one of the following: L, M, Q, H'));
        throw(ME)
end

% Test to see if the number of characters in the input is valid.
if length(inputText) > max_Char
    ME = MException('MyComponent:noSuchVariable', ...
        strcat('The Input "%s" of length %d, is too long. \n',...
        'The maximum allowable characters while using Error',...
        'Correction Level %s is %d.'),...
        inputText,length(inputText),errIn,max_Char);
    throw(ME)
end



% The following is the Table of valid Alphanumeric Values
% https://www.thonky.com/qr-code-tutorial/alphanumeric-table
Alphanumeric = ['0';
    '1';
    '2';
    '3';
    '4';
    '5';
    '6';
    '7';
    '8';
    '9';
    'A';
    'B';
    'C';
    'D';
    'E';
    'F';
    'G';
    'H';
    'I';
    'J';
    'K';
    'L';
    'M';
    'N';
    'O';
    'P';
    'Q';
    'R';
    'S';
    'T';
    'U';
    'V';
    'W';
    'X';
    'Y';
    'Z';
    ' ';
    '$';
    '%';
    '*';
    '+';
    '-';
    '.';
    '/';
    ':'];

% Match the inputed characters to the values in the Alphanumeric table.
data = -1*ones(1,length(inputText));
for i = 1:length(inputText)
    for j = 1:44
        if Alphanumeric (j,:) == inputText(i)
            data(i) = j-1;
            break;
        end
    end
    %Find invalid charecters.
    if data(i)== -1
        ME = MException('MyComponent:noSuchVariable', ...
            strcat('The inputted character "%s" is not a valid',...
            ' character for this code. \nPlease refer to the The',...
            ' Table of Alphanumeric Values found in the ',...
            ' "QR Code Tutorial", on Thonky.com\n',...
            'https://www.thonky.com/qr-code-',...
            'tutorial/alphanumeric-table'), inputText(i));
        throw(ME)
    end
end


% Formate each pair of inputed character into bits using the
% Alphanumeric Mode Encoding algorithm found at the following web page.
% https://www.thonky.com/qr-code-tutorial/alphanumeric-mode-encoding
encodedData = zeros(1,11*floor((length(data)+1)/2));
for i = 1:2:length(data)
    first = data(i);
    if i + 1 > length(data)
        temp = fliplr(de2bi(first));
        if length(temp) ~= 6
            block = [zeros(1,6-length(temp)) temp];
        else
            block = temp;
        end
    else
        second = data(i+1);
        temp = fliplr(de2bi(first*45+second));
        if length(temp) ~= 11
            block = [zeros(1,11-length(temp)) temp];
        else
            block = temp;
        end
    end
    if i == 1
        encodedData = [block,...
            encodedData(11*(i+1)/2+1:length(encodedData))];
    else
        if 11*(i-1)/2 + 11 == length(encodedData)
            encodedData = [encodedData(1:11*(i-1)/2), block];
        else
            encodedData = [encodedData(1:11*(i-1)/2), block,...
                encodedData(11*(i+1)/2+1:length(encodedData))];
        end
    end
end


% Find the number of inputed characters in 9 bit binary form
charCount = fliplr(de2bi(length(inputText)));
if length(charCount) ~= 9
    charCount = [zeros(1,9-length(charCount)) charCount];
end

% Combine the Mode Indicator, Character Count Indicator, Encoded Data.
output = [0,0,1,0, charCount encodedData];

% Add up to four terminator zeros at the end.
for i = 1:4
    if length(output) < dataCodewordNum*8
        output = [output 0];
    end
end

% Add More 0s to Make the Length a Multiple of 8
if mod(length(output),8) ~= 0
    output = [output zeros(1,8 - mod(length(output),8))];
end

% Add Pad Bytes if the String is Still too Short
while length(output) < dataCodewordNum*8
    output = [output [1 1 1 0 1 1 0 0]];
    if length(output) < dataCodewordNum*8
        output = [output [0 0 0 1 0 0 0 1]];
    end
end

% Separate the bytes.
% stream = strings(1,dataCodewordNum);
stream = -1*ones(dataCodewordNum,8);
for i = 1:dataCodewordNum
    stream(i,:) = output(8*(i-1)+1:8*(i));
end

end
