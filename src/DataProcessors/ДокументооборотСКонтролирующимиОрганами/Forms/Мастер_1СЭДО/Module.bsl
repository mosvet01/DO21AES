&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	
	Элементы.ОператорЭДО.СписокВыбора.ЗагрузитьЗначения(ОператорыЭДО.ВыгрузитьЗначения());
	
	ИзменитьОформлениеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодНалоговогоОрганаЭДОПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиОшибку(Элемент)
	
	Если Элемент.Подсказка <> "" Тогда
		ПоказатьПредупреждение(,Элемент.Подсказка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПодключенияНажатие(Элемент)
	
	Если ЗначениеЗаполнено(СсылкаОписаниеСервисаЭДО) Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаОписаниеСервисаЭДО);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорЭДОПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	Если Параметры1СЭДОУказаныКорректно() Тогда
		
		ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
		ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
		ДополнительныеПараметры.Вставить("ПараметрыФормы",     ПараметрыФормы);
		ДополнительныеПараметры.Вставить("Модифицированность", Модифицированность);
		
		Модифицированность = Ложь;
		
		Закрыть(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция Параметры1СЭДОУказаныКорректно()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ПроверитьПараметры1СЭДО(ЭтотОбъект);

КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьОформлениеФормы()
	
	// Только просмотр
	Если ЗапретитьИзменение Тогда
		Элементы.ОператорЭДО.ТолькоПросмотр = Истина;
		Элементы.КодНалоговогоОрганаЭДО.ТолькоПросмотр = Истина;
		Элементы.Сохранить.Видимость = Ложь;
		Элементы.ФормаЗакрыть.Видимость = Ложь;
	КонецЕсли;

	// Проверка
	Если СтрДлина(СокрЛП(КодНалоговогоОрганаЭДО)) > 1 И СтрДлина(СокрЛП(КодНалоговогоОрганаЭДО)) < 4 Тогда
		Элементы.ПроверкаВладелецЭЦПДатаРождения.Видимость = Истина;
		Элементы.ПроверкаВладелецЭЦПДатаРождения.Подсказка = НСтр("ru = 'Код ФНС должен состоять из 4 цифр'");
	Иначе
		Элементы.ПроверкаВладелецЭЦПДатаРождения.Видимость = Ложь;
	КонецЕсли;

КонецФункции

#КонецОбласти