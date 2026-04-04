unit server;

interface

uses
  system.sysutils;

type
  TServer = class
  private
    constructor create;
    destructor destroy; override;
  public
    procedure Initialize;
    procedure Stop;
    class function Instance: TServer;
  end;

implementation

uses
  horse,
  horse.cors,
  Horse.Jhonson,
  Horse.GBSwagger,
  documentation.config,
  route,
  GBJSON.Config;

var
  FInstance: TServer = nil;

{ TServer }

constructor TServer.create;
begin
  THorse
    .Use(CORS)
    .Use(Jhonson())
    .Use(HorseSWagger);
    TRoute.Resgiter;
    TGBJSONConfig.GetInstance.DateTimeFormat('dd/mm/yyyy');
    TGBJSONConfig.GetInstance.DateTimeLocale('pt-BR');
end;

destructor TServer.destroy;
begin

  inherited;
end;

procedure TServer.Initialize;
var
  Port: integer;
begin
  Port := 4040;
  Thorse.Listen(Port,
    procedure
    begin
      writeln(format('API runing in port: %d',[Port]));
    end)
end;

class function TServer.Instance: TServer;
begin
  if not Assigned(FInstance) then
    FInstance := Self.create;
end;

procedure TServer.Stop;
begin
  THorse.StopListen;
end;

initialization

finalization
  if Assigned(FInstance) then
    FreeAndNil(FInstance);

end.

