close all; clear all; clc;

M = 16;


% Bit Energy/Noise ratio.
EbNOdBArray = [4, 15];

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
    Ps(i) = 2* qfunc( sqrt(2*EsNO)*sin(pi/M) );
    
    %Converting symbol error rate to binary error rate
    Pb(i) = Ps(i) / log2(M);
    
    Pb_sim(i) = ChannelError(1);
    
    i = i + 1
end

figure(1)
semilogy(EbNOdBArray,Pb,"r-o");
hold on;
semilogy(EbNOdBArray,Pb_sim,"b-+");
grid on;
xlabel("E_b / N_O in dB")
ylabel("P_b")
legend("P_b Therotical","P_b Simulated")

