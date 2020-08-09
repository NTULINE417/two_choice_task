classdef Motor < Loggable
    %MOTOR A class that represent a A4988 controlled servo motor.
    properties (GetAccess = public, SetAccess = private)
        device
        dir_pin
        step_pin
        en_pin
        
        is_moving
    end
    
    properties (Access = private)
        direction
    end
    
    methods
        function obj = Motor(device, pin_def, options)
            arguments
                device 
                pin_def
                options.Name (1,1) string = 'MOTOR'
            end
    
            obj@Loggable(options.Name);
            
            obj.device = device;
            obj.dir_pin = pin_def.dir;
            obj.step_pin = pin_def.step;
            obj.en_pin = pin_def.en;
            
            obj.is_moving = false;
            obj.direction = 0;
            
            % disable it at the beginning
            obj.disable();
            
            % ensure motor is not stepped through during startup
            obj.set_digital_output_state(obj.dir_pin, 0);
            obj.reset_step_pin();
            obj.set_digital_output_state(obj.step_pin, 0);
        end
       
        function set_direction(obj, dir)
            %SET_DIRECTION Set motor direction.
            %   Set motor direction pin state.
            
            arguments
                obj
                dir (1,1) string {mustBeMember(dir, {'forward', 'reverse'})}
            end
            
            if obj.is_moving
                error('motor is still moving');
            end
            
            obj.set_digital_output_state(obj.dir_pin, obj.direction);
            obj.log('set direction to ''%s''', dir);
        end
        
        function dir = get_direction(obj)
            if obj.direction == 1
                dir = 'forward';
            else
                dir = 'reverse';
            end
        end
            
        function step(obj, n_step, freq)
            obj.set_direction();
            
            obj.enable();
            
            dt2 = (1/freq) / 2; % half cycle
            for i = 1:n_step
                obj.set_digital_output_state(obj.step_pin, 1);
                pause(dt2);
                obj.set_digital_output_state(obj.step_pin, 0);
                pause(dt2);
            end
            
            obj.disable();
        end
        
        function move(obj, freq, duration)
            obj.enable();
            
            if nargin < 3
                error('unlimited move is not functioning properly yet');
            end
            % duration is in seconds
            duration = duration / 1000;
            playTone(obj.device, obj.step_pin, freq, duration);
            pause(duration); % wait, arduino function is async
            
            obj.disable();
            
            % reset
            obj.reset_step_pin();
        end
        
        function delete(obj)
            obj.disable();
        end
    end
    
    methods (Access = protected)
        function enable(obj)
            obj.is_moving = true;
            
            obj.set_digital_output_state(obj.en_pin, 0);
            obj.log('motor enabled');
        end
        
        function disable(obj)
            obj.set_digital_output_state(obj.en_pin, 1);
            obj.log('motor disabled');
            
            obj.is_moving = false;
        end
        
        function set_digital_output_state(obj, pin, state)
            writeDigitalPin(obj.device, pin, state);
        end
        
        function reset_step_pin(obj)
            %RESET_STEP_PIN Reset step pin to unset state.
            %   We need this function to ensure step pin is not fixated to
            %   PWM mode.
            configurePin(obj.device, obj.step_pin, 'Unset');
        end
    end
end

