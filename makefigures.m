if makefig1==1
    figure(1);clf;curpart=1;highqualityfiguresetup;
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(macaelevFINAL')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';-100;'underlaycaxismax';4000;'mystepunderlay';50;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America'};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);

    %Add NCA-region outlines and numbered labels
    g=geoshow(northwestpolygonlats,northwestpolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(southwestpolygonlats,southwestpolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(gpnpolygonlats,gpnpolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(gpspolygonlats,gpspolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(midwestpolygonlats,midwestpolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(southeastpolygonlats,southeastpolygonlons);set(g,'Color','k','LineWidth',2);
    g=geoshow(northeastpolygonlats,northeastpolygonlons);set(g,'Color','k','LineWidth',2);
    t=text(0.12,0.8,'1','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.22,0.45,'2','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.35,0.8,'3','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.44,0.3,'4','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.58,0.7,'5','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.65,0.31,'6','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(0.78,0.7,'7','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');

    colormap(colormaps('grayscale','more','not'));colorbar;
    set(gca,'xtick',[],'ytick',[]);set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    title('Elevation and NCA Regions','fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.03 0.55 0.4 0.43]);


    subplot(2,2,2);
    thisarr=squeeze(median(p99esibypoint_family_hist,'omitnan'));
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(thisarr')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';15;'underlaycaxismax';35;'mystepunderlay';1;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('wbt','more','not')),'fontweight','bold','fontname','arial','fontsize',11);cb=colorbar;cb.FontSize=11;
    title(strcat('Historical p99 ESI (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.53 0.55 0.4 0.43]);


    subplot(2,2,3);
    p99esibypoint_family_rcp85(12,:,:)=p99esibypoint_family_rcp85(12,:,:).*2;
    thisdiff=p99esibypoint_family_rcp85-p99esibypoint_family_hist;
    invalid=thisdiff<=0;thisdiff(invalid)=NaN;
    for i=1:692
        for j=1:292
            if sum(~isnan(thisdiff(:,i,j)))<8 %fewer than 8 models have data for this point
                thisdiff(:,i,j)=NaN;
            end
        end
    end

    quartile1=squeeze(quantile(thisdiff,0.25));quartile3=squeeze(quantile(thisdiff,0.75));
    dataincentralquartiles=NaN.*ones(size(thisdiff,1),692,292);
    for i=1:692
        for j=1:292
            for modelfamily=1:size(thisdiff,1)
                if thisdiff(modelfamily,i,j)>=quartile1(i,j) && thisdiff(modelfamily,i,j)<=quartile3(i,j)
                    dataincentralquartiles(modelfamily,i,j)=thisdiff(modelfamily,i,j);
                end
            end
        end
    end
    thisarr=squeeze(mean(dataincentralquartiles,'omitnan'));
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(thisarr')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);

    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;
    set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});
    title(strcat('Change in p99 ESI (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'c)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.03 0.05 0.4 0.43]);


    f=load(strcat(dataloc,'exceedratio.mat'));
    if strcmp(meanormedian,'median')
        exceedratio_future_median_esi=f.exceedratio_future_median_esi;
        getrid=exceedratio_future_median_esi==0;exceedratio_future_median_esi(getrid)=NaN;
    else
        exceedratio_future_mean_esi=f.exceedratio_future_mean_esi;
        getrid=exceedratio_future_mean_esi==0;exceedratio_future_mean_esi(getrid)=NaN;
    end



    %Get distance to nearest ocean and Great Lake again
    exist disttooceanall;
    if ans==0
    for i=1:692
        for j=1:292
            curptlat=macalatsFINAL(i,j);
            curptlon=macalonsFINAL(i,j);
            mindisttooceansofar=10000; %km
            mindisttogreatlakesofar=10000; %km
            xdiststosearch=round([0.5:0.5:size(macalatsFINAL,1)]);for k=2:2:size(xdiststosearch,2);xdiststosearch(k)=-1*xdiststosearch(k);end
            ydiststosearch=round([0.5:0.5:size(macalatsFINAL,2)]);for k=2:2:size(ydiststosearch,2);ydiststosearch(k)=-1*ydiststosearch(k);end

            for xord=1:size(macalatsFINAL,1)
                for yord=1:size(macalatsFINAL,2)
                    xoffset=xdiststosearch(xord);yoffset=ydiststosearch(yord);

                    tryx=i+xoffset;tryy=j+yoffset;
                    if tryx>=1 && tryx<=size(macalatsFINAL,1) && tryy>=1 && tryy<=size(macalatsFINAL,2)
                        if elevs_on692x292grid(tryx,tryy)<=0 && macaregions(tryx,tryy)==0 %only care about this pt if it's ocean
                            oceanptlat=macalatsFINAL(tryx,tryy);
                            oceanptlon=macalonsFINAL(tryx,tryy);
                            totaldist=sqrt((curptlat-oceanptlat)^2+(curptlon-oceanptlon)^2);
                            if totaldist<mindisttooceansofar
                                mindisttooceansofar=totaldist;
                                ifoundat(i,j)=tryx;jfoundat(i,j)=tryy;
                            end
                        end
                    end

                    if i>=500 && i<=600 && j>=200 && j<=260 %Great Lakes region
                        if tryx>=1 && tryx<=size(macalatsFINAL,1) && tryy>=1 && tryy<=size(macalatsFINAL,2)
                            if macaregions(tryx,tryy)==0
                                greatlakeptlat=macalatsFINAL(tryx,tryy);
                                greatlakeptlon=macalonsFINAL(tryx,tryy);
                                totaldist=sqrt((curptlat-greatlakeptlat)^2+(curptlon-greatlakeptlon)^2);
                                if totaldist<mindisttogreatlakesofar
                                    mindisttogreatlakesofar=totaldist;
                                    ifoundat(i,j)=tryx;jfoundat(i,j)=tryy;
                                end
                            end
                        end
                    end
                end
            end
            disttooceanall(i,j)=mindisttooceansofar;
            disttogreatlakeall(i,j)=mindisttogreatlakesofar;
        end
    end
    invalid=disttooceanall>1000;disttooceanall(invalid)=NaN;
    invalid=disttogreatlakeall>1000;disttogreatlakeall(invalid)=NaN;
    save(strcat(dataloc,'variousneededarrays.mat'),'disttooceanall','disttogreatlakeall','-append');
    end

    if strcmp(meanormedian,'median')
        getrid=zeros(692,292);getrid(1:100,:)=exceedratio_future_median_esi(1:100,:)>40 & disttooceanall(1:100,:)<0.5;exceedratio_future_median_esi(logical(getrid))=NaN;

        getrid=zeros(692,292);getrid=exceedratio_future_median_esi>32 & disttogreatlakeall<0.8;exceedratio_future_median_esi(logical(getrid))=NaN;
        invalid=exceedratio_future_median_esi<10;exceedratio_future_median_esi(invalid)=NaN;
        getrid=zeros(692,292);getrid=exceedratio_future_median_esi<24 & disttogreatlakeall<0.3;exceedratio_future_median_esi(logical(getrid))=NaN;
        getrid=zeros(692,292);getrid(615:end,:)=exceedratio_future_median_esi(615:end,:)>28 & disttooceanall(615:end,:)<0.5;exceedratio_future_median_esi(logical(getrid))=NaN;
        for i=580:587;for j=222:226;exceedratio_future_median_esi(i,j)=NaN;end;end
    else
        getrid=zeros(692,292);getrid(1:100,:)=exceedratio_future_mean_esi(1:100,:)>40 & disttooceanall(1:100,:)<0.5;exceedratio_future_mean_esi(logical(getrid))=NaN;

        getrid=zeros(692,292);getrid=exceedratio_future_mean_esi>32 & disttogreatlakeall<0.8;exceedratio_future_mean_esi(logical(getrid))=NaN;
        invalid=exceedratio_future_mean_esi<10;exceedratio_future_mean_esi(invalid)=NaN;
        getrid=zeros(692,292);getrid=exceedratio_future_mean_esi<24 & disttogreatlakeall<0.3;exceedratio_future_mean_esi(logical(getrid))=NaN;
        getrid=zeros(692,292);getrid(615:end,:)=exceedratio_future_mean_esi(615:end,:)>28 & disttooceanall(615:end,:)<0.5;exceedratio_future_mean_esi(logical(getrid))=NaN;
        for i=580:587;for j=222:226;exceedratio_future_mean_esi(i,j)=NaN;end;end
    end

    subplot(2,2,4);
    if strcmp(meanormedian,'median')
        data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud((exceedratio_future_median_esi)')};
    else
        data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud((exceedratio_future_mean_esi)')};
    end
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';10;'underlaycaxismax';60;'mystepunderlay';3;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',20:10:50);
    title('Relative Increase in ESI > Historical p99','fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'d)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.53 0.05 0.4 0.43]);


    figname='figure1';curpart=2;highqualityfiguresetup;
end



if makefig2==1
    quartile1_t=squeeze(quantile(exceedratio_future_t,0.25));quartile3_t=squeeze(quantile(exceedratio_future_t,0.75));
    dataincentralquartiles_t=NaN.*ones(size(exceedratio_future_t,1),692,292);
    quartile1_q=squeeze(quantile(exceedratio_future_q,0.25));quartile3_q=squeeze(quantile(exceedratio_future_q,0.75));
    dataincentralquartiles_q=NaN.*ones(size(exceedratio_future_q,1),692,292);
    quartile1_r=squeeze(quantile(exceedratio_future_r,0.25));quartile3_r=squeeze(quantile(exceedratio_future_r,0.75));
    dataincentralquartiles_r=NaN.*ones(size(exceedratio_future_r,1),692,292);
    for i=1:692
        for j=1:292
            for modelfamily=1:size(exceedratio_future_t,1)
                if exceedratio_future_t(modelfamily,i,j)>=quartile1_t(i,j) && exceedratio_future_t(modelfamily,i,j)<=quartile3_t(i,j)
                    dataincentralquartiles_t(modelfamily,i,j)=exceedratio_future_t(modelfamily,i,j);
                end
                if exceedratio_future_q(modelfamily,i,j)>=quartile1_q(i,j) && exceedratio_future_q(modelfamily,i,j)<=quartile3_q(i,j)
                    dataincentralquartiles_q(modelfamily,i,j)=exceedratio_future_q(modelfamily,i,j);
                end
                if exceedratio_future_r(modelfamily,i,j)>=quartile1_r(i,j) && exceedratio_future_r(modelfamily,i,j)<=quartile3_r(i,j)
                    dataincentralquartiles_r(modelfamily,i,j)=exceedratio_future_r(modelfamily,i,j);
                end
            end
        end
    end
    arr_t=squeeze(mean(dataincentralquartiles_t,'omitnan'));invalid=arr_t==0;arr_t(invalid)=NaN;
    arr_q=squeeze(mean(dataincentralquartiles_q,'omitnan'));invalid=arr_q==0;arr_q(invalid)=NaN;
    arr_r=squeeze(mean(dataincentralquartiles_r,'omitnan'));invalid=arr_r==0;arr_rs(invalid)=NaN;


    %Make figure
    col1leftpos=0.02;col2leftpos=0.35;col3leftpos=0.68;
    row1bottompos=0.7;row2bottompos=0.34;row3bottompos=0.01;
    spwidth=0.31;spheight=0.27;
    cbrelleftpos=-0.04;cbrelbottompos=0.022;cbwidth=0.01;cbheight=0.145;

    %Actual increases
    figure(200);clf;curpart=1;highqualityfiguresetup;
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(tdiff_touse')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';3.5;'underlaycaxismax';8.5;'mystepunderlay';0.5;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('t','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap(round(size(cmap,1)/2):size(cmap,1),:)),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;cb.Position=[col1leftpos+spwidth+cbrelleftpos row1bottompos+cbrelbottompos cbwidth cbheight];
    title(strcat('Change in p99 T (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col1leftpos row1bottompos spwidth spheight]);
    t=text(-0.04,1.05,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,4);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(1000.*qdiff_touse')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';1.5;'underlaycaxismax';6;'mystepunderlay';0.2;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('q','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap(round(size(cmap,1)/2):size(cmap,1),:)),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;cb.Position=[col1leftpos+spwidth+cbrelleftpos row2bottompos+cbrelbottompos cbwidth cbheight];
    title('Change in p99 q (g/kg)','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col1leftpos row2bottompos spwidth spheight]);
    t=text(-0.04,1.05,'d)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,7);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(rdiff_touse')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';-10;'underlaycaxismax';10;'mystepunderlay';1;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('blueyellowred','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;cb.Position=[col1leftpos+spwidth+cbrelleftpos row3bottompos+cbrelbottompos cbwidth cbheight];
    title('Change in p99 r (J/kg)','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col1leftpos row3bottompos spwidth spheight]);
    t=text(-0.04,1.05,'g)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    %Relative increases
    subplot(3,3,2);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud((arr_t)')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';60;'mystepunderlay';5;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('wbt','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:20:60);cb.Position=[col2leftpos+spwidth+cbrelleftpos row1bottompos+cbrelbottompos cbwidth cbheight];
    title('Relative Increase in T > Historical p99','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col2leftpos row1bottompos spwidth spheight]);
    t=text(-0.04,1.05,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,5);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(arr_q')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';60;'mystepunderlay';5;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('wbt','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:20:60);cb.Position=[col2leftpos+spwidth+cbrelleftpos row2bottompos+cbrelbottompos cbwidth cbheight];
    title('Relative Increase in q > Historical p99','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col2leftpos row2bottompos spwidth spheight]);
    t=text(-0.04,1.05,'e)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,8);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(arr_r')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';60;'mystepunderlay';5;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    cmap=colormaps('wbt','more','not');
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,cmap),'fontweight','bold','fontname','arial','fontsize',11);cb=colorbar;cb.FontSize=11;
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:20:60);cb.Position=[col2leftpos+spwidth+cbrelleftpos row3bottompos+cbrelbottompos cbwidth cbheight];
    title('Relative Increase in r > Historical p99','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col2leftpos row3bottompos spwidth spheight]);
    t=text(-0.04,1.05,'h)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    %Contributions/weights
    subplot(3,3,3);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relteffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';-0.05;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'colormap',colormap(gca,colormaps('wbt','more','not')));colorbar;
    set(gca,'xtick',[],'ytick',[]);set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:0.5:1);cb.Position=[col3leftpos+spwidth+cbrelleftpos row1bottompos+cbrelbottompos cbwidth cbheight];
    title('T Weight','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col3leftpos row1bottompos spwidth spheight]);
    t=text(-0.04,1.05,'c)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,6);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relqeffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';-0.05;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'colormap',colormap(gca,colormaps('wbt','more','not')));colorbar;
    set(gca,'xtick',[],'ytick',[]);set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:0.5:1);cb.Position=[col3leftpos+spwidth+cbrelleftpos row2bottompos+cbrelbottompos cbwidth cbheight];
    title('q Weight','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col3leftpos row2bottompos spwidth spheight]);
    t=text(-0.04,1.05,'f)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,3,9);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relreffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';-0.05;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'colormap',colormap(gca,colormaps('wbt','more','not')));colorbar;
    set(gca,'xtick',[],'ytick',[]);set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',0:0.5:1);cb.Position=[col3leftpos+spwidth+cbrelleftpos row3bottompos+cbrelbottompos cbwidth cbheight];
    title('r Weight','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[col3leftpos row3bottompos spwidth spheight]);
    t=text(-0.04,1.05,'i)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    set(gcf,'color','w');
    figname='figure2NEWEST';curpart=2;highqualityfiguresetup;
end


if makefig3s10ands11==1
    for loop=1:3
    figure(3);clf;curpart=1;highqualityfiguresetup;hold on;
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    xlabel(strcat('ESI (',char(176),'C)'),'fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
    ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');

    %elevcutoffs(1) is -100 m, elevcutoffs(3) is 0 m
    if loop<=2
        for reg=1:numregs
            x=3:newxstops(reg);thingtoplot=eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x)']);
            plot(thingtoplot,x-2,'color',regcolors{reg},'linewidth',2);hold on;
            %Add round markers to indicate elevation of max and 500 m above
            [valofmax,locofmax]=max(thingtoplot);
            scatter(valofmax,locofmax,100,regcolors{reg},'filled');
            if reg~=5;scatter(thingtoplot(locofmax+10),locofmax+10,100,regcolors{reg},'filled');end
        end
        yearintitle='1980-2005';
    elseif loop==3
        for reg=1:numregs
            x=3:newxstops(reg);
            plot(eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x)']),x-2,'color',regcolors{reg},'linewidth',2);hold on;
        end
        yearintitle='2074-2099';
    end

    t=text(0.02,0.28,'Northwest','color',regcolors{1},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.24,'Southwest','color',regcolors{2},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.2,'N Great Plains','color',regcolors{3},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.16,'S Great Plains','color',regcolors{4},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.12,'Midwest','color',regcolors{5},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.08,'Southeast','color',regcolors{6},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.04,'Northeast','color',regcolors{7},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    title(strcat(['Regional Extreme ESI, ',yearintitle]),'fontsize',14,'fontweight','bold','fontname','arial');


    %Overplotted thin lines to indicate significance
    if loop==2
    for reg=1:numregs
        for model=1:13
            x=3:newxstops(reg);y=p99esi_familyarray_hist_final{reg}(model,x);
            plot(y,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
    end
    elseif loop==3
    for reg=1:numregs
        for model=1:13
            x=3:newxstops(reg);y=p99esi_familyarray_rcp85_final{reg}(model,x);
            plot(y,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
    end
    end

    if loop<=2;xlim([18 34]);elseif loop==3;xlim([21.5 41]);end
    ylim([1 65]);
    set(gca,'Position',[0.06 0.08 0.41 0.87],'Box','on');
    t=text(-0.04,1.02,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',14);


    %Add to top subplot a scatterplot of the RH of extreme ESI at 250 m above elevation of max extreme ESI 
        %versus the mean slope of the curve from the elevation of maximum extreme ESI to 500 m above it
    %elevcutoffs(11)=500; 6 is 250, 16 is 750
    %Because RH calculation requires an approx pressure, assume a standard atmosphere
    if loop==1
    clear rh_extremeesi_midpoint;clear esislope_span;
    for reg=1:numregs
        if loop<=2
        p99esi_mmmedian=eval(['p99esi_hist_mmmedian_' regsuffixes{reg} ';']);
        p99t_mmmedian=eval(['p99t_hist_mmmedian_' regsuffixes{reg} ';']);
        p99q_mmmedian=eval(['p99q_hist_mmmedian_' regsuffixes{reg} ';']);
        elseif loop==3
        p99esi_mmmedian=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} ';']);
        p99t_mmmedian=eval(['p99t_rcp85_mmmedian_' regsuffixes{reg} ';']);
        p99q_mmmedian=eval(['p99q_rcp85_mmmedian_' regsuffixes{reg} ';']);
        end

        %Start from elevation of historical max extreme ESI
        [~,levtouse]=max(p99esi_mmmedian);levtouse=levtouse+4;

        if reg~=3
            stdpres=pressurefromelev_dynamicT(elevcutoffs,p99t_mmmedian(levtouse-4));
        elseif reg==3 %no sea-level T to use
            stdpres=pressurefromelev_dynamicT(elevcutoffs,p99t_mmmedian(levtouse-4));
        elseif reg==5 %no sea-level T to use
            stdpres=pressurefromelev_dynamicT(elevcutoffs,p99t_mmmedian(levtouse-4));
        end
        thistd=calcTdfromq(1000.*p99q_mmmedian,stdpres);
        thisrh=calcrhfromTanddewpt(p99t_mmmedian-273.15,thistd);

        rh_extremeesi_midpoint(reg)=thisrh(levtouse);
        %Use fitted line to estimate ESI slopes instead
        x=elevcutoffs(levtouse-4:levtouse+4);
        c=polyfit(x,p99esi_mmmedian(levtouse-4:levtouse+4),1);
        y_est=polyval(c,x);
        esislope_span(reg)=y_est(end)-y_est(1);


    end
    axes('Position',[0.28 0.76 0.17 0.17],'color','none');scatter(esislope_span,rh_extremeesi_midpoint,'w','filled');
    for reg=1:numregs
        t=text(esislope_span(reg),rh_extremeesi_midpoint(reg),regnamesshort{reg});set(t,'fontweight','bold','fontname','arial','color',regcolors{reg});
    end
    xlim([-3.5 0]);
    set(gca,'fontsize',11,'fontweight','bold','fontname','arial','box','on');
    ylabel('RH_m_i_d_p_o_i_n_t (%)','fontsize',11,'fontweight','bold','fontname','arial');
    xlabel(strcat('\DeltaESI (',char(176),'C)'),'fontsize',11,'fontweight','bold','fontname','arial');
    end

    %Uncertainty -- overplotted thin lines
    if loop==2
        subplot(1,3,3);
        for reg=1:numregs
            for model=1:13
                x=3:newxstops(reg);y=p99esi_familyarray_rcp85_final{reg}(model,x)-p99esi_familyarray_hist_final{reg}(model,x);
                plot(y,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
            end
        end
    end


    temp=load(strcat(dataloc,'pctagreement.mat'));pctagreement=temp.pctagreement;

    
    %Plot the change
    %Make thick line where >=75% of models agree on the sign of the change between given levels
    if loop<=2
    subplot(1,3,3);
    for reg=1:numregs
        x=3:newxstops(reg);
        x_0to250=x(1:6);diff_0to250=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_0to250)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_0to250)']);
        if pctagreement(reg,1)>=0.75;lw=4;else;lw=2;end
        plot(diff_0to250,x_0to250-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_250to500=x(6:min(11,size(x,2)));diff_250to500=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_250to500)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_250to500)']);
        if pctagreement(reg,2)>=0.75;lw=4;else;lw=2;end
        plot(diff_250to500,x_250to500-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_500to1000=x(min(11,size(x,2)):min(21,size(x,2)));diff_500to1000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_500to1000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_500to1000)']);
        if pctagreement(reg,3)>=0.75;lw=4;else;lw=2;end
        plot(diff_500to1000,x_500to1000-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_1000to2000=x(min(21,size(x,2)):min(41,size(x,2)));diff_1000to2000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_1000to2000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_1000to2000)']);
        if pctagreement(reg,4)>=0.75;lw=4;else;lw=2;end
        plot(diff_1000to2000,x_1000to2000-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_2000to3000=x(min(41,size(x,2)):min(61,size(x,2)));diff_2000to3000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_2000to3000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_2000to3000)']);
        if pctagreement(reg,5)>=0.75;lw=4;else;lw=2;end
        plot(diff_2000to3000,x_2000to3000-2,'color',regcolors{reg},'linewidth',lw);hold on;
    end

    ylim([1 65]);
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{''});
    xlabel(strcat('Future - Historical ESI (',char(176),'C)'),'fontsize',14,'fontweight','bold','fontname','arial');
    title('Change, 2074-2099 minus 1980-2005','fontsize',14,'fontweight','bold','fontname','arial');

    set(gca,'Position',[0.51 0.08 0.41 0.87],'Box','on');
    t=text(-0.04,1.02,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',14);
    end

    if loop==1;fname='figure3';elseif loop==2;fname='figures10';elseif loop==3;fname='figures11';end
    figname=fname;curpart=2;highqualityfiguresetup;
    end
end




if makefig4==1
    invalid=p99esi_rcp85_histt==0;p99esi_rcp85_histt(invalid)=NaN;
    invalid=p99esi_hist==0;p99esi_hist(invalid)=NaN;
    invalid=p99esi_rcp85_histq==0;p99esi_rcp85_histq(invalid)=NaN;
    invalid=p99esi_rcp85_histr==0;p99esi_rcp85_histr(invalid)=NaN;
    invalid=p99esi_rcp85==0;p99esi_rcp85(invalid)=NaN;

    for reg=1:numregs
        invalid=eval(['p99esi_rcp85_histt_' regsuffixes{reg} '==0;']);eval(['p99esi_rcp85_histt_' regsuffixes{reg} '(invalid)=NaN;']);
        invalid=eval(['p99esi_rcp85_histq_' regsuffixes{reg} '==0;']);eval(['p99esi_rcp85_histq_' regsuffixes{reg} '(invalid)=NaN;']);
        invalid=eval(['p99esi_rcp85_histr_' regsuffixes{reg} '==0;']);eval(['p99esi_rcp85_histr_' regsuffixes{reg} '(invalid)=NaN;']);
    end

    figure(4);clf;curpart=1;highqualityfiguresetup;
    x=1:size(elevcutoffs,2);xs=[x(1:81) fliplr(x(1:81))]';


    lefts=[0.07;0.28;0.49;0.7;0.07;0.28;0.49];bottoms=[0.55;0.55;0.55;0.55;0.08;0.08;0.08];
    for regloop=1:7
        if regloop>=2;subplot(2,4,regloop);end
        xforward=x(xstarts(regloop):newxstops(regloop));
        xbackward=fliplr(x(xstarts(regloop):newxstops(regloop)));
        xs=[xforward xbackward]';

        futurewithhisttvec=eval(['p99esi_rcp85_histt_' regsuffixes{regloop} '']);
        tcontrib=eval(['p99esi_rcp85_' regsuffixes{regloop} '(1:size(futurewithhisttvec,1),:)'])-futurewithhisttvec;
        tcontrib=tcontrib(:,xstarts(regloop):newxstops(regloop));
        tcontrib_family=[tcontrib(1:3,:,:);sum(cat(4,0.5*tcontrib(4,:),0.5*tcontrib(5,:)),4,'omitnan');tcontrib(6:7,:);...
            sum(cat(4,0.33*tcontrib(8,:),0.33*tcontrib(9,:),0.33*tcontrib(17,:)),4,'omitnan');...
            sum(cat(4,0.5*tcontrib(10,:),0.5*tcontrib(11,:,:)),4,'omitnan');tcontrib(12,:);...
            sum(cat(4,0.5*tcontrib(13,:),0.5*tcontrib(18,:)),4,'omitnan');tcontrib(14,:);...
            sum(cat(4,0.5*tcontrib(15,:),0.5*tcontrib(16,:)),4,'omitnan');tcontrib(19,:)];

        q1=squeeze(quantile(tcontrib_family,0.25));q3=squeeze(quantile(tcontrib_family,0.75));
        dataincentralquartiles_t=NaN.*ones(size(tcontrib_family,1),size(tcontrib_family,2));
        for i=1:size(tcontrib_family,2)
            for modelfamily=1:size(tcontrib_family,1)
                if tcontrib_family(modelfamily,i)>=q1(i) && tcontrib_family(modelfamily,i)<=q3(i)
                    dataincentralquartiles_t(modelfamily,i)=tcontrib_family(modelfamily,i);
                end
            end
        end
        finalttoplot=squeeze(mean(dataincentralquartiles_t,'omitnan'));


        plot(finalttoplot,xforward,'color',varcolors{1},'linewidth',2);hold on;
        for i=1:size(tcontrib_family,1)
            plot(tcontrib_family(i,:),xforward,'color',palevarcolors{1},'linewidth',0.3);hold on;
        end

        futurewithhistqvec=eval(['p99esi_rcp85_histq_' regsuffixes{regloop} '']);
        qcontrib=eval(['p99esi_rcp85_' regsuffixes{regloop} '(1:size(futurewithhistqvec,1),:)'])-futurewithhistqvec;
        qcontrib=qcontrib(:,xstarts(regloop):newxstops(regloop));
        qcontrib_family=[qcontrib(1:3,:,:);sum(cat(4,0.5*qcontrib(4,:),0.5*qcontrib(5,:)),4,'omitnan');qcontrib(6:7,:);...
            sum(cat(4,0.33*qcontrib(8,:),0.33*qcontrib(9,:),0.33*qcontrib(17,:)),4,'omitnan');...
            sum(cat(4,0.5*qcontrib(10,:),0.5*qcontrib(11,:,:)),4,'omitnan');qcontrib(12,:);...
            sum(cat(4,0.5*qcontrib(13,:),0.5*qcontrib(18,:)),4,'omitnan');qcontrib(14,:);...
            sum(cat(4,0.5*qcontrib(15,:),0.5*qcontrib(16,:)),4,'omitnan');qcontrib(19,:)];

        q1=squeeze(quantile(qcontrib_family,0.25));q3=squeeze(quantile(qcontrib_family,0.75));
        dataincentralquartiles_q=NaN.*ones(size(qcontrib_family,1),size(qcontrib_family,2));
        for i=1:size(qcontrib_family,2)
            for modelfamily=1:size(qcontrib_family,1)
                if qcontrib_family(modelfamily,i)>=q1(i) && qcontrib_family(modelfamily,i)<=q3(i)
                    dataincentralquartiles_q(modelfamily,i)=qcontrib_family(modelfamily,i);
                end
            end
        end
        finalqtoplot=squeeze(mean(dataincentralquartiles_q,'omitnan'));

        plot(finalqtoplot,xforward,'color',varcolors{2},'linewidth',2);hold on;
        for i=1:size(qcontrib_family,1)
            plot(qcontrib_family(i,:),xforward,'color',palevarcolors{2},'linewidth',0.3);hold on;
        end

        plot(eval(['p99esi_rcp85_mmmedian_' regsuffixes{regloop} '(xstarts(regloop):newxstops(regloop))'])-...
            eval(['p99esi_hist_mmmedian_' regsuffixes{regloop} '(xstarts(regloop):newxstops(regloop))']),xforward,'color',colors('black'),'linewidth',3);hold on;

        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'ytick',[3:20:83],'yticklabel',[],'xtick',0:2:6,'xticklabel','');
        ylim([3 max(newxstops)]);xlim([-1.25 6.25]);
        if regloop>=4
            xlabel(strcat('\Delta (',char(176),'C)'),'fontsize',12,'fontweight','bold','fontname','arial');
            set(gca,'xticklabel',{'0','2','4','6'});
        end
        if regloop==1 || regloop==5
            ylabel('Elevation (m)','fontsize',12,'fontweight','bold','fontname','arial');
            set(gca,'yticklabel',{'0','1000','2000','3000','4000'});
        end
        if regloop==2;lefttextpos=0.01;else;lefttextpos=0.01;end
        t=text(lefttextpos,0.95,regnamesshort{regloop},'units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
        t=text(-0.09,0.98,strcat(letterlabels{regloop},')'),'units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
        set(gca,'Position',[lefts(regloop) bottoms(regloop) 0.19 0.44]);
    end

    t=text(1.14,0.6,'q Contribution (Fixed T)','units','normalized');set(t,'color','b','fontsize',14,'fontweight','bold','fontname','arial');
    t=text(1.14,0.5,'T Contribution (Fixed q)','units','normalized');set(t,'color',colors('medium green'),'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(1.14,0.4,'Total','units','normalized');set(t,'color','k','fontsize',14,'fontweight','bold','fontname','arial');

    figname='figure4';curpart=2;highqualityfiguresetup;
end


if makefigs1s2==1
    for loophere=1:2

        %Prepare to plot result for T or qbias
        if loophere==1
            figure(449);clf;curpart=1;highqualityfiguresetup;

            macattocompare=squeeze(mean(p99tbypoint_hist-273.15,1,'omitnan'));
            exist p99tbypointgridmet;
            if ans==0;f=load(strcat(dataloc,'biasarrays.mat'));p99tbypointgridmet=f.p99tbypointgridmet;end
        else
            figure(450);clf;curpart=1;highqualityfiguresetup;

            macaqtocompare=squeeze(mean(p99qbypoint_hist,1,'omitnan'));
            exist p99qbypointgridmet;
            if ans==0;f=load(strcat(dataloc,'biasarrays.mat'));p99qbypointgridmet=f.p99qbypointgridmet;end
        end

        xstopshere=newxstops;xstopshere(2)=62;xstopshere(4)=32;
        for regloop=1:numregs
            nbins=15;

            %Read MACA data
            pointsinthisreg=macaregions==regloop+1;
            clear elevdata_maca;clear tdata_maca;clear qdata_maca;
            for i=1:size(pointsinthisreg,1)
                for j=1:size(pointsinthisreg,2)
                    if pointsinthisreg(i,j)==1 %pt is within current region of interest
                        if loophere==1;tdata_maca(i,j)=macattocompare(i,j);end
                        if loophere==2;qdata_maca(i,j)=macaqtocompare(i,j);end
                        elevdata_maca(i,j)=macaelevFINAL(i,j);
                    end
                end
            end
            invalid=elevdata_maca==0;elevdata_maca(invalid)=NaN;
            elevdata_maca1d=reshape(elevdata_maca,[size(elevdata_maca,1)*size(elevdata_maca,2) 1]);
            if loophere==1
                invalid=tdata_maca==0;tdata_maca(invalid)=NaN;tdata_maca1d=reshape(tdata_maca,[size(tdata_maca,1)*size(tdata_maca,2) 1]);
            elseif loophere==2
                invalid=qdata_maca==0;qdata_maca(invalid)=NaN;qdata_maca1d=reshape(qdata_maca,[size(qdata_maca,1)*size(qdata_maca,2) 1]);
            end



            %Read gridMET data
            clear elevdata_gridmet;clear tdata_gridmet;clear qdata_gridmet;
            gridmetregions=ncaregionsfromlatlon(gridmetlats,gridmetlons);
            pointsinthisreg=gridmetregions==regloop+1;
            for i=1:size(pointsinthisreg,1)
                for j=1:size(pointsinthisreg,2)
                    if pointsinthisreg(i,j)==1 %pt is within current region of interest
                        if loophere==1;tdata_gridmet(i,j)=p99tbypointgridmet(i,j);end
                        if loophere==2;qdata_gridmet(i,j)=p99qbypointgridmet(i,j);end
                        elevdata_gridmet(i,j)=gridmetelev(i,j);
                    end
                end
            end
            invalid=elevdata_gridmet==0;elevdata_gridmet(invalid)=NaN;
            elevdata_gridmet1d=reshape(elevdata_gridmet,[size(elevdata_gridmet,1)*size(elevdata_gridmet,2) 1]);
            if loophere==1
                invalid=tdata_gridmet==0;tdata_gridmet(invalid)=NaN;tdata_gridmet1d=reshape(tdata_gridmet,[size(tdata_gridmet,1)*size(tdata_gridmet,2) 1]);
            elseif loophere==2
                invalid=qdata_gridmet==0;qdata_gridmet(invalid)=NaN;qdata_gridmet1d=reshape(qdata_gridmet,[size(qdata_gridmet,1)*size(qdata_gridmet,2) 1]);
            end


            %Difference in temperature for each elevation bin (mean and +/- 2 std devs)
            if loophere==1
                finalmeanbias=NaN.*ones(size(elevcutoffs,2),1);finalstdbias=NaN.*ones(size(elevcutoffs,2),1);
                finalstdactual=NaN.*ones(size(elevcutoffs,2),1);
                for eb=1:size(elevcutoffs,2)-1
                    thiselevbin_maca=elevdata_maca1d>=elevcutoffs(eb) & elevdata_maca1d<elevcutoffs(eb+1);macadata=tdata_maca1d(thiselevbin_maca);
                    thiselevbin_gridmet=elevdata_gridmet1d>=elevcutoffs(eb) & elevdata_gridmet1d<elevcutoffs(eb+1);gridmetdata=tdata_gridmet1d(thiselevbin_gridmet);

                    if size(macadata,1)>=1 && size(gridmetdata,1)>=1
                        clear meandiffs;clear stddiffs;
                        for repeatindex=1:1000
                            clear thisrandindex;for j=1:size(macadata,1);thisrandindex(j)=randi(size(gridmetdata,1));end
                            diffbyvalue=sort(macadata)-sort(gridmetdata(thisrandindex));

                            if sum(isnan(diffbyvalue))<0.25*size(diffbyvalue,1)
                                meandiffs(repeatindex)=mean(diffbyvalue,'omitnan');stddiffs(repeatindex)=std(diffbyvalue,'omitnan');
                            end

                            stdofactualvalues(repeatindex)=std(gridmetdata(thisrandindex));
                        end
                        finalmeanbias(eb)=mean(meandiffs);finalstdbias(eb)=mean(stddiffs);
                        finalstdactual(eb)=mean(stdofactualvalues);
                    end
                end
                figure(449);
                subplot(4,2,regloop);
                finalmeanbiassm=smooth(finalmeanbias(1:xstopshere(regloop)),7);invalid=isnan(finalmeanbias);finalmeanbiassm(invalid)=NaN;finalmeanbiassm(xstopshere(regloop)+1:end)=NaN;
                plot(1:size(elevcutoffs,2),finalmeanbiassm,'k','linewidth',2);hold on;
                meanbiasplus2sd_sm=smooth(finalmeanbias(1:xstopshere(regloop))+2*finalstdbias(1:xstopshere(regloop)),7);meanbiasplus2sd_sm(invalid)=NaN;meanbiasplus2sd_sm(xstopshere(regloop)+1:end)=NaN;
                meanbiasminus2sd_sm=smooth(finalmeanbias(1:xstopshere(regloop))-2*finalstdbias(1:xstopshere(regloop)),7);meanbiasminus2sd_sm(invalid)=NaN;meanbiasminus2sd_sm(xstopshere(regloop)+1:end)=NaN;
                plot(meanbiasplus2sd_sm,'r','linewidth',1.5);
                plot(meanbiasminus2sd_sm,'b','linewidth',1.5);
                set(gca,'fontweight','bold','fontname','arial','fontsize',12);
                ylabel(strcat('Bias (',char(176),'C)'),'fontsize',12,'fontweight','bold','fontname','arial');
                ylim([-2 3.5]);xlim([3 62]);
                if regloop==4 || regloop==6;smoothfactor=10;else;smoothfactor=7;end
                yyaxis right;relbias=smooth(finalmeanbias./finalstdactual,smoothfactor);invalid=isnan(finalmeanbiassm);relbias(invalid)=NaN;plot(relbias,'color',colors('gray'),'linewidth',1.5);
                set(gca,'xtick',3:20:size(elevcutoffs,2),'xticklabel',{'0';'1000';'2000';'3000'});ylim([0 3]);
                ax=gca;ax.YAxis(2).Color=colors('gray');ylabel('Norm. Bias','color',colors('gray'),'fontsize',12,'fontweight','bold','fontname','arial');

                if regloop==6 || regloop==7;xlabel('Elevation (m)','fontweight','bold','fontname','arial','fontsize',12);end
            else
                %Difference in specific humidity for each elevation bin (mean and +/- 2 std devs)
                finalmeanbias=NaN.*ones(size(elevcutoffs,2),1);finalstdbias=NaN.*ones(size(elevcutoffs,2),1);
                finalstdactual=NaN.*ones(size(elevcutoffs,2),1);
                for eb=1:size(elevcutoffs,2)-1
                    thiselevbin_maca=elevdata_maca1d>=elevcutoffs(eb) & elevdata_maca1d<elevcutoffs(eb+1);macadata=qdata_maca1d(thiselevbin_maca);
                    thiselevbin_gridmet=elevdata_gridmet1d>=elevcutoffs(eb) & elevdata_gridmet1d<elevcutoffs(eb+1);gridmetdata=qdata_gridmet1d(thiselevbin_gridmet);

                    if size(macadata,1)>=1 && size(gridmetdata,1)>=1
                        clear meandiffs;clear stddiffs;
                        for repeatindex=1:1000
                            clear thisrandindex;for j=1:size(macadata,1);thisrandindex(j)=randi(size(gridmetdata,1));end
                            diffbyvalue=sort(macadata)-sort(gridmetdata(thisrandindex));

                            if sum(isnan(diffbyvalue))<0.25*size(diffbyvalue,1)
                                meandiffs(repeatindex)=mean(diffbyvalue,'omitnan');stddiffs(repeatindex)=std(diffbyvalue,'omitnan');
                            end

                            stdofactualvalues(repeatindex)=std(gridmetdata(thisrandindex));
                        end
                        finalmeanbias(eb)=mean(meandiffs);finalstdbias(eb)=mean(stddiffs);
                        finalstdactual(eb)=mean(stdofactualvalues);
                    end
                end
                figure(450);
                subplot(4,2,regloop);
                finalmeanbiassm=smooth(finalmeanbias(1:xstopshere(regloop)),7);invalid=isnan(finalmeanbias);finalmeanbiassm(invalid)=NaN;finalmeanbiassm(xstopshere(regloop)+1:end)=NaN;
                plot(1:size(elevcutoffs,2),finalmeanbiassm.*1000,'k','linewidth',2);hold on;
                meanbiasplus2sd_sm=smooth(finalmeanbias(1:xstopshere(regloop))+2*finalstdbias(1:xstopshere(regloop)),7);meanbiasplus2sd_sm(invalid)=NaN;meanbiasplus2sd_sm(xstopshere(regloop)+1:end)=NaN;
                meanbiasminus2sd_sm=smooth(finalmeanbias(1:xstopshere(regloop))-2*finalstdbias(1:xstopshere(regloop)),7);meanbiasminus2sd_sm(invalid)=NaN;meanbiasminus2sd_sm(xstopshere(regloop)+1:end)=NaN;
                plot(meanbiasplus2sd_sm.*1000,'r','linewidth',1.5);
                plot(meanbiasminus2sd_sm.*1000,'b','linewidth',1.5);
                set(gca,'fontweight','bold','fontname','arial','fontsize',12);
                ylabel(strcat('Bias (g/kg)'),'fontsize',12,'fontweight','bold','fontname','arial');
                ylim([-1.5 1.5]);xlim([3 62]);
                yyaxis right;relbias=smooth(finalmeanbias./finalstdactual,7);invalid=isnan(finalmeanbiassm);relbias(invalid)=NaN;plot(relbias,'color',colors('gray'),'linewidth',1.5);
                set(gca,'xtick',3:20:size(elevcutoffs,2),'xticklabel',{'0';'1000';'2000';'3000'});ylim([-0.1 1]);
                ax=gca;ax.YAxis(2).Color=colors('gray');ylabel('Norm. Bias','color',colors('gray'),'fontsize',12,'fontweight','bold','fontname','arial');

                if regloop==6 || regloop==7;xlabel('Elevation (m)','fontweight','bold','fontname','arial','fontsize',12);end
            end
        end
        if loophere==1
            figure(449);figname='figures1';curpart=2;highqualityfiguresetup;
        else
            figure(450);figname='figures2';curpart=2;highqualityfiguresetup;
        end
    end
end


if makefigs7==1
    %Compute percent agreement in sign across models
    clear pctagreement;
    for regloop=1:7
        modelchanges0=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,3)-p99esi_hist_' regsuffixes{regloop} '(:,3);']);
        modelchanges250=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,8)-p99esi_hist_' regsuffixes{regloop} '(:,8);']);
        modelchanges500=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,13)-p99esi_hist_' regsuffixes{regloop} '(:,13);']);
        modelchanges1000=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,23)-p99esi_hist_' regsuffixes{regloop} '(:,23);']);
        modelchanges2000=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,43)-p99esi_hist_' regsuffixes{regloop} '(:,43);']);
        modelchanges3000=eval(['p99esi_rcp85_' regsuffixes{regloop} '(:,63)-p99esi_hist_' regsuffixes{regloop} '(:,63);']);
        %Percent that agree between each successive level
        for lv=1:5
            if lv==1
                lowerlev=modelchanges0;upperlev=modelchanges250;
            elseif lv==2
                lowerlev=modelchanges250;upperlev=modelchanges500;
            elseif lv==3
                lowerlev=modelchanges500;upperlev=modelchanges1000;
            elseif lv==4
                lowerlev=modelchanges1000;upperlev=modelchanges2000;
            elseif lv==5
                lowerlev=modelchanges2000;upperlev=modelchanges3000;
            end
            thesechanges=upperlev-lowerlev;
            numpos=sum(thesechanges>0);numneg=sum(thesechanges<0);largerone=max(numpos,numneg);pctagreement(regloop,lv)=largerone/20;
        end
    end
    invalid=pctagreement==0;pctagreement(invalid)=NaN;
    save(strcat(dataloc,'pctagreement.mat'),'pctagreement');

    blues=colormaps('whitelightbluedarkblue','more','not');cmap=blues(32:end,:);
    figure(50);clf;curpart=1;highqualityfiguresetup;
    imagescnan(pctagreement);cb=colorbar;cb.Ticks=[0.5:0.1:1];set(gca,'colormap',cmap);caxis([0.5 1]);
    set(gca,'yticklabel',{'NW','SW','NGP','SGP','MW','SE','NE'},'fontsize',12,'fontweight','bold','fontname','arial');
    set(gca,'xtick',1:5,'xticklabel',{'0 vs 250','250 vs 500','500 vs 1000','1000 vs 2000','2000 vs 3000'},'fontsize',16,'fontweight','bold','fontname','arial');
    figname='figures7';curpart=2;highqualityfiguresetup;

end



if makefigs9==1
    figure(20);clf;curpart=1;highqualityfiguresetup;hold on;
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    xlabel(strcat('T (',char(176),'C)'),'fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
    ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');

    %Uncertainty estimate based on a spaghetti plot, then median
    for reg=1:numregs
        x=3:newxstops(reg);
        for i=1:13
            plot(p99t_familyarray_hist_final{reg}(i,x)-273.15,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(median(p99t_familyarray_hist_final{reg}(:,x))-273.15,x-2,'color',regcolors{reg},'linewidth',2);hold on;
    end

    t=text(0.6,0.98,'Northwest','color',regcolors{1},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.94,'Southwest','color',regcolors{2},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.9,'N Great Plains','color',regcolors{3},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.86,'S Great Plains','color',regcolors{4},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.82,'Midwest','color',regcolors{5},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.78,'Southeast','color',regcolors{6},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.6,0.74,'Northeast','color',regcolors{7},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    title('Historical Extreme T','fontsize',14,'fontweight','bold','fontname','arial');

    xlim([23 47]);ylim([1 65]);
    set(gca,'Position',[0.06 0.08 0.29 0.87],'Box','on');



    subplot(1,3,2);
    %Uncertainty estimate based on a spaghetti plot, then median
    for reg=1:numregs
        x=3:newxstops(reg);
        for i=1:13
            plot(1000.*p99q_familyarray_hist_final{reg}(i,x),x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(1000.*median(p99q_familyarray_hist_final{reg}(:,x)),x-2,'color',regcolors{reg},'linewidth',2);hold on;
    end
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    xlabel(strcat('q (g/kg)'),'fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{''});

    title('Historical Extreme q','fontsize',14,'fontweight','bold','fontname','arial');

    xlim([8 21]);ylim([1 65]);
    set(gca,'Position',[0.375 0.08 0.29 0.87],'Box','on');


    subplot(1,3,3);
    %Uncertainty estimate based on a spaghetti plot, then median
    for reg=1:numregs
        x=3:newxstops(reg);
        for i=1:13
            plot(p99r_familyarray_hist_final{reg}(i,x),x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(median(p99r_familyarray_hist_final{reg}(:,x)),x-2,'color',regcolors{reg},'linewidth',2);hold on;
    end
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    xlabel(strcat('r (J/kg)'),'fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{''});
    title('Historical Extreme r','fontsize',14,'fontweight','bold','fontname','arial');

    xlim([312 380]);ylim([1 65]);
    set(gca,'Position',[0.69 0.08 0.29 0.87],'Box','on');


    figname='figures9';curpart=2;highqualityfiguresetup;
end


if makefigs12tos14==1 
    %T
    figure(210);clf;curpart=1;highqualityfiguresetup;hold on;
    lefts=[0.07;0.28;0.49;0.7;0.07;0.28;0.49];bottoms=[0.53;0.53;0.53;0.53;0.08;0.08;0.08];spwidth=0.19;spheight=0.42;
    %Uncertainty and then median, for each region
    for reg=1:numregs
        if reg>=2;axes('position',[lefts(reg) bottoms(reg) spwidth spheight]);set(gca,'box','on');end
        if reg>=4;set(gca,'xtick',[4:4:12],'xticklabel',{'4','8','12'});else;set(gca,'xtick',[],'xticklabel','');end
        x=3:newxstops(reg);
        for model=1:13
            y=p99t_familyarray_rcp85_final{reg}(model,x)-p99t_familyarray_hist_final{reg}(model,x);
            plot(y,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(eval(['p99t_rcp85_mmmedian_' regsuffixes{reg} '(x)'])-eval(['p99t_hist_mmmedian_' regsuffixes{reg} '(x)']),x-2,'color',regcolors{reg},'linewidth',2);hold on;
        xlim([1.5 14.5]);ylim([1 65]);
        if reg==1
            set(gca,'position',[lefts(reg) bottoms(reg) spwidth spheight],'box','on');
            set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
            ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');
        end
        if reg==5;set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');end
        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
        if reg>=5;xlabel(strcat('T (',char(176),'C)'),'fontsize',14,'fontweight','bold','fontname','arial');end
        title(regnamesshort{reg},'fontsize',14,'fontweight','bold','fontname','arial');
        if reg>=2;set(gca,'ytick',[],'yticklabel','');end
        if reg==2 || reg==3;set(gca,'xtick',[],'xticklabel','');end
    end
    figname='figures12';curpart=2;highqualityfiguresetup;

    %q
    figure(211);clf;curpart=1;highqualityfiguresetup;hold on;
    lefts=[0.07;0.28;0.49;0.7;0.07;0.28;0.49];bottoms=[0.53;0.53;0.53;0.53;0.08;0.08;0.08];spwidth=0.19;spheight=0.42;
    %Uncertainty and then median, for each region
    for reg=1:numregs
        if reg>=2;axes('position',[lefts(reg) bottoms(reg) spwidth spheight]);set(gca,'box','on');end
        if reg>=4;set(gca,'xtick',[4:4:12],'xticklabel',{'4','8','12'});else;set(gca,'xtick',[],'xticklabel','');end
        x=3:newxstops(reg);
        for model=1:13
            y=p99q_familyarray_rcp85_final{reg}(model,x)-p99q_familyarray_hist_final{reg}(model,x);
            plot(y.*1000,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(1000.*(eval(['p99q_rcp85_mmmedian_' regsuffixes{reg} '(x)'])-eval(['p99q_hist_mmmedian_' regsuffixes{reg} '(x)'])),x-2,'color',regcolors{reg},'linewidth',2);hold on;
        xlim([0.5 9.5]);ylim([1 65]);
        if reg==1
            set(gca,'position',[lefts(reg) bottoms(reg) spwidth spheight],'box','on');
            set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
            ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');
        end
        if reg==5;set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');end
        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
        if reg>=5;xlabel('q (g/kg)','fontsize',14,'fontweight','bold','fontname','arial');end
        title(regnamesshort{reg},'fontsize',14,'fontweight','bold','fontname','arial');
        if reg>=2;set(gca,'ytick',[],'yticklabel','');end
        if reg==2 || reg==3;set(gca,'xtick',[],'xticklabel','');end
    end
    figname='figures13';curpart=2;highqualityfiguresetup;

    %r
    figure(212);clf;curpart=1;highqualityfiguresetup;hold on;
    lefts=[0.07;0.28;0.49;0.7;0.07;0.28;0.49];bottoms=[0.53;0.53;0.53;0.53;0.08;0.08;0.08];spwidth=0.19;spheight=0.42;
    %Uncertainty and then median, for each region
    for reg=1:numregs
        if reg>=2;axes('position',[lefts(reg) bottoms(reg) spwidth spheight]);set(gca,'box','on');end
        if reg>=4;set(gca,'xtick',[4:4:12],'xticklabel',{'4','8','12'});else;set(gca,'xtick',[],'xticklabel','');end
        x=3:newxstops(reg);
        for model=1:13
            y=p99r_familyarray_rcp85_final{reg}(model,x)-p99r_familyarray_hist_final{reg}(model,x);
            plot(y,x-2,'color',paleregcolors{reg},'linewidth',0.3);hold on;
        end
        plot(eval(['p99r_rcp85_mmmedian_' regsuffixes{reg} '(x)'])-eval(['p99r_hist_mmmedian_' regsuffixes{reg} '(x)']),x-2,'color',regcolors{reg},'linewidth',2);hold on;
        xlim([-10 13]);ylim([1 65]);
        if reg==1
            set(gca,'position',[lefts(reg) bottoms(reg) spwidth spheight],'box','on');
            set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
            ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');
        end
        if reg==5;set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');end
        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
        if reg>=5;xlabel('r (J/kg)','fontsize',14,'fontweight','bold','fontname','arial');end
        title(regnamesshort{reg},'fontsize',14,'fontweight','bold','fontname','arial');
        if reg>=2;set(gca,'ytick',[],'yticklabel','');end
        if reg==2 || reg==3;set(gca,'xtick',[],'xticklabel','');end
    end
    figname='figures14';curpart=2;highqualityfiguresetup;
end


if makefigs15==1

    exist esiarray_histFINAL;
    if ans==0
    temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL;
    end

    totalnumdaysateachpoint=size(esiarray_histFINAL,3);

    for elevord=1:size(numpointsbybinandreg,1)
        for reg=1:size(numpointsbybinandreg,2)
            numdaysabovep99(elevord,reg)=numpointsbybinandreg(elevord,reg)*totalnumdaysateachpoint./100;
        end
    end
    nothingthere=numdaysabovep99==0;numdaysabovep99(nothingthere)=NaN;

    figure(32);clf;curpart=1;highqualityfiguresetup;hold on;
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    xlabel('Number of Days','fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
    ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');

    %elevcutoffs(1) is -100 m, elevcutoffs(3) is 0 m
    for reg=1:numregs
        x=3:newxstops(reg);
        plot(numdaysabovep99(x,reg),x-2,'color',regcolors{reg},'linewidth',2);hold on;
    end
    yearintitle='1980-2005';

    t=text(0.72,0.98,'Northwest','color',regcolors{1},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.94,'Southwest','color',regcolors{2},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.9,'N Great Plains','color',regcolors{3},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.86,'S Great Plains','color',regcolors{4},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.82,'Midwest','color',regcolors{5},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.78,'Southeast','color',regcolors{6},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.72,0.74,'Northeast','color',regcolors{7},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    title(strcat(['Count of Gridcell-Days Above p99, ',yearintitle]),'fontsize',14,'fontweight','bold','fontname','arial');

    ylim([1 65]);
    set(gca,'Position',[0.06 0.08 0.41 0.87],'Box','on');


    figname='figures15';curpart=2;highqualityfiguresetup;
end



%Determine, for each gridcell, what is ESI effect of changing T by 0.1 sigma? of changing RH? of changing SR?
if makefigs8==1
    for model=1:20
        modelname=MODEL_NAME{model};

        temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL;
        temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL;
        temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL;
        temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL;

        %Get st dev for each variable
        t_stdev=std(tarray_histFINAL,[],3);
        q_stdev=std(qarray_histFINAL,[],3);
        r_stdev=std(rarray_histFINAL,[],3);

        %ESI effect of lowering T by 0.1 st dev
        t_lower=tarray_histFINAL-0.1.*t_stdev;
        rharray_histFINAL=calcrhfromTanddewpt(t_lower-273.15,...
            calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),t_lower))); %3 min
            invalid=rharray_histFINAL>100;rharray_histFINAL(invalid)=NaN;qarray_histFINAL(invalid)=NaN;clear invalid; %10 sec
        esi_withtlower=0.63.*(t_lower-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_histFINAL+...
            0.0054.*((t_lower-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_histFINAL).^-1; %40 sec
        clear t_lower;

        %ESI effect of lowering q by 0.1 st dev
        q_lower=qarray_histFINAL-0.1.*q_stdev;
        rharray_histFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
            calcTdfromq_dynamicP(q_lower.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
        esi_withqlower=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_histFINAL+...
            0.0054.*((tarray_histFINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_histFINAL).^-1; %40 sec
        clear q_lower;

        %ESI effect of lowering r by 0.1 st dev
        r_lower=rarray_histFINAL-0.1.*r_stdev;
        rharray_histFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
            calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
        esi_withrlower=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histFINAL+0.002.*r_lower+...
            0.0054.*((tarray_histFINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*r_lower).^-1; %40 sec
        clear r_lower;

        clear rharray_histFINAL;


        meanteffect(model,:,:)=real(mean(esiarray_histFINAL-esi_withtlower,3,'omitnan'));
        meanqeffect(model,:,:)=real(mean(esiarray_histFINAL-esi_withqlower,3,'omitnan'));
        meanreffect(model,:,:)=real(mean(esiarray_histFINAL-esi_withrlower,3,'omitnan'));
        save(strcat(dataloc,'meaneffects.mat'),'meanteffect','meanqeffect','meanreffect');

        fprintf('Finished model %d\n',model);disp(clock);
    end
    meanmeanteffect=real(squeeze(mean(meanteffect,'omitnan')));
    meanmeanqeffect=real(squeeze(mean(meanqeffect,'omitnan')));
    meanmeanreffect=real(squeeze(mean(meanreffect,'omitnan')));

    teffect_model6=real(squeeze(meanteffect(6,:,:)));
    qeffect_model6=real(squeeze(meanqeffect(6,:,:)));
    reffect_model6=real(squeeze(meanreffect(6,:,:)));

    relteffect=teffect_model6./(teffect_model6+qeffect_model6+reffect_model6);
    relqeffect=qeffect_model6./(teffect_model6+qeffect_model6+reffect_model6);
    relreffect=reffect_model6./(teffect_model6+qeffect_model6+reffect_model6);



    figure(50);clf;curpart=1;highqualityfiguresetup;
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relteffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);

    colormap(colormaps('wbt','more','not'));colorbar;
    set(gca,'xtick',[],'ytick',[]);set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    title('T Weight','fontweight','bold','fontname','arial','fontsize',14);
    t=text(0.8,0.2,strcat(['Mean: ',num2str(round2(mean(mean(relteffect,'omitnan'),'omitnan'),0.01))]),'units','normalized');
    set(t,'fontweight','bold','fontname','arial','fontsize',11);
    set(gca,'Position',[0.3 0.67 0.4 0.29]);

    subplot(3,1,2);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relqeffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('wbt','more','not')),'fontweight','bold','fontname','arial','fontsize',11);cb=colorbar;cb.FontSize=11;
    title('q Weight','fontweight','bold','fontname','arial','fontsize',14);
    t=text(0.8,0.2,strcat(['Mean: ',num2str(round2(mean(mean(relqeffect,'omitnan'),'omitnan'),0.01))]),'units','normalized');
    set(t,'fontweight','bold','fontname','arial','fontsize',11);
    set(gca,'Position',[0.3 0.34 0.4 0.29]);

    subplot(3,1,3);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(relreffect')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0;'underlaycaxismax';1;'mystepunderlay';0.05;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('wbt','more','not')),'fontweight','bold','fontname','arial','fontsize',11);cb=colorbar;cb.FontSize=11;
    title('r Weight','fontweight','bold','fontname','arial','fontsize',14);
    t=text(0.8,0.2,strcat(['Mean: ',num2str(round2(mean(mean(relreffect,'omitnan'),'omitnan'),0.01))]),'units','normalized');
    set(t,'fontweight','bold','fontname','arial','fontsize',11);
    set(gca,'Position',[0.3 0.01 0.4 0.29]);

    figname='figures8';curpart=2;highqualityfiguresetup;
end

%Same data as previous but now make a fig 4 type sensitivity plot (i.e. an elevation profile for each region)
if makefigs16==1
    %Get number of points in each elev bin in each region
    for eb=1:size(elevcutoffs,2)-1
        %By NCA region
        for regloop=1:7                    
            temp=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1) & macaregions==regloop+1;
            teffect(eb,regloop)=mean(relteffect(temp),'omitnan');
            qeffect(eb,regloop)=mean(relqeffect(temp),'omitnan');
            reffect(eb,regloop)=mean(relreffect(temp),'omitnan');
        end
    end

    figure(51);clf;curpart=1;highqualityfiguresetup;
    x=1:size(elevcutoffs,2);xs=[x(1:81) fliplr(x(1:81))]';
    lefts=[0.07;0.28;0.49;0.7;0.07;0.28;0.49];bottoms=[0.55;0.55;0.55;0.55;0.05;0.05;0.05];
    lefttitlepos=[0.32;0.32;0.06;0.06;0.35;0.32;0.32];
    for regloop=1:7
        if regloop>=2;subplot(2,4,regloop);end
        xforward=x(xstarts(regloop):newxstops(regloop));

        tplot=teffect(xstarts(regloop):newxstops(regloop),regloop);
        qplot=qeffect(xstarts(regloop):newxstops(regloop),regloop);
        rplot=reffect(xstarts(regloop):newxstops(regloop),regloop);

        plot(tplot,xforward,'color',colors('medium green'),'linewidth',2);hold on;
        plot(qplot,xforward,'color',colors('blue'),'linewidth',2);hold on;
        plot(rplot,xforward,'color',colors('orange'),'linewidth',2);hold on;

        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'ytick',[3:20:83],'yticklabel',[]);
        ylim([3 83]);xlim([0 1]);
        t=text(lefttitlepos(regloop),0.97,regnamesfull{regloop},'units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
        if regloop==1 || regloop==5
            ylabel('Elevation (m)','fontsize',12,'fontweight','bold','fontname','arial');
            set(gca,'yticklabel',{'0','1000','2000','3000','4000'});
        end
        set(gca,'Position',[lefts(regloop) bottoms(regloop) 0.19 0.44]);
    end

    t=text(1.2,0.7,'Temperature','units','normalized');set(t,'color',colors('medium green'),'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(1.2,0.5,'Specific humidity','units','normalized');set(t,'color',colors('blue'),'fontsize',14,'fontweight','bold','fontname','arial');
    t=text(1.2,0.3,'Solar radiation','units','normalized');set(t,'color',colors('orange'),'fontsize',14,'fontweight','bold','fontname','arial');

    figname='figures16';curpart=2;highqualityfiguresetup;
end



if makefigs4==1
    figure(1);clf;curpart=1;highqualityfiguresetup;

    p99esibypoint_family_rcp85(12,:,:)=p99esibypoint_family_rcp85(12,:,:).*2;
    thisdiff=p99esibypoint_family_rcp85-p99esibypoint_family_hist;
    invalid=thisdiff<=0;thisdiff(invalid)=NaN;
    for i=1:692
        for j=1:292
            if sum(~isnan(thisdiff(:,i,j)))<8 %fewer than 8 models have data for this point
                thisdiff(:,i,j)=NaN;
            end
        end
    end
    quartile1=squeeze(quantile(thisdiff,0.25));quartile3=squeeze(quantile(thisdiff,0.75));
    dataincentralquartiles=NaN.*ones(size(thisdiff,1),692,292);
    for i=1:692
        for j=1:292
            for modelfamily=1:size(thisdiff,1)
                if thisdiff(modelfamily,i,j)>=quartile1(i,j) && thisdiff(modelfamily,i,j)<=quartile3(i,j)
                    dataincentralquartiles(modelfamily,i,j)=thisdiff(modelfamily,i,j);
                end
            end
        end
    end
    thisarr=squeeze(mean(dataincentralquartiles,'omitnan'))./3.7; %3.7 C of warming between the two periods of interest under RCP8.5
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(thisarr')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';0.8;'underlaycaxismax';1.4;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;
    set(cb,'ytick',0.8:0.2:1.4);
    title(strcat('Per-Degree Change in p99 ESI (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.05 0.55 0.9 0.4]);

    f=load(strcat(dataloc,'exceedratio.mat'));
    if strcmp(meanormedian,'median')
        exceedratio_future_median_esi=f.exceedratio_future_median_esi;
        getrid=exceedratio_future_median_esi==0;exceedratio_future_median_esi(getrid)=NaN;
    else
        exceedratio_future_mean_esi=f.exceedratio_future_mean_esi;
        getrid=exceedratio_future_mean_esi==0;exceedratio_future_mean_esi(getrid)=NaN;
    end


    if strcmp(meanormedian,'median')
        getrid=zeros(692,292);getrid(1:100,:)=exceedratio_future_median_esi(1:100,:)>40 & disttooceanall(1:100,:)<0.5;exceedratio_future_median_esi(logical(getrid))=NaN;

        getrid=zeros(692,292);getrid=exceedratio_future_median_esi>32 & disttogreatlakeall<0.8;exceedratio_future_median_esi(logical(getrid))=NaN;
        invalid=exceedratio_future_median_esi<10;exceedratio_future_median_esi(invalid)=NaN;
        getrid=zeros(692,292);getrid=exceedratio_future_median_esi<24 & disttogreatlakeall<0.3;exceedratio_future_median_esi(logical(getrid))=NaN;
        getrid=zeros(692,292);getrid(615:end,:)=exceedratio_future_median_esi(615:end,:)>28 & disttooceanall(615:end,:)<0.5;exceedratio_future_median_esi(logical(getrid))=NaN;
        for i=580:587;for j=222:226;exceedratio_future_median_esi(i,j)=NaN;end;end
    else
        getrid=zeros(692,292);getrid(1:100,:)=exceedratio_future_mean_esi(1:100,:)>40 & disttooceanall(1:100,:)<0.5;exceedratio_future_mean_esi(logical(getrid))=NaN;

        getrid=zeros(692,292);getrid=exceedratio_future_mean_esi>32 & disttogreatlakeall<0.8;exceedratio_future_mean_esi(logical(getrid))=NaN;
        invalid=exceedratio_future_mean_esi<10;exceedratio_future_mean_esi(invalid)=NaN;
        getrid=zeros(692,292);getrid=exceedratio_future_mean_esi<24 & disttogreatlakeall<0.3;exceedratio_future_mean_esi(logical(getrid))=NaN;
        getrid=zeros(692,292);getrid(615:end,:)=exceedratio_future_mean_esi(615:end,:)>28 & disttooceanall(615:end,:)<0.5;exceedratio_future_mean_esi(logical(getrid))=NaN;
        for i=580:587;for j=222:226;exceedratio_future_mean_esi(i,j)=NaN;end;end
    end

    
    
    subplot(2,1,2);
    if strcmp(meanormedian,'median')
        arr3=exceedratio_future_median_esi;
    else
        arr3=exceedratio_future_mean_esi.^(1/3.7); %3.7 C of warming between the two periods of interest under RCP8.5
    end
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud((arr3)')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';2;'underlaycaxismax';3;'mystepunderlay';3;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',2:0.25:3);
    title('Per-Degree Relative Increase in ESI > Historical p99','fontweight','bold','fontname','arial','fontsize',14);
    t=text(-0.04,1.05,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',16);
    set(gca,'Position',[0.05 0.05 0.9 0.4]);%set(gca,'colormap',cmap);


    figname='figures4';curpart=2;highqualityfiguresetup;
end


if makefigs5==1
    figure(3);clf;curpart=1;highqualityfiguresetup;
    temp=load(strcat(dataloc,'pctagreement.mat'));pctagreement=temp.pctagreement;
    
    %3.7 C warming under RCP8.5 according to Collins et al. 2013
    for reg=1:numregs
        x=3:newxstops(reg);
        x_0to250=x(1:6);diff_0to250=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_0to250)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_0to250)']);
        if pctagreement(reg,1)>=0.75;lw=4;else;lw=2;end
        plot(diff_0to250./3.7,x_0to250-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_250to500=x(6:min(11,size(x,2)));diff_250to500=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_250to500)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_250to500)']);
        if pctagreement(reg,2)>=0.75;lw=4;else;lw=2;end
        plot(diff_250to500./3.7,x_250to500-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_500to1000=x(min(11,size(x,2)):min(21,size(x,2)));diff_500to1000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_500to1000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_500to1000)']);
        if pctagreement(reg,3)>=0.75;lw=4;else;lw=2;end
        plot(diff_500to1000./3.7,x_500to1000-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_1000to2000=x(min(21,size(x,2)):min(41,size(x,2)));diff_1000to2000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_1000to2000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_1000to2000)']);
        if pctagreement(reg,4)>=0.75;lw=4;else;lw=2;end
        plot(diff_1000to2000./3.7,x_1000to2000-2,'color',regcolors{reg},'linewidth',lw);hold on;

        x_2000to3000=x(min(41,size(x,2)):min(61,size(x,2)));diff_2000to3000=eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '(x_2000to3000)'])-eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '(x_2000to3000)']);
        if pctagreement(reg,5)>=0.75;lw=4;else;lw=2;end
        plot(diff_2000to3000./3.7,x_2000to3000-2,'color',regcolors{reg},'linewidth',lw);hold on;
    end
    
    t=text(0.02,0.97,'Northwest','color',regcolors{1},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.93,'Southwest','color',regcolors{2},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.89,'N Great Plains','color',regcolors{3},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.85,'S Great Plains','color',regcolors{4},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.81,'Midwest','color',regcolors{5},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.77,'Southeast','color',regcolors{6},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');
    t=text(0.02,0.73,'Northeast','color',regcolors{7},'units','normalized');set(t,'fontsize',14,'fontname','arial','fontweight','bold');

    ylim([1 65]);
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    set(gca,'ytick',[1:20:61],'yticklabel',{'0','1000','2000','3000'});
    ylabel('Elevation (m)','fontsize',14,'fontweight','bold','fontname','arial');
    xlabel(strcat('Future - Historical ESI (',char(176),'C)'),'fontsize',14,'fontweight','bold','fontname','arial');
    title('Per-Degree Change, 2074-2099 minus 1980-2005','fontsize',14,'fontweight','bold','fontname','arial');

    fname='figures5';
    figname=fname;curpart=2;highqualityfiguresetup;
end


if makefigs17==1
    pts0to100=NaN.*ones(692,292);pts200to300=NaN.*ones(692,292);pts400to600=NaN.*ones(692,292);
    pts800to1200=NaN.*ones(692,292);pts1600to2400=NaN.*ones(692,292);pts2600to3400=NaN.*ones(692,292);
    thisdiff=squeeze(quantile(p99esibypoint_family_rcp85-p99esibypoint_family_hist,0.5));
    for i=1:692
        for j=1:292
            if macaelevFINAL(i,j)>=0 && macaelevFINAL(i,j)<100;pts0to100(i,j)=thisdiff(i,j);end
            if macaelevFINAL(i,j)>=200 && macaelevFINAL(i,j)<300;pts200to300(i,j)=thisdiff(i,j);end
            if macaelevFINAL(i,j)>=400 && macaelevFINAL(i,j)<600;pts400to600(i,j)=thisdiff(i,j);end
            if macaelevFINAL(i,j)>=800 && macaelevFINAL(i,j)<1200;pts800to1200(i,j)=thisdiff(i,j);end
            if macaelevFINAL(i,j)>=1600 && macaelevFINAL(i,j)<2400;pts1600to2400(i,j)=thisdiff(i,j);end
            if macaelevFINAL(i,j)>=2600 && macaelevFINAL(i,j)<3400;pts2600to3400(i,j)=thisdiff(i,j);end
        end
    end
    
    figure(153);clf;curpart=1;highqualityfiguresetup;
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts0to100')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 0-100 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.05 0.67 0.4 0.28]);
    t=text(-0.04,1.05,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);
        
    subplot(3,2,2);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts200to300')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 200-300 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.55 0.67 0.4 0.28]);
    t=text(-0.04,1.05,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,2,3);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts400to600')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 400-600 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.05 0.34 0.4 0.28]);
    t=text(-0.04,1.05,'c)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,2,4);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts800to1200')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 800-1200 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.55 0.34 0.4 0.28]);
    t=text(-0.04,1.05,'d)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,2,5);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts1600to2400')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 1600-2400 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.05 0.01 0.4 0.28]);
    t=text(-0.04,1.05,'e)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,2,6);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(pts2600to3400')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';fig1cmin;'underlaycaxismax';fig1cmax;'mystepunderlay';0.25;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,flipud(colormaps('whiteorangered','more','not'))),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',3:5,'yticklabel',{'3','4','5'});cb.Label.String=strcat('Change (',char(176),'C)');
    title('Change in p99 ESI: 2600-3400 m','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.55 0.01 0.4 0.28]);
    t=text(-0.04,1.05,'f)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    figname='figures17';curpart=2;highqualityfiguresetup;
end


if makefigs3==1
    %Combine 3 plots into 1 later
    %0-250 m
    figure(765);clf;curpart=1;highqualityfiguresetup;
    ylims=0.15*ones(7,1);lefts=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];
    for regloop=1:7 
        era5val(1,regloop)=mean(era5trendasesi(regloop,3:7),'omitnan');
        stnval(1,regloop)=stnstrend(regloop,1);
        macavals{1,regloop}=squeeze(mean(macatrend(:,regloop,3:7),3,'omitnan'));
        
        if regloop>=2;subplot(1,7,regloop);end
        b=boxplot(macavals{1,regloop},'Widths',0.7);set(b,'linewidth',2);hold on;
        if sum(era5pointsbyregandelevbin(regloop,1))>=25;scatter(1,era5val(1,regloop),150,colors('medium green'),'filled');end %require at least 25 ERA5 gridpoints
        
        regc=eval([regsuffixes{regloop} 'c;']);
        if sum(regc(1))>=2;scatter(1,stnval(1,regloop),150,colors('purple'),'filled');end %require at least 2 stns for this region/elevation bin combination
        ylim([-ylims(regloop) ylims(regloop)]);
        title(regnamesshort{regloop},'fontname','arial','fontweight','bold','fontsize',14);
        set(gca,'xticklabel','');
        set(gca,'fontname','arial','fontweight','bold','fontsize',12);
        set(gca,'Position',[lefts(regloop) 0.1 0.09 0.8]);
        if regloop>=2;set(gca,'yticklabel','');end
    end
    figname='boxplot0250m';curpart=2;highqualityfiguresetup;
    
    %500-750 m
    figure(766);clf;curpart=1;highqualityfiguresetup;
    ylims=0.15*ones(7,1);lefts=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];
    for regloop=1:7 
        era5val(2,regloop)=mean(era5trendasesi(regloop,13:17),'omitnan');
        stnval(2,regloop)=stnstrend(regloop,3);
        macavals{2,regloop}=squeeze(mean(macatrend(:,regloop,13:17),3,'omitnan'));
        if regloop>=2;subplot(1,7,regloop);end
        b=boxplot(macavals{2,regloop},'Widths',0.7);set(b,'linewidth',2);hold on;
        if sum(era5pointsbyregandelevbin(regloop,3))>=25;scatter(1,era5val(2,regloop),150,colors('medium green'),'filled');end %require at least 25 ERA5 gridpoints
        
        regc=eval([regsuffixes{regloop} 'c;']);
        if sum(regc(3))>=2;scatter(1,stnval(2,regloop),150,colors('purple'),'filled');end %require at least 2 stns for this region/elevation bin combination
        ylim([-ylims(regloop) ylims(regloop)]);
        title(regnamesshort{regloop},'fontname','arial','fontweight','bold','fontsize',14);
        set(gca,'xticklabel','');
        set(gca,'fontname','arial','fontweight','bold','fontsize',12);
        set(gca,'Position',[lefts(regloop) 0.1 0.09 0.8]);
        if regloop>=2;set(gca,'yticklabel','');end
    end
    figname='boxplot500750m';curpart=2;highqualityfiguresetup;
    
    %1500-2000 m
    figure(767);clf;curpart=1;highqualityfiguresetup;
    ylims=0.15*ones(7,1);lefts=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];
    for regloop=1:7 
        era5val(3,regloop)=mean(era5trendasesi(regloop,33:42),'omitnan');
        stnval(3,regloop)=mean(stnstrend(regloop,7:8),'omitnan');
        macavals{3,regloop}=squeeze(mean(macatrend(:,regloop,33:42),3,'omitnan'));
        if regloop>=2;subplot(1,7,regloop);end
        if regloop~=5 && regloop~=7
            b=boxplot(macavals{3,regloop},'Widths',0.7);set(b,'linewidth',2);hold on;
            if sum(era5pointsbyregandelevbin(regloop,7:8))>=25;scatter(1,era5val(3,regloop),150,colors('medium green'),'filled');end %require at least 25 ERA5 gridpoints

            regc=eval([regsuffixes{regloop} 'c;']);
            if sum(regc(7:8))>=2;scatter(1,stnval(3,regloop),150,colors('purple'),'filled');end %require at least 2 stns for this region/elevation bin combination
            ylim([-ylims(regloop) ylims(regloop)]);
        else
            set(gca,'visible','off');
        end
        set(gca,'xticklabel','');
        title(regnamesshort{regloop},'fontname','arial','fontweight','bold','fontsize',14);
        set(gca,'fontname','arial','fontweight','bold','fontsize',12);
        set(gca,'Position',[lefts(regloop) 0.1 0.09 0.8]);
        if regloop>=2;set(gca,'yticklabel','');end
    end
    figname='boxplot15002000m';curpart=2;highqualityfiguresetup;
end

if makefigs6==1
    thistorical=p99tbypoint_family_hist;invalid=thistorical<=0;thistorical(invalid)=NaN;
    tdiff=p99tbypoint_family_rcp85-p99tbypoint_family_hist;invalid=tdiff<=0;tdiff(invalid)=NaN;
    qhistorical=p99qbypoint_family_hist;invalid=qhistorical<=0;qhistorical(invalid)=NaN;
    qdiff=p99qbypoint_family_rcp85-p99qbypoint_family_hist;invalid=qdiff<=0;qdiff(invalid)=NaN;
    rhistorical=p99rbypoint_family_hist;invalid=rhistorical<=0;rhistorical(invalid)=NaN;
    rdiff=p99rbypoint_family_rcp85-p99rbypoint_family_hist;
    %Eliminate data if fewer than 8 models have data for a point
    for i=1:692
        for j=1:292
            if sum(~isnan(thistorical(:,i,j)))<8;thistorical(:,i,j)=NaN;end
            if sum(~isnan(tdiff(:,i,j)))<8;tdiff(:,i,j)=NaN;end
            if sum(~isnan(qhistorical(:,i,j)))<8;qhistorical(:,i,j)=NaN;end
            if sum(~isnan(qdiff(:,i,j)))<8;qdiff(:,i,j)=NaN;end
            if sum(~isnan(rhistorical(:,i,j)))<8;rhistorical(:,i,j)=NaN;end
            if sum(~isnan(rdiff(:,i,j)))<8;rdiff(:,i,j)=NaN;end
        end
    end 

    %Get mean of central quantiles
    quartile1_thistorical=squeeze(quantile(thistorical,0.25));quartile3_thistorical=squeeze(quantile(thistorical,0.75));thistoricalcentralquartiles=NaN.*ones(13,692,292);
    quartile1_tdiff=squeeze(quantile(tdiff,0.25));quartile3_tdiff=squeeze(quantile(tdiff,0.75));tdiffcentralquartiles=NaN.*ones(13,692,292);
    quartile1_qhistorical=squeeze(quantile(qhistorical,0.25));quartile3_qhistorical=squeeze(quantile(qhistorical,0.75));qhistoricalcentralquartiles=NaN.*ones(13,692,292);
    quartile1_qdiff=squeeze(quantile(qdiff,0.25));quartile3_qdiff=squeeze(quantile(qdiff,0.75));qdiffcentralquartiles=NaN.*ones(13,692,292);
    quartile1_rhistorical=squeeze(quantile(rhistorical,0.25));quartile3_rhistorical=squeeze(quantile(rhistorical,0.75));rhistoricalcentralquartiles=NaN.*ones(13,692,292);
    quartile1_rdiff=squeeze(quantile(rdiff,0.25));quartile3_rdiff=squeeze(quantile(rdiff,0.75));rdiffcentralquartiles=NaN.*ones(13,692,292);
    for i=1:692
        for j=1:292
            for modelfamily=1:13
                if thistorical(modelfamily,i,j)>=quartile1_thistorical(i,j) && thistorical(modelfamily,i,j)<=quartile3_thistorical(i,j)
                    thistoricalcentralquartiles(modelfamily,i,j)=thistorical(modelfamily,i,j);
                end
                if tdiff(modelfamily,i,j)>=quartile1_tdiff(i,j) && tdiff(modelfamily,i,j)<=quartile3_tdiff(i,j)
                    tdiffcentralquartiles(modelfamily,i,j)=tdiff(modelfamily,i,j);
                end
                if qhistorical(modelfamily,i,j)>=quartile1_qhistorical(i,j) && qhistorical(modelfamily,i,j)<=quartile3_qhistorical(i,j)
                    qhistoricalcentralquartiles(modelfamily,i,j)=qhistorical(modelfamily,i,j);
                end
                if qdiff(modelfamily,i,j)>=quartile1_qdiff(i,j) && qdiff(modelfamily,i,j)<=quartile3_qdiff(i,j)
                    qdiffcentralquartiles(modelfamily,i,j)=qdiff(modelfamily,i,j);
                end
                if rhistorical(modelfamily,i,j)>=quartile1_rhistorical(i,j) && rhistorical(modelfamily,i,j)<=quartile3_rhistorical(i,j)
                    rhistoricalcentralquartiles(modelfamily,i,j)=rhistorical(modelfamily,i,j);
                end
                if rdiff(modelfamily,i,j)>=quartile1_rdiff(i,j) && rdiff(modelfamily,i,j)<=quartile3_rdiff(i,j)
                    rdiffcentralquartiles(modelfamily,i,j)=rdiff(modelfamily,i,j);
                end
            end
        end
    end
    thistorical_touse=squeeze(mean(thistoricalcentralquartiles,'omitnan'));invalid=thistorical_touse==0;thistorical_touse(invalid)=NaN;
    tdiff_touse=squeeze(mean(tdiffcentralquartiles,'omitnan'));
    qhistorical_touse=squeeze(mean(qhistoricalcentralquartiles,'omitnan'));invalid=qhistorical_touse==0;qhistorical_touse(invalid)=NaN;
    qdiff_touse=squeeze(mean(qdiffcentralquartiles,'omitnan'));
    rhistorical_touse=squeeze(mean(rhistoricalcentralquartiles,'omitnan'));invalid=rhistorical_touse==0;rhistorical_touse(invalid)=NaN;
    rdiff_touse=squeeze(mean(rdiffcentralquartiles,'omitnan'));

    
    
    figure(60);clf;curpart=1;highqualityfiguresetup;
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud((thistorical_touse-273.15)')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';17;'underlaycaxismax';51;'mystepunderlay';2;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('t','more','not')),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',20:10:50);
    title(strcat('Historical p99 T (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.2 0.67 0.6 0.28]);
    t=text(-0.04,1.05,'a)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,1,2);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(1000.*qhistorical_touse')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';6;'underlaycaxismax';23;'mystepunderlay';1;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('q','more','not')),'fontweight','bold','fontname','arial','fontsize',11);cb=colorbar;cb.FontSize=11;
    title('Historical p99 q (g/kg)','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.2 0.34 0.6 0.28]);
    t=text(-0.04,1.05,'b)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    subplot(3,1,3);
    data={flipud(macalatsFINAL');flipud(macalonsFINAL');flipud(rhistorical_touse')};
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    'underlaycaxismin';280;'underlaycaxismax';420;'mystepunderlay';10;'overlaynow';0;'datatounderlay';data;'conttoplot';'North America';'nonewfig';1};
    datatype='custom';region='usa';
    plotModelData(data,region,vararginnew,datatype);
    set(gca,'xtick',[],'ytick',[],'colormap',colormap(gca,colormaps('blueyellowred','more','not')),'fontweight','bold','fontname','arial','fontsize',11);
    cb=colorbar;cb.FontSize=11;set(cb,'ytick',300:25:400);
    title('Historical p99 r (J/kg)','fontweight','bold','fontname','arial','fontsize',14);
    set(gca,'Position',[0.2 0.01 0.6 0.28]);
    t=text(-0.04,1.05,'c)','units','normalized');set(t,'fontweight','bold','fontname','arial','fontsize',18);

    figname='figures6';curpart=2;highqualityfiguresetup;
end
