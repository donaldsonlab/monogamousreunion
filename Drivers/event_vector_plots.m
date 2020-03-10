%Ryan Cameron - University of Colorado, Boulder
%Donaldson Lab
%Created: 1/23/2020
%Edited:  1/23/2020
%--------------------------------------------------------------------------
%This script plots all cells that had more than 3 events but less than 15
%events in a way such that teh vector begins at the point in time when the
%event occured and then shows the amount the animal traveled in the 1
%second after the cell event occured.
%--------------------------------------------------------------------------

clearvars; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
cd ..
addpath('Functions')
cd Overlaps
load('angle_distance_table_all.mat')

cd ..
cd Data_No_Check

animal_type = 'Neither';
partnerColor = [255 20 147]/255; %'b'
novelColor = 'b';
chamber_type = ''; %OR 'opposite'
if string(animal_type) == "Neither"
    data_tab = loadtable('Partner','');
    data_tab_opp = loadtable('Partner','opposite');
else
    data_tab = loadtable(animal_type,'');
    data_tab_opp = loadtable(animal_type,'opposite');
end
% data_tab = loadtable(animal_type,'');
% data_tab_opp = loadtable(animal_type,'opposite');
cd ..
cd('Vector Plots')
cd(animal_type)

for an = animals
    vole_num = sprintf('Vole %d',an);
    if ~exist(vole_num,'dir')
        mkdir(vole_num)
    end
    cd(vole_num)
    for ep = 1:3
        %Pull the event and behavior data
        [events, behavior] = fileloop(an,ep);
        times = events(:,1);
        events(:,1) = [];
        tethered_trace_partner = behavior(:,[3,4]);
        tethered_trace_novel = behavior(:,[6,7]);
