%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/9/2020
%Edited:  1/9/2020
%--------------------------------------------------------------------------
%This script find the amount of overlap between the Novel Approach cells
%in the partner chamber and the novel approach cells in the novel
%chamber.
%--------------------------------------------------------------------------
clear all; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];

cd .. %Navigates to parent folder
cd('Data_No_Check'); %Navigates to data folder

%Want to compare the values in relation to the partner animal  from both
%chambers so load in appropriate data
load('N_all_time')
load('N_opposite_all_time')

%Identify the approach cells in each, <10 p-val
N_app_ind = find(N_all_time.P_val < 10);
N_app = N_all_time(N_app_ind,:);

N_opp_app_ind = find(N_opposite_all_time.P_val < 10);
N_opp_app = N_opposite_all_time(N_opp_app_ind,:);

%Find how many overlap
%Get the vector of cell nums for each animal and epoch and compare to the
%vector of cell nums for the opposite and see which ones match.
overlap_mat = [];
for ep = 1:3
    num_overlap = 0;
    for an = animals
        index = find(N_app.animal == an & N_app.epoch == ep);
        N_small = N_app(index,:);
        
        index = find(N_opp_app.animal == an & N_opp_app.epoch == ep);
        N_opp_small = N_opp_app(index,:);
        
        cell_vec = N_small.cell_num;
        cell_vec_opp = N_opp_small.cell_num;
        
        ind_overlap = [];
        for i = 1:length(cell_vec)
            cell = cell_vec(i);
            ind = find(cell_vec_opp == cell);
            ind_overlap = [ind_overlap;ind];
        end
        num_overlap = num_overlap + length(ind_overlap);
    end
    cd ..
    cd('Functions')
    num_n_app = length(find(N_app.epoch == ep));
    num_n_opp_app = length(find(N_opp_app.epoch == ep));
    p_val = overlap_perm(ep,N_all_time, N_opposite_all_time, animals, 10, num_overlap);
    overlap_mat = [overlap_mat;ep,num_n_app,num_n_opp_app,num_overlap,p_val];
end
N_approach_overlap = array2table(overlap_mat);
N_approach_overlap.Properties.VariableNames = {'Epoch','Num_N_approach','Num_N_opposite_approach','Num_overlap','P_val'};
cd ..
cd('Overlaps')
save('N_approach_overlap.mat','N_approach_overlap')
writetable(N_approach_overlap,'N_approach_overlap.xlsx')