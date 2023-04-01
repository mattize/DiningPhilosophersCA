function retstr = example_Ind(instruct)
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
%% CALCULATIONS, FUNCTION CALLS AND MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%
% All general calculations and operations come here.

totalAutomatonStates = 0;
totalEatingStates = 0;
totalThinkingStates = 0;

philosopherCount = 3 + fix(rand(1) * 7);
timesteps = 10 + fix(rand(1) * 500);
eatingTimeOffset = 1 + fix(rand(1) * 8);

% init CA
philosopherAutomaton = zeros(timesteps, philosopherCount);
totalAutomatonStates = totalAutomatonStates + (timesteps * philosopherCount);

avgRunEatingTimes = [];
avgRunThinkingTimes = [];
avgStarvingTimes = [];

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
                else
                    philosopherAutomaton(nextTimeStep,j) = 22;
                end
            else
                philosopherAutomaton(nextTimeStep,j) = 21;
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

ret = ['Simulation run with: ' num2str(philosopherCount) ' philosophers and ' num2str(timesteps) ' timesteps.' ...
    ' Sampled eating time offset: ' num2str(eatingTimeOffset) ...
    ' Average sampled eating time (incl. eating time offset): ' num2str((sum(avgRunThinkingTimes)/length(avgRunEatingTimes))) ... 
    ' Average sampled thinking time: ' num2str((sum(avgRunThinkingTimes)/length(avgRunThinkingTimes)))];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GRAPHICAL OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphical output is generated here.

Pic1 = figure('visible','off');
hold on;

thinkingDots = [];
eatingDots = [];
starvingDots = [];

for i = 1 : timesteps 
    for j = 1 : philosopherCount
        s = philosopherAutomaton(i,j);

        if (s < 11) 
            thinkingDots = vertcat(thinkingDots, [i,j]);
        end

        if ((s >= 11) && (s <= 20)) 
            eatingDots = vertcat(eatingDots, [i,j]);
        end

        if (s > 20) 
            starvingDots = vertcat(starvingDots, [i,j]);
        end  
    end
end

scatter(thinkingDots(:,1), thinkingDots(:,2), 50,'blue', 'filled', 'square');

scatter(eatingDots(:,1), eatingDots(:,2),50,'green','filled', 'square');

scatter(starvingDots(:,1), starvingDots(:,2),50,'red','filled', 'square');


ylim([0,philosopherCount + 1]);
grid on;
xlabel('timesteps');
ylabel('philosophers');
legend('thinking', 'eating', 'starving')
hold off;

Pic2 = figure('visible', 'off');
hold on;

data = [totalAutomatonStates - (totalThinkingStates + totalEatingStates) totalEatingStates totalThinkingStates];
pie(data);
legend({'starving States', 'eating States', 'thinkingStates'});
xlim([-1.5 1.5])
ylim([-1.5 1.5])


    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disables graphical output on the remote system. Switch ’on’ at home.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
r=adamInitialize();
r=adamRenderText(r,instruct,ret,'Indicators');

% produces textual output.
r=adamRenderImage(r,instruct,Pic1,'Gantt Chart of CA');
r=adamRenderImage(r,instruct,Pic2,'Ratio of Total States');
% produces a *.png image for graphical output.
retstr=adamComposeResultString(r);
%================================= END OF SPECIFIC CODE - CUT HERE ========
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
%% END OF EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%