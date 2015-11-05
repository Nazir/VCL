unit nzrLinkLabelUnit;

{*****************************************************************}
{                                                                 }
{                     Модуль гиперссылки                          }
{                                                                 }
{  Авторское право: Nazir © 2002-2012                             }
{  Разработчик: Хуснутдинов Назир Каримович  (Wild Pointer)       }
{  Модифицирован: 15.02.2007                                      }
{  Модифицирован: 23.07.2012                                      }
{                                                                 }
{*****************************************************************}

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  ShellAPI, nzrTypesUnit;

type
  {1 Класс настроек свойств письма }
  {{
  Класс TEmail для компонентя гиперссылки
  }
  TEmail = class (TPersistent)
  private
    FAddress: string;
    FBody: TStrings;
    FSubject: string;
    procedure SetAddress(const Value: string);
    procedure SetBody(const Value: TStrings);
    procedure SetSubject(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    {1 Адресс почты получателя письма (E-mail) }
    property Address: string read FAddress write SetAddress;
    {1 Текст письма }
    property Body: TStrings read FBody write SetBody;
    {1 Тема письма }
    {{
    Property Subject is read / write at run time and design time.
    }
    property Subject: string read FSubject write SetSubject;
  end;
  
  {1 Класс nstLinkLabel для создания гиперссылки. }
  TnzrLinkLabel = class (TCustomLabel)
  private
    FAbout: TAboutProperty;
    FFontMouseOver: TFont;
    FFontNormal: TFont;
    FFontOnPush: TFont;
    FEmail: TEmail;
    FMouseEnter: TNotifyEvent;
    FMouseLeave: TNotifyEvent;
    FURL: string;
    procedure SetFontMouseOver(Value: TFont);
    procedure SetFontNormal(Value: TFont);
    procedure SetFontOnPush(Value: TFont);
    procedure SetEmail(const Value: TEmail);
    procedure SetURL(const Value: string);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: 
            Integer); override;
    procedure MouseEnter(Sender: TObject);
    procedure MouseLeave(Sender: TObject);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); 
            override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property About: TAboutProperty read FAbout write FAbout;
    property FontMouseOver: TFont read FFontMouseOver write
            SetFontMouseOver;
    property FontNormal: TFont read FFontNormal write SetFontNormal;
    property FontOnPush: TFont read FFontOnPush write SetFontOnPush;
    property Email: TEmail read FEmail write SetEmail;
    property URL: string read FURL write SetURL;
    //
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color nodefault;
    property Constraints;
    property Cursor default crHandPoint;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;
  

implementation

{1 Класс настроек свойств письма }
{{
Класс TEmail для компонентя гиперссылки
}
{ TEmail }
constructor TEmail.Create;
begin
  FBody := TStringList.Create;
  FBody.Clear;
  FBody.Add('Text');

  FSubject := 'Subject';
end;

destructor TEmail.Destroy;
begin
  FBody.Free;
  
  inherited;
end;

procedure TEmail.SetAddress(const Value: string);
begin
  if FAddress <> Value then
  begin
  
  FAddress := Value;
  
  end;
end;

procedure TEmail.SetBody(const Value: TStrings);
begin
  FBody.Assign(Value);
end;

{1 Тема }
{{
Тема (указывается при необходимости)
}
procedure TEmail.SetSubject(const Value: string);
begin
  if FSubject <> Value then
  begin
  
  FSubject := Value;
  
  end;
end;

{1 Класс nstLinkLabel для создания гиперссылки. }
{ TnzrLinkLabel }
constructor TnzrLinkLabel.Create(AOwner: TComponent);
begin
  inherited;
  
  FMouseEnter := Self.OnMouseEnter;
  FMouseLeave := Self.OnMouseLeave;
  OnMouseEnter := MouseEnter;
  OnMouseLeave := MouseLeave;

  FFontMouseOver := TFont.Create;
  FFontNormal := TFont.Create;
  FFontOnPush := TFont.Create;

  FFontNormal.Color := clBlue;
  FFontNormal.Style := [fsUnderLine];
  FFontOnPush.Color := clRed;
  FFontMouseOver.Color := clPurple;

  Font.Assign(FFontNormal);

  Caption := 'ovvio.pro';

  Cursor := crHandPoint;
  
  FEmail := TEmail.Create;
end;

destructor TnzrLinkLabel.Destroy;
begin
  inherited;

  FEmail.Free;

  FFontMouseOver.Free;
  FFontNormal.Free;
  FFontOnPush.Free;

end;

procedure TnzrLinkLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, 
        Y: Integer);
begin
  if Button = mbLeft then
    Font.Assign(FontOnPush);
  
  inherited;
end;

procedure TnzrLinkLabel.MouseEnter(Sender: TObject);
begin
  if csDesigning in ComponentState then
    Exit;
  
  Font.Assign(FFontMouseOver);
  
  if Assigned(FMouseEnter) then
    FMouseEnter(Self);
  
  inherited;
end;

procedure TnzrLinkLabel.MouseLeave(Sender: TObject);
begin
  Font.Assign(FFontNormal);
  
  if Assigned(FMouseLeave) then
    FMouseLeave(Self);
  
  inherited;
end;

procedure TnzrLinkLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TnzrLinkLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: 
        Integer);
var
  sTemp: string;
begin
  if (FURL = '') and (FEmail.Address = '') then
  begin
    if Pos('@',Caption) = 0 then
      sTemp := Caption
    else
      sTemp := 'mailto:' + Caption + '?subject=' +
                         FEmail.Subject + '&body=' +
                         FEmail.Body.Text
  end
  else
  begin
    if FURL = '' then
    begin
      if FEmail.Address <> '' then
        sTemp := 'mailto:' + FEmail.Address + '?subject=' +
                           FEmail.Subject + '&body=' +
                           FEmail.Body.Text;
    end
    else
      sTemp := FURL;
  end;

  sTemp := StringReplace(sTemp, #13#10, '%0D%0A', [rfReplaceAll,rfIgnoreCase]);
  sTemp := StringReplace(sTemp, #32, '%20', [rfReplaceAll,rfIgnoreCase]);
  sTemp := StringReplace(sTemp, #9, '%09', [rfReplaceAll,rfIgnoreCase]);
  sTemp := StringReplace(sTemp, #34, '%22', [rfReplaceAll,rfIgnoreCase]);

  ShellExecute(0, nil, PChar(sTemp), nil, nil, SW_SHOW);

  Font.Assign(FFontNormal);

  inherited;
end;

procedure TnzrLinkLabel.SetFontMouseOver(Value: TFont);
begin
  if FFontMouseOver <> Value then
  begin

    FFontMouseOver := Value;

    Invalidate;

  end;
end;

procedure TnzrLinkLabel.SetFontNormal(Value: TFont);
begin
  if FFontNormal <> Value then
  begin
  
    FFontNormal := Value;

    Font.Color := FFontNormal.Color;
  
    Invalidate;
  
  end;
end;

procedure TnzrLinkLabel.SetFontOnPush(Value: TFont);
begin
  if FFontOnPush <> Value then
  begin

    FFontOnPush := Value;

    Invalidate;

  end;
end;

procedure TnzrLinkLabel.SetEmail(const Value: TEmail);
begin
  FEmail.Assign(Value);

  FURL := '';
end;

procedure TnzrLinkLabel.SetURL(const Value: string);
begin
  if FURL <> Value then
  begin

    FURL := Value;

    FEmail.Address := '';

  end;
end;

end.
