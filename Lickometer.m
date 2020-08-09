classdef Lickometer < AbstractPort
    %LICKOMETER 
    
    properties (Access = private)
        dispenser
    end
    
    methods
        function obj = Lickometer(device, name, pin_def, dispenser)
            % lickometer does not have visual pin
            pin_def.visual = '';
            
            obj@AbstractPort(device, name, pin_def); 
            obj.dispenser = dispenser;
        end
        
        function action(obj)
        end
        
        function give_reward(obj)
            obj.log('dispense reward');
            obj.dispenser.dispense_ul();
        end
    end
    
    methods (Access = protected)
        function set_cue_state(obj, state) %#ok<INUSD>
        end
    end
end

