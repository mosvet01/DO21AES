&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьДоступностьРеквизитов();
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьРеквизитов()
	Если Запись.Бессрочный Тогда
		Запись.ДатаОкончанияДействия = '00010101';
		Запись.ПорядокПродления = Неопределено;
		Элементы.ДатаОкончанияДействия.Доступность = Ложь;
		Элементы.ДатаОкончанияДействия.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ПорядокПродления.Доступность = Ложь;
		Элементы.ПорядокПродления.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		Элементы.ДатаОкончанияДействия.Доступность = Истина;
		Элементы.ДатаОкончанияДействия.АвтоОтметкаНезаполненного = Истина;
		Элементы.ПорядокПродления.Доступность = Истина;
		Элементы.ПорядокПродления.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура БессрочныйПриИзменении(Элемент)
	ОбновитьДоступностьРеквизитов();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Не Запись.Бессрочный Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаОкончанияДействия");
		ПроверяемыеРеквизиты.Добавить("ПорядокПродления");
	КонецЕсли;
КонецПроцедуры

