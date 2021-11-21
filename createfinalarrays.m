for modelnum=arraycreationmodelstart:arraycreationmodelstop
    model=models(modelnum);
    modelname=MODEL_NAME{model};

    for expnum=arraycreationexpstart:arraycreationexpstop
        experiment=exps(expnum);
        expname=EXP_NAME{experiment};

        if experiment==1 %historical
            %Creates full-US arrays of T in C, q in kg/kg, net solar radiation in W/m^2
            %Interval is 1 for West US for variables with array dims of 237x233, vs an interval of 2 for array dims 474x466
            %Default intervals are 1 for East and 2 for West

            %1) Temperature
            if reread_arrays(modelnum,1,expnum,1)==1 && reread_arrays(modelnum,1,expnum,2)==1
                %East   
                if downloadedfromserver2(modelnum,1,expnum,2)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,1,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,2)==0
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'7565.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9075.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'10590.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_east=cat(1,tarray_hist3,tarray_hist2,tarray_hist1);clear tarray_hist1;clear tarray_hist2;clear tarray_hist3;
                else
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'7565.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'8075.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'8580.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9085.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist5=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9590.nc'),vname);
                        tarray_hist5=tarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist6=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'10095.nc'),vname);
                        tarray_hist6=tarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist7=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'105100.nc'),vname);
                        tarray_hist7=tarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_east=cat(1,tarray_hist7,tarray_hist6,tarray_hist5,tarray_hist4,tarray_hist3,tarray_hist2,tarray_hist1);
                    clear tarray_hist1;clear tarray_hist2;clear tarray_hist3;clear tarray_hist4;clear tarray_hist5;clear tarray_hist6;clear tarray_hist7;
                end

                %West
                if downloadedfromserver2(modelnum,1,expnum,1)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,1,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,1)==0
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'120105.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist5=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'125120.nc'),vname);
                        tarray_hist5=tarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_west=cat(1,tarray_hist5,tarray_hist4);clear tarray_hist4;clear tarray_hist5;
                else
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'110105.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'115110.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'120115.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'125120.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_west=cat(1,tarray_hist4,tarray_hist3,tarray_hist2,tarray_hist1);clear tarray_hist4;clear tarray_hist3;clear tarray_hist2;clear tarray_hist1;
                end

                tarray_histFINAL=cat(1,tarray_hist_west,tarray_hist_east);clear tarray_hist_west;clear tarray_hist_east;
                tarray_histFINAL=tarray_histFINAL(1:692,:,:);fprintf('For modelnum %d and expnum %d, size of tarray_histFINAL is %d/%d/%d\n',...
                    modelnum,expnum,size(tarray_histFINAL,1),size(tarray_histFINAL,2),size(tarray_histFINAL,3));
            elseif reread_arrays(modelnum,1,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,1,expnum,1)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,1,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,1)==0
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'120105.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist5=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'125120.nc'),vname);
                        tarray_hist5=tarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_west=cat(1,tarray_hist5,tarray_hist4);clear tarray_hist4;clear tarray_hist5;
                else
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'110105.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'115110.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'120115.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'125120.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_west=cat(1,tarray_hist4,tarray_hist3,tarray_hist2,tarray_hist1);clear tarray_hist4;clear tarray_hist3;clear tarray_hist2;clear tarray_hist1;
                end
                %East    
                temp=load(strcat(dataloc,'historicaltasmax',modelname,'easternus.mat'));tarray_hist_east=temp.saveddata; %Eastern US
                if size(tarray_hist_east,1)==237;eastint_fort=1;else;eastint_fort=1;end
                fprintf('For model %d and expnum %d, T value at 200,100 (East) is %0.2f\n',model,expnum,tarray_hist_east(200,100,1000));
                for i=1:382*25;if ~isnan(tarray_hist_east(400,50,i));tarray_hist_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                tarray_hist_east=tarray_hist_east(eastint_fort:eastint_fort:end,2:eastint_fort:end,mjjasodays_hist);tarray_hist_east=cat(2,tarray_hist_east,NaN.*ones(455,1,nd));

                tarray_histFINAL=cat(1,tarray_hist_west,tarray_hist_east);clear tarray_hist_west;clear tarray_hist_east;
                tarray_histFINAL=tarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of tarray_histFINAL is %d\n',modelnum,expnum,size(tarray_histFINAL));
            elseif reread_arrays(modelnum,1,expnum,2)==1
                %East  
                if downloadedfromserver2(modelnum,1,expnum,2)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,1,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,2)==0
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'7565.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9075.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'10590.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_east=cat(1,tarray_hist3,tarray_hist2,tarray_hist1);clear tarray_hist1;clear tarray_hist2;clear tarray_hist3;
                else
                    tarray_hist1=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'7565.nc'),vname);
                        tarray_hist1=tarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist2=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'8075.nc'),vname);
                        tarray_hist2=tarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist3=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'8580.nc'),vname);
                        tarray_hist3=tarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist4=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9085.nc'),vname);
                        tarray_hist4=tarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist5=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'9590.nc'),vname);
                        tarray_hist5=tarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist6=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'10095.nc'),vname);
                        tarray_hist6=tarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist7=ncread(strcat(dataloc,'NEWhistoricaltasmax',modelname,'105100.nc'),vname);
                        tarray_hist7=tarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    tarray_hist_east=cat(1,tarray_hist7,tarray_hist6,tarray_hist5,tarray_hist4,tarray_hist3,tarray_hist2,tarray_hist1);
                    clear tarray_hist1;clear tarray_hist2;clear tarray_hist3;clear tarray_hist4;clear tarray_hist5;clear tarray_hist6;clear tarray_hist7;
                end
                %West
                temp=load(strcat(dataloc,'historicaltasmax',modelname,'.mat'));tarray_hist_west=temp.saveddata; %Western US
                    if size(tarray_hist_west,1)==237;westint_fort=1;else;westint_fort=2;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (West) is %0.2f\n',model,expnum,tarray_hist_west(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_hist_west(1,1,i));tarray_hist_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_hist_west=tarray_hist_west(:,1:end-1,mjjasodays_hist);
                    if size(tarray_hist_west,1)==237
                        tarray_hist1=cat(2,NaN.*ones(237,59,nd),tarray_hist_west);tarray_hist1=cat(2,tarray_hist1,NaN.*ones(237,1,nd));
                    else
                        tarray_hist1=cat(2,NaN.*ones(474,119,nd),tarray_hist_west);
                    end
                    tarray_hist_west=tarray_hist1(westint_fort:westint_fort:end,westint_fort:westint_fort:end,:);clear tarray_hist1;

                tarray_histFINAL=cat(1,tarray_hist_west,tarray_hist_east);clear tarray_hist_west;clear tarray_hist_east;
                tarray_histFINAL=tarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of tarray_histFINAL is %d\n',modelnum,expnum,size(tarray_histFINAL));
            else
                temp=load(strcat(dataloc,'historicaltasmax',modelname,'.mat'));tarray_hist=temp.saveddata; %Western US
                    if size(tarray_hist,1)==237;westint_fort=1;else;westint_fort=2;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (West) is %0.2f\n',model,expnum,tarray_hist(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_hist(1,1,i));tarray_hist(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_hist=tarray_hist(:,1:end-1,mjjasodays_hist);
                    if size(tarray_hist,1)==237
                        tarray_hist1=cat(2,NaN.*ones(237,59,nd),tarray_hist);tarray_hist1=cat(2,tarray_hist1,NaN.*ones(237,1,nd));
                    else
                        tarray_hist1=cat(2,NaN.*ones(474,119,nd),tarray_hist);
                    end
                    tarray_hist_west=tarray_hist1(westint_fort:westint_fort:end,westint_fort:westint_fort:end,:);clear tarray_hist;
                temp=load(strcat(dataloc,'historicaltasmax',modelname,'easternus.mat'));tarray_hist2=temp.saveddata; %Eastern US
                    if size(tarray_hist2,1)==237;eastint_fort=1;else;eastint_fort=1;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (East) is %0.2f\n',model,expnum,tarray_hist2(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_hist2(400,50,i));tarray_hist2(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_hist_east=tarray_hist2(eastint_fort:eastint_fort:end,2:eastint_fort:end,mjjasodays_hist);tarray_hist_east=cat(2,tarray_hist_east,NaN.*ones(455,1,nd));
                    clear tarray_hist2;

                    tarray_histFINAL=cat(1,tarray_hist_west,tarray_hist_east);clear tarray_hist_west;clear tarray_hist_east;
                    invalid=abs(tarray_histFINAL)>400;tarray_histFINAL(invalid)=NaN;
                    invalid=abs(tarray_histFINAL)==0;tarray_histFINAL(invalid)=NaN;
                    %fprintf('For modelnum %d and expnum %d, size of tarray_histFINAL is %d\n',modelnum,expnum,size(tarray_histFINAL)); 
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'),'tarray_histFINAL','-v7.3');end

            
            %2) Specific humidity
            if reread_arrays(modelnum,5,expnum,1)==1 && reread_arrays(modelnum,5,expnum,2)==1
                %East    
                if downloadedfromserver2(modelnum,5,expnum,2)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,5,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,2)==0
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'7565.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9075.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'10590.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_east=cat(1,qarray_hist3,qarray_hist2,qarray_hist1);clear qarray_hist1;clear qarray_hist2;clear qarray_hist3;
                else
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'7565.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'8075.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'8580.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9085.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist5=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9590.nc'),vname);
                        qarray_hist5=qarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist6=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'10095.nc'),vname);
                        qarray_hist6=qarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist7=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'105100.nc'),vname);
                        qarray_hist7=qarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_east=cat(1,qarray_hist7,qarray_hist6,qarray_hist5,qarray_hist4,qarray_hist3,qarray_hist2,qarray_hist1);
                    clear qarray_hist1;clear qarray_hist2;clear qarray_hist3;clear qarray_hist4;clear qarray_hist5;clear qarray_hist6;clear qarray_hist7;
                end

                %West
                if downloadedfromserver2(modelnum,5,expnum,1)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,5,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,1)==0
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'120105.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist5=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'125120.nc'),vname);
                        qarray_hist5=qarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_west=cat(1,qarray_hist5,qarray_hist4);clear qarray_hist4;clear qarray_hist5;
                else
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'110105.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'115110.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'120115.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'125120.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_west=cat(1,qarray_hist4,qarray_hist3,qarray_hist2,qarray_hist1);clear qarray_hist4;clear qarray_hist3;clear qarray_hist2;clear qarray_hist1;
                end

                qarray_histFINAL=cat(1,qarray_hist_west,qarray_hist_east);clear qarray_hist_west;clear qarray_hist_east;
                qarray_histFINAL=qarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_histFINAL is %d\n',modelnum,expnum,size(qarray_histFINAL));
            elseif reread_arrays(modelnum,5,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,5,expnum,1)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,5,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,1)==0
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'120105.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist5=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'125120.nc'),vname);
                        qarray_hist5=qarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_west=cat(1,qarray_hist5,qarray_hist4);clear qarray_hist4;clear qarray_hist5;
                else
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'110105.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'115110.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'120115.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'125120.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_west=cat(1,qarray_hist4,qarray_hist3,qarray_hist2,qarray_hist1);clear qarray_hist4;clear qarray_hist3;clear qarray_hist2;clear qarray_hist1;
                end  
                %East    
                temp=load(strcat(dataloc,'historicalhuss',modelname,'easternus.mat'));qarray_hist_east=temp.saveddata; %Eastern US
                if size(qarray_hist_east,1)==237;eastint_forq=1;else;eastint_forq=1;end
                fprintf('For model %d and expnum %d, q value at 200,100 (East) is %0.2f\n',model,expnum,qarray_hist_east(200,100,1000));
                for i=1:382*25;if ~isnan(qarray_hist_east(400,50,i));qarray_hist_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                qarray_hist_east=qarray_hist_east(eastint_forq:eastint_forq:end,2:eastint_forq:end,mjjasodays_hist);qarray_hist_east=cat(2,qarray_hist_east,NaN.*ones(455,1,nd));

                qarray_histFINAL=cat(1,qarray_hist_west,qarray_hist_east);clear qarray_hist_west;clear qarray_hist_east;
                qarray_histFINAL=qarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_histFINAL is %d\n',modelnum,expnum,size(qarray_histFINAL));
            elseif reread_arrays(modelnum,5,expnum,2)==1
                %East  
                if downloadedfromserver2(modelnum,5,expnum,2)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,5,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,2)==0
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'7565.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9075.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'10590.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_east=cat(1,qarray_hist3,qarray_hist2,qarray_hist1);clear qarray_hist1;clear qarray_hist2;clear qarray_hist3;
                else
                    qarray_hist1=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'7565.nc'),vname);
                        qarray_hist1=qarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist2=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'8075.nc'),vname);
                        qarray_hist2=qarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist3=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'8580.nc'),vname);
                        qarray_hist3=qarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist4=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9085.nc'),vname);
                        qarray_hist4=qarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist5=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'9590.nc'),vname);
                        qarray_hist5=qarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist6=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'10095.nc'),vname);
                        qarray_hist6=qarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist7=ncread(strcat(dataloc,'NEWhistoricalhuss',modelname,'105100.nc'),vname);
                        qarray_hist7=qarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    qarray_hist_east=cat(1,qarray_hist7,qarray_hist6,qarray_hist5,qarray_hist4,qarray_hist3,qarray_hist2,qarray_hist1);
                    clear qarray_hist1;clear qarray_hist2;clear qarray_hist3;clear qarray_hist4;clear qarray_hist5;clear qarray_hist6;clear qarray_hist7;
                end
                
                %West
                temp=load(strcat(dataloc,'historicalhuss',modelname,'.mat'));qarray_hist_west=temp.saveddata; %Western US
                    if size(qarray_hist_west,1)==237;westint_forq=1;else;westint_forq=2;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (West) is %0.2f\n',model,expnum,qarray_hist_west(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_hist_west(1,1,i));qarray_hist_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_hist_west=qarray_hist_west(:,1:end-1,mjjasodays_hist);
                    if size(qarray_hist_west,1)==237
                        qarray_hist1=cat(2,NaN.*ones(237,59,nd),qarray_hist_west);qarray_hist1=cat(2,qarray_hist1,NaN.*ones(237,1,nd));
                    else
                        qarray_hist1=cat(2,NaN.*ones(474,119,nd),qarray_hist_west);
                    end
                    qarray_hist_west=qarray_hist1(westint_forq:westint_forq:end,westint_forq:westint_forq:end,:);clear qarray_hist1;

                qarray_histFINAL=cat(1,qarray_hist_west,qarray_hist_east);clear qarray_hist_west;clear qarray_hist_east;
                qarray_histFINAL=qarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_histFINAL is %d\n',modelnum,expnum,size(qarray_histFINAL));
            else
                temp=load(strcat(dataloc,'historicalhuss',modelname,'.mat'));qarray_hist=temp.saveddata; %Western US
                    if size(qarray_hist,1)==237;westint_forq=1;else;westint_forq=2;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (West) is %0.2f\n',model,expnum,qarray_hist(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_hist(1,1,i));qarray_hist(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_hist=qarray_hist(:,1:end-1,mjjasodays_hist);
                    if size(qarray_hist,1)==237
                        qarray_hist1=cat(2,NaN.*ones(237,59,nd),qarray_hist);qarray_hist1=cat(2,qarray_hist1,NaN.*ones(237,1,nd));
                    else
                        qarray_hist1=cat(2,NaN.*ones(474,119,nd),qarray_hist);
                    end
                    qarray_hist_west=qarray_hist1(westint_forq:westint_forq:end,westint_forq:westint_forq:end,:);clear qarray_hist;
                temp=load(strcat(dataloc,'historicalhuss',modelname,'easternus.mat'));qarray_hist2=temp.saveddata; %Eastern US
                    if size(qarray_hist2,1)==237;eastint_forq=1;else;eastint_forq=1;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (East) is %0.2f\n',model,expnum,qarray_hist2(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_hist2(400,50,i));qarray_hist2(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_hist_east=qarray_hist2(eastint_forq:eastint_forq:end,2:eastint_forq:end,mjjasodays_hist);qarray_hist_east=cat(2,qarray_hist_east,NaN.*ones(455,1,nd));
                    clear qarray_hist2;
                    
                    qarray_histFINAL=cat(1,qarray_hist_west,qarray_hist_east);clear qarray_hist_west;clear qarray_hist_east;
                    invalid=abs(qarray_histFINAL)>400;qarray_histFINAL(invalid)=NaN;
                    invalid=abs(qarray_histFINAL)==0;qarray_histFINAL(invalid)=NaN;
                    %fprintf('For modelnum %d and expnum %d, size of qarray_histFINAL is %d\n',modelnum,expnum,size(qarray_histFINAL));
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'),'qarray_histFINAL','-v7.3');end
            

            %3) Net solar radiation
            if reread_arrays(modelnum,2,expnum,1)==1 && reread_arrays(modelnum,2,expnum,2)==1
                %East  
                if downloadedfromserver2(modelnum,2,expnum,2)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,2,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,2)==0
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'7565.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9075.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'10590.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_east=cat(1,rarray_hist3,rarray_hist2,rarray_hist1);clear rarray_hist1;clear rarray_hist2;clear rarray_hist3;
                else
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'7565.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'8075.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'8580.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9085.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist5=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9590.nc'),vname);
                        rarray_hist5=rarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist6=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'10095.nc'),vname);
                        rarray_hist6=rarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist7=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'105100.nc'),vname);
                        rarray_hist7=rarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_east=cat(1,rarray_hist7,rarray_hist6,rarray_hist5,rarray_hist4,rarray_hist3,rarray_hist2,rarray_hist1);
                    clear rarray_hist1;clear rarray_hist2;clear rarray_hist3;clear rarray_hist4;clear rarray_hist5;clear rarray_hist6;clear rarray_hist7;
                end

                %West
                if downloadedfromserver2(modelnum,2,expnum,1)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,2,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,1)==0
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'120105.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist5=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'125120.nc'),vname);
                        rarray_hist5=rarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_west=cat(1,rarray_hist5,rarray_hist4);clear rarray_hist4;clear rarray_hist5;
                else
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'110105.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'115110.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'120115.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'125120.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_west=cat(1,rarray_hist4,rarray_hist3,rarray_hist2,rarray_hist1);clear rarray_hist4;clear rarray_hist3;clear rarray_hist2;clear rarray_hist1;
                end

                rarray_histFINAL=cat(1,rarray_hist_west,rarray_hist_east);clear rarray_hist_west;clear rarray_hist_east;
                rarray_histFINAL=rarray_histFINAL(1:692,:,:);
                fprintf('For model %d and expnum %d, size of rarray_histFINAL is %d\n',modelnum,expnum,size(rarray_histFINAL,1));
            elseif reread_arrays(modelnum,2,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,2,expnum,1)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,2,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,1)==0
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'120105.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist5=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'125120.nc'),vname);
                        rarray_hist5=rarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_west=cat(1,rarray_hist5,rarray_hist4);clear rarray_hist4;clear rarray_hist5;
                else
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'110105.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'115110.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'120115.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'125120.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_west=cat(1,rarray_hist4,rarray_hist3,rarray_hist2,rarray_hist1);clear rarray_hist4;clear rarray_hist3;clear rarray_hist2;clear rarray_hist1;
                end
                %East    
                temp=load(strcat(dataloc,'historicalrsds',modelname,'easternus.mat'));rarray_hist_east=temp.saveddata; %Eastern US
                if size(rarray_hist_east,1)==237;eastint_forr=1;else;eastint_forr=1;end
                fprintf('For model %d and expnum %d, r value at 200,100 (East) is %0.2f\n',model,expnum,rarray_hist_east(200,100,1000));
                for i=1:382*25;if ~isnan(rarray_hist_east(400,50,i));rarray_hist_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                rarray_hist_east=rarray_hist_east(eastint_forr:eastint_forr:end,2:eastint_forr:end,mjjasodays_hist);rarray_hist_east=cat(2,rarray_hist_east,NaN.*ones(455,1,nd));

                rarray_histFINAL=cat(1,rarray_hist_west,rarray_hist_east);clear rarray_hist_west;clear rarray_hist_east;
                rarray_histFINAL=rarray_histFINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of rarray_histFINAL is %d\n',modelnum,expnum,size(rarray_histFINAL));
            elseif reread_arrays(modelnum,2,expnum,2)==1
                %East    
                if downloadedfromserver2(modelnum,2,expnum,2)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_historical');end
                if downloadedfromserver2(modelnum,2,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,2)==0
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'7565.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9075.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'10590.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_east=cat(1,rarray_hist3,rarray_hist2,rarray_hist1);clear rarray_hist1;clear rarray_hist2;clear rarray_hist3;
                else
                    rarray_hist1=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'7565.nc'),vname);
                        rarray_hist1=rarray_hist1(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist2=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'8075.nc'),vname);
                        rarray_hist2=rarray_hist2(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist3=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'8580.nc'),vname);
                        rarray_hist3=rarray_hist3(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist4=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9085.nc'),vname);
                        rarray_hist4=rarray_hist4(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist5=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'9590.nc'),vname);
                        rarray_hist5=rarray_hist5(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist6=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'10095.nc'),vname);
                        rarray_hist6=rarray_hist6(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist7=ncread(strcat(dataloc,'NEWhistoricalrsds',modelname,'105100.nc'),vname);
                        rarray_hist7=rarray_hist7(2:2:end,2:2:end,mjjasodays_hist);
                    rarray_hist_east=cat(1,rarray_hist7,rarray_hist6,rarray_hist5,rarray_hist4,rarray_hist3,rarray_hist2,rarray_hist1);
                    clear rarray_hist1;clear rarray_hist2;clear rarray_hist3;clear rarray_hist4;clear rarray_hist5;clear rarray_hist6;clear rarray_hist7;
                end
                %West
                temp=load(strcat(dataloc,'historicalrsds',modelname,'.mat'));rarray_hist_west=temp.saveddata; %Western US
                    if size(rarray_hist_west,1)==237;westint_forr=1;else;westint_forr=2;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (West) is %0.2f\n',model,expnum,rarray_hist_west(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_hist_west(1,1,i));rarray_hist_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_hist_west=rarray_hist_west(:,1:end-1,mjjasodays_hist);
                    if size(rarray_hist_west,1)==237
                        rarray_hist1=cat(2,NaN.*ones(237,59,nd),rarray_hist_west);rarray_hist1=cat(2,rarray_hist1,NaN.*ones(237,1,nd));
                    else
                        rarray_hist1=cat(2,NaN.*ones(474,119,nd),rarray_hist_west);
                    end
                    rarray_hist_west=rarray_hist1(westint_forr:westint_forr:end,westint_forr:westint_forr:end,:);clear rarray_hist1;

                rarray_histFINAL=cat(1,rarray_hist_west,rarray_hist_east);clear rarray_hist_west;clear rarray_hist_east;
                rarray_histFINAL=rarray_histFINAL(1:692,:,:);
                %fprintf('For model %d and expnum %d, size of rarray_histFINAL is %d\n',modelnum,expnum,size(rarray_histFINAL));
            else
                temp=load(strcat(dataloc,'historicalrsds',modelname,'.mat'));rarray_hist=temp.saveddata; %Western US
                    if size(rarray_hist,1)==237;westint_forr=1;else;westint_forr=2;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (West) is %0.2f\n',model,expnum,rarray_hist(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_hist(1,1,i));rarray_hist(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_hist=rarray_hist(:,1:end-1,mjjasodays_hist);
                    if size(rarray_hist,1)==237
                        rarray_hist1=cat(2,NaN.*ones(237,59,nd),rarray_hist);rarray_hist1=cat(2,rarray_hist1,NaN.*ones(237,1,nd));
                    else
                        rarray_hist1=cat(2,NaN.*ones(474,119,nd),rarray_hist);
                    end
                    rarray_hist_west=rarray_hist1(westint_forr:westint_forr:end,westint_forr:westint_forr:end,:);clear rarray_hist;
                temp=load(strcat(dataloc,'historicalrsds',modelname,'easternus.mat'));rarray_hist2=temp.saveddata; %Eastern US
                    if size(rarray_hist2,1)==237;eastint_forr=1;else;eastint_forr=1;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (East) is %0.2f\n',model,expnum,rarray_hist2(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_hist2(400,50,i));rarray_hist2(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_hist_east=rarray_hist2(eastint_forr:eastint_forr:end,2:eastint_forr:end,mjjasodays_hist);rarray_hist_east=cat(2,rarray_hist_east,NaN.*ones(455,1,nd));
                    clear rarray_hist2;

                    rarray_histFINAL=cat(1,rarray_hist_west,rarray_hist_east);clear rarray_hist_west;clear rarray_hist_east;
                    invalid=abs(rarray_histFINAL)>400;rarray_histFINAL(invalid)=NaN;
                    invalid=abs(rarray_histFINAL)==0;rarray_histFINAL(invalid)=NaN;
                    %fprintf('For model %d and expnum %d, size of rarray_histFINAL is %d\n',modelnum,expnum,size(rarray_histFINAL)); 
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'),'rarray_histFINAL','-v7.3');end
            

            %4) Environmental stress index and wet-bulb temperature
            disp('Calculating ESI for historical');
            rharray_histFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
                calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
                invalid=rharray_histFINAL>100;rharray_histFINAL(invalid)=NaN;qarray_histFINAL(invalid)=NaN;clear invalid; %10 sec

            twarray_histFINAL=calcwbtfromTandshum(tarray_histFINAL-273.15,qarray_histFINAL,1); %5 min

            esiarray_histFINAL=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_histFINAL+...
                                    0.0054.*((tarray_histFINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_histFINAL).^-1; %40 sec
                if savestuff==1
                save(strcat(dataloc,'rharrayhistfinal',modelname,'.mat'),'rharray_histFINAL','-v7.3'); %1 min
                save(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'),'esiarray_histFINAL','-v7.3'); %1 min
                save(strcat(dataloc,'twarrayhistfinal',modelname,'.mat'),'twarray_histFINAL','-v7.3'); %1 min
                end
                
                
                
                

                if mastertroubleshooting==0
                    clear rharray_histFINAL;clear rarray_histFINAL;clear twarray_histFINAL;clear esiarray_histFINAL;
                else
                    figure(494);clf;
                    subplot(3,2,1);plot(squeeze(tarray_histFINAL(54,165,:)));subplot(3,2,2);plot(squeeze(tarray_histFINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(tarray_histFINAL(254,165,:)));subplot(3,2,4);plot(squeeze(tarray_histFINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(tarray_histFINAL(454,165,:)));subplot(3,2,6);plot(squeeze(tarray_histFINAL(654,230,:)));
                    title(strcat('Historical T for model ',num2str(modelnum)));

                    figure(495);clf;
                    subplot(3,2,1);plot(squeeze(qarray_histFINAL(54,165,:)));subplot(3,2,2);plot(squeeze(qarray_histFINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(qarray_histFINAL(254,165,:)));subplot(3,2,4);plot(squeeze(qarray_histFINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(qarray_histFINAL(454,165,:)));subplot(3,2,6);plot(squeeze(qarray_histFINAL(654,230,:)));
                    title(strcat('Historical q for model ',num2str(modelnum)));

                    figure(496);clf;
                    subplot(3,2,1);plot(squeeze(rarray_histFINAL(54,165,:)));subplot(3,2,2);plot(squeeze(rarray_histFINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(rarray_histFINAL(254,165,:)));subplot(3,2,4);plot(squeeze(rarray_histFINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(rarray_histFINAL(454,165,:)));subplot(3,2,6);plot(squeeze(rarray_histFINAL(654,230,:)));
                    title(strcat('Historical r for model %d',num2str(modelnum)));
                    
                    figure(497);clf;imagescnan(squeeze(quantile(esiarray_histFINAL,0.99,3)));
                end

                
        elseif experiment==3 %RCP8.5
            %Interval is 1 for West US for variables with array dims of 237x233, vs an interval of 2 for array dims 474x466
            %Default interval is 1 for East and 2 for West
            if model==0
                eastussubtract=0;westussubtract=0;
            else %West US array dims are 474x466
                eastussubtract=0;westussubtract=0;
            end

            %1) Temperature
            if reread_arrays(modelnum,1,expnum,1)==1 && reread_arrays(modelnum,1,expnum,2)==1
                %East  
                if downloadedfromserver2(modelnum,1,expnum,2)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,1,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,2)==0
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'7565.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9075.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'10590.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_east=cat(1,tarray_rcp853,tarray_rcp852,tarray_rcp851);clear tarray_rcp851;clear tarray_rcp852;clear tarray_rcp853;
                else
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'7565.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'8075.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'8580.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9085.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp855=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9590.nc'),vname);
                        tarray_rcp855=tarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp856=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'10095.nc'),vname);
                        tarray_rcp856=tarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp857=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'105100.nc'),vname);
                        tarray_rcp857=tarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_east=cat(1,tarray_rcp857,tarray_rcp856,tarray_rcp855,tarray_rcp854,tarray_rcp853,tarray_rcp852,tarray_rcp851);
                    clear tarray_rcp851;clear tarray_rcp852;clear tarray_rcp853;clear tarray_rcp854;clear tarray_rcp855;clear tarray_rcp856;clear tarray_rcp857;
                end

                %West
                if downloadedfromserver2(modelnum,1,expnum,1)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,1,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,1)==0
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'120105.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp855=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'125120.nc'),vname);
                        tarray_rcp855=tarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_west=cat(1,tarray_rcp855,tarray_rcp854);clear tarray_rcp854;clear tarray_rcp855;
                else
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'110105.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'115110.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'120115.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'125120.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_west=cat(1,tarray_rcp854,tarray_rcp853,tarray_rcp852,tarray_rcp851);clear tarray_rcp854;clear tarray_rcp853;clear tarray_rcp852;clear tarray_rcp851;
                end

                tarray_rcp85FINAL=cat(1,tarray_rcp85_west,tarray_rcp85_east);clear tarray_rcp85_west;clear tarray_rcp85_east;
                tarray_rcp85FINAL=tarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of tarray_rcp85FINAL is %d\n',modelnum,expnum,size(tarray_rcp85FINAL));
            elseif reread_arrays(modelnum,1,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,1,expnum,1)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,1,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,1)==0
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'120105.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp855=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'125120.nc'),vname);
                        tarray_rcp855=tarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_west=cat(1,tarray_rcp855,tarray_rcp854);clear tarray_rcp854;clear tarray_rcp855;
                else
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'110105.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'115110.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'120115.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'125120.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_west=cat(1,tarray_rcp854,tarray_rcp853,tarray_rcp852,tarray_rcp851);clear tarray_rcp854;clear tarray_rcp853;clear tarray_rcp852;clear tarray_rcp851;
                end
                %East    
                temp=load(strcat(dataloc,'rcp85tasmax',modelname,'easternus.mat'));tarray_rcp85_east=temp.saveddata; %Eastern US
                if size(tarray_rcp85_east,1)==237;eastint_fort=1;else;eastint_fort=1;end
                fprintf('For model %d and expnum %d, T value at 200,100 (East) is %0.2f\n',model,expnum,tarray_rcp85_east(200,100,1000));
                for i=1:382*25;if ~isnan(tarray_rcp85_east(400,50,i));tarray_rcp85_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                tarray_rcp85_east=tarray_rcp85_east(eastint_fort:eastint_fort:end,2:eastint_fort:end,mjjasodays_rcp85);tarray_rcp85_east=cat(2,tarray_rcp85_east,NaN.*ones(455,1,nd));

                tarray_rcp85FINAL=cat(1,tarray_rcp85_west,tarray_rcp85_east);clear tarray_rcp85_west;clear tarray_rcp85_east;
                tarray_rcp85FINAL=tarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of tarray_rcp85FINAL is %d\n',modelnum,expnum,size(tarray_rcp85FINAL));
            elseif reread_arrays(modelnum,1,expnum,2)==1
                %East
                if downloadedfromserver2(modelnum,1,expnum,2)==1;vname='air_temperature';else;vname=strcat('tasmax_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,1,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,1,expnum,2)==0
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'7565.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9075.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'10590.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_east=cat(1,tarray_rcp853,tarray_rcp852,tarray_rcp851);clear tarray_rcp851;clear tarray_rcp852;clear tarray_rcp853;
                else
                    tarray_rcp851=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'7565.nc'),vname);
                        tarray_rcp851=tarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp852=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'8075.nc'),vname);
                        tarray_rcp852=tarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp853=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'8580.nc'),vname);
                        tarray_rcp853=tarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp854=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9085.nc'),vname);
                        tarray_rcp854=tarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp855=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'9590.nc'),vname);
                        tarray_rcp855=tarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp856=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'10095.nc'),vname);
                        tarray_rcp856=tarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp857=ncread(strcat(dataloc,'NEWrcp85tasmax',modelname,'105100.nc'),vname);
                        tarray_rcp857=tarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    tarray_rcp85_east=cat(1,tarray_rcp857,tarray_rcp856,tarray_rcp855,tarray_rcp854,tarray_rcp853,tarray_rcp852,tarray_rcp851);
                    clear tarray_rcp851;clear tarray_rcp852;clear tarray_rcp853;clear tarray_rcp854;clear tarray_rcp855;clear tarray_rcp856;clear tarray_rcp857;
                end
                %West
                temp=load(strcat(dataloc,'rcp85tasmax',modelname,'.mat'));tarray_rcp85_west=temp.saveddata; %Western US
                    if size(tarray_rcp85_west,1)==237;westint_fort=1;else;westint_fort=2;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (West) is %0.2f\n',model,expnum,tarray_rcp85_west(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_rcp85_west(1,1,i));tarray_rcp85_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_rcp85_west=tarray_rcp85_west(:,1:end-1,mjjasodays_rcp85);
                    if size(tarray_rcp85_west,1)==237
                        tarray_rcp851=cat(2,NaN.*ones(237,59,nd),tarray_rcp85_west);tarray_rcp851=cat(2,tarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        tarray_rcp851=cat(2,NaN.*ones(474,119,nd),tarray_rcp85_west);
                    end
                    tarray_rcp85_west=tarray_rcp851(westint_fort:westint_fort:end,westint_fort:westint_fort:end,:);clear tarray_rcp851;

                tarray_rcp85FINAL=cat(1,tarray_rcp85_west,tarray_rcp85_east);clear tarray_rcp85_west;clear tarray_rcp85_east;
                tarray_rcp85FINAL=tarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of tarray_rcp85FINAL is %d\n',modelnum,expnum,size(tarray_rcp85FINAL));
            else
                temp=load(strcat(dataloc,'rcp85tasmax',modelname,'.mat'));tarray_rcp85=temp.saveddata; %Western US
                    if size(tarray_rcp85,1)==237;westint_fort=1;else;westint_fort=2;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (West) is %0.2f\n',model,expnum,tarray_rcp85(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_rcp85(1,1,i));tarray_rcp85(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_rcp85=tarray_rcp85(:,1:end-1,mjjasodays_rcp85);
                    if size(tarray_rcp85,1)==237
                        tarray_rcp851=cat(2,NaN.*ones(237,59,nd),tarray_rcp85);tarray_rcp851=cat(2,tarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        tarray_rcp851=cat(2,NaN.*ones(474,119,nd),tarray_rcp85);
                    end
                    tarray_rcp85_west=tarray_rcp851(westint_fort:westint_fort:end,westint_fort:westint_fort:end,:);clear tarray_rcp85;
                temp=load(strcat(dataloc,'rcp85tasmax',modelname,'easternus.mat'));tarray_rcp852=temp.saveddata; %Eastern US
                    if size(tarray_rcp852,1)==237;eastint_fort=1;else;eastint_fort=1;end
                    fprintf('For model %d and expnum %d, T value at 200,100 (East) is %0.2f\n',model,expnum,tarray_rcp852(200,100,1000));
                    for i=1:382*25;if ~isnan(tarray_rcp852(400,50,i));tarray_rcp852(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    tarray_rcp85_east=tarray_rcp852(eastint_fort:eastint_fort:end,2:eastint_fort:end,mjjasodays_rcp85);tarray_rcp85_east=cat(2,tarray_rcp85_east,NaN.*ones(455,1,nd));
                    clear tarray_rcp852;

                    tarray_rcp85FINAL=cat(1,tarray_rcp85_west,tarray_rcp85_east);clear tarray_rcp85_west;clear tarray_rcp85_east;
                    invalid=abs(tarray_rcp85FINAL)>400;tarray_rcp85FINAL(invalid)=NaN;
                    invalid=abs(tarray_rcp85FINAL)==0;tarray_rcp85FINAL(invalid)=NaN;
                    %fprintf('For modelnum %d and expnum %d, size of tarray_rcp85FINAL is %d\n',modelnum,expnum,size(tarray_rcp85FINAL));
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'),'tarray_rcp85FINAL','-v7.3');end

                
            %2) Specific humidity
            if reread_arrays(modelnum,5,expnum,1)==1 && reread_arrays(modelnum,5,expnum,2)==1
                %East    
                if downloadedfromserver2(modelnum,5,expnum,2)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,5,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,2)==0
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'7565.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9075.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'10590.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_east=cat(1,qarray_rcp853,qarray_rcp852,qarray_rcp851);clear qarray_rcp851;clear qarray_rcp852;clear qarray_rcp853;
                else
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'7565.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'8075.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'8580.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9085.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp855=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9590.nc'),vname);
                        qarray_rcp855=qarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp856=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'10095.nc'),vname);
                        qarray_rcp856=qarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp857=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'105100.nc'),vname);
                        qarray_rcp857=qarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_east=cat(1,qarray_rcp857,qarray_rcp856,qarray_rcp855,qarray_rcp854,qarray_rcp853,qarray_rcp852,qarray_rcp851);
                    clear qarray_rcp851;clear qarray_rcp852;clear qarray_rcp853;clear qarray_rcp854;clear qarray_rcp855;clear qarray_rcp856;clear qarray_rcp857;
                end

                %West
                if downloadedfromserver2(modelnum,5,expnum,1)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,5,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,1)==0
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'120105.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp855=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'125120.nc'),vname);
                        qarray_rcp855=qarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_west=cat(1,qarray_rcp855,qarray_rcp854);clear qarray_rcp854;clear qarray_rcp855;
                else
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'110105.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'115110.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'120115.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'125120.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_west=cat(1,qarray_rcp854,qarray_rcp853,qarray_rcp852,qarray_rcp851);clear qarray_rcp854;clear qarray_rcp853;clear qarray_rcp852;clear qarray_rcp851;
                end

                qarray_rcp85FINAL=cat(1,qarray_rcp85_west,qarray_rcp85_east);clear qarray_rcp85_west;clear qarray_rcp85_east;
                qarray_rcp85FINAL=qarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_rcp85FINAL is %d\n',modelnum,expnum,size(qarray_rcp85FINAL));
            elseif reread_arrays(modelnum,5,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,5,expnum,1)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,5,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,1)==0
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'120105.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp855=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'125120.nc'),vname);
                        qarray_rcp855=qarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_west=cat(1,qarray_rcp855,qarray_rcp854);clear qarray_rcp854;clear qarray_rcp855;
                else
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'110105.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'115110.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'120115.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'125120.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_west=cat(1,qarray_rcp854,qarray_rcp853,qarray_rcp852,qarray_rcp851);clear qarray_rcp854;clear qarray_rcp853;clear qarray_rcp852;clear qarray_rcp851;
                end
                %East    
                temp=load(strcat(dataloc,'rcp85huss',modelname,'easternus.mat'));qarray_rcp85_east=temp.saveddata; %Eastern US
                if size(qarray_rcp85_east,1)==237;eastint_forq=1;else;eastint_forq=1;end
                fprintf('For model %d and expnum %d, q value at 200,100 (East) is %0.2f\n',model,expnum,qarray_rcp85_east(200,100,1000));
                for i=1:382*25;if ~isnan(qarray_rcp85_east(400,50,i));qarray_rcp85_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                qarray_rcp85_east=qarray_rcp85_east(eastint_forq:eastint_forq:end,2:eastint_forq:end,mjjasodays_rcp85);qarray_rcp85_east=cat(2,qarray_rcp85_east,NaN.*ones(455,1,nd));

                qarray_rcp85FINAL=cat(1,qarray_rcp85_west,qarray_rcp85_east);clear qarray_rcp85_west;clear qarray_rcp85_east;
                qarray_rcp85FINAL=qarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_rcp85FINAL is %d\n',modelnum,expnum,size(qarray_rcp85FINAL));
            elseif reread_arrays(modelnum,5,expnum,2)==1
                %East    
                if downloadedfromserver2(modelnum,5,expnum,2)==1;vname='specific_humidity';else;vname=strcat('huss_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,5,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,5,expnum,2)==0
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'7565.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9075.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'10590.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_east=cat(1,qarray_rcp853,qarray_rcp852,qarray_rcp851);clear qarray_rcp851;clear qarray_rcp852;clear qarray_rcp853;
                else
                    qarray_rcp851=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'7565.nc'),vname);
                        qarray_rcp851=qarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp852=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'8075.nc'),vname);
                        qarray_rcp852=qarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp853=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'8580.nc'),vname);
                        qarray_rcp853=qarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp854=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9085.nc'),vname);
                        qarray_rcp854=qarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp855=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'9590.nc'),vname);
                        qarray_rcp855=qarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp856=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'10095.nc'),vname);
                        qarray_rcp856=qarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp857=ncread(strcat(dataloc,'NEWrcp85huss',modelname,'105100.nc'),vname);
                        qarray_rcp857=qarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    qarray_rcp85_east=cat(1,qarray_rcp857,qarray_rcp856,qarray_rcp855,qarray_rcp854,qarray_rcp853,qarray_rcp852,qarray_rcp851);
                    clear qarray_rcp851;clear qarray_rcp852;clear qarray_rcp853;clear qarray_rcp854;clear qarray_rcp855;clear qarray_rcp856;clear qarray_rcp857;
                end
                %West
                temp=load(strcat(dataloc,'rcp85huss',modelname,'.mat'));qarray_rcp85_west=temp.saveddata; %Western US
                    if size(qarray_rcp85_west,1)==237;westint_forq=1;else;westint_forq=2;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (West) is %0.2f\n',model,expnum,qarray_rcp85_west(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_rcp85_west(1,1,i));qarray_rcp85_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_rcp85_west=qarray_rcp85_west(:,1:end-1,mjjasodays_rcp85);
                    if size(qarray_rcp85_west,1)==237
                        qarray_rcp851=cat(2,NaN.*ones(237,59,nd),qarray_rcp85_west);qarray_rcp851=cat(2,qarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        qarray_rcp851=cat(2,NaN.*ones(474,119,nd),qarray_rcp85_west);
                    end
                    qarray_rcp85_west=qarray_rcp851(westint_forq:westint_forq:end,westint_forq:westint_forq:end,:);clear qarray_rcp851;

                qarray_rcp85FINAL=cat(1,qarray_rcp85_west,qarray_rcp85_east);clear qarray_rcp85_west;clear qarray_rcp85_east;
                qarray_rcp85FINAL=qarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of qarray_rcp85FINAL is %d\n',modelnum,expnum,size(qarray_rcp85FINAL));
            else
                temp=load(strcat(dataloc,'rcp85huss',modelname,'.mat'));qarray_rcp85=temp.saveddata; %Western US
                    if size(qarray_rcp85,1)==237;westint_forq=1;else;westint_forq=2;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (West) is %0.2f\n',model,expnum,qarray_rcp85(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_rcp85(1,1,i));qarray_rcp85(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_rcp85=qarray_rcp85(:,1:end-1,mjjasodays_rcp85);
                    if size(qarray_rcp85,1)==237
                        qarray_rcp851=cat(2,NaN.*ones(237,59,nd),qarray_rcp85);qarray_rcp851=cat(2,qarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        qarray_rcp851=cat(2,NaN.*ones(474,119,nd),qarray_rcp85);
                    end
                    qarray_rcp85_west=qarray_rcp851(westint_forq:westint_forq:end,westint_forq:westint_forq:end,:);clear qarray_rcp85;
                temp=load(strcat(dataloc,'rcp85huss',modelname,'easternus.mat'));qarray_rcp852=temp.saveddata; %Eastern US
                    if size(qarray_rcp852,1)==237;eastint_forq=1;else;eastint_forq=1;end
                    fprintf('For model %d and expnum %d, q value at 200,100 (East) is %0.2f\n',model,expnum,qarray_rcp852(200,100,1000));
                    for i=1:382*25;if ~isnan(qarray_rcp852(400,50,i));qarray_rcp852(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    qarray_rcp85_east=qarray_rcp852(eastint_forq:eastint_forq:end,2:eastint_forq:end,mjjasodays_rcp85);qarray_rcp85_east=cat(2,qarray_rcp85_east,NaN.*ones(455,1,nd));
                    clear qarray_rcp852;
                    
                    qarray_rcp85FINAL=cat(1,qarray_rcp85_west,qarray_rcp85_east);clear qarray_rcp85_west;clear qarray_rcp85_east;
                    invalid=abs(qarray_rcp85FINAL)>400;qarray_rcp85FINAL(invalid)=NaN;
                    invalid=abs(qarray_rcp85FINAL)==0;qarray_rcp85FINAL(invalid)=NaN;
                    %fprintf('For modelnum %d and expnum %d, size of qarray_rcp85FINAL is %d\n',modelnum,expnum,size(qarray_rcp85FINAL));
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'),'qarray_rcp85FINAL','-v7.3');end
            

            %3) Net solar radiation
            if reread_arrays(modelnum,2,expnum,1)==1 && reread_arrays(modelnum,2,expnum,2)==1
                %East
                if downloadedfromserver2(modelnum,2,expnum,2)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,2,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,2)==0
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'7565.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9075.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'10590.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_east=cat(1,rarray_rcp853,rarray_rcp852,rarray_rcp851);clear rarray_rcp851;clear rarray_rcp852;clear rarray_rcp853;
                else
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'7565.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'8075.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'8580.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9085.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp855=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9590.nc'),vname);
                        rarray_rcp855=rarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp856=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'10095.nc'),vname);
                        rarray_rcp856=rarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp857=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'105100.nc'),vname);
                        rarray_rcp857=rarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_east=cat(1,rarray_rcp857,rarray_rcp856,rarray_rcp855,rarray_rcp854,rarray_rcp853,rarray_rcp852,rarray_rcp851);
                    clear rarray_rcp851;clear rarray_rcp852;clear rarray_rcp853;clear rarray_rcp854;clear rarray_rcp855;clear rarray_rcp856;clear rarray_rcp857;
                end

                %West
                if downloadedfromserver2(modelnum,2,expnum,1)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,2,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,1)==0
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'120105.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp855=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'125120.nc'),vname);
                        rarray_rcp855=rarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_west=cat(1,rarray_rcp855,rarray_rcp854);clear rarray_rcp854;clear rarray_rcp855;
                else
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'110105.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'115110.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'120115.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'125120.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_west=cat(1,rarray_rcp854,rarray_rcp853,rarray_rcp852,rarray_rcp851);clear rarray_rcp854;clear rarray_rcp853;clear rarray_rcp852;clear rarray_rcp851;
                end

                rarray_rcp85FINAL=cat(1,rarray_rcp85_west,rarray_rcp85_east);clear rarray_rcp85_west;clear rarray_rcp85_east;
                rarray_rcp85FINAL=rarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of rarray_rcp85FINAL is %d\n',modelnum,expnum,size(rarray_rcp85FINAL));
            elseif reread_arrays(modelnum,2,expnum,1)==1
                %West
                if downloadedfromserver2(modelnum,2,expnum,1)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,2,expnum,1)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,1)==0
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'120105.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp855=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'125120.nc'),vname);
                        rarray_rcp855=rarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_west=cat(1,rarray_rcp855,rarray_rcp854);clear rarray_rcp854;clear rarray_rcp855;
                else
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'110105.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'115110.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'120115.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'125120.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_west=cat(1,rarray_rcp854,rarray_rcp853,rarray_rcp852,rarray_rcp851);clear rarray_rcp854;clear rarray_rcp853;clear rarray_rcp852;clear rarray_rcp851;
                end
                %East    
                temp=load(strcat(dataloc,'rcp85rsds',modelname,'easternus.mat'));rarray_rcp85_east=temp.saveddata; %Eastern US
                if size(rarray_rcp85_east,1)==237;eastint_forr=1;else;eastint_forr=1;end
                fprintf('For model %d and expnum %d, r value at 200,100 (East) is %0.2f\n',model,expnum,rarray_rcp85_east(200,100,1000));
                for i=1:382*25;if ~isnan(rarray_rcp85_east(400,50,i));rarray_rcp85_east(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                rarray_rcp85_east=rarray_rcp85_east(eastint_forr:eastint_forr:end,2:eastint_forr:end,mjjasodays_rcp85);rarray_rcp85_east=cat(2,rarray_rcp85_east,NaN.*ones(455,1,nd));

                rarray_rcp85FINAL=cat(1,rarray_rcp85_west,rarray_rcp85_east);clear rarray_rcp85_west;clear rarray_rcp85_east;
                rarray_rcp85FINAL=rarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of rarray_rcp85FINAL is %d\n',modelnum,expnum,size(rarray_rcp85FINAL));
            elseif reread_arrays(modelnum,2,expnum,2)==1
                %East   
                if downloadedfromserver2(modelnum,2,expnum,2)==1;vname='surface_downwelling_shortwave_flux_in_air';else;vname=strcat('rsds_',modelname,'_r1i1p1_rcp85');end
                if downloadedfromserver2(modelnum,2,expnum,2)==0 && downloadedfromserver1ROUND2(modelnum,2,expnum,2)==0
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'7565.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9075.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'10590.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_east=cat(1,rarray_rcp853,rarray_rcp852,rarray_rcp851);clear rarray_rcp851;clear rarray_rcp852;clear rarray_rcp853;
                else
                    rarray_rcp851=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'7565.nc'),vname);
                        rarray_rcp851=rarray_rcp851(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp852=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'8075.nc'),vname);
                        rarray_rcp852=rarray_rcp852(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp853=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'8580.nc'),vname);
                        rarray_rcp853=rarray_rcp853(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp854=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9085.nc'),vname);
                        rarray_rcp854=rarray_rcp854(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp855=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'9590.nc'),vname);
                        rarray_rcp855=rarray_rcp855(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp856=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'10095.nc'),vname);
                        rarray_rcp856=rarray_rcp856(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp857=ncread(strcat(dataloc,'NEWrcp85rsds',modelname,'105100.nc'),vname);
                        rarray_rcp857=rarray_rcp857(2:2:end,2:2:end,mjjasodays_rcp85);
                    rarray_rcp85_east=cat(1,rarray_rcp857,rarray_rcp856,rarray_rcp855,rarray_rcp854,rarray_rcp853,rarray_rcp852,rarray_rcp851);
                    clear rarray_rcp851;clear rarray_rcp852;clear rarray_rcp853;clear rarray_rcp854;clear rarray_rcp855;clear rarray_rcp856;clear rarray_rcp857;
                end
                %West
                temp=load(strcat(dataloc,'rcp85rsds',modelname,'.mat'));rarray_rcp85_west=temp.saveddata; %Western US
                    if size(rarray_rcp85_west,1)==237;westint_forr=1;else;westint_forr=2;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (West) is %0.2f\n',model,expnum,rarray_rcp85_west(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_rcp85_west(1,1,i));rarray_rcp85_west(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_rcp85_west=rarray_rcp85_west(:,1:end-1,mjjasodays_rcp85);
                    if size(rarray_rcp85_west,1)==237
                        rarray_rcp851=cat(2,NaN.*ones(237,59,nd),rarray_rcp85_west);rarray_rcp851=cat(2,rarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        rarray_rcp851=cat(2,NaN.*ones(474,119,nd),rarray_rcp85_west);
                    end
                    rarray_rcp85_west=rarray_rcp851(westint_forr:westint_forr:end,westint_forr:westint_forr:end,:);clear rarray_rcp851;

                rarray_rcp85FINAL=cat(1,rarray_rcp85_west,rarray_rcp85_east);clear rarray_rcp85_west;clear rarray_rcp85_east;
                rarray_rcp85FINAL=rarray_rcp85FINAL(1:692,:,:);%fprintf('For modelnum %d and expnum %d, size of rarray_rcp85FINAL is %d\n',modelnum,expnum,size(rarray_rcp85FINAL));
            else
                temp=load(strcat(dataloc,'rcp85rsds',modelname,'.mat'));rarray_rcp85=temp.saveddata; %Western US
                    if size(rarray_rcp85,1)==237;westint_forr=1;else;westint_forr=2;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (West) is %0.2f\n',model,expnum,rarray_rcp85(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_rcp85(1,1,i));rarray_rcp85(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_rcp85=rarray_rcp85(:,1:end-1,mjjasodays_rcp85);
                    if size(rarray_rcp85,1)==237
                        rarray_rcp851=cat(2,NaN.*ones(237,59,nd),rarray_rcp85);rarray_rcp851=cat(2,rarray_rcp851,NaN.*ones(237,1,nd));
                    else
                        rarray_rcp851=cat(2,NaN.*ones(474,119,nd),rarray_rcp85);
                    end
                    rarray_rcp85_west=rarray_rcp851(westint_forr:westint_forr:end,westint_forr:westint_forr:end,:);clear rarray_rcp85;
                temp=load(strcat(dataloc,'rcp85rsds',modelname,'easternus.mat'));rarray_rcp852=temp.saveddata; %Eastern US
                    if size(rarray_rcp852,1)==237;eastint_forr=1;else;eastint_forr=1;end
                    fprintf('For model %d and expnum %d, r value at 200,100 (East) is %0.2f\n',model,expnum,rarray_rcp852(200,100,1000));
                    for i=1:382*25;if ~isnan(rarray_rcp852(400,50,i));rarray_rcp852(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                    rarray_rcp85_east=rarray_rcp852(eastint_forr:eastint_forr:end,2:eastint_forr:end,mjjasodays_rcp85);rarray_rcp85_east=cat(2,rarray_rcp85_east,NaN.*ones(455,1,nd));
                    clear rarray_rcp852;

                    rarray_rcp85FINAL=cat(1,rarray_rcp85_west,rarray_rcp85_east);clear rarray_rcp85_west;clear rarray_rcp85_east;
                    invalid=abs(rarray_rcp85FINAL)>400;rarray_rcp85FINAL(invalid)=NaN;
                    invalid=abs(rarray_rcp85FINAL)==0;rarray_rcp85FINAL(invalid)=NaN;
                    %fprintf('For modelnum %d and expnum %d, size of rarray_rcp85FINAL is %d\n',modelnum,expnum,size(rarray_rcp85FINAL));
            end
            %Save final result
            if savestuff==1;save(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'),'rarray_rcp85FINAL','-v7.3');end
            

            %4) Environmental stress index
            disp('Calculating ESI for future');
            rharray_rcp85FINAL=calcrhfromTanddewpt(tarray_rcp85FINAL-273.15,...
                calcTdfromq_dynamicP(qarray_rcp85FINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_rcp85FINAL))); %3 min
                invalid=rharray_rcp85FINAL>100;rharray_rcp85FINAL(invalid)=NaN;qarray_rcp85FINAL(invalid)=NaN;clear invalid; %10 sec

            twarray_rcp85FINAL=calcwbtfromTandshum(tarray_rcp85FINAL-273.15,qarray_rcp85FINAL,1); %5 min

            esiarray_rcp85FINAL=0.63.*(tarray_rcp85FINAL-273.15)-0.03.*rharray_rcp85FINAL+0.002.*rarray_rcp85FINAL+...
                                    0.0054.*((tarray_rcp85FINAL-273.15).*rharray_rcp85FINAL)-0.073.*(0.1*rarray_rcp85FINAL).^-1; %40 sec

                if savestuff==1
                save(strcat(dataloc,'rharrayrcp85final',modelname,'.mat'),'rharray_rcp85FINAL','-v7.3'); %4 min
                save(strcat(dataloc,'esiarrayrcp85final',modelname,'.mat'),'esiarray_rcp85FINAL','-v7.3'); %4 min
                save(strcat(dataloc,'twarrayrcp85final',modelname,'.mat'),'twarray_rcp85FINAL','-v7.3'); %4 min
                end

                if mastertroubleshooting==0
                    clear rharray_rcp85FINAL;clear rarray_rcp85FINAL;clear twarray_rcp85FINAL;clear esiarray_rcp85FINAL;
                else
                    %It takes 2 min to make the below figures:
                    figure(594);clf;
                    subplot(3,2,1);plot(squeeze(tarray_rcp85FINAL(54,165,:)));subplot(3,2,2);plot(squeeze(tarray_rcp85FINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(tarray_rcp85FINAL(254,165,:)));subplot(3,2,4);plot(squeeze(tarray_rcp85FINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(tarray_rcp85FINAL(454,165,:)));subplot(3,2,6);plot(squeeze(tarray_rcp85FINAL(654,230,:)));
                    title(strcat('rcp85 T for model ',num2str(modelnum)));

                    figure(595);clf;
                    subplot(3,2,1);plot(squeeze(qarray_rcp85FINAL(54,165,:)));subplot(3,2,2);plot(squeeze(qarray_rcp85FINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(qarray_rcp85FINAL(254,165,:)));subplot(3,2,4);plot(squeeze(qarray_rcp85FINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(qarray_rcp85FINAL(454,165,:)));subplot(3,2,6);plot(squeeze(qarray_rcp85FINAL(654,230,:)));
                    title(strcat('rcp85 q for model ',num2str(modelnum)));

                    figure(596);clf;
                    subplot(3,2,1);plot(squeeze(rarray_rcp85FINAL(54,165,:)));subplot(3,2,2);plot(squeeze(rarray_rcp85FINAL(154,165,:)));
                    subplot(3,2,3);plot(squeeze(rarray_rcp85FINAL(254,165,:)));subplot(3,2,4);plot(squeeze(rarray_rcp85FINAL(354,165,:)));
                    subplot(3,2,5);plot(squeeze(rarray_rcp85FINAL(454,165,:)));subplot(3,2,6);plot(squeeze(rarray_rcp85FINAL(654,230,:)));
                    title(strcat('rcp85 r for model ',num2str(modelnum)));
                    
                    figure(694);clf;imagescnan(squeeze(quantile(tarray_rcp85FINAL,0.99,3))-squeeze(quantile(tarray_histFINAL,0.99,3)));
                        title(strcat('t diff for model ',num2str(modelnum)));
                    figure(695);clf;imagescnan(squeeze(quantile(qarray_rcp85FINAL,0.99,3))-squeeze(quantile(qarray_histFINAL,0.99,3)));
                        title(strcat('q diff for model ',num2str(modelnum)));
                    figure(696);clf;imagescnan(squeeze(quantile(rarray_rcp85FINAL,0.99,3))-squeeze(quantile(rarray_histFINAL,0.99,3)));
                        title(strcat('r diff for model ',num2str(modelnum)));
                        
                    figure(794);clf;imagescnan(squeeze(quantile(tarray_histFINAL,0.99,3)));
                        title(strcat('t hist for model ',num2str(modelnum)));
                    figure(795);clf;imagescnan(squeeze(quantile(qarray_histFINAL,0.99,3)));
                        title(strcat('q hist for model ',num2str(modelnum)));
                    figure(796);clf;imagescnan(squeeze(quantile(rarray_histFINAL,0.99,3)));
                        title(strcat('r hist for model ',num2str(modelnum)));
                        
                    figure(894);clf;imagescnan(squeeze(quantile(tarray_rcp85FINAL,0.99,3)));
                        title(strcat('t rcp85 for model ',num2str(modelnum)));
                    figure(895);clf;imagescnan(squeeze(quantile(qarray_rcp85FINAL,0.99,3)));
                        title(strcat('q rcp85 for model ',num2str(modelnum)));
                    figure(896);clf;imagescnan(squeeze(quantile(rarray_rcp85FINAL,0.99,3)));
                        title(strcat('r rcp85 for model ',num2str(modelnum)));
                    
                    figure(998);clf;imagescnan(squeeze(quantile(esiarray_rcp85FINAL,0.99,3)));
                        title(strcat('rcp85 esi for model ',num2str(modelnum)));
                    figure(999);clf;imagescnan(squeeze(quantile(esiarray_rcp85FINAL,0.99,3))-squeeze(quantile(esiarray_histFINAL,0.99,3)));
                        title(strcat('esi diff for model ',num2str(modelnum)));
                end
        end  
    end
end


clear qarray_hist1;clear rarray_hist1;
clear qarray_rcp851;clear rarray_rcp851;

