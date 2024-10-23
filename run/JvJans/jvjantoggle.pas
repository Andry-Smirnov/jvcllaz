unit JvJanToggle;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons;

type
  TOnToggleChange = procedure (Sender: Tobject; AState: boolean) of object;

  TToggleColor = (tcRed, tcGreen, tcYellow, tcBlue, tcPurple);
  TToggleStyle = (tsVertical, tsHorizontal);
  TButtonStyle = (bsSquare, bsRound);

  TJvJanToggle = class(TGraphicControl)
  private
    FOnToggleChange: TOnToggleChange;
    FToggleState: boolean;
    FIn, FOut: TRect;
    FInColor: TToggleColor;
    FOutColor: TToggleColor;
    FBackLit: boolean;
    FMarking: boolean;
    FToggleStyle: TToggleStyle;
    FInCap: string;
    FOutCap: string;
    FButtonStyle: TButtonStyle;
    FWidthChanged: Boolean;
    FHeightChanged: Boolean;
    procedure DoToggleChange;
    function IsStoredInCap: Boolean;
    function IsStoredOutCap: Boolean;
    procedure SetToggleState(const AValue: boolean);
    procedure SetIncolor(const AValue: TToggleColor);
    procedure SetOutColor(const AValue: TToggleColor);
    procedure SetBackLit(const AValue: boolean);
    function FXcolor(AColor: TToggleColor; ABright: boolean): TColor;
    procedure SetMarking(const AValue: boolean);
    procedure SetToggleStyle(const AValue: TToggleStyle);
    procedure MakeStyle;
    procedure SetButtonStyle(const AValue: TButtonStyle);
    procedure SetInCap(const AValue: string);
    procedure SetOutCap(const AValue: string);

  protected
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
    procedure FontChanged(Sender: TObject); override;
    procedure Paint; override;
    procedure Resize; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ToggleMouseDown(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; X, Y: Integer);

  published
    property ToggleState: Boolean read FToggleState write SetToggleState default false;
    property ToggleStyle: TToggleStyle read FToggleStyle write SetToggleStyle default tsVertical;
    property ButtonStyle: TButtonStyle read FButtonstyle write SetButtonstyle default bsSquare;
    property BackLit: boolean read FBackLit write SetBackLit default false;
    property Marking: boolean read FMarking write SetMarking default true;
    property InColor: TToggleColor read FInColor write SetInColor default tcRed;
    property InCap: string read FInCap write SetInCap stored IsStoredInCap;
    property OutColor: TToggleColor read FOutColor write SetOutColor default tcGreen;
    property OutCap: string read FOutCap write SetOutCap stored IsStoredOutCap;

    property OnToggleChange: TOnToggleChange read FOnToggleChange write FOnToggleChange;

    property BorderSpacing;
    property Font;
  end;


implementation

{ TJvJanToggle }

constructor TJvJanToggle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 24;
  Height := 48;
  {
  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, CX, CY);
    }
  ControlStyle := ControlStyle + [csReplicatable];
  FButtonStyle := bsSquare;
  MakeStyle;
  OnMouseDown := @ToggleMouseDown;
  FInColor := tcRed;
  FoutColor := tcGreen;
  FBackLit := false;
  FMarking := true;
  FInCap := 'I';
  FOutCap := 'O';
end;

destructor TJvJanToggle.Destroy;
begin
 //mycode
  inherited Destroy;
end;

procedure TJvJanToggle.DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
  const AXProportion, AYProportion: Double);
begin
  inherited;
  if AMode in [lapAutoAdjustWithoutHorizontalScrolling, lapAutoAdjustForDPI] then
    MakeStyle;
end;

procedure TJvJanToggle.FontChanged(Sender: TObject);
begin
  inherited;
  Invalidate;
end;

function TJvJanToggle.IsStoredInCap: Boolean;
begin
  Result := FInCap <> 'I';
end;

function TJvJanToggle.IsStoredOutCap: Boolean;
begin
  Result := FOutCap <> 'O';
end;

procedure TJvJanToggle.MakeStyle;
begin
  case FToggleStyle of
    tsVertical:
      begin
        if FWidthChanged then
          SetBounds(Left, Top, Width, Width * 2)
        else
        if FHeightChanged then
          Setbounds(Left, Top, Height div 2, Height)
        else
          exit;
        FIn := Rect(1, 1, Width-1, Width-2);
        FOut := Rect(1, Width, Width-2, Height-2);
      end;
    tsHorizontal:
      begin
        if FWidthChanged then
          SetBounds(Left, Top, Width, Width div 2)
        else if FHeightChanged then
          SetBounds(Left, Top, Height * 2, Height)
        else
          exit;
        FIn := Rect(1, 1, Height-2, Height-2);
        FOut := Rect(Height, 1, Width-2, Height-2);
      end;
  end;
  Invalidate; //Refresh;
