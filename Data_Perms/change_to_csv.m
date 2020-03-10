%Ryan Cameron
%Puts all .mat files in .csv files

clear all; close all; clc;

obj = dir('*.mat'); %Gets all .mat data files as tables

for i = 1:length(obj)
    name = obj(i).name;
    t = load(name);
    name(end-3:end) = [];
    tab = extractfield(t,name);
    tab = tab{1}; %Now we have the table, save it
    tab.Var4 = [];
    writetable(tab,strcat(name,'.csv'));
end