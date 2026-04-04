unit task.repository.interfaces;

interface

uses
  task.types;

type
  ITaskRepository = interface
    ['{1CD9FE2D-AC6B-464A-B3B6-16161947647D}']
    function findById(id: integer): TTask;
    function findAll(Filter: RTaskFilter): TTaskList;
    function Update(id: integer; taskUpdate: TTaskUpdated): TTask;
    function Insert(taskInsert: TTaskInsert): TTask;
    function Delete(id: integer): TTask;
  end;

implementation

end.
