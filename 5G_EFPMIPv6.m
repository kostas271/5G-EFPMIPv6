%hop distance between mag and lma
Hmag_lma=2:2:60;
%hop distance between rsu/eNodeB and lma
HenodeB_mag=1;
%hop distance between mags
Hmag_mag=1;
%nubmer of location updates
lambda=10;
%length of  handover indication message 
L_hind=52*8;
%length of  handover initiation message 
L_hi=52*8;
%length of  handover acknowledgement message 
L_hack=52*8;
%length of  handover complete message 
L_hoc=52*8;
%length of  pbu message 
L_pbu=76*8;
%length of  pba message s
L_pba=76*8;
%length of  data packet 
L_data=1500*8;
%length of tunnel header
L_hd=40*8; 
%probabilty of wireless link failure
pwf=0.1:0.05:1;
%bandwidth of the wired connection
Bl=10^9;
%bandwidth of the wireless connection
Bw=54*10^6;

%delay of the handover indication message over wired connection
Tl_hind=L_hind/Bl;
%delay of the handover indication message over wireless connection
Tw_hind=(1+1*pwf)/(1-pwf)*L_hind/Bw;
%delay of the handover initiation message
Tl_hi=(1+1*pwf)/(1-pwf)*L_hi/Bl;
%delay of the handover acknowledgement message
Tl_hack=(1+1*pwf)/(1-pwf)*L_hack/Bl;
%delay of the handover complete message
Tl_hoc=(1+1*pwf)/(1-pwf)*L_hoc/Bl;
%delay of the pbu message
Tl_pbu=(1+1*pwf)/(1-pwf)*L_pbu/Bl;
%delay of the pba message
Tl_pba=(1+1*pwf)/(1-pwf)*L_pba/Bl;
%delay of the data packet over wired connection
Tl_data=L_data/Bl;
%delay of the data packet over wireless connection
Tw_data=(1+1*pwf)/(1-pwf)*L_data/Bw;

%%%%%%%%Handover Latency%%%%%%%%

%tf is the period from when the MN sends the handover indication to
%the new access point untill it decides to reconnect to the previous access point.

Tf=10*10^(-3);

%probabilty factor for a false predictive handover to occur
pf=0.5;

%probabilty of predictive scenario to activate
Pp=0.3;

%%%%%%%%predictive scenario%%%%%%%%

%Tpre for  predictive scenario
Tpre_p=Tw_hind + Tl_hind*HenodeB_mag + 2*Hmag_lma*Tl_hi + 2*Hmag_lma* Tl_hack;

%Tl2 for  predictive scenario
Tl2_p=59*10^(-3);

%Tpost for  predictive scenario
Tpost_p = Tw_data + Tl_data*HenodeB_mag + Tl_data*Hmag_lma +Tl_data*Hmag_mag 
 Hmag_lma* Tl_pbu+ Hmag_lma* Tl_pba;

%handover latency for a sucessful  predictive handover
Tho_ps = Tpre_p + Tl2_p + Tpost_p;

%handover latency for a false predictive handover
Tho_pf=Tf+ Tw_hind + Tl_hind*HenodeB_mag + Tw_data + Tl_data*HenodeB_mag 
+ Tl_data*Hmag_lma ;

%total handover latency for  predictive scenario
Tho_p=(1-pf)*Tho_ps + pf*Tho_pf;

%%%%%%%%enhanced predictive scenario%%%%%%%%

%Tpre for enhanced predictive scenario
Tpre_ep=Tw_hind + Tl_hind*HenodeB_mag + 2*Hmag_lma*Tl_hi+ 2*Hmag_lma* Tl_hack
+ Hmag_lma* Tl_pbu+ Hmag_lma* Tl_pba;

%Tl2 for enhanced predictive scenario
Tl2_ep= Tpre_p + Tl2_p - Tpre_ep;

%Tpost for enhanced predictive scenario
Tpost_ep = Tw_data + Tl_data*HenodeB_mag;

%handover latency for a sucessful enhanced predictive handover
Tho_eps = Tpre_ep + Tl2_ep + Tpost_ep;

%handover latency for a enhanced false predictive handover
Tho_epf=Tf+ Tw_hind + Tl_hind*HenodeB_mag + Tw_data + Tl_data*HenodeB_mag
+ Tl_data*Hmag_lma ;

%total handover latency for enhanced predictive scenario
Tho_ep=(1-pf)*Tho_eps + pf*Tho_epf;

%%%%%%%%reactive scenario%%%%%%%%

%Tl2 for  reactive scenario
Tl2_r=59*10^(-3);

%Tpost for  reactive scenario
Tpost_r= 2*Tl_hi*Hmag_lma + 2*Tl_hack*Hmag_lma + Tl_pbu*Hmag_lma + Tl_pba*Hmag_lma
+ Tw_data + Tl_data*HenodeB_mag + Tl_data*Hmag_mag + Tl_data*Hmag_lma;

%total handover latency for  reactive handover
Tho_r=Tl2_r + Tpost_r;

%Total handover latency for the scheme
Tho_=Pp*Tho_p + (1-Pp)*Tho_r;

