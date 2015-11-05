unit nzrVersionInfoReg;

interface

uses
  Classes, DesignIntf, DesignEditors,
  nzrTypesUnit, nzrPropertyEditorsUnit, nzrVersionInfoUnit;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nazir Standard', [TnzrVersionInfo]);

  RegisterPropertyEditor(TypeInfo(TAboutProperty),
                         TnzrVersionInfo,
                         'About',
                         TAboutPropertyEditor);
end;

end.
