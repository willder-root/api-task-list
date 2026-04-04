unit query.factory.interfaces;

interface

uses
  QueryInterface;

type
  IQueryFactory = interface
    ['{DF681D17-5768-4330-9B49-CBB92542EB44}']
    function CreateQuery: IQuery;
  end;

implementation

end.
