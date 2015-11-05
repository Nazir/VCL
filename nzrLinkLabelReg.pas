unit nzrLinkLabelReg;

interface

uses
  Classes, DesignIntf, DesignEditors,
  nzrTypesUnit, nzrPropertyEditorsUnit, nzrLinkLabelUnit;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nazir Standard', [TnzrLinkLabel]);

  RegisterPropertyEditor(TypeInfo(TAboutProperty),
                         TnzrLinkLabel,
                         'About',
                         TAboutPropertyEditor);
end;

end.
