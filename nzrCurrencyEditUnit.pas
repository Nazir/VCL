unit nzrCurrencyEditUnit;

{*****************************************************************}
{                                                                 }
{                     Модуль валюты с меткой                      }
{                                                                 }
{  Авторское право: Nazir Software © 2002-2011                    }
{  Разработчик: Хуснутдинов Назир Каримович  (Wild Pointer)       }
{  Модифицирован: 16.02.2007                                      }
{                                                                 }
{*****************************************************************}

interface

uses
  SysUtils, WinProcs, Messages, Classes, Controls, ExtCtrls, StdCtrls,
  nzrTypesUnit;

type
  TnzrCurrencyEdit = class(TCustomMemo)
  private
    FAbout: TAboutProperty;
    FDisplayFormat: string;
    FDisplayFormatType: TFormatType;
    FDisplayCurrency: TCurrencyFormat;
    FDisplayMinus: Boolean;
    FDisplayDecimalSeparator: Boolean;
    FValue: Extended;
    FMaxValue: Extended;
    FMinValue: Extended;
    function CheckValue (AValue: Extended): Extended;
    procedure SetDisplayFormat(AValue: string);
    procedure SetDisplayFormatType(const AValue: TFormatType);
    procedure SetDisplayCurrency(const AValue: TCurrencyFormat);
    procedure SetDisplayMinus(const AValue: Boolean);
    procedure SetDisplayDecimalSeparator(const AValue: Boolean);
    procedure SetValue(AValue: Extended);
    procedure FormatText;
    procedure UnFormatText;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TAboutProperty read FAbout write FAbout;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat;
    property DisplayFormatType: TFormatType read FDisplayFormatType write SetDisplayFormatType default ftCurrency;
    property DisplayCurrency: TCurrencyFormat read FDisplayCurrency write SetDisplayCurrency default cfRuble;
    property DisplayMinus: Boolean read FDisplayMinus write SetDisplayMinus default True;
    property DisplayDecimalSeparator: Boolean read FDisplayDecimalSeparator write SetDisplayDecimalSeparator default True;
    property Value: Extended read FValue write SetValue;
    property MaxValue: Extended read FMaxValue write FMaxValue;
    property MinValue: Extended read FMinValue write FMinValue;
    property Anchors;
    property AutoSelect;
    property BorderStyle;
    property CharCase;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property ParentBiDiMode;
    property Alignment default taRightJustify;
    property AutoSize default True;
    property Color;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

constructor TnzrCurrencyEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := True;
  Alignment := taRightJustify;
  Width := 75;
  Height := 21;

//  DispFormat := '$,0.00;($,0.00)';
  FDisplayFormat := '0.00, р.';
  FDisplayFormatType := ftCurrency;
  FDisplayCurrency := cfRuble;
  FValue := 0.0;
  FDisplayMinus := True;
  FDisplayDecimalSeparator := True;
  WantReturns := False;
  WordWrap := False;
  FormatText;
  //
//  nstComponentInfo := 'TnstCurrencyEdit';
end;

procedure TnzrCurrencyEdit.SetDisplayFormat(AValue: string);
begin
  if FDisplayFormat <> AValue then
  begin
    FDisplayFormat := AValue;
    FDisplayFormatType := ftCustom;
    FormatText;
  end;
end;

procedure TnzrCurrencyEdit.SetDisplayFormatType(
  const AValue: TFormatType);
begin
  if FDisplayFormatType = AValue then
    Exit;
  FDisplayFormatType := AValue;
  case FDisplayFormatType of
    ftCurrency:
    begin
      FDisplayFormat := '0.00, р.,';
      FDisplayDecimalSeparator := True;
    end;
    ftFloat:
    begin
      FDisplayFormat := '0.00';
      FDisplayDecimalSeparator := True;
    end;
    ftInteger:
    begin
      FDisplayFormat := '0';
      FDisplayDecimalSeparator := False;
    end;
  end;
  FormatText;
end;

procedure TnzrCurrencyEdit.SetDisplayCurrency(
  const AValue: TCurrencyFormat);
