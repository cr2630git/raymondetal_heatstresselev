
%Elevation-aware projections for the US using MACA
%Data obtained in two sections: Western US (105-125 W, 30-50 N) and Eastern US (105-66 W, 24-50 N)
%https://climate.northwestknowledge.net/MACA
%http://thredds.northwestknowledge.net:8080/thredds/reacch_climate_CMIP5_aggregated_macav2_catalog.html

mastertroubleshooting=0; %suppresses the typical deletion of arrays
    
reload=1; %5 sec; ALWAYS HAVE ON
readdata=0; %50 min per model and time period for temperature and specific humidity, 2 hour per model and time period for radiation
    readmodelstart=4;readmodelstop=4;
createfinalbigarrays=0; %45 min per model and time period
    arraycreationmodelstart=17;arraycreationmodelstop=17;
    arraycreationexpstart=2;arraycreationexpstop=2;  %1 is hist, 2 is rcp85
    savestuff=1; %default is 1 -- set to 0 only when troubleshooting
extremeheatbyelev=0; %1 hr per model for historical, 2 hr per model for future; 40 min for dohypotheticalsalso ONLY
    maincalcmodelstart=6;maincalcmodelstop=6;
    maincalcexpstart=2;maincalcexpstop=2; %1 is hist, 2 is rcp85
    varstart=1;varstop=5;dohypotheticalsalso=1;donormalpart=1;
bypointcalculation=0; %20 min per model for historical, 20 min per model for future
    bypointmodelstart=1;bypointmodelstop=1;
    bypointexpstart=1;bypointexpstop=2; %1 is hist, 2 is rcp85
    doesionly=0; %0 means do indiv changes of T, q, r also
    savethisnow=0;
doqc=0; %40 min
    redoeliminationofbaddata=1;
    pointcutoff=50; %minimum number of points in a region's elevation bin
constructfamilyarrays=0; %20 sec
dobootstrappingofelevcurves=0; %5 min
numdaysexceeding=0; %3 hr
tqrcontribs=0; %20 min per model, 7 hr total
gomakefigures=0;
    makefig1=0;
        meanormedian='mean';
    makefig2=0; %2 min
    makefig3s10ands11=0;
        xstarts=[3;3;7;3;4;3;3];xstops=[62;81;72;41;14;32;28];
    makefig4=0;
    makefigs1s2=0; %5 min
    makefigs3=0;
    makefigs4=0;
    makefigs5=0;
    makefigs6=0;
    makefigs7=0;
    makefigs8=0;
    makefigs9=0;
    makefigs12tos14=0;
    makefigs15=0;
    makefigs16=0;
    makefigs17=0;
compareagainstobstrends=0;
histbiascalc=0;



icloud='~/Library/Mobile Documents/com~apple~CloudDocs/';
figloc=strcat(icloud,'General_Academics/Research/RCMES_heatbyelevation/');
dataloc='/Volumes/ExternalDriveD/MACA_Projections/';


EXP_NAME={'historical';'rcp45'; 'rcp85';};
VAR_NAME = {'tasmax';'rsds';'uas';'vas';'huss'};
VAR_LONGNAME = {'air_temperature';'surface_downwelling_shortwave_flux_in_air'; 'northward_wind';'eastward_wind';'specific_humidity';};
UNITS={'K';'K';'%';'%';'mm';'W m-2';'m s-1';'m s-1';'kg kg-1'};
MODEL_NAME={'CSIRO-Mk3-6-0';'inmcm4'; 'CanESM2';'MIROC-ESM';...
     'MIROC-ESM-CHEM';'MRI-CGCM3';'CNRM-CM5';'IPSL-CM5A-MR';... 
    'IPSL-CM5A-LR';'GFDL-ESM2G';'GFDL-ESM2M';'MIROC5';...
     'bcc-csm1-1';'BNU-ESM';'NorESM1-M';'CCSM4';...
    'IPSL-CM5B-LR';'bcc-csm1-1-m';'HadGEM2-ES365';'HadGEM2-CC365'};
modelweights_full=[1;0.5;1;0.5;0.5;1;1;0.33;...
    0.33;0.5;0.5;1;0.5;1;0.5;0.5;...
    0.33;0.5;0.5;0.5];
modelweights=modelweights_full./sum(modelweights_full);


regnamesfull={'Northwest';'Southwest';'Northern Great Plains';'Southern Great Plains';'Midwest';'Southeast';'Northeast'};
regnamesshort={'NW';'SW';'NGP';'SGP';'MW';'SE';'NE'};
regcolors={colors('light green');colors('light red');colors('orange');colors('gold');colors('histogram blue');colors('forest green');colors('purple')};
regsuffixes={'nw';'sw';'ngp';'sgp';'mw';'se';'ne'};
numregs=size(regsuffixes,1);

varcolors={colors('medium green');colors('blue')};

letterlabels={'a';'b';'c';'d';'e';'f';'g'};

for c=1:size(regcolors,1)
    thiscolor=regcolors{c};
    temp=max(max(thiscolor))-thiscolor;
    paleregcolors{c}=thiscolor+0.25*temp;
end
for c=1:size(varcolors,1)
    thiscolor=varcolors{c};
    temp=max(max(thiscolor))-thiscolor;
    palevarcolors{c}=thiscolor+0.25*temp;
end

fig1cmin=2.7;fig1cmax=5.4;


%Manual borders of NCA regions, for complete transparency
%Northwest
northwestpolygonlats=[42;42;44.47;...
    44.75;44.65;44.55;44.55;44.52;44.56;44.55;44.46;44.5;44.36;...
    44.49;44.81;44.79;45.7;45.46;45.61;45.9;46.3;46.65;...
    46.65;46.97;47.26;47.41;47.63;47.99;...
    49;49;48.25;48.49];
northwestpolygonlons=[-124.22;-111;-111.05;...
    -111.38;-111.51;-111.49;-111.7;-111.82;-111.87;-112.34;-112.39;-112.74;-112.85;...
    -113.03;-113.2;-113.35;-113.95;-114.34;-114.56;-114.43;-114.47;-114.32;...
    -114.63;-115.05;-115.33;-115.71;-115.7;-116.05;...
    -116.05;-123.278;-123.32;-124.77];
%Southwest
southwestpolygonlats=[32.53;32.663;32.454;31.32;31.35;31.77;31.784;...
    31.895;32;32;37;37;41;41;42;42];
southwestpolygonlons=[-117.13;-114.81;-114.84;-111.07;-108.23;-108.2;-106.578;...
    -106.642;-106.622;-103;-103;-102;-102;-111;-111;-124.22];
%Great Plains North
gpnpolygonlats=[49;47.99;47.63;47.41;47.26;46.97;46.65;46.65;46.3;45.9;...
    45.61;45.46;45.7;44.79;44.81;44.49;44.36;44.5;44.46;44.55;44.56;44.52;...
    44.55;44.55;44.65;44.75;44.47;41;...
    41;40;40;40.585;41.059;41.179;41.195;41.308;41.463;41.546;41.959;42.395;...
    42.459;42.495;42.627;42.724;43.13;43.28;43.485;43.504;45.302;45.626;45.921;...
    46.894;47.02;47.664;48.054;48.6;49;49];
gpnpolygonlons=[-116.05;-116.05;-115.7;-115.71;-115.33;-115.05;-114.63;-114.32;-114.47;-114.43;...
    -114.56;-114.34;-113.95;-113.35;-113.2;-113.03;-112.85;-112.74;-112.39;-112.34;-111.87;-111.82;...
    -111.7;-111.49;-111.51;-111.38;-111.05;-111;...
    -102;-102;-95.295;-95.754;-95.872;-95.865;-95.92;-95.908;-95.945;-96.078;-96.147;-96.411;...
    -96.38;-96.478;-96.52;-96.641;-96.441;-96.577;-96.593;-96.454;-96.454;-96.855;-96.57;...
    -96.746;-96.828;-96.872;-97.075;-97.13;-97.234;-116];
%Great Plains South
gpspolygonlats=[29.69;30.89;32;33.56;33.64;35.45;36.55;38.959;39.12;39.15;39.218;39.565;39.796;40;40;37;37;37;32;32;31.895;31.784;31.75;31.75;31.47;31.38;31.08;...
    30.99;30.85;30.77;30.66;30.2;29.94;29.66;29.5;29.43;...
    29.32;29.27;29.18;29.15;29.03;28.98;29.08;29.24;29.73;...
    29.78;29.87;29.80;29.77;29.54;29.47;29.37;29.25;...
    29.09;28.94;28.25;28.14;27.77;27.58;27.30;27.02;26.86;...
    26.44;26.09;26.07;26.01;25.84;25.92;25.96];
    gpspolygonlons=[-93.84;-93.56;-94;-94;-94.515;-94.45;-94.61;-94.609;-94.606;-94.593;-94.833;-95.084;-94.903;-95.3;-102;-102;-103;-103;-103;-106.622;-106.642;-106.578;-106.48;-106.4;-106.22;-105.99;-105.6;...
    -105.56;-105.38;-105.16;-104.98;-104.71;-104.7;-104.53;-104.23;-104.2;...
    -104.03;-103.79;-103.71;-103.54;-103.39;-103.14;-103.08;-102.89;-102.69;...
    -102.39;-102.33;-102.11;-101.44;-101.25;-101.06;-101.01;-100.80;...
    -100.66;-100.65;-100.27;-100.09;-99.85;-99.52;-99.52;-99.44;-99.28;...
    -99.11;-98.25;-97.83;-97.64;-97.43;-97.36;-97.14];
%Midwest
midwestpolygonlats=[40;40.585;41.059;41.179;41.195;41.308;41.463;41.546;41.959;42.395;...
    42.459;42.495;42.627;42.724;43.13;43.28;43.485;43.504;45.302;45.626;45.921;...
    46.894;47.02;47.664;48.054;48.6;49;49;49.38;49.31;48.78;48.61;48.52;...
    48.63;48.53;48.26;48.35;48.05;48.19;48.11;47.97;48.3;46.88;...
    46.47;46.55;46.07;46.13;45.99;45.82;45.34;43.59;43;
    42.71;42.15;41.73;42.33;40.641;...
    40.59;40.48;40.27;40.1;39.91;39.91;39.63;39.39;39.34;39.41;...
    39.26;39.27;39.09;38.94;38.88;39.03;38.8;38.6;38.58;38.45;38.42;...    
    38.48;38.55;38.57;38.75;38.73;38.62;38.6;38.66;38.7;38.64;...
    38.66;38.76;38.79;38.81;39.03;39.05;39.12;39.09;39.1;39.07;...
    39.14;39.06;38.91;38.87;38.79;38.69;38.74;38.73;38.53;38.27;...
    38.28;38;38.03;38.18;37.85;37.99;37.9;37.78;37.94;37.91;...
    37.82;37.9;37.67;37.48;37.38;37.27;37.13;37.06;37.23;37.05;...
    36.96;36.57;36.62;36.47;36.58;36.55;36.35;
    36;36;36.5;36.55;38.959;39.12;39.15;39.218;...
    39.565;39.796;40];
midwestpolygonlons=[-95.295;-95.754;-95.872;-95.865;-95.92;-95.908;-95.945;-96.078;-96.147;-96.411;...
    -96.38;-96.478;-96.52;-96.641;-96.441;-96.577;-96.593;-96.454;-96.454;-96.855;-96.57;...
    -96.746;-96.828;-96.872;-97.075;-97.13;-97.234;-95.186;-95.15;-94.81;-94.69;-93.82;-93.8;...
    -93.26;-92.65;-92.4;-92.24;-91.53;-90.9;-90.74;-89.34;-88.38;-84.87;...
    -84.52;-84.2;-83.98;-83.66;-83.46;-83.57;-82.5;-82.13;-82.43;
    -82.34;-83.05;-82.77;-80.52;-80.527;...
    -80.66;-80.6;-80.61;-80.72;-80.76;-80.8;-80.88;-81.21;-81.38;-81.45;...
    -81.58;-81.67;-81.79;-81.77;-81.9;-82.02;-82.21;-82.18;-82.28;-82.33;-82.59;...
    -82.62;-82.72;-82.84;-82.88;-83.02;-83.17;-83.31;-83.38;-83.58;-83.67;...
    -83.78;-83.87;-83.97;-84.22;-84.34;-84.43;-84.45;-84.52;-84.55;-84.61;...
    -84.75;-84.89;-84.87;-84.78;-84.82;-85.2;-85.28;-85.44;-85.42;-85.74;...
    -85.82;-85.95;-86.24;-86.34;-86.64;-86.81;-87.03;-87.11;-87.43;-87.59;...
    -87.65;-87.86;-88.15;-88.07;-88.49;-88.51;-88.42;-88.5;-88.99;-89.18;...
    -89.1;-89.23;-89.35;-89.48;-89.53;-89.57;-89.53;
    -89.71;-90.37;-90.16;-94.61;-94.61;-94.606;-94.593;-94.833;...
    -95.084;-94.903;-95.295];
%Southeast
southeastpolygonlats=[37.05;37.9;38.4;38.38;38.73;38.87;39.15;39.23;39.32;...
    39.13;39.46;39.34;39.12;38.96;38.92;38.76;38.85;38.42;38.46;38.56;...
    38.59;38.36;38.13;37.99;37.7;37.63;37.52;37.43;37.48;37.36;37.42;...
    37.34;37.24;37.33;37.2;37.28;37.48;37.51;37.57;37.74;37.95;38.16;
    38.42;...
    38.48;38.55;38.57;38.75;38.73;38.62;38.6;38.66;38.7;38.64;...
    38.66;38.76;38.79;38.81;39.03;39.05;39.12;39.09;39.1;39.07;...
    39.14;39.06;38.91;38.87;38.79;38.69;38.74;38.73;38.53;38.27;...
    38.28;38;38.03;38.18;37.85;37.99;37.9;37.78;37.94;37.91;...
    37.82;37.9;37.67;37.48;37.38;37.27;37.13;37.06;37.23;37.05;...
    36.96;36.57;36.62;36.47;36.58;36.55;36.35;
    36;36;36.5;36.55;35.45;...
    33.64;33.56;32;30.89;29.69];
southeastpolygonlons=[-76.08;-76.3;-77;-77.29;-77.03;-77.03;-77.53;-77.46;-77.71;...
    -77.83;-78.35;-78.35;-78.46;-78.63;-78.75;-78.87;-78.99;-79.29;-79.48;-79.54;...
    -79.65;-79.74;-79.94;-80;-80.3;-80.22;-80.3;-80.48;-80.51;-80.79;-80.85;...
    -80.86;-81.23;-81.36;-81.61;-81.84;-81.98;-81.94;-82.14;-82.33;-82.5;-82.64;
    -82.59;...
    -82.62;-82.72;-82.84;-82.88;-83.02;-83.17;-83.31;-83.38;-83.58;-83.67;...
    -83.78;-83.87;-83.97;-84.22;-84.34;-84.43;-84.45;-84.52;-84.55;-84.61;...
    -84.75;-84.89;-84.87;-84.78;-84.82;-85.2;-85.28;-85.44;-85.42;-85.74;...
    -85.82;-85.95;-86.24;-86.34;-86.64;-86.81;-87.03;-87.11;-87.43;-87.59;...
    -87.65;-87.86;-88.15;-88.07;-88.49;-88.51;-88.42;-88.5;-88.99;-89.18;...
    -89.1;-89.23;-89.35;-89.48;-89.53;-89.57;-89.53;
    -89.71;-90.37;-90.16;-94.61;-94.45;...
    -94.515;-94.04;-94;-93.56;-93.84];
%Northeast
northeastpolygonlats=[37.9;38.4;38.38;38.73;38.87;39.15;39.23;39.32;
    39.13;39.46;39.34;39.12;38.96;38.92;38.76;38.85;38.42;38.46;38.56;...
    38.59;38.36;38.13;37.99;37.7;37.63;37.52;37.43;37.48;37.36;37.42;...
    37.34;37.24;37.33;37.2;37.28;37.48;37.51;37.57;37.74;37.95;38.16;
    38.42;38.45;38.58;38.6;38.8;39.03;38.88;38.94;39.09;39.27;39.26;...
    39.41;39.34;39.39;39.63;39.91;39.91;40.1;40.27;40.48;40.59;
    40.64;42.33;42.82;43.6;43.6;44.15;45;45;45.29;45.25;45.34;...
    45.24;45.42;45.39;45.5;45.91;46.32;46.42;46.7;47.46;47.42;47.24;...
    47.19;47.29;47.36;47.34;47.06;45.69;45.58;45.25;45.12;45.19;45.15;44.82];
northeastpolygonlons=[-76.3;-77;-77.29;-77.03;-77.03;-77.53;-77.46;-77.71;
    -77.83;-78.35;-78.35;-78.46;-78.63;-78.75;-78.87;-78.99;-79.29;-79.48;-79.54;...
    -79.65;-79.74;-79.94;-80;-80.3;-80.22;-80.3;-80.48;-80.51;-80.79;-80.85;...
    -80.86;-81.23;-81.36;-81.61;-81.84;-81.98;-81.94;-82.14;-82.33;-82.5;-82.64;    
    -82.59;-82.33;-82.28;-82.18;-82.21;-82.02;-81.9;-81.77;-81.79;-81.67;-81.58;...
    -81.45;-81.38;-81.21;-80.88;-80.8;-80.76;-80.72;-80.61;-80.6;-80.66;
    -80.527;-80.52;-79.1;-79.3;-76.8;-76.5;-75.11;-71.51;-71.31;-71.16;-70.98;...
    -70.86;-70.79;-70.64;-70.72;-70.26;-70.22;-70.05;-70;-69.22;-69.03;-69.04;...
    -68.9;-68.39;-68.36;-68.21;-67.78;-67.78;-67.43;-67.47;-67.34;-67.26;-67.14;-66.94];