%%%%%%%%enhanced reactive scenario%%%%%%%%

%Tl2 for enhanced reactive scenario
Tl2_er= Tl2_r;

%Tpost for enhanced reactive scenario
Tpost_er= 2*Tl_hi*Hmag_lma + 2*Tl_hack*Hmag_lma + Tl_pbu*Hmag_lma 
+Tl_pba*Hmag_lma + Tw_data + Tl_data*HenodeB_mag + Tl_data*Hmag_lma;

%total handover latency for enhanced reactive handover
Tho_er=Tl2_er + Tpost_er;

%Total handover latency for the enhanced scheme
Tho_e=Pp*Tho_ep + (1-Pp)*Tho_er;

%%%%%%%%handover latency figure%%%%%%%%

figure
plot( Hmag_lma,Tho_*1000,'-ro', Hmag_lma,Tho_e*1000,'-.b')
legend('FPMIPv6','EFPMIPv6')
xlabel('Hmag-lma')
ylabel('Handover Latency (ms)')

%%%%%%%%Signaling Cost%%%%%%%%

%%%%%%%%FPMIPv6%%%%%%%%

%transimission cost between MAGs in predictive scenario 
SPmag_mag= 2*Hmag_mag*L_hi + 2*Hmag_mag*L_hack;

%transimission cost between MAG and LMA in predictive scenario 
SPmag_lma=Hmag_lma*L_pbu + Hmag_lma*L_pba;

%transimission cost between MAGs in reactive scenario 
SRmag_mag = 2*Hmag_mag*L_hi + 2*Hmag_mag*L_hack;

%transimission cost between MAG and LMA in reactive scenario 
SRmag_lma = Hmag_lma*L_pbu + Hmag_lma*L_pba;

%signaling cost for the  predictive scenario
Csig_p=lambda*(SPmag_mag + SPmag_lma);

%signaling cost for the  reactive scenario
Csig_r=lambda*(SRmag_mag + SRmag_lma);

%Total signalling cost forenchanced scheme
Csig_=Pp*Csig_p + (1-Pp)*Csig_r;

%%%%%%%%enhanced FMIPv6%%%%%%%%

%transimission cost between MAGs in predictive scenario 
SEPmag_mag= 2*Hmag_mag*L_hi + 2*Hmag_mag*L_hack;

%transimission cost between MAG and LMA in predictive scenario 
SEPmag_lma=2*(Hmag_lma*L_pbu + Hmag_lma*L_pba);

%transimission cost between MAGs in reactive scenario 
SERmag_mag = 2*Hmag_mag*L_hi + 2*Hmag_mag*L_hack;

%transimission cost between MAG and LMA in reactive scenario 
SERmag_lma = Hmag_lma*L_pbu + Hmag_lma*L_pba;

%signaling cost for the enhanced predictive scenario
Csig_ep=lambda*(SEPmag_mag + SEPmag_lma);

%signaling cost for the enhanced reactive scenario
Csig_er=lambda*(SERmag_mag + SERmag_lma);

%Total signalling cost for the the enhanced scheme
Csig_e=Pp*Csig_ep + (1-Pp)*Csig_er;

%%%%%%%%signalling cost figure%%%%%%%%
figure;
plot( Hmag_lma,Csig_,'-ro', Hmag_lma,Csig_e,'-.b');
legend('FPMIPv6','EFPMIPv6')
xlabel('Hmag-lma')
ylabel('Signalling Cost(Bytes)')

%%%%%%%%Tunneling Cost%%%%%%%%

%number of packets transmitted due to packet loss
n_retr=2;

%packet arrival rate at overlapping cells
lambdap=50;

%transimission cost from LMA to MAG
Pmag_lma= Hmag_lma*L_hd;

%transimission cost from MAG to MAG
Pmag_mag= Hmag_lma*(L_hd+L_hd);

%%%%%%%%FPMIPv6%%%%%%%%
%duration on tunneling between 2 MAG
Ttnl_p=Tl2_p + Hmag_lma* Tl_pbu + Hmag_lma*Tl_pba;

Ttnl_r=Hmag_lma* Tl_pbu + Hmag_lma*Tl_pba;

%period when packets are lost in reactive scenario
Tloss_r= Tl2_r + 2*Hmag_lma*Tl_hi;

%tunneling cost of predictive scenario
Ctun_p=lambda*lambdap*(Pmag_lma.*Tho_p + Pmag_mag.*Ttnl_p);

%tunneling cost of reactive scenario
Ctun_r=lambda*lambdap*(n_retr*Pmag_lma.*Tloss_r + Pmag_lma.*(Tho_r-Tloss_r)) 
+ Pmag_mag.*Ttnl_r; 

%Total tunneling cost for the scheme
Ctun_=Pp*Ctun_p + (1-Pp)*Ctun_r;

%%%%%%%%Enhanced FPMIPv6%%%%%%%%

%duaration on tunneling between 2 MAG
Ttnl_ep=Tl2_ep + Hmag_lma* Tl_pbu + Hmag_lma*Tl_pba;

