function retstr = example_Stat(instruct)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Short description of example:
%
% TOPIC: "Dining Philosophers"
% CHAPTER: "Introduction"
% EXAMPLE: example_Ind
% ID: indicators
% KEYWORDS: "dining philosophers, cellular automaton, indicators"
% DESCRIPTION: "A cellular automaton modell of the dining philosophers problem.
% Variables philosopher count, timesteps and eating time offset are randomly sampled in 
% this example. Further the model runs mutliple times in order to analyze and 
% track indicators (e.g. average eating time)"
% AUTHORS: "Widmer Tim Oliver, Vincent Keenbek, Florian Haidenberger, Matthias Zezulka"
% LAST UPDATE: "31.03.2023"
% BY: "Matthias Zezulka"
%
% Part of the MMT E-Learning Platform by ASC-MMS and DWH.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% EXTRACTION OF INPUT VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input values from the web-interface must be extracted from a text string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraction of input variables from a text string.
simRuns=str2num(instruct.simRuns);
displayOffset = str2num(instruct.showOffset);
offsetFunction = instruct.offsetFunction;

%================================= END OF SPECIFIC CODE - CUT HERE ========
%% CALCULATIONS, FUNCTION CALLS AND MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%
% All general calculations and operations come here.

avgEatingTimes = zeros(simRuns,1);
avgThinkingTimes = zeros(simRuns,1);
avgStarvingTimes = zeros(simRuns,1);
simulatedTimesteps = zeros(simRuns,1);
simulatedPhilosophers = zeros(simRuns,1);
simulatedOffset = zeros(simRuns,1);
totalAutomatonStates = 0;
totalEatingStates = 0;
totalThinkingStates = 0;

for k = 1 : simRuns

    philosopherCount = 3 + fix(rand(1) * 7);
    timesteps = 10 + fix(rand(1) * 500);
    simulatedTimesteps(k) = timesteps;
    simulatedPhilosophers(k) = philosopherCount;     

    switch offsetFunction
        case 'sin'
            eatingTimeOffset = fix(sin(k) * 5) + 5;
        case 'cubic'
            eatingTimeOffset = fix(0.0000001461039*k^(3) - 0.0002335497835*k^(2) + 0.0802489177489*k + 2);
        case 'none'
            eatingTimeOffset = 0;
        case 'random'
            eatingTimeOffset = fix(rand(1) * 9);
        case 'constant'
            eatingTimeOffset = 5;
    end

    if eatingTimeOffset < 0
        eatingTimeOffset = 0;
    elseif eatingTimeOffset > 9
        eatingTimeOffset = 9;
    end
    
    simulatedOffset(k) = eatingTimeOffset;

    % init CA
    philosopherAutomaton = zeros(timesteps, philosopherCount);
    totalAutomatonStates = totalAutomatonStates + (timesteps * philosopherCount);

    avgRunEatingTimes = [];
    avgRunThinkingTimes = [];
    avgRunStarvingTimes = [];
    starvingHelpCounter = zeros(1,philosopherCount);
    
    for i = 1 : philosopherCount
        % generate random number 0 < r <= 10
        r = 1 + fix(rand(1) * 9);
        % set initial meditation state r for philosopher i
        philosopherAutomaton(1, i) = r;
    end
    
    % main loop
    for i = 1 : timesteps
        for j = 1 : philosopherCount
            % s = current decremented state
            s = philosopherAutomaton(i,j) - 1;
            leftPhilosopher = j - 1;
            rightPhilosopher = j + 1;
            nextTimeStep = i + 1;
    
            % take care of index bounds
            if (nextTimeStep > timesteps)
               break;
            end
           
            if (leftPhilosopher <= 0)
                leftPhilosopher = philosopherCount;
            end
    
            if (rightPhilosopher > philosopherCount)
                rightPhilosopher = 1;
            end
    
                % check if left and right for available
                % if yes generate eating state
                % else set 22 or 21
            if (s >= 20) || (s == 0)
                if ((philosopherAutomaton(i, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(i,leftPhilosopher) <= 11) ...
                        && (philosopherAutomaton(nextTimeStep, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(nextTimeStep,leftPhilosopher) <= 10))
                    if (philosopherAutomaton(i, rightPhilosopher) > 20 || philosopherAutomaton(i,rightPhilosopher) <= 11)
                        r = fix(rand(1) * (9-eatingTimeOffset)) + eatingTimeOffset;
                        philosopherAutomaton(nextTimeStep,j) = 11+r;
                        avgRunEatingTimes = vertcat(avgRunEatingTimes, 1+r);
                        totalEatingStates = totalEatingStates + 1+r;
                        if starvingHelpCounter(1,j) > 0
                            avgRunStarvingTimes = vertcat(avgRunThinkingTimes,starvingHelpCounter(1,j));
                            if (isnan(starvingHelpCounter(1,j)))
                                starvingHelpCounter(1,j) = 1;
                            end
                            starvingHelpCounter(1,j) = 0;
                        end
                    else
                        philosopherAutomaton(nextTimeStep,j) = 22;
                        starvingHelpCounter(1,j) = starvingHelpCounter(1,j) + 1;
                    end
                else
                    philosopherAutomaton(nextTimeStep,j) = 21;
                    starvingHelpCounter(1,j) = starvingHelpCounter(1,j) + 1;
                end
    
                % finished eating
                % generate thinking state
            elseif s == 10
                r = 1 + fix(rand(1) * 9);
                philosopherAutomaton(nextTimeStep,j) = 1+r;
                avgRunThinkingTimes = vertcat(avgRunThinkingTimes, 1+r);
                totalThinkingStates = totalThinkingStates + 1+r;
                % not state transition
                % decrement step
            else
                philosopherAutomaton(nextTimeStep,j) = s;
            end
    
        end
        
    end

    if ~isempty(avgRunEatingTimes)
        avgEatingTimes(k) = mean(avgRunEatingTimes);
    end
    if ~isempty(avgRunThinkingTimes)
        avgThinkingTimes(k) = mean(avgRunThinkingTimes);
    end
    if ~isempty(avgRunStarvingTimes)
        avgStarvingTimes(k) = mean(avgRunStarvingTimes);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphical output is generated here.

Pic1 = figure('visible','on');



hold on;

plot(1:simRuns,avgEatingTimes, 'Color','green','LineWidth',2);
plot(1:simRuns, avgThinkingTimes, 'Color','blue','LineWidth',2);
plot(1:simRuns, avgStarvingTimes,'Color','red','LineWidth',2);
if displayOffset
    plot(1:simRuns, simulatedOffset, 'Color','magenta');
end


legend('average Eating Times', 'average Thinking Time', 'average Starving Time','Eating Time Offset');


grid on;
hold off;

Pic2 = figure('visible', 'off');
hold on;

data = [totalAutomatonStates - (totalThinkingStates + totalEatingStates) totalEatingStates totalThinkingStates];
pie(data);
legend({'starving States', 'eating States', 'thinkingStates'});
xlim([-1.5 1.5])
ylim([-1.5 1.5])

Pic3 = figure('visible','off');

totalAvgThinking = mean(avgThinkingTimes);
totalAvgEating = mean(avgEatingTimes);
totalAvgStarving = mean(avgStarvingTimes);

hold on;
plot([0 simRuns],[totalAvgEating totalAvgEating], 'Color','green','LineWidth',2);
plot([0 simRuns], [totalAvgThinking totalAvgThinking], 'Color','blue','LineWidth',2);
plot([0 simRuns], [totalAvgStarving totalAvgStarving],'Color','red','LineWidth',2);
    
legend('Total Average Eating Time','Total Average Thinking Time','Total Average Starving Time' );
grid on;
ylim([0 10]);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disables graphical output on the remote system. Switch ’on’ at home.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
r=adamInitialize();
r=adamRenderImage(r,instruct,Pic1,'Gantt Chart of CA');
r=adamRenderImage(r,instruct,Pic2,'Gantt Chart of CA');
r=adamRenderImage(r,instruct,Pic3,'Gantt Chart of CA');
% produces a *.png image for graphical output.
retstr=adamComposeResultString(r);
%================================= END OF SPECIFIC CODE - CUT HERE ========
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
%% END OF EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%