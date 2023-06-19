#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ЗначениеПоСтроковомуЗначению(ВерсияСтрокой) Экспорт
	
	Если ВерсияСтрокой = "2.5" Тогда
		Возврат Версия25;
	ИначеЕсли ВерсияСтрокой = "2.7" Тогда
		Возврат Версия27;
	ИначеЕсли ВерсияСтрокой = "2.7.1" Тогда 
		Возврат Версия271;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Последняя на данный момент актуальная версия формата МЭДО
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ВерсииФорматаМЭДО
Функция ПоследняяВерсия() Экспорт
	Возврат Версия271;
КонецФункции

#КонецОбласти

#КонецЕсли