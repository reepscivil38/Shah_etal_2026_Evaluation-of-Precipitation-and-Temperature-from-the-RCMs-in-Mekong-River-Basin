%%% to regrid from circular grid to rectangle grid.
clc; clear all;

CR=0.5; FR=0.01; % fine resolution 1km for 0.01 degree

lonlat=importdata('../lonlat_0.5_Mekong');

filelist=dir('../../processed/CORDEX/cat_txt_Mekong_box/tasm*'); % tasm*'); %add p or tasm for precipitation and temperatue

for m=12%;%1:size(filelist)
     display (filelist(m).name);
     
mkdir ('../../processed/CORDEX/resample_grid/',filelist(m).name)
    
    
    %% to generate fine resolution grids for the Mekong box from required lonlat 
    % fine resolution lon lat
    lonlat_f=importdata('lonlat_list/lonlat_Mekong_0p01');
    
    %% now to find nearest neighbour grid (for finer grid) from original grid as assign them
    lonlat_c=[];  % to remove old memory as size of original lonlat is different
    
    for j=1:size(lonlat_f,1);
        display (j);
        lon=lonlat_f(j,1);
        lat=lonlat_f(j,2);
        
        lonlat_c=importdata(['lonlat_list/lonlat_',filelist(m).name]);
        
        %find distance from all original grid
        for k=1:size(lonlat_c,1);
            lon_c=lonlat_c(k,1);
            lat_c=lonlat_c(k,2);
            lonlat_c(k,3)=posdist(lat,lon,lat_c,lon_c);
        end
        
        % write down nearest original grid next to finer grid
        lonlat2=sortrows(lonlat_c,3);
        
        lonlat_f(j,3:4)=lonlat2(1,1:2);
        
    end
    
    %% now find finer resolution grid falling within 1 grid box of coarser and then mean corresponding original grid
    data=[];  % as size may differ across different cordex
    for l=219:size(lonlat,1);
        display (l);
        lon_o=lonlat(l,1);
        lat_o=lonlat(l,2);
        out=[];
        
        a=find(lonlat_f(:,1)>=lon_o-CR/2 & lonlat_f(:,1)<=lon_o+CR/2 & lonlat_f(:,2)>=lat_o-CR/2 & lonlat_f(:,2)<=lat_o+CR/2);
        
        for l1=1:size(a,1);
            lon_n=lonlat_f(a(l1),3);
            lat_n=lonlat_f(a(l1),4);
            data=importdata(['../../processed/CORDEX/grid/',filelist(m).name,'/data_',num2str(lat_n,'%0.6f'),'_',num2str(lon_n,'%0.6f')]);
            out(:,l1)=data(:,4);
        end
        
        data1=data(:,1:3);
        data1(:,4)=mean(out,2);
        dlmwrite(['../../processed/CORDEX/resample_grid/',filelist(m).name,'/data_',num2str(lat_o,'%0.2f'),'_',num2str(lon_o,'%0.2f')],data1,' ');
    end
end