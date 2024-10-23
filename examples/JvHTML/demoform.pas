unit DemoForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    btnFind: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    cbReplaceWith: TCheckBox;
    cbCaseSensitive: TCheckBox;
    cbWholeWordsOnly: TCheckBox;
    cbRegularExpressions: TCheckBox;
    cbMultilinePattern: TCheckBox;
    cbPromptOnReplace: TCheckBox;
    cmbReplaceWidth: TComboBox;
    edName: TEdit;
    gbOptions: TGroupBox;
    gbOrigin: TGroupBox;
    gbSearchScope: TGroupBox;
    gbDirection: TGroupBox;
    lblTextToFind: TLabel;
    rbFromCursor: TRadioButton;
    rbFromBeginning: TRadioButton;
    rbSelectedText: TRadioButton;
    rbGlobal: TRadioButton;
    rbBackwardSearch: TRadioButton;
    rbForwardSearch: TRadioButton;
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

end.

