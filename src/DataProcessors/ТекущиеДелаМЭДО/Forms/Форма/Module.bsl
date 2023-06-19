
#Область ОбработчикиСобытийФормы

	&НаКлиенте
	Процедура ПриОткрытии(Отказ)
		
		Элементы.ГруппаКомандыВходящиеДокументы.ТекущаяСтраница = Элементы.СтраницаПолучитьВходящиеДокументы;
		Элементы.ГруппаКомандыВходящиеУведомления.ТекущаяСтраница = Элементы.СтраницаПолучитьВходящиеУведомления;
		
		ОбновитьКаталогиОбмена();
		
		ОбновитьНаСервере();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
		Если ИмяСобытия = "ЗаписьНастроекМЭДО" И Параметр = Объект.Организация Тогда
			ОбновитьКаталогиОбмена();
		КонецЕсли;
		
	КонецПроцедуры
	
	&НаСервере
	Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
		СписокОрганизаций = ОрганизацииНастроенныеДляМЭДО();
		Если СписокОрганизаций.Количество() > 0
			И СписокОрганизаций.НайтиПоЗначению(Объект.Организация) = Неопределено Тогда
			Объект.Организация = СписокОрганизаций[0].Значение;
		КонецЕсли;
		
		ЭтоПолноправныйПользователь = ИнтеграцияСМЭДО.ЕстьПолныеПрава();
		Элементы.РасширенныйВид.Пометка = ЭтоПолноправныйПользователь;
		УправлениеВидимостью();
		
	КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

	&НаКлиенте
	Процедура ОрганизацияПриИзменении(Элемент)
		
		ОчиститьСообщения();
		
		ОбновитьКаталогиОбмена();
		ОбновитьНаСервере();
		
	КонецПроцедуры

	&НаКлиенте
	Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СписокОрганизаций;
		
	КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВходящиеДокументы

	&НаКлиенте
	Процедура ВходящиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
		ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецПроцедуры

	&НаКлиенте
	Процедура ВходящиеДокументыПриАктивизацииСтроки(Элемент)
		
		Если Элементы.ВходящиеДокументы.ТекущиеДанные = Неопределено Тогда
			Элементы.ГруппаКомандыВходящиеДокументы.ТекущаяСтраница = Элементы.СтраницаПолучитьВходящиеДокументы;
		Иначе
			Элементы.ГруппаКомандыВходящиеДокументы.ТекущаяСтраница = Элементы.СтраницаПолучитьИОтказатьВРегистрацииВходящиеДокументы;
		КонецЕсли;
		
	КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсходящиеУведомления

	&НаКлиенте
	Процедура ИсходящиеУведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
		УведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВходящиеУведомления

	&НаКлиенте
	Процедура ВходящиеУведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
		УведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецПроцедуры

	&НаКлиенте
	Процедура ВходящиеУведомленияПриАктивизацииСтроки(Элемент)
		
		ВыбраныТолькоОтказы = Истина;
		Для Каждого Индекс Из Элемент.ВыделенныеСтроки Цикл
			ВыделеннаяСтрока = ВходящиеУведомления.НайтиПоИдентификатору(Индекс);
			Если Не (ВыделеннаяСтрока.Состояние
				= ПредопределенноеЗначение("Перечисление.СостоянияДокументовМЭДО.ПолученоУведомление")
				И ВыделеннаяСтрока.ТипУведомления 
				= ПредопределенноеЗначение("Перечисление.ТипыУведомленийМЭДО.ОбОтказеВРегистрации")) Тогда
				ВыбраныТолькоОтказы = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ВыбраныТолькоОтказы Тогда
			Элементы.ГруппаКомандыВходящиеУведомления.ТекущаяСтраница
				= Элементы.СтраницаПолучитьПовторитьИОтменитьОтправкуВходящиеУведомления;
		Иначе
			Элементы.ГруппаКомандыВходящиеУведомления.ТекущаяСтраница = Элементы.СтраницаПолучитьВходящиеУведомления;
		КонецЕсли;
		
	КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсходящиеДокументы

	&НаКлиенте
	Процедура ИсходящиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
		ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецПроцедуры

#Конецобласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостоянияДокументовМЭДО

	&НаКлиенте
	Процедура СостоянияДокументовМЭДОВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
		ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
	&НаКлиенте
	Процедура ПолучитьВходящиеДокументы(Команда)
		
		ОчиститьСообщения();
		
		МЭДОВызовСервера.ПолучитьВходящиеДокументы(Объект.Организация);
		ОбновитьВходящиеДокументы();
		ОбновитьИсходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ОтправитьИсходящиеУведомления(Команда)
		
		ОчиститьСообщения();
		
		МЭДОВызовСервера.ОтправитьИсходящиеКвитанции(Объект.Организация);
		
		МассивУведомлений = Новый Массив();
		Для Каждого Строка Из ИсходящиеУведомления.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл
			Если ТипЗнч(Строка.ПредметСообщения) = Тип("ДокументСсылка.УведомлениеМЭДО") Тогда
				МассивУведомлений.Добавить(Строка.ПредметСообщения);
			КонецЕсли;
		КонецЦикла;
		Если МассивУведомлений.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеОтвета = МЭДОКлиент.НовыйЛегкийОтвет();
		МЭДОВызовСервера.ОтправитьИсходящиеУведомления(Объект.Организация, ДанныеОтвета, МассивУведомлений);
		
		ОбновитьВходящиеДокументы();
		ОбновитьИсходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ОтправитьИсходящиеДокументы(Команда)
		
		МассивДокументов = Новый Массив;
		Для Каждого Строка Из ИсходящиеДокументы.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл
			МассивДокументов.Добавить(Строка.Документ);
		КонецЦикла;
		Если МассивДокументов.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ОчиститьСообщения();
		
		МЭДОКлиент.НачатьОтправкуИсходящихДокументов(
			Объект.Организация,
			МассивДокументов,
			ЭтотОбъект,
			Новый ОписаниеОповещения("ОтправитьИсходящиеДокументыЗавершение", ЭтотОбъект));
		ОбновитьИсходящиеДокументы();
		ОбновитьВходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ПолучитьВходящиеУведомления(Команда)
		
		ОчиститьСообщения();
		
		МЭДОВызовСервера.ПолучитьВходящиеУведомленияКвитанции(Объект.Организация);
		ОбновитьИсходящиеДокументы();
		ОбновитьВходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура Обновить(Команда)
		
		ОбновитьНаСервере();
		Элементы.ВсеУведомленияСписок.Обновить();
		Элементы.СписокЖурналСобытий.Обновить();
		Элементы.СостоянияДокументовМЭДО.Обновить();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ВходящиеДокументыСоздатьОтветноеУведомление(Команда)
		
		Если Элементы.ВходящиеДокументы.ВыделенныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		КолвоВыделенных = Элементы.ВходящиеДокументы.ВыделенныеСтроки.Количество();
		Если КолвоВыделенных = 0 Или КолвоВыделенных > 1 Тогда
			ПоказатьПредупреждение( , 
				НСтр("ru = 'Должна быть выделена одна строка в списке документов. 
				|Уведомление создается на конкретный документ!'"), , 
				НСтр("ru = 'Отменено'"));
			Возврат;
		КонецЕсли;
		
		ВыделеннаяСтрока = ВходящиеДокументы.НайтиПоИдентификатору(Элементы.ВходящиеДокументы.ВыделенныеСтроки[0]);
		МЭДОКлиент.СоздатьОтветноеУведомление(ВыделеннаяСтрока.Документ, ЭтотОбъект);
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ВходящиеДокументыОтказатьВРегистрации(Команда)
		
		Если Элементы.ВходящиеДокументы.ВыделенныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		КолвоВыделенных = Элементы.ВходящиеДокументы.ВыделенныеСтроки.Количество();
		Фраза = НСтр("ru = 'Укажите причину отказа.'");
		Если КолвоВыделенных = 0 Тогда
			Возврат;
		ИначеЕсли КолвоВыделенных = 1 Тогда
			Фраза = Фраза + НСтр("ru = ' Автоматически будет создано уведомление'");
		Иначе
			Фраза = Фраза + СтрШаблон(
				НСтр("ru = ' Автоматически будут созданы уведомления с этой причиной отказа по всем выделенным документам - %1 шт'"),
				КолвоВыделенных);
		КонецЕсли;
		
		ПричинаОтказа = Неопределено;
		ОписаниеОповещения = Новый ОписаниеОповещения("ВводПричиныОтказаВРегистрацииЗавершение", ЭтотОбъект);
		ПоказатьВводЗначения(
			ОписаниеОповещения, ПричинаОтказа, Фраза, Тип("СправочникСсылка.ПричиныОтказаВРегистрацииМЭДО"));
		
	КонецПроцедуры

	&НаКлиенте
	Процедура ЗапуститьЗадание(Команда)
		ЗапуститьЗаданиеНаСервере();
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ИсходящиеДокументыВыполнитьДействие(Команда)
		
		МассивДокументов = Новый Массив();
		Для Каждого Индекс Из Элементы.ВходящиеУведомления.ВыделенныеСтроки Цикл
			ВыделеннаяСтрока = ВходящиеУведомления.НайтиПоИдентификатору(Индекс);
			МассивДокументов.Добавить(ВыделеннаяСтрока.Документ);
		КонецЦикла;
		
		ИсходящиеДокументыВыполнитьДействиеНаСервере(МассивДокументов, Команда.Имя);
		ОбновитьИсходящиеДокументы();
		ОбновитьВходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ИсходящиеУведомленияВыбратьВсе(Команда)
		
		ВыбратьВсеИсходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ИсходящиеУведомленияСнятьВсе(Команда)
		
		СнятьВсеИсходящиеУведомления();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ИсходящиеДокументыВыбратьВсе(Команда)
		
		ВыбратьВсеИсходящиеДокументы();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура ИсходящиеДокументыСнятьВсе(Команда)
		
		СнятьВсеИсходящиеДокументы();
		
	КонецПроцедуры
	
	&НаКлиенте
	Процедура РасширенныйВид(Команда)
		
		Элементы.РасширенныйВид.Пометка = Не Элементы.РасширенныйВид.Пометка;
		УправлениеВидимостью();
		
	КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
	#Область СлужебныеКлиентские
	
		&НаКлиенте
		Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
			
			СтандартнаяОбработка = Ложь;
			Если Элемент.ТекущиеДанные = Неопределено Или Элемент.ТекущиеДанные.Свойство("Документ") = Ложь Тогда
				Возврат;
			КонецЕсли;
			ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
			
		КонецПроцедуры
		
		&НаКлиенте
		Процедура УведомленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
			
			СтандартнаяОбработка = Ложь;
			Если Элемент.ТекущиеДанные = Неопределено Или Элемент.ТекущиеДанные.Свойство("ПредметСообщения") = Ложь Тогда
				Возврат;
			КонецЕсли;
			
			Если ТипЗнч(Элемент.ТекущиеДанные.ПредметСообщения) = Тип("ДокументСсылка.УведомлениеМЭДО") Тогда
				ПоказатьЗначение(, Элемент.ТекущиеДанные.ПредметСообщения);
			Иначе
				ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
			КонецЕсли;
			
		КонецПроцедуры
		
		&НаКлиенте
		Процедура ОтправитьИсходящиеДокументыЗавершение(Результат, ПараметрыОповещения) Экспорт
			
			ОбновитьИсходящиеДокументы();
			ОбновитьВходящиеУведомления();
			
		КонецПроцедуры
		
		&НаКлиенте
		Процедура ВводПричиныОтказаВРегистрацииЗавершение(ПричинаОтказа, Параметры) Экспорт
			
			Если Не ЗначениеЗаполнено(ПричинаОтказа) Тогда
				Возврат;
			КонецЕсли;
			
			МассивДокументов = Новый Массив();
			Для Каждого Индекс Из Элементы.ВходящиеДокументы.ВыделенныеСтроки Цикл
				ВыделеннаяСтрока = ВходящиеДокументы.НайтиПоИдентификатору(Индекс);
				МассивДокументов.Добавить(ВыделеннаяСтрока.Документ);
			КонецЦикла;
			
			ВходящиеДокументыОтказатьВРегистрацииНаСервере(МассивДокументов, ПричинаОтказа);
			
			ОбновитьВходящиеДокументы();
			ОбновитьИсходящиеУведомления();
			
		КонецПроцедуры
	
	#КонецОбласти
	
	#Область СлужебныеСерверные
	
		&НаСервере
		Процедура ОбновитьНаСервере()
			
			ОбновитьВходящиеДокументы();
			ОбновитьИсходящиеУведомления();
			ОбновитьИсходящиеДокументы();
			ОбновитьВходящиеУведомления();
			
			СписокОрганизаций = ОрганизацииНастроенныеДляМЭДО();
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ОбновитьКаталогиОбмена()
			
			Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
				Возврат;
			КонецЕсли;
			
			ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет(Истина, "");
			Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.ПолучитьНастройки(Объект.Организация, ДанныеОтвета);
			Если Не ДанныеОтвета.Успех Тогда
				Возврат;
			КонецЕсли;
			КаталогОбменаПолучение = Настройки.КаталогПолучения;
			КаталогОбменаОтправка = Настройки.КаталогОтправки;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ОбновитьВходящиеДокументы()
			
			ВходящиеДокументы.Загрузить(МЭДО.ВходящиеДокументыКОбработке());
			
			Для Каждого Стр Из ВходящиеДокументы Цикл
				Стр.ПредставлениеДокумента = СтрШаблон(НСтр(
					"ru = '%1
					|Получен из сообщения: %2'"),
						СокрЛП(Стр.Документ),
						Стр.ИдентификаторСообщения)
			КонецЦикла;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ОбновитьИсходящиеУведомления()
			
			ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
			Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.ПолучитьНастройки(
				Объект.Организация, ДанныеОтвета, "Организация, КаталогОтправки, РазмерПорции");
			Если Не ДанныеОтвета.Успех Тогда
				Возврат;
			КонецЕсли;
			ИсходящиеУведомления.Загрузить(МЭДО.ИсходящиеУведомленияКОтправке(Настройки));
			ВыбратьВсеИсходящиеУведомления();
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ОбновитьИсходящиеДокументы()
			
			ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
			Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.ПолучитьНастройки(
				Объект.Организация, ДанныеОтвета, "Организация, КаталогОтправки, РазмерПорции");
			Если Не ДанныеОтвета.Успех Тогда
				Возврат;
			КонецЕсли;
			ИсходящиеДокументы.Загрузить(МЭДО.ИсходящиеДокументыКОтправке(Настройки));
			ВыбратьВсеИсходящиеДокументы();
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ОбновитьВходящиеУведомления()
			
			ВходящиеУведомления.Загрузить(МЭДО.ВходящиеУведомленияКОбработке());
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ВходящиеДокументыОтказатьВРегистрацииНаСервере(МассивДокументов, ПричинаОтказа)
			
			МЭДО.СоздатьОтказыВРегистрации(МассивДокументов, ПричинаОтказа);
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ИсходящиеДокументыВыполнитьДействиеНаСервере(МассивДокументов, Действие)
			
			Если Действие = "ИсходящиеДокументыПовторитьОтправку" Тогда
				
				Для Каждого Документ Из МассивДокументов Цикл
					МЭДО.ИзменитьПризнакОтправки(Документ, "ПовторитьОтправку");
				КонецЦикла;
				
			ИначеЕсли Действие = "ИсходящиеДокументыОтменитьОтправку" Тогда
				
				Для Каждого Документ Из МассивДокументов Цикл
					МЭДО.ИзменитьПризнакОтправки(Документ, "ОтменитьОтправку");
				КонецЦикла;
				
			Иначе
				Возврат;
			КонецЕсли;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ВыбратьВсеИсходящиеУведомления()
			
			Для Каждого Стр Из ИсходящиеУведомления Цикл
				Стр.Использовать = Истина;
			КонецЦикла;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура СнятьВсеИсходящиеУведомления()
			
			Для Каждого Стр Из ИсходящиеУведомления Цикл
				Стр.Использовать = Ложь;
			КонецЦикла;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура ВыбратьВсеИсходящиеДокументы()
			
			Для Каждого Стр Из ИсходящиеДокументы Цикл
				Стр.Использовать = Истина;
			КонецЦикла;
			
		КонецПроцедуры
		
		&НаСервере
		Процедура СнятьВсеИсходящиеДокументы()
			
			Для Каждого Стр Из ИсходящиеДокументы Цикл
				Стр.Использовать = Ложь;
			КонецЦикла;
			
		КонецПроцедуры
		
		&НаСервере
		Функция ОрганизацииНастроенныеДляМЭДО()
			
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	Настройки.Организация
				|ИЗ
				|	РегистрСведений.НастройкиОрганизацийМЭДО КАК Настройки
				|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
				|	Справочник.Организации КАК Организации
				|		ПО
				|			Организации.Ссылка = Настройки.Организация
				|УПОРЯДОЧИТЬ ПО
				|	Организация
				|АВТОУПОРЯДОЧИВАНИЕ");
			
			МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
			СписокОрганизаций = Новый СписокЗначений();
			СписокОрганизаций.ЗагрузитьЗначения(МассивОрганизаций);
			Возврат СписокОрганизаций;
			
		КонецФункции
		
		&НаСервере
		Процедура УправлениеВидимостью()
			
			Если Элементы.РасширенныйВид.Пометка Тогда
				Элементы.РасширенныйВид.Заголовок = НСтр("ru = 'Выключить расширенный вид'");
			Иначе
				Элементы.РасширенныйВид.Заголовок = НСтр("ru = 'Включить расширенный вид'");
			КонецЕсли;
			
			Элементы.СтраницаСостояния.Видимость = Элементы.РасширенныйВид.Пометка;
			Элементы.СтраницаЖурналСобытий.Видимость = Элементы.РасширенныйВид.Пометка;
			Элементы.СтраницаУведомления.Видимость = Элементы.РасширенныйВид.Пометка;
			
			Если Не ЭтоПолноправныйПользователь Тогда
				Элементы.ЗапуститьЗадание.Видимость = Ложь;
			КонецЕсли;
			
		КонецПроцедуры
	
		&НаСервере
		Процедура ЗапуститьЗаданиеНаСервере()
			МЭДО.ВыполнитьОбменМЭДО();
			ОбновитьНаСервере();
		КонецПроцедуры
	
	#КонецОбласти
	
#КонецОбласти
