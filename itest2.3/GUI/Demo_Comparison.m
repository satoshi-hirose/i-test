function varargout = Demo_Comparison(varargin)
% DEMO_COMPARISON MATLAB code for Demo_Comparison.fig
%      DEMO_COMPARISON, by itself, creates a new DEMO_COMPARISON or raises the existing
%      singleton*.
%
%      H = DEMO_COMPARISON returns the handle to a new DEMO_COMPARISON or the handle to
%      the existing singleton*.
%
%      DEMO_COMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_COMPARISON.M with the given input arguments.
%
%      DEMO_COMPARISON('Property','Value',...) creates a new DEMO_COMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Demo_Comparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Demo_Comparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Demo_Comparison

% Last Modified by GUIDE v2.5 15-Jul-2020 23:04:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Demo_Comparison_OpeningFcn, ...
                   'gui_OutputFcn',  @Demo_Comparison_OutputFcn, ...
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


% --- Executes just before Demo_Comparison is made visible.
function Demo_Comparison_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Demo_Comparison (see VARARGIN)

% % Choose default command line output for Demo_Comparison
% handles.output = hObject;
% 
% % Update handles structure
% guidata(hObject, handles);
addpath ../itest
addpath ../subfunctions

handles.v_i = 3;
handles.v_g_0 = 0.5;
handles.v_N_trial = 100;
handles.v_DA = [48 56 60 61 65 69 72 77 80 83 91 93]/100; 
handles.v_a = 0.05; 
handles.v_chance = 0.5;
handles.v_sd = 1/(2*sqrt(100));
handles.v_uspecfy = '[0:0.01:1;binopdf(0:100,100,0.5)]';
handles.v_dist = [0:0.01:1;binopdf(0:100,100,0.5)];
set(handles.Exp_Results,'String',mat2str(handles.v_DA))
set(handles.Gamma_0,'String',num2str(handles.v_g_0))
set(handles.i,'String',num2str(handles.v_i))
set(handles.N_sub,'String',num2str(length(handles.v_DA)))
set(handles.Alpha,'String',num2str(handles.v_a))

set(handles.chance,'String',num2str(handles.v_chance))
set(handles.N_Trial,'String',num2str(handles.v_N_trial))
set(handles.SD,'String',num2str(handles.v_sd))
set(handles.uspecify_dist,'String',handles.v_uspecfy)
guidata(hObject, handles);

% UIWAIT makes Demo_Comparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Demo_Comparison_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% get parameters
alpha = str2double(handles.Alpha.String);
exp_results = sort(str2num(handles.Exp_Results.String));
g0 = str2double(handles.Gamma_0.String);
i = str2double(handles.i.String);
N_sub = length(exp_results);

set(handles.N_sub,'String',num2str(N_sub))

%%
if sum(exp_results>1)>(length(exp_results)/2)
    disp('assuming that D-Acc is percent')
    exp_results = exp_results/100;
end
%% find largest i
prob_min =  binocdf(0:N_sub,N_sub,(1-g0));
i_max = find(prob_min<alpha,1,'last');
if isempty(i_max); warning('Number of participants is too small'); i_max = 1; 
    
end

%% figure

% Actual Data
plot(handles.axes1,[exp_results' exp_results'],[0 0.3],'k','LineWidth',2)
hold on
% Mean
plot(handles.axes1,[mean(exp_results) mean(exp_results)],[0 0.3],'r','LineWidth',1)
axis(handles.axes1,[0 1 0 1])

plot(handles.axes1,handles.v_dist(1,:),handles.v_dist(2,:)./max(handles.v_dist(2,:)),'b','LineWidth',1)

