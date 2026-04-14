unit task.controller;

interface

uses
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  Horse.GBSwagger.Controller,
  GBJSON.Interfaces,
  GBJSON.Helper,
  task.types,
  system.json;

type
  [SwagPath('Task','Endpoints de controle de tarefas')]
  TTaskController = class(THorseGBSwagger)
  public
    [SwagGET('{id}','Pesquisa uma tarefa pelo id', false)]
    [SwagParamPath('id','Id da tarefa')]
    [SwagResponse(200, TTask)]
    [SwagResponse(404)]
    procedure Show;

    [SwagGET('List','Lista tarefas', false)]
    [SwagParamQuery('Title','Titulo da tarefa')]
    [SwagParamQuery('DateStart','Data de inicio da tarefa. Formato dd/mm/yyyy')]
    [SwagParamQuery('Status','Situacao da tarefa')]
    [SwagResponse(200, TTaskList)]
    procedure List;

    [SwagPOST('Cria nova Tarefa', false)]
    [SwagParamBody('CreateTask', TTaskInsert)]
    [SwagResponse(201)]
    [SwagResponse(400)]
    procedure CreateTask;

    [SwagPUT('{id}','Atualiza uma Tarefa', false)]
    [SwagParamPath('id','Id da tarefa')]
    [SwagParamBody('Updatetask', TTaskUpdated)]
    [SwagResponse(200)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure UpdateTask;

    [SwagDelete('{id}','Apaga uma Tarefa', false)]
    [SwagParamPath('id','Id da tarefa')]
    [SwagResponse(200)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure DeleteTask;
  end;

implementation

uses
  System.SysUtils,
  Horse.Commons,
  Horse.Exception,
  task.service,
  task.service.interfaces;

{ TTaskController }

procedure TTaskController.CreateTask;
var
  taskInsert: TTaskInsert;
  taskService: ITaskService;
  task: TTask;
begin
  taskInsert := TTaskInsert.Create;
  try
    try
      taskInsert.FromJSONString(FRequest.Body);
    except
      on E: Exception do
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message);
    end;

    try
      taskService := TTaskService.Create;
      task := taskService.CreateTask(taskInsert);
    except
      on E: Exception do
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message);
    end;

    FResponse.Status(THTTPStatus.Created).Send<TJSONObject>(TJSONObject.Create);
  finally
    taskInsert.Free;
  end;
end;

procedure TTaskController.DeleteTask;
var
  taskService: ITaskService;
  task: TTask;
  id: Integer;
begin
  id := StrToIntDef(FRequest.Params['id'], 0);
  if id <= 0 then
    raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Id is required.');

  try
    taskService := TTaskService.Create;
    task := taskService.DeleteTask(id);
  except
    on E: Exception do
      if SameText(E.Message, 'Task not found.') then
        raise EHorseException.New.Status(THTTPStatus.NotFound).Error(E.Message)
      else if SameText(E.Message, 'Id is required.') then
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message)
      else
        raise;
  end;

  FResponse.Status(THTTPStatus.Ok).Send<TJSONObject>(TJSONObject.Create);
end;

procedure TTaskController.List;
var
  taskService: ITaskService;
  filter: RTaskFilter;
  taskList: TTaskList;
  dateStart: TDateTime;
  dateFormatSettings: TFormatSettings;
  statusValue: string;
begin
  filter.Title := FRequest.Query['Title'];
  filter.DateStart := 0;
  filter.HasStatus := False;
  filter.Status := PENDING;

  if not FRequest.Query['DateStart'].Trim.IsEmpty then
  begin
    dateFormatSettings := TFormatSettings.Create;
    dateFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    dateFormatSettings.DateSeparator := '/';

    if not TryStrToDate(FRequest.Query['DateStart'], dateStart, dateFormatSettings) then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('DateStart must be in dd/mm/yyyy format.');

    filter.DateStart := dateStart;
  end;

  statusValue := FRequest.Query['Status'].Trim;
  if not statusValue.IsEmpty then
  begin
    try
      filter.Status := filter.Status.ToEnum(statusValue);
      filter.HasStatus := True;
    except
      on E: Exception do
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message);
    end;
  end;

  taskService := TTaskService.Create;
  taskList := taskService.FindAll(filter);
  FResponse.Send<TJSONObject>(taskList.ToJSONObject).Status(THTTPStatus.Ok);
end;

procedure TTaskController.Show;
var
  taskService: ITaskService;
  task: TTask;
  id: Integer;
begin
  id := StrToIntDef(FRequest.Params['id'], 0);
  if id <= 0 then
    raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Id is required.');

  taskService := TTaskService.Create;
  task := taskService.FindById(id);
  if not Assigned(task) then
    raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Task not found.');

  FResponse.Send<TJSONObject>(task.ToJSONObject).Status(THTTPStatus.Ok);
  task := nil;
end;

procedure TTaskController.UpdateTask;
var
  taskUpdate: TTaskUpdated;
  taskService: ITaskService;
  task: TTask;
  id: Integer;
begin
  id := StrToIntDef(FRequest.Params['id'], 0);
  if id <= 0 then
    raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Id is required.');

  taskUpdate := TTaskUpdated.Create;
  try
    try
      taskUpdate.FromJSONString(FRequest.Body);
    except
      on E: Exception do
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message);
    end;

    try
      taskService := TTaskService.Create;
      task := taskService.UpdateTask(id, taskUpdate);
    except
      on E: Exception do
        raise EHorseException.New.Status(THTTPStatus.BadRequest).Error(E.Message);
    end;

    if not Assigned(task) then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Task not found.');

    FResponse.Status(THTTPStatus.Ok).Send<TJSONObject>(TJSONObject.Create);
  finally
    taskUpdate.Free;
  end;
end;

end.
