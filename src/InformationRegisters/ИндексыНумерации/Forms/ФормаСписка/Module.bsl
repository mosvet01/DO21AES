&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокТипов(ТипыОбъектов);
	Список.Параметры.УстановитьЗначениеПараметра("Тип", ТипЗнч(Неопределено));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокТипов(СписокТипов) 
	
	Типы = Метаданные.РегистрыСведений.ИндексыНумерации.Измерения.Объект.Тип.Типы();
	Для Каждого ТипОбъекта Из Типы Цикл
		ОбъектСсылка = Новый(ТипОбъекта);
		
		Если ТипОбъекта = Тип("СправочникСсылка.Организации") Тогда 
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
				Продолжить;
			КонецЕсли;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ВопросыДеятельности") Тогда 
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности") Тогда 
				Продолжить;
			КонецЕсли;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда 
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыВходящихДокументов") Тогда 
				Продолжить;
			КонецЕсли;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда 
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов") Тогда 
				Продолжить;
			КонецЕсли;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда 
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов") Тогда 
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Представление = ОбъектСсылка.Метаданные().ПредставлениеСписка;
	 	Если ПустаяСтрока(Представление) Тогда
			Представление = ОбъектСсылка.Метаданные().Синоним;
		КонецЕсли;
		
        СписокТипов.Добавить("СправочникСсылка." + ОбъектСсылка.Метаданные().Имя, Представление);
	КонецЦикла;	
	СписокТипов.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыОбъектовПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ТипыОбъектов.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ТипОбъекта = ТипыОбъектов.НайтиПоИдентификатору(Элементы.ТипыОбъектов.ТекущаяСтрока).Значение;
	Если Тип(ТипОбъекта) <> Список.Параметры.Элементы.Найти("Тип").Значение Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Тип", Тип(ТипОбъекта));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТипОбъекта = ТипыОбъектов.НайтиПоИдентификатору(Элементы.ТипыОбъектов.ТекущаяСтрока).Значение;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта", ТипОбъекта);
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;	
		
	Открытьформу("РегистрСведений.ИндексыНумерации.ФормаЗаписи", ПараметрыФормы, Элементы.Список);
	
КонецПроцедуры
