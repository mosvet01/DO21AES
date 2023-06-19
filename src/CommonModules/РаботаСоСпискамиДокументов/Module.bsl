#Область ПрограммныйИнтерфейс

// Переключает вид просмотра в списках документов.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой расположен список.
//
Процедура ПереключитьВидПросмотра(Форма) Экспорт 
	
	Элементы = Форма.Элементы;
	Список = Форма.Список;
	ВидПросмотра = Форма.ВидПросмотра;
	ПредыдущийВидПросмотра = Форма.ПредыдущийВидПросмотра;
	
	РаботаСКатегориямиДанныхКлиентСервер.ОтключитьКатегорииКакПараметры(Список, 10);
	
	ПараметрыКомпоновки = Новый Структура(
		"Папка, 
		|ВидДокумента, 
		|ВопросДеятельности, 
		|Контрагент, 
		|Проект, 
		|НоменклатураДел, 
		|Дело");
		
	Для Каждого ИмяПараметра Из ПараметрыКомпоновки Цикл
		Параметр = Список.Параметры.НайтиЗначениеПараметра(
			Новый ПараметрКомпоновкиДанных(ИмяПараметра.Ключ));
		Если Параметр <> Неопределено И Параметр.Использование Тогда 
			Параметр.Использование = Ложь;
		КонецЕсли;	
	КонецЦикла;
	
	Если Элементы.Найти("Папка") <> Неопределено Тогда 
		Элементы.Папка.Видимость = Истина;
	КонецЕсли;	
	
	Если Элементы.Найти("СтраницаПапки") <> Неопределено Тогда 	
		Элементы.СтраницаПапки.Видимость = Ложь;
	КонецЕсли;
	
	Если Элементы.Найти("СтраницаПапки") <> Неопределено Тогда 	
		Элементы.ОтборПапка.Видимость = Истина;
	КонецЕсли;	
	
	Если Элементы.Найти("РежимПросмотраПоПапкам") <> Неопределено Тогда 
		Элементы.РежимПросмотраПоПапкам.Пометка = Ложь;
	КонецЕсли;	
	
	Если Элементы.Найти("Контрагент") <> Неопределено Тогда 
		Элементы.Контрагент.Видимость = Истина;
	ИначеЕсли Элементы.Найти("Отправитель") <> Неопределено Тогда 
		Элементы.Отправитель.Видимость = Истина;
	ИначеЕсли Элементы.Найти("Получатели") <> Неопределено Тогда 
		Элементы.Получатели.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ВидДокумента.Видимость = Истина;
	Элементы.ВопросДеятельности.Видимость = Истина;
	Элементы.НоменклатураДел.Видимость = Истина;
	Элементы.Дело.Видимость = Истина;
	Элементы.ЕстьКатегории.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных");
	Элементы.Проект.Видимость = Истина;
	
	Элементы.СтраницыДеревоРазрезов.Видимость = Истина;
	Элементы.СтраницаВидыДокументов.Видимость = Ложь;
	Элементы.СтраницаВопросыДеятельности.Видимость = Ложь;
	Элементы.СтраницаКонтрагенты.Видимость = Ложь;
	Элементы.СтраницаНоменклатураДел.Видимость = Ложь;
	Элементы.СтраницаДелаТома.Видимость = Ложь;
	Элементы.СтраницаПроекты.Видимость = Ложь;
	Элементы.СтраницаКатегории.Видимость = Ложь;
	
	Если Элементы.Найти("ОтборВидДокумента") <> Неопределено Тогда 
		Элементы.ОтборВидДокумента.Видимость = Истина;
	КонецЕсли;
	Элементы.ОтборКонтрагент.Видимость = Истина;
	Если Элементы.Найти("ОтборПроект") <> Неопределено Тогда 
		Элементы.ОтборПроект.Видимость = Истина;
	КонецЕсли;
	Элементы.ОтборКатегория.Видимость = Истина;
	
	Элементы.РежимПросмотраСписком.Пометка = Ложь;
	Элементы.РежимПросмотраПоВидамДокументов.Пометка = Ложь;
	Элементы.РежимПросмотраПоВопросамДеятельности.Пометка = Ложь;
	Элементы.РежимПросмотраПоКонтрагентам.Пометка = Ложь;
	Элементы.РежимПросмотраПоНоменклатуреДел.Пометка = Ложь;
	Элементы.РежимПросмотраПоДеламТомам.Пометка = Ложь;
	Элементы.РежимПросмотраПоКатегориям.Пометка = Ложь;
	Элементы.РежимПросмотраПоПроектам.Пометка = Ложь;
	
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраСписком") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраСписком.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоПапкам") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоПапкам.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоВидамДокументов") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоВидамДокументов.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоВопросамДеятельности") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоВопросамДеятельности.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоКонтрагентам") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоКонтрагентам.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоНоменклатуреДел") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоНоменклатуреДел.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоДеламТомам") <> Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюРежимПросмотраПоДеламТомам.Пометка = Ложь;
	КонецЕсли;
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоКатегориям") <> Неопределено Тогда 
		Элементы.РежимПросмотраПоКатегориям.Пометка = Ложь;
	КонецЕсли;	
	Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоПроектам") <> Неопределено Тогда 
		Элементы.РежимПросмотраПоПроектам.Пометка = Ложь;
	КонецЕсли;	
	
	Если ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком Тогда
		
		Элементы.СтраницыДеревоРазрезов.Видимость = Ложь;
		Элементы.РежимПросмотраСписком.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраСписком") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраСписком.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам Тогда
		
		Если ЗначениеЗаполнено(Форма.Папка) Тогда 
			Форма.Папка = Неопределено;
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Папка");
			ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборПапка, Неопределено);
		КонецЕсли;
		
		Элементы.СтраницаПапки.Видимость = Истина;
		
		Форма.ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
		Если ЗначениеЗаполнено(Форма.ТекущаяПапка) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Папка", Форма.ТекущаяПапка);
		КонецЕсли;	
		
		Элементы.ОтборПапка.Видимость = Ложь;
		Элементы.Папка.Видимость = Ложь;
		Элементы.РежимПросмотраПоПапкам.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоПапкам") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоПапкам.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоКатегориям Тогда
		
		Если Форма.ИспользоватьКатегорииДанных Тогда	
			
			Если ЗначениеЗаполнено(Форма.Категория) Тогда 
				Форма.Категория = Неопределено;
				Параметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Категория"));
				Параметр.Использование = Ложь;
				ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборКатегория, Неопределено);
			КонецЕсли;
			
			Если Форма.ИмяФормы = "Справочник.ВнутренниеДокументы.Форма.ФормаСпискаСПапками" Тогда 
				КлючОбъекта = "СписокВнутреннихДокументов";
			ИначеЕсли Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ОбращенияГраждан" Тогда 	
				КлючОбъекта = "СписокОбращенийГраждан";
			ИначеЕсли Форма.ИмяФормы = "Справочник.ВходящиеДокументы.Форма.ФормаСписка" Тогда 	
				КлючОбъекта = "СписокВходящихДокументов";	
			ИначеЕсли Форма.ИмяФормы = "Справочник.ИсходящиеДокументы.Форма.ФормаСписка" Тогда 	
				КлючОбъекта = "СписокИсходящихДокументов";
			КонецЕсли;	
			
			Форма.ВсеКатегорииПредопределенное = Справочники.КатегорииДанных.ВсеКатегории;
			Форма.КатегорииПриОткрытии = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "ОткрытыеКатегории");
				
			Форма.ТекущаяКатегорияПриОткрытии = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "ТекущаяКатегория");
				
			Форма.ТекущаяКатегория = Форма.ТекущаяКатегорияПриОткрытии;
			
			Форма.ВыбранныеКатегорииПриОткрытии = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "ВыбранныеКатегории");
				
			Если Форма.ВыбранныеКатегорииПриОткрытии.Количество() = 1 И
				Форма.ВыбранныеКатегорииПриОткрытии[0].Значение = Форма.ТекущаяКатегория Тогда
				Форма.ВыбранныеКатегорииПриОткрытии.Очистить();
			КонецЕсли;
			
			Форма.ОтборДанных = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "ОтборДанных");	
				
			Форма.СУчетомПодкатегорий = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "СУчетомПодкатегорий");
				
			Форма.ПоказыватьСписокОтмеченных = 
				ХранилищеНастроекДанныхФорм.Загрузить(КлючОбъекта, "ПоказыватьСписокОтмеченных");
			
			Если Не ЗначениеЗаполнено(Форма.ОтборДанных) Тогда
				Форма.ОтборДанных = "ПоВсем";
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Форма.СУчетомПодкатегорий) Тогда
				Форма.СУчетомПодкатегорий = Истина;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Форма.ПоказыватьСписокОтмеченных) Тогда
				Форма.ПоказыватьСписокОтмеченных = Ложь;
			КонецЕсли;
			Если Форма.ОтборДанных = "ПоВсем" Тогда
				Элементы.ДеревоКатегорийПоказыватьСУчетомОднойИзОтмеченных.Пометка = Ложь;
				Элементы.ДеревоКатегорийПоказыватьСУчетомВсехОтмеченных.Пометка = Истина;
			Иначе
				Элементы.ДеревоКатегорийПоказыватьСУчетомОднойИзОтмеченных.Пометка = Истина;
				Элементы.ДеревоКатегорийПоказыватьСУчетомВсехОтмеченных.Пометка = Ложь;
			КонецЕсли;
			
			Элементы.ДеревоКатегорийПоказыватьСУчетомИерархии.Пометка = Форма.СУчетомПодкатегорий;
			Элементы.ДеревоКатегорийПоказыватьВыбранныеКатегории.Пометка = Форма.ПоказыватьСписокОтмеченных;
			Элементы.ВыбранныеКатегории.Видимость = Форма.ПоказыватьСписокОтмеченных;
		КонецЕсли;
	
		Форма.ПостроитьДеревоКатегорий();
		Элементы.СтраницаКатегории.Видимость = Истина;
		
		Форма.УстановитьПараметрыВыбранныхКатегорий();
		РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(
			Элементы.ДеревоКатегорий, Форма.ДеревоКатегорий, Форма.ТекущаяКатегория);
		
		Элементы.ОтборКатегория.Видимость = Ложь;
		Элементы.ЕстьКатегории.Видимость = Ложь;
		Элементы.РежимПросмотраПоКатегориям.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоКатегориям") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоКатегориям.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов Тогда
		
		Если Элементы.Найти("ОтборВидДокумента") <> Неопределено Тогда 
			Если ЗначениеЗаполнено(Форма.ВидДокумента) Тогда 
				Форма.ВидДокумента = Неопределено;
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
					"ВидДокумента");
				ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборВидДокумента, Неопределено);
			КонецЕсли;
		КонецЕсли;
		
		Элементы.СтраницаВидыДокументов.Видимость = Истина;
		
		Форма.ТекущийВидДокумента = Элементы.ВидыДокументов.ТекущаяСтрока;
		Если ЗначениеЗаполнено(Форма.ТекущийВидДокумента) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("ВидДокумента", 
				Форма.ТекущийВидДокумента);
			НастроитьСписокСогласноВидуДокумента(Форма);
		КонецЕсли;
		
		Если Элементы.Найти("ОтборВидДокумента") <> Неопределено Тогда
			Элементы.ОтборВидДокумента.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.ВидДокумента.Видимость = Ложь;
		Элементы.РежимПросмотраПоВидамДокументов.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоВидамДокументов") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоВидамДокументов.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоВопросамДеятельности Тогда
		
		Элементы.СтраницаВопросыДеятельности.Видимость = Истина;
		
		Форма.ТекущийВопросДеятельности = Элементы.ВопросыДеятельности.ТекущаяСтрока;
		Если ЗначениеЗаполнено(Форма.ТекущийВопросДеятельности) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("ВопросДеятельности", 
				Форма.ТекущийВопросДеятельности);
		КонецЕсли;
		
		Элементы.ВопросДеятельности.Видимость = Ложь;
		Элементы.РежимПросмотраПоВопросамДеятельности.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоВопросамДеятельности") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоВопросамДеятельности.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам Тогда
		
		Элементы.СтраницаКонтрагенты.Видимость = Истина;
		
		Форма.ТекущийКонтрагент = Элементы.Контрагенты.ТекущаяСтрока;
		Если ЗначениеЗаполнено(Форма.ТекущийКонтрагент) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Контрагент", 
				Форма.ТекущийКонтрагент);
		КонецЕсли;
		
		Элементы.ОтборКонтрагент.Видимость = Ложь;
		Элементы.РежимПросмотраПоКонтрагентам.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоКонтрагентам") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоКонтрагентам.Пометка = Истина;
		КонецЕсли;
		
		Если Элементы.Найти("Контрагент") <> Неопределено Тогда 
			Элементы.Контрагент.Видимость = Ложь;
			
			Если ЗначениеЗаполнено(Форма.Контрагент) Тогда 
				Форма.Контрагент = Неопределено;
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
					"Контрагент");
				ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборКонтрагент, Неопределено);
			КонецЕсли;
			
		ИначеЕсли Элементы.Найти("Отправитель") <> Неопределено Тогда 
			Элементы.Отправитель.Видимость = Ложь;
			
			Если ЗначениеЗаполнено(Форма.Отправитель) Тогда 
				Форма.Отправитель = Неопределено;
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
					"Отправитель");
				ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборКонтрагент, Неопределено);
			КонецЕсли;
			
		ИначеЕсли Элементы.Найти("Получатели") <> Неопределено Тогда 
			Элементы.Получатели.Видимость = Ложь;
			
			Если ЗначениеЗаполнено(Форма.Получатель) Тогда 
				Форма.Получатель = Неопределено;
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
					"Получатель");
				ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборКонтрагент, Неопределено);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПроектам Тогда
		
		Если ЗначениеЗаполнено(Форма.Проект) Тогда 
			Форма.Проект = Неопределено;
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Проект");
			ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборПроект, Неопределено);
		КонецЕсли;
		
		Элементы.СтраницаПроекты.Видимость = Истина;
		
		Форма.ТекущийПроект = Элементы.Проекты.ТекущаяСтрока;
		Если ЗначениеЗаполнено(Форма.ТекущийПроект) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Проект", Форма.ТекущийПроект);
		КонецЕсли;	
		
		Если Элементы.Найти("ОтборПроект") <> Неопределено Тогда 
			Элементы.ОтборПроект.Видимость = Ложь;
		КонецЕсли;	
		
		Элементы.Проект.Видимость = Ложь;
		Элементы.РежимПросмотраПоПроектам.Пометка = Истина;	
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоПроектам") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоПроектам.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоНоменклатуреДел Тогда	
		
		ЗаполнитьДеревоНоменклатурыДел(Форма);
		Элементы.СтраницаНоменклатураДел.Видимость = Истина;
		
		ТекущаяСтрока = Элементы.СписокНоменклатураДел.ТекущаяСтрока;
		Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("НоменклатураДел", ТекущаяСтрока);
		КонецЕсли;
		
		Элементы.НоменклатураДел.Видимость = Ложь;
		Элементы.РежимПросмотраПоНоменклатуреДел.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоНоменклатуреДел") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоНоменклатуреДел.Пометка = Истина;
		КонецЕсли;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоДеламТомам Тогда
		
		ЗаполнитьДеревоДелТомов(Форма);
		Элементы.СтраницаДелаТома.Видимость = Истина;
		
		ТекущаяСтрока = Элементы.ДелаТома.ТекущаяСтрока;
		Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Дело", ТекущаяСтрока);
		КонецЕсли;	
		
		Элементы.Дело.Видимость = Ложь;
		Элементы.РежимПросмотраПоДеламТомам.Пометка = Истина;
		Если Элементы.Найти("СписокКонтекстноеМенюРежимПросмотраПоДеламТомам") <> Неопределено Тогда 
			Элементы.СписокКонтекстноеМенюРежимПросмотраПоДеламТомам.Пометка = Истина;
		КонецЕсли;
		
	Иначе
		Форма.ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
		ПереключитьВидПросмотра(Форма);
	КонецЕсли;
	
	Если Форма.ИспользоватьКатегорииДанных = Истина 
		И ПредыдущийВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоКатегориям 
		И ВидПросмотра <> Перечисления.ВидыПросмотраСпискаОбъектов.ПоКатегориям Тогда
			РаботаСКатегориямиДанных.ЗаписатьПараметрыДереваКатегорийВСпискахДокументов(
				КлючОбъекта,
				Форма.СписокРаскрытыхКатегорий,
				Форма.ТекущаяКатегория,
				Форма.ВыбранныеКатегории,
				Форма.ОтборДанных,
				Форма.СУчетомПодкатегорий,
				Форма.ПоказыватьСписокОтмеченных);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет дерево номенклатуры дел в списках документов.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой расположен список.
