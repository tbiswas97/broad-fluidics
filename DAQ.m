classdef DAQ 
    properties (Access = public)
        currentScan
        DAQSession
    end
    methods (Access = public)
        function  connect(self)
            self.DAQSession = daq.createSession('ni');
            s = self.DAQSession;
            addAnalogOutputChannel(s,'Dev1','ao0','Voltage'); %Pump Speed Control 
            addDigitalOutputChannel(s,'Dev1','Port0/Line0','OutpuOnly'); %Pump Direction Control
            addDigitalOutputChannel(s,'Dev1','Port0/Line2','OutputOnly');%Pump Power Control
            addDigitalOutputChannel(s,'Dev1','Port0/Line8:19','OutputOnly'); %Control valves 
        end
        function switchValve(self,varargin)
            signal = self.currentScan;
            for i = 1:nargin
                signal(4*nargin:(4*nargin)+3) = dec2mat(varargin{i});
            end
            signal (3) = 1;
            outputSingleScan(self.DAQSession, signal)
        end
        function primeTubing(self)
            self.currentScan(1) = 5;
            self.currentScan(3) = 0;
            outputSingleScan(self.DAQSession,self.currentScan);
        end
        function startFlow(self,num,unit)
            if strcmp(unit,'mL/min')
                voltage = (num - 0.202)/0.456;
                vr = round(voltage,2);
                self.currentScan(1) = vr;
                outputSingleScan(self.DAQSession,self.currentScan)
            else
                disp('Only mL inputs are supported at this time')
            end
        end 
        function stopPump(self)
            self.currentScan(3) = 0;
            self.currentScan(1) = 0;
            outputSingleScan(self.DAQSession,self.currentScan)
        end
    end
end

function signal = dec2mat(num)
    binval = dec2bin(num,4);
    carray = cellstr(binval')';
    signal = flip(str2double(carray));
end