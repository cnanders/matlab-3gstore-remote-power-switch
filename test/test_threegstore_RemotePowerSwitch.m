[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Add src
addpath(genpath(fullfile(cDirThis, '..', 'src')));

clear
clc

cHost = '192.168.20.30';

device = threegstore.RemotePowerSwitch(...
    'cHost', cHost ...
);

tic
device.isOn(1)
toc

tic
device.isOn(2)
toc

tic
device.isOn(1)
toc

%{
device.turnOn(1)
device.isOn(1)
device.turnOff(1)
device.isOn(1)
device.turnOn(2)
device.isOn(2)
device.turnOff(2)
device.isOn(2)
%}