exist macaelevFINAL;
if ans==0
    metelev=ncread(strcat(dataloc,'metdata_elevation.nc'),'elevation');
    metlat=ncread(strcat(dataloc,'metdata_elevation.nc'),'lat');
    metlon=ncread(strcat(dataloc,'metdata_elevation.nc'),'lon');


    %Corresponding MACA indices, before any flipping or trimming:
    %Western US: 1:466, 2:475
    %Eastern US: 1:585, 476:1386
        %NOTE: Eastern US has already been retrieved using stride=[2 2 1], so its
        %true indices are actually 2:2:584, 477:2:1385
    macaelev=metelev';
    clear macalats;clear macalons;
    for i=1:size(metlat,1)
        for j=1:size(metlon,1)
            macalats(i,j)=metlat(i);macalons(i,j)=metlon(j);
        end
    end
    macalats_eus=macalats(2:2:584,477:2:1385);macalons_eus=macalons(2:2:584,477:2:1385);macaelev_eus=macaelev(2:2:584,477:2:1385);
    macalats_wus=macalats(1:466,2:475);macalons_wus=macalons(1:466,2:475);macaelev_wus=macaelev(1:466,2:475);

    macalats=macalats';macalons=macalons';macaelev=macaelev';
    macalats_eus=macalats_eus';macalons_eus=macalons_eus';macaelev_eus=macaelev_eus';macalats_wus=macalats_wus';macalons_wus=macalons_wus';macaelev_wus=macaelev_wus';
    macalats=fliplr(macalats);macalons=fliplr(macalons);macaelev=fliplr(macaelev);
    macalats_eus=fliplr(macalats_eus);macalons_eus=fliplr(macalons_eus);macaelev_eus=fliplr(macaelev_eus);
    macalats_wus=fliplr(macalats_wus);macalons_wus=fliplr(macalons_wus);macaelev_wus=fliplr(macaelev_wus);
    ocean=macaelev==0;macaelev(ocean)=NaN;

    %Combine western & eastern US, ensuring that they line up appropriately
    newmacalats_wus=macalats_wus(:,1:end-1);newmacalons_wus=macalons_wus(:,1:end-1);newmacaelev_wus=macaelev_wus(:,1:end-1);
    newnewmacalats_wus=cat(2,NaN.*ones(474,119),newmacalats_wus);newnewmacalons_wus=cat(2,NaN.*ones(474,119),newmacalons_wus);newnewmacaelev_wus=cat(2,NaN.*ones(474,119),newmacaelev_wus);
    newnewmacalats_wus=newnewmacalats_wus(2:2:end,2:2:end);newnewmacalons_wus=newnewmacalons_wus(2:2:end,2:2:end);newnewmacaelev_wus=newnewmacaelev_wus(2:2:end,2:2:end);
    macalatsFINAL=cat(1,newnewmacalats_wus,macalats_eus);macalonsFINAL=cat(1,newnewmacalons_wus,macalons_eus);macaelevFINAL=cat(1,newnewmacaelev_wus,macaelev_eus);

    macaregions=ncaregionsfromlatlon(macalatsFINAL,macalonsFINAL);
    invalid=macaelevFINAL==0;macaelevFINAL(invalid)=NaN;
    macaregions(1,:)=0;
    
    %Certain areas near water are represented as water in the GCM, resulting in bad results after downscaling (esp for radiation), so the only solution is to remove them entirely
    %Therefore, set elevations for these points (identified from prior calculations) to NaN
    %This affects regions 4-7
    macaelevFINAL(1:21,150:167)=NaN;macaelevFINAL(1:8,180:190)=NaN;macaelevFINAL(1:15,276:281)=NaN;
    macaelevFINAL(345:355,1:47)=NaN;macaelevFINAL(369:394,1:59)=NaN;
    macaelevFINAL(406:450,264:292)=NaN;macaelevFINAL(442:465,210:239)=NaN;
    macaelevFINAL(454:465,244:262)=NaN;macaelevFINAL(455:501,1:59)=NaN;macaelevFINAL(455:501,240:251)=NaN;
    macaelevFINAL(502:573,215:250)=NaN;macaelevFINAL(502:514,192:202)=NaN;macaelevFINAL(502:526,1:11)=NaN;
    macaelevFINAL(526:540,35:55)=NaN;macaelevFINAL(526:537,203:210)=NaN;
    macaelevFINAL(538:550,92:95)=NaN;macaelevFINAL(550:565,100:107)=NaN;
    macaelevFINAL(574:590,110:119)=NaN;
    macaelevFINAL(585:600,145:157)=NaN;macaelevFINAL(610:650,187:195)=NaN;macaelevFINAL(646:670,193:221)=NaN;
end

exist gridmetlats;
if ans==0
    gridmetlat=ncread(strcat('/Volumes/ExternalDriveC/gridMET_daily/sph_1980.nc'),'lat');
    gridmetlon=ncread(strcat('/Volumes/ExternalDriveC/gridMET_daily/sph_1980.nc'),'lon');
    clear gridmetlats;clear gridmetlons;
    for i=1:size(gridmetlon,1)
        for j=1:size(gridmetlat,1)
            gridmetlats(i,j)=gridmetlat(j);
            gridmetlons(i,j)=gridmetlon(i);
        end
    end
end
gridmetelev=ncread('/Volumes/ExternalDriveC/Basics_gridMET/metdata_elevationdata.nc','elevation');


exps=[1;3];models=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20];

nd=4784; %number of days in MJJAS across all 26 years [1980-2005 and 2074-2099]

elevcutoffs=[-100:50:4000];
%Get number of points in each elev bin in each region
for eb=1:size(elevcutoffs,2)-1
    %By NCA region
    for regloop=1:7                    
        temp=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1) & macaregions==regloop+1;
        numpointsbybinandreg(eb,regloop)=sum(sum(temp));
    end
end

%Obtain number of points in each elevation bin and each region
%Note that elevation categories of smoothed arrays are -50 to 50 m; 50 to 150 m; etc.
clear countbyelevineachreg;
for reg=1:7
    for elevbin=1:size(elevcutoffs,2)-1
        countbyelevineachreg(elevbin,reg+1)=sum(sum(macaelevFINAL>=elevcutoffs(elevbin) & macaelevFINAL<elevcutoffs(elevbin+1) & macaregions==reg+1));
    end
end
sz=size(elevcutoffs,2);
x=1:sz;
for reg=1:numregs
    invalid=countbyelevineachreg(:,reg+1)<pointcutoff;newxstops(reg)=max(x)-sum(invalid)+1;
end



if reload==1
        temp=load(strcat(dataloc,'variousneededarrays.mat'));
        elevs_on692x292grid=temp.elevs_on692x292grid;
        pointsbystate=temp.pointsbystate;
        disttooceanall=temp.disttooceanall;
        disttogreatlakeall=temp.disttogreatlakeall;
        
        temp=load(strcat(dataloc,'twresults.mat'));
        p99tw_hist=temp.p99tw_hist;
        p99esi_hist=temp.p99esi_hist;
        p99t_hist=temp.p99t_hist;
        p99q_hist=temp.p99q_hist;
        p99r_hist=temp.p99r_hist;
        p99tw_rcp85=temp.p99tw_rcp85;
        p99esi_rcp85=temp.p99esi_rcp85;
        p99t_rcp85=temp.p99t_rcp85;
        p99q_rcp85=temp.p99q_rcp85;
        p99r_rcp85=temp.p99r_rcp85;

        p99tw_hist_nw=temp.p99tw_hist_nw;
        p99esi_hist_nw=temp.p99esi_hist_nw;
        p99t_hist_nw=temp.p99t_hist_nw;
        p99q_hist_nw=temp.p99q_hist_nw;
        p99r_hist_nw=temp.p99r_hist_nw;
        p99tw_rcp85_nw=temp.p99tw_rcp85_nw;
        p99esi_rcp85_nw=temp.p99esi_rcp85_nw;
        p99t_rcp85_nw=temp.p99t_rcp85_nw;
        p99q_rcp85_nw=temp.p99q_rcp85_nw;
        p99r_rcp85_nw=temp.p99r_rcp85_nw;

        p99tw_hist_sw=temp.p99tw_hist_sw;
        p99esi_hist_sw=temp.p99esi_hist_sw;
        p99t_hist_sw=temp.p99t_hist_sw;
        p99q_hist_sw=temp.p99q_hist_sw;
        p99r_hist_sw=temp.p99r_hist_sw;
        p99tw_rcp85_sw=temp.p99tw_rcp85_sw;
        p99esi_rcp85_sw=temp.p99esi_rcp85_sw;
        p99t_rcp85_sw=temp.p99t_rcp85_sw;
        p99q_rcp85_sw=temp.p99q_rcp85_sw;
        p99r_rcp85_sw=temp.p99r_rcp85_sw;

        p99tw_hist_ngp=temp.p99tw_hist_ngp;
        p99esi_hist_ngp=temp.p99esi_hist_ngp;
        p99t_hist_ngp=temp.p99t_hist_ngp;
        p99q_hist_ngp=temp.p99q_hist_ngp;
        p99r_hist_ngp=temp.p99r_hist_ngp;
        p99tw_rcp85_ngp=temp.p99tw_rcp85_ngp;
        p99esi_rcp85_ngp=temp.p99esi_rcp85_ngp;
        p99t_rcp85_ngp=temp.p99t_rcp85_ngp;
        p99q_rcp85_ngp=temp.p99q_rcp85_ngp;
        p99r_rcp85_ngp=temp.p99r_rcp85_ngp;
        
        p99tw_hist_sgp=temp.p99tw_hist_sgp;
        p99esi_hist_sgp=temp.p99esi_hist_sgp;
        p99t_hist_sgp=temp.p99t_hist_sgp;
        p99q_hist_sgp=temp.p99q_hist_sgp;
        p99r_hist_sgp=temp.p99r_hist_sgp;
        p99tw_rcp85_sgp=temp.p99tw_rcp85_sgp;
        p99esi_rcp85_sgp=temp.p99esi_rcp85_sgp;
        p99t_rcp85_sgp=temp.p99t_rcp85_sgp;
        p99q_rcp85_sgp=temp.p99q_rcp85_sgp;
        p99r_rcp85_sgp=temp.p99r_rcp85_sgp;
        
        p99tw_hist_mw=temp.p99tw_hist_mw;
        p99esi_hist_mw=temp.p99esi_hist_mw;
        p99t_hist_mw=temp.p99t_hist_mw;
        p99q_hist_mw=temp.p99q_hist_mw;
        p99r_hist_mw=temp.p99r_hist_mw;
        p99tw_rcp85_mw=temp.p99tw_rcp85_mw;
        p99esi_rcp85_mw=temp.p99esi_rcp85_mw;
        p99t_rcp85_mw=temp.p99t_rcp85_mw;
        p99q_rcp85_mw=temp.p99q_rcp85_mw;
        p99r_rcp85_mw=temp.p99r_rcp85_mw;
        
        p99tw_hist_se=temp.p99tw_hist_se;
        p99esi_hist_se=temp.p99esi_hist_se;
        p99t_hist_se=temp.p99t_hist_se;
        p99q_hist_se=temp.p99q_hist_se;
        p99r_hist_se=temp.p99r_hist_se;
        p99tw_rcp85_se=temp.p99tw_rcp85_se;
        p99esi_rcp85_se=temp.p99esi_rcp85_se;
        p99t_rcp85_se=temp.p99t_rcp85_se;
        p99q_rcp85_se=temp.p99q_rcp85_se;
        p99r_rcp85_se=temp.p99r_rcp85_se;
        
        p99tw_hist_ne=temp.p99tw_hist_ne;
        p99esi_hist_ne=temp.p99esi_hist_ne;
        p99t_hist_ne=temp.p99t_hist_ne;
        p99q_hist_ne=temp.p99q_hist_ne;
        p99r_hist_ne=temp.p99r_hist_ne;
        p99tw_rcp85_ne=temp.p99tw_rcp85_ne;
        p99esi_rcp85_ne=temp.p99esi_rcp85_ne;
        p99t_rcp85_ne=temp.p99t_rcp85_ne;
        p99q_rcp85_ne=temp.p99q_rcp85_ne;
        p99r_rcp85_ne=temp.p99r_rcp85_ne;
        
        p99esi_rcp85_histt=temp.p99esi_rcp85_histt;
        p99esi_rcp85_histq=temp.p99esi_rcp85_histq;
        p99esi_rcp85_histr=temp.p99esi_rcp85_histr;
        
        p99esi_rcp85_histt_nw=temp.p99esi_rcp85_histt_nw;p99esi_rcp85_histq_nw=temp.p99esi_rcp85_histq_nw;p99esi_rcp85_histr_nw=temp.p99esi_rcp85_histr_nw;
        p99esi_rcp85_histt_sw=temp.p99esi_rcp85_histt_sw;p99esi_rcp85_histq_sw=temp.p99esi_rcp85_histq_sw;p99esi_rcp85_histr_sw=temp.p99esi_rcp85_histr_sw;
        p99esi_rcp85_histt_ngp=temp.p99esi_rcp85_histt_ngp;p99esi_rcp85_histq_ngp=temp.p99esi_rcp85_histq_ngp;p99esi_rcp85_histr_ngp=temp.p99esi_rcp85_histr_ngp;
        p99esi_rcp85_histt_sgp=temp.p99esi_rcp85_histt_sgp;p99esi_rcp85_histq_sgp=temp.p99esi_rcp85_histq_sgp;p99esi_rcp85_histr_sgp=temp.p99esi_rcp85_histr_sgp;
        p99esi_rcp85_histt_mw=temp.p99esi_rcp85_histt_mw;p99esi_rcp85_histq_mw=temp.p99esi_rcp85_histq_mw;p99esi_rcp85_histr_mw=temp.p99esi_rcp85_histr_mw;
        p99esi_rcp85_histt_se=temp.p99esi_rcp85_histt_se;p99esi_rcp85_histq_se=temp.p99esi_rcp85_histq_se;p99esi_rcp85_histr_se=temp.p99esi_rcp85_histr_se;
        p99esi_rcp85_histt_ne=temp.p99esi_rcp85_histt_ne;p99esi_rcp85_histq_ne=temp.p99esi_rcp85_histq_ne;p99esi_rcp85_histr_ne=temp.p99esi_rcp85_histr_ne;
        
        %Need to carefully consider which one of these to invoke!
        %Generally the QCed one is the best choice, except when troubleshooting
        reloadbypoint=0;
        if reloadbypoint==1
            temp=load(strcat(dataloc,'twbypointresults.mat'));
            p99esibypoint_hist=temp.p99esibypoint_hist;
            p99tbypoint_hist=temp.p99tbypoint_hist;
            p99qbypoint_hist=temp.p99qbypoint_hist;
            p99rbypoint_hist=temp.p99rbypoint_hist;

            p99esibypoint_rcp85=temp.p99esibypoint_rcp85;
            p99tbypoint_rcp85=temp.p99tbypoint_rcp85;
            p99qbypoint_rcp85=temp.p99qbypoint_rcp85;
            p99rbypoint_rcp85=temp.p99rbypoint_rcp85;
            
            temp=load(strcat(dataloc,'twbypointresults_qced.mat'));
        end
        
        
        f=load(strcat(dataloc,'familychanges.mat'));
        p99esibypoint_family_hist=f.p99esibypoint_family_hist;
        p99esibypoint_family_rcp85=f.p99esibypoint_family_rcp85;
        p99esibypoint_family_change=f.p99esibypoint_family_change;
        p99tbypoint_family_hist=f.p99tbypoint_family_hist;
        p99tbypoint_family_rcp85=f.p99tbypoint_family_rcp85;
        p99tbypoint_family_change=f.p99tbypoint_family_change;
        p99qbypoint_family_hist=f.p99qbypoint_family_hist;
        p99qbypoint_family_rcp85=f.p99qbypoint_family_rcp85;
        p99qbypoint_family_change=f.p99qbypoint_family_change;
        p99rbypoint_family_hist=f.p99rbypoint_family_hist;
        p99rbypoint_family_rcp85=f.p99rbypoint_family_rcp85;
        p99rbypoint_family_change=f.p99rbypoint_family_change;
        
        f=load(strcat(dataloc,'exceedratio.mat'));
        exceedratio_future_median_esi=f.exceedratio_future_median_esi;
        exceedratio_future_median_t=f.exceedratio_future_median_t;
        exceedratio_future_median_q=f.exceedratio_future_median_q;
        exceedratio_future_median_r=f.exceedratio_future_median_r;
        exceedratio_future_mean_esi=f.exceedratio_future_mean_esi;
        exceedratio_future_mean_t=f.exceedratio_future_mean_t;
        exceedratio_future_mean_q=f.exceedratio_future_mean_q;
        exceedratio_future_mean_r=f.exceedratio_future_mean_r;
        
        f=load(strcat(dataloc,'p99esimmmedianresults.mat'));
        p99esi_hist_mmmedian_nw=f.p99esi_hist_mmmedian_nw;p99esi_hist_mmmedian_sw=f.p99esi_hist_mmmedian_sw;p99esi_hist_mmmedian_ngp=f.p99esi_hist_mmmedian_ngp;
        p99esi_hist_mmmedian_sgp=f.p99esi_hist_mmmedian_sgp;p99esi_hist_mmmedian_mw=f.p99esi_hist_mmmedian_mw;p99esi_hist_mmmedian_se=f.p99esi_hist_mmmedian_se;
        p99esi_hist_mmmedian_ne=f.p99esi_hist_mmmedian_ne;
        
        p99esi_rcp85_mmmedian_nw=f.p99esi_rcp85_mmmedian_nw;p99esi_rcp85_mmmedian_sw=f.p99esi_rcp85_mmmedian_sw;p99esi_rcp85_mmmedian_ngp=f.p99esi_rcp85_mmmedian_ngp;
        p99esi_rcp85_mmmedian_sgp=f.p99esi_rcp85_mmmedian_sgp;p99esi_rcp85_mmmedian_mw=f.p99esi_rcp85_mmmedian_mw;p99esi_rcp85_mmmedian_se=f.p99esi_rcp85_mmmedian_se;
        p99esi_rcp85_mmmedian_ne=f.p99esi_rcp85_mmmedian_ne;

        p99t_hist_mmmedian_nw=f.p99t_hist_mmmedian_nw;p99t_hist_mmmedian_sw=f.p99t_hist_mmmedian_sw;p99t_hist_mmmedian_ngp=f.p99t_hist_mmmedian_ngp;
        p99t_hist_mmmedian_sgp=f.p99t_hist_mmmedian_sgp;p99t_hist_mmmedian_mw=f.p99t_hist_mmmedian_mw;p99t_hist_mmmedian_se=f.p99t_hist_mmmedian_se;
        p99t_hist_mmmedian_ne=f.p99t_hist_mmmedian_ne;
        
        p99t_rcp85_mmmedian_nw=f.p99t_rcp85_mmmedian_nw;p99t_rcp85_mmmedian_sw=f.p99t_rcp85_mmmedian_sw;p99t_rcp85_mmmedian_ngp=f.p99t_rcp85_mmmedian_ngp;
        p99t_rcp85_mmmedian_sgp=f.p99t_rcp85_mmmedian_sgp;p99t_rcp85_mmmedian_mw=f.p99t_rcp85_mmmedian_mw;p99t_rcp85_mmmedian_se=f.p99t_rcp85_mmmedian_se;
        p99t_rcp85_mmmedian_ne=f.p99t_rcp85_mmmedian_ne;
        
        p99q_hist_mmmedian_nw=f.p99q_hist_mmmedian_nw;p99q_hist_mmmedian_sw=f.p99q_hist_mmmedian_sw;p99q_hist_mmmedian_ngp=f.p99q_hist_mmmedian_ngp;
        p99q_hist_mmmedian_sgp=f.p99q_hist_mmmedian_sgp;p99q_hist_mmmedian_mw=f.p99q_hist_mmmedian_mw;p99q_hist_mmmedian_se=f.p99q_hist_mmmedian_se;
        p99q_hist_mmmedian_ne=f.p99q_hist_mmmedian_ne;
        
        p99q_rcp85_mmmedian_nw=f.p99q_rcp85_mmmedian_nw;p99q_rcp85_mmmedian_sw=f.p99q_rcp85_mmmedian_sw;p99q_rcp85_mmmedian_ngp=f.p99q_rcp85_mmmedian_ngp;
        p99q_rcp85_mmmedian_sgp=f.p99q_rcp85_mmmedian_sgp;p99q_rcp85_mmmedian_mw=f.p99q_rcp85_mmmedian_mw;p99q_rcp85_mmmedian_se=f.p99q_rcp85_mmmedian_se;
        p99q_rcp85_mmmedian_ne=f.p99q_rcp85_mmmedian_ne;
        
        p99r_hist_mmmedian_nw=f.p99r_hist_mmmedian_nw;p99r_hist_mmmedian_sw=f.p99r_hist_mmmedian_sw;p99r_hist_mmmedian_ngp=f.p99r_hist_mmmedian_ngp;
        p99r_hist_mmmedian_sgp=f.p99r_hist_mmmedian_sgp;p99r_hist_mmmedian_mw=f.p99r_hist_mmmedian_mw;p99r_hist_mmmedian_se=f.p99r_hist_mmmedian_se;
        p99r_hist_mmmedian_ne=f.p99r_hist_mmmedian_ne;
        
        p99r_rcp85_mmmedian_nw=f.p99r_rcp85_mmmedian_nw;p99r_rcp85_mmmedian_sw=f.p99r_rcp85_mmmedian_sw;p99r_rcp85_mmmedian_ngp=f.p99r_rcp85_mmmedian_ngp;
        p99r_rcp85_mmmedian_sgp=f.p99r_rcp85_mmmedian_sgp;p99r_rcp85_mmmedian_mw=f.p99r_rcp85_mmmedian_mw;p99r_rcp85_mmmedian_se=f.p99r_rcp85_mmmedian_se;
        p99r_rcp85_mmmedian_ne=f.p99r_rcp85_mmmedian_ne;