%         %Identify partner events
%         index = find(behavior(:,18) == 1);
%         events_use = events(index,:);
%         behavior_use = behavior(index,:);
%         events_use(find(events_use > 0)) = 1;
        %Identify novel events
        index = find(behavior(:,20) == 1);
        events_use = events(index,:);
        behavior_use = behavior(index,:);
        events_use(find(events_use > 0)) = 1;
        %Identify unregistered events
        index = find(behavior(:,19) == 1 | behavior(:,18) == 1);
        events_c = events(index,:);
        behavior_c = behavior(index,:);
        events_c(find(events_c > 1)) = 1;
        
        epoch = sprintf('Epoch %d',ep);
        
        %Reduce the size of the angle table to the right animal and epoch
        small_index = find(angle_distance_table_all.Animal == an & angle_distance_table_all.Epoch == ep);
        data_index = find(data_tab.animal == an & data_tab.epoch == ep);
        data_opp_index = find(data_tab_opp.animal == an & data_tab_opp.epoch == ep);
        
        small_table = angle_distance_table_all(small_index,:);
        small_data = data_tab(data_index,:);
        small_data_opp = data_tab_opp(data_opp_index,:);
        
        if (size(small_table,1)~=size(small_data,1) && size(small_table,1)~=size(small_data_opp,1))
            fprintf('Data Table Not the Same Size')
            pause
        end
        
        %Only plot cells with greater than 5 events and less than 15
        small_index = find(small_table.Number_events >=5);% & small_table.Number_events <= 15);
        small_table = small_table(small_index,:);
        small_data = small_data(small_index,:);
        small_data_opp = small_data_opp(small_index,:);
        if ~exist(epoch,'dir')
            mkdir(epoch)
        end
        cd(epoch)
        for direction_type = "neither"%["approach","departure"]
            switch direction_type
                case 'approach'
                    small_index = find(small_data.P_val <= 10);
                    %Plot table is narrowed down by animal, epoch, number
                    %of events, partner chamber, and now Pvalue.
                    plot_table = small_table(small_index,:);
                    
                    small_index_opp = find(small_data_opp.P_val <= 10);
                    plot_table_opp = small_table(small_index_opp,:);
                    
                    cells = plot_table.Cell;
                    if ~isempty(cells)
                        for j = cells'
                            fig = figure('Visible','off');
                            title('Approach')
                            %xlim([400 700])
                            xticks([])
                            xticklabels({})
                            yticks([])
                            yticklabels({})
                            hold on
                            grid on
                            scatter(tethered_trace_partner(:,1),tethered_trace_partner(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',partnerColor,'MarkerEdgeColor',partnerColor);
                            scatter(tethered_trace_novel(:,1),tethered_trace_novel(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',novelColor,'MarkerEdgeColor',novelColor);
                            %fig = heatscatter(fig,tethered_trace(:,1),tethered_trace(:,2),[],[],'.',[],0,[],[],[]);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_c,behavior_c,j,[.5 0.5 0.5],1.0);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_use,behavior_use,j,'k',2.0); %[255 127 0]/255
                            %fig = concentrations(fig,tethered_trace(:,1),tethered_trace(:,2));
                            %fig.Visible = 'on';
                            saveas(fig,sprintf('Cell_%d_Approach',j));
                            saveas(fig,sprintf('Cell_%d_Approach.png',j));
                            close(fig)
                        end
                    end
                case 'departure'
                    small_index = find(small_data.P_val >= 90);
                    plot_table = small_table(small_index,:);
                    
                    small_index_opp = find(small_data_opp.P_val >= 90);
                    plot_table_opp = small_table(small_index_opp,:);
                    cells = plot_table.Cell;
                    if ~isempty(cells)
                        for j = cells'
                            fig = figure('Visible','off');
                            title('Departure')
                            xticks([])
                            xticklabels({})
                            yticks([])
                            yticklabels({})
                            hold on
                            grid on
                            scatter(tethered_trace_partner(:,1),tethered_trace_partner(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',partnerColor,'MarkerEdgeColor',partnerColor);
                            scatter(tethered_trace_novel(:,1),tethered_trace_novel(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',novelColor,'MarkerEdgeColor',novelColor);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_c,behavior_c,j,[.5 0.5 0.5],1.0);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_use,behavior_use,j,'k',2.0);%'g'
                            %fig = concentrations(fig,tethered_trace(:,1),tethered_trace(:,2));
                            saveas(fig,sprintf('Cell_%d_Departure',j));
                            saveas(fig,sprintf('Cell_%d_Departure.png',j));
                            close(fig)
                        end
                    end
                otherwise
                    warning('No direction specified')
                    small_index = find(small_data.P_val < 90 & small_data.P_val > 10);
                    plot_table = small_table(small_index,:);
                    
                    small_index_opp = find(small_data.P_val < 90 & small_data.P_val > 10);
                    plot_table_opp = small_table(small_index_opp,:);
                    cells = plot_table.Cell;
                    if ~isempty(cells)
                        for j = cells'
                            fig = figure('Visible','off');
                            title('Neutral')
                            xticks([])
                            xticklabels({})
                            yticks([])
                            yticklabels({})
                            hold on
                            grid on
                            scatter(tethered_trace_partner(:,1),tethered_trace_partner(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',partnerColor,'MarkerEdgeColor',partnerColor);
                            scatter(tethered_trace_novel(:,1),tethered_trace_novel(:,2),2000,'.','MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1,...
                                'MarkerFaceColor',novelColor,'MarkerEdgeColor',novelColor);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_use,behavior_use,j,[0.5 0.5 0.5],1.0);
                            fig = plotVecs(fig,plot_table,plot_table_opp,events_c,behavior_c,j,[0.5 0.5 0.5],1.0);
                            %plot(tethered_trace(:,1),tethered_trace(:,2),'b')
                            saveas(fig,sprintf('Cell_%d_Neutral',j));
                            close(fig)
                        end
                    end
            end
        end
        %save(sprintf('tethered_trace_%d_%d.mat',an,ep),'tethered_trace');
        cd ..
    end
    cd ..
end

function [data_tab]= loadtable(animal_type, chamber_type)
if isempty(chamber_type)
    file = strcat(animal_type(1),'_all_time');
else
    file = strcat(animal_type(1),'_',chamber_type,'_all_time');
end
filename = strcat(file,'.mat');
data_struct = load(filename);
data_cell = extractfield(data_struct,file);
data_tab = data_cell{1};
data_tab.Var4 = [];
end

function [fig] = plotVecs(fig,plot_table,plot_table_opp,events,behavior,cell_val,color,lw)
%figure(fig)
%set(fig,'Visible','off')
cell_vec = events(:,cell_val); %Right now events is only specific to the partner or novel chamber, animal and epoch,
[~,~,vector_data] = mean_angle_perm(cell_vec,behavior,'no'); %Specific to partner chamber
%vector_data.after_vec = vector_data.after_vec./norm(vector_data.after_vec);
event_index = vector_data.event_index;
dist = behavior(event_index,17); %Partner
after_index = vector_data.after_index;
after_dist = behavior(after_index,17);
delta_dist = after_dist - dist;
index_app = find(delta_dist < 0);
index_dep = find(delta_dist > 0);

% u = vector_data.after_vec(index_app,1);
% v = vector_data.after_vec(index_app,2);
% x = vector_data.event_loc(index_app,1);
% y = vector_data.event_loc(index_app,2);
% quiver(x,y,u,v,'Color',color)
% 
% u = vector_data.after_vec(index_dep,1);
% v = vector_data.after_vec(index_dep,2);
% x = vector_data.event_loc(index_dep,1);
% y = vector_data.event_loc(index_dep,2);
% quiver(x,y,u,v,'Color',color)

u = vector_data.after_vec(:,1);
v = vector_data.after_vec(:,2);
x = vector_data.event_loc(:,1);
y = vector_data.event_loc(:,2);
quiver(x,y,u,v,'Color',color,'LineWidth',lw)
end

function fig = concentrations(fig,x_pos,y_pos)
cmap = colormap(hot);
index = find(cmap(:,1) == 1 & cmap(:,2) == 1 & cmap(:,3) == 0);
cmap(index:end,:) = [];
index = find(cmap(:,1) == 1 & cmap(:,2) == 0 & cmap(:,3) == 0);
cmap(1:index,:) = [];

%Find the concentration of positions
bins = [20 20];
[N,centers] = hist3([x_pos,y_pos],'Nbins',bins);
%[edgeMat,~] = edgeFind(N);
ypad = zeros(size(N,2),round(size(N,1)/4));
xpad = zeros(round(size(N,1)/4),size(N,2)+2*size(ypad,2));
N = [ypad,N,ypad];
N = [xpad;N;xpad];
no_conc = find(N == 0);

%Assign the concentrations in N 
max_norm = max(max(N));
norm_mat = N./max_norm;
norm_mat = 1 - norm_mat;
ind_mat = ceil(norm_mat.*(length(cmap)));
ind_mat(find(ind_mat == 0)) = 1;
ind_mat(no_conc) = 0;

image = zeros([size(N), 3]); %Create a 3 layer rgb matrix
%Now assign values for each pixel in the image
index = find(ind_mat == 0);
%Assign the no data values to white
layer = zeros(size(N,1));
layer(index) = 1;
image(:,:,1) = layer;
image(:,:,2) = layer;
image(:,:,3) = layer;

[indx,indy] = find(ind_mat);
for i = 1:length(indx)
    x = indx(i);
    y = indy(i);
    ind_val = ind_mat(x,y);
    for j = 1:3
        image(x,y,j) = cmap(ind_val,j);
    end
end
% %Make the meshgrid
% x_vec = linspace(min(x_pos),max(x_pos),bins(1));
% y_vec = linspace(min(y_pos),max(y_pos),bins(1));
% [X,Y] = meshgrid(x_vec,y_vec);
% 
% %make the pcolor plot
% pcolor(X,Y,ind_mat);
% %shading interp
% colormap(cmap)

%Need to shift image to where its supposed to be on the plot
%First resize the image
xlims = [min(x_pos) max(x_pos)];
ylims = [min(y_pos) max(y_pos)];
image = imresize(image, [250 250]);
image = imgaussfilt(image,3.25);
% figure
% imagesc(image)
xlim([0 800])
ylim([0 400])

%Now position the picture on the plot
%axes('pos',[min(x_pos) min(y_pos) xlims(2)-xlims(1) ylims(2)-ylims(1)]);
%axes('pos',[.1 .6 .5 .3]);
%Convert plot data points to figure position
old_axes = fig.Children;
figPos = ds2nfu([xlims(1) ylims(1) xlims(2)-xlims(1) ylims(2)-ylims(1)]);
new_ax = axes('pos',figPos);
imshow(image);
new_ax.YDir = 'normal';
set(new_ax,'color','none')

%reassign the figure
new_fig = figure('Visible','off');
new_ax.Parent = new_fig;
old_axes.Parent = new_fig;
old_axes.Color = 'none';
close(fig)
clear fig
fig = new_fig;
fig.Color = 'w';
end

