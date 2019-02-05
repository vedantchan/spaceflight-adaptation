% Recurrence plots for HR.

N=1000;
M=5;
J=1;
L=20;
thr=0.05;


x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,1)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,2)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,3)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,4)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,5)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,6)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,7)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,8)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,9)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,10)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,11)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,12)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,13)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,14)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,15)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,16)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,17)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,18)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,19)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,20)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,21)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,22)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,23)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,24)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,25)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,26)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,27)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,28)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,29)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_rec.csv');
subplot(6,5,30)
A=makea1(x,N,M,J,L);
RM=RecMat(A);
RecPlt(RM,thr);
[RR,DET,ENTR,LL] = Recu_RQA_mjs(RM,thr);
title([num2str(RR,3),' / ',num2str(DET,3),' / ',num2str(ENTR,3),' / ',num2str(LL,3)],'FontSize',8);

