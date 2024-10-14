function AmpSpectrum()
% v1.0 | 06-04-2024
% v1.1 | add scale

%% Figure
f= figure('Units','normalized','Position',[0.1,0.0646,0.8,0.85], ...
    'MenuBar','none','ToolBar','figure','NumberTitle','off', ...
    'Name','Amplitude Spectrum');


%% Axes

w1 = 0.71;
x1 = 0.27;
h1 = 0.41;
y1 = 0.56;

ax1 = axes(f,"Units","normalized","Position",[x1,y1,w1,h1]);
L1 = plot(NaN,NaN,'LineWidth',0.5,'Color',[0 0.4470 0.7410]); hold on; grid on
xticklabels('')
xticks('auto')
ylabel('Data','FontWeight','bold')

ax2 = axes(f,"Units","normalized","Position",[0.0638,0.07,0.9162,0.457]);
L2 = plot(NaN,NaN,'LineWidth',1,'Color',[0.8500 0.3250 0.0980]); hold on; grid on
ylabel('Spectrum','FontWeight','bold')

%% Var selection

datapannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.0445,0.9+0.0123,0.165,0.06]);


varsname = ['Select';evalin('base', 'who')];

menuBox = uicontrol(datapannel,'Style','popupmenu','Units','normalized',...
    'Position',[0.28,0.16,0.7,0.6],'String',varsname,...
    'FontUnits','normalized','FontSize',0.6);

txt1 = uicontrol(datapannel,"Style",'pushbutton','Units','normalized',...
    'Position',[0.02,0.2,0.24,0.6],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','left','FontWeight','bold',...
    'BackgroundColor',[0.85,0.85,0.85]);
txt1.String = 'Data:';

%% FFT Button and Export Button

h = 0.39;
w = 0.91;
gh = (1 - 2*h)/3;
gw = (1 - w)/2;


btnpannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.1557,0.544+0.0123,0.05865,0.098147]);

fftBtn = uicontrol('Parent',btnpannel,'Units','normalized',...
    'FontUnits','normalized','String','FFT',...
    'Style','pushbutton','Position',[gw,h+2*gh,w,h],...
    'BackgroundColor',[0.85,0.85,0.85],'ForegroundColor',[0,0,0],...
    'FontSize',0.55,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

exportBtn = copyobj(fftBtn,btnpannel);
exportBtn.Position = [gw,gh,w,h];
exportBtn.String = 'Export';

%% Linewidth

w1 = 0.4326;
w2 = 0.5;
h1 = 0.1;
h = (1-3*h1)/2;
x1 = 0.48;

linepannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.0445,0.783+0.0123,0.14,0.105],...
    'Title','linewidth','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.13);

l1txt = uicontrol(linepannel,"Style",'text','Units','normalized',...
    'Position',[0.033,2*h1+h,w1,h],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','left','FontWeight','bold');
l1txt.String = 'signal:';

l1Box = uicontrol(linepannel,"Style","edit",'Units','normalized',...
    'Position',[x1,2*h1+h,w2,h],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center');
l1Box.String = '0.5';

l2txt = copyobj(l1txt,linepannel);
l2txt.String = 'spectrum:';
l2txt.Position = [0.033,h1,w1,h];
l2txt.HorizontalAlignment = 'left';

l2Box = copyobj(l1Box,linepannel);
l2Box.Position = [x1,h1,w2,h];
l2Box.String = '1';

%% scale, grid

gridpannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.0445,0.66+0.0123,0.17,0.105],...
    'Title','Scale (fs) & Grid','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.13);

scaletxt = copyobj(l1txt,gridpannel);
scaletxt.String = 'scale:';
scaletxt.Position(3) = 0.2242;

scaleBox = copyobj(l1Box,gridpannel);
scaleBox.Position([1,3]) = [0.2863,0.6936];
scaleBox.String = '1';

gridtxt = copyobj(l2txt,gridpannel);
gridtxt.String = 'grid:';
gridtxt.Position(3) = 0.2242;

gridBox = copyobj(l2Box,gridpannel);
gridBox.Position([1,3]) = [0.2863,0.6936];
gridBox.String = 'nan';

%% Resolution

fftpannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.0445,0.543+0.0123,0.106,0.105],...
    'Title','fft parameter','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.13);

restxt = copyobj(l1txt,fftpannel);
restxt.String = 'resol:';
restxt.Position(3) = 0.343;

resBox = copyobj(l1Box,fftpannel);
resBox.Position(1) = 0.458;
resBox.String = 'inf';

%% Window function

