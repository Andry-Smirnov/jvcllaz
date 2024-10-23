unit uFormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  JvWizard, JvWizardRouteMapNodes;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ImageList1: TImageList;
    JvWizard1: TJvWizard;
    JvWizardInteriorPage1: TJvWizardInteriorPage;
    JvWizardInteriorPage2: TJvWizardInteriorPage;
    JvWizardInteriorPage3: TJvWizardInteriorPage;
    JvWizardInteriorPage4: TJvWizardInteriorPage;
    JvWizardRouteMapNodes1: TJvWizardRouteMapNodes;
    JvWizardWelcomePage1: TJvWizardWelcomePage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    RadioButton1: TRadioButton;
    procedure JvWizard1ActivePageChanged(Sender: TObject);
    procedure JvWizard1CancelButtonClick(Sender: TObject);
    procedure JvWizard1FinishButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.JvWizard1CancelButtonClick(Sender: TObject);
begin
  if MessageDlg('Are you sure?', mtConfirmation, mbYesNo, 0) = mrYes then
    Close;
end;

procedure TForm1.JvWizard1FinishButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.JvWizard1ActivePageChanged(Sender: TObject);
begin
  JvWizardRouteMapNodes1.Visible := JvWizard1.ActivePage <> JvWizardWelcomePage1;
end;

end.

