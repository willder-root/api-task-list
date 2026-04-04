unit connection.factory.interfaces;

interface

uses
  FireDAC.Comp.Client;

type
  IConnectionFactory = interface
    ['{412FD7A7-1A78-49D9-8BCB-06FB4A3F9B8A}']
    function CreateConnection: TFDConnection;
  end;

implementation

end.
