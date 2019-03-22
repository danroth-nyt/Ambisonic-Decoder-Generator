%SphericalHarmonicsModeller
%% This code graphically plots different spherical harmonic degrees (m) of a specified ambisonic order (n)

n = 1; %order
m = 1; %degree
numpoints = 90;
azi = linspace(0, 2*pi, numpoints*2);
elev = linspace(-pi/2, pi/2, numpoints);
[a,e] = meshgrid(azi,elev);
Pn = legendre(n,sin(e));

if n==0
    Pmn = Pn;
else 
    Pmn = squeeze(Pn(abs(m)+1,:,:));
end

%normalization
if m==0
    dm = 1;
else
    dm = 0;
end
Nmn = sqrt(2*n + 1)*(2 - dm) .* (factorial(n - abs(m))) / factorial(n + abs(m));

%harmonic calculation
fTerm = 0;
if m > 0
    fTerm = cos(abs(m)*azi);
elseif m < 0
    fTerm = sin(abs(m)*azi);
elseif m== 0
    fTerm = 1;
end
Ymn = Nmn .* Pmn .* fTerm; 
Ymn = Ymn .* ((-1) .^ abs(m)); %condon shortly fix

%prepare for plot
r = abs(Ymn);
[x,y,z] = sph2cart(a,e,r);

%plot
cmap = ones(size(Ymn)) .* sign(Ymn);
figure(1)
surf(x,y,z,cmap);
xlabel('X')
ylabel('Y')
zlabel('Z')
colormap([1 0 0;0 0 1]); %blue is in-phase, red is out-of-phase
shading interp
axis equal;
axis vis3d
light('Position',[2 -4 5])
axis on
