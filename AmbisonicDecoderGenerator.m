%decoder parameters
azi = [45 135 -135 -45 0]; %azimuths
azi = azi .* pi/180;
elev = [0 0 0 0 0]; %elevations
elev = elev .* pi/180;
order = 1;

clear r %clear decoder matrix to be filled
%decoder matrix
for i = 1:length(azi)
    c = 1;
    for n = 0:order
        for m = -n:n
            r(i,c) = SphericalHarmonics(azi(i), elev(i), n, m);
            c = c+1;
        end
    end
end

%invert matrix, create decoder
r = pinv(r);
 
%Generate B-format input
num_sp = 16; %number of loud speakers 
sp_pos = 0:360/num_sp:360*(1-1/num_sp); %create speaker angular positions 
sp_rad = sp_pos*pi/180; %convert to radians 
sp_elev = zeros(length(num_sp));
WigCreateAmbiJS(r, sp_rad, sp_elev, 'SN3D', '2D', 'AmbiDan'); %create ambisonic decoder JS

%input signal
sources = 181;
inAzi = 0:2*pi/(sources-1):2*pi;
inElev = zeros(size(inAzi));
for i = 1:length(inAzi)
    d = 1;
    for n = 0:order
        for m = -n:n
            input(i,d) = SphericalHarmonics(inAzi(i), inElev(i), n, m);
            d = d+1;
        end
    end
end

%convolve input with ambisonic decoder
G = input * r;

%plot
figure(1)
polarplot(repmat(inAzi,length(azi),1)',abs(G))




