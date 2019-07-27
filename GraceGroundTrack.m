%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace Satellites Ground-FootPrint Tracker             %
% by: Alireza Ahmadi                                    %
% University of Bonn- MSc Geodetic Engineering          %
% Alireza.Ahmadi@uni-bonn.de                            %
% The MIT License                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TLE Parameteres with their character nubers         %
% 19-32     Element Set Epoch (UTC) (first line)        %
% 3-7       Satellite Catalog Number                    %
% 9-16      Orbit Inclination (degrees)                 %
% 18-25     Right Ascension of Ascending Node (degrees) %
% 27-33     Eccentricity (decimal point assumed)        %
% 35-42     Argument of Perigee (degrees)               %
% 44-51     Mean Anomaly (degrees)                      %
% 53-63     Mean Motion (revolutions/day)               %
% 64-68     Revolution Number at Epoch                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;
R2D = 57.2958;
D2R = 0.0174533;
%fprintf('************Constants*************\n')
R = 6378137;
a = 6378137;
b = 6356752.314;
j2 = 0.00108263;
GM = 3.986 * 10^14;
mu = 398600.4418; %  Standard gravitational parameter for the earth
% TLE file name 
% Open the TLE file and read TLE elements
inum = 1;

filename  = '/Users/alireza/Google Drive/Exercises/Satellite Godesy and Earth System-Exercise/1-4/Ex6/ex6_data/coast.dat';
%filename  = 'coast.dat';
fileID = fopen(filename);
formatSpec = '%f %f';
sizeA = [2 Inf];
M = fscanf(fileID,formatSpec,sizeA);
Coast = M.';
lat=Coast(:,1);
lon=Coast(:,2);
lon0 = min(lon) ; lon1 = max(lon) ;
lat0 = min(lat) ; lat1 = max(lat) ;
%plotting the coast files 
subplot(2,2,1)
plot(lat,lon,'k-');
hold on
subplot(2,2,2)
plot(lat,lon,'k-');
hold on
subplot(2,2,3)
plot(lat,lon,'k-');
hold on
subplot(2,2,4)
plot(lat,lon,'k-');
hold on
rev = 1;
cnt =0;

fname = '/Users/alireza/Google Drive/Exercises/Satellite Godesy and Earth System-Exercise/1-4/Ex6/ex6_data/TLE.txt';
%fname = 'TLE.txt';
fid = fopen(fname, 'rb');

%% 
    %Reading the lines
SatNum = fgetl(fid);
tline1 = fgetl(fid);
tline2 = fgetl(fid);
SatNum1 = fgetl(fid);
tline3 = fgetl(fid);
tline4 = fgetl(fid);
while cnt <1
    %% display lines
%     disp(SatNum);
%     disp(tline1);
%     disp(tline2);
%     disp(SatNum1);
%     disp(tline3);
%     disp(tline4);
    %% 
    %First Satellite Information
    %fprintf('************Satellite One TLE*************\n')
    epochY1 = str2num(tline1(19:20)) ;                               % Epoch year
    epochD1 = str2num(tline1(21:32)) ;                               % Epoch day
    epoch1 = epochY1 * 365.25 + epochD1 ;
    epochH1 = epoch1  * 24;
    epochM1 = epochH1 * 60;
    epochS1 = epochM1 * 60;

    inc1  = (str2num(tline2(10:16)));                                % Orbit Inclination (degree)
    raan1 = (str2num(tline2(18:25)));                                % Right Ascension of Ascending Node (degree)
    ecc1  = str2num(strcat('0.',tline2(28:33)))  ;                   % Eccentricity (-)
    w1    = (str2num(tline2(35:42)));                                % Argument of Perigee (degree)
    M1    = (str2num(tline2(44:51)));                                % Mean Anomaly (degree)
    n1    = str2num(tline2(53:63)) ;                                 % (mean velocity)Mean Motion (revolutions per day)
    rNo1  = str2num(tline2(64:68)) ;                                 % Revolution Number at Epoch 
    %fprintf('************Satellite Two TLE*************\n')
    
    %Second Satellite Information
    epochY2 = str2num(tline3(19:20))  ;                              % Epoch year
    epochD2 = str2num(tline3(21:32))  ;                              % Epoch day
    epoch2 = epochY2 * 365.25 + epochD2 ;
    epochH2 = epoch2  * 24;
    epochM2 = epochH2 * 60;
    epochS2 = epochM2 * 60;

    inc2  = (str2num(tline4(10:16)));                                % Orbit Inclination (degree)
    raan2 = (str2num(tline4(18:25)));                                % Right Ascension of Ascending Node (degree)
    ecc2  = str2num(strcat('0.',tline4(28:33)));                     % Eccentricity
    w2    = (str2num(tline4(35:42)));                                % Argument of Perigee (degree)
    M2    = (str2num(tline4(44:51)));                                % Mean Anomaly (degree)
    n2    = str2num(tline4(53:63)) ;                                 % (mean velocity)Mean Motion (revolutions per day)
    rNo2  = str2num(tline4(64:68)) ;                                 % Revolution Number at Epoch 
   
    cnt = cnt +1;
