unit basicAuth.middleware;

interface

uses
  horse,
  Horse.BasicAuthentication;

  function BasicAuthMiddleware: THorseCallback;

implementation

uses
  basicAuth.config;

function BasicAuthMiddleware: THorseCallback;
begin
  Result :=  HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := ( (AUsername = TBasicAuthConfig.instance.Username) and
      (APassword = TBasicAuthConfig.instance.Password) );
    end);

end;

end.
