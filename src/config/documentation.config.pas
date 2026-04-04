unit documentation.config;

interface

uses
  Horse.GBSwagger,
  GBSwagger.Model.Config;

type
  TSwaggerConfig = class
  public
    procedure InitializeConfig;
  end;

implementation

{ TSwaggerConfig }

procedure TSwaggerConfig.InitializeConfig;
begin
  Swagger
    .Info
      .Title('APITaskList')
      .Description('API para gerenciamento de tarefas')
      .TermsOfService(' ')
      .License
        .URL(' ')
        .Name(' ')
      .&End
    .&End
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    .&End
    .BasePath('v1')
    .&End;

end;

end.
