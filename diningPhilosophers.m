clear

philosopherCount = 5;
timesteps = 100;

philosopherAutomaton = zeros(timesteps, philosopherCount);

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
        currentPhilosopher = j;
        leftPhilosopher = j - 1;
        rightPhilosopher = j + 1;
        nextTimeStep = i + 1;
        last = false;

        if (nextTimeStep > timesteps)
           break;
        end
       
        if (leftPhilosopher <= 0)
            leftPhilosopher = philosopherCount;
        end

        if (rightPhilosopher > philosopherCount)
            rightPhilosopher = 1;
        end


        switch s
            % if s == 20
            % if left available
            % generate eating state
            % else set 21
            case 20
                if ((philosopherAutomaton(i, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(i,leftPhilosopher) <= 11) ...
                        && (philosopherAutomaton(nextTimeStep, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(nextTimeStep,leftPhilosopher) <= 10))
                   if (philosopherAutomaton(i, rightPhilosopher) > 20 || philosopherAutomaton(i,rightPhilosopher) <= 11)
                        r = fix(rand(1) * 9);
                        philosopherAutomaton(nextTimeStep,j) = 11+r;
                   else
                       philosopherAutomaton(nextTimeStep,j) = 22;
                   end
                else
                    philosopherAutomaton(nextTimeStep,j) = 21;
                end

                
                % if s == 21
                % if right available
                % generate eating state
                % else set 22
            case 21
                if ((philosopherAutomaton(i, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(i,leftPhilosopher) <= 11) ...
                        && (philosopherAutomaton(nextTimeStep, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(nextTimeStep,leftPhilosopher) <= 10))
                   if (philosopherAutomaton(i, rightPhilosopher) > 20 || philosopherAutomaton(i,rightPhilosopher) <= 11)
                        r = fix(rand(1) * 9);
                        philosopherAutomaton(nextTimeStep,j) = 11+r;
                   else
                       philosopherAutomaton(nextTimeStep,j) = 22;
                   end
                else
                    philosopherAutomaton(nextTimeStep,j) = 21;
                end


                % if s == 10
                % generate thinking state
            case 10
                r = 1 + fix(rand(1) * 9);
                philosopherAutomaton(nextTimeStep,j) = 1+r;
              

                % if s == 0
                % if fork left available
                % if fork right available
                % generate eating state
                % else set 22
                % else set 21
            case 0
                if ((philosopherAutomaton(i, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(i,leftPhilosopher) <= 11) ...
                        && (philosopherAutomaton(nextTimeStep, leftPhilosopher) > 20 ...
                        || philosopherAutomaton(nextTimeStep,leftPhilosopher) <= 10))
                    if (philosopherAutomaton(i, rightPhilosopher) > 20 || philosopherAutomaton(i,rightPhilosopher) <= 11)
                        r = fix(rand(1) * 9);
                        philosopherAutomaton(nextTimeStep,j) = 11+r;
                   else
                       philosopherAutomaton(nextTimeStep,j) = 22;
                   end
                else
                    philosopherAutomaton(nextTimeStep,j) = 21;
                end
          

            otherwise
                philosopherAutomaton(nextTimeStep,j) = s;
             
        end
    end
    
end

plotGanttChart(philosopherAutomaton, philosopherCount, timesteps);
verifyModel(philosopherAutomaton);

function plotGanttChart(philosopherAutomaton, philosopherCount, timesteps)
 
    starving = [0.6350 0.0780 0.1840];
    thinking = [0 0.4470 0.7410];
    eating = [0.4660 0.6740 0.1880];
    empty = [0.5 0.5 0.5];

    plainChart = ones(philosopherCount, timesteps);
    b = barh(plainChart(:,:), 'stacked','EdgeColor','none');

    for i = 1 : timesteps 
        for j = 1 : philosopherCount
            s = philosopherAutomaton(i,j);

            if (s < 11) 
                b(i).FaceColor = 'flat';
                b(i).CData(j,:) = thinking;
            end

            if ((s >= 11) && (s <= 20)) 
                b(i).FaceColor = 'flat';
                b(i).CData(j,:) = eating;
            end

            if (s > 20) 
                b(i).FaceColor = 'flat';
                b(i).CData(j,:) = starving;
            end  

            if (s == 0) 
                b(i).FaceColor = 'flat';
                b(i).CData(j,:) = empty;
            end
        end
    end
    
end

function verifyModel(philosopherAutomaton)
    philosopherCount = size(philosopherAutomaton,2);
    timesteps = size(philosopherAutomaton, 1);
    
    for i = 1 : timesteps
        for j = 2 : philosopherCount
            currentPhilosopher = j;
            leftPhilosopher = j - 1;

            if ((philosopherAutomaton(i, leftPhilosopher) > 10 && philosopherAutomaton(i, leftPhilosopher) <= 20) ...
                    && (philosopherAutomaton(i, currentPhilosopher) > 10 && philosopherAutomaton(i, currentPhilosopher) <= 20))
                disp('Model not correct, error in line: ')
                disp(i);
                return;
            end
        end
    end
    disp('Simulation correct')
end