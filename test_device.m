clearvars; close all;

%% build pin assignments
load('pin_defs.mat');

%% define hardware setup
com_port = '/dev/tty.usbmodem14101';
device = arduino(com_port, 'Uno');

%% setup device
dispenser = Dispenser(device, 'DISPENSER', pin_defs.reward.lickometer.dispenser);
dispenser.set_invert(false);

%% start test
dispenser.dispense_ul(100);
