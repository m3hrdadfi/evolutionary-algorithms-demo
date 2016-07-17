%{ ----------  Info  ---------- %}
% @author MehrdadFI <http://m3hrdadfi.com>
% @date 04-Dec-2015
% @title Differential evolution & Ackley function

clc, clear all, close all;

%% Defindividualion
global NFE;
NFE = 0;

% Number of Chromosomes
bound = [-15 15];
nd = 20;
bound_length = range(bound);
bound_start = bound(1);

%% Params
% Maximum Number of Generations
generations = 2000;
% Population Size
npop = 35;
npops = 1:npop;

% beta
beta = rand;

% pr
pr = rand;


% pop history
pops_history = [];

%% Function
Fn_Ackley = @(xx)Akley(xx);
Fn_Cost = @(x)Cost(x);
Fn_Mutation = @(p)Mutation(p, beta);
Fn_CrossOver = @(p, pm)CrossOver(p, pm, nd, pr);

%% individualialize the individual
individual.position = [];
individual.cost = [];

%% individualialize the population
pop = repmat(individual, npop, 1);
for i = 1:npop
    % individualialize Position
    pop(i).position = rand(1, nd) * bound_length + bound_start;

    % Ackley Evaluation
    ackley = Fn_Ackley(pop(i).position);

    % Cost Evaluation
    pop(i).cost = Fn_Cost(ackley);
end

% Sort Population
costs = [pop.cost];
[costs, order] = sort(costs);
pop = pop(order);

% Best Solution
best_solution = pop(1);

% Store All Best Cost
best_cost = zeros(generations, 1);

% Array to Hold Number of Function Evaluations
nfe = zeros(generations, 1);
iteration = [];

%% Main
for generation = 1:generations

    % Mutation
    popm = repmat(individual, npop, 1);
    for j = 1:npop
        % individualialize Position
        remove_j = npops(npops ~= j);
        n = datasample(remove_j, 3, 'Replace',false);
        p = pop(n);

        % Mutation
        popm(j).position = Fn_Mutation(p);

        % Ackley Evaluation
        ackley = Fn_Ackley(popm(j).position);

        % Cost Evaluation
        popm(j).cost = Fn_Cost(ackley);
    end

    % CrossOver
    popc = repmat(individual, npop, 1);
    for k = 1:npop
        % produce
        popc(k).position = Fn_CrossOver(pop(k).position, popm(k).position);

        % Ackley Evaluation
        ackley = Fn_Ackley(popc(k).position);

        % Cost Evaluation
        popc(k).cost = Fn_Cost(ackley);

        % Selection
        if popc(k).cost >= pop(k).cost
            popc(k) = pop(k);
        end
    end


    % Sort
    pops = popc;
    costs = [pops.cost];
    [costs, order] = sort(costs);
    pops = pops(order);

    % truncate
    pop = pops(npops);
    costs = costs(npops);

    % best solution
    best_solution = pop(1);

    % Store Best Cost Ever Found
    best_cost(generation) = best_solution.cost;

    % Store NFE
    nfe(generation) = NFE;
    iteration = [iteration generation];

    % Show Iteration Information
    disp(['Iteration ' num2str(generation) ': NFE = ' num2str(nfe(generation)) ', Y = Ackley(x1, x2) = ' num2str(best_cost(generation))]);
end

%% Results
subplot(2,1,1)
plot(iteration, best_cost, 'r', 'LineWidth', 2);
title('Based On Iterations')
xlabel('Iteration');
ylabel('Y = Ackley(x1, x2)');
subplot(2,1,2)
plot(nfe, best_cost, 'r', 'LineWidth', 2);
title('Based On Number Function Evaluation')
xlabel('NFE');
ylabel('Y = Ackley(x1, x2)');
drawnow;
