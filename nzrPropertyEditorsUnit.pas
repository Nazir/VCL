unit nzrPropertyEditorsUnit;

interface

uses
  DesignIntf, DesignEditors, Forms, Controls,
  nzrAboutUnit, nzrTypesUnit, nzrConstsUnit;

type
  TAboutPropertyEditor = class(TStringProperty)
  public
    ComponentInfo: TComponentInfo;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue : string; override;
    procedure Edit; override;
  end;

  TGradientPanelEditor = class(TComponentEditor)
  private
    procedure CallEditor;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TFormFillEditor = class(TGradientPanelEditor)
  private
    procedure CallEditor;
  public
    procedure ExecuteVerb(Index: Integer); override;
  end;

implementation

{ TAboutPropertyEditor }

procedure TAboutPropertyEditor.Edit;
begin
  with TnzrAboutForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

function TAboutPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TAboutPropertyEditor.GetValue: string;
begin
  Result := 'Version ' + SProductVersion;
end;

{ TGradientPanelEditor }

procedure TGradientPanelEditor.CallEditor;
{var
  dlg: TEditorForm;}
begin
{  dlg := TEditorForm.Create(Application);
  try
    with dlg do
    begin
      Lines.Assign((Component as TnzrGradientPanel).GradientColors);
      Checked := (Component as TnzrGradientPanel).GradientTwoColors;
      StartColor := (Component as TnzrGradientPanel).GradientStartColor;
      FinishColor := (Component as TnzrGradientPanel).GradientEndColor;
      GType := (Component as TnzrGradientPanel).GradientType;
      AlignEx := (Component as TnzrGradientPanel).AlignmentEx;
      if ShowModal = mrOk then
      with (Component as TnzrGradientPanel)do
      begin
        GradientColors.Assign(Lines);
        GradientTwoColors := Checked;
        GradientStartColor := StartColor;
        GradientEndColor := FinishColor;
        GradientType := GType;
        AlignmentEx := AlignEx;
      end;
    end;
  finally
    dlg.Free;
  end;
  Designer.Modified;    }
end;

procedure TGradientPanelEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    CallEditor;
end;

function TGradientPanelEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Configure...';
end;

function TGradientPanelEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TFormFillEditor }

procedure TFormFillEditor.CallEditor;
{var
  dlg: TEditorForm;}
begin
{  dlg := TEditorForm.Create(Application);
  try
    with dlg do
    begin
      AlgnCombo.Hide;
      AlignmentEx.Hide;
      SGP.Caption := '';
      Lines.Assign((Component as TnzrFormFill).ColorsOptions.ColorsArray);
      Checked := (Component as TnzrFormFill).ColorsOptions.TwoColors;
      StartColor := (Component as TnzrFormFill).ColorsOptions.FirstColor;
      FinishColor := (Component as TnzrFormFill).ColorsOptions.LastColor;
      GType := (Component as TnzrFormFill).GradientType;
      if ShowModal = mrOk then
      with (Component as TnzrFormFill)do
      begin
        ColorsOptions.ColorsArray.Assign(Lines);
        ColorsOptions.TwoColors := Checked;
        ColorsOptions.FirstColor := StartColor;
        ColorsOptions.LastColor := FinishColor;
        GradientType := GType;
      end;
    end;
  finally
    dlg.Free;
  end;
  Designer.Modified;       }
end;

procedure TFormFillEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    CallEditor;
end;

end.
