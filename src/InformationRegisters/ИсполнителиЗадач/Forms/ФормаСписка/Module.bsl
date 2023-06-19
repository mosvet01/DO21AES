
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Пользователь") И ЗначениеЗаполнено(Параметры.Пользователь) Тогда 
		
		Список.Отбор.Элементы.Очистить();
		
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Исполнитель");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = Параметры.Пользователь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РолеваяАдресация" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры
