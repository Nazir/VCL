unit nzrConstsUnit;

{*****************************************************************}
{                                                                 }
{          Модуль глобальных констант группы проектов             }
{                                                                 }
{  Авторское право: Nazir Software © 2002-2011                    }
{  Разработчики: Хуснутдинов Назир Каримович  (Wild Pointer)      }
{  Модифицирован: 21.01.2007                                      }
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

// Цвета Callipso
  clNavyBlue = $00775649;   //73 86 119 (Navy Blue - CMYK)
  clOrange = $001778E7;   //231 120 23 (Orange - CMYK)

// Com константы
  SDllIcon = 'COMICON';

// Сообщения
  SNeedToFill          = 'Небходимо заполнить поле %s';
  SNeedToChoose        = 'Небходимо выбрать %s';
  SWarning             = 'Предупреждение';
  SWarningConfirm      = 'Предупреждение: %s';
  SWarningRecordExists = 'Предупреждение: Запись существует.';
  SWarningEmptyField   = 'Предупреждение: Незаполнено поле.';
  SWarningAlreadyExist = '%s уже существует!';
  SWarningEmptyExists  = 'Остались не заполненные поля.';
  SIndexOutOfRange     = 'Индекс вне диапазона!';
  SInformation         = 'Информация';
  SConfirmation        = 'Подтверждение';
  SError               = 'Ошибка';
  SWrongFormatString   = 'Неверный формат в строке %d. ';
  SInternalError       = 'Внутренняя ошибка. Обратитесь к разработчикам для решения этой проблемы';
  SNoAccessToRegistry  = 'Невозможно получить доступ к реестру...';
  
// Иконка сообщения + кнопки
  MB_OK_EXCL = MB_OK or MB_ICONEXCLAMATION;
  MB_OK_WARN = MB_OK or MB_ICONWARNING;
  MB_OK_INFO = MB_OK or MB_ICONINFORMATION;
  MB_YESNO_QUEST = MB_YESNO or MB_ICONQUESTION;

// Пользовательские сообщения
 // WM_UPDATEBASE = WM_USER + 1;
 // WM_PROGRESS   = WM_USER + 2;
  

implementation

initialization

end.

