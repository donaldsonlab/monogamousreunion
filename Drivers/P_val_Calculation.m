%This script creates a table of pvalues for all of the animals.
%We use a bin of 10 frames

%Houskeeping & move to the right folder:
clearvars
PWD = pwd;
cd ..
cd('Functions')
close all

%List of animals:
animals = [ 440   445   451   485   487   532   535   543   546   557  570   573   584   585   586   588   598   599];
%animals = 543;
%Define parms vector:
%parms(1) = binsize
%parms(2) = permutation Number
parms = [5 1000];

%Create some empty vectors that we will fill later on:
P = [];
N = [];

timeSec = 600; %seconds. This is 10 minutes
%Loop through all the animals:
for A = 1:length(animals)
    animals(A)
    %loop through all the epochs:
    for epoch = 1:3%
        %define Which animal we are working with:
        animal = animals(A);
        %load in the data:
        [cells,downsample] = fileloop(animal,epoch);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %UNCOMMENT THIS SECTION TO SPLIT INTO 10 MINUTE BINS
        index10 = [1:find(round(cells(:,1),2) == round(cells(1,1) + timeSec,2))]; %Indices of the first 10 minutes
        index20 = [index10(end)+1: size(cells,1)]; %Indices of the last 10 minutes
        cells = cells(index20,:);
        downsample = downsample(index20,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%get rid of the time stamps:
        cells = logical(cells(:,2:end));
        %find out the size of our cells 
        [h,w] = size(cells);
        
        %w is the number of cells that we have, so what were going to do is
        %take the data for each one in the loop and then do our calculate
        %the Pvalue
        for i = 1:w
            events = cells(:,i);%this is that data we will be using 
            cell_num = i;
            
            %the scoring method is slightly different for mate, partner,
            %Nonsocial, & all so we have to pass in the string to identify
            %what we are working on.
            [ Cell_Score,Cell_Score_Array,Time_Locations,P_val,Deviation_Score] = Distance_Change_Score_Opposite_From_Perm_After_event...
                (parms(2), events,downsample,parms(1),'Partner');
            P = [P; table(animal,epoch,cell_num,{Cell_Score_Array},Deviation_Score, P_val)];
            
            [ Cell_Score,Cell_Score_Array,Time_Locations,P_val,Deviation_Score] = Distance_Change_Score_Opposite_From_Perm_After_event...
                (parms(2), events,downsample,parms(1),'Novel');
            N = [N; table(animal,epoch,cell_num,{Cell_Score_Array},Deviation_Score, P_val)];   
        end
    end
end
cd(pwd)
return
