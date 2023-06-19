
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл
		ИмяБизнесПроцесса = БизнесПроцесс.Имя;
		ТипыБизнесПроцессов.Добавить(БизнесПроцессы[ИмяБизнесПроцесса].ПустаяСсылка(), БизнесПроцесс.Синоним);
	КонецЦикла;	
	ТипыБизнесПроцессов.Вставить(0, Неопределено, НСтр("ru = 'Все повторения'"));
	
	ТипБизнесПроцесса = Неопределено;
	Список.Параметры.УстановитьЗначениеПараметра("ТипБизнесПроцесса", ТипБизнесПроцесса);
	
	ПоказатьПрекращенные = Ложь;
	УстановитьОтбор(Список, ПоказатьПрекращенные);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтбор(Список, Прекращенные)
	
	Если Прекращенные = Неопределено Тогда 
		Прекращенные = Ложь;
	КонецЕсли;	
	
	Если Прекращенные Тогда 
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ПовторениеЗавершено");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ПовторениеЗавершено", Ложь);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтбор(Список, Настройки["ПоказатьПрекращенные"]);
	
КонецПроцедуры

&НаКлиенте
Процедура Расписание(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("БизнесПроцесс", ТекущиеДанные.БизнесПроцесс);
	ОткрытьФорму("РегистрСведений.НастройкаПовторенияБизнесПроцессов.Форма.ФормаРасписания", ПараметрыФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Прекратить(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ЗавершитьНаСервере(ТекущаяСтрока);
	ОповеститьОбИзменении(ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьНаСервере(ТекущаяСтрока)
	
	МенеджерЗаписи = РегистрыСведений.НастройкаПовторенияБизнесПроцессов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.БизнесПроцесс = ТекущаяСтрока.БизнесПроцесс;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда 
		МенеджерЗаписи.ПовторениеЗавершено = Истина;
		МенеджерЗаписи.Записать();
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПоказатьЗавершенныеПриИзменении(Элемент)
	
	УстановитьОтбор(Список, ПоказатьПрекращенные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.ТипыБизнесПроцессов.ТекущаяСтрока <> Неопределено Тогда 
		
		ТекущееЗначение = Элементы.ТипыБизнесПроцессов.ТекущиеДанные.Значение;
		Список.Параметры.УстановитьЗначениеПараметра("ТипБизнесПроцесса", ТекущееЗначение);
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ТипыБизнесПроцессовПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Элементы.ТипыБизнесПроцессов.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущееЗначение = Элементы.ТипыБизнесПроцессов.ТекущиеДанные.Значение;
	Если ТекущееЗначение = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
		
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипБизнесПроцесса", ТекущееЗначение);
	
	ОткрытьФорму("РегистрСведений.НастройкаПовторенияБизнесПроцессов.ФормаЗаписи", ПараметрыФормы, Элемент);
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	Элементы.ПоказатьПрекращенные.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	
	Элементы.Переместить(Элементы.Прекратить, Элементы.СписокКонтекстноеМеню,Элементы.СписокКонтекстноеМеню);
	Элементы.Переместить(Элементы.Расписание, Элементы.СписокКонтекстноеМеню,Элементы.СписокКонтекстноеМеню);
	
	Элементы.ТипыБизнесПроцессов.Видимость = Ложь;
	
	// Добавление поля ввода.
	Элемент = ЭтаФорма.Элементы.Добавить("ПолеВыбораМК", Тип("ПолеФормы"), ЭтаФорма);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "ТипыБизнесПроцессов";
	Элемент.УстановитьДействие("НачалоВыбора","ПолеВыбораМКНачалоВыбора");
	Элементы.Переместить(Элемент, ЭтаФорма.КоманднаяПанель, ЭтаФорма.КоманднаяПанель);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораМКНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры
