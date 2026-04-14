unit basicAuth.config;

interface

uses
  system.sysutils;

type
  TBasicAuthConfig = class
  private
    FUsername: string;
    FPassWord: string;
    constructor create;
    destructor destroy; override;
  public
    property Username: string read FUsername;
    property PassWord: string read FPassWord;
    class function Instance: TBasicAuthConfig;
  end;

implementation

uses
  UAcessoIni;

var
  FInstance: TBasicAuthConfig = nil;

{ TBasicAuthConfig }
constructor TBasicAuthConfig.create;
var
  lConfig: IAcessoIni;
begin
  lConfig := TAcessoIni.New;
  FUsername := lConfig.LerStringIni('AUTH','USERNAME');
  FPassword := lConfig.LerStringIni('AUTH','PASSWORD');
end;

destructor TBasicAuthConfig.destroy;
begin
  inherited;
end;

class function TBasicAuthConfig.Instance: TBasicAuthConfig;
begin
  if not Assigned(FInstance) then
    FInstance := Self.create;
  Result := FInstance;
end;

initialization

finalization
  if Assigned(FInstance) then
    FreeAndNil(FInstance);
end.
