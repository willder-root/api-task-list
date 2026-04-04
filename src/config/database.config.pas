unit database.config;

interface

uses
  system.sysutils;

type
  TDatabaseConfig = class
  private
    FHost: string;
    FPath: string;
    FUserName: string;
    FPassword: string;
    FVendorLib: string;
    constructor create;
    destructor destroy; override;
  public
    property Host: string read FHost;
    property Path: string read FPath;
    property UserName: string read FUserName;
    property Password: string read FPassword;
    property VendorLib: string read FVendorLib;
    class function Instance: TDatabaseConfig;
  end;

  

implementation

uses
  UAcessoIni;

var
  FInstance: TDatabaseConfig = nil;

{ TDatabaseConfig }

constructor TDatabaseConfig.create;
var
  lConfig: IAcessoIni;
begin
  lConfig := TAcessoIni.new;
  FHost:= lConfig.LerStringIni('DB','HOST');
  FPath:= lConfig.LerStringIni('DB','PATH');
  FUserName:= lConfig.LerStringIni('DB','USER'); 
  FPassword:= lConfig.LerStringIni('DB','PASS');
  FVendorLib:= lConfig.LerStringIni('DB','VENDORLIB');
end;

destructor TDatabaseConfig.destroy;
begin

  inherited;
end;

class function TDatabaseConfig.Instance: TDatabaseConfig;
begin
  if not assigned(FInstance) then
    FInstance := Self.create;
end;


initialization

finalization
  if Assigned(FInstance) then
    FreeAndNil(FInstance);
  
end.