begin
  if FDisplayCurrency = AValue then
    Exit;
  FDisplayCurrency := AValue;
  FDisplayFormatType := ftCurrency;
  FDisplayDecimalSeparator := True;
  case FDisplayCurrency of
    cfRuble:
    begin
      FDisplayFormat := '0.00, р.,';
    end;
    cfUSD:
    begin
      FDisplayFormat := '$,0.00;($,0.00)';
    end;
    cfEuro:
    begin
      FDisplayFormat := '€,0.00;(€,0.00)';
    end;
  end;
  FormatText;
end;

procedure TnzrCurrencyEdit.SetValue(AValue: Extended);
begin
  if FValue <> AValue then
  begin
    FValue := CheckValue(AValue);
    FormatText;
  end;
  if Text = '' then
  begin
    FormatText;
    FValue := CheckValue(AValue);
  end;
end;

procedure TnzrCurrencyEdit.UnFormatText;
var
  TmpText: string;
  Tmp: Byte;
  IsNeg: Boolean;
  KeySet: set of Char;
begin
  IsNeg := (Pos('-', Text) > 0) or (Pos('(', Text) > 0);
  TmpText := '';
  KeySet := ['0'..'9'];
  if FDisplayDecimalSeparator then
    KeySet := KeySet + [DecimalSeparator];
  for Tmp := 1 to Length(Text) do
    if Text[Tmp] in ['0'..'9', DecimalSeparator] then
      TmpText := TmpText + Text[Tmp];
  try
    FValue := StrToFloatDef(TmpText, FValue);
    if IsNeg and FDisplayMinus then
      FValue := -FValue;
  except
    MessageBeep(mb_IconAsterisk);
  end;
end;

procedure TnzrCurrencyEdit.FormatText;
begin
  Text := FormatFloat(FDisplayFormat, FValue);
end;

procedure TnzrCurrencyEdit.CMEnter(var Message: TCMEnter);
begin
  SelectAll;
  inherited;
end;

procedure TnzrCurrencyEdit.CMExit(var Message: TCMExit);
begin
  UnformatText;
  FormatText;
  inherited;
end;

procedure TnzrCurrencyEdit.KeyPress(var Key: Char);
var
  KeySet: set of Char;
begin
  if Key = #13 then
  begin
    UnformatText;
    FormatText;
  end;
  
  KeySet := ['.', ','];

  if Key in KeySet then
    Key := DecimalSeparator;

  KeySet := ['0'..'9', #8, #13];

  if FDisplayMinus then
  begin
    if Key = '-' then
    begin
      if (Pos('-', Text) = 0)
        and (SelStart = 0) then
        KeySet := KeySet + ['-'];
    end;
  end;

  if FDisplayDecimalSeparator then
    KeySet := KeySet + [DecimalSeparator];

{  if Key = '0' then
  begin
    if (Pos('0', Text) <> 1) then
        KeySet := KeySet + ['0'];
  end;  //}


  if not (Key in KeySet) then
  begin
    Key := #0;
    MessageBeep(mb_IconAsterisk);
  end;


  inherited KeyPress(Key);
end;

procedure TnzrCurrencyEdit.SetDisplayMinus(const AValue: Boolean);
begin
  FDisplayMinus := AValue;
end;

procedure TnzrCurrencyEdit.SetDisplayDecimalSeparator(
  const AValue: Boolean);
begin
  FDisplayDecimalSeparator := AValue;
end;

function TnzrCurrencyEdit.CheckValue(AValue: Extended): Extended;
begin
  Result := AValue;
  if (FMaxValue <> FMinValue) then
  begin
    if AValue < FMinValue then
      Result := FMinValue
    else
      if AValue > FMaxValue then
        Result := FMaxValue;
  end;
end;

procedure TnzrCurrencyEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  case Alignment of
    taLeftJustify: Params.Style := Params.Style or ES_LEFT and not ES_MULTILINE;
    taRightJustify: Params.Style := Params.Style or ES_RIGHT and not
      ES_MULTILINE;
    taCenter: Params.Style := Params.Style or ES_CENTER and not ES_MULTILINE;
  end;
end;

end.
