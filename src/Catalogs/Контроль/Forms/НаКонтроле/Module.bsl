
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	ПоказатьСнятыеСКонтроля = Ложь;
	ПоказатьУдаленные = Ложь;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Список.Параметры.УстановитьЗначениеПараметра("Контролер", ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказатьСнятыеСКонтроля", ПоказатьСнятыеСКонтроля);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказатьУдаленные", ПоказатьУдаленные);
	
	Элементы.КомандаПоказыватьПомеченныеНаУдаление.Пометка = ПоказатьУдаленные;
	Элементы.КомандаПоказатьСнятыеСКонтроля.Пометка = ПоказатьСнятыеСКонтроля;
	
	Если Параметры.ОтображатьТолькоПросроченные Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список,
			"ОтображатьТолькоПросроченные",
			Параметры.ОтображатьТолькоПросроченные,
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список,
			"ТекущаяДата1",
			ТекущаяДатаСеанса,
			Истина);
		
		Элементы.КомандаПоказатьСнятыеСКонтроля.Видимость = Ложь;
		Элементы.КомандаПоказыватьПомеченныеНаУдаление.Видимость = Ложь;
		Элементы.Создать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
		Заголовок = НСтр("ru = 'На контроле (просрочено)'");
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписка;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	МК_НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда 
		ПредыдущаяСтрокаСписка = Неопределено;
		ОбновитьСведенияОКонтроле();
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Не Параметры.ОтображатьТолькоПросроченные Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ПоказатьСнятыеСКонтроля", ПоказатьСнятыеСКонтроля);
		Список.Параметры.УстановитьЗначениеПараметра("ПоказатьУдаленные", ПоказатьУдаленные);
		
		Элементы.КомандаПоказыватьПомеченныеНаУдаление.Пометка = ПоказатьУдаленные;
		Элементы.КомандаПоказатьСнятыеСКонтроля.Пометка = ПоказатьСнятыеСКонтроля;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
#Если Не МобильныйКлиент Тогда
	ПодключитьОбработчикОжидания("ОбновитьСведенияОКонтроле", 0.2, Истина);