end



%=============================================
%     PARAMETERS 
%=============================================

RUN_NUM = ones(20,1);f=find(strcmp(MODEL_NAME,'CCSM4'));RUN_NUM(f) = 6;


years_hist=[1950:2005];index_years_hist=years_hist-1950+1;
years_fut=[2006:2099];

numbins_all=40;numbins_nw=33;numbins_sw=40;numbins_ngp=38;numbins_sgp=20;numbins_mw=7;numbins_se=14;numbins_ne=17;




mjjasodays_hist=[];daysaver_hist=[];yearstart=10958;i=1;
for year=1980:2005
    if rem(year,4)==0
        ylen=366;mjjasodays_hist=[mjjasodays_hist;(yearstart+121:yearstart+304)'];
        daysaver_hist(i:i+183,1)=year;daysaver_hist(i:i+183,2)=122:305;
    else
        ylen=365;mjjasodays_hist=[mjjasodays_hist;(yearstart+120:yearstart+303)'];
        daysaver_hist(i:i+183,1)=year;daysaver_hist(i:i+183,2)=121:304;
    end
    yearstart=yearstart+ylen;i=i+184;
end
mjjasodays_hist=mjjasodays_hist-10957;

mjjasodays_rcp85=[];daysaver_rcp85=[];yearstart=24839;i=1;
for year=2074:2099
    if rem(year,4)==0
        ylen=366;mjjasodays_rcp85=[mjjasodays_rcp85;(yearstart+121:yearstart+304)'];
        daysaver_rcp85(i:i+183,1)=year;daysaver_rcp85(i:i+183,2)=122:305;
    else
        ylen=365;mjjasodays_rcp85=[mjjasodays_rcp85;(yearstart+120:yearstart+303)'];
        daysaver_rcp85(i:i+183,1)=year;daysaver_rcp85(i:i+183,2)=121:304;
    end
    yearstart=yearstart+ylen;
end
mjjasodays_rcp85=mjjasodays_rcp85-24838;






if readdata==1
        
    %variables,models
    var_target=[1 2 3 4 5]; %specifies index of VAR_NAME below to extract
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
    
    %Region 1 is East, region 2 is West
    
    for model=readmodelstart:readmodelstop
        for var=1:length(var_target)
            modelname=MODEL_NAME{model};
            
            baddataisbelow=10^-10;
            
            continueon=0;
            
           if model==4
                if var==5
                    continueon=1;dohistorical=0;dofuture=1;regstart_hist=1;regstop_hist=2;regstart_fut=1;regstop_fut=1;
                end
            end
                
                
            if continueon==1    
                if dohistorical==1
                    time_string='1950_2005';
                    myURL=[pathDir,'agg_macav2metdata_',VAR_NAME{var},'_',...
                        modelname,'_r',num2str(RUN_NUM(model)),'i1p1_historical_',char(time_string),'_CONUS_daily.nc'];
                    
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

                    %want to start at day 10957 - jan 1, 1980 (with day 1 as 1/1/1950)
                    %and end on dec 31, 2005, at day 20454
                    for reghere=regstart_hist:regstop_hist
                        if reghere==1 %Eastern US
                            numrowsthisreg=455;numcolsthisreg=292;
                            saveddata=NaN.*ones(numrowsthisreg,numcolsthisreg,382*25);
                            lat_target=[24 49.75];lon_target=[-105 -66]+360;
                        elseif reghere==2 %Western US
                            numrowsthisreg=237;numcolsthisreg=233;
                            saveddata=NaN.*ones(numrowsthisreg,numcolsthisreg,382*25);
                            lat_target=[30 49.75];lon_target=[-124.75 -105]+360;
                        end
                        
                        overallc=1;

                        %Get geographical indices of subset by looking at a sample file
                        exist latofsample;
                        if ans==0
                            latofsample=ncread(myURL,'lat');lonofsample=ncread(myURL,'lon');
                        end

                        lat_index=find(latofsample<=max(lat_target) & latofsample>=min(lat_target));lat_index=[min(lat_index):max(lat_index)];
                        lon_index=find(lonofsample<=max(lon_target) & lonofsample>=min(lon_target));lon_index=[min(lon_index):max(lon_index)];


                        for loop=438:819
                            if loop==819;leng=4;else;leng=25;end

                            start=[min(lon_index) min(lat_index) loop*25-24];
                            count=[round2(length(lon_index)/2,1,'floor') round2(length(lat_index)/2,1,'floor') leng];
                            stride=[2 2 1];

                            i=1;e=0;I=100;
                            while i<I && e<=50
                               try
                                  if loop>=439
                                      prevvalstocheckagainst1=squeeze(saveddata(150,150,overallc-leng:overallc-1));
                                      prevvalstocheckagainst2=squeeze(saveddata(155,155,overallc-leng:overallc-1));
                                  end
                                  
                                  oktofinishthisloop=0;
                                  
                                  while oktofinishthisloop==0 %keep repeating the same ncread action until valid values are obtained
                                      saveddata(1:numrowsthisreg,1:numcolsthisreg,overallc:overallc+leng-1)=ncread(myURL,VAR_LONGNAME{var},start,count,stride);

                                      if loop>=439
                                          newvalsat150150=squeeze(saveddata(150,150,overallc:overallc+leng-1));
                                          newvalsat155155=squeeze(saveddata(155,155,overallc:overallc+leng-1));
                                          invalid=newvalsat150150<=baddataisbelow;prevvalstocheckagainst1(invalid)=NaN;
                                          invalid=newvalsat155155<=baddataisbelow;prevvalstocheckagainst2(invalid)=NaN;

                                          res1=newvalsat150150==prevvalstocheckagainst1;
                                          res2=newvalsat155155==prevvalstocheckagainst2;
                                          if (sum(res1)~=size(res1,1) || sum(res2)~=size(res2,1))
                                              i = 100;
                                              %fprintf('Value at 150,150,1 (overallc %d) of this subset is %d; loop is %d;start(3) is %d; count(3) is %d\n',...
                                              %    overallc,saveddata(150,150,overallc),loop,start(3),count(3));
                                              overallc=overallc+leng;
                                              oktofinishthisloop=1;
                                          end
                                      else
                                          i = 100;
                                          fprintf('Value at 150,150,1 (overallc %d) of this subset is %d; loop is %d;start(3) is %d; count(3) is %d\n',...
                                               overallc,saveddata(150,150,overallc),loop,start(3),count(3));
                                          overallc=overallc+leng;
                                          oktofinishthisloop=1;
                                      end
                                  end
                               catch
                                  pause(.5) % pause to see if internet improves
                                  e = e+1;  % add an error
                                  fprintf('Caught something at loop %d with overallc %d \n',loop,overallc);disp(clock);
                               end
                            end

                            
                            if rem(loop,25)==0;disp(loop);end
                        end

                        if reghere==1
                            for i=1:382*25;if ~isnan(saveddata(400,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                            if var==1;for i=1:size(saveddata,1);for j=1:size(saveddata,2);for k=2:size(saveddata,3);if abs(saveddata(i,j,k)-saveddata(i,j,k-1))>=25;saveddata(i,j,k-1:k)=NaN;end;end;end;end;end
                            save(strcat(dataloc,'historical',VAR_NAME{var},MODEL_NAME{model},'easternus.mat'),'saveddata','-v7.3');
                        elseif reghere==2
                            for i=1:382*25;if ~isnan(saveddata(50,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                            if var==1;for i=1:size(saveddata,1);for j=1:size(saveddata,2);for k=2:size(saveddata,3);if abs(saveddata(i,j,k)-saveddata(i,j,k-1))>=25;saveddata(i,j,k-1:k)=NaN;end;end;end;end;end
                            save(strcat(dataloc,'historical',VAR_NAME{var},MODEL_NAME{model},'.mat'),'saveddata','-v7.3');
                        end
                        fprintf(strcat(['Just completed historical data-gathering for region',num2str(reghere),', ',VAR_NAME{var},' and ',MODEL_NAME{model},'\n']));
                    end
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
                        for reghere=regstart_fut:regstop_fut
                            
                            if reghere==1 %Eastern US
                                saveddata=NaN.*ones(455,292,382*25);
                                lat_target=[24 49.75];lon_target=[-105 -66]+360;
                            elseif reghere==2 %Western US
                                saveddata=NaN.*ones(237,233,382*25);
                                lat_target=[30 49.75];lon_target=[-124.75 -105]+360;
                            end
                            
                            overallc=1;


                            %Get geographical indices of subset by looking at a sample file
                            exist latofsample;
                            if ans==0
                                pathname=strcat(dataloc,'historicaluasCanESM2_1980-1989.nc');
                                latofsample=ncread(pathname,'lat');lonofsample=ncread(pathname,'lon');
                            end

                            lat_index=find(latofsample<=max(lat_target) & latofsample>=min(lat_target));lat_index=[min(lat_index):max(lat_index)];
                            lon_index=find(lonofsample<=max(lon_target) & lonofsample>=min(lon_target));lon_index=[min(lon_index):max(lon_index)];


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
                                       if loop>=995
                                          prevvalstocheckagainst1=squeeze(saveddata(150,150,overallc-leng:overallc-1));
                                          prevvalstocheckagainst2=squeeze(saveddata(155,155,overallc-leng:overallc-1));
                                       end
                                       
                                       oktofinishthisloop=0;
                                  
                                       while oktofinishthisloop==0 %keep repeating the same ncread action until valid values are obtained
                                          saveddata(:,:,overallc:overallc+leng-1)=ncread(myURL,VAR_LONGNAME{var},start,count,stride);
                                          
                                          
                                          if loop>=995
                                              newvalsat150150=squeeze(saveddata(150,150,overallc:overallc+leng-1));
                                              newvalsat155155=squeeze(saveddata(155,155,overallc:overallc+leng-1));
                                              invalid=newvalsat150150<baddataisbelow;prevvalstocheckagainst1(invalid)=newvalsat150150(invalid);
                                              invalid=newvalsat155155<baddataisbelow;prevvalstocheckagainst2(invalid)=newvalsat155155(invalid);
                                              
                                              res1=newvalsat150150==prevvalstocheckagainst1;
                                              res2=newvalsat155155==prevvalstocheckagainst2;
                                            if (sum(res1)~=size(res1,1) || sum(res2)~=size(res2,1))
                                                i = 100;
                                                %fprintf('Value at 150,150,1 (overallc %d) of this subset is %d; loop is %d;start(3) is %d; count(3) is %d\n',...
                                                %    overallc,saveddata(150,150,overallc),loop,start(3),count(3));
                                                overallc=overallc+leng;
                                                oktofinishthisloop=1;
                                            end
                                          else
                                              i = 100;
                                              fprintf('Value at 150,150,1 (overallc %d) of this subset is %d; loop is %d;start(3) is %d; count(3) is %d\n',...
                                                   overallc,saveddata(150,150,overallc),loop,start(3),count(3));
                                              overallc=overallc+leng;
                                              oktofinishthisloop=1;
                                          end
                                       end
                                   catch
                                      pause(.5) % pause to see if internet improves
                                      e = e+1; % add an error
                                      if rem(e,5)==0;fprintf('Caught something (error # %d) at loop %d with overallc %d \n',e,loop,overallc);disp(clock);end
                                   end
                                end

                                if rem(loop,50)==0;disp(loop);disp(clock);end
                            end
                            if reghere==1
                                for i=1:382*25;if ~isnan(saveddata(400,50,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                                if var==1;for i=1:size(saveddata,1);for j=1:size(saveddata,2);for k=2:size(saveddata,3);if abs(saveddata(i,j,k)-saveddata(i,j,k-1))>=25;saveddata(i,j,k-1:k)=NaN;end;end;end;end;end
                                save(strcat(dataloc,EXP_NAME{experiment+1},VAR_NAME{var},MODEL_NAME{model},'easternus.mat'),'saveddata','-v7.3');
                            elseif reghere==2
                                for i=1:382*25;if ~isnan(saveddata(1,1,i));saveddata(:,:,i)=NaN;end;end %if ocean has data, something is wrong with this day
                                if var==1;for i=1:size(saveddata,1);for j=1:size(saveddata,2);for k=2:size(saveddata,3);if abs(saveddata(i,j,k)-saveddata(i,j,k-1))>=25;saveddata(i,j,k-1:k)=NaN;end;end;end;end;end
                                save(strcat(dataloc,EXP_NAME{experiment+1},VAR_NAME{var},MODEL_NAME{model},'.mat'),'saveddata','-v7.3');
                            end
                            fprintf(strcat(['Just completed future data-gathering for region',num2str(reghere),...
                                ', ',EXP_NAME{experiment+1},', ',VAR_NAME{var},' and ',MODEL_NAME{model},'\n']));
                        end
                    end
                end
            end
        end
    end
    clear saveddata;
end



%Sorts out arrays that were pulled from different servers (due to various server
%errors in the downloading process) and combines them into meaningful data
if createfinalbigarrays==1
    reread_arrays=zeros(20,5,2,2); %model numbers, variables, experiments, regions (1:west, 2:east)
    downloadedfromserver2=zeros(20,5,2,2);
    downloadedfromserver1ROUND2=zeros(20,5,2,2);
    
    %1. Original files downloaded from NW Knowledge server
    reread_arrays(2,1,1,2)=1;reread_arrays(2,2,1,2)=1;reread_arrays(2,1,2,2)=1;
    reread_arrays(2,2,2,2)=1;
    reread_arrays(2,5,1,2)=1;reread_arrays(2,5,2,2)=1;
    reread_arrays(5,5,2,1)=1;
    reread_arrays(7,2,1,1)=1;
    reread_arrays(8,1,1,2)=1;
    reread_arrays(8,2,1,2)=1;
    reread_arrays(8,5,1,2)=1;
    reread_arrays(9,1,2,1)=1;reread_arrays(9,1,2,2)=1;
    reread_arrays(9,2,1,2)=1;
    reread_arrays(9,5,2,1)=1;reread_arrays(9,5,2,2)=1;reread_arrays(9,5,1,2)=1;
    reread_arrays(10,1,1,1)=1;reread_arrays(10,1,1,2)=1;
    reread_arrays(12,1,1,2)=1;reread_arrays(12,1,2,2)=1;reread_arrays(12,1,1,1)=1;
    reread_arrays(12,2,2,1)=1;reread_arrays(12,2,1,1)=1;reread_arrays(12,2,2,2)=1;
    reread_arrays(12,5,1,2)=1;reread_arrays(12,5,2,1)=1;reread_arrays(12,5,2,2)=1;
    reread_arrays(14,2,2,1)=1;
    reread_arrays(14,5,1,1)=1;reread_arrays(14,5,1,2)=1;
    reread_arrays(15,1,2,1)=1;reread_arrays(15,1,2,2)=1;reread_arrays(15,1,1,2)=1;
    reread_arrays(15,5,1,1)=1;reread_arrays(15,5,1,2)=1;reread_arrays(15,5,2,1)=1;
    reread_arrays(16,2,1,2)=1;
    reread_arrays(18,1,1,1)=1;reread_arrays(18,1,2,1)=1;reread_arrays(18,1,2,2)=1;
    
    downloadedfromserver1ROUND2(9,2,1,2)=1;
    downloadedfromserver1ROUND2(9,5,2,1)=1;downloadedfromserver1ROUND2(9,5,2,2)=1;
    downloadedfromserver1ROUND2(12,1,1,2)=1;
    downloadedfromserver1ROUND2(12,2,2,1)=1;
    downloadedfromserver1ROUND2(14,2,2,1)=1;
    downloadedfromserver1ROUND2(14,5,1,1)=1;
    downloadedfromserver1ROUND2(15,1,2,1)=1;downloadedfromserver1ROUND2(15,1,2,2)=1;
    downloadedfromserver1ROUND2(15,5,1,1)=1;downloadedfromserver1ROUND2(15,5,2,1)=1;
    downloadedfromserver1ROUND2(18,1,1,1)=1;downloadedfromserver1ROUND2(18,1,2,1)=1;downloadedfromserver1ROUND2(18,1,2,2)=1;
    
    %2. Any file that has the variable name as "air_temperature" or similar...
    %(whether from USGS or NW Knowledge)
    reread_arrays(4,5,1,1)=1;reread_arrays(4,5,1,2)=1;reread_arrays(4,5,2,1)=1;reread_arrays(4,5,2,2)=1;
    reread_arrays(5,1,1,1)=1;reread_arrays(5,1,1,2)=1;reread_arrays(5,1,2,1)=1;reread_arrays(5,1,2,2)=1;
    reread_arrays(5,2,1,1)=1;reread_arrays(5,2,1,2)=1;reread_arrays(5,2,2,1)=1;reread_arrays(5,2,2,2)=1;
    reread_arrays(5,5,1,1)=1;reread_arrays(5,5,1,2)=1;reread_arrays(5,5,2,1)=1;reread_arrays(5,5,2,2)=1;
    reread_arrays(6,1,1,1)=1;reread_arrays(6,1,1,2)=1;reread_arrays(6,1,2,1)=1;reread_arrays(6,1,2,2)=1;
    reread_arrays(6,2,1,1)=1;reread_arrays(6,2,1,2)=1;reread_arrays(6,2,2,1)=1;reread_arrays(6,2,2,2)=1;
    reread_arrays(6,5,1,1)=1;reread_arrays(6,5,1,2)=1;reread_arrays(6,5,2,1)=1;reread_arrays(6,5,2,2)=1;
    reread_arrays(7,2,1,2)=1;
    reread_arrays(8,1,2,2)=1;
    reread_arrays(8,5,2,2)=1;
    reread_arrays(9,1,1,1)=1;reread_arrays(9,1,1,2)=1;
    reread_arrays(9,2,1,1)=1;reread_arrays(9,2,2,1)=1;reread_arrays(9,2,2,2)=1;
    reread_arrays(9,5,1,1)=1;
    reread_arrays(10,1,2,1)=1;reread_arrays(10,1,2,2)=1;
    reread_arrays(12,1,1,1)=1;reread_arrays(12,1,2,1)=1;reread_arrays(12,1,1,2)=1;reread_arrays(12,1,2,2)=1;
    reread_arrays(12,5,1,1)=1;
    reread_arrays(13,1,1,1)=1;reread_arrays(13,1,1,2)=1;reread_arrays(13,1,2,1)=1;reread_arrays(13,1,2,2)=1;
    reread_arrays(14,1,1,1)=1;reread_arrays(14,1,1,2)=1;reread_arrays(14,1,2,1)=1;reread_arrays(14,1,2,2)=1;
    reread_arrays(14,2,2,2)=1;
    reread_arrays(15,1,1,1)=1;
    reread_arrays(15,2,1,1)=1;reread_arrays(15,2,1,2)=1;reread_arrays(15,2,2,1)=1;reread_arrays(15,2,2,2)=1;
    reread_arrays(15,5,2,2)=1;
    reread_arrays(16,5,1,1)=1;reread_arrays(16,5,1,2)=1;reread_arrays(16,5,2,1)=1;reread_arrays(16,5,2,2)=1;
    reread_arrays(17,1,1,1)=1;reread_arrays(17,1,1,2)=1;reread_arrays(17,1,2,2)=1;reread_arrays(17,1,2,1)=1;
    reread_arrays(17,2,1,1)=1;reread_arrays(17,2,1,2)=1;reread_arrays(17,2,2,1)=1;reread_arrays(17,2,2,2)=1;
    reread_arrays(17,5,1,1)=1;reread_arrays(17,5,1,2)=1;reread_arrays(17,5,2,1)=1;reread_arrays(17,5,2,2)=1;
    reread_arrays(18,1,1,2)=1;
    
    downloadedfromserver2(4,5,1,1)=1;downloadedfromserver2(4,5,1,2)=1;downloadedfromserver2(4,5,2,1)=1;downloadedfromserver2(4,5,2,2)=1;
    downloadedfromserver2(5,1,1,1)=1;downloadedfromserver2(5,1,1,2)=1;downloadedfromserver2(5,1,2,1)=1;downloadedfromserver2(5,1,2,2)=1;
    downloadedfromserver2(5,2,1,1)=1;downloadedfromserver2(5,2,1,2)=1;downloadedfromserver2(5,2,2,1)=1;downloadedfromserver2(5,2,2,2)=1;
    downloadedfromserver2(5,5,1,1)=1;downloadedfromserver2(5,5,1,2)=1;downloadedfromserver2(5,5,2,1)=1;downloadedfromserver2(5,5,2,2)=1;
    downloadedfromserver2(6,1,1,1)=1;downloadedfromserver2(6,1,1,2)=1;downloadedfromserver2(6,1,2,1)=1;downloadedfromserver2(6,1,2,2)=1;
    downloadedfromserver2(6,2,1,1)=1;downloadedfromserver2(6,2,1,2)=1;downloadedfromserver2(6,2,2,1)=1;downloadedfromserver2(6,2,2,2)=1;
    downloadedfromserver2(6,5,1,1)=1;downloadedfromserver2(6,5,1,2)=1;downloadedfromserver2(6,5,2,1)=1;downloadedfromserver2(6,5,2,2)=1;
    downloadedfromserver2(7,2,1,2)=1;
    downloadedfromserver2(8,1,2,2)=1;
    downloadedfromserver2(8,5,2,2)=1;
    downloadedfromserver2(9,1,1,1)=1;downloadedfromserver2(9,1,1,2)=1;
    downloadedfromserver2(9,2,1,1)=1;downloadedfromserver2(9,2,2,1)=1;downloadedfromserver2(9,2,2,2)=1;
    downloadedfromserver2(9,5,1,1)=1;
    downloadedfromserver2(10,1,2,1)=1;downloadedfromserver2(10,1,2,2)=1;
    downloadedfromserver2(12,1,1,1)=1;downloadedfromserver2(12,1,2,1)=1;downloadedfromserver2(12,1,1,2)=1;downloadedfromserver2(12,1,2,2)=1;
    downloadedfromserver2(12,5,1,1)=1;
    downloadedfromserver2(13,1,1,1)=1;downloadedfromserver2(13,1,1,2)=1;downloadedfromserver2(13,1,2,1)=1;downloadedfromserver2(13,1,2,2)=1;
    downloadedfromserver2(14,1,1,1)=1;downloadedfromserver2(14,1,1,2)=1;downloadedfromserver2(14,1,2,1)=1;downloadedfromserver2(14,1,2,2)=1;
    downloadedfromserver2(14,2,2,2)=1;
    downloadedfromserver2(15,1,1,1)=1;
    downloadedfromserver2(15,2,1,1)=1;downloadedfromserver2(15,2,1,2)=1;downloadedfromserver2(15,2,2,1)=1;downloadedfromserver2(15,2,2,2)=1;
    downloadedfromserver2(15,5,2,2)=1;
    downloadedfromserver2(16,5,1,1)=1;downloadedfromserver2(16,5,1,2)=1;downloadedfromserver2(16,5,2,1)=1;downloadedfromserver2(16,5,2,2)=1;
    downloadedfromserver2(17,1,1,1)=1;downloadedfromserver2(17,1,1,2)=1;downloadedfromserver2(17,1,2,2)=1;downloadedfromserver2(17,1,2,1)=1;
    downloadedfromserver2(17,2,1,1)=1;downloadedfromserver2(17,2,1,2)=1;downloadedfromserver2(17,2,2,1)=1;downloadedfromserver2(17,2,2,2)=1;
    downloadedfromserver2(17,5,1,1)=1;downloadedfromserver2(17,5,1,2)=1;downloadedfromserver2(17,5,2,1)=1;downloadedfromserver2(17,5,2,2)=1;
    downloadedfromserver2(18,1,1,2)=1;
    
    
    haveoutputmsg=zeros(4,1);
    
            
    createfinalarrays;
end


%Creates arrays p99esi_hist and similar
if extremeheatbyelev==1
    extremeheatbyelevscript;
end


%Gridpoint 99th-percentile calculations for each variable
if bypointcalculation==1 
    for modelnum=bypointmodelstart:bypointmodelstop
        model=models(modelnum);
        modelname=MODEL_NAME{model};
        
        for expnum=bypointexpstart:bypointexpstop
            experiment=exps(expnum);
            expname=EXP_NAME{experiment};
            
            if experiment==1
                if doesionly==0
                temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL; %1.5 min
                temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL; %1.5 min
                temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL; %1.5 min
                end
                temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL; %1.5 min
                dim1size=size(esiarray_histFINAL,1);dim2size=size(esiarray_histFINAL,2);
                
                if doesionly==0
                if sum(sum(sum(tarray_histFINAL==0)))>0;invalid=tarray_histFINAL==0;tarray_histFINAL(invalid)=NaN;end
                if sum(sum(sum(qarray_histFINAL==0)))>0;invalid=qarray_histFINAL==0;qarray_histFINAL(invalid)=NaN;end
                if sum(sum(sum(rarray_histFINAL==0)))>0;invalid=rarray_histFINAL==0;rarray_histFINAL(invalid)=NaN;end
                end
                if sum(sum(sum(esiarray_histFINAL==0)))>0;invalid=esiarray_histFINAL==0;esiarray_histFINAL(invalid)=NaN;end
            elseif experiment==3
                if doesionly==0
                temp=load(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'));tarray_rcp85FINAL=temp.tarray_rcp85FINAL; %1.5 min
                temp=load(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'));qarray_rcp85FINAL=temp.qarray_rcp85FINAL; %1.5 min
                temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_rcp85FINAL=temp.rarray_rcp85FINAL; %1.5 min
                end
                temp=load(strcat(dataloc,'esiarrayrcp85final',modelname,'.mat'));esiarray_rcp85FINAL=temp.esiarray_rcp85FINAL; %1.5 min
                dim1size=size(esiarray_rcp85FINAL,1);dim2size=size(esiarray_rcp85FINAL,2);
                
                if doesionly==0
                if sum(sum(sum(tarray_rcp85FINAL==0)))>0;invalid=tarray_rcp85FINAL==0;tarray_rcp85FINAL(invalid)=NaN;end
                if sum(sum(sum(qarray_rcp85FINAL==0)))>0;invalid=qarray_rcp85FINAL==0;qarray_rcp85FINAL(invalid)=NaN;end
                if sum(sum(sum(rarray_rcp85FINAL==0)))>0;invalid=rarray_rcp85FINAL==0;rarray_rcp85FINAL(invalid)=NaN;end
                end
                if sum(sum(sum(esiarray_rcp85FINAL==0)))>0;invalid=esiarray_rcp85FINAL==0;esiarray_rcp85FINAL(invalid)=NaN;end
            end
            clear invalid;
            
            if doesionly==0
            tbypointp99=NaN.*ones(dim1size,dim2size);
            qbypointp99=NaN.*ones(dim1size,dim2size);
            rbypointp99=NaN.*ones(dim1size,dim2size);
            end
            esibypointp99=NaN.*ones(dim1size,dim2size);


            
            if experiment==1
                for i=1:dim1size
                    for j=1:dim2size
                        if sum(~isnan(squeeze(esiarray_histFINAL(i,j,:))))>100
                            if doesionly==0
                            tbypointp99(i,j)=quantile(squeeze(tarray_histFINAL(i,j,:)),0.99);
                            qbypointp99(i,j)=quantile(squeeze(qarray_histFINAL(i,j,:)),0.99);
                            rbypointp99(i,j)=quantile(squeeze(rarray_histFINAL(i,j,:)),0.99);
                            end
                            esibypointp99(i,j)=quantile(squeeze(esiarray_histFINAL(i,j,:)),0.99);
                        end
                    end
                    if rem(i,200)==0;fprintf('In computation of bypointp99 arrays, i is %d of %d\n',i,dim1size);disp(clock);end
                end
            elseif experiment==3
                for i=1:dim1size
                    for j=1:dim2size
                        if sum(~isnan(squeeze(esiarray_rcp85FINAL(i,j,:))))>100
                            if doesionly==0
                            tbypointp99(i,j)=quantile(squeeze(tarray_rcp85FINAL(i,j,:)),0.99);
                            qbypointp99(i,j)=quantile(squeeze(qarray_rcp85FINAL(i,j,:)),0.99);
                            rbypointp99(i,j)=quantile(squeeze(rarray_rcp85FINAL(i,j,:)),0.99);
                            end
                            esibypointp99(i,j)=quantile(squeeze(esiarray_rcp85FINAL(i,j,:)),0.99);
                        end
                    end
                    if rem(i,200)==0;fprintf('In computation of bypointp99 arrays, i is %d of %d\n',i,dim1size);disp(clock);end
                end
            end
            
            invalid=isnan(macaelevFINAL);
            if doesionly==0;tbypointp99(invalid)=NaN;qbypointp99(invalid)=NaN;rbypointp99(invalid)=NaN;end
            esibypointp99(invalid)=NaN;


            fprintf('Just completed calculation for exp %s and model %s\n',expname,modelname);disp(clock);

            if savethisnow==1
                if experiment==1
                    if doesionly==0
                    p99tbypoint_hist(model,:,:)=tbypointp99;
                    p99qbypoint_hist(model,:,:)=qbypointp99;
                    p99rbypoint_hist(model,:,:)=rbypointp99;
                    save(strcat(dataloc,'twbypointresults.mat'),...
                        'p99tbypoint_hist','p99qbypoint_hist','p99rbypoint_hist','-append');
                    end
                    p99esibypoint_hist(model,:,:)=esibypointp99;
                    save(strcat(dataloc,'twbypointresults.mat'),'p99esibypoint_hist','-append');
                elseif experiment==3
                    if doesionly==0
                    p99tbypoint_rcp85(model,:,:)=tbypointp99;
                    p99qbypoint_rcp85(model,:,:)=qbypointp99;
                    p99rbypoint_rcp85(model,:,:)=rbypointp99;
                    save(strcat(dataloc,'twbypointresults.mat'),...
                        'p99tbypoint_rcp85','p99qbypoint_rcp85','p99rbypoint_rcp85','-append');
                    end
                    p99esibypoint_rcp85(model,:,:)=esibypointp99;
                    save(strcat(dataloc,'twbypointresults.mat'),'p99esibypoint_rcp85','-append');
                end
            end
        end
    end
    clear tbypoint;clear qbypoint;clear rbypoint;clear esibypoint;
end



%Various final preparation before making figures
if doqc==1
    temp=load(strcat(dataloc,'twbypointresults.mat'));
    p99esibypoint_hist=temp.p99esibypoint_hist;p99esibypoint_rcp85=temp.p99esibypoint_rcp85;
    p99tbypoint_hist=temp.p99tbypoint_hist;p99tbypoint_rcp85=temp.p99tbypoint_rcp85;
    p99qbypoint_hist=temp.p99qbypoint_hist;p99qbypoint_rcp85=temp.p99qbypoint_rcp85;
    p99rbypoint_hist=temp.p99rbypoint_hist;p99rbypoint_rcp85=temp.p99rbypoint_rcp85;

    
    %Eliminate missing, bad, or highly uncertain results 
    invalid=p99esibypoint_hist<-20;p99esibypoint_hist(invalid)=NaN;
    invalid=p99esibypoint_rcp85<-20;p99esibypoint_rcp85(invalid)=NaN;
    invalid=p99tbypoint_hist==0;p99tbypoint_hist(invalid)=NaN;
    invalid=p99qbypoint_hist==0;p99qbypoint_hist(invalid)=NaN;
    invalid=p99rbypoint_hist==0;p99rbypoint_hist(invalid)=NaN;
    invalid=p99tbypoint_rcp85==0;p99tbypoint_rcp85(invalid)=NaN;
    invalid=p99qbypoint_rcp85==0;p99qbypoint_rcp85(invalid)=NaN;
    invalid=p99rbypoint_rcp85==0;p99rbypoint_rcp85(invalid)=NaN;
    
    
    if redoeliminationofbaddata==1
        %Eliminate bad data (e.g., phantom hotspots) based on an "out-of-sample" comparison with ERA5 -- phantom hotspots in models come from gridMET itself!!
        temp=load(strcat(dataloc,'biasarraysapril2021.mat'));p99qbypointgridmet=temp.p99qbypointgridmet;
        p99qbypointgridmet_interp=interp2(gridmetlons',gridmetlats',p99qbypointgridmet',macalonsFINAL',macalatsFINAL')';
        td_era5_interp=NaN.*ones(692,292,365,10);
        for year=2010:2019
            td_era5=ncread(strcat('/Volumes/ExternalDriveZ/ERA5Land_US/td2m_',num2str(year),'_us.nc'),'d2m');
            if year==2010
                lat_era5=ncread(strcat('/Volumes/ExternalDriveZ/ERA5Land_US/td2m_',num2str(year),'_us.nc'),'latitude');
                lon_era5=ncread(strcat('/Volumes/ExternalDriveZ/ERA5Land_US/td2m_',num2str(year),'_us.nc'),'longitude');
                for i=1:size(lat_era5,1)
                    for j=1:size(lon_era5,1)
                        lat2d_era5(i,j)=lat_era5(i);lon2d_era5(i,j)=lon_era5(j);
                    end
                end
                macalonsFINAL_transp=macalonsFINAL';macalatsFINAL_transp=macalatsFINAL';
            end

            clear td_dailymax;
            for i=8:8:size(td_era5,3)
                td_dailymax(:,:,i/8)=max(td_era5(:,:,i-7:i),[],3);
            end

            for hr=1:size(td_dailymax,3)
                thishrdata=squeeze(td_dailymax(:,:,hr));
                X=double(lon2d_era5);Y=double(lat2d_era5);V=thishrdata';Xq=macalonsFINAL_transp;Yq=macalatsFINAL_transp;
                td_era5_interp(:,:,hr,year-2009)=interp2(X,Y,V,Xq,Yq)';
            end
        end
        dailymaxtd_era5_interp1d=reshape(td_era5_interp,[size(td_era5_interp,1) size(td_era5_interp,2) size(td_era5_interp,3)*size(td_era5_interp,4)]);


        p99td_era5=quantile(dailymaxtd_era5_interp1d,0.99,3);
        invalid=p99td_era5==0;p99td_era5(invalid)=NaN;
        p99q_era5=calcqfromTd(p99td_era5-273.15);


        %Plot only differences where the difference in elevation between datasets is <100 m
        z_era5land=ncread('/Volumes/ExternalDriveZ/ERA5Land_US/geopotential.nc','z')./9.81;
        lat_era5land=ncread('/Volumes/ExternalDriveZ/ERA5Land_US/geopotential.nc','latitude');
        lon_era5land=ncread('/Volumes/ExternalDriveZ/ERA5Land_US/geopotential.nc','longitude');
        clear lat2d_era5land;clear lon2d_era5land;
        for i=1:size(lat_era5land,1)
            for j=1:size(lon_era5land,1)
                lat2d_era5land(j,i)=lat_era5land(i);
                lon2d_era5land(j,i)=lon_era5land(j);
            end
        end
        z_era5land=z_era5land';lat2d_era5land=lat2d_era5land';lon2d_era5land=lon2d_era5land';
        z_era5land=[z_era5land(:,1801:3600) z_era5land(:,1:1800)];lon2d_era5land=[lon2d_era5land(:,1801:3600) lon2d_era5land(:,1:1800)];
        westernhem=lon2d_era5land>=180;lon2d_era5land(westernhem)=lon2d_era5land(westernhem)-360;
        westernhem=lon_era5land>=180;lon_era5land(westernhem)=lon_era5land(westernhem)-360;
        lon_era5land=[lon_era5land(1801:3600) lon_era5land(1:1800)];
        X=double(lon2d_era5land);Y=double(lat2d_era5land);V=double(z_era5land);V=[V(:,1801:3600) V(:,1:1800)];
        z_era5land=fliplr(z_era5land);
        Xq=macalonsFINAL_transp;Yq=macalatsFINAL_transp;
        z_era5land_interp=fliplr(flipud(interp2(X,Y,V,Xq,Yq))');

        elevsfarapart=abs(macaelevFINAL-z_era5land_interp)>100;
        diffbetween(elevsfarapart)=NaN;

        %Throw out all of a model's data for a time period for a gridpoint, if there is a changepoint of mean or variance in the annual max
        %This is done only for radiation, because the MACA dataset seems especially prone to problems for radiation. T and q are much better (although maybe not perfect)
        %Runtime is 2 min per model
        datathrownout_hist=zeros(20,692,292);datathrownout_duetomean_hist=zeros(20,692,292);datathrownout_duetostdev_hist=zeros(20,692,292);
        datathrownout_rcp85=zeros(20,692,292);datathrownout_duetomean_rcp85=zeros(20,692,292);datathrownout_duetostdev_rcp85=zeros(20,692,292);
        for modelnum=1:20
            modelname=MODEL_NAME{modelnum};
            for tperiod=1:2
                if tperiod==1
                    temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_FINAL=temp.rarray_histFINAL;
                    p99rbypoint=p99rbypoint_hist;p99esibypoint=p99esibypoint_hist;
                elseif tperiod==2
                    temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_FINAL=temp.rarray_rcp85FINAL;
                    p99rbypoint=p99rbypoint_rcp85;p99esibypoint=p99esibypoint_rcp85;
                end
                changeptmap=zeros(692,292);changeptmap_duetomean=zeros(692,292);
                stdevtemp1=zeros(692,292);stdevtemp2=zeros(692,292);stdevtemp3=zeros(692,292);stdevtemp4=zeros(692,292);
                meantemp1=zeros(692,292);meantemp2=zeros(692,292);meantemp3=zeros(692,292);

                clear annualmaxes;
                for k=184:184:4784
                    annualmaxes(k/184,:,:)=max(rarray_FINAL(:,:,k-183:k),[],3);
                end
                for dividingind=7:19
                    part1=squeeze(annualmaxes(1:dividingind,:,:));
                    part2=squeeze(annualmaxes(dividingind+1:end,:,:));
                    mean1=squeeze(mean(part1));stdev1=squeeze(std(part1));
                    mean2=squeeze(mean(part2));stdev2=squeeze(std(part2));
                    cond1=abs(mean2-mean1)>=15;cond2=squeeze(std(annualmaxes)<=10);
                    meantemp1(cond1 & cond2)=1;meantemp2(mean1==0)=1;meantemp3(mean2==0)=1;
                    stdevtemp1((stdev2./stdev1)>=15)=1;stdevtemp2((stdev2./stdev1)<=1/15)=1;stdevtemp3(stdev1==0)=1;stdevtemp4(stdev2==0)=1;
                end
                changeptmap_duetomean=meantemp1+meantemp2+meantemp3;
                gt1=changeptmap_duetomean>1;changeptmap_duetomean(gt1)=1;
                changeptmap_duetostdev=stdevtemp1+stdevtemp2+stdevtemp3+stdevtemp4;
                gt1=changeptmap_duetostdev>1;changeptmap_duetostdev(gt1)=1;

                changeptmap=changeptmap_duetomean+changeptmap_duetostdev;
                gt1=changeptmap>1;changeptmap(gt1)=1;

                %Bad radiation data affects r and esi for this model and time period
                thismodelp99r=squeeze(p99rbypoint(modelnum,:,:));
                toremove=changeptmap==1;thismodelp99r(toremove)=NaN;p99rbypoint(modelnum,:,:)=thismodelp99r;
                thismodelp99esi=squeeze(p99esibypoint(modelnum,:,:));
                toremove=changeptmap==1;thismodelp99esi(toremove)=NaN;p99esibypoint(modelnum,:,:)=thismodelp99esi;


                if tperiod==1
                    p99rbypoint_hist=p99rbypoint;p99esibypoint_hist=p99esibypoint;
                    datathrownout_hist(modelnum,:,:)=changeptmap;
                    datathrownout_duetomean_hist(modelnum,:,:)=changeptmap_duetomean;
                    datathrownout_duetostdev_hist(modelnum,:,:)=changeptmap_duetostdev;
                elseif tperiod==2
                    p99rbypoint_rcp85=p99rbypoint;p99esibypoint_rcp85=p99esibypoint;
                    datathrownout_rcp85(modelnum,:,:)=changeptmap;
                    datathrownout_duetomean_rcp85(modelnum,:,:)=changeptmap_duetomean;
                    datathrownout_duetostdev_rcp85(modelnum,:,:)=changeptmap_duetostdev;
                end
                fprintf('At line 1290, just completed model %d and time period %d\n',modelnum,tperiod);disp(clock);
            end
        end

        otherbaddata_hist=zeros(20,692,292);otherbaddata_rcp85=zeros(20,692,292);
        
        %Also, remove data subsequently manually determined to be unreliable for the specified reasons
        %model 14--unrealistically large q changes in West create shadow effect in complex terrain
        p99esibypoint_rcp85(14,:,:)=NaN;otherbaddata_rcp85(14,:,:)=1;
        %models 7, 16--artifact line of unknown origin at 105W
        p99esibypoint_rcp85(7,:,:)=NaN;otherbaddata_rcp85(7,:,:)=1;
        p99esibypoint_rcp85(16,:,:)=NaN;otherbaddata_rcp85(16,:,:)=1;
        
        save(strcat(dataloc,'twbypointresults_qced.mat'),...
            'p99rbypoint_hist','p99esibypoint_hist','p99rbypoint_rcp85','p99esibypoint_rcp85',...
            'datathrownout_hist','datathrownout_rcp85','otherbaddata_hist','otherbaddata_rcp85');
    else
        %Subsequently: reconstruct above results using datathrownout
        f=load(strcat(dataloc,'twbypointresults_qced.mat'));
        p99rbypoint_hist=f.p99rbypoint_hist;p99rbypoint_rcp85=f.p99rbypoint_rcp85;
        p99esibypoint_hist=f.p99esibypoint_hist;p99esibypoint_rcp85=f.p99esibypoint_rcp85;
        datathrownout_hist=f.datathrownout_hist;datathrownout_rcp85=f.datathrownout_rcp85;
        
        toremove=datathrownout_hist==1;p99rbypoint_hist(toremove)=NaN;p99esibypoint_hist(toremove)=NaN;
        toremove=datathrownout_rcp85==1;p99rbypoint_rcp85(toremove)=NaN;p99esibypoint_rcp85(toremove)=NaN;
    end
    
    
    
        
    for reg=1:numregs
        p99esi_hist=eval(['p99esi_hist_' regsuffixes{reg} ';']);
        invalid=abs(p99esi_hist)>1000;p99esi_hist(invalid)=NaN;
        invalid=abs(p99esi_hist)==0;p99esi_hist(invalid)=NaN;
        eval(['p99esi_hist_' regsuffixes{reg} '=p99esi_hist;']);
        
        p99esi_rcp85=eval(['p99esi_rcp85_' regsuffixes{reg} ';']);
        invalid=abs(p99esi_rcp85)>1000;p99esi_rcp85(invalid)=NaN;
        invalid=abs(p99esi_rcp85)==0;p99esi_rcp85(invalid)=NaN;
        eval(['p99esi_rcp85_' regsuffixes{reg} '=p99esi_rcp85;']);
        
        p99t_hist=eval(['p99t_hist_' regsuffixes{reg} ';']);
        invalid=abs(p99t_hist)>1000;p99t_hist(invalid)=NaN;
        invalid=abs(p99t_hist)==0;p99t_hist(invalid)=NaN;
        eval(['p99t_hist_' regsuffixes{reg} '=p99t_hist;']);
        
        p99t_rcp85=eval(['p99t_rcp85_' regsuffixes{reg} ';']);
        invalid=abs(p99t_rcp85)>1000;p99t_rcp85(invalid)=NaN;
        invalid=abs(p99t_rcp85)==0;p99t_rcp85(invalid)=NaN;
        eval(['p99t_rcp85_' regsuffixes{reg} '=p99t_rcp85;']);
        
        p99q_hist=eval(['p99q_hist_' regsuffixes{reg} ';']);
        invalid=abs(p99q_hist)>1000;p99q_hist(invalid)=NaN;
        invalid=abs(p99q_hist)==0;p99q_hist(invalid)=NaN;
        eval(['p99q_hist_' regsuffixes{reg} '=p99q_hist;']);
        
        p99q_rcp85=eval(['p99q_rcp85_' regsuffixes{reg} ';']);
        invalid=abs(p99q_rcp85)>1000;p99q_rcp85(invalid)=NaN;
        invalid=abs(p99q_rcp85)==0;p99q_rcp85(invalid)=NaN;
        eval(['p99q_rcp85_' regsuffixes{reg} '=p99q_rcp85;']);
        
        p99r_hist=eval(['p99r_hist_' regsuffixes{reg} ';']);
        invalid=abs(p99r_hist)>1000;p99r_hist(invalid)=NaN;
        invalid=abs(p99r_hist)==0;p99r_hist(invalid)=NaN;
        eval(['p99r_hist_' regsuffixes{reg} '=p99r_hist;']);
        
        p99r_rcp85=eval(['p99r_rcp85_' regsuffixes{reg} ';']);
        invalid=abs(p99r_rcp85)>1000;p99r_rcp85(invalid)=NaN;
        invalid=abs(p99r_rcp85)==0;p99r_rcp85(invalid)=NaN;
        eval(['p99r_rcp85_' regsuffixes{reg} '=p99r_rcp85;']);
    end
end
    
    
    
if constructfamilyarrays==1
    %Construct arrays that account for model genealogy, and calculate a median across these
    for reg=1:numregs
        p99esi_hist=eval(['p99esi_hist_' regsuffixes{reg} ';']);
        p99esi_familyarray_hist=[p99esi_hist(1:3,1:sz);0.5*p99esi_hist(4,1:sz)+0.5*p99esi_hist(5,1:sz);p99esi_hist(6:7,1:sz);...
            0.33*p99esi_hist(8,1:sz)+0.33*p99esi_hist(9,1:sz)+0.33*p99esi_hist(17,1:sz);...
            0.5*p99esi_hist(10,1:sz)+0.5*p99esi_hist(11,1:sz);p99esi_hist(12,1:sz);...
            0.5*p99esi_hist(13,1:sz)+0.5*p99esi_hist(18,1:sz);p99esi_hist(14,1:sz);...
            0.5*p99esi_hist(15,1:sz)+0.5*p99esi_hist(16,1:sz);0.5*p99esi_hist(19,1:sz)+0.5*p99esi_hist(20,1:sz)];
        p99esi_hist_mmmedian=median(p99esi_familyarray_hist,'omitnan');
        %Include an estimate of uncertainty based on a bootstrapping with replacement
        for eb=1:size(p99esi_familyarray_hist,2)
            for iter=1:1000
                tmp=randsample(p99esi_familyarray_hist(:,eb),size(p99esi_familyarray_hist,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            esihiststdev(reg,eb)=std(tmpmmmedian);
        end
        
        p99esi_rcp85=eval(['p99esi_rcp85_' regsuffixes{reg} ';']);
        p99esi_familyarray_rcp85=[p99esi_rcp85(1:3,1:sz);0.5*p99esi_rcp85(4,1:sz)+0.5*p99esi_rcp85(5,1:sz);p99esi_rcp85(6:7,1:sz);...
            0.33*p99esi_rcp85(8,1:sz)+0.33*p99esi_rcp85(9,1:sz)+0.33*p99esi_rcp85(17,1:sz);...
            0.5*p99esi_rcp85(10,1:sz)+0.5*p99esi_rcp85(11,1:sz);p99esi_rcp85(12,1:sz);...
            0.5*p99esi_rcp85(13,1:sz)+0.5*p99esi_rcp85(18,1:sz);p99esi_rcp85(14,1:sz);...
            0.5*p99esi_rcp85(15,1:sz)+0.5*p99esi_rcp85(16,1:sz);0.5*p99esi_rcp85(19,1:sz)+0.5*p99esi_rcp85(20,1:sz)];
        p99esi_rcp85_mmmedian=median(p99esi_familyarray_rcp85,'omitnan');
        
        invalid=countbyelevineachreg(:,reg+1)<pointcutoff;
            p99esi_hist_mmmedian(invalid)=NaN;p99esi_rcp85_mmmedian(invalid)=NaN;
        notenoughpoints=numpointsbybinandreg(:,reg)<pointcutoff;
            p99esi_hist_mmmedian(notenoughpoints)=NaN;p99esi_rcp85_mmmedian(notenoughpoints)=NaN;
        eval(['p99esi_hist_mmmedian_' regsuffixes{reg} '=p99esi_hist_mmmedian;']);
        eval(['p99esi_rcp85_mmmedian_' regsuffixes{reg} '=p99esi_rcp85_mmmedian;']);
        
        
        %Include an estimate of uncertainty based on a bootstrapping with replacement
        p99esi_familyarray_change=p99esi_familyarray_rcp85-p99esi_familyarray_hist;
        for eb=1:size(p99esi_familyarray_change,2)
            for iter=1:1000
                tmp=randsample(p99esi_familyarray_change(:,eb),size(p99esi_familyarray_change,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            esichangestdev(reg,eb)=std(tmpmmmedian);
        end
        p99esi_familyarray_hist_final{reg}=p99esi_familyarray_hist;p99esi_familyarray_rcp85_final{reg}=p99esi_familyarray_rcp85;
        
        
        p99t_hist=eval(['p99t_hist_' regsuffixes{reg} ';']);
        p99t_familyarray_hist=[p99t_hist(1:3,1:sz);0.5*p99t_hist(4,1:sz)+0.5*p99t_hist(5,1:sz);p99t_hist(6:7,1:sz);...
            0.33*p99t_hist(8,1:sz)+0.33*p99t_hist(9,1:sz)+0.33*p99t_hist(17,1:sz);...
            0.5*p99t_hist(10,1:sz)+0.5*p99t_hist(11,1:sz);p99t_hist(12,1:sz);...
            0.5*p99t_hist(13,1:sz)+0.5*p99t_hist(18,1:sz);p99t_hist(14,1:sz);...
            0.5*p99t_hist(15,1:sz)+0.5*p99t_hist(16,1:sz);0.5*p99t_hist(19,1:sz)+0.5*p99t_hist(20,1:sz)];
        p99t_hist_mmmedian=median(p99t_familyarray_hist,'omitnan');
        
        p99t_rcp85=eval(['p99t_rcp85_' regsuffixes{reg} ';']);
        p99t_familyarray_rcp85=[p99t_rcp85(1:3,1:sz);0.5*p99t_rcp85(4,1:sz)+0.5*p99t_rcp85(5,1:sz);p99t_rcp85(6:7,1:sz);...
            0.33*p99t_rcp85(8,1:sz)+0.33*p99t_rcp85(9,1:sz)+0.33*p99t_rcp85(17,1:sz);...
            0.5*p99t_rcp85(10,1:sz)+0.5*p99t_rcp85(11,1:sz);p99t_rcp85(12,1:sz);...
            0.5*p99t_rcp85(13,1:sz)+0.5*p99t_rcp85(18,1:sz);p99t_rcp85(14,1:sz);...
            0.5*p99t_rcp85(15,1:sz)+0.5*p99t_rcp85(16,1:sz);0.5*p99t_rcp85(19,1:sz)+0.5*p99t_rcp85(20,1:sz)];
        p99t_rcp85_mmmedian=median(p99t_familyarray_rcp85,'omitnan');
        
        invalid=countbyelevineachreg(:,reg+1)<pointcutoff;
            p99t_hist_mmmedian(invalid)=NaN;p99t_rcp85_mmmedian(invalid)=NaN;
        notenoughpoints=numpointsbybinandreg(:,reg)<pointcutoff;
            p99t_hist_mmmedian(notenoughpoints)=NaN;p99t_rcp85_mmmedian(notenoughpoints)=NaN;
        eval(['p99t_hist_mmmedian_' regsuffixes{reg} '=p99t_hist_mmmedian;']);
        eval(['p99t_rcp85_mmmedian_' regsuffixes{reg} '=p99t_rcp85_mmmedian;']);
        %Include an estimate of uncertainty based on a bootstrapping with replacement
        for eb=1:size(p99t_familyarray_hist,2)
            for iter=1:1000
                tmp=randsample(p99t_familyarray_hist(:,eb),size(p99t_familyarray_hist,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            thiststdev(reg,eb)=std(tmpmmmedian);
        end
        p99t_familyarray_change=p99t_familyarray_rcp85-p99t_familyarray_hist;
        for eb=1:size(p99t_familyarray_change,2)
            for iter=1:1000
                tmp=randsample(p99t_familyarray_change(:,eb),size(p99t_familyarray_change,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            tchangestdev(reg,eb)=std(tmpmmmedian);
        end
        p99t_familyarray_hist_final{reg}=p99t_familyarray_hist;p99t_familyarray_rcp85_final{reg}=p99t_familyarray_rcp85;
        
        
        p99q_hist=eval(['p99q_hist_' regsuffixes{reg} ';']);
        p99q_familyarray_hist=[p99q_hist(1:3,1:sz);0.5*p99q_hist(4,1:sz)+0.5*p99q_hist(5,1:sz);p99q_hist(6:7,1:sz);...
            0.33*p99q_hist(8,1:sz)+0.33*p99q_hist(9,1:sz)+0.33*p99q_hist(17,1:sz);...
            0.5*p99q_hist(10,1:sz)+0.5*p99q_hist(11,1:sz);p99q_hist(12,1:sz);...
            0.5*p99q_hist(13,1:sz)+0.5*p99q_hist(18,1:sz);p99q_hist(14,1:sz);...
            0.5*p99q_hist(15,1:sz)+0.5*p99q_hist(16,1:sz);0.5*p99q_hist(19,1:sz)+0.5*p99q_hist(20,1:sz)];
        p99q_hist_mmmedian=median(p99q_familyarray_hist,'omitnan');
        
        p99q_rcp85=eval(['p99q_rcp85_' regsuffixes{reg} ';']);
        p99q_familyarray_rcp85=[p99q_rcp85(1:3,1:sz);0.5*p99q_rcp85(4,1:sz)+0.5*p99q_rcp85(5,1:sz);p99q_rcp85(6:7,1:sz);...
            0.33*p99q_rcp85(8,1:sz)+0.33*p99q_rcp85(9,1:sz)+0.33*p99q_rcp85(17,1:sz);...
            0.5*p99q_rcp85(10,1:sz)+0.5*p99q_rcp85(11,1:sz);p99q_rcp85(12,1:sz);...
            0.5*p99q_rcp85(13,1:sz)+0.5*p99q_rcp85(18,1:sz);p99q_rcp85(14,1:sz);...
            0.5*p99q_rcp85(15,1:sz)+0.5*p99q_rcp85(16,1:sz);0.5*p99q_rcp85(19,1:sz)+0.5*p99q_rcp85(20,1:sz)];
        p99q_rcp85_mmmedian=median(p99q_familyarray_rcp85,'omitnan');
        
        invalid=countbyelevineachreg(:,reg+1)<pointcutoff;
            p99q_hist_mmmedian(invalid)=NaN;p99q_rcp85_mmmedian(invalid)=NaN;
        notenoughpoints=numpointsbybinandreg(:,reg)<pointcutoff;
            p99q_hist_mmmedian(notenoughpoints)=NaN;p99q_rcp85_mmmedian(notenoughpoints)=NaN;
        eval(['p99q_hist_mmmedian_' regsuffixes{reg} '=p99q_hist_mmmedian;']);
        eval(['p99q_rcp85_mmmedian_' regsuffixes{reg} '=p99q_rcp85_mmmedian;']);
        %Include an estimate of uncertainty based on a bootstrapping with replacement
        for eb=1:size(p99q_familyarray_hist,2)
            for iter=1:1000
                tmp=randsample(p99q_familyarray_hist(:,eb),size(p99q_familyarray_hist,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            qhiststdev(reg,eb)=std(tmpmmmedian);
        end
        p99q_familyarray_change=p99q_familyarray_rcp85-p99q_familyarray_hist;
        for eb=1:size(p99q_familyarray_change,2)
            for iter=1:1000
                tmp=randsample(p99q_familyarray_change(:,eb),size(p99q_familyarray_change,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            qchangestdev(reg,eb)=std(tmpmmmedian);
        end
        p99q_familyarray_hist_final{reg}=p99q_familyarray_hist;p99q_familyarray_rcp85_final{reg}=p99q_familyarray_rcp85;
        
        
        p99r_hist=eval(['p99r_hist_' regsuffixes{reg} ';']);
        p99r_familyarray_hist=[p99r_hist(1:3,1:sz);0.5*p99r_hist(4,1:sz)+0.5*p99r_hist(5,1:sz);p99r_hist(6:7,1:sz);...
            0.33*p99r_hist(8,1:sz)+0.33*p99r_hist(9,1:sz)+0.33*p99r_hist(17,1:sz);...
            0.5*p99r_hist(10,1:sz)+0.5*p99r_hist(11,1:sz);p99r_hist(12,1:sz);...
            0.5*p99r_hist(13,1:sz)+0.5*p99r_hist(18,1:sz);p99r_hist(14,1:sz);...
            0.5*p99r_hist(15,1:sz)+0.5*p99r_hist(16,1:sz);0.5*p99r_hist(19,1:sz)+0.5*p99r_hist(20,1:sz)];
        p99r_hist_mmmedian=median(p99r_familyarray_hist,'omitnan');
        
        p99r_rcp85=eval(['p99r_rcp85_' regsuffixes{reg} ';']);
        p99r_familyarray_rcp85=[p99r_rcp85(1:3,1:sz);0.5*p99r_rcp85(4,1:sz)+0.5*p99r_rcp85(5,1:sz);p99r_rcp85(6:7,1:sz);...
            0.33*p99r_rcp85(8,1:sz)+0.33*p99r_rcp85(9,1:sz)+0.33*p99r_rcp85(17,1:sz);...
            0.5*p99r_rcp85(10,1:sz)+0.5*p99r_rcp85(11,1:sz);p99r_rcp85(12,1:sz);...
            0.5*p99r_rcp85(13,1:sz)+0.5*p99r_rcp85(18,1:sz);p99r_rcp85(14,1:sz);...
            0.5*p99r_rcp85(15,1:sz)+0.5*p99r_rcp85(16,1:sz);0.5*p99r_rcp85(19,1:sz)+0.5*p99r_rcp85(20,1:sz)];
        p99r_rcp85_mmmedian=median(p99r_familyarray_rcp85,'omitnan');
        
        invalid=countbyelevineachreg(:,reg+1)<pointcutoff;
            p99r_hist_mmmedian(invalid)=NaN;p99r_rcp85_mmmedian(invalid)=NaN;
        notenoughpoints=numpointsbybinandreg(:,reg)<pointcutoff;
            p99r_hist_mmmedian(notenoughpoints)=NaN;p99r_rcp85_mmmedian(notenoughpoints)=NaN;
        eval(['p99r_hist_mmmedian_' regsuffixes{reg} '=p99r_hist_mmmedian;']);
        eval(['p99r_rcp85_mmmedian_' regsuffixes{reg} '=p99r_rcp85_mmmedian;']);
        %Include an estimate of uncertainty based on a bootstrapping with replacement
        for eb=1:size(p99r_familyarray_hist,2)
            for iter=1:1000
                tmp=randsample(p99r_familyarray_hist(:,eb),size(p99r_familyarray_hist,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            rhiststdev(reg,eb)=std(tmpmmmedian);
        end
        p99r_familyarray_change=p99r_familyarray_rcp85-p99r_familyarray_hist;
        for eb=1:size(p99r_familyarray_change,2)
            for iter=1:1000
                tmp=randsample(p99r_familyarray_change(:,eb),size(p99r_familyarray_change,1),true);
                tmpmmmedian(iter)=median(tmp,'omitnan');
            end
            rchangestdev(reg,eb)=std(tmpmmmedian);
        end
        p99r_familyarray_hist_final{reg}=p99r_familyarray_hist;p99r_familyarray_rcp85_final{reg}=p99r_familyarray_rcp85;
    end
    
    
    allarrs={p99esibypoint_hist;p99esibypoint_rcp85;p99esibypoint_rcp85-p99esibypoint_hist;p99tbypoint_hist;p99tbypoint_rcp85;p99tbypoint_rcp85-p99tbypoint_hist;...
        p99qbypoint_hist;p99qbypoint_rcp85;p99qbypoint_rcp85-p99qbypoint_hist;p99rbypoint_hist;p99rbypoint_rcp85;p99rbypoint_rcp85-p99rbypoint_hist};
    for loop=1:12
        qq=allarrs{loop};
        tmp=[qq(1:3,:,:);sum(cat(4,0.5*qq(4,:,:),0.5*qq(5,:,:)),4,'omitnan');qq(6:7,:,:);...
            sum(cat(4,0.33*qq(8,:,:),0.33*qq(9,:,:),0.33*qq(17,:,:)),4,'omitnan');...
            sum(cat(4,0.5*qq(10,:,:),0.5*qq(11,:,:)),4,'omitnan');qq(12,:,:);...
            sum(cat(4,0.5*qq(13,:,:),0.5*qq(18,:,:)),4,'omitnan');qq(14,:,:);...
            sum(cat(4,0.5*qq(15,:,:),0.5*qq(16,:,:)),4,'omitnan');sum(cat(4,0.5*qq(19,:,:),0.5*qq(20,:,:)),4,'omitnan')];
        if loop==1
            p99esibypoint_family_hist=tmp;
        elseif loop==2
            p99esibypoint_family_rcp85=tmp;
        elseif loop==3
            p99esibypoint_family_change=tmp;
        elseif loop==4
            p99tbypoint_family_hist=tmp;
        elseif loop==5
            p99tbypoint_family_rcp85=tmp;
        elseif loop==6
            p99tbypoint_family_change=tmp;
        elseif loop==7
            p99qbypoint_family_hist=tmp;
        elseif loop==8
            p99qbypoint_family_rcp85=tmp;
        elseif loop==9
            p99qbypoint_family_change=tmp;
        elseif loop==10
            p99rbypoint_family_hist=tmp;
        elseif loop==11
            p99rbypoint_family_rcp85=tmp;
        elseif loop==12
            p99rbypoint_family_change=tmp;
        end
    end
    
    invalid=abs(p99rbypoint_family_change)>=25;p99rbypoint_family_change(invalid)=NaN;
    temp=p99qbypoint_family_change(1,:,:);invalid=abs(temp)>=9*10^-3;temp(invalid)=NaN;p99qbypoint_family_change(1,:,:)=temp;
    temp=p99tbypoint_family_change(4,:,:);invalid=abs(temp)>=13;temp(invalid)=NaN;p99tbypoint_family_change(4,:,:)=temp;
    
    
    
    esihistprelim=squeeze(median(p99esibypoint_family_hist,'omitnan'));
    esichangeprelim=squeeze(median(p99esibypoint_family_change,'omitnan'));
    thistprelim=squeeze(median(p99tbypoint_family_hist,'omitnan'));
    tchangeprelim=squeeze(median(p99tbypoint_family_change,'omitnan'));
    qhistprelim=squeeze(median(p99qbypoint_family_hist,'omitnan'));
    qchangeprelim=squeeze(median(p99qbypoint_family_change,'omitnan'));
    rhistprelim=squeeze(median(p99rbypoint_family_hist,'omitnan'));
    rchangeprelim=squeeze(median(p99rbypoint_family_change,'omitnan'));
    
    invalid=esihistprelim==0;esihistprelim(invalid)=NaN;invalid=thistprelim==0;thistprelim(invalid)=NaN;
    invalid=qhistprelim==0;qhistprelim(invalid)=NaN;invalid=rhistprelim==0;rhistprelim(invalid)=NaN;
    invalid=esichangeprelim==0;esichangeprelim(invalid)=NaN;invalid=tchangeprelim==0;tchangeprelim(invalid)=NaN;
    invalid=qchangeprelim==0;qchangeprelim(invalid)=NaN;invalid=rchangeprelim==0;rchangeprelim(invalid)=NaN;
    
    %In case revisions are made later, save a copy now
    esihist=esihistprelim;esichange=esichangeprelim;
    thist=thistprelim;tchange=tchangeprelim;
    qhist=qhistprelim;qchange=qchangeprelim;
    rhist=rhistprelim;rchange=rchangeprelim;
    
    savenow=0;
    if savenow==1
    save(strcat(dataloc,'p99esimmmedianresults.mat'),'p99esi_hist_mmmedian_nw','p99esi_hist_mmmedian_sw','p99esi_hist_mmmedian_ngp',...
        'p99esi_hist_mmmedian_sgp','p99esi_hist_mmmedian_mw','p99esi_hist_mmmedian_se','p99esi_hist_mmmedian_ne',...
        'p99esi_rcp85_mmmedian_nw','p99esi_rcp85_mmmedian_sw','p99esi_rcp85_mmmedian_ngp',...
        'p99esi_rcp85_mmmedian_sgp','p99esi_rcp85_mmmedian_mw','p99esi_rcp85_mmmedian_se','p99esi_rcp85_mmmedian_ne',...
        'p99t_hist_mmmedian_nw','p99t_hist_mmmedian_sw','p99t_hist_mmmedian_ngp',...
        'p99t_hist_mmmedian_sgp','p99t_hist_mmmedian_mw','p99t_hist_mmmedian_se','p99t_hist_mmmedian_ne',...
        'p99t_rcp85_mmmedian_nw','p99t_rcp85_mmmedian_sw','p99t_rcp85_mmmedian_ngp',...
        'p99t_rcp85_mmmedian_sgp','p99t_rcp85_mmmedian_mw','p99t_rcp85_mmmedian_se','p99t_rcp85_mmmedian_ne',...
        'p99q_hist_mmmedian_nw','p99q_hist_mmmedian_sw','p99q_hist_mmmedian_ngp',...
        'p99q_hist_mmmedian_sgp','p99q_hist_mmmedian_mw','p99q_hist_mmmedian_se','p99q_hist_mmmedian_ne',...
        'p99q_rcp85_mmmedian_nw','p99q_rcp85_mmmedian_sw','p99q_rcp85_mmmedian_ngp',...
        'p99q_rcp85_mmmedian_sgp','p99q_rcp85_mmmedian_mw','p99q_rcp85_mmmedian_se','p99q_rcp85_mmmedian_ne',...
        'p99r_hist_mmmedian_nw','p99r_hist_mmmedian_sw','p99r_hist_mmmedian_ngp',...
        'p99r_hist_mmmedian_sgp','p99r_hist_mmmedian_mw','p99r_hist_mmmedian_se','p99r_hist_mmmedian_ne',...
        'p99r_rcp85_mmmedian_nw','p99r_rcp85_mmmedian_sw','p99r_rcp85_mmmedian_ngp',...
        'p99r_rcp85_mmmedian_sgp','p99r_rcp85_mmmedian_mw','p99r_rcp85_mmmedian_se','p99r_rcp85_mmmedian_ne');
    save(strcat(dataloc,'familychanges.mat'),'p99esibypoint_family_hist','p99esibypoint_family_rcp85','p99esibypoint_family_change',...
        'p99tbypoint_family_hist','p99tbypoint_family_rcp85','p99tbypoint_family_change','p99qbypoint_family_hist','p99qbypoint_family_rcp85','p99qbypoint_family_change',...
        'p99rbypoint_family_hist','p99rbypoint_family_rcp85','p99rbypoint_family_change');
    save(strcat(dataloc,'familymedianresults.mat'),'esihiststdev','esichangestdev','esihistprelim','esichangeprelim',...
        'thiststdev','tchangestdev','thistprelim','tchangeprelim','qhiststdev','qchangestdev','qhistprelim','qchangeprelim',...
        'rhiststdev','rchangestdev','rhistprelim','rchangeprelim');
    save(strcat(dataloc,'familyprofiles.mat'),'p99esi_familyarray_hist_final','p99esi_familyarray_rcp85_final',...
        'p99t_familyarray_hist_final','p99t_familyarray_rcp85_final','p99q_familyarray_hist_final',...
        'p99q_familyarray_rcp85_final','p99r_familyarray_hist_final','p99r_familyarray_rcp85_final');
    end
end



%For each region, create 1000 means at each elevation based on
%bootstrapping with replacement -- with all gridpoints and models pooled together for a particular elevation band & region     
if dobootstrappingofelevcurves==1
    bootstrapmeans=NaN.*ones(7,size(elevcutoffs,2)-1,1000);
    stdevbyregandeb=NaN.*ones(7,size(elevcutoffs,2)-1);
    stdevbyregandeb2_hist=NaN.*ones(7,size(elevcutoffs,2)-1);stdevbyregandeb2_change=NaN.*ones(7,size(elevcutoffs,2)-1);
    for regloop=1:7
        for eb=1:size(elevcutoffs,2)-1
            pointsinthisregionandelevband=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1) & macaregions==regloop+1;
            
            mydata=[];
            for i=1:692
                for j=1:292
                    if pointsinthisregionandelevband(i,j)==1 %pt is of interest
                        for model=1:13
                            mydata=[mydata;p99esibypoint_family_hist(model,i,j)];
                        end
                    end
                end
            end
            %Now, do 1000 bootstrap means
            if size(mydata,1)>=5
                for iter=1:1000
                    bootstrapmeans(regloop,eb,iter)=mean(randsample(mydata,size(mydata,1),true),'omitnan');
                end
            end
            %Get st dev for each region & elevation band
            stdevbyregandeb(regloop,eb)=std(squeeze(bootstrapmeans(regloop,eb,:)));
            
            
            %Slightly different -- each iteration consists of a bootstrap
            %estimate within a single model, and I then take the multi-model median of these means
            clear tempdata_hist;clear tempdata_change;
            for model=1:13
                ptsfound=0;
                for i=1:692
                    for j=1:292
                        if pointsinthisregionandelevband(i,j)==1 %pt is of interest
                            ptsfound=ptsfound+1;
                            tempdata_hist(model,ptsfound)=p99esibypoint_family_hist(model,i,j);
                            tempdata_change(model,ptsfound)=p99esibypoint_family_change(model,i,j);
                        end
                    end
                end
            end
            if ptsfound>=5
                for iter=1:1000
                    clear bootstrapmean_hist;clear bootstrapmean_change;
                    for model=1:13
                        %Now, do 1000 bootstrap means for each model
                        if size(tempdata_hist(model,:),2)>=5
                            bootstrapmean_hist(model)=mean(randsample(tempdata_hist(model,:),size(tempdata_hist(model,:),2),true),'omitnan');
                            bootstrapmean_change(model)=mean(randsample(tempdata_change(model,:),size(tempdata_change(model,:),2),true),'omitnan');
                        end
                    end
                    %Multi-model median
                    mmmed_hist(iter)=median(bootstrapmean_hist);
                    mmmed_change(iter)=median(bootstrapmean_change);
                end
                %Get st dev for each region & elevation band
                stdevbyregandeb2_hist(regloop,eb)=std(squeeze(mmmed_hist));
                stdevbyregandeb2_change(regloop,eb)=std(squeeze(mmmed_change));
            end
        end
    end
end

if numdaysexceeding==1
    for model=1:20
        if model~=16
            modelname=MODEL_NAME{model};
            
            temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL;
            p99esithismodel=quantile(esiarray_histFINAL,0.99,3);clear esiarray_histFINAL;
            temp=load(strcat(dataloc,'esiarrayrcp85final',modelname,'.mat'));esiarray_rcp85FINAL=temp.esiarray_rcp85FINAL;clear temp;
            esiexceedancesthismodel=zeros(692,292);
            for i=1:size(esiarray_rcp85FINAL,3)
                tmp=squeeze(esiarray_rcp85FINAL(:,:,i))>=p99esithismodel;
                esiexceedancesthismodel=esiexceedancesthismodel+tmp;
            end
            clear esiarray_rcp85FINAL;
            
            temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL;
            p99tthismodel=quantile(tarray_histFINAL,0.99,3);clear tarray_histFINAL;
            temp=load(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'));tarray_rcp85FINAL=temp.tarray_rcp85FINAL;clear temp;
            texceedancesthismodel=zeros(692,292);
            for i=1:size(tarray_rcp85FINAL,3)
                tmp=squeeze(tarray_rcp85FINAL(:,:,i))>=p99tthismodel;
                texceedancesthismodel=texceedancesthismodel+tmp;
            end
            clear tarray_rcp85FINAL;
            
            temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL;
            p99qthismodel=quantile(qarray_histFINAL,0.99,3);clear qarray_histFINAL;
            temp=load(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'));qarray_rcp85FINAL=temp.qarray_rcp85FINAL;clear temp;
            qexceedancesthismodel=zeros(692,292);
            for i=1:size(qarray_rcp85FINAL,3)
                tmp=squeeze(qarray_rcp85FINAL(:,:,i))>=p99qthismodel;
                qexceedancesthismodel=qexceedancesthismodel+tmp;
            end
            clear qarray_rcp85FINAL;
            
            temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL;
            p99rthismodel=quantile(rarray_histFINAL,0.99,3);clear rarray_histFINAL;
            temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_rcp85FINAL=temp.rarray_rcp85FINAL;clear temp;
            rexceedancesthismodel=zeros(692,292);
            for i=1:size(rarray_rcp85FINAL,3)
                tmp=squeeze(rarray_rcp85FINAL(:,:,i))>=p99rthismodel;
                rexceedancesthismodel=rexceedancesthismodel+tmp;
            end
            clear rarray_rcp85FINAL;
        end
        exceedpermodel_esi(model,:,:)=esiexceedancesthismodel;
        exceedpermodel_t(model,:,:)=texceedancesthismodel;
        exceedpermodel_q(model,:,:)=qexceedancesthismodel;
        exceedpermodel_r(model,:,:)=rexceedancesthismodel;
        
        disp(model);disp(clock);
    end
    
    exceedpermodel_family_esi=[exceedpermodel_esi(1:3,:,:);0.5*exceedpermodel_esi(4,:,:)+0.5*exceedpermodel_esi(5,:,:);exceedpermodel_esi(6:7,:,:);...
        0.33*exceedpermodel_esi(8,:,:)+0.33*exceedpermodel_esi(9,:,:)+0.33*exceedpermodel_esi(17,:,:);0.5*exceedpermodel_esi(10,:,:)+0.5*exceedpermodel_esi(11,:,:);...
        exceedpermodel_esi(12,:,:);0.5*exceedpermodel_esi(13,:,:)+0.5*exceedpermodel_esi(18,:,:);exceedpermodel_esi(14,:,:);...
        0.5*exceedpermodel_esi(15,:,:)+0.5*exceedpermodel_esi(16,:,:);0.5*exceedpermodel_esi(19,:,:)+0.5*exceedpermodel_esi(20,:,:)];
    exceedpermodel_family_esi(5,:,:)=NaN;exceedpermodel_family_esi(6,:,:)=NaN; %have line artifacts
    
    exceedpermodel_family_t=[exceedpermodel_t(1:3,:,:);0.5*exceedpermodel_t(4,:,:)+0.5*exceedpermodel_t(5,:,:);exceedpermodel_t(6:7,:,:);...
        0.33*exceedpermodel_t(8,:,:)+0.33*exceedpermodel_t(9,:,:)+0.33*exceedpermodel_t(17,:,:);0.5*exceedpermodel_t(10,:,:)+0.5*exceedpermodel_t(11,:,:);...
        exceedpermodel_t(12,:,:);0.5*exceedpermodel_t(13,:,:)+0.5*exceedpermodel_t(18,:,:);exceedpermodel_t(14,:,:);...
        0.5*exceedpermodel_t(15,:,:)+0.5*exceedpermodel_t(16,:,:);0.5*exceedpermodel_t(19,:,:)+0.5*exceedpermodel_t(20,:,:)];
    exceedpermodel_family_t(5,:,:)=NaN;exceedpermodel_family_t(6,:,:)=NaN; %have line artifacts
    
    exceedpermodel_family_q=[exceedpermodel_q(1:3,:,:);0.5*exceedpermodel_q(4,:,:)+0.5*exceedpermodel_q(5,:,:);exceedpermodel_q(6:7,:,:);...
        0.33*exceedpermodel_q(8,:,:)+0.33*exceedpermodel_q(9,:,:)+0.33*exceedpermodel_q(17,:,:);0.5*exceedpermodel_q(10,:,:)+0.5*exceedpermodel_q(11,:,:);...
        exceedpermodel_q(12,:,:);0.5*exceedpermodel_q(13,:,:)+0.5*exceedpermodel_q(18,:,:);exceedpermodel_q(14,:,:);...
        0.5*exceedpermodel_q(15,:,:)+0.5*exceedpermodel_q(16,:,:);0.5*exceedpermodel_q(19,:,:)+0.5*exceedpermodel_q(20,:,:)];
    exceedpermodel_family_q(5,:,:)=NaN;exceedpermodel_family_q(6,:,:)=NaN; %have line artifacts
    
    exceedpermodel_family_r=[exceedpermodel_r(1:3,:,:);0.5*exceedpermodel_r(4,:,:)+0.5*exceedpermodel_r(5,:,:);exceedpermodel_r(6:7,:,:);...
        0.33*exceedpermodel_r(8,:,:)+0.33*exceedpermodel_r(9,:,:)+0.33*exceedpermodel_r(17,:,:);0.5*exceedpermodel_r(10,:,:)+0.5*exceedpermodel_r(11,:,:);...
        exceedpermodel_r(12,:,:);0.5*exceedpermodel_r(13,:,:)+0.5*exceedpermodel_r(18,:,:);exceedpermodel_r(14,:,:);...
        0.5*exceedpermodel_r(15,:,:)+0.5*exceedpermodel_r(16,:,:);0.5*exceedpermodel_r(19,:,:)+0.5*exceedpermodel_r(20,:,:)];
    exceedpermodel_family_r(5,:,:)=NaN;exceedpermodel_family_r(6,:,:)=NaN; %have line artifacts
    
    %We know that because there are 4784 days in each period, there are 48 days above the historical p99 in the historical period
    exceedratio_future_esi=exceedpermodel_family_esi./48;
    exceedratio_future_median_esi=squeeze(median(exceedratio_future_esi));
    exceedratio_future_mean_esi=squeeze(mean(exceedratio_future_esi,'omitnan'));
    
    exceedratio_future_t=exceedpermodel_family_t./48;
    exceedratio_future_median_t=squeeze(median(exceedratio_future_t));
    exceedratio_future_mean_t=squeeze(mean(exceedratio_future_t,'omitnan'));
    
    exceedratio_future_q=exceedpermodel_family_q./48;
    exceedratio_future_median_q=squeeze(median(exceedratio_future_q));
    exceedratio_future_mean_q=squeeze(mean(exceedratio_future_q,'omitnan'));
    
    exceedratio_future_r=exceedpermodel_family_r./48;
    exceedratio_future_median_r=squeeze(median(exceedratio_future_r));
    exceedratio_future_mean_r=squeeze(mean(exceedratio_future_r,'omitnan'));
    save(strcat(dataloc,'exceedratio.mat'),'exceedratio_future_median_esi','exceedratio_future_median_t',...
        'exceedratio_future_median_q','exceedratio_future_median_r','exceedratio_future_mean_esi','exceedratio_future_mean_t',...
        'exceedratio_future_mean_q','exceedratio_future_mean_r');
end



if tqrcontribs==1
    for model=1:20
        modelname=MODEL_NAME{model};

        %Loading -- 10 min
        temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL;
        temp=load(strcat(dataloc,'tarrayhistfinal',modelname,'.mat'));tarray_histFINAL=temp.tarray_histFINAL;
        temp=load(strcat(dataloc,'qarrayhistfinal',modelname,'.mat'));qarray_histFINAL=temp.qarray_histFINAL;
        temp=load(strcat(dataloc,'rarrayhistfinal',modelname,'.mat'));rarray_histFINAL=temp.rarray_histFINAL;
        temp=load(strcat(dataloc,'tarrayrcp85final',modelname,'.mat'));tarray_rcp85FINAL=temp.tarray_rcp85FINAL;
        temp=load(strcat(dataloc,'qarrayrcp85final',modelname,'.mat'));qarray_rcp85FINAL=temp.qarray_rcp85FINAL;
        temp=load(strcat(dataloc,'rarrayrcp85final',modelname,'.mat'));rarray_rcp85FINAL=temp.rarray_rcp85FINAL;

        %Get change in p99 for each variable and gridpt -- 1 min
        diff_p99t=squeeze(p99tbypoint_rcp85(model,:,:)-p99tbypoint_hist(model,:,:));
        diff_p99q=squeeze(p99qbypoint_rcp85(model,:,:)-p99qbypoint_hist(model,:,:));
        diff_p99r=squeeze(p99rbypoint_rcp85(model,:,:)-p99rbypoint_hist(model,:,:));


        %ESI effect of increasing T (2 min)
        rharray_histFINAL=calcrhfromTanddewpt(tarray_rcp85FINAL-273.15,...
            calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_rcp85FINAL))); %3 min
            invalid=rharray_histFINAL>100;rharray_histFINAL(invalid)=NaN;qarray_histFINAL(invalid)=NaN;clear invalid; %10 sec
        esi_withtchange=0.63.*(tarray_rcp85FINAL-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_histFINAL+...
            0.0054.*((tarray_rcp85FINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_histFINAL).^-1; %40 sec
        p99change_duetot=quantile(esi_withtchange,0.99,3)-squeeze(p99esibypoint_hist(model,:,:));clear esi_withtchange;

        %ESI effect of increasing q (2 min)
        rharray_histFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
            calcTdfromq_dynamicP(qarray_rcp85FINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
        esi_withqchange=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_histFINAL+...
            0.0054.*((tarray_histFINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_histFINAL).^-1; %40 sec
        p99change_duetoq=quantile(esi_withqchange,0.99,3)-squeeze(p99esibypoint_hist(model,:,:));clear esi_withqchange;

        %ESI effect of changing r (2 min)
        rharray_histFINAL=calcrhfromTanddewpt(tarray_histFINAL-273.15,...
            calcTdfromq_dynamicP(qarray_histFINAL.*1000,pressurefromelev_dynamicT(repmat(macaelevFINAL,[1 1 nd]),tarray_histFINAL))); %3 min
        esi_withrchange=0.63.*(tarray_histFINAL-273.15)-0.03.*rharray_histFINAL+0.002.*rarray_rcp85FINAL+...
            0.0054.*((tarray_histFINAL-273.15).*rharray_histFINAL)-0.073.*(0.1*rarray_rcp85FINAL).^-1; %40 sec
        p99change_duetor=quantile(esi_withrchange,0.99,3)-squeeze(p99esibypoint_hist(model,:,:));clear esi_withrchange;

        clear rharray_histFINAL;


        meanteffect(model,:,:)=real(p99change_duetot);
        meanqeffect(model,:,:)=real(p99change_duetoq);
        meanreffect(model,:,:)=real(p99change_duetor);
        save(strcat(dataloc,'meanclimchangeeffects.mat'),'meanteffect','meanqeffect','meanreffect','-append');

        fprintf('Finished model %d\n',model);disp(clock);
    end
    
    %Compute model families and then medians and mean (or just mean...)
    meanteffect_family=[meanteffect(1:3,:,:);0.5*meanteffect(4,:,:)+0.5*meanteffect(5,:,:);meanteffect(6:7,:,:);...
        0.33*meanteffect(8,:,:)+0.33*meanteffect(9,:,:)+0.33*meanteffect(17,:,:);0.5*meanteffect(10,:,:)+0.5*meanteffect(11,:,:);...
        meanteffect(12,:,:);0.5*meanteffect(13,:,:)+0.5*meanteffect(18,:,:);meanteffect(14,:,:);...
        0.5*meanteffect(15,:,:)+0.5*meanteffect(16,:,:);0.5*meanteffect(19,:,:)+0.5*meanteffect(20,:,:)];
    
    meanqeffect_family=[meanqeffect(1:3,:,:);0.5*meanqeffect(4,:,:)+0.5*meanqeffect(5,:,:);meanqeffect(6:7,:,:);...
        0.33*meanqeffect(8,:,:)+0.33*meanqeffect(9,:,:)+0.33*meanqeffect(17,:,:);0.5*meanqeffect(10,:,:)+0.5*meanqeffect(11,:,:);...
        meanqeffect(12,:,:);0.5*meanqeffect(13,:,:)+0.5*meanqeffect(18,:,:);meanqeffect(14,:,:);...
        0.5*meanqeffect(15,:,:)+0.5*meanqeffect(16,:,:);0.5*meanqeffect(19,:,:)+0.5*meanqeffect(20,:,:)];
    
    meanreffect_family=[meanreffect(1:3,:,:);0.5*meanreffect(4,:,:)+0.5*meanreffect(5,:,:);meanreffect(6:7,:,:);...
        0.33*meanreffect(8,:,:)+0.33*meanreffect(9,:,:)+0.33*meanreffect(17,:,:);0.5*meanreffect(10,:,:)+0.5*meanreffect(11,:,:);...
        meanreffect(12,:,:);0.5*meanreffect(13,:,:)+0.5*meanreffect(18,:,:);meanreffect(14,:,:);...
        0.5*meanreffect(15,:,:)+0.5*meanreffect(16,:,:);0.5*meanreffect(19,:,:)+0.5*meanreffect(20,:,:)];

    
    %Get representative central value for each variable
    quartile1_t=squeeze(quantile(meanteffect_family,0.25));quartile3_t=squeeze(quantile(meanteffect_family,0.75));
    quartile1_q=squeeze(quantile(meanqeffect_family,0.25));quartile3_q=squeeze(quantile(meanqeffect_family,0.75));
    quartile1_r=squeeze(quantile(meanreffect_family,0.25));quartile3_r=squeeze(quantile(meanreffect_family,0.75));
    tdataincentralquartiles=NaN.*ones(size(meanteffect_family,1),692,292);
    qdataincentralquartiles=NaN.*ones(size(meanqeffect_family,1),692,292);
    rdataincentralquartiles=NaN.*ones(size(meanreffect_family,1),692,292);
    for i=1:692
        for j=1:292
            for modelfamily=1:size(meanteffect_family,1)
                if meanteffect_family(modelfamily,i,j)>=quartile1_t(i,j) && meanteffect_family(modelfamily,i,j)<=quartile3_t(i,j)
                    tdataincentralquartiles(modelfamily,i,j)=meanteffect_family(modelfamily,i,j);
                end
                if meanqeffect_family(modelfamily,i,j)>=quartile1_q(i,j) && meanqeffect_family(modelfamily,i,j)<=quartile3_q(i,j)
                    qdataincentralquartiles(modelfamily,i,j)=meanqeffect_family(modelfamily,i,j);
                end
                if meanreffect_family(modelfamily,i,j)>=quartile1_r(i,j) && meanreffect_family(modelfamily,i,j)<=quartile3_r(i,j)
                    rdataincentralquartiles(modelfamily,i,j)=meanreffect_family(modelfamily,i,j);
                end
            end
        end
    end
    finalmeanteffect=squeeze(mean(tdataincentralquartiles,'omitnan'));
    finalmeanqeffect=squeeze(mean(qdataincentralquartiles,'omitnan'));
    finalmeanreffect=squeeze(mean(rdataincentralquartiles,'omitnan'));
    
    %Compute relative proportions
    relteffect=finalmeanteffect./(finalmeanteffect+finalmeanqeffect+finalmeanreffect);invalid=relteffect<-0.5;relteffect(invalid)=NaN;invalid=relteffect>1;relteffect(invalid)=NaN;
    relqeffect=finalmeanqeffect./(finalmeanteffect+finalmeanqeffect+finalmeanreffect);invalid=relqeffect<-0.5;relqeffect(invalid)=NaN;invalid=relqeffect>1;relqeffect(invalid)=NaN;
    relreffect=finalmeanreffect./(finalmeanteffect+finalmeanqeffect+finalmeanreffect);invalid=relreffect<-0.5;relreffect(invalid)=NaN;invalid=relreffect>1;relreffect(invalid)=NaN;
    
    save(strcat(dataloc,'meanclimchangeeffects.mat'),'relteffect','relqeffect','relreffect','-append');
end


if gomakefigures==1
    makefigures;
end




clear figloc;




if compareagainstobstrends==1
    %99th percentile over all MJJASO days in a given elevation category and region, separated into 5-year bins to allow for a trend to be calculated
    temp=load(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/latlonarray'));era5latarray=temp.latarray;era5lonarray=temp.lonarray; %centered on 180
        era5latarray=era5latarray(101:300,901:1200);era5lonarray=era5lonarray(101:300,901:1200);
    temp=ncread('elevera5.nc','z');era5elevarray=(squeeze(temp(:,:,1))./9.81)'; %centered on 180
        era5elevarray=era5elevarray(101:300,901:1200);
    
    era5regions=ncaregionsfromlatlon(era5latarray,era5lonarray);
    
    
    usdata_5years=NaN.*ones(920,200,300);
    yearbinstarts=1981:5:2001;yearbinstops=yearbinstarts+4;
    lastyearexcluded=1980;yearbinindex=1;
    p99mse_all=NaN.*ones(size(elevcutoffs,2),7,5);p98mse_all=NaN.*ones(size(elevcutoffs,2),7,5);p95mse_all=NaN.*ones(size(elevcutoffs,2),7,5);
    for year=1981:2005
            f=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year),'.mat'));
            dailymaxmserows101to200=f.dailymaxmserows101to200;dailymaxmserows201to300=f.dailymaxmserows201to300;clear f;
            usdata=cat(2,dailymaxmserows101to200,dailymaxmserows201to300);usdata=usdata(121:304,:,901:1200);
            usdata_5years((year-lastyearexcluded)*184-183:(year-lastyearexcluded)*184,:,:)=usdata;

            dothis=1;
            if dothis==1
                if rem(year,5)==0 %end of a bin
                    elevbinc=0;
                    for eb=3:5:size(elevcutoffs,2)-1
                        elevbinc=elevbinc+1;
                        for regloop=1:7        
                            pointsinthisbinandreg=era5elevarray>=elevcutoffs(eb) & era5elevarray<elevcutoffs(eb+4) & era5regions==regloop+1; %elev bins of 250 m rather than 50 m
                            pointsinthisbinandreg2=repmat(pointsinthisbinandreg,[1 1 size(usdata_5years,1)]);
                            pointsinthisbinandreg2=permute(pointsinthisbinandreg2,[3 1 2]);

                            p99mse_all(elevbinc,regloop,yearbinindex)=quantile(usdata_5years(pointsinthisbinandreg2),0.99);
                            p98mse_all(elevbinc,regloop,yearbinindex)=quantile(usdata_5years(pointsinthisbinandreg2),0.98);
                            p95mse_all(elevbinc,regloop,yearbinindex)=quantile(usdata_5years(pointsinthisbinandreg2),0.95);
                            era5pointsbyregandelevbin(regloop,elevbinc)=sum(sum(pointsinthisbinandreg));clear pointsinthisbinandreg;
                        end
                    end
                    lastyearexcluded=year;yearbinindex=yearbinindex+1;

                    dothisagain=0;
                    if dothisagain==1
                    if year==1985
                        usdata19811985=usdata_5years;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxin5yearbins.mat','usdata19811985','-append');
                    elseif year==1990
                        usdata19861990=usdata_5years;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxin5yearbins.mat','usdata19861990','-append');
                    elseif year==1995
                        usdata19911995=usdata_5years;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxin5yearbins.mat','usdata19911995','-append');
                    elseif year==2000
                        usdata19962000=usdata_5years;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxin5yearbins.mat','usdata19962000','-append');
                    elseif year==2005
                        usdata20012005=usdata_5years;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxin5yearbins.mat','usdata20012005','-append');
                    end
                    end
                    usdata_5years=NaN.*ones(size(usdata_5years,1),200,300);
                end
            else
                eval(['usdata_' num2str(year) '=usdata;']);
            end
        %end
        fprintf('Year is %d\n',year);
    end
    
    
    tmp=load('/Volumes/ExternalDriveC/RaymondMatthewsHorton2020_Github/Data_BigFilesOnly/finalarrays.mat');twarray=tmp.twarray;
    tmp=load('/Volumes/ExternalDriveC/RaymondMatthewsHorton2020_Github/Data/finalstnmetadata.mat');finalstnlatlon=tmp.finalstnlatlon;finalstnelev=tmp.finalstnelev;
    nwstns=cell(10);swstns=cell(10);ngpstns=cell(10);sgpstns=cell(10);mwstns=cell(10);sestns=cell(10);nestns=cell(10);
    may1ord=zeros(25,1);may1ord(1)=18384;
    for year=1982:2005
        if rem(year,4)==0;yl=366;else;yl=365;end
        may1ord(year-1980)=may1ord(year-1980-1)+yl;
    end
    nwc=zeros(round(size(elevcutoffs,2)/5),1);swc=zeros(round(size(elevcutoffs,2)/5),1);ngpc=zeros(round(size(elevcutoffs,2)/5),1);sgpc=zeros(round(size(elevcutoffs,2)/5),1);
    mwc=zeros(round(size(elevcutoffs,2)/5),1);sec=zeros(round(size(elevcutoffs,2)/5),1);nec=zeros(round(size(elevcutoffs,2)/5),1);
    for stnnum=1:size(finalstnlatlon,1)
        thisstnreg=ncaregionsfromlatlon(finalstnlatlon(stnnum,1),finalstnlatlon(stnnum,2));
        binc=0;
        for eb=7:5:size(elevcutoffs,2)-1 %250-m increments, starting with 0-250 m
            binc=binc+1;
            if finalstnelev(stnnum)>=elevcutoffs(eb-4) && finalstnelev(stnnum)<elevcutoffs(eb+1) %this station is in the right elev bin
                if thisstnreg==2;nwc(binc)=nwc(binc)+1;for ybin=1:5;for ywithin=1:5;nwstns{binc}(nwc(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==3;swc(binc)=swc(binc)+1;for ybin=1:5;for ywithin=1:5;swstns{binc}(swc(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==4;ngpc(binc)=ngpc(binc)+1;for ybin=1:5;for ywithin=1:5;ngpstns{binc}(ngpc(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==5;sgpc(binc)=sgpc(binc)+1;for ybin=1:5;for ywithin=1:5;sgpstns{binc}(sgpc(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==6;mwc(binc)=mwc(binc)+1;for ybin=1:5;for ywithin=1:5;mwstns{binc}(mwc(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==7;sec(binc)=sec(binc)+1;for ybin=1:5;for ywithin=1:5;sestns{binc}(sec(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
                if thisstnreg==8;nec(binc)=nec(binc)+1;for ybin=1:5;for ywithin=1:5;nestns{binc}(nec(binc),ybin,:)=[twarray(stnnum,may1ord(ybin*5-5+ywithin):may1ord(ybin*5-5+ywithin)+183,3)];end;end;end
            end
        end
    end
    
    
    %Compute trends
    %a. ERA5 (MSE)
    clear era5trend;
    for eb=1:size(elevcutoffs,2)-1
        for regloop=1:7
            era5trend(regloop,eb)=(p99mse_all(eb,regloop,5)+p99mse_all(eb,regloop,4)-p99mse_all(eb,regloop,2)-p99mse_all(eb,regloop,1))./15; %J/kg per year
        end
    end
    save(strcat(dataloc,'trendcomparison.mat'),'era5trend','-append');
    
    
    %b. HadISD stations (Tw)
    clear stnstrend;
    binc=0;
    for eb=1:round((size(elevcutoffs,2)-1)/5)
        binc=binc+1;
        for regloop=1:7
            if size(eval([regsuffixes{regloop} 'stns{eb};']),1)>=1
                hdata=eval([regsuffixes{regloop} 'stns{eb}(:,1:2,:);']);hdata=reshape(hdata,[size(hdata,1)*size(hdata,2)*size(hdata,3) 1]);
                stnsp99twearlier=quantile(hdata,0.99);
                fdata=eval([regsuffixes{regloop} 'stns{eb}(:,4:5,:);']);fdata=reshape(fdata,[size(fdata,1)*size(fdata,2)*size(fdata,3) 1]);
                stnsp99twlater=quantile(fdata,0.99);
                stnstrend(regloop,binc)=(stnsp99twlater-stnsp99twearlier)./15;
            end
        end
    end
    invalid=stnstrend==0;stnstrend(invalid)=NaN;
    save(strcat(dataloc,'trendcomparison.mat'),'stnstrend','-append');
    
    
    %c. Set up for MACA (ESI)
    clear macatrend;
    for model=1:18
        modelname=MODEL_NAME{model};
        temp=load(strcat(dataloc,'esiarrayhistfinal',modelname,'.mat'));esiarray_histFINAL=temp.esiarray_histFINAL;
        
        data19811990=esiarray_histFINAL(:,:,184*2-183:184*11);
        data19962005=esiarray_histFINAL(:,:,184*17-183:184*26);
        
        for eb=1:size(elevcutoffs,2)-1
            for regloop=1:7
                temp=macaelevFINAL>=elevcutoffs(eb) & macaelevFINAL<elevcutoffs(eb+1) & macaregions==regloop+1;
                macapointsbyregandelevbin(regloop,eb)=sum(sum(temp));
                temp=repmat(temp,[1 1 1840]);
                thisdata19811990=data19811990(temp);thisdata19811990=reshape(thisdata19811990,[size(thisdata19811990,1)*size(thisdata19811990,2)*size(thisdata19811990,3) 1]);
                thisdata19962005=data19962005(temp);thisdata19962005=reshape(thisdata19962005,[size(thisdata19962005,1)*size(thisdata19962005,2)*size(thisdata19962005,3) 1]);
                macatrend(model,regloop,eb)=(quantile(thisdata19962005,0.99)-quantile(thisdata19811990,0.99))./15;
                
            end
            if rem(eb,20)==0;fprintf('Elev bin is %d\n',eb);end
        end
        fprintf('Model is %d\n',model);
    end
    save(strcat(dataloc,'trendcomparison.mat'),'macatrend','-append');
    
    era5trendasesi=era5trend./3; %range of MSE within US is about 340-380=40, range of Tw and ESI is about 21-34=13
end


if histbiascalc==1
    if vsnarr==1
        %Compute and map historical MACA bias (vs NARR)
        alltdata_interp=NaN.*ones(10,31+30+31+31+30+31,277,349);allqdata=NaN.*ones(10,31+30+31+31+30+31,277,349);
        for yr=2008:2017
            yrc=1;
            for mon=5:10
                if mon<=9;mzero='0';else;mzero='';end
                thismondata=load(strcat('/Volumes/ExternalDriveD/NARR_3-hourly_data_mat/air2m/',num2str(yr),'/air2m_',num2str(yr),'_',mzero,num2str(mon),'.mat'));
                eval(['thismondata=thismondata.air2m_' num2str(yr) '_' mzero num2str(mon) ';']);thismont=thismondata{3};
                %Daily maxes
                clear thismontdaily;
                for i=8:8:size(thismont,3);thismontdaily(:,:,i/8)=max(thismont(:,:,i-7:i),[],3);end
                alltdata_interp(yr-2007,yrc:yrc+size(thismontdaily,3)-1,:,:)=permute(thismontdaily,[3 2 1]);

                thismondata=load(strcat('/Volumes/ExternalDriveD/NARR_3-hourly_data_mat/shum2m/',num2str(yr),'/shum2m_',num2str(yr),'_',mzero,num2str(mon),'.mat'));
                eval(['thismondata=thismondata.shum2m_' num2str(yr) '_' mzero num2str(mon) ';']);thismonq=thismondata{3};
                %Daily maxes
                clear thismonqdaily;
                for i=8:8:size(thismonq,3);thismonqdaily(:,:,i/8)=max(thismonq(:,:,i-7:i),[],3);end
                allqdata(yr-2007,yrc:yrc+size(thismonqdaily,3)-1,:,:)=permute(thismonqdaily,[3 2 1]);


                yrc=yrc+size(thismontdaily,3);

                if yr==2008 && mon==5
                    narrlats=thismondata{1};narrlons=thismondata{2};
                end
            end
        end
        alltdata_interp_3d=reshape(alltdata_interp,[size(alltdata_interp,1)*size(alltdata_interp,2) size(alltdata_interp,3) size(alltdata_interp,4)]);clear alltdata;
        allqdata_interp_3d=reshape(allqdata,[size(allqdata,1)*size(allqdata,2) size(allqdata,3) size(allqdata,4)]);clear allqdata;
        p99tbypointnarr=NaN.*ones(size(alltdata_interp_3d,2),size(alltdata_interp_3d,3));p99qbypointnarr=NaN.*ones(size(allqdata_interp_3d,2),size(allqdata_interp_3d,3));
        for i=1:size(alltdata_interp_3d,2)
            for j=1:size(alltdata_interp_3d,3)
                p99tbypointnarr(i,j)=quantile(alltdata_interp_3d(:,i,j),0.99);
                p99qbypointnarr(i,j)=quantile(allqdata_interp_3d(:,i,j),0.99);
            end
        end
        clear alltdata_3d;clear allqdata_3d;
        invalid=abs(p99tbypointnarr)>1000;p99tbypointnarr(invalid)=NaN;
        invalid=abs(p99qbypointnarr)>100;p99qbypointnarr(invalid)=NaN;

        p99tbypointnarr=flipud(p99tbypointnarr);p99qbypointnarr=flipud(p99qbypointnarr);narrlats=flipud(narrlats);narrlons=flipud(narrlons);
        p99tbypointnarrFINAL=griddata(double(narrlons),double(narrlats),p99tbypointnarr,macalonsFINAL,macalatsFINAL);
        p99qbypointnarrFINAL=griddata(double(narrlons),double(narrlats),p99qbypointnarr,macalonsFINAL,macalatsFINAL);
        macattocompare=squeeze(mean(p99tbypoint_hist-273.15,1,'omitnan'));
        macaqtocompare=squeeze(mean(p99qbypoint_hist,1,'omitnan'));
    end
    
    if vsmetdata==1
        %Compute and map historical MACA bias (vs gridMET)
        allqdata=NaN.*ones(26,31+30+31+31+30+31,1386,585);
        for yr=1980:2005   
            thisyrqdata=ncread(strcat('/Volumes/ExternalDriveC/gridMET_daily/sph_',num2str(yr),'.nc'),'specific_humidity');thisyrqdata=thisyrqdata(:,:,1:365);
            clear thisyrqdata_shrunken;clear thisyrqdata_new;
            for doy=121:304;thisyrqdata_new(:,:,doy)=squeeze(thisyrqdata(:,:,doy))';end;clear thisyrqdata;
            
            allqdata(yr-1979,:,:,:)=permute(thisyrqdata_new(:,:,121:304),[3 2 1]);clear thisyrqdata_new;
            disp(yr);
        end
        allqdata_3d=reshape(allqdata,[size(allqdata,1)*size(allqdata,2) size(allqdata,3) size(allqdata,4)]);clear allqdata;
        
        p99qbypointgridmet_interp=NaN.*ones(size(allqdata_interp_3d,2),size(allqdata_interp_3d,3));
        p99qbypointgridmet=NaN.*ones(size(allqdata_3d,2),size(allqdata_3d,3));
        for i=1:size(allqdata_interp_3d,2);for j=1:size(allqdata_interp_3d,3);p99qbypointgridmet_interp(i,j)=quantile(allqdata_interp_3d(:,i,j),0.99);end;end;clear allqdata_interp_3d;
        for i=1:size(allqdata_3d,2);for j=1:size(allqdata_3d,3);p99qbypointgridmet(i,j)=quantile(allqdata_3d(:,i,j),0.99);end;end;clear allqdata_3d;
        invalid=abs(p99qbypointgridmet_interp)>100;p99qbypointgridmet_interp(invalid)=NaN;
        invalid=abs(p99qbypointgridmet)>100;p99qbypointgridmet(invalid)=NaN;
        save(strcat(dataloc,'biasarrays.mat'),'p99qbypointgridmet','p99qbypointgridmet_interp','-append');
        
        
        alltdata_interp=NaN.*ones(26,31+30+31+31+30+31,692,292);
        alltdata=NaN.*ones(26,31+30+31+31+30+31,1386,585);
        for yr=1980:2005
            thisyrtdata=ncread(strcat('/Volumes/ExternalDriveC/gridMET_daily/tmmx_',num2str(yr),'.nc'),'air_temperature');thisyrtdata=thisyrtdata(:,:,1:365);
            clear thisyrtdata_shrunken;clear thisyrtdata_new;
            for doy=121:304;thisyrtdata_new(:,:,doy)=squeeze(thisyrtdata(:,:,doy))';end;clear thisyrtdata;

            alltdata(yr-1979,:,:,:)=permute(thisyrtdata_new(:,:,121:304),[3 2 1]);clear thisyrtdata_new;
            disp(yr);
        end
        alltdata_interp_3d=reshape(alltdata_interp,[size(alltdata_interp,1)*size(alltdata_interp,2) size(alltdata_interp,3) size(alltdata_interp,4)]);clear alltdata_interp;
        alltdata_3d=reshape(alltdata,[size(alltdata,1)*size(alltdata,2) size(alltdata,3) size(alltdata,4)]);clear alltdata;
        
        p99tbypointgridmet_interp=NaN.*ones(size(alltdata_interp_3d,2),size(alltdata_interp_3d,3));
        p99tbypointgridmet=NaN.*ones(size(alltdata_3d,2),size(alltdata_3d,3));
        for i=1:size(alltdata_interp_3d,2);for j=1:size(alltdata_interp_3d,3);p99tbypointgridmet_interp(i,j)=quantile(alltdata_interp_3d(:,i,j),0.99);end;end;clear alltdata_interp_3d;
        for i=1:size(alltdata_3d,2);for j=1:size(alltdata_3d,3);p99tbypointgridmet(i,j)=quantile(alltdata_3d(:,i,j),0.99);end;end;clear alltdata_3d;
        invalid=abs(p99tbypointgridmet_interp)>1000;p99tbypointgridmet_interp(invalid)=NaN;p99tbypointgridmet_interp=p99tbypointgridmet_interp-273.15;
        invalid=abs(p99tbypointgridmet)>1000;p99tbypointgridmet(invalid)=NaN;p99tbypointgridmet=p99tbypointgridmet-273.15;
        save(strcat(dataloc,'biasarrays.mat'),'p99tbypointgridmet','p99tbypointgridmet_interp','-append');
        
        macattocompare=squeeze(mean(p99tbypoint_hist-273.15,1,'omitnan'));
        macaqtocompare=squeeze(mean(p99qbypoint_hist,1,'omitnan'));
    end
end


if mastertroubleshooting==0
clear esiarray_histFINAL;clear twarray_histFINAL;clear tarray_histFINAL;clear qarray_histFINAL;clear rarray_histFINAL;clear rharray_histFINAL;
clear esiarray_rcp85FINAL;clear twarray_rcp85FINAL;clear tarray_rcp85FINAL;clear qarray_rcp85FINAL;clear rarray_rcp85FINAL;clear rharray_rcp85FINAL;
clear esiarray_histtFINAL;clear esiarray_histqFINAL;clear esiarray_histrFINAL;
end
