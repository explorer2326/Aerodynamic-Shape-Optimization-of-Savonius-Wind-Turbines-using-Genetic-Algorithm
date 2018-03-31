%RA = ROTOR ANGLE; FT = DRIVING FORCE; LARM = LEVER ARM
RA = [];FTA = []; LarmA = []; 
for casenumber = 0:90
    angle = 2*casenumber;
    RA = [RA angle];
    format long
    %Returning
    myfilenamef = sprintf('Facearea-Optwithoutdeflector%d',angle);
    xA = dlmread (myfilenamef,',',[1 8 868 8]);
    yA = dlmread (myfilenamef,',',[1 9 868 9]);
    tpA = dlmread (myfilenamef,',',[1 6 868 6]);
    faxA = dlmread (myfilenamef,',',[1 10 868 10]);
    fayA = dlmread (myfilenamef,',',[1 11 868 11]);
    fxA = tpA.*faxA;
    fyA = tpA.*fayA;
    mA = -fxA.*yA+fyA.*xA;
    FXA = sum(fxA);
    FYA = sum(fyA);
    MA = sum(mA);
    FtangentA = FXA*sin(angle/180*pi)-FYA*cos(angle/180*pi);
    LA = 1000*abs(MA/FtangentA);
    FTA = [FTA FtangentA/6.534644];
    LarmA = [LarmA LA];
end
hold on;
plot(RA,LarmA,'r:');

RA = [];FTR = []; LarmR = []; 
for casenumber = 0:90
    angle = 2*casenumber;
    RA = [RA angle];
    format long
    %Advancing
    myfilenamef = sprintf('Facearea-Optwithoutdeflector%d',angle);
    xR = dlmread (myfilenamef,',',[869 8 1736 8]);
    yR = dlmread (myfilenamef,',',[869 9 1736 9]);
    tpR = dlmread (myfilenamef,',',[869 6 1736 6]);
    faxR = dlmread (myfilenamef,',',[869 10 1736 10]);
    fayR = dlmread (myfilenamef,',',[869 11 1736 11]);
    fxR = tpR.*faxR;
    fyR = tpR.*fayR;
    mR = -fxR.*yR+fyR.*xR;
    FXR = sum(fxR);
    FYR = sum(fyR);
    MR = sum(mR);
    FtangentR = FXR*sin(angle/180*pi)-FYR*cos(angle/180*pi);
    LR = 1000*abs(MR/FtangentR);
    FTR = [FTR FtangentR/6.534644];
    LarmR = [LarmR LR];
end
hold on;
plot(RA,LarmR,'g:');
axis([0 180 20 80]);