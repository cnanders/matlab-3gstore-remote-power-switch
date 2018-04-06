[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Add src
addpath(genpath(fullfile(cDirThis, '..', 'src')));

clear
clc

cHost = '192.168.10.30';

device = threegstore.RemotePowerSwitch(...
    'cHost', cHost ...
);

device.turnOn(1)
device.isOn(1)
device.turnOff(1)
device.isOn(1)
device.turnOn(2)
device.isOn(2)
device.turnOff(2)
device.isOn(2)