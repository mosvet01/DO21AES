#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает связь внешнего объекта и значения свойства в привилегированном режиме.
//
// Параметры:
//   ИДВнешнегоОбъекта - Строка - идентификатор объекта ИС.
//   ТипВнешнегоОбъекта - Строка - тип объекта ИС, например, "Справочник.Склады".
//   ВладелецСвойства - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения - доп. свойство.
//   ЗначениеСвойства - СправочникСсылка.ЗначенияСвойствОбъектов[Иерархия] - значение свойства.
//
Процедура ЗаписатьСвязь(ИДВнешнегоОбъекта, ТипВнешнегоОбъекта, ВладелецСвойства, ЗначениеСвойства) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СвязиЗначенийСвойствИОбъектовИнтегрированныхСистем.СоздатьМенеджерЗаписи();
	Запись.УзелИнтегрированнойСистемы = ПараметрыСеанса.УзелИнтегрированнойСистемы;
	Запись.ИДВнешнегоОбъекта = ИДВнешнегоОбъекта;
	Запись.ТипВнешнегоОбъекта = ТипВнешнегоОбъекта;
	Запись.ВладелецСвойства = ВладелецСвойства;
	Запись.ЗначениеСвойства = ЗначениеСвойства;
	
	Запись.Записать();
	
КонецПроцедуры

// Получает значение свойства для указанного внешнего объекта.
//
// Параметры:
//   ИДВнешнегоОбъекта - Строка - идентификатор объекта ИС.
//   ТипВнешнегоОбъекта - Строка - тип объекта ИС, например, "Справочник.Склады".
//   ВладелецСвойства - ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения - доп. свойство.
//
// Возвращаемое значение:
//   СправочникСсылка.ЗначенияСвойствОбъектов[Иерархия] - значение свойства, если связь есть, или
//   Неопределено.
//
Функция ПолучитьЗначениеСвойства(ИДВнешнегоОбъекта, ТипВнешнегоОбъекта, ВладелецСвойства) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СвязиЗначенийСвойствИОбъектовИнтегрированныхСистем.СоздатьМенеджерЗаписи();
	Запись.УзелИнтегрированнойСистемы = ПараметрыСеанса.УзелИнтегрированнойСистемы;
	Запись.ИДВнешнегоОбъекта = ИДВнешнегоОбъекта;
	Запись.ТипВнешнегоОбъекта = ТипВнешнегоОбъекта;
	Запись.ВладелецСвойства = ВладелецСвойства;
	
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Возврат Запись.ЗначениеСвойства;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли