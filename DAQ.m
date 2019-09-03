classdef DAQ < handle
    properties (Access = public)
        currentScan
        DAQSession
    end
    methods (Access = public)
        function  obj = connect(obj)
            obj.DAQSession = daq.createSession('ni');
            s = obj.DAQSession;
            addAnalogOutputChannel(s,'Dev1','ao0','Voltage'); %Pump Speed Control 
            addDigitalChannel(s,'Dev1','Port0/Line0','OutputOnly'); %Pump Direction Control
            addDigitalChannel(s,'Dev1','Port0/Line2','OutputOnly');%Pump Power Control
            addDigitalChannel(s,'Dev1','Port0/Line8:19','OutputOnly'); %Control valves 
            obj.currentScan = zeros(1,length(s.Channels));
        end
        function switchValve(self,varargin)
            signal = self.currentScan;
            nargin_wc = nargin - 1;
            i = 1;
            while i <= nargin_wc
                if varargin{i} == 0
                    i = i + 1;
                end
                signal(4*i:(4*i)+3) = dec2mat(varargin{i});
            end
            signal (3) = 1;
            outputSingleScan(self.DAQSession, signal)
        end
        function obj = primeTubing(obj)
            obj.currentScan(1) = 5;
            obj.currentScan(3) = 0;
            outputSingleScan(obj.DAQSession,obj.currentScan);
        end
        function washLines(obj,wb)
            obj.switchValve(wb,7);
            obj.currentScan(1) = 5;
            outputSingleScan(obj.DAQSession, obj.currentScan)
        end
        function startFlow(self,num,unit)
            if strcmp(unit,'mL/min')
                voltage = (num - 0.202)/0.456;
                vr = round(voltage,2);
                self.currentScan(1) = vr;
                self.currentScan(3) = 0;
                outputSingleScan(self.DAQSession,self.currentScan)
            else
                disp('Only mL inputs are supported at this time')
            end
        end 
        function stopPump(self)
            self.currentScan(3) = 1;
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
