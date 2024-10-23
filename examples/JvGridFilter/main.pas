unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  JvGridFilter;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnFilter: TButton;
    btnResetFilter: TButton;
    edFilter: TEdit;
    JvGridFilter: TJvGridFilter;
    lblSomeFamousPeople: TLabel;
    Label2: TLabel;
    lblFilter: TLabel;
    StringGrid: TStringGrid;
    procedure btnFilterClick(Sender: TObject);
    procedure btnResetFilterClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnFilterClick(Sender: TObject);
begin
  JvGridFilter.Filter(edFilter.Text);
end;

procedure TForm1.btnResetFilterClick(Sender: TObject);
begin
  JvGridFilter.ShowRows;
end;

end.

