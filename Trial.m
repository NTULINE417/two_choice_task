classdef Trial
    %TRIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = private)
        trial_name
        gt
        reward_ul
    end
    
    properties (Access = private)
        init
        l_choice
        r_choice
        lickometer
    end
    
    methods
        function obj = Trial(ports, name, gt, ul)
            obj.trial_name = name;
            
            obj.init = ports.init;
            obj.l_choice = ports.l_choice;
            obj.r_choice = ports.r_choice;
            obj.lickometer = ports.lickometer;
            
            if numel(gt) ~= 2
                error('ground truth should contain two elements');
            end
            obj.gt = gt;
            
            if nargin < 3
                ul = 6;
            end
            obj.reward_ul = ul;
        end
        
        function choice = run(obj)
            obj.init.wait()

            % show cue
            obj.l_choice.show_cue()
            obj.r_choice.show_cue()
                
            l_state0 = obj.l_choice.get_detector_state();
            r_state0 = obj.r_choice.get_detector_state();
            while true
                l_state = obj.l_choice.get_detector_state();
                r_state = obj.r_choice.get_detector_state();
                
                % build toggle table
                result = [xor(l_state, l_state0), xor(r_state, r_state0)];
                disp(result);
                
                if all(result, 'all')
                    obj.log('head exists in both port, impossible');
                elseif ~any(result, 'all')
                    % nothing triggered, next iteration
                else
                    % something triggered
                    if result(1)
                        choice = 'left';
                    else
                        choice = 'right';
                    end
                    % stop iteration
                    break
                end
            end
            
            % stop cue
            obj.l_choice.stop_cue();
            obj.r_choice.stop_cue();
            
            % deploy
            obj.log(join([choice, 'triggered']));
            
            % determine whether the mouse get reward
            obj.log(join(['ground truth', num2str(obj.gt)]));
            result = any(result & obj.gt);
            if result
                obj.lickometer.give_reward();
            end
        end
    end
    
    methods (Access = private)
        function log(obj, message)
            message = join([obj.trial_name, ' ', message]);
            logger(message);
        end
    end
end

