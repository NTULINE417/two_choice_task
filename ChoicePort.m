classdef ChoicePort < AbstractPort
    %CHOICEPORT A port that collect mouse decision.
    
    methods        
        function obj = ChoicePort(device, name, pin_def)
            obj@AbstractPort(device, name, pin_def); 
        end
        
        function action(obj) %#ok<*MANU>
            % these ports are no-op
        end
    end
end

