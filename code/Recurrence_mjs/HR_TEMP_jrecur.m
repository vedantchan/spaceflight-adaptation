% Joint-Recurrence plots for HR and TEMP.

N=1000;
M=5;
J=1;
L=20;
thr=0.25;


x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,1)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,2)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,3)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,4)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,5)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,6)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,7)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,8)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,9)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/B1_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,10)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,11)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,12)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/AA_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,13)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,14)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/EM_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,15)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,16)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,17)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,18)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,19)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/K3_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,20)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,21)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,22)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,23)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,24)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/KC_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,25)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_UP1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/TEMP_smoothedandresampled.csv_E4_UP1.csv');
subplot(6,5,26)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_UP2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/TEMP_smoothedandresampled.csv_E4_UP2.csv');
subplot(6,5,27)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_P1.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/TEMP_smoothedandresampled.csv_E4_P1.csv');
subplot(6,5,28)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_P2.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/TEMP_smoothedandresampled.csv_E4_P2.csv');
subplot(6,5,29)
PLOTj(x,y,N,M,J,L,thr)

x=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/HR_smoothedandresampled.csv_E4_Rec.csv');
y=load('/Users/SYT/Documents/Space_Corr_eval/MC2_split/TEMP_smoothedandresampled.csv_E4_Rec.csv');
subplot(6,5,30)
PLOTj(x,y,N,M,J,L,thr)




function PLOTj(x,y,N,M,J,L,thr)
A1=makea1(x,N,M,J,L);
RM1=RecMat(A1);
RP1=RecPlt(RM1,thr);
A2=makea1(y,N,M,J,L);
RM2=RecMat(A2);
RP2=RecPlt(RM2,thr);
jrec(RP1,RP2);
return
end