#КонецЕсли
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Параметры.ОтображатьТолькоПросроченные Тогда
		Возврат;
	КонецЕсли;
	
	Если Копирование Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
		Открытьформу("Справочник.Контроль.Форма.ФормаНового", ПараметрыФормы, ЭтаФорма);
	Иначе 
		ОткрытьФорму("Справочник.Контроль.Форма.ФормаНового",, ЭтаФорма, Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуКонтроля();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Параметры.ОтображатьТолькоПросроченные Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") 
		И ПараметрыПеретаскивания.Значение.Количество() > 0 Тогда
		Если ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("ДанныеФормыЭлементДерева") Тогда 
			Основание = ПараметрыПеретаскивания.Значение[0].Ссылка;
		Иначе 
			Основание = ПараметрыПеретаскивания.Значение[0];
		КонецЕсли;
		
		Если ПодходящийТипПредмета(Основание) Тогда 
			ПараметрыФормыОткрытия = Новый Структура("Основание", Основание);
			ОткрытьФорму("Справочник.Контроль.Форма.ФормаНового", ПараметрыФормыОткрытия);
		Иначе 
			ПоказатьПредупреждение(, НСтр("ru = 'Объект нельзя поставить на контроль'"));
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Предмет) Тогда 
		ПоказатьЗначение(, Предмет);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ИсполнителиСостояние 
	 Или Поле = Элементы.ИсполнителиСостояниеССостояниемОдин Тогда 
	 
	 	СтандартнаяОбработка = Ложь;
		Строка = Исполнители.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(Строка.Источник) Тогда 
			ПоказатьЗначение(, Строка.Источник);
		КонецЕсли;
		
	ИначеЕсли Поле = Элементы.ИсполнителиИсполнитель
		  Или Поле = Элементы.ИсполнителиИсполнительССостояниемОдин
		  Или Поле = Элементы.ИсполнителиИсполнительБезСостоянияНесколько
		  Или Поле = Элементы.ИсполнителиИсполнительБезСостоянияОдин Тогда 
		
		СтандартнаяОбработка = Ложь;
		Строка = Исполнители.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если ЗначениеЗаполнено(Строка.Исполнитель) Тогда 
			Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.АдресатыПочтовыхСообщений") Тогда 
				СтруктураАдресата = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(Строка.Исполнитель);
				Если ЗначениеЗаполнено(СтруктураАдресата.Контакт) Тогда 
					ПоказатьЗначение(, СтруктураАдресата.Контакт);
				КонецЕсли;
			Иначе 
				ПоказатьЗначение(, Строка.Исполнитель);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;	
	
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
Процедура СнятьСКонтроля(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.СнятСКонтроля Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Запись уже снята с контроля.'"));
		Возврат;
	КонецЕсли;	
	
	СнятьСКонтроляНаСервере(ТекущиеДанные.Ссылка);
	
	КонтрольКлиент.ОповеститьОЗаписиКонтроля(ТекущиеДанные);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Снят с контроля'"),
		ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
		Строка(ТекущиеДанные.Ссылка));
	
	РеквизитыКонтроля = ОбщегоНазначенияДокументооборотВызовСервера.ЗначенияРеквизитовОбъекта(
		ТекущаяСтрокаСписка, "СрокИсполнения");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СнятьСКонтроляПродолжение",
		ЭтотОбъект);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		РеквизитыКонтроля.СрокИсполнения, ТекущаяСтрокаСписка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьСКонтроляПродолжение(Результат, Параметры) Экспорт 
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСрок(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.СнятСКонтроля Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя перенести срок, так как карточка уже снята с контроля.'"));
		Возврат;
	КонецЕсли;
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ПеренестиСрокПродолжение", ЭтотОбъект,
		Новый Структура("ТекущиеДанные", ТекущиеДанные));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СрокИсполнения", ТекущиеДанные.СрокИсполнения);
	ПараметрыФормы.Вставить("Контроль", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Справочник.Контроль.Форма.ПереносСрока", ПараметрыФормы,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуКонтроляКоманда(Команда)
	
	ОткрытьКарточкуКонтроля();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказыватьПомеченныеНаУдаление(Команда)
	
	ПоказатьУдаленные = Не ПоказатьУдаленные;
	Элементы.КомандаПоказыватьПомеченныеНаУдаление.Пометка = ПоказатьУдаленные;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПоказатьУдаленные", ПоказатьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьСнятыеСКонтроля(Команда)
	
	ПоказатьСнятыеСКонтроля = Не ПоказатьСнятыеСКонтроля;
	Элементы.КомандаПоказатьСнятыеСКонтроля.Пометка = ПоказатьСнятыеСКонтроля;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПоказатьСнятыеСКонтроля", ПоказатьСнятыеСКонтроля);
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление(Команда)
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияСписка(ЭтаФорма, "Список");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Учет времени

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	ПараметрыОповещения = Неопределено;
	НуженДиалог = УчетВремениКлиент.НуженДиалогДляХронометража(ВключенХронометраж, 
		ДатаНачалаХронометража, ВидыРабот);
	
	Если НуженДиалог = Ложь Тогда
		
		ПереключитьХронометражСервер(ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, ТекущаяСтрокаСписка);
	
	Иначе
		ДлительностьРаботы = УчетВремениКлиент.ПолучитьДлительностьРаботы(ДатаНачалаХронометража);
		
		ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Работа с контролем ""%1""'"),
			ТекущаяСтрокаСписка);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаОтчета", ТекущаяДата());
		ПараметрыФормы.Вставить("ВидыРабот", ВидыРабот);
		ПараметрыФормы.Вставить("ОписаниеРаботы", ОписаниеРаботы);
		ПараметрыФормы.Вставить("ДлительностьРаботы", ДлительностьРаботы);
		ПараметрыФормы.Вставить("НачалоРаботы", ДатаНачалаХронометража);
		ПараметрыФормы.Вставить("Объект", ТекущаяСтрокаСписка);
		ПараметрыФормы.Вставить("СпособУказанияВремени", СпособУказанияВремени);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПереключитьХронометражПродолжение", ЭтотОбъект,
			Новый Структура("ПараметрыОповещения", ПараметрыОповещения));
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаДобавленияРаботы",
			ПараметрыФормы, , , , , ОписаниеОповещения, РежимОткрытияОкна);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометражПродолжение(ПараметрыОтчета, Параметры) Экспорт 
	
	Если ПараметрыОтчета <> Неопределено Тогда
		ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, Параметры.ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(Параметры.ПараметрыОповещения,
			ВключенХронометраж, ТекущаяСтрокаСписка);
	Иначе
		ОтключитьХронометражСервер();
	КонецЕсли;  

КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		ТекущаяСтрокаСписка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Ложь,
		ЭтаФорма); // Выполнена
		
КонецПроцедуры

&НаКлиенте
Процедура ОтчетНаКонтроле(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("КлючВарианта", "НаКонтроле");
	ПараметрыФормы.Вставить("Контролер", ПользователиКлиентСервер.ТекущийПользователь());
	
	ОткрытьФорму("Отчет.Контроль.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетИстекающиеСроки(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("КлючВарианта", "КонтрольСИстекающимСроком");
	ПараметрыФормы.Вставить("Контролер", ПользователиКлиентСервер.ТекущийПользователь());
	
	ОткрытьФорму("Отчет.Контроль.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетСводкаОКонтроле(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("КлючВарианта", "СводкаОКонтроле");
	ПараметрыФормы.Вставить("Контролер", ПользователиКлиентСервер.ТекущийПользователь());
	
	ОткрытьФорму("Отчет.Контроль.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
	
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.КонтрольСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по контролю'");
	
	РазделГипперссылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("СовместнаяРабота");
	
	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперссылка", 
										Раздел, ЗаголовокФормы, Истина, РазделГипперссылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"КонтрольСписок");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПеренестиСрокПродолжение(Результат, Параметры) Экспорт 
	
	ТекущиеДанные = Параметры.ТекущиеДанные;
	
	Если Результат <> Неопределено 
		И ТипЗнч(Результат) = Тип("Структура") 
		И ТекущиеДанные.СрокИсполнения <> Результат.НовыйСрок Тогда
		ПеренестиСрокНаСервере(ТекущиеДанные.Ссылка, Результат.НовыйСрок);  
		
		КонтрольКлиент.ОповеститьОЗаписиКонтроля(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуКонтроля()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Справочник.Контроль.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбновитьСведенияОКонтроле()
	
	ТекущиеДанные = РаботаСоСпискамиДокументовКлиент.ПолучитьДанныеТекущейСтрокиСписка(
		Элементы.Список, Элементы.Список.ТекущаяСтрока);
	
	Если ТекущиеДанные = Неопределено Тогда 
		Исполнители.Очистить();
		Описание = "";
		ПредыдущаяСтрокаСписка = Неопределено;
		ПредметСтрокой = "";
		Предмет = Неопределено;
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.Ссылка = ПредыдущаяСтрокаСписка Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущаяСтрокаСписка = ТекущиеДанные.Ссылка;
	ДанныеКонтроля = ПолучитьДанныеКонтроля(ТекущиеДанные.Ссылка);
	
	Исполнители.Очистить();
	Для Каждого Строка Из ДанныеКонтроля.МассивИсполнителей Цикл
		НоваяСтрока = Исполнители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	Описание = ДанныеКонтроля.Описание;
	
	Предмет = ДанныеКонтроля.Предмет;
	Если ЗначениеЗаполнено(Предмет) Тогда
		ПредметСтрокой = ДанныеКонтроля.ПредметСтрокой;
		Элементы.ПредметСтрокой.Гиперссылка = Истина;
	Иначе
		ПредметСтрокой = НСтр("ru = 'Нет'");
		Элементы.ПредметСтрокой.Гиперссылка = Ложь;
	КонецЕсли;
	
	Если ДанныеКонтроля.ВыводитьСостояние Тогда 
		Если Исполнители.Количество() > 1 Тогда 
			Элементы.ГруппаИсполнителиСтраницы.ТекущаяСтраница = Элементы.ГруппаИсполнителиССостояниемНесколько;
		Иначе
			Элементы.ГруппаИсполнителиСтраницы.ТекущаяСтраница = Элементы.ГруппаИсполнителиССостояниемОдин;
		КонецЕсли;	
	Иначе
		Если Исполнители.Количество() > 1 Тогда 
			Элементы.ГруппаИсполнителиСтраницы.ТекущаяСтраница = Элементы.ГруппаИсполнителиБезСостоянияНесколько;
		Иначе
			Элементы.ГруппаИсполнителиСтраницы.ТекущаяСтраница = Элементы.ГруппаИсполнителиБезСостоянияОдин;
		КонецЕсли;	
	КонецЕсли;	
	
	// Установить значения реквизитов
	Если ТипЗнч(ДанныеКонтроля.ДополнительныеРеквизиты) = Тип("Структура") Тогда
		Для каждого Реквизит Из ДанныеКонтроля.ДополнительныеРеквизиты Цикл
			ЭтаФорма[Реквизит.Ключ] = Реквизит.Значение;
		КонецЦикла;
	КонецЕсли;
	
	// Установить свойства элементов
	Если ТипЗнч(ДанныеКонтроля.СвойстваЭлементов) = Тип("Структура") Тогда
		Для каждого Элемент Из ДанныеКонтроля.СвойстваЭлементов Цикл
			НайденныйЭлемент = Элементы[Элемент.Ключ];
			Для каждого СвойствоЭлементаИЗначение Из Элемент.Значение Цикл
				ИмяСвойства = СвойствоЭлементаИЗначение.Ключ;
				ЗначениеСвойства = СвойствоЭлементаИЗначение.Значение;
							
				НайденныйЭлемент[ИмяСвойства] = ЗначениеСвойства;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	ПредыдущаяСтрокаСписка = ТекущиеДанные.Ссылка;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьДанныеКонтроля(КарточкаКонтроля)
	
	МассивИсполнителей = Новый Массив;
	
	Для Каждого Строка Из КарточкаКонтроля.Исполнители Цикл
		СтруктураИсполнителя = Новый Структура("Исполнитель, Состояние, Ответственный, Источник, Проконтролировано");
		СтруктураИсполнителя.Исполнитель = Строка.Исполнитель;
		СтруктураИсполнителя.Ответственный = Строка.Ответственный;
		СтруктураИсполнителя.Источник = Строка.Источник;
		СтруктураИсполнителя.Проконтролировано = Строка.Проконтролировано;
		
		Состояние = "";
		Если ЗначениеЗаполнено(КарточкаКонтроля.Предмет) Тогда 
			Если ТипЗнч(КарточкаКонтроля.Предмет) = Тип("СправочникСсылка.ВеткиПереписки") Тогда 
				Если ТипЗнч(Строка.Источник) = Тип("ДокументСсылка.ВходящееПисьмо") Тогда 
					Состояние = НСтр("ru = 'Ответ получен'");
				ИначеЕсли ТипЗнч(Строка.Источник) = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда 
					Состояние = НСтр("ru = 'Ответ не получен'");
				КонецЕсли;	
			ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(КарточкаКонтроля.Предмет.Метаданные())
				Или ТипЗнч(КарточкаКонтроля.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
				Если Строка.Исполнено Тогда 
					Состояние = НСтр("ru = 'Исполнено'");
				КонецЕсли;	
		    КонецЕсли;
		КонецЕсли;
		СтруктураИсполнителя.Состояние = Состояние;
		
		МассивИсполнителей.Добавить(СтруктураИсполнителя);
	КонецЦикла;
	
	Результат = новый Структура;
	Результат.Вставить("МассивИсполнителей", МассивИсполнителей);
	Результат.Вставить("Описание", КарточкаКонтроля.Описание);
	
	Если ТипЗнч(КарточкаКонтроля.Предмет) = Тип("СправочникСсылка.ВеткиПереписки") Тогда 
		Результат.Вставить("Предмет", КарточкаКонтроля.Предмет.КорневоеПисьмо);
	Иначе
		Результат.Вставить("Предмет", КарточкаКонтроля.Предмет);	
	КонецЕсли;	
	Результат.Вставить("ПредметСтрокой", Контроль.СформироватьПредставлениеПредмета(Результат.Предмет));
	
	ВыводитьСостояние = Ложь;
	Если ЗначениеЗаполнено(КарточкаКонтроля.Предмет) Тогда 
		Если ТипЗнч(КарточкаКонтроля.Предмет) = Тип("СправочникСсылка.ВеткиПереписки")
		 Или ОбщегоНазначения.ЭтоБизнесПроцесс(КарточкаКонтроля.Предмет.Метаданные()) 
		 Или ТипЗнч(КарточкаКонтроля.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
			ВыводитьСостояние = Истина; 
		КонецЕсли; 
	КонецЕсли;
	Результат.Вставить("ВыводитьСостояние", ВыводитьСостояние);
	
	// Хронометраж
	ДополнительныеРеквизиты = Новый Структура;
	СвойстваЭлементов = Новый Структура;
	
	ДатаНачалаХронометража = Неопределено;
	ДатаКонцаХронометража = Неопределено;
	ВключенХронометраж = Неопределено;
	ОпцияИспользоватьУчетВремени = Неопределено;
	ВидыРабот = Неопределено;
	СпособУказанияВремени = Неопределено;
	
	ПереключитьХронометражНеМеняяПодсказку = Новый Структура("Имя, Подсказка");
	
	ПереключитьХронометраж = Новый Структура("Доступность, Пометка");
	ПереключитьХронометраж.Доступность = Истина;
	
	УказатьТрудозатраты = Новый Структура("Доступность");
	УказатьТрудозатраты.Доступность = Истина;
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		КарточкаКонтроля,
		ВидыРабот,
		СпособУказанияВремени,
		ПереключитьХронометражНеМеняяПодсказку,
		ПереключитьХронометраж,
		УказатьТрудозатраты);
		
	СвойстваЭлементов.Вставить("ПереключитьХронометраж", Новый Соответствие);
	СвойстваЭлементов.Вставить("УказатьТрудозатраты", Новый Соответствие);
	
	СвойстваЭлементов.ПереключитьХронометраж.Вставить(
		"Доступность",
		ПереключитьХронометраж.Доступность);
	СвойстваЭлементов.ПереключитьХронометраж.Вставить(
		"Пометка",
		ПереключитьХронометраж.Пометка);
	СвойстваЭлементов.УказатьТрудозатраты.Вставить(
		"Доступность",
		УказатьТрудозатраты.Доступность);
	
	ДополнительныеРеквизиты.Вставить("ДатаНачалаХронометража", ДатаНачалаХронометража);
	ДополнительныеРеквизиты.Вставить("ДатаКонцаХронометража", ДатаКонцаХронометража);
	ДополнительныеРеквизиты.Вставить("ВключенХронометраж", ВключенХронометраж);
	ДополнительныеРеквизиты.Вставить("ОпцияИспользоватьУчетВремени", ОпцияИспользоватьУчетВремени);
	ДополнительныеРеквизиты.Вставить("ВидыРабот", ВидыРабот);
	ДополнительныеРеквизиты.Вставить("СпособУказанияВремени", СпособУказанияВремени);
	
	Результат.Вставить("ДополнительныеРеквизиты", ДополнительныеРеквизиты);
	Результат.Вставить("СвойстваЭлементов", СвойстваЭлементов);
	
	Возврат Результат;
	
КонецФункции
	
&НаСервереБезКонтекста
Процедура ПеренестиСрокНаСервере(КарточкаКонтроля, НовыйСрок)
	
	КарточкаКонтроляОбъект = КарточкаКонтроля.ПолучитьОбъект();
	КарточкаКонтроляОбъект.СрокИсполнения = НовыйСрок;
	КарточкаКонтроляОбъект.Записать();
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура СнятьСКонтроляНаСервере(КарточкаКонтроля)
	
	КарточкаКонтроляОбъект = КарточкаКонтроля.ПолучитьОбъект();
	КарточкаКонтроляОбъект.СнятСКонтроля = Истина;
	КарточкаКонтроляОбъект.ДатаСнятияСКонтроля = ТекущаяДата();
	
	Для Каждого Строка Из КарточкаКонтроляОбъект.Исполнители Цикл
		Если Не Строка.Проконтролировано Тогда 
			Строка.Проконтролировано = Истина;
			Строка.ДатаКонтроля = ТекущаяДата();
		КонецЕсли;	
	КонецЦикла;
	
	КарточкаКонтроляОбъект.Записать();
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПодходящийТипПредмета(ОбъектПеретаскивания)
	
	МассивТиповДанных = Метаданные.Справочники.Контроль.Реквизиты.Предмет.Тип.Типы();
	
	Если МассивТиповДанных.Найти(ТипЗнч(ОбъектПеретаскивания)) = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции	

&НаСервере
Процедура ОтключитьХронометражСервер()
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущаяСтрокаСписка,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения)
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущаяСтрокаСписка,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения)
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
		ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовим меню списка.
	Элементы.Создать.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
	Элементы.Создать.Отображение = ОтображениеКнопки.Картинка;
	
	Элементы.Изменить.Видимость = Ложь;
	Элементы.УстановитьПометкуУдаления.Видимость = Ложь;
	Элементы.Обновить.Видимость = Ложь;
	Элементы.ГруппаОтчеты.Видимость = Ложь;
	Элементы.СохранитьНастройкиДинамическогоСписка.Видимость = Ложь;
	Элементы.ЗагрузитьНастройкиДинамическогоСписка.Видимость = Ложь;
	Элементы.ВывестиСписок.Видимость = Ложь;
	Элементы.ОткрытьОтчеты.Видимость = Ложь;
	
	// Подготовим контекстное меню списка.
	//  Написать письмо
	Элементы.Переместить(Элементы.СоздатьПисьмоНаОсновании,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	Элементы.СоздатьПисьмоНаОсновании.Заголовок = НСтр("ru='Написать письмо'");
	//  Записать в календарь
	Элементы.Переместить(Элементы.СправочникЗаписиРабочегоКалендаряСоздатьЗаписьКалендаряНаОсновании,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	Элементы.СправочникЗаписиРабочегоКалендаряСоздатьЗаписьКалендаряНаОсновании.Заголовок =
		НСтр("ru='Записать в календарь'");
	//  Снять с контроля
	Элементы.Переместить(Элементы.СнятьСКонтроля,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	//  Указать трудозатраты
	Элементы.Переместить(Элементы.УказатьТрудозатраты,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	//  Перенести срок
	Элементы.Переместить(Элементы.ПеренестиСрок,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	//  Пометить на удаление
	Элементы.Переместить(Элементы.СписокКонтекстноеМенюУстановитьПометкуУдаления,
		Элементы.Список.КонтекстноеМеню, Элементы.СписокКонтекстноеМенюСкопировать);
	//  Скопировать
	Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Истина;
	// Остальные команды отключим.
	Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюИзменить.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюНайти.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюОтменитьПоиск.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюКопироватьВБуферОбмена.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюОбновить.Видимость = Ложь;
	Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Ложь;
	Элементы.ГруппаСоздатьНаОсновании.Видимость = Ложь;
	// Отключим общие команды "Создать на основании"
	СписокКонтекстноеМенюСоздатьНаОсновании = Элементы.Найти("СписокКонтекстноеМенюСоздатьНаОсновании");
	Если СписокКонтекстноеМенюСоздатьНаОсновании <> Неопределено Тогда
		СписокКонтекстноеМенюСоздатьНаОсновании.Видимость = Ложь;
	КонецЕсли;
	
	// Настройка списка.
	Элементы.Список.АвтоОбновление = Ложь;
	Элементы.Ссылка.Видимость = Ложь;
	Элементы.Список.Шапка = Ложь;
	
	// Сделаем 2 строки:
	//  Что  | Срок
	//  Кого | Дата создания
	Элементы.Переместить(Элементы.СписокИсполнителиСтрокой, Элементы.ГруппаСтрока, Элементы.Ссылка);
	Элементы.СписокИсполнителиСтрокой.Ширина = 30;
	
	ГруппаСтрокаДаты = Элементы.Добавить("МКГруппаСтрокаДаты", Тип("ГруппаФормы"), Элементы.Список);
	Элементы.Переместить(Элементы.СписокСрокИсполнения, ГруппаСтрокаДаты);
	Элементы.Переместить(Элементы.СписокОсталосьДней, ГруппаСтрокаДаты);
	Элементы.Переместить(Элементы.СписокДатаПостановки, ГруппаСтрокаДаты);
	Элементы.СписокОсталосьДней.ОтображатьВШапке = Ложь;
	Элементы.СписокСрокИсполнения.Ширина = 6;
	Элементы.СписокОсталосьДней.Ширина = 6;
	Элементы.СписокДатаПостановки.Ширина = 6;
	
	Элементы.СписокНаименование.Ширина = 15;
	Элементы.СписокИсполнителиСтрокой.Ширина = 15;
	
	// Изменим отображение второй строки
	Элементы.СписокИсполнителиСтрокой.Шрифт = Новый Шрифт(ШрифтыСтиля.МелкийШрифтТекста);
	Элементы.СписокИсполнителиСтрокой.ЦветТекста = WebЦвета.Серый;
	Элементы.СписокДатаПостановки.Шрифт = Новый Шрифт(ШрифтыСтиля.МелкийШрифтТекста);
	Элементы.СписокДатаПостановки.ЦветТекста = WebЦвета.Серый;
	
	// Отключим правую колонку.
	Элементы.ПраваяКолонка.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
