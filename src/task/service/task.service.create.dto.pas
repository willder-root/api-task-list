unit task.service.create.dto;

interface

uses
  System.Classes,
  System.SysUtils,
  task.types;

type
  TTaskCreateDTO = class
  private
    FFinishedAt: TDateTime;
    FTitle: string;
    FStatus: TTaskStatus;
    FStartedAt: TDateTime;
  public
    constructor Create(taskInsert: TTaskInsert);
    procedure Validate;
  end;

implementation

{ TTaskCreateDTO }

constructor TTaskCreateDTO.Create(taskInsert: TTaskInsert);
begin
  inherited Create;
  if not Assigned(taskInsert) then
    raise Exception.Create('TaskInsert is required.');

  FTitle := taskInsert.Title;
  FStartedAt := taskInsert.StartedAt;
  FFinishedAt := taskInsert.FinishedAt;
  FStatus := taskInsert.Status;
end;

procedure TTaskCreateDTO.Validate;
begin
  if Trim(FTitle).IsEmpty then
    raise Exception.Create('Title is required.');

  if FStartedAt <= 0 then
    raise Exception.Create('StartedAt is required.');

  if not (Integer(FStatus) in [Integer(Low(TTaskStatus))..Integer(High(TTaskStatus))]) then
    raise Exception.Create('Status is required.');
end;

end.
