function [design_variable,fval] = top_opt_algorithm(problem)

epsilon_Le_kernel = problem.epsilon_Le_kernel;
epsilon_iter_perimeter = problem.epsilon_iter_perimeter;
target_parameters = problem.incropt;
problembsc = problem.problembsc;


%% Initialize optimization data
global post_info
post_info.cost_n = []; post_info.theta_n = []; post_info.volume_n = []; 
post_info.lambda_n = []; post_info.Perimeter_n = []; post_info.kappa_n = []; 
post_info.gamma_old = []; post_info.incre_gamma_n = [];post_info.compliance_n=[];
post_info.penalty_Perimeter_n = []; post_info.penalty_volume_n = []; post_info.epsilon_n = [];
post_info.cumulative_iter = 0; post_info.conectivities = problem.element.conectivities; post_info.coordinates = problem.coordinates;
post_info.fhtri = []; post_info.global_iter_n = [];

% Optimization parameters
x0 = problem.x0;
initial_values = [];

% Target parameters
target_parameters.epsilon_ini = epsilon_iter_perimeter(1);
target_parameters.epsilon_final = epsilon_iter_perimeter(end);

target_parameters.epsilon_isotropy_ini = 1e-1;
target_parameters.epsilon_isotropy_final = 1e-3;

Vfrac = problem.element.Vfrac;
problem.volume(x0,Vfrac);
target_parameters.vol_ini = post_info.volume;
target_parameters.vol_final = Vfrac;

target_parameters.Cstar = [];
target_parameters.Vtarget = target_parameters.vol_ini;
target_parameters.epsilon = target_parameters.epsilon_ini;
target_parameters.epsilon_isotropy = target_parameters.epsilon_isotropy_ini;
[~,~,problembsc,initial_values,options] = create_optimization_problem(problem,problem.problem_type,problembsc,target_parameters,initial_values,[]);
target_parameters.Cstar_ini = problembsc.Ch_star;
target_parameters.Cstar_final = problembsc.Ch_star_final;
if strcmp(problembsc.enforceCh_type,'isotropy')
    target_parameters.epsilon_isotropy_ini = 1e-3;
    target_parameters.epsilon_isotropy_final = 1e-5;
end

% Tolerances
switch problem.algorithm
    case 'level_set'
        target_parameters.DualTol_ini = 100;
        target_parameters.DualTol_final = 1;
    case 'IPOPT'
        target_parameters.DualTol_ini = 1e-1;
        target_parameters.DualTol_final = 1e-4;
    otherwise
        target_parameters.DualTol_ini = 1e-1;
        target_parameters.DualTol_final = 1e-3;
end
target_parameters.PrimalTol_ini = 1e-1;
target_parameters.PrimalTol_final = 1e-3;