end
fclose(fid);
cnt_t =0;
% satellite One
%fprintf('************Satellite One Parameteres*************\n')
%finding the mean motion in Degree/sec
n_1 = n1*(2*pi/86400)*R2D;                                         
%semi-major axis of satellite orbit - meters
sma1 = nthroot((GM/(n_1*D2R)^2),3);
%Apoapsis and periapsis altitudes - meters                               
AltPerigee1 = (sma1*(1-ecc1))-R;
AltApogee1  = (sma1*(1+ecc1))-R;
% The transit time of perigee on satellite one                                
TranTimePre1=(epochD1+(((2*pi)-M1)/n_1)) ;                        
% derivative of RAAN (Omega) respect to time(seconds) -  degree/sec
DtOmega1 = -(3*(R^2)*n_1*j2*(cosd(inc1)))/(2*(1-(ecc1^2))^2 *(a^2));
% derivative of RAAN (Omega) respect to time(seconds) for one year - degree/sec
DtOmega1OneYear = DtOmega1 * 365.25*86400;
%date of epoch based on seconds
epochS1_29th = (epochY1 * 365.25 + 302)*86400;
%Main loop for calculating motion of satellite from 29th of 30th
for T= epochS1_29th:60:epochS1_29th + 86400
  %Mean anomaly at T - in degrees
  M1_t =  rem(M1 + (T-epoch1*86400) * sqrt(GM / sma1^3)*R2D, 360);
  #eccentric anomaly using mean anomaly at T - in degree
  EccAnomaly1 = M1_t + (ecc1 - (1/8)*(ecc1^3) - (1/192)*(ecc1^5) - (1/9216)*(ecc1^7))*sind(M1_t); 
  
  %True anomaly - in degree
  CTruA = (cosd(EccAnomaly1) - ecc1)/(1- (ecc1*cosd(EccAnomaly1)));
  STruA = (sqrt(1- ecc1^2)*sind(EccAnomaly1))/(1- (ecc1*cosd(EccAnomaly1)));
  %Instataneous distance to the earth center - in meter
  r1 = (sma1*(1-ecc1)^2/(1+(ecc1*CTruA)));
  %Correction of RAAN - in degree
  CorrOmega1 = raan1 + DtOmega1 * (T-epoch1*86400);
  #Position in orbital coordinates
  X1 = r1*[CTruA;STruA;0];
  #Rotation about Z - Argument of perigee  
  R_z_w = [cosd(w1), sind(w1),0
           -sind(w1),cosd(w1),0
           0,0,1];
  #Rotation about x - Inclination         
  R_x_inc = [1,0,0;
             0,cosd(inc1),sind(inc1)
             0,-sind(inc1),cosd(inc1)];
  #Rotation about Z - Corrected RAAN           
  R_z_Omega = [cosd(CorrOmega1), sind(CorrOmega1),0
               -sind(CorrOmega1),cosd(CorrOmega1),0
               0,0,1];
  #Applyng the Rotations on Orbital Position vector
  Roatation = inv(R_z_w*(R_x_inc*(R_z_Omega)));
  Product1 = Roatation*X1;
  
  #Correction of Earth Rotation 
  Date = 9*365.25*86400 ;
  alpha= ((T-Date)* 7.29211585531*10^(-5) + 1.75887890941);

  %calculte Coordintes X,Y,Z Rotation along Z axis respect to Earth rotation
  Rot_alpha = [cos(alpha), sin(alpha),0;
               -sin(alpha),cos(alpha),0;
               0,0,1];
  Product2= Rot_alpha * Product1;

  %%Convert to WGS84
  sq_ecc = (a^2-b^2)/(a^2); 
  p = sqrt( Product2(1,1)^2 + Product2(2,1)^2);
  long_ellip = atan2d(Product2(2,1) , Product2(1,1));
  GR_Lat_Initial  = atand((Product2(3,1) / p)*(1 - sq_ecc^2));
  
  GR_H_Initial = 1;
  GR_N_Initial = a/sqrt(1-(ecc1^2)* sind(GR_Lat_Initial).^2);
  lat_ellip = 1;
  
  for count=1:7
  GR_N = a/sqrt(1-(ecc1^2) * sind(lat_ellip).^2);
  GR_H = (p/cosd(GR_Lat_Initial))-GR_N_Initial;
  lat_ellip = atan2d((Product2(3,1)*(GR_N_Initial+GR_H_Initial)),p*((1-(ecc1^2))*GR_N_Initial+GR_H_Initial));

  GR_Lat_Initial = lat_ellip;
  GR_H_Initial = GR_H;
  GR_N_Initial = GR_N;
  end
  
  hold on
  if T <= epochS1_29th + n_1 * 2 * 86400 - 550
    if T  == epochS1_29th
      subplot(2,2,1);
      plot(long_ellip,lat_ellip,'b--+','MarkerSize',8);
      long_ellip
      lat_ellip
    elseif T == epochS1_29th + 86400 
      subplot(2,2,1)
      plot(long_ellip,lat_ellip,'r--d','MarkerSize', 8);
    else
      subplot(2,2,1);
      plot(long_ellip,lat_ellip,'r--.','MarkerSize', 3);
      title('Ground Track of Satellite One on first 2 rev');
    end
  end
  
  hold on
  if T == epochS1_29th 
    subplot(2,2,3)
    plot(long_ellip,lat_ellip,'r--o','MarkerSize',8);
    long_ellip
    lat_ellip
  elseif T == epochS1_29th + 86400 
    subplot(2,2,3)
    plot(long_ellip,lat_ellip,'r--d','MarkerSize', 8);
    long_ellip
    lat_ellip
  else
    subplot(2,2,3) 
    plot(long_ellip,lat_ellip,'b--+','MarkerSize', 3);
    title('Ground Track of Satellite One for One Day' );
  end
  Log = [T,lat_ellip,long_ellip];
  dlmwrite('Sat1Log.txt',Log,'-append');