windowBox = copyobj(menuBox,fftpannel);
varsname = {'Rect';'Hann';'Hamming';'Gauss';'Tukey'};
windowBox.String = varsname;
windowBox.Position = [0.051,0.0773,0.91068,0.36126];


%%
homeBtn = uicontrol('Parent',f,'Units','normalized',...
    'FontUnits','normalized','String','Home',...
    'Style','pushbutton','Position',[0.931,0.497,0.049,0.0272],...
    'BackgroundColor',[1,1,1],'ForegroundColor',[0,0,0],...
    'FontSize',0.7,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');
home0Btn = copyobj(homeBtn,f);
home0Btn.Position = [0.931,0.94,0.049,0.0272];

%% Assign Callback
set(f,'ButtonDownFcn',@refresh)
set(datapannel,'ButtonDownFcn',@refresh)
set(txt1,'ButtonDownFcn',@refresh)
set(menuBox,'callback',@menuBox_callback);
set(fftBtn,'callback',@fftupdate);
set(resBox,'callback',@fftupdate);
set(scaleBox,'callback',@scaleBox_callback);
set(windowBox,'callback',@fftupdate);
set(homeBtn,'callback',@home);
set(home0Btn,'callback',@home0);
set(l1Box,'callback',@l1Box_callback);
set(l2Box,'callback',@l2Box_callback);
set(gridBox,'callback',@drawGrid);
set(exportBtn,'callback',@exportBtn_callback)


%% GUI Data
handles.f = f;
handles.ax1 = ax1;
handles.ax2 = ax2;
handles.L2 = L2;
handles.L1 = L1;
handles. l1Box= l1Box;
handles. l2Box= l2Box;
handles.data = NaN;
handles.data0 = NaN;
handles.menuBox = menuBox;
handles.windowBox = windowBox;
handles.resBox = resBox;
handles.scaleBox = scaleBox;
handles.gridBox = gridBox;
guidata(f,handles);
end


%% Select Data
function menuBox_callback(hobj,~)
handles = guidata(hobj);
%varsname = handles.varsname;
varind = handles.menuBox.Value;
dataname = handles.menuBox.String{varind};
cvar = evalin('base', 'who');
if ~ismember(dataname,cvar)
    return
end
data0 = evalin('base', dataname);


[r,c] = size(data0);
if r == 2 && (c*2) == numel(data0)
    fs = 1/mean(diff(data0(1,:)));
    data0 = data0(2,:)';
elseif c == 2 && (r*2) == numel(data0)
    fs = 1/mean(diff(data0(:,1)));
    data0 = data0(:,2);    
elseif numel(data0) == r || numel(data0) == c
    fs = 1;
    data0 = reshape(data0,[],1);
end
if fs == 1
    handles.scaleBox.String = '1';
else
    handles.scaleBox.String = num2str(fs,'%.3e');
end


handles.dataname = dataname;
handles.data0 = data0;
guidata(hobj,handles)

updataL1(hobj);
fftupdate(hobj)
handles.gridBox.String = 'nan';

end

%% 
function refresh(hobj,~)
handles = guidata(hobj);
varsname = ['Select';evalin('base', 'who')];
handles.menuBox.String = varsname;

end

%% Update Original Data
function updataL1(hobj,~)

handles = guidata(hobj);

data0 = handles.data0;
if isempty(handles.scaleBox.String)
    fs = 1;
    handles.scaleBox.String = '1';
else
    fs = eval(handles.scaleBox.String);
end
dt = 1/fs;

axes(handles.ax1)
handles.L1.XData = 0:dt:(length(data0)-1)*dt;
handles.L1.YData = data0;

limy = [min(data0),max(data0)];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(handles.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([0,(length(data0)-1)*dt])
    drawnow;
    ylim('manual')
end
xticks('auto')
guidata(hobj,handles)
end
%%
function scaleBox_callback(hobj,~)
handles = guidata(hobj);
handles.resBox.String = 'inf';
handles.gridBox.String = 'nan';
redrawL1X(handles)
fftupdate(hobj);
home(hobj);
guidata(hobj,handles)
end

function redrawL1X(handles)

x = handles.L1.XData;

axes(handles.ax1)
limx = xlim;
ind = [find(x>=limx(1),1) , find(x<=limx(2),1,'last')];

%
n = length(handles.data0);
if isempty(handles.scaleBox.String)
    fs = 1;
    handles.scaleBox.String = '1';
else
    fs = eval(handles.scaleBox.String);
end

dt = 1/fs;
x = 0:dt:(n-1)*dt;
handles.L1.XData = x;
xticks('auto')
xlim([x(ind(1)),x(ind(2))])
end


%% Update fft
function fftupdate(hobj,~)
handles = guidata(hobj);

data0 = handles.data0;
axes(handles.ax1)
limx = xlim;

x = handles.L1.XData;
xrange = x>=limx(1) & x<=limx(2);

if ~isnan(data0)
    data = data0(xrange);
else
    return
end
if isempty(data)
    return
end

WindTypeInd=get(handles.windowBox, 'value');
n = length(data);
switch WindTypeInd
    case 1
        w = ones(n,1);
    case 2
        t = (0:1:n-1)';
        w = 0.5-0.5*cos(2*pi*t/(n-1));
    case 3
        t = (0:1:n-1)';
        w = 0.54-0.46*cos(2*pi*t/(n-1));
    case 4
        t = (0:n-1)'-(n-1)/2;
        w = exp(-(1/2)*(2.5*t/((n-1)/2)).^2);
    case 5
        ratio = 0.4;
        per = ratio/2; 
        tl = floor(per*(n-1))+1;
        th = n-tl+1;
        t = linspace(0,1,n)';
        w = [ ((1+cos(pi/per*(t(1:tl) - per)))/2);  ...
            ones(th-tl-1,1); ((1+cos(pi/per*(t(th:end) - 1 + per)))/2)];
end

if isempty(handles.resBox.String)
    reso = inf;
    handles.resBox.String = 'inf';
else
    reso = eval(handles.resBox.String);
end

if isempty(handles.scaleBox.String)
    fs = 1;
    handles.scaleBox.String = '1';
else
    fs = eval(handles.scaleBox.String);
end
[Y_FFT,freq,n_fft] = sspectrum(data, fs, reso ,w);

%
axes(handles.ax2)
handles.L2.XData = freq;
handles.L2.YData = Y_FFT;

ylim([0,max(Y_FFT)*1.05])

limx = xlim;
xlim([max([0,limx(1)]),limx(2)])

handles.n_fft = n_fft;
handles.data = data;
guidata(hobj,handles)

end


%% Home
function home(hobj,~)
handles = guidata(hobj);


y = handles.L2.YData;

if ~isnan(y(1))
    axes(handles.ax2)
    ylim([0,max(y)*1.05])
    xlim([0,max(handles.L2.XData)])
end
end

function home0(hobj,~)
handles = guidata(hobj);

y = handles.L1.YData;
limy = [min(y),max(y)];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(handles.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([0,max(handles.L1.XData)])
end

end

%% Change linewidth

function l1Box_callback(hobj,~)
handles = guidata(hobj);


if isempty(handles.l1Box.String)
    l1width = 0.5;
    handles.l1Box.String = '0.5';
else
    l1width = eval(handles.l1Box.String);
end


axes(handles.ax1)
handles.L1.LineWidth = l1width;
end

function l2Box_callback(hobj,~)
handles = guidata(hobj);
if isempty(handles.l1Box.String)
    l2width = 1;
    handles.l1Box.String = '1';
else
    l2width = eval(handles.l1Box.String);
end
axes(handles.ax2)
handles.L2.LineWidth = l2width;
end

%% draw grid
function drawGrid(hobj,~)
handles = guidata(hobj);

if isempty(handles.gridBox.String)
    gridval = nan;
    handles.gridBox.String = 'nan';
else
    gridval = eval(handles.gridBox.String);
end

if isnan(gridval)
    xticks('auto')
    return
end

x = handles.L1.XData;
dx = 1/gridval;
axes(handles.ax1)
xticks(x(1):dx:x(end))
end

%%
function exportBtn_callback(hobj,~)
handles = guidata(hobj);
data = handles.data;
freq = handles.L2.XData;
result = handles.L2.YData;

prompt = {'Data: ','Freq: ','FFT: '};
dlgtitle = 'Output Name';
dims = [1 20];
definput = {'fft_data_','fft_freq_','fft_result_'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer)
    return
end

assignin('base', answer{1}, data);
assignin('base', answer{2}, freq);
assignin('base', answer{3}, result);

end

%%
function [Y_FFT,freq,n_fft] = sspectrum(y, fs, f_resl ,window)

n = length(y);
min_nfft = fs/f_resl;
n_fft = max([2^(nextpow2(min_nfft)) , n]);
window = reshape(window,size(y));

y = (y-mean(y)).* window;
scale = n/sum(window);

n_freq = ceil(n_fft/2);
freq = (0:n_freq-1)'/n_fft*fs;
Y_FFT = abs(fft(y,n_fft)/n);
Y_FFT = Y_FFT(1:n_freq) * scale *2;
Y_FFT(1) = Y_FFT(1)/2;

end

