
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = (Параметры.ТолькоПросмотр = Истина);
	
	Индекс     = Параметры.Индекс;
	Регион     = Параметры.Регион;
	Район      = Параметры.Район;
	Город      = Параметры.Город;
	НасПункт   = Параметры.НасПункт;
	Улица      = Параметры.Улица;
	Дом        = Параметры.Дом;
	Корпус     = Параметры.Корпус;
	Квартира   = Параметры.Квартира;
	КодРегиона = Параметры.КодРегиона;
	
	Элементы.ГруппаКодНалоговогоОргана.Видимость = Ложь;
	Если Параметры.Свойство("КодНалоговогоОргана") Тогда
		Элементы.ГруппаКодНалоговогоОргана.Видимость = Истина;
		Элементы.КодНалоговогоОргана.ОтметкаНезаполненного = Истина;
		КодНалоговогоОргана = Параметры.КодНалоговогоОргана;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПрограммноеЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОСохраненииИзмененныхДанных",
			ЭтотОбъект);
		
		ТекстВопроса = НСтр("ru = 'Данные модифицированы. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Элементы.ГруппаКодНалоговогоОргана.Видимость Тогда
		ПроверяемыеРеквизиты.Добавить("КодНалоговогоОргана");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Модифицированность = Ложь;
	Если ПроверитьЗаполнение() Тогда
		
		Если ТолькоПросмотр Тогда
			Закрыть();
		Иначе
			// Возврат данных адреса
			Закрыть(ПодготовитьВозвращаемуюСтруктуру());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подготовка возвращаемой структуры с данными адреса
// Возвращаемое значение: структура с полями - реквизитами адреса.
//
&НаКлиенте
Функция ПодготовитьВозвращаемуюСтруктуру()
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Индекс"             , Индекс);
	СтруктураОтвета.Вставить("Регион"             , Регион);
	СтруктураОтвета.Вставить("КодРегиона"         , КодРегиона);
	СтруктураОтвета.Вставить("Район"              , Район);
	СтруктураОтвета.Вставить("Город"              , Город);
	СтруктураОтвета.Вставить("НаселенныйПункт"    , НасПункт);
	СтруктураОтвета.Вставить("Улица"              , Улица);
	СтруктураОтвета.Вставить("Дом"                , Дом);
	СтруктураОтвета.Вставить("Корпус"             , Корпус);
	СтруктураОтвета.Вставить("Квартира"           , Квартира);
	
	Если Элементы.ГруппаКодНалоговогоОргана.Видимость Тогда
		СтруктураОтвета.Вставить("КодНалоговогоОргана", КодНалоговогоОргана);
	КонецЕсли;
	
	Возврат СтруктураОтвета;
	
КонецФункции

&НаКлиенте
Процедура ПриОтветеНаВопросОСохраненииИзмененныхДанных(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		Закрыть(ПодготовитьВозвращаемуюСтруктуру());
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
