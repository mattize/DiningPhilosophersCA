function retstr = example_alternative(instruct)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Short description of example:
%
% TOPIC: "Dining Philosophers"
% CHAPTER: "Introduction"
% EXAMPLE: example_alternative
% ID: alternative
% KEYWORDS: "dining philosophers, cellular automatonl, alternative"
% DESCRIPTION: "A cellular automaton modell of the dining philosophers problem.
% Variables philosopher count and timesteps are fixed in this model. We propose
% an alternative version to the basic model with this model by changing the distribution
% of which eating and thinking times are sampled from a uniform distribution (as stated
% in the C10 definition) to a normal distribution. Mu and sigma are changeable parameters in
% this model."
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
mu=str2num(instruct.mu);
sigma=str2num(instruct.sigma);

%================================= END OF SPECIFIC CODE - CUT HERE ========
%% CONSTANT VARIABLES AND PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant variables and parameters are defined in this section.

philosopherCount = 5;
timesteps = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATIONS, FUNCTION CALLS AND MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%
% All general calculations and operations come here.

% init CA
philosopherAutomaton = zeros(timesteps, philosopherCount);

for i = 1 : philosopherCount
    % generate random number 0 < r <= 10
    r = 1 + fix(normrnd(mu,sigma,1));
    if r > 10
        r = 10;
    elseif r < 1
        r = 1;
    end
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
                    r = fix(normrnd(mu,sigma,1));
                    if r > 9
                        r = 9;
                    elseif r < 0
                        r = 0;
                    end
                    philosopherAutomaton(nextTimeStep,j) = 11+r;
                else
                    philosopherAutomaton(nextTimeStep,j) = 22;
                end
            else
                philosopherAutomaton(nextTimeStep,j) = 21;
            end

            % finished eating
            % generate thinking state
        elseif s == 10
            r = fix(normrnd(mu,sigma,1));
            if r > 9
                r = 9;
            elseif r < 0
                r = 0;
            end
            philosopherAutomaton(nextTimeStep,j) = 1+r;
       
            % not state transition
            % decrement step
        else
            philosopherAutomaton(nextTimeStep,j) = s;
        end

    end
    
end


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
    
Pic2 = figure('visible','off');

x = 0:0.1:10;
y = normpdf(x, mu, sigma);
plot(x,y, 'LineWidth',3);
hold on;
plot( [mu mu],[0 max(y)],'--', 'Color','red','LineWidth',2)
plot( [mu - sigma mu - sigma],[0 max(y)],'--', 'Color','magenta','LineWidth',2)
plot( [mu + sigma mu + sigma],[0 max(y)],'--', 'Color','magenta','LineWidth',2)

legend('pdf', 'mu', 'mu +/- sigma');
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disables graphical output on the remote system. Switch ’on’ at home.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
r=adamInitialize();
r=adamRenderImage(r,instruct,Pic1,'Gantt Chart of CA');
r=adamRenderImage(r,instruct,Pic2, 'Sample Distribution Pdf');
% produces a *.png image for graphical output.
retstr=adamComposeResultString(r);
%================================= END OF SPECIFIC CODE - CUT HERE ========
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
%% END OF EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%