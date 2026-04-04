unit task.service;

interface

uses
  task.repository.interfaces,
  task.service.interfaces,
  task.types;

type
  TTaskService = class(TInterfacedObject, ITaskService)
  private
    FTaskRepository: ITaskRepository;
  public
    constructor Create;
    function CreateTask(taskInsert: TTaskInsert): TTask;
    function UpdateTask(id: integer; taskUpdate: TTaskUpdated): TTask;
  end;

implementation

uses
  System.SysUtils,
  query.factory,
  task.repository,
  task.service.create.dto,
  task.service.update.dto;

{ TTaskService }

constructor TTaskService.Create;
begin
  inherited Create;
  FTaskRepository := TTaskRepository.Create(TQueryFactory.New);
end;

function TTaskService.CreateTask(taskInsert: TTaskInsert): TTask;
var
  taskCreateDTO: TTaskCreateDTO;
begin
  taskCreateDTO := TTaskCreateDTO.Create(taskInsert);
  try
    taskCreateDTO.Validate;
    Result := FTaskRepository.Insert(taskInsert);
  finally
    taskCreateDTO.Free;
  end;
end;

function TTaskService.UpdateTask(id: integer; taskUpdate: TTaskUpdated): TTask;
var
  taskUpdateDTO: TTaskUpdateDTO;
begin
  if id <= 0 then
    raise Exception.Create('Id is required.');

  taskUpdateDTO := TTaskUpdateDTO.Create(taskUpdate);
  try
    taskUpdateDTO.Validate;
    Result := FTaskRepository.Update(id, taskUpdate);
  finally
    taskUpdateDTO.Free;
  end;
end;

end.
