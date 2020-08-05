clearvars; 

%% pin assignments
% l_port
left.visual = 'D7';
left.detector = 'A1';

% r_port
right.visual = 'D5';
right.detector = 'A4';

% initiation
init.visual = 'D4';
init.detector = 'A5';

% reward
reward.visual ='D6';
reward.detector = 'A3';

% dispenser
dispenser.dir = 'D8';
dispenser.step = 'D9';
dispenser.en = 'A0';

% lickometer
lickometer.dispenser = dispenser;
lickometer.detector = '';

%% summary
reward.lickometer = lickometer;

pin_defs.left = left;
pin_defs.right = right;
pin_defs.init = init;
pin_defs.reward = reward;

%% save it
save('pin_defs.mat', 'pin_defs');