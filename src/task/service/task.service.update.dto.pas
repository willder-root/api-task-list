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
var
  validationErrors: TStringList;
begin
  validationErrors := TStringList.Create;
  try
    if Trim(FTitle).IsEmpty then
      validationErrors.Add('Title is required.');

    if FStartedAt <= 0 then
      validationErrors.Add('StartedAt is required.');

    if FFinishedAt <= 0 then
      validationErrors.Add('FinishedAt is required.');

    if not (Integer(FStatus) in [Integer(Low(TTaskStatus))..Integer(High(TTaskStatus))]) then
      validationErrors.Add('Status is required.');

    if validationErrors.Count > 0 then
      raise Exception.Create(validationErrors.Text.Trim);
  finally
    validationErrors.Free;
  end;
end;

end.
