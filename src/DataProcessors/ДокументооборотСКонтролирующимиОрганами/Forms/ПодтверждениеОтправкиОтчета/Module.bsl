
&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	СведенияОбОтчете = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(Параметры.СсылкаНаОтчет);
	
	УстановитьНаименованиеОтчета(СведенияОбОтчете);
	УстановитьДатуИПериод(СведенияОбОтчете);
	УстановитьОрганизацию(СведенияОбОтчете);
	УстановитьОрган(СведенияОбОтчете);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилосьНаличиеСоглашенияСПФР" И Источник = Организация Тогда
		
		ИзменитьОформлениеСоглашенияСПФР();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстСоглашениеСПФРОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КонтекстЭДОКлиент.ОткрытьФормуСоглашенияСПФР(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеКорректностиЗаполненияПриИзменении(Элемент)
	
	Элементы.Отправить.Доступность = ПодтверждениеКорректностиЗаполнения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеСоглашенияСПФР()
	
	СдаватьВПФР = СведенияОбОтчете.ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР;
	
	ДокументооборотСКОВызовСервера.ИзменитьОформлениеГруппыСоглашениеСПФР(
		Организация,
		Элементы.ГруппаСоглашениеСПФР, 
		СдаватьВПФР);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНаименованиеОтчета(СведенияОбОтчете)

	ВариантОтчета = Строка(СведенияОбОтчете.ВариантОтчета);
	Если ВариантОтчета = "П" Тогда
		ВариантОтчета = НСтр("ru = 'первичный'");
	ИначеЕсли Лев(ВариантОтчета, 2) = "К/" Тогда
		ВариантОтчета = НСтр("ru = 'корректирующий'") + " / " + Сред(ВариантОтчета, 3);
	КонецЕсли;
	
	ЛеваяСкобка 	= ?(НЕ ПустаяСтрока(ВариантОтчета), " (", "");
	ПраваяСкобка 	= ?(НЕ ПустаяСтрока(ВариантОтчета), ")", "");
	
	Элементы.НаименованиеИВариантОтчета.Заголовок = Строка(СведенияОбОтчете.Наименование) + ЛеваяСкобка + ВариантОтчета + ПраваяСкобка;

КонецПроцедуры
 
&НаСервере
Процедура УстановитьДатуИПериод(СведенияОбОтчете)

	ПериодЗадан = ЗначениеЗаполнено(СведенияОбОтчете.ПредставлениеПериода);
		
	Элементы.ГруппаДатаСоздания.Видимость 	= НЕ ПериодЗадан;
	Элементы.ГруппаПериод.Видимость 		= ПериодЗадан;
	
	Если ПериодЗадан Тогда
		Элементы.ПредставлениеПериода.Заголовок = Строка(СведенияОбОтчете.ПредставлениеПериода);
	Иначе
		Элементы.ДатаСоздания.Заголовок = Формат(СведенияОбОтчете.Дата, "ДФ=dd.MM.yyyy");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьОрганизацию(СведенияОбОтчете)

	Организация = СведенияОбОтчете.Организация;
	Элементы.НаименованиеОрганизации.Заголовок = Строка(Организация.Наименование);

КонецПроцедуры

&НаСервере
Процедура УстановитьОрган(СведенияОбОтчете)

	Элементы.ПредставлениеКонтролирующегоОргана.Заголовок 	= Строка(СведенияОбОтчете.ПредставлениеКонтролирующегоОргана);
	
	ИзменитьОформлениеСоглашенияСПФР();

КонецПроцедуры

#КонецОбласти