//
Процедура ЗаполнитьДеревоНоменклатурыДел(Форма) Экспорт 
	
	Дерево = Форма.РеквизитФормыВЗначение("НоменклатураДел");
	Дерево.Строки.Очистить();
	
	Делопроизводство.ЗаполнитьДеревоНоменклатурыДел(Дерево, 
		Форма.ГодНоменклатурыДел, 
		Форма.ОрганизацияНоменклатурыДел);
	
	Форма.ЗначениеВРеквизитФормы(Дерево, "НоменклатураДел");
	
КонецПроцедуры	

// Заполняет дерево дел (томов) в списках документов.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой расположен список.
//
Процедура ЗаполнитьДеревоДелТомов(Форма) Экспорт 
	
	Дерево = Форма.РеквизитФормыВЗначение("ДелаТома");
	Дерево.Строки.Очистить();
	
	Делопроизводство.ЗаполнитьДеревоДелТомов(Дерево, 
		Форма.ГодНоменклатурыДел, 
		Форма.ОрганизацияНоменклатурыДел);
	
	Форма.ЗначениеВРеквизитФормы(Дерево, "ДелаТома");
	
КонецПроцедуры	

// Возвращает контрагента, указанного в документе.
//
// Параметры:
//   Документ - СправочникСсылка.ВнутренниеДокументы, 
//				СправочникСсылка.ВходящиеДокументы, 
//				СправочникСсылка.ИсходящиеДокументы - форма, в которой расположен список.
//
// Возвращаемое значение:
//   СправочникСсылка.Контрагенты - контрагент в документе.
//
Функция ПолучитьКонтрагента(Документ) Экспорт 
	
	Если ТипЗнч(Документ) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		ТекущийКонтрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Контрагент");
	ИначеЕсли ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		ТекущийКонтрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Отправитель");
	ИначеЕсли ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		Получатели = Документ.Получатели;
		Если Получатели.Количество() > 0 Тогда 
			ТекущийКонтрагент = Получатели[0].Получатель;
		КонецЕсли;
	КонецЕсли;
		
	Возврат ТекущийКонтрагент;
	
