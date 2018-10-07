filename='Cantileverbeam_Hexahedra_Linear_Structured';
ptype = 'MACRO';
method = 'SIMPALL';
materialType = 'ISOTROPIC';
initial_case = 'holes';
cost = {'compliance'};
weights = [1];
constraint = {'volumeConstraint'};
optimizer = 'HAMILTON-JACOBI'; kappaMultiplier = 1;
filterType = 'P1';
constraint_case = 'INEQUALITY';

nsteps = 10;
Vfrac_final = 0.15;
Perimeter_target=3.5;
optimality_final =1e-4;
constr_final =1e-4;

BCscale_factor = 0.3;
HJiter0 = 1;
e2 = 1;
N_holes = [17 9 9];
R_holes = 0.2;
phase_holes = [0 0 0];

Vfrac_initial = 0.3;
optimality_initial = 5e-2;
constr_initial = 5e-2;

TOL.rho_plus = 1;
TOL.rho_minus = 0;
TOL.E_plus = 1;
TOL.E_minus = 1e-3;

% maxiter = 1;
TOL.nu_plus = 0.3;
TOL.nu_minus = 0.3;

plotting = 1;
printing = 0;
monitoring = 1;
monitoring_interval = 1;