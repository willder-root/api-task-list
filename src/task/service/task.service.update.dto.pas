unit task.service.update.dto;

interface

uses
  System.Classes,
  System.SysUtils,
  task.types;

type
  TTaskUpdateDTO = class
  private
    FFinishedAt: TDateTime;
    FTitle: string;
    FStatus: TTaskStatus;
    FStartedAt: TDateTime;
  public
    constructor Create(taskUpdate: TTaskUpdated);
    procedure Validate;
  end;

implementation

{ TTaskUpdateDTO }

constructor TTaskUpdateDTO.Create(taskUpdate: TTaskUpdated);
begin
  inherited Create;
  if not Assigned(taskUpdate) then
    raise Exception.Create('TaskUpdate is required.');

  FTitle := taskUpdate.Title;
  FStartedAt := taskUpdate.StartedAt;
  FFinishedAt := taskUpdate.FinishedAt;
  FStatus := taskUpdate.Status;
end;

procedure TTaskUpdateDTO.Validate;
begin
  if Trim(FTitle).IsEmpty then
    raise Exception.Create('Title is required.');

  if FStartedAt <= 0 then
    raise Exception.Create('StartedAt is required.');

  if FFinishedAt <= 0 then
    raise Exception.Create('FinishedAt is required.');

  if not (Integer(FStatus) in [Integer(Low(TTaskStatus))..Integer(High(TTaskStatus))]) then
    raise Exception.Create('Status is required.');
end;

end.
