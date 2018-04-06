[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Add src
addpath(genpath(fullfile(cDirThis, '..', 'src')));

clear
clc

cHost = '192.168.10.35';

device = threegstore.RemotePowerSwitch(...
    'cHost', cHost ...
);

device.turnOn();