#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыПечати = Параметры.ПараметрыПечати;
	
	// Переопределение текста (информации) на форме.
	Если Параметры.Свойство("РедакцияФормы") Тогда
		Если ЗначениеЗаполнено(Параметры.РедакцияФормы) Тогда
			Элементы.Переключатель2.СписокВыбора[0].Представление
				= "Формы в редакции приказа Минфина России " + Параметры.РедакцияФормы;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("КодФормыПоКНД") Тогда
		Если ЗначениеЗаполнено("КодФормыПоКНД") Тогда
			Элементы.Переключатель3.СписокВыбора[0].Представление
				= "Формы с титульным листом бланка по КНД " + Параметры.КодФормыПоКНД;
		КонецЕсли;
	КонецЕсли;
	
	// Настройки по умолчанию.
	НастройкиВФорме = Новый Структура;
	НастройкиВФорме.Вставить("АктивныйПункт", 1);
	НастройкиВФорме.Вставить("ДоступенПункт1", Истина);
	НастройкиВФорме.Вставить("ДоступенПункт2", Истина);
	НастройкиВФорме.Вставить("ДоступенПункт3", Истина);
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", Истина);
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НастройкиВФорме, ПараметрыПечати);
	КонецЕсли;
	
	ДоступныеПункты = Новый Массив;
	Если НастройкиВФорме.ДоступенПункт1 Тогда
		ДоступныеПункты.Добавить(1);
	КонецЕсли;
	Если НастройкиВФорме.ДоступенПункт2 Тогда
		ДоступныеПункты.Добавить(2);
	КонецЕсли;
	Если НастройкиВФорме.ДоступенПункт3 Тогда
		ДоступныеПункты.Добавить(3);
	КонецЕсли;
	
	ИндексДоступногоПункта = ДоступныеПункты.Найти(НастройкиВФорме.АктивныйПункт);
	Если ИндексДоступногоПункта = Неопределено Тогда
		ИндексДоступногоПункта = 0;
	КонецЕсли;
	Переключатель1 = ДоступныеПункты[ИндексДоступногоПункта];
	
	Элементы.Переключатель1.Доступность = НастройкиВФорме.ДоступенПункт1;
	Элементы.Переключатель2.Доступность = НастройкиВФорме.ДоступенПункт2;
	Элементы.Переключатель3.Доступность = НастройкиВФорме.ДоступенПункт3;
	
	ВыводитьКолонкуСКодамиСтрок = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьБланк(Команда)
	
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", ВыводитьКолонкуСКодамиСтрок);
	НастройкиВФорме.Вставить("АктивныйПункт", Переключатель1);
	НастройкиВФорме.Вставить("Команда", Команда.Имя);
	
	Закрыть(НастройкиВФорме);
	
КонецПроцедуры

#КонецОбласти
