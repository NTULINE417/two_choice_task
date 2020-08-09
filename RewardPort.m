classdef RewardPort < AbstractPort
    %REWARDPORT A port that will dispense reward when allowed.
    
    properties (Access = private)
    end
    
    methods
        function obj = RewardPort(device, name, pin_def)
            obj@AbstractPort(device, name, pin_def); 
        end
        
        function action(obj)
            % no-op
        end
    end
end

