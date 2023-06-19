#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СхемаПомещения") И ЗначениеЗаполнено(Параметры.СхемаПомещения) Тогда
		Объект.ТерриторияПомещение = Параметры.СхемаПомещения;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда 
		Результат = Делопроизводство.РассчитатьКоличествоХранимыхДокументов(Объект.Ссылка);
		КоличествоДел = Результат.КоличествоДел;
		КоличествоДокументов = Результат.КоличествоДокументов;
		
		КоличествоДел_ЕдиницаИзмерения = 
			ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
			КоличествоДел,
			НСтр("ru = 'дело (том)'") + "," + НСтр("ru = 'дела (тома)'") + "," + НСтр("ru = 'дел (томов)'"));
		КоличествоДокументов_ЕдиницаИзмерения = 
			ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
			КоличествоДокументов,
			НСтр("ru = 'документ'") + "," + НСтр("ru = 'документа'") + "," + НСтр("ru = 'документов'"));
			
		Если КоличествоДел = 0 И КоличествоДокументов = 0 Тогда 
			Элементы.НаполнениеМеста.Заголовок = НСтр("ru = 'Не содержит документов'");
		Иначе 
			Элементы.НаполнениеМеста.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Содержит %1 %2, %3 %4'"), КоличествоДел, КоличествоДел_ЕдиницаИзмерения,
				КоличествоДокументов, КоличествоДокументов_ЕдиницаИзмерения);
		КонецЕсли;
	Иначе 
		Элементы.НаполнениеМеста.Заголовок = НСтр("ru = 'Не содержит документов'");
	КонецЕсли;
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	ИспользоватьСхемыПомещений = ПолучитьФункциональнуюОпцию("ИспользоватьСхемыПомещений");
	
	Если ИспользоватьСхемыПомещений Тогда 
		Элементы.ПланПомещенияТекст.АвтоОтметкаНезаполненного = Истина;
		
		// Заполнение текстовых реквизитов
		Если ЗначениеЗаполнено(Объект.ТерриторияПомещение) Тогда
			ПланПомещенияТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(
				Объект.ТерриторияПомещение);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка).Изменение Тогда 
		Элементы.ПланПомещенияТекст.ТолькоПросмотр = Истина;
		Элементы.ПланПомещенияТекст.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьСхемыПомещений И Не ЗначениеЗаполнено(Объект.ТерриторияПомещение) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Помещение или территория""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Элементы.ПланПомещенияТекст",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаполнениеМестаНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НаполнениеМестаНажатиеПродолжение",
		ЭтотОбъект);

	Если Объект.Ссылка.Пустая() Тогда 
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
                             |Переход к ""Делам"" возможен только после записи данных.
                             |Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НаполнениеМестаНажатиеПродолжение(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.ОК И Не Записать() Тогда 
		Возврат; 
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("МестоХранения", Объект.Ссылка);
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.ФормаСписка" , ПараметрыФормы, , Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПланПомещенияТекст) Тогда 
		Объект.ТерриторияПомещение = Неопределено;
		ПланПомещенияТекст = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.ТерриторияПомещение);
	ОткрытьФорму("Справочник.ТерриторииИПомещения.ФормаВыбора", ПараметрыФормы, 
		Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.ТерриторияПомещение = Неопределено;
	ПланПомещенияТекст = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПланПомещенияТекст) Тогда
		ПоказатьЗначение(, Объект.ТерриторияПомещение);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда 
		
		СтандартнаяОбработка = Ложь;
		Объект.ТерриторияПомещение = ВыбранноеЗначение;
		Модифицированность = Истина;
		
		Если ЗначениеЗаполнено(Объект.ТерриторияПомещение) Тогда 
			ПланПомещенияТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(
				Объект.ТерриторияПомещение);
		Иначе 
			ПланПомещенияТекст = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПланПомещения(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПомещенияТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПланПомещения(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораПланПомещения(Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТерриторииИПомещения.Ссылка
			|ИЗ
			|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
			|ГДЕ
			|	ТерриторииИПомещения.Наименование ПОДОБНО &Текст
			|	И НЕ ТерриторииИПомещения.ПометкаУдаления"; 
			   

	Запрос.УстановитьПараметр("Текст", Текст + "%");  
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПланТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(Выборка.Ссылка);
		ДанныеВыбора.Добавить(Выборка.Ссылка, ПланТекст);
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти
