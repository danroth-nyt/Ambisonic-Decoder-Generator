function r = SphericalHarmonics(azi, elev, n, m)
%% Function to calculate spherical harmonics based on given azimuths, elevations, ambisonic order(n), and ambisonic degree(m)

Pn = legendre(n,sin(elev));

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

%output 
r = Ymn;
