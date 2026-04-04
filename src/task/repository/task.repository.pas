unit task.repository;

interface

uses
  repository.base,
  task.repository.interfaces,
  query.Factory.Interfaces,
  queryInterface,
  task.types;

type
  TTaskRepository = class(TRepositoryBase, ITaskRepository)
  private
    function MapTask(Aquery: IQuery): TTask;
  public
    function findById(id: integer): TTask;
    function findAll(Filter: RTaskFilter): TTaskList;
    function Update(id: integer; taskUpdate: TTaskUpdated): TTask;
    function Insert(taskInsert: TTaskInsert): TTask;
    function Delete(id: integer): TTask;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  Data.DB;

const
  QUERY_TASK =
  'SELECT                  ' + sLineBreak +
  '    TASK.ID,            ' + sLineBreak +
  '    TASK.TITLE,         ' + sLineBreak +
  '    TASK.STARTEDAT,     ' + sLineBreak +
  '    TASK.FINISHEDAT,    ' + sLineBreak +
  '    TASK.STATUS,        ' + sLineBreak +
  '    TASK.CREATEDAT,     ' + sLineBreak +
  '    TASK.UPDATEDAT,     ' + sLineBreak +
  '    TASK.DELETEDAT      ' + sLineBreak +
  'FROM                    ' + sLineBreak +
  '    TASK                ' + sLineBreak +
  'WHERE                   ' + sLineBreak +
  '    (1 = 1)             ';

{ TTaskRepository }

function TTaskRepository.Delete(id: integer): TTask;
var
  qryDelete: IQuery;
begin
  Result := findById(id);
  if not Assigned(Result) then
    Exit(nil);

  qryDelete := FQueryFactory.CreateQuery;
  try
    qryDelete
      .Add('DELETE FROM TASK')
      .Add('WHERE TASK.ID = :P_ID')
      .AddParam('P_ID', id)
      .ExecSQL;
  finally
    qryDelete.Close;
  end;
end;

function TTaskRepository.findAll(Filter: RTaskFilter): TTaskList;
var
  qryPesquisa: IQuery;
begin
  Result := TTaskList.Create;
  Result.Tasks := TObjectList<TTask>.Create(True);

  qryPesquisa := FQueryFactory.CreateQuery;
  try
    qryPesquisa
      .Add(QUERY_TASK)
      .Add(' AND (TASK.DELETEDAT IS NULL)');

    if not Filter.Title.Trim.IsEmpty then
      qryPesquisa
        .Add(' AND (TASK.TITLE CONTAINING :P_TITLE)')
        .AddParam('P_TITLE', Filter.Title.Trim);

    if Filter.StartedAt > 0 then
      qryPesquisa
        .Add(' AND (TASK.STARTEDAT = :P_STARTEDAT)')
        .AddParam('P_STARTEDAT', Filter.StartedAt);

    if Filter.HasStatus then
      qryPesquisa
        .Add(' AND (TASK.STATUS = :P_STATUS)')
        .AddParam('P_STATUS', Integer(Filter.Status));

    qryPesquisa.Open;
    while not qryPesquisa.DataSet.Eof do
    begin
      Result.Tasks.Add(MapTask(qryPesquisa));
      qryPesquisa.DataSet.Next;
    end;
  finally
    qryPesquisa.Close;
  end;
end;

function TTaskRepository.findById(id: integer): TTask;
var
  qryPesquisa: IQuery;
begin
  Result := nil;
  qryPesquisa := FQueryFactory.CreateQuery;
  try
    qryPesquisa
      .Add(QUERY_TASK)
      .Add(' AND (TASK.ID = :P_ID)')
      .AddParam('P_ID', id)
      .Open;
    if not qryPesquisa.DataSet.Eof then
      Result := Self.MapTask(qryPesquisa);
  finally
    qryPesquisa.Close;
  end;
end;

