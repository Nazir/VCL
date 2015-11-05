unit nzrCurrencyEditReg;

interface

uses
  Classes, DesignIntf, DesignEditors,
  nzrTypesUnit, nzrPropertyEditorsUnit, nzrCurrencyEditUnit;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nazir Standard', [TnzrCurrencyEdit]);

  RegisterPropertyEditor(TypeInfo(TAboutProperty),
                         TnzrCurrencyEdit,
                         'About',
                         TAboutPropertyEditor);
end;

end.
