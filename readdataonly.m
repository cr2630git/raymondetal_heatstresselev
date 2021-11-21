 %variables,models
    var_target=[1 2 3 4 5]; %specifies index of VAR_NAME below to extract
    model_target=[1:20]; %specifies indices of MODEL_NAME below to extract
    exp_target=[1:2]; %specifies indices of EXP_NAME below to extract

    outputFileName='maca_subset.mat';
    pathDir='http://thredds.northwestknowledge.net:8080/thredds/dodsC/';


    disp('Starting primary code block');

    %=============================================
    %     PRIMARY CODE BLOCK 
    %=============================================
    %Note: URLs to verify are along the lines of http://thredds.northwestknowledge.net:8080/thredds/reacch_climate_CMIP5_aggregated_macav2_catalog.html?
        %dataset=agg_macav2metdata_rsds_CanESM2_r1i1p1_historical_1950_2005_CONUS_daily
        
    %Model list is copied again here for convenience:
    %MODEL_NAME={'CSIRO-Mk3-6-0';'inmcm4'; 'CanESM2';'MIROC-ESM';...
    %'MIROC-ESM-CHEM';'MRI-CGCM3';'CNRM-CM5';'IPSL-CM5A-MR';... 
    %'IPSL-CM5A-LR';'GFDL-ESM2G';'GFDL-ESM2M';'MIROC5';...
    %'bcc-csm1-1';'BNU-ESM';'NorESM1-M';'CCSM4';...
    %'IPSL-CM5B-LR';'bcc-csm1-1-m';'HadGEM2-ES365';'HadGEM2-CC365'};
    
    %for var=2:length(var_target)
        %for model=4:length(model_target)
    for model=1:20
        for var=1:5
            modelname=MODEL_NAME{var};
            
            continueon=0;
            if var==1 && model==10
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='eastern-us';
            elseif var==1 && model==12
                continueon=1;dohistorical=0;dofuture=1;regdescriphist='western-us';
            elseif var==5 && model==7
                continueon=1;dohistorical=1;dofuture=0;regdescriphist='western-us';
            elseif var==5 && model==11
                continueon=1;dohistorical=1;dofuture=0;regdescriphist='western-us';
            elseif var==5 && model==12
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==15
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==13
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==14
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==16
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==17
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==18
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==19
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==5 && model==20
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==1 && model==16
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==2 && model==16
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==1 && model==17
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==2 && model==17
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==1 && model==18
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==2 && model==18
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==1 && model==19
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==2 && model==19
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==1 && model==20
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            elseif var==2 && model==20
                continueon=1;dohistorical=1;dofuture=1;regdescriphist='western-us';regdescripfut='western-us';
            end
                
                
            if continueon==1    
                if dohistorical==1
                    time_string='1950_2005';
                    myURL=[pathDir,'agg_macav2metdata_',VAR_NAME{var},'_',...
                        modelname,'_r',num2str(RUN_NUM(model)),'i1p1_historical_',char(time_string),'_CONUS_daily.nc'];

                    %want to start at day 10957 - jan 1, 1980 (with day 1 as
                    %1/1/1950) -- previously 10948
                    %and end on dec 31, 2005, at day 20454
                    overallc=1;
                    if strcmp(regdescriphist,'eastern-us')
                        saveddata=NaN.*ones(455,292,382*25);
                        lat_target=[24 49.75];lon_target=[-105 -66]+360;
                    else
                        saveddata=NaN.*ones(237,233,382*25);
                        lat_target=[30 49.75];lon_target=[-124.75 -105]+360;
                    end
                    
                    %Get geographical indices of subset by looking at a sample file
                    pathname=[pathDir,'agg_macav2metdata_huss_CanESM2_r1i1p1_historical_1950_2005_CONUS_daily.nc'];
                    lat=ncread(pathname,'lat');lon=ncread(pathname,'lon');

                    lat_index=find(lat<=max(lat_target)&lat>=min(lat_target));lat_index=[min(lat_index):max(lat_index)];
                    lon_index=find(lon<=max(lon_target)&lon>=min(lon_target));lon_index=[min(lon_index):max(lon_index)];
    

                    for loop=438:819
                        if loop==819;leng=4;else;leng=25;end

                        %start=[min(lon_index) min(lat_index) loop*25-24];
                        %count=[round2(length(lon_index)/2,1,'floor') round2(length(lat_index)/2,1,'floor') leng];
                        %if strcmp(regdescrip,'eastern-us');stride=[2 2 1];else;stride=[1 1 1];end
                        start=[min(lon_index) min(lat_index) loop*25-24];
                        count=[round2(length(lon_index)/2,1,'floor') round2(length(lat_index)/2,1,'floor') leng];
                        stride=[2 2 1];

                        i=1;e=0;I=100;
                        while i<I && e<=50
                           try
                              saveddata(:,:,overallc:overallc+leng-1)=ncread(myURL,VAR_LONGNAME{var},start,count,stride);
                              i = 100;
                              e = 0; % reset error counter
                           catch
                              pause(.5) % pause to see if internet improves
                              e = e+1;  % add an error
                           end
                        end

                        overallc=overallc+leng;
                        if rem(loop,25)==0;disp(loop);end
                    end
                    
                    if strcmp(regdescriphist,'eastern-us')
                        for i=1:382*25;if ~isnan(saveddata(400,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                        save(strcat(dataloc,'historical',VAR_NAME{var},MODEL_NAME{model},'easternus.mat'),'saveddata','-v7.3');
                    else
                        for i=1:382*25;if ~isnan(saveddata(50,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                        save(strcat(dataloc,'historical',VAR_NAME{var},MODEL_NAME{model},'.mat'),'saveddata','-v7.3');
                    end
                    fprintf(strcat(['Just completed historical data-gathering for ',regdescriphist,', ',VAR_NAME{var},' and ',MODEL_NAME{model},'\n']));
                end

                if dofuture==1
                    for experiment=2:length(exp_target)
                        time_string='2006_2099';
                        myURL=[pathDir,'agg_macav2metdata_',VAR_NAME{var},'_',...
                            modelname,'_r',num2str(RUN_NUM(model)),'i1p1_',EXP_NAME{experiment+1},'_',char(time_string),'_CONUS_daily.nc'];

                        %need to access just a small time slice first...
                        i=1;e=0;I=100;
                        while i<I && e<=50
                            try
                                tempdata=ncread(myURL,VAR_LONGNAME{var},[1 1 1],[1 1 1],[1 1 1]);
                                i=100;e=0;
                            catch
                                pause(.5) % pause to see if internet improves
                                  e = e+1; % add an error
                            end
                        end   

                        %want to start at day 24838 - jan 1, 2074
                        %and end on dec 31, 2099, after 34333 days in total
                        overallc=1;
                        if strcmp(regdescripfut,'eastern-us')
                            saveddata=NaN.*ones(455,292,382*25);
                            lat_target=[24 49.75];lon_target=[-105 -66]+360;
                        else
                            saveddata=NaN.*ones(237,233,382*25);
                            lat_target=[30 49.75];lon_target=[-124.75 -105]+360;
                        end
                        
                        
                        %Get geographical indices of subset by looking at a sample file
                        pathname=[pathDir,'agg_macav2metdata_huss_CanESM2_r1i1p1_historical_1950_2005_CONUS_daily.nc'];
                        lat=ncread(pathname,'lat');lon=ncread(pathname,'lon');

                        lat_index=find(lat<=max(lat_target)&lat>=min(lat_target));lat_index=[min(lat_index):max(lat_index)];
                        lon_index=find(lon<=max(lon_target)&lon>=min(lon_target));lon_index=[min(lon_index):max(lon_index)];
                    

                        for loop=994:1374
                            if loop==1374;leng=8;else;leng=25;end

                            start=[min(lon_index) min(lat_index) loop*25-24];
                            count=[round2(length(lon_index)/2,1,'floor') round2(length(lat_index)/2,1,'floor') leng];
                            stride=[2 2 1];

                            i = 1;
                            e = 0; % error counter
                            I = 100; % Total number of loops
                            while i<I && e<=50
                               try
                                  saveddata(:,:,overallc:overallc+leng-1)=ncread(myURL,VAR_LONGNAME{var},start,count,stride);
                                  i = 100;
                                  e = 0; % reset error counter
                               catch
                                  pause(.5) % pause to see if internet improves
                                  e = e+1; % add an error
                               end
                            end

                            overallc=overallc+leng;
                            if rem(loop,50)==0;disp(loop);disp(clock);end
                        end
                        if strcmp(regdescripfut,'eastern-us')
                            for i=1:382*25;if ~isnan(saveddata(400,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                            save(strcat(dataloc,EXP_NAME{experiment+1},VAR_NAME{var},MODEL_NAME{model},'easternus.mat'),'saveddata','-v7.3');
                        else
                            for i=1:382*25;if ~isnan(saveddata(1,1,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                            save(strcat(dataloc,EXP_NAME{experiment+1},VAR_NAME{var},MODEL_NAME{model},'.mat'),'saveddata','-v7.3');
                        end
                        fprintf(strcat(['Just completed future data-gathering for ',regdescripfut,', ',EXP_NAME{experiment+1},', ',VAR_NAME{var},' and ',MODEL_NAME{model},'\n']));
                    end
                end
            end
        end
    end