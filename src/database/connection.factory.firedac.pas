unit connection.factory.firedac;

interface

uses
  FireDAC.Comp.Client,
  connection.factory.interfaces;

type
  TFireDACConnectionFactory = class(TInterfacedObject, IConnectionFactory)
  public
    function CreateConnection: TFDConnection;
    class function New: IConnectionFactory;
  end;

implementation

uses
  Connection;

function TFireDACConnectionFactory.CreateConnection: TFDConnection;
begin
  Result := TConnectionDatabase.New;
end;

class function TFireDACConnectionFactory.New: IConnectionFactory;
begin
  Result := Self.Create;
end;

end.
