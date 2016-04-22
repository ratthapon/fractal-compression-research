% hmm processing
close all;clear all;
nStates = 3;
nTime = 4;
HStates = zeros(nStates,nTime);
HTrans = zeros(nTime,nStates,nStates);
HTransArrow = zeros(nTime,nStates,nStates);
axis([0.5 5.5 0.5 nStates+0.5 ]);
ylabel('State index');
xlabel('Frame index');
set(gca,'Ydir','reverse');
hold on;
for time = 1:nTime
    if time > 5
        axis([time-5.5 time+0.5 0.5 nStates+0.5 ]);
    end
    for state = 1:nStates
        HStates(state,nTime) = scatter(time,state,300,'k','filled');
        text(time-0.05,state-0.15,['S' num2str(state)]);
        if time > 1
            for prevState = 1:nStates
                HTrans(time,prevState,state) = ...
                    quiver((time-1), (prevState), 0.8, (state - prevState)*0.8, ...
                    1,'filled', 'MaxHeadSize', 0.3,'color','k','LineWidth',3);
                 HTransArrow(time,prevState,state) = ...
                    plot([time-1, time],[ prevState, state],'k','LineWidth',3);
                
                %                 HTrans(time,prevState,state) = ...
                %                 arrow([time-1 prevState],[time state],'color','k','BaseAngle',5);
                %                 set(HTrans(time,prevState,state),'marker','d');
            end
        end
    end
end
% H = plot([1 2; 3 4],'r')