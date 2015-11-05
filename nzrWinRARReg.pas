unit nzrWinRARReg;

interface

uses
  Classes, DesignIntf, DesignEditors,
  nzrTypesUnit, nzrPropertyEditorsUnit, nzrWinRARUnit;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nazir Standard', [TnzrWinRAR]);

  RegisterPropertyEditor(TypeInfo(TAboutProperty),
                         TnzrWinRAR,
                         'About',
                         TAboutPropertyEditor);
end;

end.
