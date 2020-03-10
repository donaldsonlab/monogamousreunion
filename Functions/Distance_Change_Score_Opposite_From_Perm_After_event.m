function [ Score,Cell_Score_Array,Time_Locations,P_val,Deviation_Score] = Distance_Change_Score_Opposite_From_Perm_After_event(perm, events,downsample,bin,str)
%Elliott Salsow - Donaldson Lab, University of Colorado Bouler
%Edited: 12/19/2019 - Ryan Cameron
%--------------------------------------------------------------------------
%For a specific cell, this will give back the DISTANCE score based on the
%Permutation. If the score is negative, that implies the animals got
%closer. If the score is postive, that implies the animals got further
%away. The scores are calculated from the median distance to the animal
%(Partner, Novel) from the OPPOSITE chamber (Novel, Partner).
%--------------------------------------------------------------------------
%Inputs:
%   perm = # of perm you want to run, (1000 seems to work pretty well without taking too long
%   events = column vector of cell activity. Should work with non logical
%transients But I generally make the cell activity logical before
%anything else
%   downsample = downsampled behavior data that allows us to pick the
%locations where the animals where interacting in certain ways
%   bin = size of bin we are using to see if the animals distance changed
%after the event.  For our analysis we are using a bin size of 5
%   str = either 'Novel', 'Partner', 'All', or 'Non'  Each refers to a
%different behavior that we are looking at.  Generally only use Novel
%or Partner.  The string allows us to pull out the data that is only in
%the correct chamber

%Outputs:
%   Cell_Score =  the score from the means of the difference
%   Cell_Score2 = the array of data of differences which Cell_Score is the
%mean of.
%   Time_Locations = the starting points for the events that we are looking
%at for the cell transients while in the Partner or Novel Chamber!
%   P_val = number of permutations where the random score was less that
%the real score
%   Deviation_Score =
%(Real_Score-mean(permutations))/(standardDev(permutations)

%-------------------------------------------------------------------------%
%This takes in (for a given event) the logical cell col vector, the
%downsample of behavior, bin size, and string identifing what we are
%working on.

% check to make sure that there is more than 100 frames of interaction
%if length(find(downsample(:,20) == 1)) > 100  && length(find(downsample(:,18) == 1)) > 100
    switch str
        case 'Novel'
            %only take the novel chamber data for the trace data and the beh
            %data, call them the same thing but add Small to the end so that
            %when we take the difference in movement, we dont create errors.
            idx = find(downsample(:,18) == 1); %In partner chamber
            downsampleSmall = downsample(idx,:);
            eventsSmall = events(idx,:);
        case 'Partner'
            %Same idea as above
            idx = find(downsample(:,20) == 1); %In novel chamber
            downsampleSmall = downsample(idx,:);
            eventsSmall = events(idx,:);
        case 'All'
            %use all of the data
            downsampleSmall = downsample(:,:);
            eventsSmall = events(:,:);
        case 'Non'
            idx = find(downsample(:,17) > 10 & downsample(:,16) > 10 );
            downsampleSmall = downsample(idx,:);
            eventsSmall = events(idx,:);
    end
    
    ind1 = find(eventsSmall > 0);%locate where the events occur
    ind1 = downsampleSmall(ind1,1);%Now find the time stamps for these
    for q = 1:length(ind1)
        index1(q) = find(downsample(:,1) == ind1(q));%find the index where these events occurred
        
        
    end
    %Notice how downsampleSmall is used here.
    [END,~] = size(downsample);
    %figure out where the cells fired & then find the time stamps in the
    %downsample
    
    if length(ind1) ~= 0 %check to make sure we have a situation where the cell did fire
        D0 = [];
        D1 = [];
        for q = 1:length(index1)
            index2 = index1(q) + bin; %add the bin size amount of time to the firing time
            if index2 < 1%END
                index2 = 1;%END;
            end
            if index2 > END
                index2 = END;
            end
            switch str
                case 'Novel'
                    D0 = [D0;downsample(index1(q),16)];%find distance 1, 16 is distance to novel
                    D1 = [D1;downsample(index2,16)];
                case 'Partner'
                    D0 = [D0;downsample(index1(q),17)]; %17 is distance to partner
                    D1 = [D1;downsample(index2,17)];
            end
        end
        
        %Now that we have gone through all the events that occurred for that
        %specific cell, we are going to make two cell score.  One that is the
        %mean, and one that is all the data.  Nice!
        
        %the median!:
        %Delete specific EVENTS that have NaN's
        ind_nan = find(isnan(D0) | isnan(D1));
        dist_diff = D1-D0;
        dist_diff(ind_nan) = [];
        Score = median(dist_diff);
        %and array:
        Cell_Score_Array = D1-D0;
        
        Time_Locations = index1;
    else
        Score = NaN;
        Cell_Score_Array = NaN;
        Time_Locations = NaN;
    end
    
    if (length(ind1) ~= 0) && (~isnan(Score))
        d = nan(perm,1);
        for i = 1:perm
            eventsSmall = eventsSmall(randperm(length(eventsSmall)));%randomize the events
            ind1 = find(eventsSmall > 0);%same process as before
            ind1 = downsampleSmall(ind1,1);
            for q = 1:length(ind1)
                index1(q) = find(downsample(:,1) == ind1(q));
            end
            index2 = index1 + bin; %After the event occurs
            %index2(find(index2 <1)) = 1;%index2 > length(events)
            index2(find(index2 > length(events))) = END;
            switch str
                case 'Novel'
                    D0 = downsample(index1,16);
                    D1 = downsample(index2,16);
                    %Delete specific EVENTS that have NaN's
                    ind_nan = find(isnan(D0) | isnan(D1));
                    dist_diff = D1-D0;
                    dist_diff(ind_nan) = [];
                    d(i) = median(dist_diff);
                case 'Partner'
                    D0 = downsample(index1,17);
                    D1 = downsample(index2,17);
                    %Delete specific EVENTS that have NaN's
                    ind_nan = find(isnan(D0) | isnan(D1));
                    dist_diff = D1-D0;
                    dist_diff(ind_nan) = [];
                    d(i) = median(dist_diff);
            end
        end
        %Check for remaining NaN's
        ind_nan = find(isnan(d));
        num_nan = length(ind_nan);
        d(ind_nan) = []; %Delete the rows where nan's exist
        
        Mu = mean(d,1);
        st = std(d,0,1);
        Deviation_Score = ((Score - Mu)./st)';
        P_val = ((length(find(d < Score)))/(perm-num_nan))*100;
    else
        Deviation_Score = NaN;
        P_val = NaN;
    end
% else
%     RATE = NaN;
%     P_val = NaN;
%     Score = NaN;
%     Cell_Score_Array = NaN;
%     Time_Locations = NaN;
%     Deviation_Score = NaN;
end
%end