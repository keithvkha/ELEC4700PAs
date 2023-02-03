%% Misc settings
winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

%% Fundamental constants
% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


%% Spatial medium and time settings
tSim = 200e-15      % stop time

f = 230e12;         % EM wave frequency
lambda = c_c/f;     % wavelength

xMax{1} = 20e-6;    % Length of x axis to simulate
nx{1} = 200;        % Number of points in x axis
ny{1} = 0.75*nx{1}; % Number of points in y axis


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;       %% Representing the medium permeaability as a tensor
epi{1} = ones(nx{1},ny{1})*c_eps_0;     %% Representing the medium permittivity as a tensor

% epi{1}(10:20,55:95)= c_eps_0*11.3;
% epi{1}(30:40,55:95)= c_eps_0*11.3;
% epi{1}(50:60,55:95)= c_eps_0*11.3;

% epi{1}(125:150,55:95)= c_eps_0*11.3;

% epi{1}(125:150,70) = c_eps_0*11.3;
% epi{1}(135, 55:95) = c_eps_0*11.3;

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};     % spatial x step
dt = 0.25*dx/c_c;       % time step
nSteps = round(tSim/dt*2);      % Number of time points based on the simulation stop time
yMax = ny{1}*dx;        % length of y axis to simulate    
nsteps_lamda = lambda/dx;   % Number of spatial steps relative to wavelength

%% Plot and animation settings
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];


%% Boundary conditions
% Excitation source
bc{1}.NumS = 1;
bc{1}.s(1).xpos = nx{1}/(4) + 1;
bc{1}.s(1).type = 's';
bc{1}.s(1).fct = @PlaneWaveBC;

bc{1}.NumS = 2;
bc{1}.s(2).xpos = nx{1}/(8) + 1;
bc{1}.s(2).type = 's';
bc{1}.s(2).fct = @PlaneWaveBC;

% Plane wave properties of the excitation source
% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = 15e-15;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0*1.5,sty,'s'};
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0/2,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






