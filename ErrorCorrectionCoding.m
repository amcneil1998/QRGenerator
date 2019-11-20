

% This function performs all operations described in the Error Correction 
% Coding Portion of the QR Code Tutorial on Thonky.com
% https://www.thonky.com/qr-code-tutorial/introduction
% This function takes one input. The input is the 2D double array of bytes
% containg the encoded data that is the output of the function encodeData.
% Note this function assumes a version 1, 21 X 21 Alphanumeric QR code
% The output of this function is a 1 X 208 chareter array of bits to be 
% used in the module placement portion of the QR Code Tutorial.


% Error Correction Coding
function [streamOut] = ErrorCorrectionCoding(streamIn)


% Obtain the needed number of parity check symbols 
% Use that number as the switch argument to get the generator polynomial 
switch (26 - length(streamIn)+1)
    case 7
        gen = [21 102 238 149 146 229 87 0];
        % x^7*?^(0)   + x^6*?^(87)  + x^5*?^(229) + x^4?^(146) +
        % x^3*?^(149) + x^2*?^(238) + x^1*?^(102) + x^0*?^(21)
    case 10
        gen = [45 32 94 64 70 118 61 46 67 251 0] ;
        % x^(10)*?^(0) + x^9*?^(251) + x^8*?^(67)  +
        % x^7*?^(46)   + x^6*?^(61)  + x^5*?^(118) + x^4?^(70) +
        % x^3*?^(64)   + x^2*?^(94)  + x^1*?^(32)  + x^0*?^(45)
    case 13
        gen = [78 140 206 218 130 104 106 100 86 100 176 152 74 0];
        % x^(13)*?^(0) + x^(12)*?^(74) + x^(11)*?^(152) + x^(10)*?^(176) +
        % x^9*?^(100)  + x^8*?^(86)    + x^7*?^(100)    + x^6*?^(106)    +
        % x^5*?^(104)  + x^4?^(130)    + x^3*?^(218)    + x^2*?^(206)    +
        % x^1*?^(140)  + x^0*?^(78)
    case 17
        gen = [136 163 243 39 150 99 24 147 214,...
            206 123 239 43 78 206 139 43 0];
        % x^(17)*?^(0)  + x^(16)*?^(43) + x^(15)*?^(139) + x^(14)*?^(206) +
        % x^(13)*?^(78) + x^(12)*?^(43) + x^(11)*?^(239) + x^(10)*?^(123) +
        % x^9*?^(206)   + x^8*?^(214)   + x^7*?^(147)    + x^6*?^(24)     +
        % x^5*?^(99)    + x^4?^(150)    + x^3*?^(39)     + x^2*?^(243)    +
        % x^1*?^(163)   + x^0*?^(136)
    otherwise
        ME = MException('MyComponent:noSuchVariable', ...
            strcat('The dimensions of the input is inconsistent with',... 
            ' the asssumptions made in the function header. \nPlease ',...
            ' use the 2D double array output of the function encodeData'));
        throw(ME)
end

% Create the symbols in GF(2^8)  
tp = gftuple([-1; (0:254)'], 8);

% Find the correct symbols in our field from the input 
Message = zeros(1,length(streamIn));
for i = 1:length(streamIn)
    index = ismember(tp,fliplr(streamIn(length(streamIn)-i+1,:)),'rows');
    spot = find(index)-2;
    if spot == -1
        spot = -Inf;
    end
    Message(i)= spot;
end

%Make room for the parity check bits.
Message = [ -Inf * ones(1, 26 - length(Message)) Message];

% Aquire the parity check bits by dividing the message by the generator.
[~,r] = gfdeconv(Message,gen,tp);

% Insert the parity check bits into the message.
Message(1:length(r)) = r(:);

% Find the binary value that match the coefficient symbols.
Message2 = -1*ones(length(Message),8);
for i = 1:length(Message)
    spot = Message(length(Message)-i+1);
    if spot == -Inf
        spot = 1;
    else
        spot = spot + 2;
    end
    Message2(i,:)= fliplr(tp(spot,:));
    % Message3 lets you see the values in decimal like the example.
    % Message3(i) = bi2de(Message2(i,:),'left-msb');
end

% Final Formatting.
streamOut = -1*ones(1,8*26);
streamOut(:) = Message2(:,:)';
streamOut = num2str(streamOut(:,:)) ;
streamOut= streamOut(~isspace(streamOut));

end



