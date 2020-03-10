%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/9/2020
%Edited:  1/9/2020
%--------------------------------------------------------------------------
%This script find the amount of overlap between the Partner Approach cells
%in the partner chamber and the partner approach cells in the novel
%chamber.
%--------------------------------------------------------------------------

clear all; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];

cd .. %Navigates to parent folder
cd('Data_No_Check'); %Navigates to data folder

%Want to compare the values in relation to the partner animal  from both
%chambers so load in appropriate data
load('P_all_time')
load('P_opposite_all_time')

%Identify the approach cells in each, <10 p-val
P_app_ind = find(P_all_time.P_val < 10);
P_app = P_all_time(P_app_ind,:);

P_opp_app_ind = find(P_opposite_all_time.P_val < 10);
P_opp_app = P_opposite_all_time(P_opp_app_ind,:);

%Find how many overlap
%Get the vector of cell nums for each animal and epoch and compare to the
%vector of cell nums for the opposite and see which ones match.
overlap_mat = [];
for ep = 1:3
    num_overlap = 0;
    for an = animals
        index = find(P_app.animal == an & P_app.epoch == ep);
        P_small = P_app(index,:);
        
        index = find(P_opp_app.animal == an & P_opp_app.epoch == ep);
        P_opp_small = P_opp_app(index,:);
        
        cell_vec = P_small.cell_num;
        cell_vec_opp = P_opp_small.cell_num;
        
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
    num_p_app = length(find(P_app.epoch == ep));
    num_p_opp_app = length(find(P_opp_app.epoch == ep));
    p_val = overlap_perm(ep,P_all_time, P_opposite_all_time, animals, 10, num_overlap);
    overlap_mat = [overlap_mat;ep,num_p_app,num_p_opp_app,num_overlap,p_val];
end
P_approach_overlap = array2table(overlap_mat);
P_approach_overlap.Properties.VariableNames = {'Epoch','Num_P_approach','Num_P_opposite_approach','Num_overlap','P_val'};
cd ..
cd('Overlaps')
save('P_approach_overlap.mat','P_approach_overlap')
writetable(P_approach_overlap,'P_approach_overlap.xlsx')