unit QueryInterface;

interface
   uses
    data.DB,
    FireDAC.Comp.Client,
    classes;

  type
    IQuery = interface
      ['{B2A64A80-7CDC-4262-925B-979BA6B74C0D}']
      function Open(Value: string): IQuery;overload;
      function Open: IQuery;overload;
      function Query: TFDQuery;
      function Clear: IQuery;
      function Close: IQuery;
      function Add(Value: string): IQuery;
      function AddParam(Param: string; Value: string): IQuery;  overload;
      function AddParam(Param: string; Value: Integer ): IQuery; overload;
      function AddParam(Param: string; Value: TDateTime): IQuery; overload;
      function AddParam(Param: string; Value: Boolean): IQuery; overload;
      function AddParam(Param: string; Value: TmemoryStream): IQuery; overload;
      function ParamLoadFromFile(Param: string; FilePath: string): IQuery;
      function AddParamNullValuePlus(Param, Campo: string): IQuery;
      function ExecSQL: IQuery;
      function DataSet: TDataSet;
      procedure Commit;
    end;
implementation

end.

