unit JvRuntimeDesignReg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 
  
procedure Register;

implementation

{$R ../../resource/jvruntimedesign.res}

uses
  JvDsgnConsts, JvDesignSurface;

procedure Register;
begin
  RegisterComponents(RsPaletteJvclVisual, [//RsPaletteRuntimeDesign, [
    TJvDesignSurface, 
    TJvDesignScrollBox, 
    TJvDesignPanel
  ]);
end;

end.

