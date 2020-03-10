%Ryan Cameron - University of Colorado, Boulder - Donaldson Lab
%Created: 2/4/2020
%Edited:  2/7/2020
%--------------------------------------------------------------------------
%This script finds the average distance change of the test animal,
%independent of the chamber it is in or when events occur, per animal per
%epoch.
%--------------------------------------------------------------------------

clearvars; close all; clc;

animals = [440 445 451 485 487 532 535 543 546 557 570 573 584 585 586 588 598 599];
cd ..
addpath('Distance_Total_Data')
data_tab = readtable('Angles_complete_w_AppDep_445excluded.csv');
data_partner = readtable('Partner_Median_PostEvent.csv');
data_novel = readtable('Novel_Median_PostEvent.csv');
%Intialize tables
approach_table = table();
departure_table = table();
VariNames = {'Animal','Epoch','before_all','before_partner','before_novel',...
    'before_center','after_all','after_partner','after_novel','after_center','partner_dev_score','novel_dev_score'};

for an = animals
    for ep = 1:3
        data_index = find(data_tab.Animal == an & data_tab.Epoch == ep);
        small_data = data_tab(data_index,:);
        
        data_index = find(data_partner.Animal == an & data_partner.Epoch == ep);
        small_partner = data_partner(data_index,:);
        small_novel = data_novel(data_index,:);
        
        for stringVar = ["approach","departure"]
            switch stringVar
                case "approach"
                    %Do the data totals for approach cells
                    index_app = find(small_data.P_app_dep_cells == 1 | small_data.N_app_dep == 1);
                    app_data = small_data(index_app,:);
                    before_dist = app_data.before_distance_all;
                    before_dist = meanNan(before_dist);
                    
                    before_dist_partner = app_data.before_distance_ptnr;
                    before_dist_partner = meanNan(before_dist_partner);
                    
                    before_dist_novel = app_data.before_distance_nov;
                    before_dist_novel = meanNan(before_dist_novel);
                    
                    before_dist_center = app_data.before_distance_ctr;
                    before_dist_center = meanNan(before_dist_center);
                    %Do the after distnace
                    after_dist = app_data.after_distance_all;
                    after_dist = meanNan(after_dist);
                    
                    after_dist_partner = app_data.after_distance_ptnr;
                    after_dist_partner = meanNan(after_dist_partner);
                    
                    after_dist_novel = app_data.after_distance_nov;
                    after_dist_novel = meanNan(after_dist_novel);
                    
                    after_dist_center = app_data.after_distance_ctr;
                    after_dist_center = meanNan(after_dist_center);
                    
                    index_app = find(small_partner.Pval_Ptnr_post <= 5);
                    dev_partner = meanNan(small_partner(index_app,:).Dev_Ptnr_post);
                    index_app = find(small_novel.Var5 <= 5);
                    dev_novel = meanNan(small_novel(index_app,:).Var4);
                    
                    approach_table = [approach_table;table(an,ep,before_dist,before_dist_partner,before_dist_novel,before_dist_center,...
                        after_dist,after_dist_partner,after_dist_novel,after_dist_center,dev_partner,dev_novel)];
                case "departure"
                    %Do the data totals for departure cells
                    index_app = find(small_data.P_app_dep_cells == 2 | small_data.N_app_dep == 2);
                    app_data = small_data(index_app,:);
                    before_dist = app_data.before_distance_all;
                    before_dist = meanNan(before_dist);
                    
                    before_dist_partner = app_data.before_distance_ptnr;
                    before_dist_partner = meanNan(before_dist_partner);
                    
                    before_dist_novel = app_data.before_distance_nov;
                    before_dist_novel = meanNan(before_dist_novel);
                    
                    before_dist_center = app_data.before_distance_ctr;
                    before_dist_center = meanNan(before_dist_center);
                    %Do the after distnace
                    after_dist = app_data.after_distance_all;
                    after_dist = mean(after_dist);
                    
                    after_dist_partner = app_data.after_distance_ptnr;
                    after_dist_partner = meanNan(after_dist_partner);
                    
                    after_dist_novel = app_data.after_distance_nov;
                    after_dist_novel = meanNan(after_dist_novel);
                    
                    after_dist_center = app_data.after_distance_ctr;
                    after_dist_center = meanNan(after_dist_center);
                    
                    index_app = find(small_partner.Pval_Ptnr_post >= 95);
                    dev_partner = meanNan(small_partner(index_app,:).Dev_Ptnr_post);
                    index_app = find(small_novel.Var5 >= 95);
                    dev_novel = meanNan(small_novel(index_app,:).Var4);
                    
                    departure_table = [departure_table;table(an,ep,before_dist,before_dist_partner,before_dist_novel,before_dist_center,...
                        after_dist,after_dist_partner,after_dist_novel,after_dist_center,dev_partner,dev_novel)];
            end
        end
    end
end
approach_table.Properties.VariableNames = VariNames;
writetable(approach_table,'Distance_Total_Data/approach_table.xlsx')
departure_table.Properties.VariableNames = VariNames;
writetable(departure_table,'Distance_Total_Data/departure_table.xlsx')

function [out] = meanNan(vec)
index = find(isnan(vec));
vec(index) = [];
out = mean(vec);
end
