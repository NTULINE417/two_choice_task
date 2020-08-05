classdef Dispenser < Motor
    %DISPENSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = private)
        name 
        is_invert
        default_reward_ul 
    end
    
    properties (Access = private)
        freq 
        factor 
    end
    
    methods
        function obj = Dispenser(device, name, pin_def, freq, factor, volume)
            obj@Motor(device, pin_def);
            
            % set name for logging
            obj.name = name;
            
            if nargin < 6
                volume = 6;
            end
            obj.default_reward_ul = volume;
            
            if nargin < 4
                % default frequency and conversion factor
                % 20 ms, 100 Hz = 6 uL
                freq = 100;
                factor = 20/6;
            end
            obj.freq = freq;
            obj.factor = factor;
            
            obj.is_invert = false;
        end
        
        function dispense_ul(obj, ul)
            if nargin < 2
                ul = obj.default_reward_ul;
            end
            
            message = sprintf('dispense %d ul', ul);
            obj.log(message); 
            
            dt = obj.factor * ul;
            obj.move(obj.freq, dt);
        end
        
        function set_invert(obj, state)
            if obj.is_moving
                error('motor is still moving');
            end
            
            obj.is_invert = state;
            
            % apply new state
            if state
                obj.set_direction('reverse');
            else
                obj.set_direction('forward');
            end
        end
    end
    
    methods (Access = protected)
        function log(obj, message)
            message = join([obj.name, ' ', message]);
            logger(message);
        end
    end
end

