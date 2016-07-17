%{ ----------  Info  ---------- %}
% @author MehrdadFI <http://m3hrdadfi.com>
% @date 04-Dec-2015
% @title Genetic & Ackley function

clc, clear all, close all;

%% Definition
global NFE;
NFE = 0;

% Number of Chromosomes
bound = [-5 5];
ndLength = range(bound);
ndOne = bound(1);

% General
gene = 10;
generations = 1000;
npop = 10;
npops = 1:npop;


% Crossover & Mutation
pc = 0.4;
pm = 0.3;

% Mutation parameters
r = rand;
b = 1;


% Function
FN_Ackley = @(xx) Akley(xx);
FN_Cost = @(x) Cost(x);
FN_CrossOver = @(p1, p2) CrossOver(p1, p2);
FN_Mutation = @(p, t) Mutation(p, t, generations, r, b);

% Solution
solution.position = [];
solution.cost = [];

%% Population
pop = repmat(solution, npop, 1);
for i = 1:npop
    % random position
    pop(i).position = rand(1, gene) * ndLength + ndOne;

    % Ackley Evaluation
    ackley = FN_Ackley(pop(i).position);

    % Cost Evaluation
    pop(i).cost = FN_Cost(ackley);
end

% Sort Population
costs = [pop.cost];
[costs, order] = sort(costs);
pop = pop(order);

% Best Solution
best_solution = pop(1);

% Store All Best Cost
best_costs = zeros(generations, 1);

% Array to Hold Number of Function Evaluations
nfe = zeros(generations, 1);
iteration = [];

%% Main
for generation = 1:generations
    % Crossover Selection
    pop_c = [];
    pop_cn = npops;
    for i = 1:npop
        rand_i = rand;
        if rand_i < pc
            pop_c = [pop_c pop(i)];
            pop_cn = pop_cn(pop_cn ~= i);
        end
    end
    if mod(length(pop_c), 2) ~= 0
        pop_c = [pop_c pop(datasample(pop_cn, 1))];
    end
    % CrossOver
    nc = length(pop_c);
    pop_c = reshape(pop_c, [], 2);
    popc = repmat(solution, nc/2, 2);
    for i = 1:nc/2
        % Applying CrossOver
        [popc(i,1).position, popc(i,2).position] = FN_CrossOver(pop_c(i,1).position, pop_c(i,2).position);
        % Ackley Evaluate Offsprings
        ackley1 = FN_Ackley(popc(i,1).position);
        ackley2 = FN_Ackley(popc(i,2).position);

        % Cost Evaluation
        popc(i,1).cost = FN_Cost(ackley1);
        popc(i,2).cost = FN_Cost(ackley2);
    end
    % reshape popc
    popc = reshape(popc, [], 1);



    % Mutation Selection
    pop_m = [];
    pop_mn = npops;
    for i = 1:npop
        rand_i = rand;
        if rand_i < pm
            pop_m = [pop_m pop(i)];
            pop_mn = pop_mn(pop_mn ~= i);
        end
    end

    % Mutation
    nm = length(pop_m);
    popm = repmat(solution, nm, 1);
    for i = 1:nm
        % Apply Mutation
        popm(i).position = FN_Mutation(pop_m(i).position, generation);

        % ackley Evaluate Offsprings
        ackley = FN_Ackley(popm(i).position);

        % Cost Evaluation
        popm(i).cost = FN_Cost(ackley);
    end

    % mix
    popMix = [pop; popc; popm];

    % sort
    popMixCosts = [popMix.cost];
    [popMixCosts, order] = sort(popMixCosts);
    popMix = popMix(order);

    % truncate
	pop = popMix(1:npop);


    % Store Best Solution Ever Found
    best_solution = pop(1);

    % Store Best Cost Ever Found
    best_costs(generation) = best_solution.cost;

    % Store NFE
    nfe(generation) = NFE;
    iteration = [iteration generation];

    % Show Iteration Information
    disp(['Generation ' num2str(generation) ': NFE = ' num2str(nfe(generation)) ', Y = Ackley(x1, x2) = ' num2str(best_costs(generation))]);
 end

%% Results
subplot(2,1,1)
plot(iteration, best_costs, 'r', 'LineWidth', 2);
title('Based On Generation')
xlabel('Iteration');
ylabel('Y = Ackley(x1, x2)');
subplot(2,1,2)
plot(nfe, best_costs, 'r', 'LineWidth', 2);
title('Based On Number Function Evaluation')
xlabel('NFE');
ylabel('Y = Ackley(x1, x2)');
drawnow;
