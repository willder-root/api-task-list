unit Connection;

interface

  uses
    FireDAC.Comp.Client;

  type
    TConnectionDatabase = class
      class function New : TFDConnection;
    end;

implementation

 uses
    database.Config;

class function TConnectionDatabase.New : TFDConnection;
var
  databasePath: string;
  user: string;
  pass: string;
begin
  with TDatabaseConfig.Instance do
  begin
    databasePath := Host + ':' + Path;
    user := UserName;
    pass := Password;
  end;

  Result := TFDConnection.Create(nil);
  Result.Params.DriverID := 'FB';
  Result.Params.Database := databasePath;
  Result.Params.UserName := user;
  Result.Params.Password := pass;
  Result.Params.Add('CharacterSet=utf8');

end;

end.

