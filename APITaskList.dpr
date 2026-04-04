program APITaskList;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  server in 'server.pas',
  documentation.config in 'src\config\documentation.config.pas',
  task.types in 'src\task\types\task.types.pas',
  connection.factory.firedac in 'src\database\connection.factory.firedac.pas',
  connection.factory.interfaces in 'src\database\connection.factory.interfaces.pas',
  Connection in 'src\database\Connection.pas',
  query.factory.interfaces in 'src\database\query.factory.interfaces.pas',
  query.factory in 'src\database\query.factory.pas',
  Query in 'src\database\Query.pas',
  QueryInterface in 'src\database\QueryInterface.pas',
  database.config in 'src\config\database.config.pas',
  uAcessoIni in 'src\util\uAcessoIni.pas';

begin
  try
    TServer.Instance.Initialize;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
