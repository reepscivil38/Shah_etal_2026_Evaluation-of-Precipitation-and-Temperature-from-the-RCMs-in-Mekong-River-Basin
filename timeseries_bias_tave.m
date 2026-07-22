% compare trend in precipitation from CORDEX with
clc; clear all;

lonlatr=importdata('../lonlat_0.5_Mekong');
filelist=importdata('file_list_tave');

out=[1990:2007]';

%% aphro
aph1=[];

for ir=1:size(lonlatr,1);
    disp (ir);
    lonr=lonlatr(ir,1);
    latr=lonlatr(ir,2);
    aph=importdata(['../../processed/APHRO/grid_tave//data_',num2str(latr),'_',num2str(lonr)]);
    
    %% annual
    n=1;
    for y=1990:2007;
        b=find(aph(:,1)==y);
        aph1(n,ir)=mean(aph(b,4));
        n=n+1;
    end
    
end

out(:,2)=mean(aph1,2);

%%model

res1=[];

for m=1:size(filelist)
    display(m);
    
    for ir=1:size(lonlatr,1);
        disp (ir);
        lonr=lonlatr(ir,1);
        latr=lonlatr(ir,2);
        tmax=importdata(['../../processed/CORDEX/resample_grid/tasmax_',char(filelist(m)),'/data_',num2str(latr),'_',num2str(lonr)]);
        tmin=importdata(['../../processed/CORDEX/resample_grid/tasmin_',char(filelist(m)),'/data_',num2str(latr),'_',num2str(lonr)]);
        
        %% annual
        n=1;
        for y=1990:2007;
            a=find(tmax(:,1)==y);
            res1(n,ir)=mean((tmax(a,4)+tmin(a,4))/2);
            n=n+1;
        end
    end
    out(:,m+2)=mean(res1,2);
    
end

%% error

out1=out(:,1);

for m=1:size(filelist,1);
    out1(:,m+1)=out(:,m+2)-out(:,2);
end

dlmwrite(['../../plot/timeseries_analysis/timeseries_bias_tave'],out1,' ');
