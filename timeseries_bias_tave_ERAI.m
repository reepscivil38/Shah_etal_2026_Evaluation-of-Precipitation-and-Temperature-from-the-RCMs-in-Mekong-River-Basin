%  to estimate bias in basin-average time-series of temperature from ERA-I using APHRO as reference to plot figure 3d.  
clc; clear all;

lonlatr=importdata('../../lonlat_0.5_Mekong');

out=[1990:2007]';

%% aphro
aph1=[];

for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    aph=importdata(['../../../processed/APHRO/grid_tave/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        b=find(aph(:,1)==y);
        aph1(n,ir)=mean(aph(b,4));
        n=n+1;
    end
    
end

out(:,2)=mean(aph1,2);

%%era-i

m=2


for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    tmax=importdata(['../../../processed/ERA-I/tempe_daily/resample/data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        a=find(tmax(:,1)==y);
        res1(n,ir)=mean(tmax(a,4));
        n=n+1;
    end
end
out(:,m+1)=mean(res1,2);

%% error

out1=out(:,1);

for m=2;
    out1(:,m)=out(:,m+1)-out(:,2);
end

dlmwrite(['../../../plot/timeseries_analysis/era_i_tave_bias'],out1,' ');

