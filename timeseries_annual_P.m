% compare basin-average precipitation from CORDEX with
clc; clear all;

lonlatr=importdata('lonlat_0.5_Mekong');
% read cordex directory storing all cordex resample grids under folder pr_$model 
filelist=dir('../processed/CORDEX/resample_grid/pr*');

out=[1990:2007]';

%% aphro
aph1=[];

for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    aph=importdata(['../processed/APHRO/grid_mm_day/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        b=find(aph(:,1)==y);
        aph1(n,ir)=mean(aph(b,4));
        n=n+1;
    end
    
end

out(:,2)=mean(aph1,2)

%% read RCM grid data

for m=2:size(filelist); %from 2 to ignore, CCLM5 as it is on number 1. 
    display(filelist(m).name);
    
    for ir=1:size(lonlatr,1);
        disp (ir);
        lonr=lonlatr(ir,1);
        latr=lonlatr(ir,2);
        res=importdata(['../processed/CORDEX/resample_grid/',filelist(m).name,'/data_',num2str(latr),'_',num2str(lonr)]);
        
        %% annual
        n=1;
        for y=1990:2007;
            a=find(res(:,1)==y);
            res1(n,ir)=mean(res(a,4));
            n=n+1;
        end
    end
    out(:,1+m)=mean(res1,2);
    
end

dlmwrite(['../plot/timeseries_analysis/timeseries_annual_p'],out,' ');

 
 %anomaly
 
 out1=out(:,1);
 
 for m=1:size(filelist)+1;
     out1(:,m+1)=(out(:,m+1)-mean(out(:,m+1)))/mean(out(:,m+1))*100; %anomaly in percentage
 end
 %
  dlmwrite(['../plot/timeseries_analysis/timeseries_annual_p_anomaly'],out1,' ');
