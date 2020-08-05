function logger(message, filename)
%LOGGER Log messages to a specified location.
%   Detailed explanation goes here

persistent fid;

if strcmp(message, 'open')
    if fid >= 0
        error('logger is already opened');
    end
    fid = fopen(filename, 'w');
elseif strcmp(message, 'close')
    if fid < 0
        error('logger is not opened');
    end
    fclose(fid);
    fid = -1; % reset fid variable
else
    if isempty(fid)
        error('logger is not opened yet');
    end
    
    timestamp = datetime('now', 'Format', 'yyyy-MM-dd''T''HH:mm:ss.SSS');
    timestamp = string(timestamp); % we need string to concat
    
    fprintf(fid, '%s %s\n', timestamp, message);
end


end

