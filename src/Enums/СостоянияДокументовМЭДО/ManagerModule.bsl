// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Все возможные состояния входящего документа.
// 
// Возвращаемое значение:
//  СписокЗначений из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния входящего документа
Функция СостоянияВходящегоДокумента() Экспорт
	
	Состояния = Новый СписокЗначений();
	Состояния.Добавить(ДокументПолучен);
	Состояния.Добавить(ВходящийДокументЗарегистрирован);
	Состояния.Добавить(ИсходящееУведомлениеЕщеНеОтправлено);
	Состояния.Добавить(ОтправленаКвитанция);
	Состояния.Добавить(ОтправленаКвитанцияОбОшибке);
	Состояния.Добавить(ОтправленоУведомление);
	Состояния.Добавить(СозданаИсходящаяКвитанция);
	Состояния.Добавить(СозданоИсходящееУведомление);
	
	Возврат Состояния;
	
КонецФункции

// Все возможные состояния исходящего документа.
// 
// Возвращаемое значение:
//  СписокЗначений из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния исходящего документа
Функция СостоянияИсходящегоДокумента() Экспорт
	
	Состояния = Новый СписокЗначений();
	Состояния.Добавить(ДокументЗарегистрированГотовКОтправке);
	Состояния.Добавить(ДокументОтправлен);
	Состояния.Добавить(ИсходящийДокументЕщеНеОтправлен);
	Состояния.Добавить(ОтправкаОтменена);
	Состояния.Добавить(ПолученаКвитанция);
	Состояния.Добавить(ПолученаКвитанцияОбОшибке);
	Состояния.Добавить(ПолученоУведомление);
	
	Возврат Состояния;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Массив-константа - состояния, являющиеся признаком к отправке исходящих уведомлений.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния к отправке
Функция СостоянияУведомленияКОтправке() Экспорт

	Состояния = Новый Массив();
	Состояния.Добавить(ВходящийДокументЗарегистрирован);
	Состояния.Добавить(СозданоИсходящееУведомление);
	
	Возврат Состояния;

КонецФункции

// Массив-константа - состояния, являющиеся признаком к обработке входящих уведомлений.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния к отправке
Функция СостоянияВходящиеУведомленияКОбработке() Экспорт

	Состояния = Новый Массив();
	Состояния.Добавить(ДокументОтправлен); // но ожидается уведомление.
	Состояния.Добавить(ПолученаКвитанция);
	Состояния.Добавить(ПолученоУведомление);
	
	Возврат Состояния;

КонецФункции

// Массив-константа - состояния, являющиеся признаком к обработке полученных входящих документов.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния к отправке
Функция СостоянияВходящиеДокументыКОбработке() Экспорт
	
	Состояния = Новый Массив();
	Состояния.Добавить(ДокументПолучен);
	Состояния.Добавить(ОтправленаКвитанция);
	Состояния.Добавить(СозданаИсходящаяКвитанция);
	
	Возврат Состояния;
	
КонецФункции

// Массив-константа - состояния, являющиеся признаком к отправке исходящих документов.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояния к отправке
Функция СостоянияИсходящиеДокументыКОтправке() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументЗарегистрированГотовКОтправке);
	
КонецФункции

Функция СостоянияВходящегоДокументаПередУведомлением() Экспорт
	
	Состояния = Новый Массив();
	Состояния.Добавить(ДокументПолучен);
	Состояния.Добавить(ВходящийДокументЗарегистрирован);
	Состояния.Добавить(ОтправленаКвитанция);
	Состояния.Добавить(ОтправленоУведомление);
	Состояния.Добавить(СозданоИсходящееУведомление);
	Возврат Состояния;
	
КонецФункции

#КонецОбласти

#КонецЕсли