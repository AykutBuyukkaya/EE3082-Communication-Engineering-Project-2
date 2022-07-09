close all; clear all; clc;


%NOTE: This script may take long time to complete!


M_Array = [4,16];

% Bit Energy/Noise ratio.
EbNOdBArray = 1:2:15;

j = 1


while j <= length(M_Array)
   
M = M_Array(j)
    
%Grouping bits as symbols.
K = log2(M);

%Signal rate for our random signal generator. I choose 48 kbps as generator
%signal rate.
Nbps = 48e3;

%Symbol Rate
Rs = 1e6;

%Symbol period
Ts = 1/Rs;

%Bit period
Tb = Ts/K;

%Bit Rate
Rb = 1/Tb;

%Simulation Period (s)
Tsim = 10;

i = 1;

%QAM modulations

while i <= length(EbNOdBArray)
    
    EbNOdB = EbNOdBArray(i);
    sim("q2_QAM_simulink_model",Tsim);
    
    %Converting bit enery ratio to symbol energy ratio
    EbNO = 10 ^ (EbNOdB / 10);
    
    m = sqrt(M);
    
    %Symbol Error rate calculation
    Ps(i) = (2*(m-1)/m) * qfunc( sqrt((6*log2(m)/ (m^2 - 1)) * EbNO));
    
    %Converting symbol error rate to binary error rate
    Pb_qam(j,i) = Ps(i) / log2(m);
    
    Pb_qam_sim(j,i) = ChannelError(1);
    
    
    i = i + 1
end
    

    j = j + 1
    
end

M_Array = [2,16];

j = 1


%PAM Modulations

while j <= length(M_Array)
   
M = M_Array(j)
    
%Grouping bits as symbols.
K = log2(M);

%Signal rate for our random signal generator. I choose 48 kbps as generator
%signal rate.
Nbps = 48e3;

%Symbol Rate
Rs = 1e6;

%Symbol period
Ts = 1/Rs;

%Bit period
Tb = Ts/K;

%Bit Rate
Rb = 1/Tb;

%Simulation Period (s)
Tsim = 10;

i = 1;

while i <= length(EbNOdBArray)
    
    EbNOdB = EbNOdBArray(i);
    sim("q2_PAM_simulink_model",Tsim);
    
    %Converting bit enery ratio to symbol energy ratio
    EbNO = 10 ^ (EbNOdB / 10);       
    
    %Symbol Error rate calculation
    Ps(i) = (2*(M-1)/M) * qfunc( sqrt((6*log2(M)/ (M^2 - 1)) * EbNO));
    
    %Converting symbol error rate to binary error rate
    Pb_pam(j,i) = Ps(i) / log2(M);
    
    Pb_pam_sim(j,i) = ChannelError(1);
    
    
    i = i + 1
end
    
    fprintf("%d-ary PAM tranmission. Transmission BW = %d, Data Rate %d",M ,Rs, Rb);


    j = j + 1
    
end

figure(1)
semilogy(EbNOdBArray,Pb_qam(1,:),"r-o",'LineWidth',2);
hold on;
semilogy(EbNOdBArray,Pb_qam_sim(1,:),"b--+",'LineWidth',2);
grid on;
semilogy(EbNOdBArray,Pb_qam(2,:),"g-o",'LineWidth',2);
semilogy(EbNOdBArray,Pb_qam_sim(2,:),"k--+",'LineWidth',2);

semilogy(EbNOdBArray,Pb_pam(1,:),"c-o",'LineWidth',2);
semilogy(EbNOdBArray,Pb_pam_sim(1,:),"m--+",'LineWidth',2);

semilogy(EbNOdBArray,Pb_pam(2,:),"g-*",'LineWidth',2);
semilogy(EbNOdBArray,Pb_pam_sim(2,:),"b--+",'LineWidth',2);

xlabel("Eb/No dB")
ylabel("Pb")
legend({"QAM P_b Theoritical (4-ary)", "QAM P_b Simulated (4-ary)", " QAM P_b Theoritical (16-ary)", "QAM P_b Simulated (16-ary)", " PAM P_b Theoritical (binary)", "PAM P_b Simulated (binary)", " PAM P_b Theoritical (16-ary)", "PAM P_b Simulated (16-ary)"},'Location','southwest','NumColumns',4)




