unit repository.base;

interface

uses
  System.SysUtils,
  Query.factory.interfaces;

type
  TRepositoryBase = class(TInterfacedObject)
  protected
    FQueryFactory: IQueryFactory;
    function BuildContainsClause(const FieldName: string; const Values: TArray<Integer>): string;
  public
    constructor create(aQueryFactory: IQueryFactory);
  end;
implementation

{ TRepositoryAbstract }

function TRepositoryBase.BuildContainsClause(const FieldName: string; const Values: TArray<Integer>): string;
var
  I: Integer;
begin
  Result := '';
  for I := Low(Values) to High(Values) do
  begin
    if Result <> '' then
      Result := Result + ' OR ';
    Result := Result + 'CONTAINS(' + FieldName + ', ''' + IntToStr(Values[I]) + ''')';
  end;

  if not Result.IsEmpty then
    Result := '(' + Result + ')';
end;

constructor TRepositoryBase.create(aQueryFactory: IQueryFactory);
begin
  FQueryFactory := aQueryFactory;
end;

end.