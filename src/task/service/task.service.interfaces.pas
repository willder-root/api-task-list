unit task.service.interfaces;

interface

uses
  task.types;

type
  ITaskService = interface
    ['{786A0EA5-4715-4F44-A9A4-1781A2B3128E}']
    function FindById(id: Integer): TTask;
    function FindAll(const Filter: RTaskFilter): TTaskList;
    function CreateTask(taskInsert: TTaskInsert): TTask;
    function UpdateTask(id: integer; taskUpdate: TTaskUpdated): TTask;
    function DeleteTask(id: integer): TTask;
  end;

implementation

end.
