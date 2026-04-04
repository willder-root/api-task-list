unit uAcessoIni;

interface

  uses
    inifiles,
    classes,
    sysutils;

   type
   IAcessoIni = interface
     ['{71C57236-E5AD-4894-B5C1-31ADB4CF0F1E}']
      function LerStringIni(secao,chave: string):string;
      function LerIntegerIni(secao,chave: string):Integer;
      function LerBooleanIni(secao,chave: string):Boolean;
      procedure GravarStringIni(secao,chave, valor: string);
      procedure GravarIntegerIni(secao,chave: string; valor:Integer);
      procedure GravarBooleanIni(secao,chave: string; valor:Boolean);
   end;

    TAcessoIni = class(TInterfacedObject,IAcessoIni)
    private
      FConfigPath: string;
      Fini: TIniFile;
      function GetAcessIni: TIniFile;
      constructor create; overload;
      constructor create(configPath: string); overload;
      destructor destroy; override;
    public
      function LerStringIni(secao,chave: string):string;
      function LerIntegerIni(secao,chave: string):Integer;
      function LerBooleanIni(secao,chave: string):Boolean;
      procedure GravarStringIni(secao,chave, valor: string);
      procedure GravarIntegerIni(secao,chave: string; valor:Integer);
      procedure GravarBooleanIni(secao,chave: string; valor:Boolean);
      class function New: IAcessoIni; overload;
      class function New(configPath: string): IAcessoIni; overload;
    end;
implementation

{ AcessoIni }

constructor TAcessoIni.create;
begin
  FConfigPath := ExtractFilePath(ParamStr(0)) + 'config.ini';
end;

constructor TAcessoIni.create(configPath: string);
begin
  FConfigPath := configPath;
end;

destructor TAcessoIni.destroy;
begin

  inherited;
end;

function TAcessoIni.GetAcessIni: TIniFile;
begin
  result := TIniFile.Create(FConfigPath);
end;

procedure TAcessoIni.GravarBooleanIni(secao, chave: string;
  valor: Boolean);
var
  lIni: TIniFile;
begin
  Lini := nil;
  lIni := self.GetAcessIni;
  try
    lIni.WriteBool(secao, chave, valor);
  finally
    lIni.Free
  end;
end;

procedure TAcessoIni.GravarIntegerIni(secao, chave: string;
  valor: Integer);
var
  lIni: TIniFile;
begin
  lIni := nil;
  lIni := self.GetAcessIni;
  try
    lIni.WriteInteger(secao, chave, valor);
  finally
    lIni.Free
  end;
end;

procedure TAcessoIni.GravarStringIni(secao, chave, valor: string);
var
  lIni: TIniFile;
  CTIConfig: string;
begin
  lIni := nil;
  lIni := self.GetAcessIni;
  try
    lIni.WriteString(secao, chave, valor);
  finally
    lIni.Free
  end;
end;

function TAcessoIni.LerBooleanIni(secao, chave: string): Boolean;
var
  lIni: TIniFile;
begin
  lIni := self.GetAcessIni;
  try
    Result := lIni.ReadBool(secao, chave, false);
  finally
    lIni.Free
  end;
end;

function TAcessoIni.LerIntegerIni(secao, chave: string): Integer;
var
  lIni: TIniFile;
begin
  lIni := nil;
  lIni := self.GetAcessIni;
  try
    Result := lIni.ReadInteger(secao, chave, 0);
  finally
    lIni.Free
  end;
end;

function TAcessoIni.LerStringIni(secao, chave: string): string;
var
  lIni: TIniFile;
begin
  lIni := nil;
  lIni := self.GetAcessIni;
  try
    Result := lIni.ReadString(secao, chave, '') ;
  finally
    lIni.Free
  end;
end;

class function TAcessoIni.New: IAcessoIni;
begin
  Result := Self.create;
end;

class function TAcessoIni.New(configPath: string): IAcessoIni;
begin
  Result := Self.create(configPath);
end;

end.
