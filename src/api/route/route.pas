unit route;

interface

uses
  Horse.GBSwagger.Register,
  task.controller;

type
  TRoute = class
    class procedure Resgiter;
  end;

implementation

{ TRoute }

class procedure TRoute.Resgiter;
begin
  THorseGBSwaggerRegister.RegisterPath(TTaskController);
end;

end.