КонецФункции	

// Устанавливает/снимает пометку удаления для переданного массива документов.
//
// Параметры:
//   Документы - Массив - документы, для которых нужно установить пометку.
//   Пометка - Булево - устанавливаемая пометка.
//
Процедура УстановитьДокументамПометкуУдаленияСервер(Документы, Пометка) Экспорт 
	
	Для каждого Документ Из Документы Цикл
		Права = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Документ);
		Если Не Права.Удаление Тогда
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вас нет прав на установку пометки удаления документа ""%1"".'"),
				Строка(Документ));
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
	КонецЦикла;	
		
	Для каждого Документ Из Документы Цикл	
		ЗаблокироватьДанныеДляРедактирования(Документ);
		ДокументОбъект = Документ.ПолучитьОбъект();
		ДокументОбъект.УстановитьПометкуУдаления(Пометка);
		РазблокироватьДанныеДляРедактирования(Документ);
	КонецЦикла;
	
КонецПроцедуры

// Настраивает список согласно настройкам выбранного вида документа.
//
Процедура НастроитьСписокСогласноВидуДокумента(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	ВидДокумента = Элементы.ВидыДокументов.ТекущаяСтрока;
	Если ТипЗнч(ВидДокумента) <> Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	ПределСторон = 2;
	
	ТипыСторон = Новый Соответствие;
	ТипыСторон[Тип("СправочникСсылка.Организации")] = "ДопустимыОрганизации";
	ТипыСторон[Тип("СправочникСсылка.Контрагенты")] = "ДопустимыКонтрагенты";
	ТипыСторон[Тип("СправочникСсылка.Пользователи")] = "ДопустимыПользователи";
	
	НаименованияСторон = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента,
		"НаименованияСторон", Истина);
	ЕстьСтороны = Ложь;
	Если НаименованияСторон <> Неопределено Тогда
		Выборка = НаименованияСторон.Выбрать();
		ЕстьСтороны = Выборка.Количество() > 0;
	КонецЕсли;
	
	Если ЕстьСтороны Тогда
		
		Номер = 1;
		Пока Выборка.Следующий()
			И Номер <= ПределСторон Цикл
			// Установим видимость и заголовки.
			Элементы["ОтборСторона" + Номер].Видимость = Истина;
			Элементы["ОтборСторона" + Номер].Заголовок = Выборка.НаименованиеСтороны;
			Элементы["ОтборСторона" + Номер].ПодсказкаВвода = Выборка.НаименованиеСтороны;
			Элементы["Сторона" + Номер].Видимость = Истина;
			Элементы["Сторона" + Номер].Заголовок = Выборка.НаименованиеСтороны;
			// Приведем типы.
			Для Каждого ТипСтороны Из ТипыСторон Цикл
				Форма["Сторона" + Номер + ТипСтороны.Значение] = Выборка[ТипСтороны.Значение];
				Если ТипЗнч(Форма["Сторона" + Номер]) = ТипСтороны.Ключ
					И НЕ Выборка[ТипСтороны.Значение] Тогда
					Форма["Сторона" + Номер] = Неопределено;
				КонецЕсли;
			КонецЦикла;
			// Назначим пустое значение по умолчанию.
			Если Форма["Сторона" + Номер] = Неопределено Тогда
				Для Каждого ТипСтороны Из ТипыСторон Цикл
					Если Выборка[ТипСтороны.Значение] Тогда
						ОписаниеТипов = Новый ОписаниеТипов(
							ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипСтороны.Ключ));
						Форма["Сторона" + Номер] = ОписаниеТипов.ПривестиЗначение();
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			// Изменим отбор.
			Если ЗначениеЗаполнено(Форма["Сторона" + Номер]) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Форма.Список.Отбор,
					"Сторона" + Номер, Форма["Сторона" + Номер]);
			Иначе
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Форма.Список.Отбор,
					"Сторона" + Номер);
			КонецЕсли;
			// Настроим ограничение типа.
			Типы = Новый Массив;
			Для Каждого ТипСтороны Из ТипыСторон Цикл
				Если Выборка[ТипСтороны.Значение] Тогда
					Типы.Добавить(ТипСтороны.Ключ);
				КонецЕсли;
			КонецЦикла;
			Элементы["ОтборСторона" + Номер].ОграничениеТипа = Новый ОписаниеТипов(Типы);
			Номер = Номер + 1;
		КонецЦикла;
		
		Пока Номер <= ПределСторон Цикл
			Элементы["Сторона" + Номер].Видимость = Ложь;
			Элементы["Сторона" + Номер].Заголовок = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			Элементы["ОтборСторона" + Номер].Видимость = Ложь;
			Элементы["ОтборСторона" + Номер].Заголовок = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			Элементы["ОтборСторона" + Номер].ПодсказкаВвода = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Форма.Список.Отбор,
				"Сторона" + Номер);
			Номер = Номер + 1;
		КонецЦикла;
		
		// Выключим видимость организаций и сбросим отбор.
		Элементы.ОтборОрганизация.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Форма.Список.Отбор,
			"Организация");
		Элементы.Организация.Видимость = Ложь;
		
		// Выключим видимость контрагентов и сбросим отбор.
		Элементы.ОтборКонтрагент.Видимость = Ложь;
		Форма.Список.Параметры.УстановитьЗначениеПараметра("ОтборПоКонтрагенту", Ложь);
		Форма.Список.Параметры.УстановитьЗначениеПараметра("КонтрагентОтбор", Неопределено);
		Элементы.КонтрагентыДляСписков.Видимость = Ложь;
		
	Иначе
		
		// Выключим видимость сторон.
		Для Номер = 1 По ПределСторон Цикл
			Элементы["Сторона" + Номер].Видимость = Ложь;
			Элементы["Сторона" + Номер].Заголовок = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			Элементы["ОтборСторона" + Номер].Видимость = Ложь;
			Элементы["ОтборСторона" + Номер].Заголовок = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			Элементы["ОтборСторона" + Номер].ПодсказкаВвода = СтрШаблон(НСтр("ru = 'Сторона %1'"), Номер);
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Форма.Список.Отбор,
				"Сторона" + Номер);
		КонецЦикла;
		
		// Включим видимость организации и установим отбор.
		Элементы.ОтборОрганизация.Видимость = Истина;
		Если ЗначениеЗаполнено(Форма.Организация) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Форма.Список.Отбор,
				"Организация", Форма.Организация);
		КонецЕсли;
		Элементы.Организация.Видимость = Истина;
		
		// Включим видимость контрагента и установим отбор.
		Элементы.ОтборКонтрагент.Видимость = Истина;
		Если ЗначениеЗаполнено(Форма.Контрагент) Тогда
			Форма.Список.Параметры.УстановитьЗначениеПараметра("ОтборПоКонтрагенту", Истина);
			Форма.Список.Параметры.УстановитьЗначениеПараметра("КонтрагентОтбор", Форма.Контрагент);
		КонецЕсли;
		Элементы.КонтрагентыДляСписков.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные выбора стороны по введенному тексту.
