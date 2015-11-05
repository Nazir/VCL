unit nzrToolsRegUnit;

interface

uses
  Windows, Messages, SysUtils, Classes,
  nzrWinRARReg, nzrLinkLabelReg;


procedure Register;

implementation

procedure Register;
begin
  nzrLinkLabelReg.Register;
  nzrWinRARReg.Register;
end;

end.
