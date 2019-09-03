%Experiment 1 
daq = DAQ;
daq.connect();
daq.DAQSession.Rate = 1;
%daq.primeTubing;
disp('Press key when priming complete')
pause();

fr = input('Set the volume to fill each well (mL)'); 
wb = input ('Designate wash buffer');

ro = [5 5 5 5 5 5]; %order of reagents

wo = [1 2 3 4 5 6]; %order of wells to be filled

for i = 1:6 %iterating through each well 
    daq.switchValve(1,1)
    daq.washLines(wb);
    pause(60) %initial wash lasts one minute 
    daq.switchValve(ro(i),wo(i));
    pause(1)
    if i > 1
        if ro(i-1) == wb
                daq.startFlow(fr,'mL/min')
                fprintf('Filling well %d with reagent %d ...\n',wo(i), ro(i))
                pause(60)
        else
                daq.washLines(wb);
                break
        end
    end
end

daq.stopPump();