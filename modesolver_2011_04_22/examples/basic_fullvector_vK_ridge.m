addpath('..\tools');

% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
% rw = 1.0;           % Ridge half-width
rw = linspace(0.325,1,10);
rwstruct = struct();
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

for i = 1:length(rw)
    [x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2,n3],[h1,h2,h3], ...
                                            rh,rw(i),side,dx,dy);
    rwstruct(i).rw = rw(i);
    rwstruct(i).x = x;
    rwstruct(i).y = y;
    rwstruct(i).xc = xc;
    rwstruct(i).yc = yc;
    rwstruct(i).nx = nx;
    rwstruct(i).ny = ny;
    rwstruct(i).eps = eps;
end

% First consider the fundamental TE mode:

for i = 1:length(rwstruct)
%     [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');
    [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,rwstruct(i).eps,'000A');
    rwstruct(i).Hx = Hx;
    rwstruct(i).Hy = Hy;
    rwstruct(i).neff = neff;
    neff_vec(i) = neff;
end

fprintf(1,'neff = %.6f\n',neff);
figure; plot(rw, neff_vec);

mode = struct();

for i = 1:length(rwstruct)
    for nm = 1:nmodes
        x = rwstruct(i).x;
        y = rwstruct(i).y;
        mode(nm).Hx = rwstruct(i).Hx(:,:,nm);
        mode(nm).Hy = rwstruct(i).Hy(:,:,nm);

        figure;
        subplot(121);
        contourmode_vK(x,y,mode(nm).Hx);
        title('Hx (TE mode)'); xlabel('x'); ylabel('y');
        for v = edges, line(v{:}); end

        subplot(122);
        contourmode_vK(x,y,mode(nm).Hy);
        title('Hy (TE mode)'); xlabel('x'); ylabel('y');
        for v = edges, line(v{:}); end
    end
end

%% TM mode
% Next consider the fundamental TM mode
% (same calculation, but with opposite symmetry)

for i = 1:length(rwstruct)
    [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,rwstruct(i).eps,'000S');
    rwstruct(i).Hx = Hx;
    rwstruct(i).Hy = Hy;
    rwstruct(i).neff = neff;
    neff_vec(i) = neff;
end

fprintf(1,'neff = %.6f\n',neff);

for i = 1:length(rwstruct)
    for nm = 1:nmodes
        x = rwstruct(i).x;
        y = rwstruct(i).y;
        mode(nm).Hx = rwstruct(i).Hx(:,:,nm);
        mode(nm).Hy = rwstruct(i).Hy(:,:,nm);

        figure;
        subplot(121);
        contourmode_vK(x,y,mode(nm).Hx);
        title('Hx (TM mode)'); xlabel('x'); ylabel('y');
        for v = edges, line(v{:}); end

        subplot(122);
        contourmode_vK(x,y,mode(nm).Hy);
        title('Hy (TM mode)'); xlabel('x'); ylabel('y');
        for v = edges, line(v{:}); end

    end
end
