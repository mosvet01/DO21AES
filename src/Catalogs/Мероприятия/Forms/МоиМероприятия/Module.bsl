#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Параметры списка
	Список.Параметры.УстановитьЗначениеПараметра("Участник", ПользователиКлиентСервер.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
	// Задачи
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда 
		Элементы.Задачи.Видимость = Ложь;
	КонецЕсли;
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	// Категории
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		Элементы.ЕстьКатегорииДанных.Видимость = Ложь;
	КонецЕсли;
	
	// Автообновление
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Ложь;
	Иначе
		Автообновление.ЗагрузитьНастройкиАвтообновленияСписка(ЭтаФорма, "Список");
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Истина;
	КонецЕсли;
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
	// Раздельное исполнение пунктов протокола.
	РаздельноеИсполнениеПунктовПротокола =
		ПолучитьФункциональнуюОпцию("ИспользоватьРаздельноеИсполнениеПунктовПротоколаМероприятия");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечать;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Учет трудозатрат
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Неопределено,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
		
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	МК_НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("СправочникСсылка.Мероприятия") Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.Файлы Тогда
		ПараметрыОткрытия = Новый Структура("Ключ, ОткрытьЗакладкуФайлы", ВыбраннаяСтрока, Истина);
		ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.Задачи Тогда
		ОткрытьФорму("ОбщаяФорма.ПроцессыИЗадачи",
			Новый Структура("Предмет", ВыбраннаяСтрока),
			ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ЕстьКатегорииДанных Тогда
		ПараметрыОткрытия = Новый Структура("Ключ, ОткрытьЗакладкуКатегории", ВыбраннаяСтрока, Истина);
		ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СостояниеКонтроля Тогда
		КонтрольКлиент.ОбработкаКомандыКонтроль(ВыбраннаяСтрока, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", ВыбраннаяСтрока);
	ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		Или ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ТекущееМероприятие = Неопределено;
		УстановитьДоступностьКомандОтправить(Ложь);
		ОбновитьПараметрыУчетаВремениВФорме();
		Возврат;
	КонецЕсли;
	
	ТекущееМероприятие = ТекущиеДанные.Ссылка;
	УстановитьДоступностьКомандОтправить(ТекущиеДанные.ПротокольноеМероприятие);
	ОбновитьПараметрыУчетаВремениВФорме();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого КлючИЗначение Из Строки Цикл
		
		ДанныеСтроки = КлючИЗначение.Значение.Данные;
		
		// Период строкой
		Если ДанныеСтроки.Свойство("ПериодСтрокой") Тогда
			ДанныеСтроки.ПериодСтрокой = УправлениеМероприятиями.МестныйПериодСтрокой(
				ДанныеСтроки.ДатаНачала,
				ДанныеСтроки.ДатаОкончания);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления(Элемент)
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Автообновление(Команда)
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияСписка(ЭтаФорма, "Список");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьМатериалы(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеЗапросаМатериалов = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыВыступающихЗапрошены"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеЗапросаМатериалов", УстановилСостояниеЗапросаМатериалов);
	
	Оповещение = Новый ОписаниеОповещения("ЗапроситьМатериалы_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеЗапросаМатериалов)
		И ТипЗнч(УстановилСостояниеЗапросаМатериалов) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Материалы уже запрошены.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть запрос'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новый'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьМатериалы_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеЗапросаМатериалов);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Основание = Новый Структура;
	Основание.Вставить("ОперацияМероприятия", "ЗапроситьМатериалы");
	Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ОткрытьФорму("БизнесПроцесс.Исполнение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнитьПротокол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеИсполненияПротокола = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаИсполнении"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеИсполненияПротокола", УстановилСостояниеИсполненияПротокола);
	
	Оповещение = Новый ОписаниеОповещения("ИсполнитьПротокол_Завершение", ЭтотОбъект, ДопПараметры);
	Если ЗначениеЗаполнено(УстановилСостояниеИсполненияПротокола)
		И ТипЗнч(УстановилСостояниеИсполненияПротокола) <> Тип("СправочникСсылка.Пользователи") Тогда
		ТекстВопроса = НСтр("ru = 'Протокол уже отправлен на исполнение.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть исполнение'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнитьПротокол_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеИсполненияПротокола);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	ПараметрыНаИсполнение = УправлениеМероприятиямиКлиент.ПараметрыДляНаправленияПротоколаНаИсполнение();
	ПараметрыНаИсполнение.Мероприятие = ТекущиеДанные.Ссылка;
	ПараметрыНаИсполнение.ТипПротокола = ТекущиеДанные.ТипПротокола;
	ПараметрыНаИсполнение.МатериалПротокол = ТекущиеДанные.МатериалПротокол;
	ПараметрыНаИсполнение.РаздельноеИсполнение = РаздельноеИсполнениеПунктовПротокола;
	ПараметрыНаИсполнение.Владелец = ЭтотОбъект;
	
	УправлениеМероприятиямиКлиент.НаправитьПротоколМероприятияНаИсполнение(ПараметрыНаИсполнение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОзнакомитьСМатериалами(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеОзнакомленияСМатериалами = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыОтправленыНаОзнакомление"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеОзнакомленияСМатериалами", УстановилСостояниеОзнакомленияСМатериалами);
	
	Оповещение = Новый ОписаниеОповещения("ОзнакомитьСМатериалами_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеОзнакомленияСМатериалами)
		И ТипЗнч(УстановилСостояниеОзнакомленияСМатериалами) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Материалы уже отправлены на ознакомление.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть ознакомление'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОзнакомитьСМатериалами_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеОзнакомленияСМатериалами);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Основание = Новый Структура;
	Основание.Вставить("ОперацияМероприятия", "ОзнакомитьСМатериалами");
	Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ОткрытьФорму("БизнесПроцесс.Ознакомление.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПротокол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеПодготовкиПротокола = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколГотовиться"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеПодготовкиПротокола", УстановилСостояниеПодготовкиПротокола);
	
	Оповещение = Новый ОписаниеОповещения("ПодготовитьПротокол_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеПодготовкиПротокола)
		И ТипЗнч(УстановилСостояниеПодготовкиПротокола) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Подготовка протокола уже инициирована.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть процесс подготовки'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новый'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПротокол_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеПодготовкиПротокола);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Основание = Новый Структура;
	Основание.Вставить("ОперацияМероприятия", "ПодготовитьПротокол");
	Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ОткрытьФорму("БизнесПроцесс.Исполнение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегории(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьКатегорииПродолжение",
		ЭтотОбъект);
		
	РаботаСКатегориямиДанныхКлиент.ОткрытьФормуПодбораКатегорийДляСпискаОбъектов(
		Элементы.Список, Истина, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегорииПродолжение(Результат, Параметры) Экспорт 

	Если Результат <> Неопределено Тогда
		ОповеститьОбИзменении(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПригласитьУчастников(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	УстановилСостояниеПриглашенияУчастников = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияОтправлены"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеПриглашенияУчастников", УстановилСостояниеПриглашенияУчастников);
	
	Оповещение = Новый ОписаниеОповещения("ПригласитьУчастников_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеПриглашенияУчастников)
		И ТипЗнч(УстановилСостояниеПриглашенияУчастников) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Приглашение уже отправлено.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть приглашение'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПригласитьУчастников_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеПриглашенияУчастников);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипПрограммы = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВОтдельномДокументе")
		И ЗначениеЗаполнено(ТекущиеДанные.МатериалПрограмма) Тогда 
		ПараметрыФормы = Новый Структура("Основание", ТекущиеДанные.МатериалПрограмма);
		ОткрытьФорму("БизнесПроцесс.Приглашение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы = Новый Структура("Основание", ТекущиеДанные.Ссылка);
		ОткрытьФорму("БизнесПроцесс.Приглашение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиМероприятие(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеПроведенияМероприятия = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеВСтадииПодготовки"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеПроведенияМероприятия", УстановилСостояниеПроведенияМероприятия);
	
	Оповещение = Новый ОписаниеОповещения("ПровестиМероприятие_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеПроведенияМероприятия)
		И ТипЗнч(УстановилСостояниеПроведенияМероприятия) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Проведение мероприятия уже инициировано.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть процесс'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новый'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиМероприятие_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеПроведенияМероприятия);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Основание = Новый Структура;
	Основание.Вставить("ОперацияМероприятия", "ПровестиМероприятие");
	Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
	ПараметрыФормы = Новый Структура("Основание", Основание);
	ОткрытьФорму("БизнесПроцесс.Исполнение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьПротокол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеСогласованияПротокола = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
		ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаСогласовании"));
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеСогласованияПротокола", УстановилСостояниеСогласованияПротокола);
	
	Оповещение = Новый ОписаниеОповещения("СогласоватьПротокол_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеСогласованияПротокола)
		И ТипЗнч(УстановилСостояниеСогласованияПротокола) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Протокол уже отправлен на согласование.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть согласование'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьПротокол_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеСогласованияПротокола);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипПротокола = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВОтдельномДокументе")
		И ЗначениеЗаполнено(ТекущиеДанные.МатериалПротокол) Тогда 
		ПараметрыФормы = Новый Структура("Основание", ТекущиеДанные.МатериалПротокол);
		ОткрытьФорму("БизнесПроцесс.Согласование.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе	
		Основание = Новый Структура;
		Основание.Вставить("ОперацияМероприятия", "СогласоватьПротокол");
		Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Новый Структура("Основание", Основание);
		ОткрытьФорму("БизнесПроцесс.Согласование.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьПрограмму(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеУтвержденияПрограммы = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
			ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаНаУтверждении"));
			
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеУтвержденияПрограммы", УстановилСостояниеУтвержденияПрограммы);
	
	Оповещение = Новый ОписаниеОповещения("УтвердитьПрограмму_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеУтвержденияПрограммы)
		И ТипЗнч(УстановилСостояниеУтвержденияПрограммы) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Программа уже находиться на утверждении.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть утверждение'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьПрограмму_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеУтвержденияПрограммы);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипПрограммы = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВОтдельномДокументе")
		И ЗначениеЗаполнено(ТекущиеДанные.МатериалПрограмма) Тогда 
		ПараметрыФормы = Новый Структура("Основание", ТекущиеДанные.МатериалПрограмма);
		ОткрытьФорму("БизнесПроцесс.Утверждение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе	
		Основание = Новый Структура;
		Основание.Вставить("ОперацияМероприятия", "УтвердитьПрограмму");
		Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Новый Структура("Основание", Основание);
		ОткрытьФорму("БизнесПроцесс.Утверждение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьПротокол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановилСостояниеУтвержденияПротокола = УправлениеМероприятиямиВызовСервера.ПолучитьУстановилСостояниеМероприятия(
			ТекущиеДанные.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаУтверждении"));
			
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДопПараметры.Вставить("УстановилСостояниеУтвержденияПротокола", УстановилСостояниеУтвержденияПротокола);
	
	Оповещение = Новый ОписаниеОповещения("УтвердитьПротокол_Завершение",
		ЭтотОбъект, ДопПараметры);
	
	Если ЗначениеЗаполнено(УстановилСостояниеУтвержденияПротокола)
		И ТипЗнч(УстановилСостояниеУтвержденияПротокола) <> Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекстВопроса = НСтр("ru = 'Протокол уже отправлен на утверждение.'");
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(Истина, НСтр("ru = 'Открыть утверждение'"));
		КнопкиВопроса.Добавить(Ложь, НСтр("ru = 'Создать новое'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса,, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура УтвердитьПротокол_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьЗначение(, ДопПараметры.УстановилСостояниеУтвержденияПротокола);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДопПараметры.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипПротокола = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВОтдельномДокументе")
		И ЗначениеЗаполнено(ТекущиеДанные.МатериалПротокол) Тогда 
		ПараметрыФормы = Новый Структура("Основание", ТекущиеДанные.МатериалПротокол);
		ОткрытьФорму("БизнесПроцесс.Утверждение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе
		Основание = Новый Структура;
		Основание.Вставить("ОперацияМероприятия", "УтвердитьПротокол");
		Основание.Вставить("Мероприятие", ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Новый Структура("Основание", Основание);
		ОткрытьФорму("БизнесПроцесс.Утверждение.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	ПараметрыОповещения = Неопределено;
	НуженДиалог = УчетВремениКлиент.НуженДиалогДляХронометража(ВключенХронометраж, 
		ДатаНачалаХронометража, ВидыРабот);
	
	Если НуженДиалог = Ложь Тогда
		
		ПереключитьХронометражСервер(ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, ТекущиеДанные.Ссылка);
		
	Иначе
		ДлительностьРаботы = УчетВремениКлиент.ПолучитьДлительностьРаботы(ДатаНачалаХронометража);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаОтчета", ТекущаяДата());
		ПараметрыФормы.Вставить("ВидыРабот", ВидыРабот);
		ПараметрыФормы.Вставить("ОписаниеРаботы", Строка(ТекущиеДанные.Ссылка));
		ПараметрыФормы.Вставить("ДлительностьРаботы", ДлительностьРаботы);
		ПараметрыФормы.Вставить("НачалоРаботы", ДатаНачалаХронометража);
		ПараметрыФормы.Вставить("Объект", ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("СпособУказанияВремени", СпособУказанияВремени);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПереключитьХронометражПродолжение",
			ЭтотОбъект,
			Новый Структура("Объект", ТекущиеДанные.Ссылка));
		
		ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаДобавленияРаботы", ПараметрыФормы,,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Трудозатраты(Команда)
	
	ПараметрыФормы = Новый Структура("Источник", ТекущееМероприятие);
	ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаСпискаИсточника", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДатаОтчета = ТекущаяДата();
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		ТекущиеДанные.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Ложь,
		ЭтаФорма); // Выполнена
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьОтображатьУдаленные()
	
	Элементы.ФормаОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандОтправить(ПротокольноеМероприятие)
	
	ВыбраноМероприятие = ЗначениеЗаполнено(ТекущееМероприятие);
	
	Если Элементы.Найти("ФормаОбщаяКомандаСоздатьПисьмоНаОсновании") <> Неопределено Тогда
		Элементы.ФормаОбщаяКомандаСоздатьПисьмоНаОсновании.Доступность = ВыбраноМероприятие;
	КонецЕсли;
	Элементы.ОтправитьОбъекты.Доступность = ВыбраноМероприятие;
	
	Элементы.ФормаУтвердитьПрограмму.Доступность = ВыбраноМероприятие;
	Элементы.ФормаПригласитьУчастников.Доступность = ВыбраноМероприятие;
	Элементы.ФормаЗапроситьМатериалы.Доступность = ВыбраноМероприятие;
	Элементы.ФормаОзнакомитьСМатериалами.Доступность = ВыбраноМероприятие;
	Элементы.ФормаПровестиМероприятие.Доступность = ВыбраноМероприятие;
	
	Элементы.ФормаПодготовитьПротокол.Доступность = ПротокольноеМероприятие;
	Элементы.ФормаСогласоватьПротокол.Доступность = ПротокольноеМероприятие;
	Элементы.ФормаУтвердитьПротокол.Доступность = ПротокольноеМероприятие;
	Элементы.ФормаИсполнитьПротокол.Доступность = ПротокольноеМероприятие;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
		ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыУчетаВремениВФорме()
	
	Если Не ЗначениеЗаполнено(ТекущееМероприятие) Тогда 
		Элементы.ПереключитьХронометраж.Доступность = Ложь;
		Элементы.УказатьТрудозатраты.Доступность = Ложь;
		Элементы.Трудозатраты.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыУчетаВремени = ПолучитьПараметрыУчетаВремени(ТекущееМероприятие);
	
	ДатаНачалаХронометража = ПараметрыУчетаВремени.ДатаНачалаХронометража;
	ДатаКонцаХронометража = ПараметрыУчетаВремени.ДатаКонцаХронометража;
	ВключенХронометраж = ПараметрыУчетаВремени.ВключенХронометраж;
	ОпцияИспользоватьУчетВремени = ПараметрыУчетаВремени.ОпцияИспользоватьУчетВремени;
	ВидыРабот = ПараметрыУчетаВремени.ВидыРабот;
	СпособУказанияВремени = ПараметрыУчетаВремени.СпособУказанияВремени;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.ПереключитьХронометраж Цикл
		Элементы.ПереключитьХронометраж[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.УказатьТрудозатраты Цикл
		Элементы.УказатьТрудозатраты[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
	Элементы.Трудозатраты.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	Если Не ЗначениеЗаполнено(ТекущееМероприятие) Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущееМероприятие,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометражПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ДобавитьВОтчетИОбновитьФорму(Результат, ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, Параметры.Объект);
	Иначе
		ОтключитьХронометражСервер();
	КонецЕсли;  

КонецПроцедуры

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	Если Не ЗначениеЗаполнено(ТекущееМероприятие) Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущееМероприятие,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыУчетаВремени(Мероприятие)
	
	Результат = Новый Структура;
	
	ДатаНачалаХронометража = Неопределено;
	ДатаКонцаХронометража = Неопределено;
	ВключенХронометраж = Неопределено;
	ОпцияИспользоватьУчетВремени = Неопределено;
	ВидыРабот = Неопределено;
	СпособУказанияВремени = Неопределено;
	
	ПереключитьХронометражНеМеняяПодсказку = Новый Структура("Имя, Подсказка");
	
	ПереключитьХронометраж = Новый Структура("Доступность, Пометка, Видимость");
	ПереключитьХронометраж.Доступность = Истина;
	
	УказатьТрудозатраты = Новый Структура("Доступность");
	УказатьТрудозатраты.Доступность = Истина;
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Мероприятие,
		ВидыРабот,
		СпособУказанияВремени,
		ПереключитьХронометражНеМеняяПодсказку,
		ПереключитьХронометраж,
		УказатьТрудозатраты);
		
	Результат.Вставить("ПереключитьХронометраж", Новый Соответствие);
	Результат.Вставить("УказатьТрудозатраты", Новый Соответствие);
	
	Результат.ПереключитьХронометраж.Вставить(
		"Доступность",
		ПереключитьХронометраж.Доступность);
	Результат.ПереключитьХронометраж.Вставить(
		"Пометка",
		ПереключитьХронометраж.Пометка);
	Результат.УказатьТрудозатраты.Вставить(
		"Доступность",
		УказатьТрудозатраты.Доступность);
	
	Результат.Вставить("ДатаНачалаХронометража", ДатаНачалаХронометража);
	Результат.Вставить("ДатаКонцаХронометража", ДатаКонцаХронометража);
	Результат.Вставить("ВключенХронометраж", ВключенХронометраж);
	Результат.Вставить("ОпцияИспользоватьУчетВремени", ОпцияИспользоватьУчетВремени);
	Результат.Вставить("ВидыРабот", ВидыРабот);
	Результат.Вставить("СпособУказанияВремени", СпособУказанияВремени);
	
	Возврат Результат;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	Элементы.ФормаОбновить.Видимость = Ложь;
	Элементы.ГруппаПечать.Видимость = Ложь;
	
	// Список.
	Элементы.МК_ГруппаКолонок.Видимость = Истина;
	Элементы.Переместить(Элементы.СписокНаименование, Элементы.ГруппаНаименование);
	Элементы.Переместить(Элементы.ГруппаПериодСтрокой, Элементы.ГруппаВремя);
	
	Элементы.СписокНаименование.Высота = 3;
	Элементы.ПериодСтрокой.Шрифт = ШрифтыСтиля.МелкийШрифтТекста;
	
	Элементы.Список.Шапка = Ложь;
	Элементы.Код.Видимость = Ложь;
	Элементы.Участники.Видимость = Ложь;
	Элементы.ВидМероприятия.Видимость = Ложь;
	Элементы.МестоПроведения.Видимость = Ложь;
	Элементы.СостояниеМероприятия.Видимость = Ложь;
	Элементы.Председатель.Видимость = Ложь;
	Элементы.Секретарь.Видимость = Ложь;
	Элементы.Проект.Видимость = Ложь;
	Элементы.Комментарий.Видимость = Ложь;
	Элементы.ДатаНачала.Видимость = Ложь;
	Элементы.ДатаОкончания.Видимость = Ложь;
	Элементы.ГруппаЗадачиФайлы.Видимость = Ложь;
	Элементы.ГруппаВажностьКонтроль.Видимость = Ложь;
	Элементы.СостояниеКонтроля.Видимость = Ложь;
	Элементы.Ссылка.Видимость = Ложь;
	
	Элементы.Переместить(Элементы.УказатьТрудозатраты, Элементы.Список.КонтекстноеМеню);
	Элементы.Переместить(Элементы.ПереключитьХронометраж, Элементы.Список.КонтекстноеМеню);
	Элементы.Переместить(Элементы.Трудозатраты, Элементы.Список.КонтекстноеМеню);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
