function varargout = csv_plotter(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csv_plotter_OpeningFcn, ...
                   'gui_OutputFcn',  @csv_plotter_OutputFcn, ...
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


% --- Executes just before csv_plotter is made visible.
function csv_plotter_OpeningFcn(hObject, eventdata, handles, varargin)
handles.csv_files = [];
handles.cwd = pwd;
handles.x_title = 'X';
handles.y_title ='Y';
handles.title = 'My Title';
handles.interpreter = 'none';
handles.legend = 0;
handles.delimiter = '_';
handles.index = 1;


handles.x_min = 0;
handles.x_max = 0; 
handles.y_min = 0; 
handles.y_max = 0;

% Choose default command line output for csv_plotter
handles.output = hObject;
guidata(hObject, handles);

update_listbox(hObject, eventdata, handles)
update_plot(hObject, eventdata, handles, varargin)

% Update handles structure

% UIWAIT makes csv_plotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function update_plot(hObject, eventdata, handles, varargin)
handles = guidata(hObject);

cla(handles.main_axes)
cla(handles.main_axes, 'reset')
hold on

xlabel(handles.main_axes, {handles.x_title}, 'Interpreter', handles.interpreter);
ylabel(handles.main_axes, handles.y_title, 'Interpreter', handles.interpreter);
title(handles.main_axes, handles.title, 'Interpreter', handles.interpreter);
legend_names = {};
for i = 1:numel(handles.csv_files)
  name = strsplit(handles.csv_files(i).name,handles.delimiter)
  legend_names{i} = name{handles.index};
  filename = strcat(strcat(handles.cwd, '\'), handles.csv_files(i).name);
  M = csvread(filename, 1, 0);
  
  xs = M(:, 1);
  ys = M(:, 2);
  
  plot(handles.main_axes, xs, ys);
  
  
end

if (handles.x_max > handles.x_min)
    xlim(handles.main_axes, [handles.x_min handles.x_max])
end

if (handles.y_max > handles.y_min)
    ylim(handles.main_axes, [handles.y_min handles.y_max])
end

legend('hide');
if (handles.legend)
    legend(handles.main_axes, legend_names, 'Interpreter', handles.interpreter)
end
hold off
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = csv_plotter_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
filename = uiputfile('*.fig','Save Figure');
if filename ~= 0
    fh = figure(); %new figure
    copyobj(handles.main_axes, fh); %show selected axes in new figure
    saveas(gcf,filename);
    close(gcf);
end



function title_edit_text_Callback(hObject, eventdata, handles)
handles.title = get(hObject,'String');
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function title_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_label_edit_text_Callback(hObject, eventdata, handles)
handles.x_title = get(hObject,'String');
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function x_label_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_label_edit_text_Callback(hObject, eventdata, handles)
handles.y_title = get(hObject,'String');
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function y_label_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
folder_name = uigetdir(handles.cwd);
if folder_name ~= 0
    handles.cwd = folder_name;
end
guidata(hObject, handles);
update_listbox(hObject, eventdata, handles)
update_plot(hObject, eventdata, handles)

function update_listbox(hObject, eventdata, handles)
handles = guidata(hObject);
strcat(handles.cwd, '\*.csv');
csv_cell = {};
handles.csv_files = struct([]);
handles.csv_files = dir(strcat(handles.cwd, '\*.csv'));
for i = 1:numel(handles.csv_files)
  csv_cell{i} = handles.csv_files(i).name;
end
set(handles.csv_listbox,'String', csv_cell)
set(handles.foldername_text,'string',handles.cwd);
guidata(hObject, handles);
update_plot(hObject, eventdata, handles)


% --- Executes on selection change in csv_listbox.
function csv_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to csv_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% --- Executes during object creation, after setting all properties.
function csv_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in legend_check.
function legend_check_Callback(hObject, eventdata, handles)
handles.legend = get(hObject,'Value');
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes on button press in latex_check.
function latex_check_Callback(hObject, eventdata, handles)
handles.interpreter = 'none'
if get(hObject,'Value') == 1
    handles.interpreter = 'latex'
end
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);



function delimiter_edit_text_Callback(hObject, eventdata, handles)
handles.delimiter = get(hObject,'String');
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function delimiter_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_min_edit_text_Callback(hObject, eventdata, handles)
handles.x_min = str2double(get(hObject,'String'));
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function x_min_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_max_edit_text_Callback(hObject, eventdata, handles)
handles.x_max = str2double(get(hObject,'String'));
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function x_max_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_min_edit_text_Callback(hObject, eventdata, handles)
handles.y_min = str2double(get(hObject,'String'));
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function y_min_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_max_edit_text_Callback(hObject, eventdata, handles)
handles.y_max = str2double(get(hObject,'String'));
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function y_max_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function index_edit_text_Callback(hObject, eventdata, handles)
handles.index = str2double(get(hObject,'String'));
guidata(hObject, handles);
update_plot(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function index_edit_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end