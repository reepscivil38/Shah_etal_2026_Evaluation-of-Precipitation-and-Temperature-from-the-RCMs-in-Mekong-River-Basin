% to estimate error in basin-average time-series of ERA-I wrt APHRO to plot figure 3a.
clc; clear all;

lonlatr=importdata('../../lonlat_0.5_Mekong');

out=[1990:2007]';

%% aphro
aph1=[];

for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    aph=importdata(['../../../processed/APHRO/grid_mm_day/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        b=find(aph(:,1)==y);
        aph1(n,ir)=mean(aph(b,4)); % mean for mm/day
        n=n+1;
    end
    
end

out(:,2)=mean(aph1,2);

%era

m=2;
for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    res=importdata(['../../../processed/ERA-I/pr_daily_mmperday/resample/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        a=find(res(:,1)==y);
        res1(n,ir)=mean(res(a,4)); %mean for mm/day
        n=n+1;
    end
end
out(:,1+m)=mean(res1,2); % 1for aphro

%% error

out1=out(:,1);

for m=2;
    out1(:,m)=(out(:,m+1)-(out(:,2)));
end

dlmwrite(['../../../plot/timeseries_analysis/era_i_p_bias'],out1,' ');
