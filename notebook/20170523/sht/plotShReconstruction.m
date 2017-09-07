% *************************************************************************
%
% Plot Reconstructed Function
%
% Inputs
%   F_N         - (N+1)^2 vector of spherical harmonic coefficients
%   basisType   - SH basis type for the coefficients {'real','complex'} 
%   aziRes      - Azimuthal grid resolution [deg]
%   polarRes    - Polar angle grid resolution [deg]
%   axisHandle  - optional argument to define an axis handle for the plot,
%                 otherwise the new axis handle is returned
% Outputs
%   []
%
% This function is based on plotSphFunctionCoeffs.m by Archontis Politis 
% (archontis.politis@aalto.fi) commit 4f4cf39. Designed to work as addition
% to the Spherical-Harmonic-Transform Library, which is distributed under
% the license included in that commit. This function licensed under the MIT
% License.
%   
%           Scott Schoen Jr | Georgia Tech | 20170523
%
% *************************************************************************

function [ h_ax, result ] = ...
    plotShReconstruction(F_N, basisType, aziRes, polarRes, R0, h_ax)

switch nargin
    case 4
        R0 = 1;
        figure();
        h_ax = gca;
    case 5
        figure();
        h_ax = gca;
    otherwise
        h_ax = NaN;
        result = 'Not enough input arguments!';
        return;
end

% get function values at grid by the inverse SHT
dirs = grid2dirs(aziRes, polarRes);
F = inverseSHT(F_N, dirs, basisType);
Fgrid = Fdirs2grid(F, aziRes, polarRes, 1);

% construct grid
azi = 0:aziRes:360;
elev = 0:polarRes:180;
azi_rad = azi*pi/180;
elev_rad = elev*pi/180;
[Az, El] = meshgrid(azi_rad, elev_rad);

% Plot over surface of sphere with constant radius
R = R0 + 0.*Az;
D_x = R.*cos(Az).*sin(El);
D_y = R.*sin(Az).*sin(El);
D_z = R.*cos(El);

% plot 3d axes
maxF = max(max(abs(Fgrid)));
line([0 1.1*maxF],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.1*maxF],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.1*maxF],'color',[0 0 1])

% plot function
hold on
Hm = surf(D_x, D_y, D_z, real(Fgrid));
shading interp;

xlabel('$x$');
ylabel('$y$');
zlabel('$z$');

view(40,30);
camlight left;
camlight right;
lighting none;
axis equal;
colorbar;

end
