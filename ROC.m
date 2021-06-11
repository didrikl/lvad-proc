F.prePT_PCI3 = double(string(F.balloonDiam))>7;
F.prePT_PCI2 = double(string(F.balloonDiam))>=6;
F.prePT_PCI1 = double(string(F.balloonDiam))>=4.31;
F.prePT_PCI4 = double(string(F.balloonDiam))>=9;
F2500 = F(F.pumpSpeed=='2500',:);
[X,Y,T,AUC,OPTROCPT] = perfcurve(F2500.prePT_PCI2,F2500.accA_y_nf_pow,1)
plot(X,Y)
[X,Y,T,AUC,OPTROCPT] = perfcurve(F2500.prePT_PCI1,F2500.accA_y_nf_pow,1)
hold on
plot(X,Y)
[X,Y,T,AUC,OPTROCPT] = perfcurve(F2500.prePT_PCI3,F2500.accA_y_nf_pow,1)
plot(X,Y)
[X,Y,T,AUC,OPTROCPT] = perfcurve(F2500.prePT_PCI4,F2500.accA_y_nf_pow,1)
plot(X,Y)
[X,Y,T,AUC,OPTROCPT] = perfcurve(F2500.prePT_PCI2,F2500.accA_y_nf_pow,1,"NBoot",1000)
xlabel('False positive rate')
ylabel('True positive rate')
