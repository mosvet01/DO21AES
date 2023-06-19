
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	История = Истина;
	РежимВыгрузки = 0; // история
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()
	
	Если История Тогда
		Если Объекты.Количество() Тогда
			Для Каждого Строка Из Объекты Цикл
				Если ЗначениеЗаполнено(Строка.Объект) Тогда
					МиграцияДанныхИзВнешнихСистемСервер.ВыгрузитьОбъект(Строка.Объект.ПолноеИмя,,,, Строка.Ключ);
				КонецЕсли;
			КонецЦикла;	
		Иначе
			МиграцияДанныхИзВнешнихСистемСервер.ВыгрузкаИстории(,, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если Изменения Тогда
		МиграцияДанныхИзВнешнихСистемСервер.ВыгрузкаИзменений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВыгрузкиПриИзменении(Элемент)
	
	Если РежимВыгрузки = 0 Тогда
		История = Истина;
		Изменения = Ложь;
		Элементы.Объекты.Видимость = Истина;
	ИначеЕсли РежимВыгрузки = 1 Тогда
		История = Ложь;
		Изменения = Истина;
		Элементы.Объекты.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	ВыгрузитьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОбъектыПриПомощиОтбора(Команда)
	
	// тут выбор ИОМ
	ИОМ = ПредопределенноеЗначение("Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка");
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаполнитьОбъектПродолжение",
		ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, ИОМ, "Выберите объект метаданных", ОписаниеТипов);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОбъектПродолжение(ИОМ, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ИОМ) Тогда
		Возврат;
	КонецЕсли;
	
	ИОМВыбранный = ИОМ;
	СписокСсылокИмяТаблицы = ИмяТаблицыИОМ(ИОМ);
	
	ТекПараметры = Новый Структура("ДействиеВыбора, ИмяТаблицы", 
		Истина,
		СписокСсылокИмяТаблицы);
	ОткрытьФорму("Обработка.МиграцияДанныхИзВнешнихСистемМонитор.Форма.ВыборОбъектовОтбором", 
		ТекПараметры, Элементы.Объекты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого Стр Из ВыбранноеЗначение.ДанныеВыбора Цикл
		
		НовСтр = Объекты.Добавить();
		НовСтр.Объект = ИОМВыбранный; 
		НовСтр.Ключ = Стр.Ссылка;
		
	КонецЦикла;	
	
	Элементы.Объекты.Обновить();
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ИмяТаблицыИОМ(ИОМ)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИОМ, "ПолноеИмя");
	
КонецФункции	
