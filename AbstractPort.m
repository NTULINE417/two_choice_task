classdef AbstractPort < Loggable
    %ABSTRACTPORT A port mounts on the chamber wall.
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = private)
        port_name
        device
        visual_cue_pin
        detector_pin
    end
    
    methods
        function obj = AbstractPort(device, name, pin_def)
            obj@Loggable(name) % we use port name as log identifier
            
            obj.device = device;
            
            obj.port_name = name;
            obj.visual_cue_pin = pin_def.visual;
            obj.detector_pin = pin_def.detector;
        end
        
        function show_cue(obj)
            obj.set_cue_state(1);
            obj.log('show cue');
        end
        
        function stop_cue(obj)
            obj.set_cue_state(0);
            obj.log('stop cue');
        end
        
        function wait(obj)
            %WAIT Wait for mice to trigger this port.
            state0 = obj.get_detector_state();
            
            obj.show_cue();
            while true
                state = obj.get_detector_state();
                if xor(state, state0)
                    obj.log('toggled');
                    break
                end
            end
            obj.stop_cue();
            
            obj.action();
        end
        
        function state = get_detector_state(obj)
            state = readDigitalPin(obj.device, obj.detector_pin);
            state = logical(state);
        end
    end
    
    methods (Abstract)
        action(obj)
    end
    
    methods (Access = protected)
        function set_cue_state(obj, state)
            writeDigitalPin(obj.device, obj.visual_cue_pin, state);
        end
    end
end

