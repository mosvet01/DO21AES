
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоДокументов();
	НачатьОбновлениеДанныхВыделенных();
	
	УстановитьУсловноеОформление();
	
	Если МиграцияДанныхИзВнешнихСистемСервер.БлокироватьОбменСВнешнимиРесурсами() Тогда
		УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОжидатьПолучениеДанныхВыделенных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновленоСостояниеЭДДО" Тогда
		ОбновитьСписокДокументов();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеПакетовЭДОДО" Тогда
		ОбновитьСписокДокументов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ОрганизацияОтбор, ОрганизацияОтбор);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.КонтрагентОтбор, КонтрагентОтбор);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ВидДокументаОтбор, ВидДокументаОтбор);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ТипОбъектовОтбор, ТипОбъектовОтбор);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ДействияОтбор, ДействияОтбор);
	
	ЗаполнитьДеревоДокументов();
	НачатьОбновлениеДанныхВыделенных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиСобытийЭлементовОтбора

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОрганизацияОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, КонтрагентОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаОтборПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ВидДокументаОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектовОтборПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ТипОбъектовОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияОтборПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ДействияОтбор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоДокументовКОтправке

&НаКлиенте
Процедура ДеревоДокументовКОтправкеПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПослеАктивизацииСтрокиСпискаДокументов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовКОтправкеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоДокументовКОтправке.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоПакетЭДО Тогда
		
		ОбменСКонтрагентамиДОСлужебныйКлиент.ОткрытьПакетЭДО(ТекущиеДанные.ИдентификаторПакета);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ДокументДО) Тогда
		
		ПоказатьЗначение(, ТекущиеДанные.ДокументДО);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоФайловДокументов

