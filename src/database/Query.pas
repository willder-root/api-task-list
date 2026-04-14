unit Query;

interface

  uses
    QueryInterface,
    Data.DB,
    System.Classes,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option,
    FireDAC.Stan.Error,
    FireDAC.UI.Intf,
    FireDAC.Phys.Intf,
    FireDAC.Stan.Def,
    FireDAC.Stan.Pool,
    FireDAC.Stan.Async,
    FireDAC.Phys,
    FireDAC.Comp.Client,
    FireDAC.Phys.FB,
    FireDAC.Phys.FBDef,
    FireDAC.Phys.IBBase,
    FireDAC.Stan.Param,
    FireDAC.DatS,
    FireDAC.DApt.Intf,
    FireDAC.DApt,
    FireDAC.Comp.DataSet;

  type
    TQuery = class(TInterfacedObject, iQuery)
      private
        FConnection: TFDConnection;
        FQuery: TFDQuery;
      public
        constructor create(connection:TFDConnection);
        destructor destroy; override;
        function Open(Value: string): IQuery;overload;
        function Open: IQuery; overload;
        function Query: TFDQuery;
        function Clear: IQuery;
        function Close: IQuery;
        function Add(Value: string): IQuery;
        function AddParam(Param: string; Value: string): IQuery;  overload;
        function AddParam(Param: string; Value: Integer ): IQuery; overload;
        function AddParam(Param: string; Value: TDateTime): IQuery; overload;
        function AddParam(Param: string; Value: Boolean): IQuery; overload;
        function AddParam(Param: string; Value: TmemoryStream): IQuery; overload;
        function AddParamNullValuePlus(Param, Campo: string):IQuery;
        function ParamLoadFromFile(Param: string; FilePath: string): IQuery;
        function ExecSQL: IQuery;
        function DataSet: TDataSet;
        procedure Commit;
        class function StartQuery(connection:TFDConnection): IQuery;
    end;

implementation

{ TQuery }

function TQuery.Add(Value: string): IQuery;
begin
  Result := self;
  FQuery.SQL.Add(value);
end;

function TQuery.AddParam(Param: string; Value: Boolean): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).AsBoolean := Value;
end;

function TQuery.AddParam(Param: string; Value: TDateTime): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).AsDateTime := Value;
end;

function TQuery.AddParam(Param: string; Value: Integer): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).AsInteger := Value
end;

function TQuery.AddParam(Param, Value: string): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).AsString := Value;
end;

function TQuery.AddParam(Param: string; Value: TmemoryStream): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).LoadFromStream(value, ftBlob);
end;

function TQuery.AddParamNullValuePlus(Param, Campo: string):IQuery;
begin
  Result := Self;
  if (Campo = '') then
  begin
    FQuery.ParamByName(Param).Clear;
  end else
  begin
    FQuery.ParamByName(Param).AsString := Campo;
  end;
end;

function TQuery.Clear: IQuery;
begin
  Result := self;
  FQuery.SQL.Clear;
end;

function TQuery.Close: IQuery;
begin
  Result := self;
  FQuery.Close;
end;

procedure TQuery.Commit;
begin
  FQuery.Connection.Commit;
end;

constructor TQuery.create(connection: TFDConnection);
begin
  FConnection := connection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

function TQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

destructor TQuery.destroy;
begin
  FConnection.Free;
  FConnection := nil;
  FQuery.Free;
  FQuery := nil;
  inherited;
end;

function TQuery.ExecSQL: IQuery;
begin
  result:= Self;
  FQuery.ExecSQL;
end;

function TQuery.Open(Value: string): IQuery;
begin
  Result := self;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Text := value;
  FQuery.Open;
end;

function TQuery.Open: IQuery;
begin
  Result := self;
  FQuery.Open;
end;

function TQuery.ParamLoadFromFile(Param, FilePath: string): IQuery;
begin
  Result := self;
  FQuery.ParamByName(param).LoadFromFile(FilePath,ftBlob);
end;

function TQuery.Query: TFDQuery;
begin
  Result := FQuery;
end;

class function TQuery.StartQuery(connection: TFDConnection): IQuery;
begin
  Result := Self.create(connection);
end;

end.