%%
if ~strcmp(problem.algorithm,'check_derivative')
    %% Call optimizer
    nsteps = length(target_parameters.alpha_PrimalTol);
    for t = 1:nsteps  
        post_info.iepsilon = t;    
        target_parameters = update_target_parameters(target_parameters,t);
        [fobj,constr_fun,problembsc,initial_values] = create_optimization_problem(problem,problem.problem_type,problembsc,target_parameters,initial_values,options);
        problem.volume_current = @(x) problem.volume(x,target_parameters.Vtarget);
        optimality_tolerance = target_parameters.DualTol;
        constraint_tolerance = target_parameters.PrimalTol;
        [x0,fval,options] = optimizer_selection (fobj,constr_fun,x0,problembsc,problem,initial_values,options,optimality_tolerance,constraint_tolerance);
    end
    design_variable = x0;



    %% Post-process (save results)
    optdata = struct;
    problem.outputopt(design_variable,optdata,true);

    % POST-PROCESS FOR COMPARISONS
    figure(problem.fhplots);
    % Compare compliance with "real" with P0
    [~,~,gamma_reg_gp_P0] = problem.diff_react_equation(design_variable,epsilon_Le_kernel,'P0_kernel','gamma');
    [compliance_P0,~,structural_values] = problem.equilibrium(gamma_reg_gp_P0,problembsc,initial_values.compliance0);
    subplot(3,4,11);                 
    hold on
    plot(post_info.global_iter_n(end),compliance_P0,'xr') 
    drawnow
    if strcmp(problem.design_type,'MICRO')
        message = 'FINAL MICROSTRUCTURAL PROPERTIES (P0):';
        try
            cprintf('key','\n%s\n',message);
        catch ME
            warning('cprintf failed!');
            fprintf('\n%s\n',message);
        end
        inv_matCh = inv(structural_values.matCh);
        nu12 = -inv_matCh(1,2)/inv_matCh(1,1);
        nu21 = -inv_matCh(2,1)/inv_matCh(2,2);
        E1 = 1/inv_matCh(1,1);
        E2 = 1/inv_matCh(2,2);
        fprintf('E1 = %16.16f\n',E1);
        fprintf('E2 = %16.16f\n',E2);
        fprintf('nu12 = %16.16f\n',nu12);
        fprintf('nu21 = %16.16f\n',nu21);
        fprintf('G = %16.16f\n',1/inv_matCh(3,3));
        matCh = structural_values.matCh;
        fprintf('Isotropic condition = %16.16f\n',matCh(1,1) - matCh(2,1) - 2*matCh(3,3));
        Ch_star_div = post_info.Ch_star;
        Ch_star_div (abs(Ch_star_div) < 1e-3) = 1;
        abs((matCh - post_info.Ch_star)./Ch_star_div)
        matCh
        post_info.Ch_star
        
    end

    % Compute complience using a threshold
    threshold = 0.5;
    gamma_threshold = gamma_reg_gp_P0;
    gamma_threshold (gamma_threshold < threshold) = 0;
    gamma_threshold (gamma_threshold >= threshold) = 1;
    [compliance_P0,~,~] = problem.equilibrium(gamma_threshold,problembsc,initial_values.compliance0);
    subplot(3,4,11);                 
    hold on
    plot(post_info.global_iter_n(end),compliance_P0,'*k') 
    drawnow

    % Fair compliance comparison SIMP vs SIMP-ALL
    if strcmp(problem.method,'SIMP')
        % Recompute with SIMP-ALL
        problem.element.mu_func = problem.element.mu_func_simp_all;
        problem.element.kappa_func = problem.element.kappa_func_simp_all;
        problem.element.polarization_sym_part_fourth_order_tensor = problem.element.polarization_sym_part_fourth_order_tensor_simp_all;
        problem.element.polarization_doble_product_second_identity_tensor = problem.element.polarization_doble_product_second_identity_tensor_simp_all;
        [compliance_P0,~,~] = problem.equilibrium_simp_all(gamma_reg_gp_P0,problembsc,problem.element,initial_values.compliance0);
        subplot(3,4,11);                 
        hold on
        plot(post_info.global_iter_n(end),compliance_P0,'+g') 
        drawnow
    end 
else
    %% Check derivatives module 
    design_variable = [];
    fval = [];

    % Initialize functions
    fobj = @(x) problem.compliance(x,problembsc,initial_values);
    epsi = 1e-6;
    [f0,g0] = fobj(x0);
    [v0,gv0] = problem.volume(x0,target_parameters.vol_final);
    [p0,gp0] = problem.perimeter(x0,target_parameters.epsilon_final);
    % NOTE: not possible to use perimeter with parfor (uses global variables)

    % Compute gradients by finite-differences
    nnod = length(g0);
    g = zeros(size(g0));
    gv = zeros(size(g0));
    gp = zeros(size(g0));
    parfor inode = 1:nnod % parallelize equilibrium evaluations
        x = x0;
        x(inode) = x(inode) - epsi;
        f = feval(fobj,x);
        g(inode) = (f0-f)/epsi;
    end
    for inode = 1:nnod
        x = x0;
        x(inode) = x(inode) - epsi;
        p = feval(problem.perimeter,x,target_parameters.epsilon_final);
        v = feval(problem.volume,x,target_parameters.vol_final);
        gp(inode) = (p0-p)/epsi;
        gv(inode) = (v0-v)/epsi;
    end
    fprintf('Relative error Volume: %g\n',error_norm_field(gv,gv0,problem.Msmooth));
    fprintf('Relative error Perimeter: %g\n',error_norm_field(gp,gp0,problem.Msmooth));
    fprintf('Relative error Compliance: %g\n',error_norm_field(g,g0,problem.Msmooth));

    % Plots
    save_fig = false;
    plot_check_derivative(g,g0,gv,gv0,gp,gp0,problem.coordinates,problem.Msmooth,save_fig);
    % figure('Name','Relation user-supplied/finite-differences');
    % plot(g0./g,'x');
end
  
end
