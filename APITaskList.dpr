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
  uAcessoIni in 'src\util\uAcessoIni.pas',
  task.repository.interfaces in 'src\task\repository\task.repository.interfaces.pas',
  repository.base in 'src\shared\repository\repository.base.pas',
  task.repository in 'src\task\repository\task.repository.pas',
  task.service.interfaces in 'src\task\service\task.service.interfaces.pas',
  task.service.create.dto in 'src\task\service\task.service.create.dto.pas',
  task.service.update.dto in 'src\task\service\task.service.update.dto.pas',
  task.service in 'src\task\service\task.service.pas',
  task.controller in 'src\task\controller\task.controller.pas',
  route in 'src\api\route\route.pas';

begin
  try
    TServer.Instance.Initialize;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