&НаКлиенте
Процедура ДеревоФайловДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоФайловДокументов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Документ) И ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторПакета) Тогда
		
		ОбменСКонтрагентамиДОСлужебныйКлиент.ОткрытьПакетЭДО(ТекущиеДанные.ИдентификаторПакета);
		
	ИначеЕсли Не ЗначениеЗаполнено(ТекущиеДанные.Файл) И ЗначениеЗаполнено(ТекущиеДанные.Документ) Тогда 
		
		ПоказатьЗначение(, ТекущиеДанные.Документ);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Файл) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФайлДокумента(ТекущиеДанные.Файл, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подписать(Команда)
	
	ВыполнитьДействияПоИсходящимОбъектам(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьИОтправить(Команда)
	
	ВыполнитьДействияПоИсходящимОбъектам(Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ВыполнитьДействияПоИсходящимОбъектам(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПакет(Команда)
	
	Если ВыбранныеПакеты.Количество() > 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбраны пакеты документов. Операцию создания пакета можно выполнить только по отношению к одиночным документам.'"), ,
			НСтр("ru = 'Выбраны неверные объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеОдиночныеДокументы.Количество() = 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не выбраны документы для создания пакета. Выберите документы для объединения в пакет.'"), ,
			НСтр("ru = 'Не выбраны объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеОдиночныеДокументы.Количество() = 1 Тогда
		
		ОбменСКонтрагентамиДОСлужебныйКлиент.ОткрытьФормуСозданияПакетаЭДО(
			ВыбранныеОдиночныеДокументы.ВыгрузитьЗначения(), ЭтотОбъект);
		
	Иначе
		
		ОбменСКонтрагентамиДОСлужебныйКлиент.ОбъединитьДокументыВИсходящийПакетЭДО(
			ВыбранныеОдиночныеДокументы.ВыгрузитьЗначения());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСоставПакета(Команда)
	
	Если ВыбранныеОдиночныеДокументы.Количество() > 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбраны одиночные документы. Операцию изменения состава пакета может быть выполнена только для одного пакета.'"), ,
			НСтр("ru = 'Выбраны неверные объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеПакеты.Количество() = 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не выбран пакет для изменения состава. Выберите один пакет.'"), ,
			НСтр("ru = 'Не выбраны объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеПакеты.Количество() > 1 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбрано более одного пакета. Изменить состав можно только для одного пакета.'"), ,
			НСтр("ru = 'Выбраны неверные объекты'"));
		Возврат;
	КонецЕсли;
	
	ИдентификаторПакета = ВыбранныеПакеты[0].Значение;
	
	ОбменСКонтрагентамиДОСлужебныйКлиент.ОткрытьФормуИзмененияСоставаПакетаЭДО(ИдентификаторПакета, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКПакету(Команда)
	
	Если ВыбранныеПакеты.Количество() > 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбраны пакеты документов. Операцию добавления документа к пакету может быть выполнена только для одного документа.'"), ,
			НСтр("ru = 'Выбраны неверные объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеОдиночныеДокументы.Количество() = 0 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Не выбран документ для добавление в пакет. Выберите документ для добавления к пакету.'"), ,
			НСтр("ru = 'Не выбраны объекты'"));
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеОдиночныеДокументы.Количество() > 1 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбрано более одного документа. Добавить к пакету можно только одиночный документ.'"), ,
			НСтр("ru = 'Выбраны неверные объекты'"));
		Возврат;
	КонецЕсли;
	
	Документ = ВыбранныеОдиночныеДокументы[0].Значение;
	
	ОбменСКонтрагентамиДОСлужебныйКлиент.ДобавитьДокументКПакету(Документ, Неопределено, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДокументовКОтправке.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоДокументовКОтправке.ЭтоПакетЭДО");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт",
		Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоФайловДокументов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоФайловДокументов.ИдентификаторПакета");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоФайловДокументов.Документ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт",
		Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоФайловДокументов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоФайловДокументов.Документ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоФайловДокументов.Файл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НеЗаполненныйПредмет);
	
КонецПроцедуры

#Область ЗаполнениеСпискаДокументов

&НаКлиенте
Процедура ОбновитьСписокДокументов() Экспорт
	
	ДанныеОтображения = ДанныеОтображенияДерева();
	ЗаполнитьДеревоДокументов();
	ВосстановитьОтображениеДерева(ДанныеОтображения);
	ОбновитьДанныеВыделенныхОбъектов(Истина);
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеОтображенияДерева()
	
	ДанныеОтображения = Новый Соответствие;
	
	Для Каждого СтрокаУровня1 Из ДеревоДокументовКОтправке.ПолучитьЭлементы() Цикл
		
		КлючСтроки = КлючСтрокиДереваКОтправке(СтрокаУровня1);
		
		Если КлючСтроки <> "" Тогда
			
			ДанныеОтображения.Вставить(КлючСтроки, ДанныеОтображенияСтрокиДереваКОтправке(СтрокаУровня1));
			
		КонецЕсли;
		
		Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл
			
			КлючСтроки = КлючСтрокиДереваКОтправке(СтрокаУровня2);
			
			Если КлючСтроки <> "" Тогда
				
				ДанныеОтображения.Вставить(КлючСтроки, ДанныеОтображенияСтрокиДереваКОтправке(СтрокаУровня2));
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеОтображения;
	
КонецФункции

&НаКлиенте
Функция ДанныеОтображенияСтрокиДереваКОтправке(СтрокаДерева)
	
	ИДСтроки = СтрокаДерева.ПолучитьИдентификатор();
	ВыделенныеСтроки = Элементы.ДеревоДокументовКОтправке.ВыделенныеСтроки;
	ТекущиеДанные = Элементы.ДеревоДокументовКОтправке.ТекущиеДанные;
	
	ДанныеОтображенияСтроки = Новый Структура;
	ДанныеОтображенияСтроки.Вставить("Развернута", Элементы.ДеревоДокументовКОтправке.Развернут(ИДСтроки));
	ДанныеОтображенияСтроки.Вставить("Выделена", (ВыделенныеСтроки.Найти(ИДСтроки) <> Неопределено));
	ДанныеОтображенияСтроки.Вставить("Активна", (ТекущиеДанные = СтрокаДерева));
	
	Возврат ДанныеОтображенияСтроки;
	
КонецФункции

&НаКлиенте
Функция КлючСтрокиДереваКОтправке(СтрокаДерева)
	
	КлючСтроки = "";
	Если ЗначениеЗаполнено(СтрокаДерева.ДокументДО) Тогда
		КлючСтроки = СтрШаблон("doc_%1", СтрокаДерева.ДокументДО.УникальныйИдентификатор());
	ИначеЕсли ЗначениеЗаполнено(СтрокаДерева.ИдентификаторПакета) Тогда
		КлючСтроки = СтрШаблон("pack_%1", СтрокаДерева.ИдентификаторПакета);
	КонецЕсли;
	
	Возврат КлючСтроки;
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьОтображениеДерева(ДанныеОтображения)
	
	ИДСтрокКВыделению = Новый Массив;
	ИДСтрокКРазворачиванию = Новый Массив;
	ИДАктивнойСтроки = Неопределено;
	
	Для Каждого СтрокаУровня1 Из ДеревоДокументовКОтправке.ПолучитьЭлементы() Цикл
		
		ИДСтроки1 = СтрокаУровня1.ПолучитьИдентификатор();
		
		ДанныеОтображенияСтроки = ДанныеОтображения.Получить(КлючСтрокиДереваКОтправке(СтрокаУровня1));
		
		Если ДанныеОтображенияСтроки <> Неопределено Тогда
			
			Если ДанныеОтображенияСтроки.Выделена Тогда
				ИДСтрокКВыделению.Добавить(ИДСтроки1);
			КонецЕсли;
			Если ДанныеОтображенияСтроки.Развернута Тогда
				ИДСтрокКРазворачиванию.Добавить(ИДСтроки1);
			КонецЕсли;
			Если ДанныеОтображенияСтроки.Активна Тогда
				ИДАктивнойСтроки = ИДСтроки1;
			КонецЕсли;
			
		КонецЕсли;
		
		ЕстьВыделенныеДочерние = Ложь;
		
		Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл
			
			ИДСтроки2 = СтрокаУровня2.ПолучитьИдентификатор();
			
			ДанныеОтображенияСтроки = ДанныеОтображения.Получить(КлючСтрокиДереваКОтправке(СтрокаУровня2));
			
			Если ДанныеОтображенияСтроки <> Неопределено Тогда
				
				Если ДанныеОтображенияСтроки.Выделена Тогда
					ИДСтрокКВыделению.Добавить(ИДСтроки2);
					ЕстьВыделенныеДочерние = Истина;
				КонецЕсли;
				Если ДанныеОтображенияСтроки.Развернута Тогда
					ИДСтрокКРазворачиванию.Добавить(ИДСтроки2);
				КонецЕсли;
				Если ДанныеОтображенияСтроки.Активна Тогда
					ИДАктивнойСтроки = ИДСтроки2;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьВыделенныеДочерние Тогда
			ИДСтрокКРазворачиванию.Добавить(ИДСтроки1);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ИДСтроки Из ИДСтрокКРазворачиванию Цикл
		Элементы.ДеревоДокументовКОтправке.Развернуть(ИДСтроки);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ИДАктивнойСтроки) Тогда
		Элементы.ДеревоДокументовКОтправке.ТекущаяСтрока = ИДАктивнойСтроки;
	ИначеЕсли ИДСтрокКВыделению.Количество() > 0 Тогда
		Элементы.ДеревоДокументовКОтправке.ТекущаяСтрока =  ИДСтрокКВыделению[0];
	КонецЕсли;
	
	Для Каждого ИДСтроки Из ИДСтрокКВыделению Цикл
		Элементы.ДеревоДокументовКОтправке.ВыделенныеСтроки.Добавить(ИДСтроки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоДокументов()
	
	ДеревоДокументовКОтправке.ПолучитьЭлементы().Очистить();
	
	ТаблицаИсходящихДокументов = ОбменСКонтрагентамиДОСлужебный.ИсходящиеДокументыЭДО(
		ОтборыСпискаДокументов());
	
	СтрокиПакетов = Новый Соответствие;
	
	Для Каждого СтрокаДокумента Из ТаблицаИсходящихДокументов Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаДокумента.ИдентификаторПакета) Тогда
			
			Родитель = ДеревоДокументовКОтправке;
			
		Иначе
			
			СтрокаПакета = СтрокиПакетов.Получить(СтрокаДокумента.ИдентификаторПакета);
			
			Если СтрокаПакета <> Неопределено Тогда
				
				Родитель = СтрокаПакета;
				
			Иначе
				
				Родитель = ДеревоДокументовКОтправке.ПолучитьЭлементы().Добавить();
				
				Родитель.ЭтоПакетЭДО = Истина;
				Родитель.Организация = СтрокаДокумента.Организация;
				Родитель.Контрагент = СтрокаДокумента.Контрагент;
				Родитель.ИдентификаторПакета = СтрокаДокумента.ИдентификаторПакета;
				
				СтрокиПакетов.Вставить(СтрокаДокумента.ИдентификаторПакета, Родитель);
				
			КонецЕсли;
			
		КонецЕсли;
		
		СтрокаДерева = Родитель.ПолучитьЭлементы().Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрокаДокумента);
		
		СтрокаДерева.ПредставлениеЭлемента = СтрокаДокумента.ДокументДО;
		
		Если СтрокаДерева.ПодписанЭП Тогда
			СтрокаДерева.ИндексКартинкиЭП = 2;
		Иначе
			СтрокаДерева.ИндексКартинкиЭП = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Элемент Из СтрокиПакетов Цикл
		
		СтрокаПакета = Элемент.Значение;
		
		КоллекцияСтрок = СтрокаПакета.ПолучитьЭлементы();
		
		СтрокаПакета.ПредставлениеЭлемента = СтрШаблон(
			НСтр("ru = 'Пакет ЭДО (%1)'"),
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';%1 документ;;%1 документа;%1 документов;%1 документов'"),
				КоллекцияСтрок.Количество()));
		
		ПодписанЭППервыйДокумент = КоллекцияСтрок[0].ПодписанЭП;
		
		Если ПодписанЭППервыйДокумент Тогда
			ИндексКартинкиЭП = 2;
		Иначе
			ИндексКартинкиЭП = 0;
		КонецЕсли;
		
		Для Счет = 1 По КоллекцияСтрок.Количество() - 1 Цикл
			Если КоллекцияСтрок[Счет].ПодписанЭП <> ПодписанЭППервыйДокумент Тогда
				ИндексКартинкиЭП = 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ИндексКартинкиЭП = 3 Тогда
			СтрокаПакета.ПодписанЭП = Ложь;
			СтрокаПакета.ИндексКартинкиЭП = ИндексКартинкиЭП;
		Иначе
			СтрокаПакета.ПодписанЭП = ПодписанЭППервыйДокумент;
			СтрокаПакета.ИндексКартинкиЭП = ИндексКартинкиЭП;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОтборыСпискаДокументов()
	
	Отбор = Новый Структура;
	
	Если ЗначениеЗаполнено(ОрганизацияОтбор) Тогда
		Отбор.Вставить("Организация", ОрганизацияОтбор);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтрагентОтбор) Тогда
		Отбор.Вставить("Контрагент", КонтрагентОтбор);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидДокументаОтбор) Тогда
		Отбор.Вставить("ВидДокумента", ВидДокументаОтбор);
	КонецЕсли;
	
	Если ТипОбъектовОтбор = "Документы" Тогда
		Отбор.Вставить("Объекты", "Документы");
	ИначеЕсли ТипОбъектовОтбор = "Пакеты" Тогда
		Отбор.Вставить("Объекты", "Пакеты");
	КонецЕсли;
	
	Если ДействияОтбор = "КПодписанию" Тогда
		Отбор.Вставить("Действия", "Подписание");
	ИначеЕсли ДействияОтбор = "КОтправке" Тогда
		Отбор.Вставить("Действия", "Отправка");
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

#КонецОбласти

#Область ФормированиеДанныхВыделенныхДокументов

&НаКлиенте
Процедура ПослеАктивизацииСтрокиСпискаДокументов()
	
	ОбновитьДанныеВыделенныхОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеВыделенныхОбъектов(ОбновитьПринудительно = Ложь)
	
	КлючТекущих = КлючТекущихВыделенныхСтрок();
	
	Если КлючТекущих <> КлючВыделенныхСтрок
		Или ОбновитьПринудительно Тогда
		
		КлючВыделенныхСтрок = КлючТекущих;
		
		НачатьОбновлениеДанныхВыделенных();
		ОжидатьПолучениеДанныхВыделенных();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КлючТекущихВыделенныхСтрок() Экспорт
	
	// Ключ выделенных строк пишем как <УИД пакета активной строки>_<УИД документа активной строки>_<Колво строк>
	//  Первые два - однозначно идентифицируют текущую строку, третье - количество.
	//  Количество нужно поскольку мы можем менять количество выделенных строк, не меняя активную (через ctrl)
	
	ТекущиеДанные = Элементы.ДеревоДокументовКОтправке.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтрШаблон("%1_%2_%3",
		ТекущиеДанные.ИдентификаторПакета,
		ТекущиеДанные.ДокументДО.УникальныйИдентификатор(),
		Элементы.ДеревоДокументовКОтправке.ВыделенныеСтроки.Количество());
	
КонецФункции

&НаСервере
Процедура НачатьОбновлениеДанныхВыделенных()
	
	ВыделенныеСтроки = Элементы.ДеревоДокументовКОтправке.ВыделенныеСтроки;
	
	ДанныеВыделенных = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		
		СтрокаДерева = ДеревоДокументовКОтправке.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если СтрокаДерева = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеВыделенного = Новый Структура;
		ДанныеВыделенного.Вставить("Документ", СтрокаДерева.ДокументДО);
		ДанныеВыделенного.Вставить("ИдентификаторПакета", СтрокаДерева.ИдентификаторПакета);
		
		ДанныеВыделенных.Добавить(ДанныеВыделенного);
		
	КонецЦикла;
	
	ВыбранныеОдиночныеДокументы.Очистить();
	ВыбранныеПакеты.Очистить();
	
	ПолучениеДанныхВыделенных =
		ОбменСКонтрагентамиДОСлужебный.ЗапуститьПолучениеДанныхИсходящих(
			ДанныеВыделенных, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДанныеВыделенных()
	
	Если ПолучениеДанныхВыделенных = Неопределено
		ИЛИ ПолучениеДанныхВыделенных.Статус = "Ошибка" Тогда
		
		ОтобразитьОшибкуПолученияДанныхВыделенных();
		
	ИначеЕсли ПолучениеДанныхВыделенных.Статус = "Выполнено" Тогда
		
		ОтобразитьДанныеВыделенныхДокументов()
		
	ИначеЕсли ПолучениеДанныхВыделенных.Статус = "Выполняется" Тогда
		
		ОтобразитьОжиданиеПолученияДанныхВыделенных();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДанныеВыделенныхДокументов()
	
	РезультатПолучения = ПолучитьИзВременногоХранилища(ПолучениеДанныхВыделенных.АдресРезультата);
	
	Если РезультатПолучения = Неопределено Тогда
		ОтобразитьОшибкуПолученияДанныхВыделенных();
		Возврат;
	КонецЕсли;
	
	ПолучениеДанныхВыделенных = Неопределено;
	
	ВыбранныеПакеты.ЗагрузитьЗначения(РезультатПолучения.Пакеты);
	ВыбранныеОдиночныеДокументы.ЗагрузитьЗначения(РезультатПолучения.ОдиночныеДокументы);
	
	ЗаполнитьДеревоФайлов(РезультатПолучения.ДеревоФайлов);
	
	ЗаполнитьТекстовыеОписания(РезультатПолучения);
	
	УстановитьВидимостьКоманд(РезультатПолучения.ДоступныеДействия);
	
	Элементы.СтраницыВыполненияДанныхВыделенных.ТекущаяСтраница =
		Элементы.СтраницаДанныеВыделенных;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОшибкуПолученияДанныхВыделенных()
	
	Элементы.СтраницыВыполненияДанныхВыделенных.ТекущаяСтраница =
		Элементы.СтраницаОшибкиПолучения;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОжиданиеПолученияДанныхВыделенных()
	
	Элементы.СтраницыВыполненияДанныхВыделенных.ТекущаяСтраница =
		Элементы.СтраницаОжидание;
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьПолучениеДанныхВыделенных()
	
	Если ПолучениеДанныхВыделенных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьДанныеВыделенных", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Вставить("ВыводитьОкноОжидания", Ложь);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		ПолучениеДанныхВыделенных, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеВыделенных(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучениеДанныхВыделенных = Результат;
	ОтобразитьДанныеВыделенных();
	
	Для Каждого Строка Из ДеревоФайловДокументов.ПолучитьЭлементы() Цикл
		Элементы.ДеревоФайловДокументов.Развернуть(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоФайлов(ДеревоФайлов)
	
	ДеревоФайловДокументов.ПолучитьЭлементы().Очистить();
	
	Если ТипЗнч(ДеревоФайлов) <> Тип("ДеревоЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаУровня1 Из ДеревоФайлов.Строки Цикл
		
		НоваяСтрока = ДеревоФайловДокументов.ПолучитьЭлементы().Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаУровня1);
		
		Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл
			
			НоваяДочерняяСтрока = НоваяСтрока.ПолучитьЭлементы().Добавить();
			
			ЗаполнитьЗначенияСвойств(НоваяДочерняяСтрока, СтрокаУровня2);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекстовыеОписания(РезультатПолучения)
	
	КолвоДокументов = РезультатПолучения.ОдиночныеДокументы.Количество();
	КолвоПакетов = РезультатПолучения.Пакеты.Количество();
	
	Если (КолвоПакетов = 0 И КолвоДокументов = 1)
		Или (КолвоПакетов = 1 И КолвоДокументов = 0) Тогда
		
		Элементы.НадписьОписаниеВыбранныхДанных.Видимость = Ложь;
		Элементы.НадписьОписаниеВыбранныхДанных.Заголовок = "";
		
	ИначеЕсли КолвоПакетов = 0 И КолвоДокументов = 0 Тогда 
		
		Элементы.НадписьОписаниеВыбранныхДанных.Видимость = Истина;
		Элементы.НадписьОписаниеВыбранныхДанных.Заголовок =
			НСтр("ru = 'Не выбрано объектов для отправки.'");
		
	ИначеЕсли КолвоПакетов = 0 Тогда 
		
		Элементы.НадписьОписаниеВыбранныхДанных.Видимость = Истина;
		Элементы.НадписьОписаниеВыбранныхДанных.Заголовок =
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';Выбран %1 документ;;Выбрано %1 документа;
					|Выбрано %1 документов;Выбрано %1 документов'"),
				КолвоДокументов);
		
	ИначеЕсли КолвоДокументов = 0 Тогда 
		
		Элементы.НадписьОписаниеВыбранныхДанных.Видимость = Истина;
		Элементы.НадписьОписаниеВыбранныхДанных.Заголовок =
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';Выбран %1 пакет;;Выбрано %1 пакета;
					|Выбрано %1 пакетов;Выбрано %1 пакетов'"),
				КолвоПакетов);
		
	Иначе 
		
		Элементы.НадписьОписаниеВыбранныхДанных.Видимость = Истина;
		Элементы.НадписьОписаниеВыбранныхДанных.Заголовок =
			СтрШаблон(НСтр("ru = '%1 и %2'"),
				СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
					НСтр("ru = ';Выбран %1 пакет;;Выбрано %1 пакета;
						|Выбрано %1 пакетов;Выбрано %1 пакетов'"),
					КолвоПакетов),
				СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
					НСтр("ru = ';%1 одиночный документ;;%1 одиночных документа;
						|%1 одиночных документов;%1 одиночных документов'"),
					КолвоДокументов));
		
	КонецЕсли;
	
	Если РезультатПолучения.Организации.Количество() = 1 Тогда
		
		Элементы.НадписьОрганизацииВыделенных.Заголовок = СтрШаблон(
			НСтр("ru = '%1: %2'"),
			РедакцииКонфигурацииКлиентСервер.Организация(),
			РезультатПолучения.Организации[0]);
		
	Иначе
		
		ШаблонДляСклонений = СтрШаблон(
			НСтр("ru = ';%1 %2;;%1 %3;%1 %4;%1 %4'"), 
			"%1", // меняем на самого себя - этот управляющий значок понадобится для склонений.
			РедакцииКонфигурацииКлиентСервер.ОрганизацияНРег(),
			РедакцииКонфигурацииКлиентСервер.ОрганизацииРодительный(),
			РедакцииКонфигурацииКлиентСервер.ОрганизацийРодительный()
		);
		Элементы.НадписьОрганизацииВыделенных.Заголовок =
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				ШаблонДляСклонений, РезультатПолучения.Организации.Количество());
		
	КонецЕсли;
	
	Если РезультатПолучения.Контрагенты.Количество() = 1 Тогда
		
		Элементы.НадписьКонтрагентыВыделенных.Заголовок = СтрШаблон(
			НСтр("ru = 'Контрагент: %1'"),
			РезультатПолучения.Контрагенты[0]);
		
	Иначе
		
		Элементы.НадписьКонтрагентыВыделенных.Заголовок =
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';%1 контрагент;;%1 контрагента;
					|%1 контрагентов;%1 контрагентов'"),
				РезультатПолучения.Контрагенты.Количество());
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоманд(ДоступныеДействия)
	
	Элементы.Подписать.Видимость = Ложь;
	Элементы.Подписать.Доступность = Ложь;
	Элементы.ПодписатьИОтправить.Видимость = Ложь;
	Элементы.ПодписатьИОтправить.Доступность = Ложь;
	Элементы.Отправить.Видимость = Ложь;
	Элементы.Отправить.Доступность = Ложь;
	Элементы.СоздатьПакет.Видимость = Ложь;
	Элементы.СоздатьПакет.Доступность = Ложь;
	Элементы.ДобавитьКПакету.Видимость = Ложь;
	Элементы.ДобавитьКПакету.Доступность = Ложь;
	Элементы.ИзменитьСоставПакета.Видимость = Ложь;
	Элементы.ИзменитьСоставПакета.Доступность = Ложь;
	
	Если ДоступныеДействия["Подписать"] = Истина Тогда
		
		Элементы.Подписать.Видимость = Истина;
		Элементы.Подписать.Доступность = Истина;
		Элементы.ПодписатьИОтправить.Видимость = Истина;
		Элементы.ПодписатьИОтправить.Доступность = Истина;
		
	ИначеЕсли ДоступныеДействия["Отправить"] = Истина Тогда 
		
		Элементы.Отправить.Видимость = Истина;
		Элементы.Отправить.Доступность = Истина;
		
	КонецЕсли;
	
	Если ДоступныеДействия["СоздатьПакет"] = Истина Тогда
		Элементы.СоздатьПакет.Видимость = Истина;
		Элементы.СоздатьПакет.Доступность = Истина;
	КонецЕсли;
	
	Если ДоступныеДействия["ДобавитьКПакету"] = Истина Тогда
		Элементы.ДобавитьКПакету.Видимость = Истина;
		Элементы.ДобавитьКПакету.Доступность = Истина;
	КонецЕсли;
	
	Если ДоступныеДействия["ИзменитьСоставПакета"] = Истина Тогда
		Элементы.ИзменитьСоставПакета.Видимость = Истина;
		Элементы.ИзменитьСоставПакета.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыборДокументовДляДействий

&НаКлиенте
Процедура ВыполнитьДействияПоИсходящимОбъектам(Подписать, Отправить)
	
	ДокументыДляОбработки = ВыбранныеОдиночныеДокументы.ВыгрузитьЗначения();
	ПакетыДляОбработки = ВыбранныеПакеты.ВыгрузитьЗначения();
	
	Если ДокументыДляОбработки.Количество() = 0 И ПакетыДляОбработки.Количество() = 0 Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Нет объектов для обработки!'"), , НСтр("ru = 'Нет объектов'"));
		Возврат;
		
	КонецЕсли;
	
	ПараметрыВыполненияДействий =
		ОбменСКонтрагентамиДОСлужебныйКлиент.НовыеПараметрыВыполненияДействийПоИсходящимДокументамЭДО();
	
	ВозможныеДействия = ОбменСКонтрагентамиДОСлужебныйКлиентСервер.ДействияПоИсходящимДокументам();
	
	Если Подписать Тогда
		ПараметрыВыполненияДействий.Действия.Добавить(ВозможныеДействия.Подписать);
	КонецЕсли;
	
	Если Отправить Тогда
		ПараметрыВыполненияДействий.Действия.Добавить(ВозможныеДействия.Отправить);
	КонецЕсли;
	
	ПараметрыВыполненияДействий.Документы = ДокументыДляОбработки;
	ПараметрыВыполненияДействий.Пакеты = ПакетыДляОбработки;
	ПараметрыВыполненияДействий.УникальныйИдентификатор = УникальныйИдентификатор;
	
	ОбменСКонтрагентамиДОСлужебныйКлиент.ВыполнитьДействияПоИсходящимДокументам(ПараметрыВыполненияДействий);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию()
	
	ТолькоПросмотр = Истина;
	Элементы.ГруппаМиграцияНаНовуюВерсию.Видимость = Истина;
	
	// Доступность команд настраивается при получении выделенных данных
	
	Элементы.НадписьМиграцияНаНовуюВерсию.Заголовок =
		НСтр("ru = 'Обмен с контрагентами по ЭДО выполняется и настраивается в новой версии программы. Действия необходимо производить в новой версии программы.'")
	
КонецПроцедуры

#КонецОбласти
