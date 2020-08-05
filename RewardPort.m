classdef RewardPort < AbstractPort
    %REWARDPORT A port that will dispense reward when allowed.
    
    properties (Access = private)
        dispenser
    end
    
    methods
        function obj = RewardPort(device, name, pin_def, dispenser)
            obj@AbstractPort(device, name, pin_def); 
            obj.dispenser = dispenser;
        end
        
        function action(obj)
            % trigger motor
        end
        
        function give_reward(obj)
            obj.log('dispense reward');
            obj.dispenser.dispense_ul();
        end
    end
end

