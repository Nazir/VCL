unit nzrConstsUnit;

{*****************************************************************}
{                                                                 }
{          ������ ���������� �������� ������ ��������             }
{                                                                 }
{  ��������� �����: Nazir Software � 2002-2011                    }
{  ������������: ����������� ����� ���������  (Wild Pointer)      }
{  �������������: 21.01.2007                                      }
{                                                                 }
{*****************************************************************}

interface

uses
  Windows;

const
  SProductVersion = '1.4.0';
  SProductID = '0000-0NZR-TOOL-2006-1001';
  SEmailAddress = '';
  SSiteAddress = '';

// ����� Callipso
  clNavyBlue = $00775649;   //73 86 119 (Navy Blue - CMYK)
  clOrange = $001778E7;   //231 120 23 (Orange - CMYK)

// Com ���������
  SDllIcon = 'COMICON';

// ���������
  SNeedToFill          = '��������� ��������� ���� %s';
  SNeedToChoose        = '��������� ������� %s';
  SWarning             = '��������������';
  SWarningConfirm      = '��������������: %s';
  SWarningRecordExists = '��������������: ������ ����������.';
  SWarningEmptyField   = '��������������: ����������� ����.';
  SWarningAlreadyExist = '%s ��� ����������!';
  SWarningEmptyExists  = '�������� �� ����������� ����.';
  SIndexOutOfRange     = '������ ��� ���������!';
  SInformation         = '����������';
  SConfirmation        = '�������������';
  SError               = '������';
  SWrongFormatString   = '�������� ������ � ������ %d. ';
  SInternalError       = '���������� ������. ���������� � ������������� ��� ������� ���� ��������';
  SNoAccessToRegistry  = '���������� �������� ������ � �������...';
  
// ������ ��������� + ������
  MB_OK_EXCL = MB_OK or MB_ICONEXCLAMATION;
  MB_OK_WARN = MB_OK or MB_ICONWARNING;
  MB_OK_INFO = MB_OK or MB_ICONINFORMATION;
  MB_YESNO_QUEST = MB_YESNO or MB_ICONQUESTION;

// ���������������� ���������
 // WM_UPDATEBASE = WM_USER + 1;
 // WM_PROGRESS   = WM_USER + 2;
  

implementation

initialization

end.

