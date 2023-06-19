
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("ТекущийПользователь", ТекущийПользователь);

	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;

	ЗагрузитьСинхронизируемыеПрокты();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заголовок = СтрШаблон("%1: %2", Заголовок, ТекущийПользователь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда

		Сообщение = Новый СообщениеПользователю();
		Сообщение.Поле  = "ТекущийПользователь";
		Сообщение.Текст = "Не выбран пользователь";
		Сообщение.Сообщить();

		Возврат;

	КонецЕсли;

	ОбновитьПроектыСинхронизацииПриНеобходимости();
	
	Если СоставПроектовИзменился Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
		
	Закрыть(СоставПроектовИзменился);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для Каждого СтрокаПроект Из ТаблицаПроектов Цикл
		
		СтрокаПроект.Выбран = Истина;
		СтрокаПроект.ВыборИзменен = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для Каждого СтрокаПроект Из ТаблицаПроектов Цикл
		
		СтрокаПроект.Выбран = Ложь;
		СтрокаПроект.ВыборИзменен = Истина
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПроектыВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Проекты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВыборИзменен = ТекущиеДанные.Выбран <> ТекущиеДанные.ВыбранПриОткрытии;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Проекты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Проекты.Форма.ФормаЭлемента", Новый Структура("Ключ", ТекущиеДанные.Проект), , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс)

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьСинхронизируемыеПрокты()

	ТаблицаПроектов.Загрузить(РегистрыСведений.МП_СинхронизацияПроектов.ТаблицаПроектыДляСинхронизации(
		ТекущийПользователь, СоставПроектовИзменился));
		
	Для Каждого СтрокаТаблицыПроектов Из ТаблицаПроектов Цикл
		
		Если СоставПроектовИзменился Тогда
			СтрокаТаблицыПроектов.ВыбранПриОткрытии = Ложь;
			СтрокаТаблицыПроектов.ВыборИзменен = Истина;
		Иначе
			СтрокаТаблицыПроектов.ВыбранПриОткрытии = Истина;
		КонецЕсли;
		
	КонецЦикла;

	ЗаполнитьПроекты();	
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьПроекты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыбранныеПроекты.Проект КАК Проект,
		|	ВыбранныеПроекты.Выбран КАК Выбран,
		|	ВыбранныеПроекты.ВыборИзменен КАК ВыборИзменен,
		|	ВыбранныеПроекты.ВыбранПриОткрытии КАК ВыбранПриОткрытии
		|ПОМЕСТИТЬ ВыбранныеПроекты
		|ИЗ
		|	&ВыбранныеПроекты КАК ВыбранныеПроекты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Проекты.Ссылка КАК Проект,
		|	Проекты.ПометкаУдаления КАК ПометкаУдаления,
		|	ЕСТЬNULL(ВыбранныеПроекты.Выбран, ЛОЖЬ) КАК Выбран,
		|	ЕСТЬNULL(ВыбранныеПроекты.ВыборИзменен, ЛОЖЬ) КАК ВыборИзменен,
		|	ЕСТЬNULL(ВыбранныеПроекты.ВыбранПриОткрытии, ЛОЖЬ) КАК ВыбранПриОткрытии
		|ИЗ
		|	Справочник.Проекты КАК Проекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеПроекты КАК ВыбранныеПроекты
		|		ПО Проекты.Ссылка = ВыбранныеПроекты.Проект
		|ГДЕ
		|	НЕ Проекты.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Проект
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ВыбранныеПроекты", ТаблицаПроектов.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаПроектов.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПроектыСинхронизацииПриНеобходимости()
	
	КлючОтбора = Новый Структура("ВыборИзменен", Истина);
	ИзмененныеСтроки = ТаблицаПроектов.НайтиСтроки(КлючОтбора);
	
	Если ИзмененныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СоставПроектовИзменился = Истина;
	
	Для Каждого ИзмененнаяСтрока Из ИзмененныеСтроки Цикл
		РегистрыСведений.МП_СинхронизацияПроектов.Добавить(ТекущийПользователь, ИзмененнаяСтрока.Проект,
			Не ИзмененнаяСтрока.Выбран);
	КонецЦикла;
	
	КлючОтбора = Новый Структура("Выбран", Истина);
	ВыбранныеСтроки = ТаблицаПроектов.НайтиСтроки(КлючОтбора);
	
	РегистрыСведений.ОбменСМобильнымиНастройкиПользователей.ЗаписатьНастройку(ТекущийПользователь, 
		Перечисления.ОбменСМобильнымиТипыНастроекПользователей.СинхронизацияУчетаВремени,
		(Не ВыбранныеСтроки.Количество() = 0));
	
КонецПроцедуры

#КонецОбласти


