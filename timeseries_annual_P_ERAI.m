% % to create annual basin-average timeseires for ERA-I used to plot figure 3a.

clc; clear all;

lonlatr=importdata('../../lonlat_0.5_Mekong');

out=[1990:2007]';

%% aphro
aph1=[];

for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    aph=importdata(['../../../processed/ERA-I/pr_daily_mmperday/resample/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        b=find(aph(:,1)==y);
        aph1(n,ir)=mean(aph(b,4));
        n=n+1;
    end
    
end

out(:,2)=mean(aph1,2);
dlmwrite(['../../../plot/timeseries_analysis/era_i_p'],out,' ');

% anomaly
out1(:,1)=out(:,1);
out1(:,2)=(out(:,2)-mean(out(:,2)))/mean(out(:,2))*100; %anomaly in percentage
 
dlmwrite(['../../../plot/timeseries_analysis/era_i_p_anomaly'],out1,' ');
