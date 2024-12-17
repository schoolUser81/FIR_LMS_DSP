%%==============================================================================================
%    UNIVERSITÉ DU QUÉBEC A TROIS-RIVIERES
%    Département de génie électrique et de génie informatique
%    COURS: GEI-1064 Conception en VLSI
%    Date: Automne 2023
%%=============================================================================================
clear all; close all; clc;

load('data_FIR_LMS.mat')
timetick=[0:1/20e6:1999/20e6]';
SineWave1=inp;
ref = timeseries(SineWave1,timetick);
SineWave2=yn;
input = timeseries(SineWave2,timetick);
ref.time=timetick;
% Wave1.signals.values=SineWave1;
% Wave1.signals.dimentions=[1];
input.time=timetick;
% Wave2.signals.values=SineWave2;
% Wave2.signals.dimentions=[1];