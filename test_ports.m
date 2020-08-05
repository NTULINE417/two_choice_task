clearvars; close all;

%% build pin assignments
load('pin_defs.mat');

%% define hardware setup
com_port = '/dev/tty.usbmodem14101';
device = arduino(com_port, 'Uno');

L_port = ChoicePort(device, 'LEFT', pin_defs.left);
R_port = ChoicePort(device, 'RIGHT', pin_defs.right);
I_port = ChoicePort(device, 'INITIATION', pin_defs.init);

dispenser = Dispenser(device, 'DISPENSER', pin_defs.reward.lickometer.dispenser);
dispenser.set_invert(false);
M_port = RewardPort(device, 'REWARD', pin_defs.reward, dispenser);

ports.init = I_port;
ports.l_choice = L_port;
ports.r_choice = R_port;
ports.lickometer = M_port;

%% setup session
logger('open', 'session_1.txt');
s = Session(ports, 'patient0', [0.8, 0.2], 25);

%% kick start
s.run();
% s.report();

%% cleanup
logger('close');

%% stop
disp('program stopped');

