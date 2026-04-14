unit documentation.config;
interface
uses
  Horse.GBSwagger,
  GBSwagger.Model.Config;
type
  TSwaggerConfig = class
  public
    class procedure InitializeConfig;
  end;
implementation
uses
  basicAuth.middleware;
{ TSwaggerConfig }
class procedure TSwaggerConfig.InitializeConfig;
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
    .AddBasicSecurity
      .AddCallback(BasicAuthMiddleware())
    .&End
    .BasePath('v1')
    .&End;
end;
end.
