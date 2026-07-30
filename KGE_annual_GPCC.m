% compare trend in precipitation from CORDEX with
clc; clear all;

lonlatr=importdata('lonlat_0.5_Mekong');

filelist=dir('../processed/CORDEX/resample_grid/pr*');

for m=1:size(filelist)
    display(filelist(m).name);
    
    for ir=1:size(lonlatr,1);
        disp (ir);
        lonr=lonlatr(ir,1);
        latr=lonlatr(ir,2);
        res=importdata(['../processed/CORDEX/resample_grid/',filelist(m).name,'/data_',num2str(latr),'_',num2str(lonr)]);
        aph=importdata(['../processed/APHRO/grid_mm_day/data_',num2str(latr),'_',num2str(lonr)]);
        CRU=importdata(['../processed/CRU/data_',num2str(latr),'_',num2str(lonr)]);
        GPCC=importdata(['../processed/GPCC/data_',num2str(latr),'_',num2str(lonr)]);
        ERA5=importdata(['../processed/ERA5/grid_mm_day/data_',num2str(latr),'_',num2str(lonr)]);
        ERAI=importdata(['../processed/ERA-I/pr_daily_mmperday/resample/data_',num2str(latr),'_',num2str(lonr)]);

        %% annual
        n=1;
        for y=1990:2007;
            a=find(res(:,1)==y);
            yea(n,1)=sum(res(a,4));
            b=find(GPCC(:,1)==y);
            yea(n,2)=sum(GPCC(b,3));
            n=n+1;
        end
        lonlatr(ir,2+m)= calcKGE(yea(:,2),yea(:,1));
        
               %% annual ERAI
        n=1;
        for y=1990:2007;
            a=find(ERAI(:,1)==y);
            yea(n,1)=sum(ERAI(a,4));
            n=n+1;
        end
        lonlatr(ir,2+m+1)= calcKGE(yea(:,2),yea(:,1));

    end
end

% dlmwrite(['../plot/bias_annual/bias_annual'],lonlatr,' ');