%period when packets are lost in reactive scenario
Tloss_er= Tl2_er + 2*Hmag_lma*Tl_hi

%tunneling cost of predictive scenario
Ctun_ep=lambda*lambdap*(Pmag_lma.*(2*Hmag_lma*Tl_hi+2*Hmag_lma*Tl_hack+Hmag_lma*Tl_pbu+Hmag_lma*Tl_pba)
+ Pmag_mag.*Ttnl_ep);

%tunneling cost of reactive scenario
Ctun_er=lambda*lambdap*(n_retr*Pmag_lma.*Tloss_er + Pmag_lma.*(Tho_er-Tloss_er)); 

%Total tunneling cost for the the enhanced scheme
Ctun_e=Pp*Ctun_ep + (1-Pp)*Ctun_er;

%%%%%%%%tunneling cost figure%%%%%%%%

figure;
plot( Hmag_lma,Ctun_,'-ro', Hmag_lma,Ctun_e,'-.b');
legend('FPMIPv6','EFPMIPv6')
xlabel('Hmag-lma')
ylabel('Tunneling Cost(Bytes)')

%%%%%%%%Total Cost%%%%%%%%

Ctot_=Csig_+Ctun_;
Ctot_e=Csig_e+Ctun_e;

%%%%%%%%Total cost figure%%%%%%%%

figure;
plot( Hmag_lma,Ctot_,'-ro', Hmag_lma,Ctot_e,'-.b');
legend('FPMIPv6','EFPMIPv6')
xlabel('Hmag-lma')
ylabel('Tunneling Cost(Bytes)')

%%%%%%%%Packet Loss%%%%%%%%

%size of buffer in PMAG
Bp=500*8*1000;

%size of buffer in NMAG
Bn=500*8*1000;

%size of buffer in LMA
Bl=500*8*1000;

%%%%%%%%FPMIPv6%%%%%%%%

%packet loss of enchanced sucessful predictive scenario
Closs_ps=max(lambdap*L_data*(2*Hmag_lma*Tl_hi + 2*Hmag_lma* Tl_hack)-Bp ,0)
+max(lambdap*L_data*(2*Hmag_lma*Tl_hi+2*Hmag_lma*Tl_hack+Tl2_p)-Bn, 0); 

%false predictive case where the HI message to reconnect to the previoud MAG is
%sent before the HACK

if(Tf + Tw_hind < Tw_hind + Tl_hi + Tl_hack)
    Closs_pf = max(lambdap*L_data*(Tf + Tw_hind) -Bp , 0);
else
    Closs_pf = lambdap*L_data*(Tf + Tw_hind);
end
    
%total packet loss for predictive scenario
Closs_p = (1-pf)*Closs_ps + pf*Closs_pf;

%packet loss of reactive scenario
Closs_r = lambdap*L_data*(Tl2_r + 2*Hmag_lma*Tl_hi) +
max(lambdap*L_data*(2*Hmag_lma*Tl_hack) - Bp, 0);

%total packet loss for FPMIPv6 scheme
Closs_= Pp*Closs_p + (1-Pp)*Closs_r;

%%%%%%%%Enhanced FPMIPv6%%%%%%%%

%packet loss of enchanced sucessful predictive scenario
Closs_eps = max(lambdap*L_data*(2*Hmag_lma*Tl_hi + 2*Hmag_lma* Tl_hack) - Bp , 0) 
+max(lambdap*L_data*(2*Hmag_lma*Tl_hi + 2*Hmag_lma* Tl_hack 
+ Hmag_lma* Tl_pbu+ Hmag_lma* Tl_pba + Tl2_ep) - Bn, 0); 

%fasle predictive case where the HI message to reconnect to the previoud MAG is 
%sent before the HACK

if(Tf + Tw_hind < Tw_hind + Tl_hi + Tl_hack)
   
    Closs_epf = max(lambdap*L_data*(Tf + Tw_hind) -Bp , 0);
else
    Closs_epf = max(lambdap*L_data*(2*Hmag_lma*Tl_hi + 2*Hmag_lma* Tl_hack) - Bp, 0) 
    + max(lambdap*L_data*(Tf + Tw_hind) - Bn, 0);
end    

%total packet loss for predictive scenario
Closs_ep = (1-pf)*Closs_eps + pf*Closs_epf;

%packet loss of enhanced reactive scenario
Closs_er = lambdap*L_data*(Tl2_er + 2*Hmag_lma*Tl_hi)
+max(lambdap*L_data*(2*Hmag_lma*Tl_hack+Hmag_lma*Tl_pbu
+Hmag_lma*Tl_pba+2*Hmag_lma*Tl_hoc)-Bp, 0);

%total packet loss for enhanced scheme
Closs_e= Pp*Closs_ep + (1-Pp)*Closs_er;

%%%%%%%%Packet loss figure%%%%%%%%

plot(Hmag_lma,Closs_,'-ro', Hmag_lma,Closs_e ,'-.b');
legend('FPMIPv6','EFPMIPv6')
xlabel('Hmag-lma')
ylabel('Packet Loss (Bytes)')