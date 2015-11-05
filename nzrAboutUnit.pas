unit nzrAboutUnit;

{*****************************************************************}
{                                                                 }
{                  Модуль окна о компонентах                      }
{                                                                 }
{  Авторское право: Nazir Software © 2002-2011                    }
{  Разработчик: Хуснутдинов Назир Каримович  (Wild Pointer)       }
{  Модифицирован: 21.01.2007, 14.12.2007                          }
{  Модифицирован: 26.10.2010                                      }
{                                                                 }
{*****************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, nzrLinkLabelUnit, nzrVersionInfoUnit;

type
  TnzrAboutForm = class (TForm)
    pnBackground: TPanel;
    lbVersion: TLabel;
    lbProjectName: TLabel;
    lbCreators: TLabel;
    lbComponentInfo: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
  public
  private
  end;
   
var
  nzrAboutForm: TnzrAboutForm;

implementation

uses
  nzrConstsUnit, nzrUtilsUnit, nzrTypesUnit;

{$R *.dfm}
{$R Images.res}


{
********************************** TnzrAboutForm **********************************
}
procedure TnzrAboutForm.FormCreate(Sender: TObject);
begin
  lbVersion.Caption := 'Версия ' + SProductVersion + '    ';
  lbComponentInfo.Caption := nzrComponentInfo;
end;

procedure TnzrAboutForm.FormDestroy(Sender: TObject);
begin
//
end;

procedure TnzrAboutForm.FormShow(Sender: TObject);
begin
  lbComponentInfo.Caption := nzrComponentInfo;
end;

procedure TnzrAboutForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrOk;
end;

procedure TnzrAboutForm.FormClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
