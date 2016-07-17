%{ ----------  Info  ---------- %}
% @author MehrdadFI <m3hrdadfi@gmail.com>
% @date 18-Dec-2015
% @title PSO

clc; clear; close all;

%% Defintion
global NFE;
NFE = 0;

% Number of Chromosomes
bound = [-5 5];
nd = 2;
bound_length = range(bound);
bound_start = bound(1);

% PSO
generations = 500;
npop = 20;

% w0 = 0.9;
% wT = 0.4;
% w = 0.9;
% c1 = 1;
% c2 = 0;
w = 0.72984;
c1 = 2.05;
c2 = 2.05;

% Velocity Limits
velocity_max = 0.5 * (bound(2) - bound(1));
velocity_min = -velocity_max;

% Functions 
fn_ackley = @(xx)ackley(xx);

[X1, X2] = meshgrid(bound(1):.1:bound(2));
Z = zeros(size(X1));
for i = 1:size(X1, 1)
    for j = 1:size(X1, 2)
        Z(i, j) = fn_ackley([X1(i,j), X2(i,j)]);
    end
end

%% Individual Structure
individual.position = [];
individual.cost = [];
individual.velocity = [];
individual.best.position = [];
individual.best.cost = [];

gbest.cost = inf;

%% Population Produce
particle = repmat(individual, npop, 1);
for i = 1:npop
    
    particle(i).position = rand(1, nd) * bound_length + bound_start;
    particle(i).cost = fn_ackley(particle(i).position);
    particle(i).velocity = zeros(1, nd);
    
    particle(i).best.position = particle(i).position;
    particle(i).best.cost = particle(i).cost;
    

    if particle(i).best.cost < gbest.cost
        gbest = particle(i).best;
    end
end

% Store All Best Cost
best_cost = zeros(generations, 1);

% Array to Hold Number of Function Evaluations
nfe = zeros(generations, 1);

figure;
mesh(X1, X2, Z);
hold on;
%% Main
for generation = 1:generations
    for i = 1:npop
        % update velocity
        particle(i).velocity = w * particle(i).velocity ...
            + c1 * rand(1, nd) .* (particle(i).best.position - particle(i).position) ...
            + c2 * rand(1, nd) .* (gbest.position - particle(i).position);
        
        
        % velocity limitation
        particle(i).velocity = max(particle(i).velocity, velocity_min);
        particle(i).velocity = min(particle(i).velocity, velocity_max);

        % update position
        particle(i).position = particle(i).position + particle(i).velocity;
        
        % velocity mirror effect
        isOutside=(particle(i).position < bound(1) | particle(i).position > bound(2));
        particle(i).velocity(isOutside) = -particle(i).velocity(isOutside);
        
      
        % update cost
        particle(i).cost = fn_ackley(particle(i).position);
        
        % update personal best
        if particle(i).cost < particle(i).best.cost
            particle(i).best.position = particle(i).position;
            particle(i).best.cost = particle(i).cost;
            
            % update gbest
            if particle(i).best.cost < gbest.cost
                gbest = particle(i).best;
            end
        end
    end
        
    for i = 1:npop
        plot3(particle(i).best.position(1), particle(i).best.position(2), particle(i).best.cost, 'k.');
    end
    drawnow
    
    % w = (w0 - wT) * (generations - generation) * (1 / generations) + wT;
    
    % Store Best Cost Ever Found
    best_cost(generation) = gbest.cost;
    
    % Store NFE
    nfe(generation) = NFE;
    
    % Show Generation Information
    disp(['Iteration = ' num2str(generation) ', NFE = ' num2str(nfe(generation)) ', Y = Ackley = ' num2str(best_cost(generation))]);
end


%% Results
plot3(gbest.position(1), gbest.position(2), gbest.cost, 'r*');
hold off;


figure
semilogy(nfe, best_cost, 'r', 'LineWidth', 2);
title('Based On Number Function Evaluation');
xlabel('NFE');
ylabel('Y = Ackley(xx)');






