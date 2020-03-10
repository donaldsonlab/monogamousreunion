%Ryan Cameron - University of Colorado, Donaldson Lab
%Created: 1/10/2020
%Edited:  1/10/2020
%--------------------------------------------------------------------------
%This function outputs the median distance change and the number of events
%for a given cell vector with the behavior data. This is both the before
%and after data.
%INPUTS:  cell events vector
%         behavior matrix
%OUTPUTS: number of events
%         before event median distance change
%         after event median distance change
%--------------------------------------------------------------------------

function [before_dist,after_dist,num_events] = median_distance_count(cell_vec,behavior)
event_index = find(cell_vec);
num_events = length(event_index);
event_loc = behavior(event_index,9:10);

%Correlate those indices with the behavior matrix
before_index = event_index - 5;
before_index(find(before_index < 1)) = 1;
before_loc = behavior(before_index,9:10); %x and y
before_dist = event_loc - before_loc;
before_dist = hypot(before_dist(:,1),before_dist(:,2));
before_dist(isnan(before_dist)) = [];
before_dist = median(before_dist);

after_index = event_index + 5;
after_index(find(after_index > length(cell_vec))) = length(cell_vec);
after_loc = behavior(after_index,9:10);
after_dist = after_loc - event_loc;
after_dist = hypot(after_dist(:,1),after_dist(:,2));
after_dist(isnan(after_dist)) = [];
after_dist = median(after_dist);
end