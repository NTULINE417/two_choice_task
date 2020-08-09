classdef Dispenser < Motor
    %DISPENSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = private) 
        is_invert
        default_reward_ul 
    end
    
    properties (Access = private)
        freq 
        factor 
    end
    
    methods
        function obj = Dispenser(device, name, pin_def, options)
            arguments
                device
                name
                pin_def
                options.Frequency (1,1) double = 100
                options.Factor (1,1) double = 20/6
                options.DefaultVolume (1,1) double = 6
            end
            
            obj@Motor(device, pin_def, 'Name', name);
            
            % default dispensed reward, 6 uL
            obj.default_reward_ul = options.DefaultVolume;

            % default frequency and conversion factor
            % calculated from: 
            %   20 ms, 100 Hz = 6 uL
            obj.freq = options.Frequency;
            obj.factor = options.Factor;
            
            obj.is_invert = false;
        end
        
        function dispense_ul(obj, ul)
            arguments
                obj
                ul (1,1) double = obj.default_reward_ul
            end
            
            message = sprintf('start dispense %d ul', ul);
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
end

