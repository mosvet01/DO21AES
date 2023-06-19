&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем МассивСообщенийКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИтогиПоСообщениям = Неопределено;
	
	Если Параметры.Сообщения = Неопределено Тогда 
		Отказ = Истина;
		Возврат;
	Иначе
		МассивСообщений = Параметры.Сообщения;
		ИтогиПоСообщениям = Параметры.ИтогиПоСообщениям;
	КонецЕсли;
	
	Если ТипЗнч(МассивСообщений) <> Тип("Массив") И МассивСообщений.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыИНастройки(МассивСообщений, ИтогиПоСообщениям, Отказ);
	
	ОпределитьКоличествоСообщенийКРасшифровке();
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	ПродолжитьАвтообмен = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = Неопределено ИЛИ ТипЗнч(Параметр) <> Тип("Массив") Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ЗаполнитьРеквизитыИНастройки(Параметр, Неопределено, Отказ);
	Если Отказ Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаРасшифровать(Команда)
	
	ПродолжитьАвтообмен = Истина;
	ЗакрытьФормуИНачатьРасшифровку();
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеПоказывать(Команда)
	
	ПродолжитьАвтообмен = Ложь;
	Закрыть(ПродолжитьАвтообмен);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПозже(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыИНастройки(МассивСообщений, ИтогиПоСообщениям, Отказ)
	
	Если ИтогиПоСообщениям = Неопределено Тогда
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ДетальнаяИнформация = КонтекстЭДОСервер.ПолучитьСообщенияДляРасшифровки(МассивСообщений);
		ИтогиПоСообщениям = ДетальнаяИнформация.ИтогиПоСообщениям;
	КонецЕсли;
	
	Если ИтогиПоСообщениям.Количество() = 0 Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТаблицаРасшифровкиПоОрганизациям.Очистить();
	
	Для Каждого СтрокаРезультата Из ИтогиПоСообщениям Цикл
		
		НоваяСтрока = ТаблицаРасшифровкиПоОрганизациям.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		НоваяСтрока.Отметка = Истина;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	Если МассивСообщенийКлиент = Неопределено ИЛИ ТипЗнч(МассивСообщенийКлиент) <> Тип("Массив") Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ЗаполнитьРеквизитыИНастройки(МассивСообщенийКлиент, Неопределено, Отказ);
	Если Отказ Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуИНачатьРасшифровку()
 
	// Расшифровка будет запущена сразу после закрытия этой формы вместе с формой бублика.
	ДополнительныеПараметры = РезультатВыбораПользователя();
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры
	
&НаКлиенте
Функция РезультатВыбораПользователя()
	
	ИтогиПоСообщениям = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаРасшифровкиПоОрганизациям Цикл
		НоваяСтрока = Новый Структура("Организация, КоличествоСообщений");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		ИтогиПоСообщениям.Добавить(НоваяСтрока);
	КонецЦикла;	
	
	Результат = КонтекстЭДОКлиент.СобратьСообщенияДляРасшифровкиНаКлиенте(ИтогиПоСообщениям);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОпределитьКоличествоСообщенийКРасшифровке()

	КоличествоСообщенийКРасшифровке = ТаблицаРасшифровкиПоОрганизациям.Итог("КоличествоСообщений");
	
	ТекстНадписи = НСтр("ru = 'Получено %1 от контролирующих органов.
                         |Расшифровать сообщения сейчас?'");
						 
	ЧислоИПредметИсчисления = ДлительнаяОтправкаКлиентСервер.ЧислоИПредметИсчисления(
		КоличествоСообщенийКРасшифровке,
		"сообщение",
		"сообщения",
		"сообщений",
		"с");
						 
	ТекстНадписи = СтрШаблон(ТекстНадписи, ЧислоИПредметИсчисления);
	Элементы.ТекстНадписи.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры
	
#КонецОбласти