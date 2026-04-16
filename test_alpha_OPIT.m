clear;clc; close all
addpath(genpath('state-of-the-arts\'))

%%
n_exp = 3;
n = 100;
r = 10;
T = 2000;
time_varying_factor = 1e-4*ones(1,T);
beta    = 0.98; % forgetting factor
alpha   = 0.9;  % alpha-divergence

eta_OPAST  = zeros(1,T); rho_OPAST  = zeros(1,T);
eta_aFAPI = zeros(1,T); rho_aFAPI = zeros(1,T);
eta_FAPI  = zeros(1,T); rho_FAPI = zeros(1,T);
eta_RPAST = zeros(1,T); rho_RPAST = zeros(1,T);
eta_YAST  = zeros(1,T); rho_YAST = zeros(1,T);
eta_RYAST = zeros(1,T); rho_RYAST = zeros(1,T);
eta_LORAF = zeros(1,T); rho_LORAF = zeros(1,T);
eta_aFAPI = zeros(1,T); rho_aFAPI = zeros(1,T);
eta_TRPAST = zeros(1,T); rho_TRPAST = zeros(1,T); 
eta_ROBUSTA = zeros(1,T); rho_ROBUSTA = zeros(1,T); 
eta_GRASTA = zeros(1,T);    rho_GRASTA = zeros(1,T);  
eta_OPIT = zeros(1,T);       rho_OPIT = zeros(1,T);  
eta_alpha_OPIT = zeros(1,T); rho_alpha_OPIT = zeros(1,T);
for ii = 1 : n_exp
    fprintf('run %d/%d \n',ii,n_exp)
    disp('+ Data Generating ...')
    % Generating data
    % true data
    [X,U_tr] = data_generator(n,T,r,time_varying_factor);
    % noise
    epsilon   = 0.2;  % ratio of the mixture of two aussian noises
    sigma_n   = 10;
    mu_n      = 10;
    
    % add mixture noises + outliers
    Noise            = randn(n,T); %(1-epsilon)*randn(n,T) + epsilon*(randn(n,T));
    mixture_outlier1 = (1-epsilon)*randn(n,1) + epsilon*sigma_n*(randn(n,1) + mu_n);  
    mixture_outlier2 = (1-epsilon)*randn(n,1) + epsilon*2*sigma_n*(randn(n,1) + mu_n);  
    sparse_outlier   = 2*sigma_n*rand(n,1);  
    sparse_outlier(abs(sparse_outlier)<0.6*sigma_n) = 0;
    Noise(:,500)  = mixture_outlier1;
    Noise(:,1000) = sparse_outlier;
    Noise(:,1500) = mixture_outlier2;
    X_noise   = X + Noise;
    
    %% Main Program
    disp('+ Processing ...')
    OPTS.lambda = beta;

    [~, eta_aFAPI_ii,~]     = alpha_FAPI(X_noise,beta,alpha,U_tr);
    [~,eta_OPIT_ii,~]       = OPIT(X_noise,U_tr,OPTS);
    [~,eta_alpha_OPIT_ii,~] = alpha_OPIT(X_noise,U_tr,alpha,OPTS);

    
    eta_aFAPI        = eta_aFAPI + eta_aFAPI_ii;
    eta_OPIT         = eta_OPIT + eta_OPIT_ii;
    eta_alpha_OPIT   = eta_alpha_OPIT + eta_alpha_OPIT_ii;

end
eta_aFAPI   = eta_aFAPI/n_exp;
eta_OPIT    = eta_OPIT/n_exp;
eta_alpha_OPIT    = eta_alpha_OPIT/n_exp;

%% PLOT
disp('Plotting ....')

makerSize = 11;
numbMarkers = 500;
LineWidth = 2;

color   = get(groot,'DefaultAxesColorOrder');
red_o      = [1,0,0];
blue_o     = [0, 0, 1];
magenta_0  = [1 0 1];
gree_o     = [0, 0.5, 0];
black_o    = [0.25, 0.25, 0.25];

blue_n  = color(1,:);
oran_n  = color(2,:);
yell_n  = color(3,:);
viol_n  = color(4,:);
gree_n  = color(5,:);
lblu_n  = color(6,:);
brow_n  = color(7,:);
lbrow_n = [0.5350    0.580    0.2840];


k = 1; TS = round(T/5);


fig = figure; 
hold on;

t2 = semilogy(1:k:T,eta_OPIT(1:k:T),'-','color',gree_o,'LineWidth',LineWidth);
t21 = semilogy(1:TS:T,eta_OPIT(1:TS:T),'marker','+','markersize',makerSize,...
   'linestyle','none','color',gree_o,'LineWidth',LineWidth);
t22 =  semilogy(1,eta_OPIT(1),'marker','+','markersize',makerSize,...
   'linestyle','-','color',gree_o,'LineWidth',LineWidth);

t7 = semilogy(1:k:T,eta_aFAPI(1:k:T),'-','color','b','LineWidth',2.5);
t71 =  semilogy(1:TS:T,eta_aFAPI(1:TS:T),'marker','p','markersize',makerSize,...
   'linestyle','none','color','b','LineWidth',LineWidth);
t72 =  semilogy(1,eta_aFAPI(1),'marker','p','markersize',makerSize,...
   'linestyle','-','color','b','LineWidth',LineWidth);

t8 = semilogy(1:k:T,eta_alpha_OPIT(1:k:T),'-','color',red_o,'LineWidth',2.5);
t81 =  semilogy(1:TS:T,eta_alpha_OPIT(1:TS:T),'marker','>','markersize',makerSize,...
   'linestyle','none','color',red_o,'LineWidth',LineWidth);
t82 =  semilogy(1,eta_alpha_OPIT(1),'marker','>','markersize',makerSize,...
   'linestyle','-','color',red_o,'LineWidth',LineWidth);

hold off


ylabel('SEP','interpreter','latex','FontSize',13,'FontName','Times New Roman'); 
xlabel('Data Sample','interpreter','latex','FontSize',13,'FontName','Times New Roman');
%leg = legend([t12 t32 t22 t52 t42 t62 t72 t82],...
 leg = legend([  t22  t72 t82],...
     '\texttt{OPIT}', '$\alpha$\texttt{FAPI}', ...
     '$\alpha$\texttt{OPIT} (proposed)');
set(leg,'Location','NorthWest','Interpreter','latex',...
   'FontSize',20,'NumColumns',1);

% legend boxoff

axis([0 T 1e-4 1e2 ]);

h=gca;
set(gca, 'YScale', 'log','FontSize',24)
set(h,'FontSize',24,'XGrid','on','YGrid','on','FontName','Times New Roman');
% set(h,'Xtick',0:200:1000,'FontSize',24,'XGrid','on','YGrid','on','FontName','Times New Roman');
grid on;
box on;
%set(fig, 'units', 'inches', 'position', [0.5 0.5 9 7]);

