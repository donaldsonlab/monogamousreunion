function [ cells,Fdownsample ] = fileloop( vole_num,epoch )
PWD = pwd;
%cd('/Users/elliottsaslow/Google Drive/Vole imaging master data')
%cd('C:\Users\DonaldsonLab\Google Drive\Vole imaging master data')
%cd('C:\Users\lccam\Google Drive\Vole imaging master data')
cd('G:\My Drive\Donaldson Lab\Vole imaging master data')
%cd('C:\Users\lccam\Google Drive\Donaldson Lab\Vole imaging master data')
voles=[570 598 599 451 487 543 546 557 573 440 585 586 485 532 535 584 588 445 566 589];
cohorts=[14 14 14 8 9 10 11 11 12 8 12 13 9 10 10 12 12 8 13 13];
index = find(vole_num == voles);
cohort_num = cohorts(index); %Storing cohort and vole #
vole_num = voles(index);
if(cohort_num < 10) %If cohort# is less than 10, add 0 to front of number (for filename)
    cohort_num = sprintf('0%d',cohort_num);
    vole_file = sprintf('C%s_%d',cohort_num,vole_num);
else
    vole_file = sprintf('C%d_%d',cohort_num,vole_num);
end
cd(vole_file)

switch epoch 
    case 1
        if isfile(sprintf('Vole_%d_%d-premating_cell_events_choice.mat', vole_num, epoch))
            choice_file = sprintf('Vole_%d_%d-premating_cell_events_choice.mat', vole_num, epoch);
        elseif isfile(sprintf('Vole %d_%d-premating_cell_events_choice.mat', vole_num, epoch))
            choice_file = sprintf('Vole %d_%d-premating_cell_events_choice.mat', vole_num, epoch);
        else
            [choice_file,~] = uigetfile('*');
        end
        
        if isfile(sprintf('Vole_%d_%d-premating_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch))
            beh_file = sprintf('Vole_%d_%d-premating_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch);
        elseif isfile(sprintf('Vole %d_%d-premating_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch))
            beh_file = sprintf('Vole %d_%d-premating_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch);
        else
            beh_file = uigetfile('*');
        end
        cells = load(choice_file);
        cells = cells.cell_events_choice;
        downsample = load(beh_file);
        Fdownsample = eval(strcat('downsample.',char(fieldnames(downsample,'-full'))));
    case 2
        choice_file = sprintf('Vole %d_%d-72hrs_cell_events_choice.mat', vole_num, epoch);
            beh_file = sprintf('Vole %d_%d-72hrs_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch); 
        cells = load(choice_file);
        cells = cells.cell_events_choice;
        downsample = load(beh_file);
        a = char(fieldnames(downsample,'-full') );
        Fdownsample = eval(strcat('downsample.',a(end,:)));
    case 3
        choice_file = sprintf('Vole %d_%d-2wks_cell_events_choice.mat', vole_num, epoch);
        beh_file = sprintf('Vole %d_%d-2wks_choice_beh_gap1sec_ApWt_downsample.mat', vole_num, epoch); 
        cells = load(choice_file);
        cells = cells.cell_events_choice;
        downsample = load(beh_file);
        a = char(fieldnames(downsample,'-full') );
        Fdownsample = eval(strcat('downsample.',a(end,:)));
        
end
cd(PWD) 

clearvars -except cells Fdownsample
end