end;

procedure TJvJanToggle.DoToggleChange;
begin
  if Assigned(FOnToggleChange) then
    FOnToggleChange(self, FToggleState);
end;

procedure TJvJanToggle.ToggleMouseDown(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; X, Y: Integer);
var
  hit, lState: boolean;

  function InRect(x, y: Integer; ARect: TRect): boolean;
  begin
    Result := (x > ARect.Left) and
              (x < ARect.Right) and
              (y > ARect.Top) and
              (y < ARect.Bottom);
  end;

begin
  hit := false;
  if InRect(x, y, FIn) then begin
    hit := true;
    lState := true;
  end
  else if InRect(x, y, FOut) then begin
    hit := true;
    lState := false;
  end;
  if hit then
    ToggleState := lState;
end;

function TJvJanToggle.FXcolor(AColor: TToggleColor; ABright: boolean): TColor;
begin
  if ABright then
    case AColor of
      tcRed: Result := clRed;
      tcGreen: Result := clLime;
      tcYellow: Result := clYellow;
      tcBlue: Result := clAqua;
      tcPurple: Result := clFuchsia;
    end
  else
    case AColor of
      tcRed: Result := clMaroon;
      tcGreen: Result := clGreen;
      tcYellow: Result := clOlive;
      tcBlue: Result := clNavy;
      tcPurple: Result := clPurple;
    end;
end;

procedure TJvJanToggle.Paint;

  procedure DoLit(ARect: TRect; AColor: TToggleColor; ABright: boolean);
  var
    glass: TColor;
    mr: integer;
    x1, y1, x2, y2: integer;
  begin
    x1 := ARect.Left;
    y1 := ARect.Top;
    x2 := ARect.Right;
    y2 := ARect.Bottom;
    glass := FXColor(AColor, ABright);
    mr := 1;
    with Canvas do begin
      Pen.Style := psClear;
      Brush.Color := glass;
      case FButtonStyle of
        bsSquare:  Rectangle(x1+mr, y1+mr, x2, y2);
        bsRound:   Ellipse(x1+2, y1+2, x2-2, y2-2);
       end;
      Pen.Style := psSolid;
      if ABright then
        Pen.Color := clWhite
      else
        Pen.Color := FXColor(AColor, true);
      Arc(ARect.Left+3, ARect.Top+3, ARect.Right-3, ARect.Bottom-3,
          ARect.Left+12,ARect.Top+0, ARect.Left+0,  ARect.Top+16
      );
      Pen.Color := clBlack;
    end;
  end;

  procedure BtnCap(R: TRect; s: string; AColor: TToggleColor; ABright: boolean);
  var
    x, y, w, h: integer;
  begin
    with Canvas do begin
      Font.Assign(Self.Font);
      Font.Style := Font.Style + [fsBold];
      w := TextWidth(s);
      h := TextHeight(s);
      x := (R.Right - R.Left - w + 1) div 2;
      y := (R.Bottom - R.Top - h) div 2;
      Pen.Color := clBlack;
      Brush.Style := bsClear;
      if FBacklit then
        Font.Color := clBlack
      else
        Font.Color := FXColor(AColor, ABright);
      TextOut(R.Left + x, R.Top + y, s);
    end;
  end;

  procedure BtnDown(ARect: TRect; s: string; AColor: TToggleColor);
  var
    x1, y1, x2, y2: integer;
  begin
    x1 := ARect.Left;
    y1 := ARect.Top;
    x2 := ARect.Right;
    y2 := ARect.Bottom;
    with Canvas do begin
      case FButtonStyle of
        bsSquare:
          begin
            Brush.Color := $E0E0E0;
            FillRect(ARect);
            Pen.Color := clBlack;
            MoveTo(x1, y2);
            LineTo(x1, y1);
            LineTo(x2, y1);
            Pen.Color := clWhite;
            LineTo(x2, y2);
            LineTo(x1, y2);
          end;
        bsRound:
          begin
            Brush.Color := $E0E0E0;
            Pen.Color := clGray;
            Ellipse(x1, y1, x2, y2);
            Pen.Color := clBlack;
            Ellipse(x1+1, y1+1, x2-1, y2-1);
            Pen.Color := clWhite;
            Arc(x1+1, y1+1, x2-1, y2-1, x1, y2, x2, y1);
          end;
      end;
      if FBackLit then DoLit(ARect, AColor, true);
      if FMarking then BtnCap(ARect, s, AColor, true);
    end;
  end;

  procedure BtnUp(ARect: TRect; s: string; AColor: TTogglecolor);
  var
    x1, y1, x2, y2: integer;
  begin
    x1 := ARect.Left;
    y1 := ARect.Top;
    x2 := ARect.Right;
    y2 := ARect.Bottom;
    with Canvas do begin
      case FButtonStyle of
        bsSquare:
          begin
            Brush.Color := clSilver;
            FillRect(arect);
            Pen.Color := clWhite;
            MoveTo(ARect.Left, ARect.Bottom);
            LineTo(ARect.Left, ARect.Top);
            LineTo(ARect.Right, ARect.Top);
            Pen.Color := clBlack;
            LineTo(ARect.Right, ARect.Bottom);
            LineTo(ARect.Left, ARect.Bottom);
          end;
        bsRound:
          begin
            Brush.Color := clSilver;
            Pen.Color := clGray;
            Ellipse(x1, y1, x2, y2);
            Pen.Color := clBlack;
            Ellipse(x1+1, y1+1, x2-1, y2-1);
            Pen.Color := clWhite;
            Arc(x1+1, y1+1, x2-1, y2-1, x2, y1, x1, y2);
          end;
      end;
      if FBackLit then DoLit(ARect, AColor, false);
      if FMarking then BtnCap(ARect, s, AColor, false);
    end;
  end;

