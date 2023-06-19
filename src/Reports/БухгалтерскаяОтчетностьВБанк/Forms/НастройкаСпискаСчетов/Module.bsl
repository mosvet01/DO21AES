#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометкуСтрокТаблицы(Истина, "Включен");
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкуСтрокТаблицы(Ложь, "Включен");
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	РезультатВыбора = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из СоставОтчетаПоСчетам Цикл
		РезультатВыбора.Добавить(Новый Структура("Счет, Включен", СтрокаТаблицы.Счет, СтрокаТаблицы.Включен));
	КонецЦикла;
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПометкуСтрокТаблицы(ЗначениеКолонки, ИмяКолонки)
	
	Для Каждого СтрокаТаблицы Из СоставОтчетаПоСчетам Цикл
		СтрокаТаблицы[ИмяКолонки] = ЗначениеКолонки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
