%Experiment 1 
daq = DAQ;
%daq.connect();
%daq.DAQSession.Rate = 1;
daq.primeTubing;
disp('Press key when priming complete')
pause();

fr = input('Set the volume to fill each well (mL)'); 

ro = [1 4 2 4 3 4]; %order of reagents

for i = 1:4
    daq.switchValve(ro(i),i);
    pause(1)
    daq.startFlow(fr,'mL')
    fprintf('Filling well %d with reagent %d ...\n',i, ro(i))
    pause(fr*60)
end