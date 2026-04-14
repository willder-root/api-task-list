unit Connection;

interface

  uses
    FireDAC.Comp.Client,
    FireDAC.Phys.FB,
    FireDAC.Phys,
    system.sysutils;

  type
    TConnectionDatabase = class
      class function New : TFDConnection;
    end;

implementation
uses
  database.Config;

var
  DriverLink : TFDPhysFBDriverLink = nil;

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
  Result.Params.Clear;
  Result.Params.Values['DriverID']    := 'FB';
  Result.Params.Values['Database']    := databasePath;
  Result.Params.Values['User_Name']   := user;
  Result.Params.Values['Password']    := pass;
  Result.Params.Values['CharacterSet']:= 'UTF8';


  // FORA o FireDAC a usar esta lib (caminho completo)
  Result.Params.Values['VendorLib']   := TDatabaseConfig.Instance.VendorLib;


end;

initialization
  if not Assigned(DriverLink) then
    DriverLink := TFDPhysFBDriverLink.Create(nil);
  DriverLink.VendorLib := TDatabaseConfig.Instance.VendorLib;

finalization
  if Assigned(DriverLink) then
    FreeAndNil(DriverLink);

end.

