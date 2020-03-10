%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/10/2020
%Edited:  1/23/2020
%--------------------------------------------------------------------------
%This is just outputting the data for the median distance change by the
%animal in the 1 second before and after ALL events. This is not dependant
%on any chamber or approach data, simply the amount of distnace traveled by
%an animal around an event.
%--------------------------------------------------------------------------

clear all; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
%animals = 445;

cd ..
cd('Functions')
data_table = [];
for an = animals
    for ep = 1:3
        %First grab the data from the google drive using the fileloop
        %function
        [cells,behavior] = fileloop(an,ep);
        
        %Make the cells matrix only 0's and 1's
        %cells(:,1) = []; %Vector of times
        cells(find(cells > 0)) = 1; %Makes all events = 1
        num_cells = size(cells,2);
        %------------------------------------------------------------------
        %This section filters depending on partner, novel, or center
        %chamber
        %------------------------------------------------------------------
%         %PARTNER
%         index = find(behavior(:,18));
%         cells = cells(index,:);
%         
%         %Novel
%         index = find(behavior(:,20));
%         cells = cells(index,:);
%         
%         %Center
%         index = find(behavior(:,19));
%         cells = cells(index,:);
        %------------------------------------------------------------------
        for i = 1:num_cells
            cell_vec = cells(:,i);
            [before_dist,after_dist,num_events] = median_distance_count(cell_vec,behavior);
            [theta,p_val,~] = mean_angle_perm(cell_vec,behavior,'yes');
            data_table = [data_table;an,ep,i,theta,p_val,before_dist,after_dist,num_events];
        end
    end
end
angle_distance_table_all = array2table(data_table);
angle_distance_table_all.Properties.VariableNames = {'Animal','Epoch','Cell','Theta_deg','Theta_Pval','before_distance','after_distance','Number_events'};
cd ..
cd('Overlaps')
save('angle_distance_table_all.mat','angle_distance_table_all');
writetable(angle_distance_table_all,'angle_distance_table_all.xlsx');
            
            