%Experiment 1 
daq = DAQ;
daq.connect();
daq.DAQSession.Rate = 1;
%daq.primeTubing;
disp('Press key when priming complete')
pause();

fr = input('Set the volume to fill each well (mL)'); 

ro = [5 5 5 5 5 5]; %order of reagents

wo = [1 2 3 4 5 6];
for i = 1:6
    daq.switchValve(ro(i),wo(i));
    pause(1)
    daq.startFlow(fr,'mL/min')
    fprintf('Filling well %d with reagent %d ...\n',wo(i), ro(i))
    pause(60)
end

daq.stopPump();