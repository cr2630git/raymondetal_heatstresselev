for modelnum=1:20
        model=models(modelnum);
        modelname=MODEL_NAME{model};
        
        disp(clock);
        for expnum=1:2
            experiment=exps(expnum);
            expname=EXP_NAME{experiment};
            for loop=1:5
                daystart=loop*1000-999;dayend=loop*1000;dayshere=1000;if loop==5;dayend=4810;dayshere=810;end


                if expnum==1
                elseif expnum==2
                    if radiationonly==0
                    tbypoint(:,:,daystart:dayend)=eval(['tarray_rcp85FINAL_shrunken' num2str(loop) ';']);
                    qbypoint(:,:,daystart:dayend)=eval(['qarray_rcp85FINAL_shrunken' num2str(loop) ';']);
                    end
                    rbypoint(:,:,daystart:dayend)=eval(['rarray_rcp85FINAL_shrunken' num2str(loop) ';']);

                    esibypoint(:,:,daystart:dayend)=eval(['esiNEW' num2str(loop) ';']);
                end
            end
            
            if radiationonly==0
                tbypointp99=NaN.*ones(size(tbypoint,1),size(tbypoint,2));
                qbypointp99=NaN.*ones(size(tbypoint,1),size(tbypoint,2));
                esibypointp99=NaN.*ones(size(esibypoint,1),size(esibypoint,2));
                if sum(sum(sum(tbypoint==0)))>0;invalid=tbypoint==0;tbypoint(invalid)=NaN;end
                if sum(sum(sum(qbypoint==0)))>0;invalid=qbypoint==0;qbypoint(invalid)=NaN;end
                if sum(sum(sum(esibypoint==0)))>0;invalid=esibypoint==0;esibypoint(invalid)=NaN;end
            end
            rbypointp99=NaN.*ones(size(rbypoint,1),size(rbypoint,2));
            if sum(sum(sum(rbypoint==0)))>0;invalid=rbypoint==0;rbypoint(invalid)=NaN;end

            clear invalid;

            for i=1:dim1size
                for j=1:dim2size
                    if sum(~isnan(squeeze(rbypoint(i,j,:))))>100
                        if radiationonly==0
                            tbypointp99(i,j)=quantile(squeeze(tbypoint(i,j,:)),0.99);
                            qbypointp99(i,j)=quantile(squeeze(qbypoint(i,j,:)),0.99);
                            esibypointp99(i,j)=quantile(squeeze(esibypoint(i,j,:)),0.99);
                        end
                        rbypointp99(i,j)=quantile(squeeze(rbypoint(i,j,:)),0.99);
                    end
                end
                if rem(i,50)==0;fprintf('In computation of bypointp99 arrays, i is %d of %d\n',i,size(rbypoint,1));disp(clock);end
            end
            
            invalid=isnan(macaelevFINAL);tbypointp99(macaelevFINAL)=NaN;qbypointp99(macaelevFINAL)=NaN;rbypointp99(macaelevFINAL)=NaN;esibypointp99(macaelevFINAL)=NaN;


            fprintf('Just completed calculation for exp %s and model %s\n',expname,modelname);disp(clock);

            if experiment==1
                if radiationonly==0
                    p99tbypoint_hist(model,:,:)=tbypointp99;
                    p99qbypoint_hist(model,:,:)=qbypointp99;
                    p99esibypoint_hist(model,:,:)=esibypointp99;
                end
                p99rbypoint_hist(model,:,:)=rbypointp99;
                save('/Volumes/ExternalDriveD/MACA_Projections/twbypointresults.mat',...
                    'p99tbypoint_hist','p99qbypoint_hist','p99rbypoint_hist','p99esibypoint_hist','-append');
            elseif experiment==3
                p99tbypoint_rcp85(model,:,:)=tbypointp99;
                p99qbypoint_rcp85(model,:,:)=qbypointp99;
                p99rbypoint_rcp85(model,:,:)=rbypointp99;
                p99esibypoint_rcp85(model,:,:)=esibypointp99;
                save('/Volumes/ExternalDriveD/MACA_Projections/twbypointresults.mat',...
                    'p99tbypoint_rcp85','p99qbypoint_rcp85','p99rbypoint_rcp85','p99esibypoint_rcp85','-append');
            end
        end
    end