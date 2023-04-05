function retstr = example_Par(instruct)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Short description of example:
%
% TOPIC: "Dining Philosophers"
% CHAPTER: "Introduction"
% EXAMPLE: example_Par
% ID: parameterised
% KEYWORDS: "dining philosophers, cellular automaton, parameterised"
% DESCRIPTION: "A cellular automaton modell of the dining philosophers problem.
% This model allows for multiple parameters to be changed in order to gain
% a better understanding of the cellular automaton approach. User editable
% parameters include: philosophers count, timesteps, probability
% distribution, mu (if compatible with distribution), sigma (if compatible with distribution)
% and eating time offset.
% AUTHORS: "Widmer Tim Oliver, Vincent Keenbek, Florian Haidenberger, Matthias Zezulka"
% LAST UPDATE: "05.04.2023"
% BY: "Matthias Zezulka"
%
% Part of the MMT E-Learning Platform by ASC-MMS and DWH.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% EXTRACTION OF INPUT VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input values from the web-interface must be extracted from a text string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraction of input variables from a text string.
% dist = instruct.dist;
% mu=str2num(instruct.var1);
% sigma=str2num(instruct.var2);
% philosopherCount = str2num(instruct.philosopherCount);
% timesteps = str2num(instruct.timesteps);
% eatingTimeOffset = str2num(instruct.eatingTimeOffset);
dist = 'normal';
mu = 4;
sigma = 2.5;
philosopherCount = 7;
timesteps = 100;
eatingTimeOffset = 0;

%================================= END OF SPECIFIC CODE - CUT HERE ========
%% CALCULATIONS, FUNCTION CALLS AND MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%
% All general calculations and operations come here.

sampledValues = [];

% init CA
philosopherAutomaton = zeros(timesteps, philosopherCount);

for i = 1 : philosopherCount
    % generate random number 0 < r <= 10
    switch dist
        case 'uniform'
            r = 1 + fix(random('uniform',0,9));
        case 'normal'
            r = 1 + fix(random('normal',mu,sigma));
    end

    if r > 10
        r = 10;
    elseif r < 1
        r = 1;
    end
    % set initial meditation state r for philosopher i
    philosopherAutomaton(1, i) = r;
    sampledValues = vertcat(sampledValues, r);
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
                    switch dist
                        case 'uniform'
                            r = fix(random('uniform',(0+eatingTimeOffset),9));
                        case 'normal'
                            r = eatingTimeOffset + fix(random('normal',mu,sigma) - eatingTimeOffset);
                    end

                    if r > 9
                        r = 9;
                    elseif r < 0
                        r = 0;
                    end
                    sampledValues = vertcat(sampledValues, (1+r));

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
            switch dist
                case 'uniform'
                    r = fix(random('uniform',0,9));
                case 'normal'
                    r = fix(random('normal',mu,sigma));
            end
            if r > 9
                r = 9;
            elseif r < 0
                r = 0;
            end
            philosopherAutomaton(nextTimeStep,j) = 1+r;
            sampledValues = vertcat(sampledValues, (1+r));
       
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
    
Pic2 = figure('visible','on');

x = 0:0.1:10;
hold on;
switch dist
    case 'uniform'
        histogram(sampledValues,'Normalization','probability','FaceColor','blue','FaceAlpha',0.3);
        y = unifpdf(x,0,10);
        plot(x,y, 'LineWidth',3,'Color','red');
        legend('values','pdf');

    case 'normal'
        histogram(sampledValues,'Normalization','probability','FaceColor','blue','FaceAlpha',0.3);
        y = normpdf(x, mu, sigma);
        plot(x,y, 'LineWidth',3,'Color','red');
        plot( [mu mu],[0 max(y)],'--', 'Color','blue','LineWidth',3)
        plot( [mu - sigma mu - sigma],[0 max(y)],'--', 'Color','red','LineWidth',2)
        plot( [mu + sigma mu + sigma],[0 max(y)],'--', 'Color','red','LineWidth',2)
        legend('values','pdf', 'mu', 'mu +/- sigma');
        
end


hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disables graphical output on the remote system. Switch ’on’ at home.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
% r=adamInitialize();
% r=adamRenderText(r,instruct,ret,'Indicators');
% 
% % produces textual output.
% r=adamRenderImage(r,instruct,Pic1,'Gantt Chart of CA');
% r=adamRenderImage(r,instruct,Pic2,'Ratio of Total States');
% % produces a *.png image for graphical output.
% retstr=adamComposeResultString(r);
% %================================= END OF SPECIFIC CODE - CUT HERE ========
%================================= BEGIN OF SPECIFIC CODE - CUT HERE ======
%% END OF EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%