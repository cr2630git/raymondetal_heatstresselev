%%Some commands for making nice figures
%These should be run before any publication-quality figure is produced
%Derived from brief tutorial at https://dgleich.wordpress.com/2013/06/04/...
    %creating-high-quality-graphics-in-matlab-for-papers-and-presentations/
    
%It doesn't matter how things look in the Matlab window, only once they're viewed in the final format

%Outline for the script that calls this one:
%1. create the blank figure
%2. curpart=1;highqualityfiguresetup;
%3. plot whatever is going to be plotted
%4. curpart=2;figloc='/a/b/c/';figname='XXXX';highqualityfiguresetup;

exist width;if ans==0;width=12;end %default page width
exist height;if ans==0;height=7;end %default page height
alw=0.75;fsz=12;lw=1.5;msz=7;
if curpart==1 %initial figure set-up
    pos=get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) width*100 height*100]);
    %Line below is a default setting but if necessary can be commented out to eliminate the blank axes that it creates
    %set(gca,'FontSize',fsz,'LineWidth',alw,'FontName','Arial','FontWeight','bold');
elseif curpart==2 %preparation for saving, & saving itself
    curaxiscolor=get(gca,'color');
    if curaxiscolor(1)==1 && curaxiscolor(2)==1 && curaxiscolor(3)==1 %i.e. white
        set(gcf,'InvertHardcopy','on');
    else
        set(gcf,'InvertHardcopy','off');
    end
    set(gcf,'PaperUnits','inches');
    papersize=get(gcf,'PaperSize');
    left=(papersize(1)-width)/2;
    bottom=(papersize(2)-height)/2;
    myfiguresize=[left,bottom,width,height];
    
    
    addingaftermarkettext=0;
    if addingaftermarkettext==1
        myxlim=xlim;myylim=ylim;
        figheight=myylim(2)-myylim(1);figwidth=myxlim(2)-myxlim(1);
        fprintf('Fig bottom left corner is [%d,%d], fig top right corner is [%d,%d]\n',...
            myxlim(1),myylim(1),myxlim(2),myylim(2));


        %Now, actually create these 'after-market text' descriptions
        %All coordinates are optimized for the final png figures
        numdescrsalreadyadded=0;
        exist fullshadingdescr;
        if ans==1
            text(myxlim(1)+0.38*figwidth,myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded,fullshadingdescr,...
                'fontsize',14,'fontweight','bold','fontname','arial');
            numdescrsalreadyadded=numdescrsalreadyadded+1;
        end
        exist fullcontoursdescr;
        if ans==1
            if ~strcmp(fullshadingdescr,fullcontoursdescr) %i.e. if they're not identical
                text(myxlim(1)+0.38*figwidth,myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded,fullcontoursdescr,...
                    'fontsize',14,'fontweight','bold','fontname','arial');
                numdescrsalreadyadded=numdescrsalreadyadded+1;
            end
        end
        exist windbarbsdescr;
        if ans==1
            exist inclrefvectext;
            if ans==1
                if inclrefvectext==1
                    text(myxlim(1)+0.38*figwidth,myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded,windbarbsdescr,...
                        'fontsize',14,'fontweight','bold','fontname','arial');
                    numdescrsalreadyadded=numdescrsalreadyadded+1;
                end
            end
        end
        exist refval;
        if ans==1
            exist inclrefvectext;
            if ans==1
                if inclrefvectext==1
                    text(myxlim(1)+0.38*figwidth,myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded,...
                        sprintf('Reference: %0.0f m/s',refval),'fontsize',14,'fontweight','bold','fontname','arial');
                end
            end
        end
        exist normrefveclength;
        if ans==1
            if normrefveclength~=0
                x=[0.58-normrefveclength 0.58];
                y=[myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded-0.05 
                    myylim(1)-0.06*figheight-0.05*numdescrsalreadyadded-0.05];
                annotation('textarrow',x,y,'linewidth',2);
            end
        end
    end

    set(gcf,'PaperPosition',myfiguresize);
    %set(gcf,'PaperPositionMode','auto'); %mostly so custom subaxes don't get moved around -- apply only as necessary
    
    %used only for creation of figures in NCC paper, March 2020
    %set(gcf,'PaperPosition',myfiguresize,'PaperOrientation','landscape','PaperSize',[20 10]);
    
    
    printedalready=0;
    exist saveaseps;
    if ans==1;print(gcf,strcat(figloc,figname,'.eps'),'-depsc','-r600','-cmyk');printedalready=1;end
    exist saveaspdf;
    if ans==1;print(gcf,strcat(figloc,figname,'.pdf'),'-dpdf','-r600','-cmyk');printedalready=1;end
    
    if printedalready==0;print(strcat(figloc,figname),'-dpng','-r600');end
    fprintf('Figure name is %s\n',strcat(figloc,figname));
    
    
    %Clear after-market text so that the next figure includes or excludes the right phrases
    clear fullcontoursdescr;clear fullshadingdescr;clear windbarbsdescr;
    clear refval;clear normrefveclength;
    %Also clear width & height so defaults are used when variables are not specified
    clear width;clear height;
    
    clear saveaseps;clear saveaspdf;
end
    