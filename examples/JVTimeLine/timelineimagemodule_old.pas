unit TimelineImageModule_old;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls;

type

  { TImageModuleOld }

  TImageModule = class(TDataModule)
    ImageList1: TImageList;
    ImageList2: TImageList;
  private

  public

  end;

var
  ImageModule: TImageModule;

implementation

{$R *.lfm}

end.

