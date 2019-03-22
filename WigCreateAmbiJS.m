function WigCreateAmbiJS(dec,az,elev,norm,HV,pname)

% WigCreateAmbiJS(dec,az,elev,norm,HV,pname)
%
% Create a JS effect that implements an Ambisonic Decoder.  Dec is the 2D
% decoding matrix.  Az and Elev are the speaker positions (used for
% labelling the ins outs and 'norm' is the normalisation scheme/channel
% ordering.  This can be 'SN3D', 'N3D' or 'FuMa'. Channel ordering is ACN
% except for 'FuMa'. HV can either be '2D' or '3D' and is used to provide
% the correct scaling for MaxRE and inphase decoders from your coefficients
% which are assumed to be MaxRV. 'pname' is the name of the plugin that you
% wish to create

[n,m] = size(dec);
order = floor(sqrt(n-1));
nspeak = m;
torder = num2str(order);
tnspeak = num2str(nspeak);

disp(['This is an order ',num2str(order),' decoder']);
disp(['For a ',num2str(nspeak)',' speaker array']);

fid = fopen(pname,'w');

% Initial Comments
fprintf(fid,['// an order ',num2str(order),' decoder\n// For a ',num2str(nspeak),' speaker array\n\n']);
% Name of plugin
fprintf(fid,['desc:Order ',torder,', ',tnspeak,' Speaker Decoder\n\n']);
fprintf(fid,'slider1:2<0,2,1{Strict,Cardioid,Energy}>Decode Type\n\n');
fprintf(fid,['@init\nbpos=0;\ncsp1 = 1024;\nlength_of_csps = ',num2str((order+1)^2),';\n']);
for i=2:nspeak
    fprintf(fid,'end_of_csps = csp%d + length_of_csps;\ncsp%d = end_of_csps;\n',i-1,i);
end
% write in the actual decoder values
for i=1:nspeak
    for j=1:(order+1)^2
        fprintf(fid,'csp%d[%d] = %1.10f;',i,j-1,dec(j,i));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');

% rE  2D      |   0      1      2      3      4
%  ------------------------------------------------
%           1 |   1   0.707
%           2 |   1   0.866  0.500
%           3 |   1   0.924  0.707  0.383
%           4 |   1   0.951  0.809  0.588  0.309
%
%
%  rE  3D     |   0      1      2      3      4
%  ------------------------------------------------
%           1 |   1   0.577
%           2 |   1   0.775  0.400
%           3 |   1   0.862  0.612  0.305
%           4 |   1   0.906  0.732  0.501  0.246
% IP  2D      |   0      1      2      3      4
% ------------------------------------------------
%           1 |   1   0.500
%           2 |   1   0.667  0.167
%           3 |   1   0.750  0.300  0.050
%           4 |   1   0.800  0.400  0.114  0.014
%
%
% IP  3D      |   0      1      2      3      4
% ------------------------------------------------
%           1 |   1   0.333
%           2 |   1   0.500  0.100
%           3 |   1   0.600  0.200  0.029
%           4 |   1   0.667  0.286  0.071  0.008

InPhase2D(1,:) = [1 0.5     0       0       0];
InPhase2D(2,:) = [1 0.667   0.167   0       0];
InPhase2D(3,:) = [1 0.750   0.300   0.05    0];
InPhase2D(4,:) = [1 0.800   0.400  0.114    0.014];
InPhase3D(1,:) = [1 0.333   0       0       0];
InPhase3D(2,:) = [1 0.5     0.1     0       0];
InPhase3D(3,:) = [1 0.600   0.200  0.029    0];
InPhase3D(4,:) = [1 0.667   0.286  0.071    0.008];
MaxrE2D(1,:) = [1   0.707   0       0   0];
MaxrE2D(2,:) = [1   0.866  0.500    0   0];
MaxrE2D(3,:) = [1   0.924  0.707  0.383 0];
MaxrE2D(4,:) = [1   0.951  0.809  0.588 0.309];
MaxrE3D(1,:) = [1   0.577   0       0   0];
MaxrE3D(2,:) = [1   0.775  0.400    0   0];
MaxrE3D(3,:) = [1   0.862  0.612  0.305 0];
MaxrE3D(4,:) = [1   0.906  0.732  0.501 0.246];

fprintf(fid,'MaxRvGain2d = end_of_csps;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = MaxRvGain2d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'MaxRvGain2d[%d] = 1.000;',a-1);
end
fprintf(fid,'\nMaxRvGain3d = end_of_gain;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = MaxRvGain3d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'MaxRvGain3d[%d] = 1.000;',a-1);
end
fprintf(fid,'\nInPhase2d = end_of_gain;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = InPhaseGain2d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'InPhaseGain2d[%d] = %1.4f;',a-1,InPhase2D(order,a));
end
fprintf(fid,'\nInPhaseGain3d = end_of_gain;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = InPhaseGain3d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'InPhaseGain3d[%d] = %1.4f;',a-1,InPhase3D(order,a));
end
fprintf(fid,'\nMaxReGain2d = end_of_gain;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = MaxReGain2d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'MaxReGain2d[%d] = %1.4f;',a-1,MaxrE2D(order,a));
end
fprintf(fid,'\nMaxReGain3d = end_of_gain;\nlength_of_array = %d;\n',order+1);
fprintf(fid,'end_of_gain = MaxReGain3d + length_of_array;\n');
for a = 1:order+1
    fprintf(fid,'MaxReGain3d[%d] = %1.4f;',a-1,MaxrE3D(order,a));
end

fprintf(fid,'\n\nBF = end_of_gain;\n');
fprintf(fid,'length_of_array = %d\n',(order+1)^2);
fprintf(fid,'end_of_array = BF + length_of_array;\n');

fprintf(fid,'\n@slider\n');
fprintf(fid,'slider1==0 ? GainType = MaxRvGain%s;\n',HV);
fprintf(fid,'slider1==1 ? GainType = InPhaseGain%s;\n',HV);
fprintf(fid,'slider1==2 ? GainType = MaxReGain%s;\n\n',HV);

fprintf(fid,'@sample\n');
for an = 1:(order+1)^2
    fprintf(fid,'BF[%d] = spl%d*GainType[%d];\n',an-1,an-1,floor(sqrt(an-1)));
end

% clear samples ready for deriving output
for an = 1:nspeak
    fprintf(fid,'spl%d=',an-1);
end
fprintf(fid,'0.0;\n\n');

fprintf(fid,'cnt = 0;\n');
fprintf(fid,'loop(%d,\n',(order+1)^2);
for an = 1:nspeak
    fprintf(fid,'spl%d+=BF[cnt]*csp%d[cnt];\n',an-1,an);
end
fprintf(fid,'cnt = cnt+1;\n);');

fclose(fid);

type(pname)