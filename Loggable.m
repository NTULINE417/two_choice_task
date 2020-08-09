classdef Loggable < handle
    %LOGGABLE Objects that need to log information.
    
    properties (GetAccess = public, SetAccess = private)
        identifier
    end
    
    methods
        function obj = Loggable(identifier)
            obj.identifier = identifier;
        end
    end
    
    methods (Access = protected)    
        function log(obj, fmt, varargin)
            %LOG The actual logging function.
            %   This function emulate fprintf interface.
            
            % generate message
            message = sprintf(fmt, varargin{:});
            % attach identifier
            message = join([obj.identifier, message], ' ');
            
            logger(message);
        end
    end
end