begin
  with Canvas do begin
    Brush.Color := clSilver;
    Pen.Color := clBlack;
    case FButtonStyle of
      bssquare: Rectangle(0, 0, Width, Height);
    end;
    if FToggleState then begin
      BtnDown(FIn, FInCap, FInColor);
      BtnUp(FOut, FOutCap, FOutColor);
    end
    else begin
      BtnUp(FIn, FInCap, FInColor);
      BtnDown(FOut, FOutCap, FOutColor);
    end;
  end;
end;

procedure TJvJanToggle.Resize;
begin
  inherited;
  MakeStyle;
end;

procedure TJvJanToggle.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FWidthChanged := AWidth <> Width;
  FHeightChanged := AHeight <> Height;
  inherited;
end;

procedure TJvJanToggle.SetToggleState(const AValue: boolean);
begin
  if AValue <> FToggleState then
  begin
    FToggleState := AValue;
    Refresh;
    DoToggleChange;
  end;
end;

procedure TJvJanToggle.SetInColor(const AValue: TToggleColor);
begin
  if FInColor <> AValue then begin
    FInColor := AValue;
    Refresh;
  end;
end;

procedure TJvJanToggle.SetOutColor(const AValue: TToggleColor);
begin
  if FOutColor <> AValue then begin
    FOutColor := AValue;
    Refresh;
  end;
end;

procedure TJvJanToggle.SetBackLit(const AValue: boolean);
begin
  if AValue <> FBackLit then begin;
    FBackLit := AValue;
    Refresh;
  end;
end;

procedure TJvJanToggle.SetMarking(const AValue: boolean);
begin
  if AValue <> FMarking then begin
    FMarking := AValue;
    Refresh;
  end;
end;

procedure TJvJanToggle.SetToggleStyle(const AValue: TToggleStyle);
begin
  if AValue <> FToggleStyle then begin
    FToggleStyle := AValue;
    MakeStyle;
  end;
end;

procedure TJvJanToggle.SetInCap(const AValue: string);
begin
  if AValue = '' then exit;
  if UpperCase(AValue[1]) <> FIncap then begin
    FInCap := UpperCase(AValue[1]);
    Refresh;
  end;
end;

procedure TJvJanToggle.SetOutCap(const AValue: string);
begin
  if AValue = '' then exit;
  if UpperCase(AValue[1]) <> FOutcap then begin
    FOutCap := UpperCase(AValue[1]);
    Refresh;
  end;
end;

procedure TJvJanToggle.SetButtonStyle(const AValue: TButtonStyle);
begin
  if AValue <> FButtonStyle then begin
    FButtonstyle := AValue;
    Refresh;
  end;
end;

end.