//
Функция ДанныеВыбораСтороны(Текст, ДопустимыОрганизации, ДопустимыКонтрагенты, ДопустимыПользователи) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Не ДопустимыОрганизации
		И Не ДопустимыКонтрагенты
		И Не ДопустимыПользователи Тогда
		Возврат ДанныеВыбора;
	КонецЕсли;
	
	Подзапросы = Новый Массив;
	Если ДопустимыОрганизации Тогда
		Подзапросы.Добавить(СтрЗаменить(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
			|	Организации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	Организации.Наименование ПОДОБНО &Текст
			|	И НЕ Организации.ПометкаУдаления
			|",
			"РАЗРЕШЕННЫЕ",
			?(Подзапросы.Количество() = 0, "РАЗРЕШЕННЫЕ", "")));
	КонецЕсли;
	Если ДопустимыКонтрагенты Тогда
		Подзапросы.Добавить(СтрЗаменить(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
			|	Контрагенты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Наименование ПОДОБНО &Текст
			|	И НЕ Контрагенты.ПометкаУдаления
			|",
			"РАЗРЕШЕННЫЕ",
			?(Подзапросы.Количество() = 0, "РАЗРЕШЕННЫЕ", "")));
	КонецЕсли;
	Если ДопустимыПользователи Тогда
		Подзапросы.Добавить(СтрЗаменить(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
			|	Пользователи.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Пользователи КАК Пользователи
			|ГДЕ
			|	Пользователи.Наименование ПОДОБНО &Текст
			|	И НЕ Пользователи.ПометкаУдаления
			|	И НЕ Пользователи.Недействителен
			|",
			"РАЗРЕШЕННЫЕ",
			?(Подзапросы.Количество() = 0, "РАЗРЕШЕННЫЕ", "")));
	КонецЕсли;
	Запрос = Новый Запрос(СтрСоединить(Подзапросы, "
		|ОБЪЕДИНИТЬ ВСЕ
		|"));
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти