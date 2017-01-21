function varargout = GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function drawFig(handles)
loadToWorkspace(handles);
drawFromWorkspace(handles)

function drawFromWorkspace(handles)
global maxt x y holdOn;
t = evalin('base','t');
angle = evalin('base','angle');
speed = evalin('base','speed');
cw = evalin('base','cw');
rho = evalin('base','rho');
A = evalin('base','A');
m = evalin('base','m');
g = evalin('base','g');

axes(handles.axes1);
hold off
if holdOn
    hold on
end
[x, y] = mitLuftwiderstand(t, angle, speed, cw, rho, A, m, g);
maxt = find(y<0,1);
if length(maxt)==0
    maxt = length(x)
end
plot(x([1:maxt]),y([1:maxt]));
setAxes(handles)
assignin('base','notReloadedx',x);
assignin('base','notReloadedy',y);

neg=find(y<0);
y2 = y(neg(1)-1);
y1 = y(neg(1)-2);

x2 = x(neg(1)-1);
x1 = x(neg(1)-2);

t2 = t(neg(1)-1);
t1 = t(neg(1)-2);

s = sqrt((x2-x1)^2+(y2-y1)^2);
dt = t2-t1;

vlanding = (s/dt);

set(handles.lblFlightDuration,'string',strcat(num2str(t(maxt)),'s'));
set(handles.lblFlightHeight,'string',strcat(num2str(max(y)),'m'));
set(handles.lblFlightDistance,'string',strcat(num2str(x(maxt)),'m'));
set(handles.lblLandingSpeed,'string',strcat(num2str(vlanding),'m/s'));

set(handles.lbldHeight,'string',strcat(num2str(70-max(y)),'m'));
set(handles.lbldDistance,'string',strcat(num2str(330-x(maxt)),'m'));
set(handles.lbldLandingSpeed,'string',strcat(num2str(50-vlanding),'m/s'));



function loadToWorkspace(handles)
speed = str2double(get(handles.txtSpeed,'String'));
angle = str2double(get(handles.txtAngle,'String'));
A = str2double(get(handles.txtArea,'String'));
m = str2double(get(handles.txtMass,'String'));
cw = str2double(get(handles.txtCW,'String'));
rho = str2double(get(handles.txtRHO,'String'));
g = str2double(get(handles.txtG,'String'));
duration = str2double(get(handles.txtDuration,'String'));
resolution = (1/str2double(get(handles.txtResolution,'String')));
t = 0:resolution:duration;



assignin('base','t',t);
assignin('base','angle',angle);
assignin('base','speed',speed);
assignin('base','cw',cw);
assignin('base','rho',rho);
assignin('base','A',A);
assignin('base','m',m);
assignin('base','g',g);
assignin('base','duration',duration);
assignin('base','resolution',resolution);


function setAxes(handles)
axes(handles.axes1);
    if str2double(get(handles.txtXmax,'String'))==0
        xlim([0 inf])
    else
        xlim([0 str2double(get(handles.txtXmax,'String'))])
    end
    if str2double(get(handles.txtYmax,'String'))==0
        ylim([0 inf])
    else
        ylim([0 str2double(get(handles.txtYmax,'String'))])
    end


% --- Executes on button press in btnLoadCurr.
function btnLoadCurr_Callback(hObject, eventdata, handles)
global maxt x y;
set(handles.txtXmax,'string',x(maxt));
set(handles.txtYmax,'string',max(y));


function radioON_Callback(hObject, eventdata, handles)
global holdOn
holdOn = 1;

function radionOFF_Callback(hObject, eventdata, handles)
global holdOn
holdOn = 0;
