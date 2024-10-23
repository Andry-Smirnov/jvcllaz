unit JvInterpreterCallFunctionFm;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Dialogs, SynEdit, SynHighlighterPas, LCLVersion,
  JvInterpreter;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    JvInterpreterProgram1: TJvInterpreterProgram;
    SynPasSyn1: TSynPasSyn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JvInterpreterProgram1GetValue(Sender: TObject;
      Identifier: String; var Value: Variant; Args: TJvInterpreterArgs;
      var Done: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    JvHLEditor: TSynEdit;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Args: TJvInterpreterArgs;
begin
  { before we get here, JvInterpreterProgram1.Pas is already set to show the text in the HLEditor. }
  Assert(JvInterpreterProgram1.Pas.Count>0);


  { THIS IS ONLY ONE POSSIBLE WAY TO CALL CallFunction! Look at both ways please. }

  {Args is a temporary argument data holder object}
  Args := TJvInterpreterArgs.Create;
  try
    Args.Count := 1;
    Args.Values[0] := 'SomeText';
    JvInterpreterProgram1.CallFunction( 'MyFunction', Args, []);
    { show result to user:}
    Edit1.Text := VarToStr( JvInterpreterProgram1.VResult );
  finally
    Args.Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  { move program text over to interpreter! }
  JvInterpreterProgram1.Pas.Assign(JvHLEditor.Lines);
end;

procedure TForm1.JvInterpreterProgram1GetValue(Sender: TObject;
  Identifier: String; var Value: Variant; Args: TJvInterpreterArgs;
  var Done: Boolean);
begin
  Identifier := UpperCase(Identifier);

  if (Identifier='LENGTH') and (ARgs.Count=1) and (VarIsStr(Args.Values[0])) then
  begin
    Value := Length(ARgs.Values[0]);
    Done := true;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Param1,Param2:Variant;
begin
  { before we get here, JvInterpreterProgram1.Pas is already set to show the text in the HLEditor. }
  Assert(JvInterpreterProgram1.Pas.Count>0);

  { Alternative method without creating/freeing JvInterpreter args is to use Params instead, but not Args:}
  Param1 :=  10;
  Param2 := 20;
  JvInterpreterProgram1.CallFunction( 'MyFunction2', nil, [Param1,Param2]  );

  { show result to user:}
  Edit1.Text := VarToStr( JvInterpreterProgram1.VResult );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  JvHLEditor := TSynEdit.Create(self);
  with JvHLEditor do
  begin
    Parent := self;
    AnchorSideLeft.Control := self;
    AnchorSideTop.Control := Button2;
    AnchorSideTop.Side := asrBottom;
    AnchorSideRight.Control := self;
    AnchorSideRight.Side := asrBottom;
    AnchorSideBottom.Control := Self;
    AnchorSideBottom.Side := asrBottom;
    BorderSpacing.Left := 12;
    BorderSpacing.Top := 8;
    BorderSpacing.Right := 12;
    BorderSpacing.Bottom := 12;
    Anchors := [akTop, akLeft, akRight, akBottom];
    Lines.Add('unit UserFunctions;');
    Lines.Add('');
    Lines.Add('// sample of a user-created-library of jvinterpreter functions that your compiled');
    Lines.Add('// program might access:');
    Lines.Add('');
    Lines.Add('');
    Lines.Add('// notice that there is no interface/implementation section in this ');
    Lines.Add('// interpreter-only unit.');
    Lines.Add('');
    Lines.Add('function MyFunction(B:String):Integer;');
    Lines.Add('begin');
    Lines.Add('  result := Length(B);');
    Lines.Add('end;');
    Lines.Add('');
    Lines.Add('function MyFunction2(A,B:Integer):Integer;');
    Lines.Add('begin');
    Lines.Add('  result := A+B;');
    Lines.Add('end;');
    Lines.Add('');
    Lines.Add('');
    Lines.Add('end.');
    Highlighter := SynPasSyn1;
  end;
 {$IF LCL_FullVersion >= 2010000}
  JvHLEditor.ScrollOnEditLeftOptions.ScrollExtraMax := 10;
  JvHLEditor.ScrollOnEditLeftOptions.ScrollExtraPercent := 20;
  SynPasSyn1.Typehelpers := true;
 {$ENDIF}
end;


end.
