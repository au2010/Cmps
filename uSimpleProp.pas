unit uSimpleProp;

{$I JEDI.INC}

interface

uses
{$IFDEF DELPHIXE2_UP}
	System.SysUtils, Vcl.Graphics, System.Types,
{$ELSE}
  SysUtils, Graphics,  Types,
{$ENDIF}
{$IFDEF DELPHI6_UP}
	DesignIntf, DesignEditors, VCLEditors
{$ELSE}
	Dsgnintf, DsgnWnds
{$ENDIF}
	;

type
 {$REGION 'Documentation'}
 ///	<summary>
 ///	  オブジェクトインスペクタ上にフォント名とフォントサイズを 設定したフォント設定で表示する。
 ///	</summary>
 ///	<remarks>
 ///	  <see cref="http://qc.embarcadero.com/wc/qcmain.aspx?d=108775">QC108775</see>
 ///	   がある為、ICustomPropertyDrawingだけではCustomDrawが有効化されないので
 ///	  ICustomPropertyDrawing80も併せて実装する
 ///	</remarks>
 {$ENDREGION}
	TAUFontProperty = class(TFontProperty, ICustomPropertyDrawing, ICustomPropertyDrawing80)
  public
		function GetValue: string; override;

    { ICustomPropertyDrawing }
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);

    { ICustomPropertyDrawing80 }
    function PropDrawNameRect(const ARect: TRect): TRect;
    function PropDrawValueRect(const ARect: TRect): TRect;
	end;

implementation

function TAUFontProperty.GetValue: string;
var
	vFont: TFont;
begin
	vFont := TFont(GetOrdValue);
	Result := '[' + vFont.Name + ' ' + IntToStr(vFont.Size) + ']';
end;

procedure TAUFontProperty.PropDrawName(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;

function TAUFontProperty.PropDrawNameRect(const ARect: TRect): TRect;
begin
  Result := ARect;
end;

procedure TAUFontProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
var
	vFont: TFont;
  vCanvasFont: TFont;
  vCanvasBrush: TBrush;

  SampleRect: TRect;
  FontRect: TRect;
  SampleStr: String;
begin
  vCanvasFont := TFont.Create;
  vCanvasFont.Assign(ACanvas.Font);

  vCanvasBrush := TBrush.Create;
  vCanvasBrush.Assign(ACanvas.Brush);

  ACanvas.FillRect(ARect);
	vFont := TFont(GetOrdValue);
  if Not ASelected then
  begin
    if ColorToRGB(vFont.Color) <> ColorToRGB(clWhite) then
      ACanvas.Font.Color := vFont.Color;
  end;
  ACanvas.Font.Name := vFont.Name;
  ACanvas.Font.Style := vFont.Style;
  ACanvas.Font.Size := 9;
  ACanvas.Brush.Color := clWhite;
  ACanvas.Brush.Style := bsSolid;

  SampleRect := Rect(ARect.Left, ARect.Top - 1, ARect.Left + 20, ARect.Bottom + 1);
  ACanvas.FillRect(SampleRect);
  SampleStr := 'Aaあア亜';
  ACanvas.TextRect(SampleRect, SampleStr, [tfSingleLine, tfVerticalCenter, tfCenter, tfCalcRect]);
  ACanvas.TextRect(SampleRect, SampleStr, [tfSingleLine, tfVerticalCenter, tfCenter]);

  FontRect := Rect(SampleRect.Right + 1, ARect.Top, ARect.Right, ARect.Bottom);
  ACanvas.Font.Assign(vCanvasFont);
  ACanvas.Brush.Assign(vCanvasBrush);
  DefaultPropertyDrawValue(Self, ACanvas, FontRect);
  vCanvasBrush.Free;
  vCanvasFont.Free;
end;

function TAUFontProperty.PropDrawValueRect(const ARect: TRect): TRect;
begin
  Result := ARect;
end;

end.
 