%% alpha, chance level
try [H, p_1]   = itest(exp_results',handles.v_dist,1,g0,alpha,1);
catch p_1='error'; disp(lasterr); end
if i<=i_max
try [H, p_i]   = itest(exp_results',handles.v_dist,i,g0,alpha,1);
catch p_i='error'; disp(lasterr); end
else; p_i='error'; end
try [H, p_max] = itest(exp_results',handles.v_dist,i_max,g0,alpha,1);
catch p_max='error'; disp(lasterr); end
try [H, p_ttest] = ttest(exp_results,handles.v_chance,'Tail','right');
catch p_ttest='error'; disp(lasterr); end

set(handles.itest_one_p,'String',num2str(p_1))
set(handles.itest_p,'String',num2str(p_i))
set(handles.itest_max_p,'String',[num2str(p_max) ' (i=' int2str(i_max) ')'])
set(handles.ttest_p,'String',num2str(p_ttest))



function Exp_Results_Callback(hObject, eventdata, handles)
% hObject    handle to Exp_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
handles.v_DA = str2double(tmp);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Exp_Results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Exp_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Gamma_0_Callback(hObject, eventdata, handles)
% hObject    handle to Gamma_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'String');
handles.v_g_0 = str2double(tmp);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of Gamma_0 as text
%        str2double(get(hObject,'String')) returns contents of Gamma_0 as a double


% --- Executes during object creation, after setting all properties.
function Gamma_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gamma_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function i_Callback(hObject, eventdata, handles)
% hObject    handle to i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i as text
%        str2double(get(hObject,'String')) returns contents of i as a double
tmp = get(hObject,'String');
handles.v_i = str2double(tmp);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_Trial_Callback(hObject, eventdata, handles)
% hObject    handle to N_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_Trial as text
%        str2double(get(hObject,'String')) returns contents of N_Trial as a double
tmp = get(hObject,'String');
handles.v_N_trial = str2double(tmp);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function N_Trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_Trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Alpha_Callback(hObject, eventdata, handles)
% hObject    handle to Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Alpha as text
%        str2double(get(hObject,'String')) returns contents of Alpha as a double
tmp = get(hObject,'String');
handles.v_a = str2double(tmp);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bino.
function bino_Callback(hObject, eventdata, handles)
% hObject    handle to bino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.v_dist = [0:1/handles.v_N_trial:1;binopdf(0:handles.v_N_trial,handles.v_N_trial,handles.v_chance)];
hold off
plot(handles.axes1,handles.v_dist(1,:),handles.v_dist(2,:)./max(handles.v_dist(2,:)),'b','LineWidth',1)
axis(handles.axes1,[0 1 0 1])
guidata(hObject, handles);



function chance_Callback(hObject, eventdata, handles)
% hObject    handle to chance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chance as text
%        str2double(get(hObject,'String')) returns contents of chance as a double
tmp = get(hObject,'String');
handles.v_chance = str2double(tmp);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function chance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm.
function norm_Callback(hObject, eventdata, handles)
% hObject    handle to norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
precision = 10^-5;
p_minus = [normcdf(0,handles.v_chance,handles.v_sd) diff(normcdf(0:precision:(1-precision),handles.v_chance,handles.v_sd))];
p_minus(end+1) = 1-sum(p_minus);


handles.v_dist = [0:precision:1;p_minus];
hold off
plot(handles.axes1,handles.v_dist(1,:),handles.v_dist(2,:)./max(handles.v_dist(2,:)),'b','LineWidth',1)
axis(handles.axes1,[0 1 0 1])
guidata(hObject, handles);


function uspecify_dist_Callback(hObject, eventdata, handles)
% hObject    handle to uspecify_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uspecify_dist as text
%        str2double(get(hObject,'String')) returns contents of uspecify_dist as a double
tmp = get(hObject,'String');
handles.v_uspecfy = tmp;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function uspecify_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uspecify_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in uspecify.
function uspecify_Callback(hObject, eventdata, handles)
% hObject    handle to uspecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.v_dist = eval(handles.v_uspecfy);
hold off
plot(handles.axes1,handles.v_dist(1,:),handles.v_dist(2,:)./max(handles.v_dist(2,:)),'b','LineWidth',1)
axis(handles.axes1,[0 1 0 1])
guidata(hObject, handles);

function SD_Callback(hObject, eventdata, handles)
% hObject    handle to SD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SD as text
%        str2double(get(hObject,'String')) returns contents of SD as a double
tmp = get(hObject,'String');
handles.v_sd = str2double(tmp);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function Norm_chance_Callback(hObject, eventdata, handles)
% hObject    handle to Norm_chance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Norm_chance as text
%        str2double(get(hObject,'String')) returns contents of Norm_chance as a double
tmp = get(hObject,'String');
handles.v_Norm_chance = str2double(tmp);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Norm_chance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Norm_chance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