function TTaskRepository.Insert(taskInsert: TTaskInsert): TTask;
var
  qryInsert: IQuery;
  id: Integer;
begin
  qryInsert := FQueryFactory.CreateQuery;
  try
    qryInsert
      .Add('INSERT INTO TASK (TITLE, STARTEDAT, FINISHEDAT, STATUS)')
      .Add('VALUES (:P_TITLE, :P_STARTEDAT, :P_FINISHEDAT, :P_STATUS)')
      .Add('RETURNING ID')
      .AddParam('P_TITLE', taskInsert.Title)
      .AddParam('P_STATUS', Integer(taskInsert.Status));

    if taskInsert.StartedAt > 0 then
      qryInsert.AddParam('P_STARTEDAT', taskInsert.StartedAt)
    else
      qryInsert.Query.ParamByName('P_STARTEDAT').Clear;

    if taskInsert.FinishedAt > 0 then
      qryInsert.AddParam('P_FINISHEDAT', taskInsert.FinishedAt)
    else
      qryInsert.Query.ParamByName('P_FINISHEDAT').Clear;

    qryInsert.Open;
    id := qryInsert.DataSet.FieldByName('ID').AsInteger;
    Result := findById(id);
  finally
    qryInsert.Close;
  end;
end;

function TTaskRepository.MapTask(Aquery: IQuery): TTask;
var
  LDataSet: TDataSet;
begin
  LDataSet := Aquery.DataSet;

  Result := TTask.Create;
  Result.Id := LDataSet.FieldByName('ID').AsInteger;
  Result.Title := LDataSet.FieldByName('TITLE').AsString;
  Result.Status := Result.Status.ToEnum(LDataSet.FieldByName('STATUS').AsInteger);

  if not LDataSet.FieldByName('STARTEDAT').IsNull then
    Result.StartedAt := LDataSet.FieldByName('STARTEDAT').AsDateTime;

  if not LDataSet.FieldByName('FINISHEDAT').IsNull then
    Result.FinishedAt := LDataSet.FieldByName('FINISHEDAT').AsDateTime;

  if not LDataSet.FieldByName('CREATEDAT').IsNull then
    Result.CreatedAt := LDataSet.FieldByName('CREATEDAT').AsDateTime;

  if not LDataSet.FieldByName('UPDATEDAT').IsNull then
    Result.UpdatedAt := LDataSet.FieldByName('UPDATEDAT').AsDateTime;

  if not LDataSet.FieldByName('DELETEDAT').IsNull then
    Result.DeletedAt := LDataSet.FieldByName('DELETEDAT').AsDateTime;
end;

function TTaskRepository.Update(id: integer; taskUpdate: TTaskUpdated): TTask;
var
  qryUpdate: IQuery;
begin
  qryUpdate := FQueryFactory.CreateQuery;
  try
    qryUpdate
      .Add('UPDATE TASK')
      .Add('SET TITLE = :P_TITLE,')
      .Add('    STARTEDAT = :P_STARTEDAT,')
      .Add('    FINISHEDAT = :P_FINISHEDAT,')
      .Add('    STATUS = :P_STATUS')
      .Add('WHERE TASK.ID = :P_ID')
      .AddParam('P_ID', id)
      .AddParam('P_TITLE', taskUpdate.Title)
      .AddParam('P_STATUS', Integer(taskUpdate.Status));

    if taskUpdate.StartedAt > 0 then
      qryUpdate.AddParam('P_STARTEDAT', taskUpdate.StartedAt)
    else
      qryUpdate.Query.ParamByName('P_STARTEDAT').Clear;

    if taskUpdate.FinishedAt > 0 then
      qryUpdate.AddParam('P_FINISHEDAT', taskUpdate.FinishedAt)
    else
      qryUpdate.Query.ParamByName('P_FINISHEDAT').Clear;

    qryUpdate.ExecSQL;
    Result := findById(id);
  finally
    qryUpdate.Close;
  end;
end;

end.
