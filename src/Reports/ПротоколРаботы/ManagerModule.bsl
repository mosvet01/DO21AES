#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.НастройкаИАдминистрирование));
	
	Если КлючВариантаОтчета = "СписокСобытий" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаПоТипамСобытий" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "АктивностьПоПользователям" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ДинамикаАктивностиЗаПериод" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
