%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/10/2020
%Edited:  1/10/2020
%--------------------------------------------------------------------------
%This function outputs the MEAN angle value between before and after event
%vectors (<180 ALWAYS) for a cell and then also a p-value based on a
%permutation where the events are shuffled and the calculation is redone. 
%INPUTS:  cell events vector
%         behavior matrix
%OUTPUTS: angle
%         p-value
%--------------------------------------------------------------------------

function [theta,p_val,vector_data] = mean_angle_perm(cell_vec,behavior,perm)
event_index = find(cell_vec);
num_events = length(event_index);
event_loc = behavior(event_index,9:10);

%Correlate those indices with the behavior matrix
before_index = event_index - 5;
before_index(find(before_index < 1)) = 1;
before_loc = behavior(before_index,9:10); %x and y
before_vec = event_loc - before_loc;

after_index = event_index + 5;
after_index(find(after_index > length(after_index))) = length(after_index);
after_loc = behavior(after_index,9:10);
after_vec = after_loc - event_loc;

vector_data.event_loc = event_loc;
vector_data.before_vec = before_vec;
vector_data.after_vec = after_vec;
vector_data.event_index = event_index;
vector_data.after_index = after_index;
vector_data.before_index = before_index;

%Find the angle with the dot product
cos_theta = (dot(before_vec,after_vec,2))./(hypot(before_vec(:,1),before_vec(:,2)).*hypot(after_vec(:,1),after_vec(:,2)));
theta = acosd(cos_theta);
theta = round(theta,3);
theta(isnan(theta)) = [];
ind = find(theta > 180);
theta(ind) = 360 - theta(ind);
theta = mean(theta);

%Now run the permutation
perm = lower(perm);
if strcmp(perm,'yes')
    for perm = 1:1000
        cell_vec_perm = cell_vec(randperm(length(cell_vec))); %Shuffles the events
        event_index_perm = find(cell_vec_perm);
        event_loc_perm = behavior(event_index_perm,9:10);
        
        before_index_perm = event_index_perm - 5;
        before_index_perm(find(before_index_perm < 1)) = 1;
        before_loc_perm = behavior(before_index_perm,9:10);
        before_vec_perm = event_loc_perm - before_loc_perm;
        
        after_index_perm = event_index_perm + 5;
        after_index_perm(find(after_index_perm > length(after_index_perm))) = length(after_index_perm);
        after_loc_perm = behavior(after_index_perm,9:10);
        after_vec_perm = after_loc_perm - event_loc_perm;
        
        %Find the angle
        cos_theta_perm = (dot(before_vec_perm,after_vec_perm,2))./(hypot(before_vec_perm(:,1),before_vec_perm(:,2)).*hypot(after_vec_perm(:,1),after_vec_perm(:,2)));
        theta_perm = acosd(cos_theta_perm);
        theta_perm = round(theta_perm,3);
        theta_perm(isnan(theta_perm)) = [];
        ind = find(theta_perm > 180);
        theta_perm(ind) = 360 - theta_perm(ind);
        theta_new(perm) = mean(theta_perm);
    end
    %DON'T KNOW IF THIS IS CORRECT WAY TO FIND THE PVAL WE WANT
    p_val = length(find(theta_new < theta))/1000 * 100;
else
    p_val = NaN;
    fprintf('No Pcal computed\n');
end
end