
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
	ЗаполнитьАдресатов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресатов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникГруппыЛичныхАдресатов.Ссылка КАК ГруппаСсылка,
		|	СправочникГруппыЛичныхАдресатов.ПометкаУдаления КАК ГруппаПометкаУдаления,
		|	СправочникГруппыЛичныхАдресатов.Предопределенный КАК ГруппаПредопределенный,
		|	СправочникГруппыЛичныхАдресатов.Наименование КАК ГруппаНаименование,
		|	ЛичныеАдресаты.Ссылка КАК ЛичныеАдресатыСсылка,
		|	ЛичныеАдресаты.ПометкаУдаления КАК ЛичныеАдресатыПометкаУдаления,
		|	ЛичныеАдресаты.Наименование КАК ЛичныеАдресатыНаименование,
		|	ЛичныеАдресаты.Должность,
		|	ЛичныеАдресаты.Комментарий,
		|	ЛичныеАдресаты.Организация
		|ИЗ
		|	Справочник.ГруппыЛичныхАдресатов КАК СправочникГруппыЛичныхАдресатов
		|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
		|		ПО СправочникГруппыЛичныхАдресатов.Ссылка = ЛичныеАдресаты.Группа
		|ГДЕ
		|	ЕСТЬNULL(СправочникГруппыЛичныхАдресатов.Пользователь, ЛичныеАдресаты.Пользователь) = &Пользователь
		|	И ЕСТЬNULL(ЛичныеАдресаты.Пользователь, СправочникГруппыЛичныхАдресатов.Пользователь) = &Пользователь
		|	И (&ПометкаУдаления = НЕОПРЕДЕЛЕНО
		|			ИЛИ НЕ ЕСТЬNULL(ЛичныеАдресаты.ПометкаУдаления, ЛОЖЬ))
		|	И (&ПометкаУдаления = НЕОПРЕДЕЛЕНО
		|			ИЛИ НЕ ЕСТЬNULL(СправочникГруппыЛичныхАдресатов.ПометкаУдаления, ЛОЖЬ))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ГруппаСсылка ИЕРАРХИЯ,
		|	ЛичныеАдресатыНаименование";
		
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Если Не ОтображатьУдаленныхАдресатов Тогда
		Запрос.УстановитьПараметр("ПометкаУдаления", ОтображатьУдаленныхАдресатов);
	Иначе	
		Запрос.УстановитьПараметр("ПометкаУдаления", Неопределено);
	КонецЕсли;
	
	ВыборкаДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ДеревоКонтактов.ПолучитьЭлементы().Очистить();
	КореньДерева = ДеревоКонтактов.ПолучитьЭлементы();
	ВеткиДереваДляГрупп = Новый Соответствие;
	
	ВыборкаДерево.Строки.Сортировать("ГруппаНаименование, ЛичныеАдресатыНаименование");
	Для Каждого СтрокаВыборкиДерево Из ВыборкаДерево.Строки Цикл
		
		ЗаполнитьЛистДереваМоиКонтакты(СтрокаВыборкиДерево, КореньДерева, ВеткиДереваДляГрупп);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛистДереваМоиКонтакты(Выборка, КореньДерева, ВеткиДереваДляГрупп);
	
	СтрокаДереваГруппы = Неопределено;
	ЭлементыДляДобавленияПользователей = КореньДерева;
	
	Если ЗначениеЗаполнено(Выборка.ГруппаСсылка) Тогда
	
		СтрокаДереваГруппы = ВеткиДереваДляГрупп.Получить(Выборка.ГруппаСсылка);
		Если СтрокаДереваГруппы = Неопределено Тогда
			
			СтрокаДереваГруппы = КореньДерева.Добавить();
			ВеткиДереваДляГрупп.Вставить(Выборка.ГруппаСсылка, СтрокаДереваГруппы);
			
			СтрокаДереваГруппы.Наименование = Выборка.ГруппаНаименование;
			СтрокаДереваГруппы.Группа = Выборка.ГруппаСсылка;
			СтрокаДереваГруппы.Ссылка = Выборка.ГруппаСсылка;
			СтрокаДереваГруппы.НомерКартинки = ?(Выборка.ГруппаПометкаУдаления, 2, 3);
			СтрокаДереваГруппы.ПометкаУдаления = Выборка.ГруппаПометкаУдаления;
			
		КонецЕсли;
		
		ЭлементыДляДобавленияПользователей = СтрокаДереваГруппы.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ЛичныеАдресатыСсылка) Тогда
		
		СтрокаДереваПользователь = ЭлементыДляДобавленияПользователей.Добавить();
		
		СтрокаДереваПользователь.Наименование = Выборка.ЛичныеАдресатыНаименование;
		СтрокаДереваПользователь.Группа = Выборка.ГруппаСсылка;
		СтрокаДереваПользователь.Ссылка = Выборка.ЛичныеАдресатыСсылка;
		СтрокаДереваПользователь.НомерКартинки = ?(Выборка.ЛичныеАдресатыПометкаУдаления = Истина, 0, 1);
		СтрокаДереваПользователь.ЭтоАдресат = Истина;
		СтрокаДереваПользователь.ПометкаУдаления = Выборка.ЛичныеАдресатыПометкаУдаления;
		
		СтрокаДереваПользователь.Должность = Выборка.Должность;
		СтрокаДереваПользователь.Комментарий = Выборка.Комментарий;
		СтрокаДереваПользователь.Организация = Выборка.Организация;
		
		Для Каждого СтрокаКонтактнойИнформации Из Выборка.ЛичныеАдресатыСсылка.КонтактнаяИнформация Цикл
			Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				СтрокаДереваПользователь.Email = СтрокаКонтактнойИнформации.АдресЭП;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Для Каждого СтрокаКонтактнойИнформации Из Выборка.ЛичныеАдресатыСсылка.КонтактнаяИнформация Цикл
			Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
				СтрокаДереваПользователь.Телефон = СтрокаКонтактнойИнформации.Представление;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
	КонецЕсли;	
	
	Выборка.Строки.Сортировать("ГруппаНаименование, ЛичныеАдресатыНаименование");
	Для Каждого СтрокаВыборкиДерево Из Выборка.Строки Цикл
		
		ЗаполнитьЛистДереваМоиКонтакты(СтрокаВыборкиДерево, 
			СтрокаДереваГруппы.ПолучитьЭлементы(), ВеткиДереваДляГрупп);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Элемент", Элемент);

	Если Элемент.ВыделенныеСтроки.Количество() = 1 Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Пометка = Элемент.ТекущиеДанные.ПометкаУдаления;
			ПараметрыОповещения.Вставить("Множественный", Ложь);

			Если Пометка Тогда 
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
					Строка(Элемент.ТекущиеДанные.Наименование));
			Иначе
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометить ""%1"" на удаление?'"),
					Строка(Элемент.ТекущиеДанные.Наименование));
			КонецЕсли;	
		Иначе 
			Возврат; 
		КонецЕсли;
		
	ИначеЕсли Элемент.ВыделенныеСтроки.Количество() > 1 Тогда
		
		Пометка = Истина;
		Для Каждого СтрокаТаблицы Из Элемент.ВыделенныеСтроки Цикл
			СтрокаТаблицыКонтакт = ДеревоКонтактов.НайтиПоИдентификатору(СтрокаТаблицы);
			Если СтрокаТаблицыКонтакт.ПометкаУдаления = Истина Тогда
				Пометка = Ложь;
				Прервать;	
			КонецЕсли;
		КонецЦикла;
		ПараметрыОповещения.Вставить("Множественный", Истина);
		
		Если Пометка Тогда
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОповещения.Вставить("Пометка", Пометка);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоКонтактовПередУдалениемПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);

	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПередУдалениемПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	Элемент = Параметры.Элемент;
	Пометка = Параметры.Пометка;
	
	Если Параметры.Множественный Тогда 
		ПометитьНаУдалениеСтроки(Элемент.ВыделенныеСтроки, Пометка);
		ЗаполнитьАдресатовИВосстановитьСостояниеДерева();	
	Иначе 	
		Элемент.ТекущиеДанные.ПометкаУдаления = НЕ Элемент.ТекущиеДанные.ПометкаУдаления;
		Если Пометка Тогда
			Элемент.ТекущиеДанные.НомерКартинки = Элемент.ТекущиеДанные.НомерКартинки + 1;
		Иначе	
			Элемент.ТекущиеДанные.НомерКартинки = Элемент.ТекущиеДанные.НомерКартинки - 1;
		КонецЕсли;	
		
		РаботаСЛичнымиАдресатами.ПометитьНаУдаление(Элемент.ТекущиеДанные.Ссылка, Не Пометка, УникальныйИдентификатор);
		
		Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ГруппыЛичныхАдресатов")
			Или ОтображатьУдаленныхАдресатов = Ложь Тогда
			ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
		КонецЕсли;	
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПередУдалениемОдинЭлемент(Результат, Параметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	Элемент = Параметры.Элемент;
	Пометка = Параметры.Пометка;
	
	Элемент.ТекущиеДанные.ПометкаУдаления = НЕ Элемент.ТекущиеДанные.ПометкаУдаления;
	Если Пометка Тогда
		Элемент.ТекущиеДанные.НомерКартинки = Элемент.ТекущиеДанные.НомерКартинки + 1;
	Иначе	
		Элемент.ТекущиеДанные.НомерКартинки = Элемент.ТекущиеДанные.НомерКартинки - 1;
	КонецЕсли;	
	
	РаботаСЛичнымиАдресатами.ПометитьНаУдаление(Элемент.ТекущиеДанные.Ссылка, Не Пометка, УникальныйИдентификатор);
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ГруппыЛичныхАдресатов")
		Или ОтображатьУдаленныхАдресатов = Ложь Тогда
		ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеСтроки(Знач МассивСтрок, Пометка)
	
	Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
		СтрокаТаблицыКонтакт = ДеревоКонтактов.НайтиПоИдентификатору(СтрокаТаблицы);
		РаботаСЛичнымиАдресатами.ПометитьНаУдаление(СтрокаТаблицыКонтакт.Ссылка, Пометка, УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппу(Команда)
	
	ТекущаяГруппа = Неопределено;
	Если Элементы.ДеревоКонтактов.ТекущиеДанные <> Неопределено Тогда
		ТекущаяГруппа = Элементы.ДеревоКонтактов.ТекущиеДанные.Группа;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаполнитьДеревоАдресатов",
		ЭтотОбъект);

	ПараметрыФормы = Новый Структура("Родитель", ТекущаяГруппа);
	ОткрытьФорму("Справочник.ГруппыЛичныхАдресатов.ФормаОбъекта", ПараметрыФормы,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоАдресатов(Результат, Параметры) Экспорт 
	
	ЗаполнитьАдресатовИВосстановитьСостояниеДерева();

КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАдресатовИВосстановитьСостояниеДерева()
	
	СостояниеРаскрытости = Новый Соответствие;
	
	ТекущаяСсылка = Неопределено;
	Если Элементы.ДеревоКонтактов.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылка = Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка;
	КонецЕсли; 
	
	КореньДерева = ДеревоКонтактов.ПолучитьЭлементы();
	Для Каждого Строка Из КореньДерева Цикл
		СтрокаРазвернута = Элементы.ДеревоКонтактов.Развернут(Строка.ПолучитьИдентификатор());
		СостояниеРаскрытости[Строка.Ссылка] = СтрокаРазвернута;
	КонецЦикла;
	
	ЗаполнитьАдресатов();
	
	КореньДерева = ДеревоКонтактов.ПолучитьЭлементы();
	
	ТекущийИдентификатор = Неопределено;
	Если ТекущаяСсылка <> Неопределено Тогда
		ТекущийИдентификатор = НайтиИдентификаторПоСсылке(КореньДерева, ТекущаяСсылка);
	КонецЕсли;
	
	Для Каждого Строка Из КореньДерева Цикл
		
		СтрокаРазвернута = СостояниеРаскрытости.Получить(Строка.Ссылка);
		
		Если СтрокаРазвернута = Истина Тогда
			Элементы.ДеревоКонтактов.Развернуть(Строка.ПолучитьИдентификатор());
		КонецЕсли;	
		
	КонецЦикла;
	
	Элементы.ДеревоКонтактов.ТекущаяСтрока = ТекущийИдентификатор;
	
КонецПроцедуры

&НаКлиенте 
Функция НайтиИдентификаторПоСсылке(ЭлементыДерева, ТекущаяСсылка)
	
	Для Каждого Строка Из ЭлементыДерева Цикл
		
		Если Строка.Ссылка = ТекущаяСсылка Тогда
			Возврат Строка.ПолучитьИдентификатор();
		КонецЕсли;	
		
		ДочерниеЭлементыДерева = Строка.ПолучитьЭлементы();
		Идентификатор = НайтиИдентификаторПоСсылке(ДочерниеЭлементыДерева, ТекущаяСсылка);
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;	
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции	

&НаКлиенте
Процедура ДеревоКонтактовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ПоказатьЗначение(, Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекущаяГруппа = Неопределено;
	Если Элементы.ДеревоКонтактов.ТекущиеДанные <> Неопределено Тогда
		ТекущаяГруппа = Элементы.ДеревоКонтактов.ТекущиеДанные.Группа;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("Родитель", ТекущаяГруппа);
	Если Копирование Тогда
		ПараметрыФормы.Вставить("КопируемыйЭлемент", Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаполнитьДеревоАдресатов",
		ЭтотОбъект);

	ОткрытьФорму("Справочник.ЛичныеАдресаты.ФормаОбъекта", ПараметрыФормы,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	КонецПроцедуры
	
&НаКлиенте
Процедура ДеревоКонтактовОбработкаЗапросаОбновления()
	
	Элементы.ДеревоКонтактов.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзOutlook(Команда)
	
	Состояние(НСтр("ru='Выполняется загрузка из адресной книги Outlook. Пожалуйста подождите...'"));
	
	МассивКонтактов = РаботаСЛичнымиАдресатамиКлиент.ЗагрузитьКонтактыИзOutlook();

	ЧислоЗагруженных = РаботаСЛичнымиАдресатами.ЗаписатьКонтакты(МассивКонтактов);
	ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	
	Состояние();
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Загрузка из адресной книги Outlook завершена. Загружено: %1.'"), 
		Формат(ЧислоЗагруженных, "ЧН=0"));
	ПоказатьПредупреждение(, СтрокаСообщения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЛичныйАдресат" Тогда
		ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение.Очистить();
	
	ТекущиеДанные = Элементы.ДеревоКонтактов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Для Каждого СтрокаИд Из Элементы.ДеревоКонтактов.ВыделенныеСтроки Цикл
		СтрокаДерева = ДеревоКонтактов.НайтиПоИдентификатору(СтрокаИд);
		ПараметрыПеретаскивания.Значение.Добавить(СтрокаДерева.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ГруппаНазначения = ПредопределенноеЗначение("Справочник.ЛичныеАдресаты.ПустаяСсылка");
	
	Если ЗначениеЗаполнено(Строка) Тогда
		СтрокаНазначения = ДеревоКонтактов.НайтиПоИдентификатору(Строка);
		Если СтрокаНазначения <> Неопределено Тогда
			ГруппаНазначения = СтрокаНазначения.Группа;
		КонецЕсли;			
	КонецЕсли;	
	
	СменитьВладельца(ПараметрыПеретаскивания.Значение, ГруппаНазначения);
	ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаСервере
Процедура СменитьВладельца(МассивСсылок, ГруппаНазначения)
	
	Для Каждого Ссылка Из МассивСсылок Цикл
		
		Если Ссылка.Группа <> ГруппаНазначения Тогда
			
			ЗаблокироватьДанныеДляРедактирования(Ссылка, , УникальныйИдентификатор);
			СправочникОбъект = Ссылка.ПолучитьОбъект();
			СправочникОбъект.Группа = ГруппаНазначения;
			СправочникОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Ссылка, УникальныйИдентификатор);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПреобразоватьВКонтрагента(Команда)
	
	Если Элементы.ДеревоКонтактов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЛичныйАдресат = Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка;
	ПараметрыФормы = Новый Структура("ЛичныйАдресат", ЛичныйАдресат);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПреобразоватьВКонтрагентаПродолжение",
		ЭтотОбъект,
		ПараметрыФормы);

	ОткрытьФорму("Справочник.ЛичныеАдресаты.Форма.ВыборКонтрагентаКонтактноеЛицо", ПараметрыФормы,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПреобразоватьВКонтрагентаПродолжение(КодВозврата, Параметры) Экспорт 
	
	Если ТипЗнч(КодВозврата) = Тип("СправочникСсылка.Контрагенты") 
		Или ТипЗнч(КодВозврата) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ЛичныйАдресат = Параметры.ЛичныйАдресат;
		СтрокаОшибки = "";
		
		Если РаботаСЛичнымиАдресатами.ЗаполнитьКонтактИЗаменитьСсылки(ЛичныйАдресат, КодВозврата, Неопределено, СтрокаОшибки) Тогда
			ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
			
			ТекстОповещения = ?(ТипЗнч(КодВозврата) = Тип("СправочникСсылка.Контрагенты"),
				"контрагента", "контактное лицо");
			ТекстОповещения = СтрШаблон(НСтр("ru = 'Адресат преобразован в ""%1"""), ТекстОповещения);
			ПоказатьОповещениеПользователя(ТекстОповещения,
				ПолучитьНавигационнуюСсылку(КодВозврата),
				Строка(КодВозврата),
				БиблиотекаКартинок.Информация32);
		Иначе
			ПоказатьПредупреждение(, СтрокаОшибки);
		КонецЕсли;	
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныхАдресатов(Команда)
	
	ОтображатьУдаленныхАдресатов = Не ОтображатьУдаленныхАдресатов;
	Элементы.ДеревоКонтактовОтображатьУдаленныхАдресатов.Пометка = ОтображатьУдаленныхАдресатов;
	ЗаполнитьАдресатовИВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.ДеревоКонтактовОрганизация.Заголовок = РедакцииКонфигурацииКлиентСервер.Организация();
		
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	// Скроем команды.
	Элементы.ДеревоКонтактовОбновить.Видимость = Ложь;
	Элементы.ДеревоКонтактовЗагрузитьИзOutlook.Видимость = Ложь;
	Элементы.ДеревоКонтактовКонтекстноеМенюДобавить.Видимость = Ложь;
	Элементы.ДеревоКонтактовКонтекстноеМенюДобавитьГруппу.Видимость = Ложь;
	Элементы.ДеревоКонтактовКонтекстноеМенюЗагрузитьИзOutlook.Видимость = Ложь;

	// Показывать удаленных - перенесем в общее меню.
	Элементы.ДеревоКонтактовОтображатьУдаленныхАдресатов.ПоложениеВКоманднойПанели 
		= ПоложениеКнопкиВКоманднойПанели.ВКоманднойПанели;

	// Преобразовать в - должно быть в контекстном меню.
	Элементы.ДеревоКонтактовПреобразоватьВКонтрагента.Видимость = Ложь;
	Элементы.ДеревоКонтактовКонтекстноеМенюПреобразоватьВКонтрагента.Видимость = Истина;
	
КонецПроцедуры

