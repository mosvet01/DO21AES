Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		// Комплекты документов
		Если Запись.ТипСвязи = Справочники.ТипыСвязей.Содержит Тогда
			Если Не ЭтоКомплект(Запись.Документ) Тогда
				ТекстСообщения = НСтр("ru = 'Документ не может содержать другие документы или файлы, так как он не является комплектом.'");
				ВызватьИсключение ТекстСообщения;
			ИначеЕсли ЭтоКомплектДокументов(Запись.Документ) Тогда
				Если Запись.Документ.ПодписанЭП Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Комплект документов ""%1"" подписан ЭП. Нельзя менять состав комплекта.'"),
						Запись.Документ);
					ВызватьИсключение ТекстСообщения;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Запись.ТипСвязи = Справочники.ТипыСвязей.ВходитВКомплект Тогда
			Если Не ЭтоКомплект(Запись.СвязанныйДокумент) Тогда
				ТекстСообщения = НСтр("ru = 'Связь ""Входит в комплект"" может быть установлена только с документом, являющимся комплектом.'");
				ВызватьИсключение ТекстСообщения;
			ИначеЕсли ЭтоКомплектДокументов(Запись.СвязанныйДокумент) Тогда
				Если Запись.СвязанныйДокумент.ПодписанЭП Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Комплект документов ""%1"" подписан ЭП. Нельзя менять состав комплекта.'"),
						Запись.СвязанныйДокумент);
					ВызватьИсключение ТекстСообщения;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		
		СвязанныйДокумент = Неопределено;
		Если ЗначениеЗаполнено(Запись.СвязанныйДокумент) Тогда 
			СвязанныйДокумент = Запись.СвязанныйДокумент;
		ИначеЕсли ЗначениеЗаполнено(Запись.СвязаннаяСтрока) Тогда 
			СвязанныйДокумент = Запись.СвязаннаяСтрока;
		КонецЕсли;
		
		НастройкиСвязи = СвязиДокументов.ПолучитьНастройкуСвязи(Запись.Документ, СвязанныйДокумент, Запись.ТипСвязи);
		Если НастройкиСвязи = Неопределено Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Записываемая связь не соответствует настройкам для типа связи! Связи документов: %1, %2, %3'"), 
				Запись.Документ, Запись.ТипСвязи, СвязанныйДокумент);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ХарактерСвязи = НастройкиСвязи.ХарактерСвязи;
		Если ХарактерСвязи = Перечисления.ХарактерСвязей.Единичная Тогда 
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 2
			|	СвязиДокументов.Документ,
			|	СвязиДокументов.ТипСвязи,
			|	СвязиДокументов.СвязанныйДокумент,
			|	СвязиДокументов.СвязаннаяСтрока,
			|	СвязиДокументов.Комментарий,
			|	СвязиДокументов.Установил,
			|	СвязиДокументов.ДатаУстановки
			|ИЗ
			|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
			|ГДЕ
			|	СвязиДокументов.ТипСвязи = &ТипСвязи
			|	И СвязиДокументов.Документ = &Документ
			|	И СвязиДокументов.ДополнительныйОбъектСвязи = &ДополнительныйОбъектСвязи";
			Запрос.УстановитьПараметр("ТипСвязи", Запись.ТипСвязи);
			Запрос.УстановитьПараметр("Документ", Запись.Документ);
			Запрос.УстановитьПараметр("ДополнительныйОбъектСвязи", Запись.ДополнительныйОбъектСвязи);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Количество() > 1 Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 не может быть установлено более одной единичной связи %2!'"), 
					Запись.Документ, Запись.ТипСвязи);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если ТипЗнч(Запись.СвязанныйДокумент) <> Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
			Продолжить;
		КонецЕсли;
		
		Получатели = Запись.СвязанныйДокумент.Получатели;
		Отправлен = Ложь;
		Если Получатели.Количество() = 1 Тогда
			Отправлен = Получатели[0].Отправлен;
			
		ИначеЕсли Получатели.Найти(Ложь, "Отправлен") = Неопределено Тогда
			Отправлен = Истина;
			
		ИначеЕсли ТипЗнч(Запись.Документ) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
			ВходящийДокумент = Запись.Документ;
			ПараметрыОтбора = Новый Структура("Получатель", ВходящийДокумент.Отправитель);
			НайденныеСтроки = Получатели.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() = 1 Тогда
				Отправлен = НайденныеСтроки[0].Отправлен;
			Иначе
				ПараметрыОтбора = Новый Структура("Получатель, Адресат", ВходящийДокумент.Отправитель, ВходящийДокумент.Подписал);
				НайденныеСтроки = Получатели.НайтиСтроки(ПараметрыОтбора);
				Если НайденныеСтроки.Количество() = 1 Тогда
					Отправлен = НайденныеСтроки[0].Отправлен;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Запись.СвязанныйДокументОтправлен = Отправлен;
	КонецЦикла;
	
	// Заполнение РС КешИнформацииОбОбъектах
	СвязиПисем = Новый ТаблицаЗначений;
	СвязиПисем.Колонки.Добавить("Письмо");
	СвязиПисем.Колонки.Добавить("Признак");
	СвязиПисем.Колонки.Добавить("КоличествоСвязей");
	
	СписокПисем = Новый Массив;
	
	Если Замещение Тогда
		ТекущееЗначениеНабора = ЭтотОбъект.Выгрузить();
		ЭтотОбъект.Прочитать();
		Для каждого Запись Из ЭтотОбъект Цикл
			Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Запись.Документ)
				И (Запись.ТипСвязи = Справочники.ТипыСвязей.ОтправленоОтветноеПисьмо
				Или Запись.ТипСвязи = Справочники.ТипыСвязей.ОтправленОтветныйДокумент
				Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПересланоПисьмом
				Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПеренаправленоПисьмом
				Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПолученоОтветноеПисьмо
				Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПолученОтветныйДокумент) Тогда
				СписокПисем.Добавить(Запись.Документ);
				
				СвязиПисемСтрока = СвязиПисем.Добавить();
				СвязиПисемСтрока.Письмо = Запись.Документ;
				СвязиПисемСтрока.Признак = СвязиДокументов.ПолучитьИмяПризнакаДляТипаСвязи(Запись.ТипСвязи);
				СвязиПисемСтрока.КоличествоСвязей = -1;
			КонецЕсли;
		КонецЦикла;
		ЭтотОбъект.Загрузить(ТекущееЗначениеНабора);
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Запись.Документ)
			И (Запись.ТипСвязи = Справочники.ТипыСвязей.ОтправленоОтветноеПисьмо
			Или Запись.ТипСвязи = Справочники.ТипыСвязей.ОтправленОтветныйДокумент
			Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПересланоПисьмом
			Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПеренаправленоПисьмом
			Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПолученоОтветноеПисьмо
			Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПолученОтветныйДокумент) Тогда
			СписокПисем.Добавить(Запись.Документ);
			
			СвязиПисемСтрока = СвязиПисем.Добавить();
			СвязиПисемСтрока.Письмо = Запись.Документ;
			СвязиПисемСтрока.Признак = СвязиДокументов.ПолучитьИмяПризнакаДляТипаСвязи(Запись.ТипСвязи);
			СвязиПисемСтрока.КоличествоСвязей = 1;
		КонецЕсли;
	КонецЦикла;
	
	Если СвязиПисем.Количество() > 0 Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СвязиДокументов.Документ КАК Ссылка,
			|	СвязиДокументов.ТипСвязи
			|ИЗ
			|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
			|ГДЕ
			|	СвязиДокументов.Документ В(&СписокПисем)
			|	И (СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленоОтветноеПисьмо)
			|			ИЛИ СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленОтветныйДокумент)
			|			ИЛИ СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПересланоПисьмом)
			|			ИЛИ СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПеренаправленоПисьмом)
			|			ИЛИ СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученоОтветноеПисьмо)
			|			ИЛИ СвязиДокументов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученОтветныйДокумент))");
		Запрос.УстановитьПараметр("СписокПисем", СписокПисем);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СвязиПисемСтрока = СвязиПисем.Добавить();
			СвязиПисемСтрока.Письмо = Выборка.Ссылка;
			СвязиПисемСтрока.Признак = СвязиДокументов.ПолучитьИмяПризнакаДляТипаСвязи(Выборка.ТипСвязи);
			СвязиПисемСтрока.КоличествоСвязей = 1;
		КонецЦикла;
		
		СвязиПисем.Свернуть("Письмо, Признак", "КоличествоСвязей");
		Для каждого СвязиПисемСтрока Из СвязиПисем Цикл
			РегистрыСведений.КешИнформацииОбОбъектах.УстановитьПризнак(
				СвязиПисемСтрока.Письмо,
				СвязиПисемСтрока.Признак,
				СвязиПисемСтрока.КоличествоСвязей > 0);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


// КОМПЛЕКТЫ ДОКУМЕНТОВ

Функция ЭтоКомплект(Документ)
	
	Возврат
	(ТипЗнч(Документ) = Тип("СправочникСсылка.ВнутренниеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныВходящихДокументов")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов"))
	И ЗначениеЗаполнено(Документ.ВидДокумента)
	И Документ.ВидДокумента.ЯвляетсяКомплектомДокументов;
	
КонецФункции

Функция ЭтоКомплектДокументов(Документ)
	Возврат
	(ТипЗнч(Документ) = Тип("СправочникСсылка.ВнутренниеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы"))
	И ЗначениеЗаполнено(Документ.ВидДокумента)
	И Документ.ВидДокумента.ЯвляетсяКомплектомДокументов;
КонецФункции

