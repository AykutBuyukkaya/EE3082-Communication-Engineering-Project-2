close all; clear all; clc;


%NOTE: This script may take long time to complete!


M_Array = [4, 8, 16];

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

while i <= length(EbNOdBArray)
    
    EbNOdB = EbNOdBArray(i);
    sim("q1_simulink_model",Tsim);
    
    %Converting bit enery ratio to symbol energy ratio
    EsNO = K* (10^(EbNOdB/10));
    
    %Symbol Error rate calculation
    Ps(i) = 2 * qfunc( sqrt(2*EsNO)*sin(pi/M));
    
    %Converting symbol error rate to binary error rate
    Pb(j,i) = Ps(i) / log2(M);
    
    Pb_sim(j,i) = ChannelError(1);
    
    
    i = i + 1
end
    

    j = j + 1
    
end

figure(1)
semilogy(EbNOdBArray,Pb(1,:),"r-o",'LineWidth',2);
hold on;
semilogy(EbNOdBArray,Pb_sim(1,:),"b-+",'LineWidth',2);
grid on;
semilogy(EbNOdBArray,Pb(2,:),"g--o",'LineWidth',2);
semilogy(EbNOdBArray,Pb_sim(2,:),"k--+",'LineWidth',2);
semilogy(EbNOdBArray,Pb(3,:),"c:o",'LineWidth',2);
semilogy(EbNOdBArray,Pb_sim(3,:),"m:+",'LineWidth',2);
xlabel("Eb/No dB")
ylabel("Pb")
legend({"P_b Theoritical (4-ary)", "P_b Simulated (4-ary)", "P_b Theoritical (8-ary)", "P_b Simulated (8-ary)", "P_b Theoritical (16-ary)", "P_b Simulated (16-ary)"},'Location','southwest','NumColumns',3)




