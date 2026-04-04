unit query.factory;

interface

uses
  QueryInterface,
  query.factory.interfaces,
  connection.factory.interfaces;

type
  TQueryFactory = class(TInterfacedObject, IQueryFactory)
  private
    FConnectionFactory: IConnectionFactory;
  public
    constructor Create;
    function CreateQuery: IQuery;
    class function New: IQueryFactory;
  end;

implementation

uses
  Query,
  connection.factory.firedac;

constructor TQueryFactory.Create;
begin
  inherited Create;
  FConnectionFactory := TFireDACConnectionFactory.New;
end;

function TQueryFactory.CreateQuery: IQuery;
begin
  Result := TQuery.StartQuery(FConnectionFactory.CreateConnection);
end;

class function TQueryFactory.New: IQueryFactory;
begin
  Result := Self.Create;
end;

end.
