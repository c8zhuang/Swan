filename='Cantilever_triangle_fine';
ptype = 'MACRO';
method = 'SIMPALL';
materialType = 'ISOTROPIC';
initial_case = 'holes';
cost = {'compliance','perimeter'};
weights = [1 0.25];
constraint = {'volume'};
optimizer = 'HAMILTON-JACOBI'; kappaMultiplier = 1;
filterType = 'P1';
constraint_case = 'INEQUALITY';
line_search = 'DIMENSIONALLY CONSISTENT';

HJiter0 = 1;
e2 = 50;
N_holes = [11 12];
R_holes = 0.4;
phase_holes = [pi/2 pi/2];

nsteps = 1;
Vfrac_final = 0.4;
Perimeter_target = 1;
optimality_final = 1e-3;
constr_final =1e-3;

Vfrac_initial = 0.7;
optimality_initial = 1e-3;
constr_initial = 1e-3;
TOL.rho_plus = 1;
TOL.rho_minus = 0;
TOL.E_plus = 1;
TOL.E_minus = 1e-3;
TOL.nu_plus = 1/3;
TOL.nu_minus = 1/3;