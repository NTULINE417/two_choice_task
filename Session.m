classdef Session
    %SESSION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = private)
        mouse_id
        prob
        n_trials
    end
    
    properties (Access = private)
        ports
        reward_ul
    end
    
    methods
        function obj = Session(ports, mid, prob, n, ul)
            obj.mouse_id = mid;
            
            obj.ports = ports;
            
            if numel(prob) == 1
                obj.prob = [prob, 1-prob];
            elseif numel(prob) == 2
                obj.prob = prob;
            else
                error('invalid probability argument');
            end
            
            obj.n_trials = n;
            
            if nargin < 5
                ul = 6;
            end
            obj.reward_ul = ul;
        end
        
        function run(obj)
            message = sprintf('start session, mouse ''%s''', obj.mouse_id);
            obj.log(message);
            
            gt = obj.generate_gt(); % TODO correct sequence?
            cs = cell(obj.n_trials, 1);
            for i = 1:obj.n_trials
                name = sprintf('TRIAL-%03d', i);
                trial = Trial(obj.ports, name, gt(:, i).', obj.reward_ul);
                c = trial.run();
                cs{i} = c;
            end
            
            % TODO save gt, cs
            % TODO export result
            
            message = sprintf('stop session, mouse ''%s''', obj.mouse_id);
            obj.log(message);
        end
    end
    
    methods (Access = private)
        function p = generate_gt(obj)
            %GENERATE_GT Generate ground truth in god perspective.
            
            % threshold for integer sequence
            t = round(obj.n_trials * (1-obj.prob.'));
            % generate lookup serial numbers
            p = [randperm(obj.n_trials); randperm(obj.n_trials)];
            
            % convert to actual ground truth
            p = p > t;
        end
        
        function log(obj, message)
            message = join(['SESSION', ' ', message]);
            logger(message);
        end
    end
end

