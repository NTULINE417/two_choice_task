classdef MockMotor < Motor
    %MOCKMOTOR Mock object for Motor.
    
    methods
        function obj = MockMotor(name)
            arguments
                name (1,1) string = 'MOCKMOTOR'
            end
            
            pin_def.dir = 'DIR_PIN';
            pin_def.step = 'STEP_PIN';
            pin_def.en = 'EN_PIN';
            obj@Motor('', pin_def, 'Name', name);
        end
        
        function step(obj, n_step, freq)
            obj.set_direction();
            
            obj.enable();
            
            dt2 = (1/freq) / 2;
            message = sprintf('step=%d, half-cycle=%.4f', n_step, dt2);
            obj.log(message);
            
            obj.disable();
        end
        
        function move(obj, freq, duration)
            obj.set_direction(); 
            
            obj.enable();
            
            duration = duration / 1000;
            message = sprintf('freq=%dHz,duration=%ds', freq, duration);
            obj.log(message);
            
            obj.disable();
            
            obj.disable();
        end
    end
    
    methods (Access = protected)
        function set_digital_output_state(obj, pin, state) %#ok<INUSD>
            % no-op
        end
        
        function reset_step_pin(obj) %#ok<MANU>
            % no-op
        end
    end
end

