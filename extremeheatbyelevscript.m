for modelnum=maincalcmodelstart:maincalcmodelstop
    model=models(modelnum);
    modelname=MODEL_NAME{model};

    for expnum=maincalcexpstart:maincalcexpstop
        experiment=exps(expnum);
        expname=EXP_NAME{experiment};
         
        p99esi=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_nw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_nw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_nw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_sw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_sw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_sw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_ngp=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_ngp=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_ngp=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_sgp=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_sgp=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_sgp=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_mw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_mw=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_mw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_se=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_se=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_se=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_histt_ne=NaN.*ones(size(elevcutoffs,2),1);p99esi_histq_ne=NaN.*ones(size(elevcutoffs,2),1);p99esi_histr_ne=NaN.*ones(size(elevcutoffs,2),1);
        p99tw=NaN.*ones(size(elevcutoffs,2),1);
        p99t=NaN.*ones(size(elevcutoffs,2),1);p99q=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_nw=NaN.*ones(size(elevcutoffs,2),1);p99tw_nw=NaN.*ones(size(elevcutoffs,2),1);
        p99t_nw=NaN.*ones(size(elevcutoffs,2),1);p99q_nw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_sw=NaN.*ones(size(elevcutoffs,2),1);p99tw_sw=NaN.*ones(size(elevcutoffs,2),1);
        p99t_sw=NaN.*ones(size(elevcutoffs,2),1);p99q_sw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_ngp=NaN.*ones(size(elevcutoffs,2),1);p99tw_ngp=NaN.*ones(size(elevcutoffs,2),1);
        p99t_ngp=NaN.*ones(size(elevcutoffs,2),1);p99q_ngp=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_sgp=NaN.*ones(size(elevcutoffs,2),1);p99tw_sgp=NaN.*ones(size(elevcutoffs,2),1);
        p99t_sgp=NaN.*ones(size(elevcutoffs,2),1);p99q_sgp=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_mw=NaN.*ones(size(elevcutoffs,2),1);p99tw_mw=NaN.*ones(size(elevcutoffs,2),1);
        p99t_mw=NaN.*ones(size(elevcutoffs,2),1);p99q_mw=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_se=NaN.*ones(size(elevcutoffs,2),1);p99tw_se=NaN.*ones(size(elevcutoffs,2),1);
        p99t_se=NaN.*ones(size(elevcutoffs,2),1);p99q_se=NaN.*ones(size(elevcutoffs,2),1);
        p99esi_ne=NaN.*ones(size(elevcutoffs,2),1);p99tw_ne=NaN.*ones(size(elevcutoffs,2),1);
        p99t_ne=NaN.*ones(size(elevcutoffs,2),1);p99q_ne=NaN.*ones(size(elevcutoffs,2),1);
        p99r=NaN.*ones(size(elevcutoffs,2),1);
        p99r_nw=NaN.*ones(size(elevcutoffs,2),1);p99r_sw=NaN.*ones(size(elevcutoffs,2),1);p99r_ngp=NaN.*ones(size(elevcutoffs,2),1);
        p99r_sgp=NaN.*ones(size(elevcutoffs,2),1);p99r_mw=NaN.*ones(size(elevcutoffs,2),1);
        p99r_se=NaN.*ones(size(elevcutoffs,2),1);p99r_ne=NaN.*ones(size(elevcutoffs,2),1);


        fprintf('At line 41 of extremeheatbyelevscript for model %d and exp %d\n',modelnum,expnum);disp(clock);

        for varloop=varstart:varstop %T, q, r, Tw, ESI
            if experiment==1
                if varloop==1
                    temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL; %1.5 min
                    invalid=tarray_histFINAL<200;tarray_histFINAL(invalid)=NaN;
                elseif varloop==2
                    temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL; %1.5 min
                elseif varloop==3
                    temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL; %1.5 min
                elseif varloop==4
                    temp=load(strcat(dataloc,'twarrayhistfinal',modelname,'.mat'));twarray_histFINAL=temp.twarray_histFINAL; %1.5 min
                elseif varloop==5
                    temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL; %1.5 min
                    invalid=esiarray_histFINAL<-100;esiarray_histFINAL(invalid)=NaN;
                end
            elseif experiment==3
                if varloop==1
                    temp=load(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'));tarray_rcp85FINAL=temp.tarray_rcp85FINAL;clear temp; %1.5 min
                elseif varloop==2
                    temp=load(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'));qarray_rcp85FINAL=temp.qarray_rcp85FINAL;clear temp; %1.5 min
                elseif varloop==3
                    temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_rcp85FINAL=temp.rarray_rcp85FINAL;clear temp; %1.5 min
                elseif varloop==4
                    temp=load(strcat(dataloc,'twarrayrcp85final',modelname,'.mat'));twarray_rcp85FINAL=temp.twarray_rcp85FINAL;clear temp; %1.5 min
                elseif varloop==5
                    temp=load(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'));tarray_rcp85FINAL=temp.tarray_rcp85FINAL;clear temp;
                    temp=load(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'));qarray_rcp85FINAL=temp.qarray_rcp85FINAL;clear temp;
                    temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_rcp85FINAL=temp.rarray_rcp85FINAL;clear temp;
                    temp=load(strcat(dataloc,'rharrayrcp85final',modelname,'.mat'));rharray_rcp85FINAL=temp.rharray_rcp85FINAL;clear temp;
                    if donormalpart==1
                    temp=load(strcat(dataloc,'esiarrayrcp85final',modelname,'.mat'));esiarray_rcp85FINAL=temp.esiarray_rcp85FINAL;clear temp;
                    invalid=esiarray_rcp85FINAL<-100;esiarray_rcp85FINAL(invalid)=NaN;
                    end
                    
                    temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL; %1.5 min
                    temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL; %1.5 min
                    temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL; %1.5 min

                    rharray_histtFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
                        calcTdfromq_dynamicP(qarray_rcp85FINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
                    invalid=rharray_histtFINAL>150;rharray_histtFINAL(invalid)=NaN;invalid=rharray_histtFINAL<=0;rharray_histtFINAL(invalid)=NaN;clear invalid; %10 sec
                    rharray_histqFINAL=calcrhfromTanddewpt(tarray_rcp85FINAL-273.15,...
                        calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_rcp85FINAL)));clear qarray_histFINAL; %3 min
                        invalid=rharray_histqFINAL>150;rharray_histqFINAL(invalid)=NaN;invalid=rharray_histqFINAL<=0;rharray_histqFINAL(invalid)=NaN;clear invalid; %10 sec

                    esiarray_histtFINAL=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histtFINAL+0.002.*rarray_rcp85FINAL+...
                                            0.0054.*((tarray_histFINAL-273.15).*rharray_histtFINAL)-0.073.*(0.1*rarray_rcp85FINAL).^-1;clear rharray_histtFINAL;clear tarray_histFINAL; %40 sec
                        invalid=esiarray_histtFINAL==0;esiarray_histtFINAL(invalid)=NaN;
                    esiarray_histqFINAL=0.63.*(tarray_rcp85FINAL-273.15)-0.03.*rharray_histqFINAL+0.002.*rarray_rcp85FINAL+...
                                            0.0054.*((tarray_rcp85FINAL-273.15).*rharray_histqFINAL)-0.073.*(0.1*rarray_rcp85FINAL).^-1;clear rharray_histqFINAL; %40 sec
                        invalid=esiarray_histqFINAL==0;esiarray_histqFINAL(invalid)=NaN;
                    esiarray_histrFINAL=0.63.*(tarray_rcp85FINAL-273.15)-0.03.*rharray_rcp85FINAL+0.002.*rarray_histFINAL+...
                                            0.0054.*((tarray_rcp85FINAL-273.15).*rharray_rcp85FINAL)-0.073.*(0.1*rarray_histFINAL).^-1;clear rharray_rcp85FINAL;clear rarray_histFINAL; %40 sec
                        invalid=esiarray_histrFINAL==0;esiarray_histrFINAL(invalid)=NaN;clear invalid;
                    if varstart>=2;clear tarray_rcp85FINAL;end
                    if varstop<=1 || varstart>=3;clear qarray_rcp85FINAL;end
                    if varstop<=2 || varstart>=4;clear rarray_rcp85FINAL;end
                end
            end


            disp('Starting elevation loop');disp(clock);
            for eb=1:size(elevcutoffs,2)-1
                %Nationally
                pointsinthisbin=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1);
                pointsinthisbin2=repmat(pointsinthisbin,[1 1 nd]);clear pointsinthisbin;

                if experiment==1
                    if varloop==1
                        p99t(eb)=quantile(tarray_histFINAL(pointsinthisbin2),0.99);
                    elseif varloop==2
                        p99q(eb)=quantile(qarray_histFINAL(pointsinthisbin2),0.99);
                    elseif varloop==3
                        p99r(eb)=quantile(rarray_histFINAL(pointsinthisbin2),0.99);
                    elseif varloop==4
                        p99tw(eb)=quantile(twarray_histFINAL(pointsinthisbin2),0.99);
                    elseif varloop==5
                        p99esi(eb)=quantile(esiarray_histFINAL(pointsinthisbin2),0.99);
                    end
                elseif experiment==3
                    if varloop==1
                        p99t(eb)=quantile(tarray_rcp85FINAL(pointsinthisbin2),0.99);
                    elseif varloop==2
                        p99q(eb)=quantile(qarray_rcp85FINAL(pointsinthisbin2),0.99);
                    elseif varloop==3
                        p99r(eb)=quantile(rarray_rcp85FINAL(pointsinthisbin2),0.99);
                    elseif varloop==4
                        p99tw(eb)=quantile(twarray_rcp85FINAL(pointsinthisbin2),0.99);
                    elseif varloop==5
                        if donormalpart==1;p99esi(eb)=quantile(esiarray_rcp85FINAL(pointsinthisbin2),0.99);end
                        p99esi_histt(eb)=quantile(esiarray_histtFINAL(pointsinthisbin2),0.99);
                        p99esi_histq(eb)=quantile(esiarray_histqFINAL(pointsinthisbin2),0.99);
                        p99esi_histr(eb)=quantile(esiarray_histrFINAL(pointsinthisbin2),0.99);
                    end
                end
                clear pointsinthisbin2;
                


                %By NCA region
                for regloop=1:7                    
                    pointsinthisbinandreg=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1) & macaregions==regloop+1;
                    pointsinthisbinandreg2=repmat(pointsinthisbinandreg,[1 1 nd]);clear pointsinthisbinandreg;

                    if experiment==1
                        if varloop==1
                            p99there=quantile(tarray_histFINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==2
                            p99qhere=quantile(qarray_histFINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==3
                            p99rhere=quantile(rarray_histFINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==4
                            p99twhere=quantile(twarray_histFINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==5
                            p99esihere=quantile(esiarray_histFINAL(pointsinthisbinandreg2),0.99);
                        end
                    elseif experiment==3
                        if varloop==1
                            p99there=quantile(tarray_rcp85FINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==2
                            p99qhere=quantile(qarray_rcp85FINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==3
                            p99rhere=quantile(rarray_rcp85FINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==4
                            p99twhere=quantile(twarray_rcp85FINAL(pointsinthisbinandreg2),0.99);
                        elseif varloop==5
                            if donormalpart==1;p99esihere=quantile(esiarray_rcp85FINAL(pointsinthisbinandreg2),0.99);end
                                p99esi_histthere=quantile(esiarray_histtFINAL(pointsinthisbinandreg2),0.99);
                                p99esi_histqhere=quantile(esiarray_histqFINAL(pointsinthisbinandreg2),0.99);
                                p99esi_histrhere=quantile(esiarray_histrFINAL(pointsinthisbinandreg2),0.99);
                        end
                    end
                    clear pointsinthisbinandreg2;

                    if regloop==1
                        if varloop==1;p99t_nw(eb)=p99there;elseif varloop==2;p99q_nw(eb)=p99qhere;elseif varloop==3;p99r_nw(eb)=p99rhere;
                        elseif varloop==4;p99tw_nw(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_nw(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_nw(eb)=p99esi_histthere;p99esi_histq_nw(eb)=p99esi_histqhere;p99esi_histr_nw(eb)=p99esi_histrhere;
                        end
                    elseif regloop==2
                        if varloop==1;p99t_sw(eb)=p99there;elseif varloop==2;p99q_sw(eb)=p99qhere;elseif varloop==3;p99r_sw(eb)=p99rhere;
                        elseif varloop==4;p99tw_sw(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_sw(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_sw(eb)=p99esi_histthere;p99esi_histq_sw(eb)=p99esi_histqhere;p99esi_histr_sw(eb)=p99esi_histrhere;
                        end
                    elseif regloop==3
                        if varloop==1;p99t_ngp(eb)=p99there;elseif varloop==2;p99q_ngp(eb)=p99qhere;elseif varloop==3;p99r_ngp(eb)=p99rhere;
                        elseif varloop==4;p99tw_ngp(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_ngp(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_ngp(eb)=p99esi_histthere;p99esi_histq_ngp(eb)=p99esi_histqhere;p99esi_histr_ngp(eb)=p99esi_histrhere;
                        end
                    elseif regloop==4
                        if varloop==1;p99t_sgp(eb)=p99there;elseif varloop==2;p99q_sgp(eb)=p99qhere;elseif varloop==3;p99r_sgp(eb)=p99rhere;
                        elseif varloop==4;p99tw_sgp(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_sgp(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_sgp(eb)=p99esi_histthere;p99esi_histq_sgp(eb)=p99esi_histqhere;p99esi_histr_sgp(eb)=p99esi_histrhere;
                        end
                    elseif regloop==5
                        if varloop==1;p99t_mw(eb)=p99there;elseif varloop==2;p99q_mw(eb)=p99qhere;elseif varloop==3;p99r_mw(eb)=p99rhere;
                        elseif varloop==4;p99tw_mw(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_mw(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_mw(eb)=p99esi_histthere;p99esi_histq_mw(eb)=p99esi_histqhere;p99esi_histr_mw(eb)=p99esi_histrhere;
                        end
                    elseif regloop==6
                        if varloop==1;p99t_se(eb)=p99there;elseif varloop==2;p99q_se(eb)=p99qhere;elseif varloop==3;p99r_se(eb)=p99rhere;
                        elseif varloop==4;p99tw_se(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_se(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_se(eb)=p99esi_histthere;p99esi_histq_se(eb)=p99esi_histqhere;p99esi_histr_se(eb)=p99esi_histrhere;
                        end
                    elseif regloop==7
                        if varloop==1;p99t_ne(eb)=p99there;elseif varloop==2;p99q_ne(eb)=p99qhere;elseif varloop==3;p99r_ne(eb)=p99rhere;
                        elseif varloop==4;p99tw_ne(eb)=p99twhere;elseif varloop==5 && donormalpart==1;p99esi_ne(eb)=p99esihere;end
                        if varloop==5 && experiment==3
                            p99esi_histt_ne(eb)=p99esi_histthere;p99esi_histq_ne(eb)=p99esi_histqhere;p99esi_histr_ne(eb)=p99esi_histrhere;
                        end
                    end
                end

                if rem(eb,5)==0;disp(eb);disp(clock);end
            end
            fprintf('Completed varloop %d\n',varloop);disp(clock);
            clear esiarray_histFINAL;clear twarray_histFINAL;clear tarray_histFINAL;clear qarray_histFINAL;clear rarray_histFINAL;
            clear esiarray_rcp85FINAL;clear twarray_rcp85FINAL;clear tarray_rcp85FINAL;clear qarray_rcp85FINAL;clear rarray_rcp85FINAL;
            clear esiarray_histtFINAL;clear esiarray_histqFINAL;clear esiarray_histrFINAL;
        end
             
            

        if experiment==1
            if varstart<=4 && varstop>=4;p99tw_hist(model,1:size(elevcutoffs,2))=squeeze(p99tw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist(model,1:size(elevcutoffs,2))=squeeze(p99esi(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist)>1000;p99esi_hist(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist(model,1:size(elevcutoffs,2))=squeeze(p99t(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist(model,1:size(elevcutoffs,2))=squeeze(p99q(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_nw(model,1:size(elevcutoffs,2))=squeeze(p99tw_nw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_nw(model,1:size(elevcutoffs,2))=squeeze(p99esi_nw(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_nw)>1000;p99esi_hist_nw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_nw(model,1:size(elevcutoffs,2))=squeeze(p99t_nw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_nw(model,1:size(elevcutoffs,2))=squeeze(p99q_nw(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_sw(model,1:size(elevcutoffs,2))=squeeze(p99tw_sw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_sw(model,1:size(elevcutoffs,2))=squeeze(p99esi_sw(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_sw)>1000;p99esi_hist_sw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_sw(model,1:size(elevcutoffs,2))=squeeze(p99t_sw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_sw(model,1:size(elevcutoffs,2))=squeeze(p99q_sw(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_ngp(model,1:size(elevcutoffs,2))=squeeze(p99tw_ngp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_ngp(model,1:size(elevcutoffs,2))=squeeze(p99esi_ngp(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_ngp)>1000;p99esi_hist_ngp(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_ngp(model,1:size(elevcutoffs,2))=squeeze(p99t_ngp(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_ngp(model,1:size(elevcutoffs,2))=squeeze(p99q_ngp(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_sgp(model,1:size(elevcutoffs,2))=squeeze(p99tw_sgp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_sgp(model,1:size(elevcutoffs,2))=squeeze(p99esi_sgp(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_sgp)>1000;p99esi_hist_sgp(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_sgp(model,1:size(elevcutoffs,2))=squeeze(p99t_sgp(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_sgp(model,1:size(elevcutoffs,2))=squeeze(p99q_sgp(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_mw(model,1:size(elevcutoffs,2))=squeeze(p99tw_mw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_mw(model,1:size(elevcutoffs,2))=squeeze(p99esi_mw(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_mw)>1000;p99esi_hist_mw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_mw(model,1:size(elevcutoffs,2))=squeeze(p99t_mw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_mw(model,1:size(elevcutoffs,2))=squeeze(p99q_mw(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_se(model,1:size(elevcutoffs,2))=squeeze(p99tw_se(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_se(model,1:size(elevcutoffs,2))=squeeze(p99esi_se(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_se)>1000;p99esi_hist_se(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_se(model,1:size(elevcutoffs,2))=squeeze(p99t_se(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_se(model,1:size(elevcutoffs,2))=squeeze(p99q_se(1:size(elevcutoffs,2)));end

            if varstart<=4 && varstop>=4;p99tw_hist_ne(model,1:size(elevcutoffs,2))=squeeze(p99tw_ne(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_hist_ne(model,1:size(elevcutoffs,2))=squeeze(p99esi_ne(1:size(elevcutoffs,2)));invalid=abs(p99esi_hist_ne)>1000;p99esi_hist_ne(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_hist_ne(model,1:size(elevcutoffs,2))=squeeze(p99t_ne(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_hist_ne(model,1:size(elevcutoffs,2))=squeeze(p99q_ne(1:size(elevcutoffs,2)));end

            if varstart<=3 && varstop>=3
            p99r_hist(model,1:size(elevcutoffs,2))=squeeze(p99r(1:size(elevcutoffs,2)));
            p99r_hist_nw(model,1:size(elevcutoffs,2))=squeeze(p99r_nw(1:size(elevcutoffs,2)));
            p99r_hist_sw(model,1:size(elevcutoffs,2))=squeeze(p99r_sw(1:size(elevcutoffs,2)));
            p99r_hist_ngp(model,1:size(elevcutoffs,2))=squeeze(p99r_ngp(1:size(elevcutoffs,2)));
            p99r_hist_sgp(model,1:size(elevcutoffs,2))=squeeze(p99r_sgp(1:size(elevcutoffs,2)));
            p99r_hist_mw(model,1:size(elevcutoffs,2))=squeeze(p99r_mw(1:size(elevcutoffs,2)));
            p99r_hist_se(model,1:size(elevcutoffs,2))=squeeze(p99r_se(1:size(elevcutoffs,2)));
            p99r_hist_ne(model,1:size(elevcutoffs,2))=squeeze(p99r_ne(1:size(elevcutoffs,2)));
            end

            if varstart<=1 && varstop>=1
                save(strcat(dataloc,'twresults.mat'),...
                    'p99t_hist','p99t_hist_nw','p99t_hist_sw','p99t_hist_ngp','p99t_hist_sgp','p99t_hist_mw','p99t_hist_se','p99t_hist_ne','-append');
            end
            if varstart<=2 && varstop>=2
                save(strcat(dataloc,'twresults.mat'),...
                    'p99q_hist','p99q_hist_nw','p99q_hist_sw','p99q_hist_ngp','p99q_hist_sgp','p99q_hist_mw','p99q_hist_se','p99q_hist_ne','-append');
            end
            if varstart<=3 && varstop>=3
                save(strcat(dataloc,'twresults.mat'),...
                    'p99r_hist','p99r_hist_nw','p99r_hist_sw','p99r_hist_ngp','p99r_hist_sgp','p99r_hist_mw','p99r_hist_se','p99r_hist_ne','-append');
            end
            if varstart<=4 && varstop>=4
                save(strcat(dataloc,'twresults.mat'),...
                    'p99tw_hist','p99tw_hist_nw','p99tw_hist_sw','p99tw_hist_ngp','p99tw_hist_sgp','p99tw_hist_mw','p99tw_hist_se','p99tw_hist_ne','-append');
            end
            if varstart<=5 && varstop>=5  && donormalpart==1
                save(strcat(dataloc,'twresults.mat'),...
                    'p99esi_hist','p99esi_hist_nw','p99esi_hist_sw','p99esi_hist_ngp','p99esi_hist_sgp','p99esi_hist_mw','p99esi_hist_se','p99esi_hist_ne','-append');
            end
            
            outputtowrite=[expnum modelnum];
            dlmwrite(strcat(dataloc,'twresults_LASTSAVED.txt'),outputtowrite);
        elseif experiment==3
            if varstart<=4 && varstop>=4;p99tw_rcp85(model,1:size(elevcutoffs,2))=squeeze(p99tw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85(model,1:size(elevcutoffs,2))=squeeze(p99esi(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85)>1000;p99esi_rcp85(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85(model,1:size(elevcutoffs,2))=squeeze(p99t(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85(model,1:size(elevcutoffs,2))=squeeze(p99q(1:size(elevcutoffs,2)));end

            if varstart<=5 && varstop>=5
            p99esi_rcp85_histt(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt(1:size(elevcutoffs,2)));
            p99esi_rcp85_histq(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq(1:size(elevcutoffs,2)));
            p99esi_rcp85_histr(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_nw(model,1:size(elevcutoffs,2))=squeeze(p99tw_nw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_nw(model,1:size(elevcutoffs,2))=squeeze(p99esi_nw(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_nw)>1000;p99esi_rcp85_nw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_nw(model,1:size(elevcutoffs,2))=squeeze(p99t_nw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_nw(model,1:size(elevcutoffs,2))=squeeze(p99q_nw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_nw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_nw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_nw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_nw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_nw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_nw(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_sw(model,1:size(elevcutoffs,2))=squeeze(p99tw_sw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_sw(model,1:size(elevcutoffs,2))=squeeze(p99esi_sw(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_sw)>1000;p99esi_rcp85_sw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_sw(model,1:size(elevcutoffs,2))=squeeze(p99t_sw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_sw(model,1:size(elevcutoffs,2))=squeeze(p99q_sw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_sw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_sw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_sw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_sw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_sw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_sw(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_ngp(model,1:size(elevcutoffs,2))=squeeze(p99tw_ngp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_ngp(model,1:size(elevcutoffs,2))=squeeze(p99esi_ngp(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_ngp)>1000;p99esi_rcp85_ngp(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_ngp(model,1:size(elevcutoffs,2))=squeeze(p99t_ngp(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_ngp(model,1:size(elevcutoffs,2))=squeeze(p99q_ngp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_ngp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_ngp(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_ngp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_ngp(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_ngp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_ngp(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_sgp(model,1:size(elevcutoffs,2))=squeeze(p99tw_sgp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_sgp(model,1:size(elevcutoffs,2))=squeeze(p99esi_sgp(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_sgp)>1000;p99esi_rcp85_sgp(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_sgp(model,1:size(elevcutoffs,2))=squeeze(p99t_sgp(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_sgp(model,1:size(elevcutoffs,2))=squeeze(p99q_sgp(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 
                p99esi_rcp85_histt_sgp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_sgp(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_sgp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_sgp(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_sgp(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_sgp(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_mw(model,1:size(elevcutoffs,2))=squeeze(p99tw_mw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_mw(model,1:size(elevcutoffs,2))=squeeze(p99esi_mw(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_mw)>1000;p99esi_rcp85_mw(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_mw(model,1:size(elevcutoffs,2))=squeeze(p99t_mw(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_mw(model,1:size(elevcutoffs,2))=squeeze(p99q_mw(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_mw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_mw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_mw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_mw(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_mw(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_mw(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_se(model,1:size(elevcutoffs,2))=squeeze(p99tw_se(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_se(model,1:size(elevcutoffs,2))=squeeze(p99esi_se(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_se)>1000;p99esi_rcp85_se(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_se(model,1:size(elevcutoffs,2))=squeeze(p99t_se(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_se(model,1:size(elevcutoffs,2))=squeeze(p99q_se(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_se(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_se(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_se(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_se(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_se(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_se(1:size(elevcutoffs,2)));
            end

            if varstart<=4 && varstop>=4;p99tw_rcp85_ne(model,1:size(elevcutoffs,2))=squeeze(p99tw_ne(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5 && donormalpart==1;p99esi_rcp85_ne(model,1:size(elevcutoffs,2))=squeeze(p99esi_ne(1:size(elevcutoffs,2)));invalid=abs(p99esi_rcp85_ne)>1000;p99esi_rcp85_ne(invalid)=NaN;end
            if varstart<=1 && varstop>=1;p99t_rcp85_ne(model,1:size(elevcutoffs,2))=squeeze(p99t_ne(1:size(elevcutoffs,2)));end
            if varstart<=2 && varstop>=2;p99q_rcp85_ne(model,1:size(elevcutoffs,2))=squeeze(p99q_ne(1:size(elevcutoffs,2)));end
            if varstart<=5 && varstop>=5
                p99esi_rcp85_histt_ne(model,1:size(elevcutoffs,2))=squeeze(p99esi_histt_ne(1:size(elevcutoffs,2)));
                p99esi_rcp85_histq_ne(model,1:size(elevcutoffs,2))=squeeze(p99esi_histq_ne(1:size(elevcutoffs,2)));
                p99esi_rcp85_histr_ne(model,1:size(elevcutoffs,2))=squeeze(p99esi_histr_ne(1:size(elevcutoffs,2)));
            end

            if varstart<=3 && varstop>=3
            p99r_rcp85(model,1:size(elevcutoffs,2))=squeeze(p99r(1:size(elevcutoffs,2)));
            p99r_rcp85_nw(model,1:size(elevcutoffs,2))=squeeze(p99r_nw(1:size(elevcutoffs,2)));
            p99r_rcp85_sw(model,1:size(elevcutoffs,2))=squeeze(p99r_sw(1:size(elevcutoffs,2)));
            p99r_rcp85_ngp(model,1:size(elevcutoffs,2))=squeeze(p99r_ngp(1:size(elevcutoffs,2)));
            p99r_rcp85_sgp(model,1:size(elevcutoffs,2))=squeeze(p99r_sgp(1:size(elevcutoffs,2)));
            p99r_rcp85_mw(model,1:size(elevcutoffs,2))=squeeze(p99r_mw(1:size(elevcutoffs,2)));
            p99r_rcp85_se(model,1:size(elevcutoffs,2))=squeeze(p99r_se(1:size(elevcutoffs,2)));
            p99r_rcp85_ne(model,1:size(elevcutoffs,2))=squeeze(p99r_ne(1:size(elevcutoffs,2)));
            end

            if varstart<=1 && varstop>=1
                save(strcat(dataloc,'twresults.mat'),...
                    'p99t_rcp85','p99t_rcp85_nw','p99t_rcp85_sw','p99t_rcp85_ngp','p99t_rcp85_sgp','p99t_rcp85_mw','p99t_rcp85_se','p99t_rcp85_ne','-append');
            end
            if varstart<=2 && varstop>=2
                save(strcat(dataloc,'twresults.mat'),...
                    'p99q_rcp85','p99q_rcp85_nw','p99q_rcp85_sw','p99q_rcp85_ngp','p99q_rcp85_sgp','p99q_rcp85_mw','p99q_rcp85_se','p99q_rcp85_ne','-append');
            end
            if varstart<=3 && varstop>=3
                save(strcat(dataloc,'twresults.mat'),...
                    'p99r_rcp85','p99r_rcp85_nw','p99r_rcp85_sw','p99r_rcp85_ngp','p99r_rcp85_sgp','p99r_rcp85_mw','p99r_rcp85_se','p99r_rcp85_ne','-append');
            end
            if varstart<=4 && varstop>=4
                save(strcat(dataloc,'twresults.mat'),...
                    'p99tw_rcp85','p99tw_rcp85_nw','p99tw_rcp85_sw','p99tw_rcp85_ngp','p99tw_rcp85_sgp','p99tw_rcp85_mw','p99tw_rcp85_se','p99tw_rcp85_ne','-append');
            end
            if varstart<=5 && varstop>=5  && donormalpart==1
                save(strcat(dataloc,'twresults.mat'),...
                    'p99esi_rcp85','p99esi_rcp85_nw','p99esi_rcp85_sw','p99esi_rcp85_ngp','p99esi_rcp85_sgp','p99esi_rcp85_mw','p99esi_rcp85_se','p99esi_rcp85_ne','-append');
            end
            if varstart<=5 && varstop>=5
                save(strcat(dataloc,'twresults.mat'),...
                    'p99esi_rcp85_histt','p99esi_rcp85_histq','p99esi_rcp85_histr','p99esi_rcp85_histt_nw','p99esi_rcp85_histq_nw','p99esi_rcp85_histr_nw',...
                    'p99esi_rcp85_histt_sw','p99esi_rcp85_histq_sw','p99esi_rcp85_histr_sw','p99esi_rcp85_histt_ngp','p99esi_rcp85_histq_ngp','p99esi_rcp85_histr_ngp',...
                    'p99esi_rcp85_histt_sgp','p99esi_rcp85_histq_sgp','p99esi_rcp85_histr_sgp','p99esi_rcp85_histt_mw','p99esi_rcp85_histq_mw','p99esi_rcp85_histr_mw',...
                    'p99esi_rcp85_histt_se','p99esi_rcp85_histq_se','p99esi_rcp85_histr_se','p99esi_rcp85_histt_ne','p99esi_rcp85_histq_ne','p99esi_rcp85_histr_ne','-append');
            end
           
            outputtowrite=[expnum modelnum];
            dlmwrite(strcat(dataloc,'twresults_LASTSAVED.txt'),outputtowrite);
        end
    end

    figure(868);clf;
    plot(mean(p99tw_rcp85,1,'omitnan')-mean(p99tw_hist,1,'omitnan'));hold on;
    plot(mean(p99esi_rcp85,1,'omitnan')-mean(p99esi_hist,1,'omitnan'),'b--');
end
