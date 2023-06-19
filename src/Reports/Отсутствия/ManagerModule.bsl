#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.СовместнаяРабота));
	
	Если КлючВариантаОтчета = "ПоСотруднику" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОтсутствияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		
	ИначеЕсли КлючВариантаОтчета = "ПоВидуОтсутствия" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОтсутствияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ДинамикаОтсутствий" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОтсутствияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "РаботающиеУдаленно" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОтсутствияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ДниОтсутствия" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОтсутствияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли