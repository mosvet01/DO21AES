
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидДокументаЭДО = Параметры.ВидДокументаЭДО;
	ФорматДокумента = Параметры.Формат;
	ТребуетсяИзвещениеОПолучении = Параметры.ТребуетсяИзвещениеОПолучении;
	ТребуетсяОтветнаяПодпись = Параметры.ТребуетсяОтветнаяПодпись;
	
	ОтборФорматов = ЭлектронныеДокументыЭДО.НовыйОтборФорматовЭлектронныхДокументов();
	ОтборФорматов.Действует = Истина;
	ФорматыЭД.Загрузить(ЭлектронныеДокументыЭДО.ФорматыЭлектронныхДокументов(ОтборФорматов));
	
	УстановитьВидимостьДоступность(Ложь);
	
	Если МиграцияДанныхИзВнешнихСистемСервер.БлокироватьОбменСВнешнимиРесурсами() Тогда
		УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидДокументаЭДОПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматДокументаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Закрыть(СтруктураНастроек());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СтруктураНастроек()
	
	СтруктураНастроек = Новый Структура;
	
	СтрокиФорматов = ФорматыЭД.НайтиСтроки(
		Новый Структура("ВидДокумента", ВидДокументаЭДО));
	
	Если СтрокиФорматов.Количество() = 0 Тогда
		ФорматДокумента = "";
	КонецЕсли;
	
	СтруктураНастроек.Вставить("ВидДокументаЭДО", ВидДокументаЭДО);
	СтруктураНастроек.Вставить("Формат", ФорматДокумента);
	СтруктураНастроек.Вставить("ТребуетсяИзвещениеОПолучении", ТребуетсяИзвещениеОПолучении);
	СтруктураНастроек.Вставить("ТребуетсяОтветнаяПодпись", ТребуетсяОтветнаяПодпись);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьДоступность(ПерезаписатьНастройки = Истина)
	
	ОписаниеВидаДокумента = ЭлектронныеДокументыЭДО.ОписаниеВидаДокумента(ВидДокументаЭДО);
	НастройкиРегламента =
		ЭлектронныеДокументыЭДО.НастройкиРегламента(ОписаниеВидаДокумента, ФорматДокумента);
	
	Если НастройкиРегламента <> Неопределено Тогда
		Элементы.ТребуетсяОтветнаяПодпись.Доступность = НастройкиРегламента.РедактироватьОтветнуюПодпись;
		Элементы.ТребуетсяИзвещениеОПолучении.Доступность = НастройкиРегламента.РедактироватьИзвещение;
		
		Если ПерезаписатьНастройки Или Не НастройкиРегламента.РедактироватьОтветнуюПодпись Тогда
			ТребуетсяОтветнаяПодпись = НастройкиРегламента.ТребуетсяОтветнаяПодпись;
		КонецЕсли;
		
		Если ПерезаписатьНастройки Или Не НастройкиРегламента.РедактироватьИзвещение Тогда
			ТребуетсяИзвещениеОПолучении = НастройкиРегламента.ТребуетсяИзвещениеОПолучении;
		КонецЕсли;
	КонецЕсли;
	
	НастроитьВыборФормата();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВыборФормата()
	
	Элементы.ФорматДокумента.Видимость = Ложь;
	
	Если Не ЗначениеЗаполнено(ВидДокументаЭДО) Тогда
		ФорматДокумента = "";
		Возврат;
	КонецЕсли;
	
	СтрокиФорматов = ФорматыЭД.НайтиСтроки(
		Новый Структура("ВидДокумента", ВидДокументаЭДО));
	
	Если СтрокиФорматов.Количество() = 0 Тогда
		ФорматДокумента = "";
		Возврат;
	КонецЕсли;
	
	Элементы.ФорматДокумента.Видимость = Истина;
	Элементы.ФорматДокумента.СписокВыбора.Очистить();
	
	НайденФормат = Ложь;
	
	Элементы.ФорматДокумента.СписокВыбора.Добавить(
		"", НСтр("ru = 'Автоматически'"));
	
	Для Каждого СтрокаТаблицы Из СтрокиФорматов Цикл
		Элементы.ФорматДокумента.СписокВыбора.Добавить(СтрокаТаблицы.ИдентификаторФормата,
			СтрокаТаблицы.ПредставлениеФормата);
		
		Если СтрокаТаблицы.ИдентификаторФормата = ФорматДокумента Тогда
			НайденФормат = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не НайденФормат Тогда
		ФорматДокумента = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию()
	
	ТолькоПросмотр = Истина;
	Элементы.ГруппаМиграцияНаНовуюВерсию.Видимость = Истина;
	Элементы.ФормаСохранитьНастройки.Доступность = Ложь;
	
	Элементы.НадписьМиграцияНаНовуюВерсию.Заголовок =
		НСтр("ru = 'Обмен с контрагентами по ЭДО выполняется и настраивается в новой версии программы. Настройки отправки документов необходимо производить в новой версии программы.'");
	
КонецПроцедуры

#КонецОбласти