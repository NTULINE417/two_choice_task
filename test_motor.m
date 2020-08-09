clearvars; close all;

%% logger open
logger('open', 'mock_log.txt');

%% run
error = [];
try
   d = MockDispenser('TEST_MOCK_DISPENSER');
    d.set_invert('reverse');
    d.dispense_ul(5);
catch error
end

%% logger close
logger('close');

%% rethrow error if exists
if ~isempty(error)
   rethrow(error);
end
