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
  end;

implementation

uses
  query.factory,
  task.repository,
  task.service.dto;

{ TTaskService }

constructor TTaskService.Create;
begin
  inherited Create;
  FTaskRepository := TTaskRepository.Create(TQueryFactory.New);
end;

function TTaskService.CreateTask(taskInsert: TTaskInsert): TTask;
var
  taskInsertDTO: TTaskInsertDTO;
begin
  taskInsertDTO := TTaskInsertDTO.Create(taskInsert);
  try
    taskInsertDTO.Validate;
    Result := FTaskRepository.Insert(taskInsert);
  finally
    taskInsertDTO.Free;
  end;
end;

end.
