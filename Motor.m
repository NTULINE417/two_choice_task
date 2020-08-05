classdef Motor < handle
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
        function obj = Motor(device, pin_def)
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
            configurePin(obj.device, obj.step_pin, 'Unset');
            obj.set_digital_output_state(obj.step_pin, 0);
        end
        
        function set_direction(obj, dir)
            if obj.is_moving
                error('motor is still moving');
            end
            
            if nargin > 1
                if strcmp(dir, 'forward')
                    obj.direction = 1;
                elseif strcmp(dir, 'reverse')
                    obj.direction = 0;
                else
                    error('direction should be ''forward'' or ''reverse''');
                end  
            end
            
            obj.set_digital_output_state(obj.dir_pin, obj.direction);
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
            
            obj.is_moving = true;
            obj.enable();
            
            dt2 = (1/freq) / 2; % half cycle
            for i = 1:n_step
                obj.set_digital_output_state(obj.step_pin, 1);
                pause(dt2);
                obj.set_digital_output_state(obj.step_pin, 0);
                pause(dt2);
            end
            
            obj.disable();
            obj.is_moving = false;
        end
        
        function move(obj, freq, duration)
            obj.set_direction();
            
            obj.is_moving = true;
            obj.enable();
            
            if nargin < 3
                error('unlimited move is not functioning properly yet');
                duration = 1; % move unlimited until stop
            end
            % duration is in seconds
            duration = duration / 1000;
            playTone(obj.device, obj.step_pin, freq, duration);
            pause(duration); % wait, arduino function is async
            
            obj.disable();
            obj.is_moving = false;
            
            % reset
            configurePin(obj.device, obj.step_pin, 'Unset');
        end
        
        function delete(obj)
            obj.disable();
        end
    end
    
    methods (Access = private)
        function enable(obj)
            obj.set_digital_output_state(obj.en_pin, 0);
        end
        
        function disable(obj)
            obj.set_digital_output_state(obj.en_pin, 1);
        end
        
        function set_digital_output_state(obj, pin, state)
            writeDigitalPin(obj.device, pin, state);
        end
    end
end

