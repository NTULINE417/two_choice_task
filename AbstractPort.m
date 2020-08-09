classdef AbstractPort < Loggable
    %ABSTRACTPORT A port mounts on the chamber wall.
    
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
            %SHOW_CUE Show visual cue.
            %   This will enable the LED on the port.
            
            obj.set_cue_state(1);
            obj.log('show cue');
        end
        
        function stop_cue(obj)
            %STOP_CUE Disable visual cue.
            %   This will disable the LED on the port.
            
            obj.set_cue_state(0);
            obj.log('stop cue');
        end
        
        function wait(obj)
            %WAIT Wait for mice to trigger this port.
            %   This will first get current detector state, and later wait
            %   until the state is different. Visual cue is controlled
            %   automatically.
            %
            %   After the state toggle event occured, this method will call
            %   the action method.
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

