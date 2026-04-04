program APITaskList;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  server in 'server.pas',
  documentation.config in 'src\config\documentation.config.pas',
  task.types in 'src\task\types\task.types.pas';

begin
  try
    TServer.Instance.Initialize;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