end

% satellite Two
%fprintf('************Satellite Two Parameteres*************\n')
n_2 = n2*(2*pi/86400)*R2D;
sma2 = nthroot((GM/(n_2*D2R)^2),3);
AltPerigee2 = (sma2*(1-ecc2))-R;
AltApogee2  = (sma2*(1+ecc2))-R;
                                
TranTimePre1=(epochD2+(((2*pi)-M2*D2R)/n_2)) ;                         

DtOmega2 = -(3*(R^2)*n_2*j2*(cosd(inc2)))/(2*(1-(ecc2^2))^2 *(a^2));

epochS2_29th = (epochY1* 365.25 + 302)*86400;
for T= epochS2_29th:60:epochS2_29th + 86400
  M2_t =  rem(M2 + (T-epoch2*86400) * sqrt(GM / sma2^3)*R2D, 360);

  EccAnomaly2 = M2_t + (ecc2 - (1/8)*(ecc2^3) - (1/192)*(ecc2^5) - (1/9216)*(ecc2^7))*sind(M2_t); 
  
  CTruA = (cosd(EccAnomaly2) - ecc2)/(1- (ecc2*cosd(EccAnomaly2)));
  STruA = (sqrt(1- ecc2^2)*sind(EccAnomaly2))/(1- (ecc2*cosd(EccAnomaly2)));
  
  r2 = (sma2*(1-ecc2)^2/(1+(ecc2*CTruA)));
  
  CorrOmega2 = raan2 + DtOmega2 * (T-epoch2*86400);
  
  X2 = r2*[CTruA;STruA;0];
       
  R_z_w = [cosd(w2), sind(w2),0
           -sind(w2),cosd(w2),0
           0,0,1];
           
  R_x_inc = [1,0,0;
             0,cosd(inc2),sind(inc2)
             0,-sind(inc2),cosd(inc2)];
             
  R_z_Omega = [cosd(CorrOmega2), sind(CorrOmega2),0
               -sind(CorrOmega2),cosd(CorrOmega2),0
               0,0,1];

  Roatation = inv(R_z_w*(R_x_inc*(R_z_Omega)));
  
  Product1 = Roatation*X2;
  
  Date = (9 * 365.25)*86400 ;
  alpha= ((T-Date)* 7.29211585531*10^(-5) + 1.75887890941);

  %calculte coordintes X,Y,Z Rotation along Z axis
   Rot_alpha = [cos(alpha), sin(alpha),0;
               -sin(alpha),cos(alpha),0;
               0,0,1];
  Product2= Rot_alpha * Product1;

  %%Convert to WGS84
  sq_ecc = (a^2-b^2)/(a^2); 
  p = sqrt( Product2(1,1)^2 + Product2(2,1)^2);
  long_ellip = atan2d(Product2(2,1) , Product2(1,1));
  GR_Lat_Initial  = atand((Product2(3,1) / p)*(1 - sq_ecc^2));

  GR_H_Initial = 1;
  GR_N_Initial = a/sqrt(1-(ecc2^2)* sind(GR_Lat_Initial).^2);
  lat_ellip = 1;

  for count=1:7
  GR_N = a/sqrt(1-(ecc2^2) * sind(lat_ellip).^2);
  GR_H = (p/cosd(GR_Lat_Initial))-GR_N_Initial;
  lat_ellip = atan2d((Product2(3,1)*(GR_N_Initial+GR_H_Initial)),p*((1-(ecc2^2))*GR_N_Initial+GR_H_Initial));

  GR_Lat_Initial = lat_ellip;
  GR_H_Initial = GR_H;
  GR_N_Initial = GR_N;
  end

  hold on
  if T <= epochS2_29th + n_2 * 2 * 86400 -550
    if T == epochS2_29th 
    subplot(2,2,2)
    plot(long_ellip,lat_ellip,'b--+','MarkerSize',8);
    long_ellip
    lat_ellip
  elseif T == epochS1_29th + 86400 
    subplot(2,2,1)
    plot(long_ellip,lat_ellip,'r--d','MarkerSize', 8);
  else
    subplot(2,2,2)
    plot(long_ellip,lat_ellip,'r--.','MarkerSize',3);
    title('Ground Track of Satellite Two on first 2 rev');
    end
  end
  
  hold on
  if T == epochS2_29th 
    subplot(2,2,4)
    plot(long_ellip,lat_ellip,'r--o','MarkerSize',8);
    long_ellip
    lat_ellip
  elseif T == epochS2_29th + 86400 
    subplot(2,2,4)
    plot(long_ellip,lat_ellip,'r--d','MarkerSize',8);
    long_ellip
    lat_ellip
  else
    subplot(2,2,4) 
    plot(long_ellip,lat_ellip,'b--+','MarkerSize',3);
    title('Ground Track of Satellite Two for One Day' );
  end
  Log = [T,lat_ellip,long_ellip];
  dlmwrite('Sat2Log.txt',Log,'-append');
end
