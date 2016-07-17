%{ ----------  Info  ---------- %}
% @author MehrdadFI <http://m3hrdadfi.com>
% @date 04-Dec-2015
% @title Genetic & nQueens Problem

clc; clear; close all;

%% Definition
% NFE
global NFE;
NFE = 0;

% General
gene = input('n Queens (default: 8): ');
generations = input('How Many Ancestors Do You Have?(default = 300) ');
npop = input('How Many population Do You Have?(default = 10) ');

if isempty(gene)
    gene = 8;
end
if isempty(generations)
    generations = 300;
end
if isempty(npop)
    npop = 10;
end

npops = 1:npop;

% CrossOver & Mutation
pc = 0.8;
nc = 2 * round(pc * npop / 2);

pm = 0.6;
nm = round(pm * npop);

% Functions
FN_Threats = @(positions, queen) Threats(gene, positions, queen);
FN_Cost = @(threats) Cost(threats);
FN_CrossOver = @(p1, p2) CrossOver(p1, p2);
FN_Mutation = @(p) Mutation(p);

% Solution
solution.position = [];
solution.threats = zeros(1, gene);
solution.cost = [];

%% Population
pop = repmat(solution, npop, 1);
for i = 1:npop
    % random position
    pop(i).position = randperm(gene);
    % find threats
    for ii = 1:gene
        pop(i).threats(ii) = FN_Threats(pop(i).position, ii);
    end
    % evaluate the solution
    pop(i).cost = FN_Cost(pop(i).threats);
end

% Sort Population
costs = [pop.cost];
[costs, order] = sort(costs);
pop = pop(order);

% Best Solution
best_solution = pop(1);

% Store All Best Cost
best_costs = [];

% Array to Hold Number of Function Evaluations
nfe = [];
iteration = [];

%% Main
for generation = 1:generations
    % CrossOver
    popc = repmat(solution, nc/2, 2);
    for i = 1:nc/2
        % Select First Parent Randomly
        n1 = datasample(npops, 1, 'Replace', false);
        p1 = pop(n1);

        % Select Second Parent Randomly
        n2 = datasample(npops(npops~=n1), 1, 'Replace', false);
        p2 = pop(n2);

        % child produced by crossover
        [popc(i,1).position, popc(i,2).position] = FN_CrossOver(p1.position, p2.position);

        % find threats
        for ii = 1:gene
            popc(i,1).threats(ii) = FN_Threats(popc(i,1).position, ii);
            popc(i,2).threats(ii) = FN_Threats(popc(i,2).position, ii);
        end
        % evaluate the solution
        popc(i,1).cost = FN_Cost(popc(i,1).threats);
        popc(i,2).cost = FN_Cost(popc(i,2).threats);
    end

    % reshape popc
    popc = reshape(popc, [], 1);


    % Mutation
    popm = repmat(solution, nm, 1);
    for i = 1:nm
        % Select Parent Randomly
        n = datasample(npops, 1, 'Replace', false);
        p = pop(n);

        % child produced by mutation
        popm(i).position = FN_Mutation(p.position);

        % find threats
        for ii = 1:gene
            popm(i).threats(ii) = FN_Threats(popm(i).position, ii);
        end
        % evaluate the solution
        popm(i).cost = FN_Cost(popm(i).threats);
    end

    % mix
    popMix = [pop; popc; popm];

    % sort
    popMixCosts = [popMix.cost];
    [popMixCosts, order] = sort(popMixCosts);
    popMix = popMix(order);

    % truncate
    pop = popMix(1:npop);

    % store best solution & costs
    best_solution = pop(1);
    best_costs = [best_costs best_solution.cost];

    % Store NFE
    nfe = [nfe NFE];
    iteration = [iteration generation];

    % Show Generation Information
    disp(['Iteration ' num2str(generation) ': NFE = ' num2str(nfe(generation)) ', Threats = ' num2str(best_costs(generation)) ', queen = ' num2str(best_solution.position)]);

    % break the loop
    if best_solution.cost == 0
        break;
    end
end
%% Results

subplot(2,1,1)
plot(iteration, best_costs, 'r', 'LineWidth', 2);
title('Based On Iterations')
xlabel('Iteration');
ylabel('THREATS');
subplot(2,1,2)
plot(nfe, best_costs, 'r', 'LineWidth', 2);
title('Based On Number Function Evaluation')
xlabel('NFE');
ylabel('THREATS');
drawnow
