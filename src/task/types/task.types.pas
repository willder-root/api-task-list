unit task.types;

interface

uses
  system.generics.collections,
  system.sysutils,
  typInfo,
  GBSwagger.Model.Attributes;

type
  TTaskStatus = ( PENDING,
                  FINISH);

  TTaskStatusHelper = record helper for TTaskStatus
    function ToString: string;
    function ToEnum(value: string): TTaskStatus; overload;
    function ToEnum(value: integer): TTaskStatus; overload;
  end;

  TTask = class
  private
    FId: integer;
    FTitle: string;
    FStartedAt: TDateTime;
    FFinishedAt: TDateTime;
    FStatus: TTaskStatus;
    FCreatedAt: TDateTime;
    FUpdatedAt: TDateTime;
    FDeletedAt: TDateTime;
  published
    property Id: integer read FId write FId;
    property Title: string read FTitle write FTitle;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property StartedAt: TDateTime read FStartedAt write FStartedAt;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property FinishedAt: TDateTime read FFinishedAt write FFinishedAt;
    property Status: TTaskStatus read FStatus write FStatus;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
  end;

  TTaskList = class
  private
    FTasks: TObjectList<TTask>;
  published
    property Tasks: TObjectList<TTask> read FTasks write FTasks;
  end;

  TTaskInsert = class
  private
    FFinishedAt: TDateTime;
    FTitle: string;
    FStatus: TTaskStatus;
    FStartedAt: TDateTime;
  published
    property Title: string read FTitle write FTitle;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property StartedAt: TDateTime read FStartedAt write FStartedAt;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property FinishedAt: TDateTime read FFinishedAt write FFinishedAt;
    property Status: TTaskStatus read FStatus write FStatus;
  end;

  TTaskUpdated = class
  private
    FFinishedAt: TDateTime;
    FTitle: string;
    FStatus: TTaskStatus;
    FStartedAt: TDateTime;
  published
    property Title: string read FTitle write FTitle;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property StartedAt: TDateTime read FStartedAt write FStartedAt;
    [SwagDate('dd/mm/yyyy hh:mm:ss')]
    property FinishedAt: TDateTime read FFinishedAt write FFinishedAt;
    property Status: TTaskStatus read FStatus write FStatus;
  end;

  RTaskFilter = record
    Title: string;
    DateStart: TDate;
    HasStatus: Boolean;
    Status: TTaskStatus;
  end;

implementation

{ TTaskStatusHelper }

function TTaskStatusHelper.ToEnum(value: string): TTaskStatus;
begin
  Result := TTaskStatus(GetEnumValue(TypeInfo(TTaskStatus), UpperCase(value)));
end;

function TTaskStatusHelper.ToEnum(value: integer): TTaskStatus;
begin
  Result := TTaskStatus(value);
end;

function TTaskStatusHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TTaskStatus), Integer(Self));
end;

end.
