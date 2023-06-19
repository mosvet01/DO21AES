
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение наименования
	Наименование = Параметры.Наименование;
	
	// Заполнение типа условия
	ТипУсловия = Параметры.ТипУсловия;
	Если Не ЗначениеЗаполнено(ТипУсловия) Тогда
		ТипУсловия = Перечисления.ТипыУсловийКомплексныхПроцессов.УсловиеПоРезультатамВыполненияДействий;
	КонецЕсли;
	
	// Заполнение таблицы предметов
	Если Параметры.Предметы <> Неопределено Тогда
		
		// Заполним таблицу по параметру Предметы.
		КэшСтрокТаблицыПредметов = Новый Соответствие;
		Для Каждого СтрокаТаблицы Из Параметры.Предметы Цикл
			СтрокаТаблицыПредметов = Предметы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыПредметов, СтрокаТаблицы);
			КэшСтрокТаблицыПредметов.Вставить(СтрокаТаблицыПредметов.ИмяПредмета, СтрокаТаблицыПредметов);
		КонецЦикла;
		
		// Установим отметки и условия по параметру НастройкиУсловия
		Если ТипУсловия = Перечисления.ТипыУсловийКомплексныхПроцессов.УсловиеПоПредметам
			И Параметры.НастройкиУсловия <> Неопределено Тогда
			
			ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных("УсловиеПоПредметам");
			Для Каждого ЭлементОтбора Из Параметры.НастройкиУсловия.Отбор.Элементы Цикл
				
				Если ЭлементОтбора.ЛевоеЗначение <> ПолеКомпоновкиДанных Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТаблицыПредметов = КэшСтрокТаблицыПредметов.Получить(
					ЭлементОтбора.ПравоеЗначение.ИмяПредмета);
				
				Если СтрокаТаблицыПредметов <> Неопределено Тогда
					СтрокаТаблицыПредметов.УсловиеМаршрутизации = ЭлементОтбора.ПравоеЗначение.Условие;
					СтрокаТаблицыПредметов.ИспользоватьВУсловии = Истина;
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	// Заполнение таблицы действий
	Если Параметры.Действия <> Неопределено Тогда
		
		// Заполнение реквизита РезультатыВыполненияДействий
		РезультатыВыполненияДействий = Новый Структура;
		
		ВсеРезультатыВыполнения = РаботаСКомплекснымиБизнесПроцессамиСервер.РезультатыВыполненияДействий();
		
		// Заполним таблицу по параметру Действия.
		КэшСтрокТаблицыДействий = Новый Соответствие;
		Для Каждого СтрокаТаблицы Из Параметры.Действия Цикл
			
			СтрокаТаблицыДействий = Действия.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыДействий, СтрокаТаблицы);
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Действие) Тогда
				СтрокаТаблицыДействий.Описание = СтрПолучитьСтроку(СтрокаТаблицы.Наименование, 1);
			ИначеЕсли ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(СтрокаТаблицы.Действие) Тогда
				СтрокаТаблицыДействий.Описание = Строка(СтрокаТаблицы.Действие);
			Иначе
				СтрокаТаблицыДействий.Описание = Строка(СтрокаТаблицы.Действие);
			КонецЕсли;
			
			ИмяДействияВКП = РаботаСКомплекснымиБизнесПроцессамиСервер.ИмяДействияВКомплексномПроцессеПоОбъекту(
				СтрокаТаблицы.Действие);
			
			РезультатыВыполненияДействий.Вставить(СтрокаТаблицыДействий.Имя,
				ВсеРезультатыВыполнения[ИмяДействияВКП]);
			
			КэшСтрокТаблицыДействий[СтрокаТаблицыДействий.Имя] = СтрокаТаблицыДействий;
			
		КонецЦикла;
		
		// Установим отметки и результаты завершения по параметру НастройкиУсловия
		Если ТипУсловия = Перечисления.ТипыУсловийКомплексныхПроцессов.УсловиеПоРезультатамВыполненияДействий
			И Параметры.НастройкиУсловия <> Неопределено Тогда
			
			ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных("УсловиеПоРезультатамВыполненияДействий");
			Для Каждого ЭлементОтбора Из Параметры.НастройкиУсловия.Отбор.Элементы Цикл
				
				Если ЭлементОтбора.ЛевоеЗначение <> ПолеКомпоновкиДанных Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТаблицыДействий = КэшСтрокТаблицыДействий.Получить(
					ЭлементОтбора.ПравоеЗначение.Действие);
				
				Если СтрокаТаблицыДействий <> Неопределено Тогда
					СтрокаТаблицыДействий.РезультатВыполнения = ЭлементОтбора.ПравоеЗначение.РезультатВыполнения;
					
					ВсеРезультатыДействия = РезультатыВыполненияДействий[СтрокаТаблицыДействий.Имя];
					
					ЗначениеИПредставлениеРезультата = ВсеРезультатыДействия.НайтиПоЗначению(
						СтрокаТаблицыДействий.РезультатВыполнения);
					
					Если ЗначениеИПредставлениеРезультата <> Неопределено Тогда
						СтрокаТаблицыДействий.РезультатВыполненияСтрокой = ЗначениеИПредставлениеРезультата.Представление;
					Иначе
						СтрокаТаблицыДействий.РезультатВыполненияСтрокой = Строка(СтрокаТаблицыДействий.РезультатВыполнения);
					КонецЕсли;
					
					СтрокаТаблицыДействий.ИспользоватьВУсловии = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	// Заполнение компоновщика (реквизит формы Компоновщик)
	Если ТипУсловия = Перечисления.ТипыУсловийКомплексныхПроцессов.РасширенноеУсловие Тогда
		ИнициализироватьКомпоновщикНастроек(
			Компоновщик, УникальныйИдентификатор, Параметры.НастройкиУсловия);
	Иначе
		ИнициализироватьКомпоновщикНастроек(Компоновщик, УникальныйИдентификатор);
	КонецЕсли;
	
	// Устновка условного оформления таблицы Предметы.
	Эл = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформление, НСтр("ru = 'Не заполнено условие маршрутизации'"));
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предметы.ИспользоватьВУсловии");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предметы.УсловиеМаршрутизации");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("ОтметкаНезаполненного");
	ЭлементОформления.Значение = Истина;
	ЭлементОформления.Использование = Истина;
	Поле = Эл.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ПредметыУсловиеМаршрутизации");
	
	Эл = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформление, НСтр("ru = 'Недоступное для редактирования условие маршрутизации'"));
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предметы.ИспользоватьВУсловии");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("Текст");
	ЭлементОформления.Значение = "";
	ЭлементОформления.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("ТолькоПросмотр");
	ЭлементОформления.Значение = Истина;
	ЭлементОформления.Использование = Истина;
	Поле = Эл.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ПредметыУсловиеМаршрутизации");
	
	// Устновка условного оформления таблицы Действия.
	Эл = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформление, НСтр("ru = 'Не заполнен результат выполнения'"));
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Действия.ИспользоватьВУсловии");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Действия.РезультатВыполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("ОтметкаНезаполненного");
	ЭлементОформления.Значение = Истина;
	ЭлементОформления.Использование = Истина;
	Поле = Эл.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ДействияРезультатВыполненияСтрокой");
	
	Эл = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформление, НСтр("ru = 'Недоступный для редактирования результат выполнения действия'"));
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Действия.ИспользоватьВУсловии");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("Текст");
	ЭлементОформления.Значение = "";
	ЭлементОформления.Использование = Истина;
	ЭлементОформления = Эл.Оформление.Элементы.Найти("ТолькоПросмотр");
	ЭлементОформления.Значение = Истина;
	ЭлементОформления.Использование = Истина;
	Поле = Эл.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ДействияРезультатВыполненияСтрокой");
	
	// Для компоновщика скрываем поля ЛевоеЗначение, ВидСравнения, ПравоеЗначение.
	// Они будут заполняться программно.
	Элементы.КомпоновщикНастройкиОтборЛевоеЗначение.Видимость = Ложь;
	Элементы.КомпоновщикНастройкиОтборВидСравнения.Видимость = Ложь;
	Элементы.КомпоновщикНастройкиОтборПравоеЗначение.Видимость = Ложь;
	
	// Определяем доступность команды добавления условий на встроенном языке.
	Элементы.ДобавитьВыражениеНаВстроенномЯзыке.Видимость = ПравоДоступа(
		"Изменение", Метаданные.РегистрыСведений.СкриптыСхемКомплексныхПроцессов);
	
	// Настраиваем доступности/видимости элементов.
	Элементы.ГруппаТипУсловия.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ГруппаНастройкиУсловий.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.Наименование.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.КоманднаяПанельКомпоновщика.Видимость = Не ТолькоПросмотр;
	Элементы.Готово.Видимость = Не ТолькоПросмотр;
	Элементы.Готово.КнопкаПоУмолчанию = Не ТолькоПросмотр;
	Элементы.Отмена.Видимость = Не ТолькоПросмотр;
	Элементы.Закрыть.Видимость = ТолькоПросмотр;
	Элементы.Закрыть.КнопкаПоУмолчанию = ТолькоПросмотр;
	
	// Устанавливаем ключ сохранения формы.
	КлючСохраненияПоложенияОкна = ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказатьНастрокиПоТипуУсловия();
	
	ЗаполнитьПредставленияУсловийКомпоновщика();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипУсловияПриИзменении(Элемент)
	
	ПоказатьНастрокиПоТипуУсловия();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Действия

&НаКлиенте
Процедура ДействияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДействияОписание Тогда
		СтандартнаяОбработка = Ложь;
		Если Элементы.Действия.ТекущиеДанные <> Неопределено Тогда
			ПоказатьЗначение(, Элементы.Действия.ТекущиеДанные.Действие);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Действия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатыВыполненияДействия = РезультатыВыполненияДействий[Элементы.Действия.ТекущиеДанные.Имя];
	
	Элементы.ДействияРезультатВыполненияСтрокой.СписокВыбора.Очистить();
	
	Для Каждого РезультатВыполненияДействия Из РезультатыВыполненияДействия Цикл
		Элементы.ДействияРезультатВыполненияСтрокой.СписокВыбора.Добавить(
			РезультатВыполненияДействия.Значение,
			РезультатВыполненияДействия.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.Действия.ТекущийЭлемент = Элементы.ДействияОписание Тогда
		
		Отказ = Истина;
		
		Если Элементы.Действия.ТекущиеДанные <> Неопределено Тогда
			ПоказатьЗначение(, Элементы.Действия.ТекущиеДанные.Действие);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияРезультатВыполненияСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Действия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РезультатВыполнения = ВыбранноеЗначение;
	
	ВсеРезультатыДействия = РезультатыВыполненияДействий[ТекущиеДанные.Имя];
	ТекущиеДанные.РезультатВыполненияСтрокой = 
		ВсеРезультатыДействия.НайтиПоЗначению(ВыбранноеЗначение).Представление;
	
	Элементы.Действия.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияРезультатВыполненияСтрокойОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Действия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РезультатВыполнения = ПредопределенноеЗначение(
		"Перечисление.РезультатыВыполненияДействийКомплексныхПроцессов.ПустаяСсылка");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Предметы

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредметыОписание Тогда
		СтандартнаяОбработка = Ложь;
		Если Элементы.Предметы.ТекущиеДанные <> Неопределено
			И ЗначениеЗаполнено(Элементы.Предметы.ТекущиеДанные.Предмет) Тогда
			
			ПоказатьЗначение(, Элементы.Предметы.ТекущиеДанные.Предмет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.Предметы.ТекущийЭлемент = Элементы.ПредметыОписание Тогда
		
		Отказ = Истина;
		
		Если Элементы.Предметы.ТекущиеДанные <> Неопределено
			И ЗначениеЗаполнено(Элементы.Предметы.ТекущиеДанные.Предмет) Тогда
			
			ПоказатьЗначение(, Элементы.Предметы.ТекущиеДанные.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыКомпоновщикНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикНастройкиОтборПередНачаломИзменения(Элемент, Отказ)
	
	ТекущийЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	
	Если ТипЗнч(ТекущийЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или Элемент.ТекущийЭлемент.Имя = "КомпоновщикНастройкиОтборИспользование" Тогда
		
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПолеУсловиеПоПредметам = Новый ПолеКомпоновкиДанных("УсловиеПоПредметам");
	ПолеУсловиеПоРезультатамВыполненияДействий = Новый ПолеКомпоновкиДанных("УсловиеПоРезультатамВыполненияДействий");
	ПолеВыражениеНаВстроенномЯзыке = Новый ПолеКомпоновкиДанных("ВыражениеНаВстроенномЯзыке");
	
	Если ТекущийЭлементОтбора.ЛевоеЗначение = ПолеУсловиеПоПредметам Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершитьНачалоИзмененияНастройкиОтбора", ЭтотОбъект, ТекущийЭлементОтбора);
		
		ВыбратьУсловиеПоПредмету(
			ТекущийЭлементОтбора.ПравоеЗначение.ИмяПредмета,
			ТекущийЭлементОтбора.ПравоеЗначение.Условие,
			ОписаниеОповещения);
		
	ИначеЕсли ТекущийЭлементОтбора.ЛевоеЗначение = ПолеУсловиеПоРезультатамВыполненияДействий Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершитьНачалоИзмененияНастройкиОтбора", ЭтотОбъект, ТекущийЭлементОтбора);
		
		ВыбратьУсловиеВыполненияДействия(
			ТекущийЭлементОтбора.ПравоеЗначение.Действие,
			ТекущийЭлементОтбора.ПравоеЗначение.РезультатВыполнения,
			ОписаниеОповещения);
		
	ИначеЕсли ТекущийЭлементОтбора.ЛевоеЗначение = ПолеВыражениеНаВстроенномЯзыке Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершитьНачалоИзмененияНастройкиОтбораНаВстроенномЯзыке", ЭтотОбъект, ТекущийЭлементОтбора);
		
		РедактироватьВыражениеНаВстроенномЯзыке(
			ТекущийЭлементОтбора.ПравоеЗначение.Наименование,
			ТекущийЭлементОтбора.ПравоеЗначение.Выражение,
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение КомпоновщикНастройкиОтборПередНачаломИзменения
//
&НаКлиенте
Процедура ЗавершитьНачалоИзмененияНастройкиОтбора(Результат, ТекущийЭлементОтбора) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийЭлементОтбора.ПравоеЗначение = Результат;
	
	ЗаполнитьПредставленияУсловийКомпоновщика();
	
КонецПроцедуры

// Продолжение КомпоновщикНастройкиОтборПередНачаломИзменения
//
&НаКлиенте
Процедура ЗавершитьНачалоИзмененияНастройкиОтбораНаВстроенномЯзыке(
	Результат, ТекущийЭлементОтбора) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Условие = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.
		СтруктураУсловияНаВстроенномЯзыкеДляЭлементаОтбораКомпоновкиДанных(
			Результат.Наименование,
			Результат.ИдентификаторСкрипта);
	
	ТекущийЭлементОтбора.ПравоеЗначение = Условие;
	
	ЗаполнитьПредставленияУсловийКомпоновщика();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьРезультатВыполненияДействия(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьДобавлениеРезультатаВыполненияДействия", ЭтотОбъект);
	
	ВыбратьУсловиеВыполненияДействия(,, ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры ДобавитьРезультатВыполненияДействия
//
&НаКлиенте
Процедура ЗавершитьДобавлениеРезультатаВыполненияДействия(Условие, ДополнительныеПараметры) Экспорт
	
	Если Условие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьУсловиеВКомпоновщик("УсловиеПоРезультатамВыполненияДействий", Условие);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУсловиеПоПредмету(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьДобавлениеУсловияПоПредмету", ЭтотОбъект);
	
	ВыбратьУсловиеПоПредмету(,, ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры ДобавитьУсловиеПоПредмету
&НаКлиенте
Процедура ЗавершитьДобавлениеУсловияПоПредмету(Условие, ДополнительныеПараметры) Экспорт
	
	Если Условие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьУсловиеВКомпоновщик("УсловиеПоПредметам", Условие);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыражениеНаВстроенномЯзыке(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьДобавлениеУсловияНаВстроенномЯзыке", ЭтотОбъект);
	
	РедактироватьВыражениеНаВстроенномЯзыке(,, ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры ДобавитьУсловиеПоПредмету
&НаКлиенте
Процедура ЗавершитьДобавлениеУсловияНаВстроенномЯзыке(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Условие = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.
		СтруктураУсловияНаВстроенномЯзыкеДляЭлементаОтбораКомпоновкиДанных(
			Результат.Наименование,
			Результат.ИдентификаторСкрипта);
	
	ДобавитьУсловиеВКомпоновщик("ВыражениеНаВстроенномЯзыке", Условие);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Если ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.УсловиеПоПредметам") Тогда
		
		// Проверим заполнение условий маршрутизации
		ЕстьСтрокиБезУсловий = Ложь;
		Для Каждого СтрокаТаблицы Из Предметы Цикл
			
			Если Не СтрокаТаблицы.ИспользоватьВУсловии Тогда
				Продолжить;
			КонецЕсли;
			
			ИндексСтроки = Предметы.Индекс(СтрокаТаблицы);
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.УсловиеМаршрутизации) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не указано условие'"),,
					"Предметы[" + ИндексСтроки + "].УсловиеМаршрутизации",,
					ЕстьСтрокиБезУсловий);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьСтрокиБезУсловий Тогда
			Возврат;
		КонецЕсли;
		
		// Получить настроки условий по предметам.
		НастройкиУсловия = НастройкиУсловияПоПредметам(Предметы, УникальныйИдентификатор);
		
	ИначеЕсли ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.УсловиеПоРезультатамВыполненияДействий") Тогда
		
		// Проверим заполнение результатов выполнения
		ЕстьСтрокиБезУсловий = Ложь;
		Для Каждого СтрокаТаблицы Из Действия Цикл
			
			Если Не СтрокаТаблицы.ИспользоватьВУсловии Тогда
				Продолжить;
			КонецЕсли;
			
			ИндексСтроки = Действия.Индекс(СтрокаТаблицы);
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.РезультатВыполнения) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не указан результат выполнения'"),,
					"Действия[" + ИндексСтроки + "].РезультатВыполнения",,
					ЕстьСтрокиБезУсловий);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьСтрокиБезУсловий Тогда
			Возврат;
		КонецЕсли;
		
		НастройкиУсловия = НастройкиУсловияПоДействиям(Действия, УникальныйИдентификатор);
		
	ИначеЕсли ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.РасширенноеУсловие") Тогда
		
		ОчиститьПредставленияУсловийКомпоновщика();
		
		НастройкиУсловия = НастройкиРасширенногоУсловия(Компоновщик);
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ТипУсловия", ТипУсловия);
	Результат.Вставить("НастройкиУсловия", НастройкиУсловия);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Включает отображение соответствующей настройки по типу условия.
//
&НаКлиенте
Процедура ПоказатьНастрокиПоТипуУсловия()
	
	Если ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.УсловиеПоПредметам") Тогда
		
		Элементы.ГруппаНастройкиУсловий.ТекущаяСтраница = Элементы.ГруппаУсловияПоПредметам;
		
	ИначеЕсли ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.УсловиеПоРезультатамВыполненияДействий") Тогда
		
		Элементы.ГруппаНастройкиУсловий.ТекущаяСтраница = Элементы.ГруппаУсловиеПоРезультатамВыполнения;
		
	ИначеЕсли ТипУсловия = ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.РасширенноеУсловие") Тогда
		
		Элементы.ГруппаНастройкиУсловий.ТекущаяСтраница = Элементы.ГруппаРасширенноеУсловие;
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует компоновщик настроек компоновки данных.
//
// Параметры:
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - компоновщик настроек.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы для размещения
//                                                 схемы компоновки данных во временном хранилище.
//  НастройкиУсловия - НастройкиКомпоновкиДанных - настройки условий, которые загружаются в компоновщик.
//
&НаСервереБезКонтекста
Процедура ИнициализироватьКомпоновщикНастроек(
	КомпоновщикНастроек, ИдентификаторФормы, НастройкиУсловия = Неопределено)
	
	СхемаКомпоновкиДанных = Справочники.СхемыКомплексныхПроцессов.ПолучитьМакет("Условие");
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ИдентификаторФормы);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Если НастройкиУсловия <> Неопределено Тогда
		Настройки = НастройкиУсловия;
	КонецЕсли;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
КонецПроцедуры

// Открывает форму выбора/редактирования условия выполнения действия.
//
// Параметры:
//  ИмяДействия - Строка - выбранное имя действия в карте маршрута.
//  РезультатВыполнения - ПеречислениеСсылка.РезультатыВыполненияДействийКомплексныхПроцессов - результат выполнения действия.
//  ОписаниеОповещения - ОписаниеОповещения - описание обработчика,
//                       который следует выполнить после закрытия формы.
//
&НаКлиенте
Процедура ВыбратьУсловиеВыполненияДействия(
	ИмяДействия = Неопределено,
	РезультатВыполнения = Неопределено,
	ОписаниеОповещения)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяДействия", ИмяДействия);
	ПараметрыФормы.Вставить("РезультатВыполнения", РезультатВыполнения);
	ПараметрыФормы.Вставить("Действия", Действия);
	ПараметрыФормы.Вставить("РезультатыВыполненияДействий", РезультатыВыполненияДействий);
	
	ОткрытьФорму(
		"Справочник.СхемыКомплексныхПроцессов.Форма.ВыборРезультаВыполненияДействия",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму выбора/редактирования условия маршрутизации.
//
// Параметры:
//  ИмяПредмета - СправочникСсылка.ИменаПредметов - выбранное имя предмета.
//  Условие - СправочникСсылка.УсловияМаршрутизации - выбранное условие.
//  ОписаниеОповещения - ОписаниеОповещения - описание обработчика,
//                       который следует выполнить после закрытия формы.
//
&НаКлиенте
Процедура ВыбратьУсловиеПоПредмету(
	ИмяПредмета = Неопределено,
	Условие = Неопределено,
	ОписаниеОповещения)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяПредмета", ИмяПредмета);
	ПараметрыФормы.Вставить("Условие", Условие);
	ПараметрыФормы.Вставить("Предметы", Предметы);
	
	ОткрытьФорму(
		"Справочник.СхемыКомплексныхПроцессов.Форма.ВыборУсловияМаршрутизации",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму редактирования выражения на встроенном языке.
//
// Параметры:
//  Наименование - Строка - наименование условия.
//  Выражение - Строка - выражение на встроенном языке.
//  ОписаниеОповещения - ОписаниеОповещения - описание обработчика,
//                       который следует выполнить после закрытия формы.
//
&НаКлиенте
Процедура РедактироватьВыражениеНаВстроенномЯзыке(
	Наименование = Неопределено,
	Выражение = Неопределено,
	ОписаниеОповещения)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Наименование", Наименование);
	ПараметрыФормы.Вставить("ИдентификаторСкрипта", Выражение);
	ПараметрыФормы.Вставить("ПоказыватьОбластьПроверки", Истина);
	ПараметрыФормы.Вставить("Схема", Параметры.Схема);
	ПараметрыФормы.Вставить("СкриптПоУмолчанию", "Результат = Истина;");
	
	ОткрытьФорму(
		"Справочник.СхемыКомплексныхПроцессов.Форма.РедактированиеСкриптаСхемы",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Добавляет условие в отбор компоновщика.
//
// Параметры:
//  ПутьКДанным - Строка - путь к данным, на которые накладывается условие в компоновщике.
//  Условие - УникальныйИдентификатор, Структура - идентификатор выражения на встроенном языке,
//                                                 структура условия маршрутизации
//                                                 или структура результата выполнения действия.
//  ПредставлениеУсловия - Строка - представление условия в компоновщике. 
//
&НаКлиенте
Процедура ДобавитьУсловиеВКомпоновщик(ПутьКДанным, Условие)
	
	КоллекцияЭлементовОтбора = Компоновщик.Настройки.Отбор.Элементы;
	
	ТекущийЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	
	Если ТипЗнч(ТекущийЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		КоллекцияЭлементовОтбора = ТекущийЭлементОтбора.Элементы;
	ИначеЕсли ТипЗнч(ТекущийЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
		И ТекущийЭлементОтбора.Родитель <> Неопределено Тогда
		
		КоллекцияЭлементовОтбора = ТекущийЭлементОтбора.Родитель.Элементы;
	КонецЕсли;
	
	НовыйЭлемент = ДобавитьУсловиеВЭлементыОтбораКомпоновщика(
		КоллекцияЭлементовОтбора, ПутьКДанным, Условие);
	
	Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока = 
		Компоновщик.Настройки.Отбор.ПолучитьИдентификаторПоОбъекту(НовыйЭлемент);
	
	ЗаполнитьПредставленияУсловийКомпоновщика();
	
КонецПроцедуры

// Добавляет условие в элементы отбора компоновщика.
// В качестве результата возвращает новый элемент отбора.
//
// Параметры:
//  ЭлементыОтбора - КоллекцияЭлементовОтбораКомпоновкиДанных - элементы отбора.
//  ПутьКДанным - Строка - путь к данным поля компоновки с условием.
//  Условие - Произвольный - правое значение условия.
//
&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьУсловиеВЭлементыОтбораКомпоновщика(ЭлементыОтбора, ПутьКДанным, Условие)
	
	НовыйЭлемент = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКДанным);
	НовыйЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйЭлемент.ПравоеЗначение = Условие;
	
	Возврат НовыйЭлемент;
	
КонецФункции

// Возвращает настройки копомоновщика по таблице предметов.
//
// Параметры:
//  Предметы - ДанныеФормыКоллекция - таблица с предметами (см. реквизит формы Предметы)
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы для размещения
//                                                 схемы компоновки данных во временном хранилище.
//
// Возвращаемое значение:
//  НастройкиКомпоновкиДанных - настройки условия
//
&НаСервереБезКонтекста
Функция НастройкиУсловияПоПредметам(Знач Предметы, ИдентификаторФормы)
	
	// Инициализируем компоновщик настроек
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, ИдентификаторФормы);
	
	// Заполняем настройки компоновщика условиями по таблице Предметы
	Для Каждого СтрокаТаблицы Из Предметы Цикл
		
		Если Не СтрокаТаблицы.ИспользоватьВУсловии Тогда
			Продолжить;
		КонецЕсли;
		
		Условие = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.
			СтруктураУсловияПоПредметуДляЭлементаОтбораКомпоновкиДанных(
				СтрокаТаблицы.УсловиеМаршрутизации, СтрокаТаблицы.ИмяПредмета);
		
		ДобавитьУсловиеВЭлементыОтбораКомпоновщика(
			КомпоновщикНастроек.Настройки.Отбор.Элементы, "УсловиеПоПредметам", Условие);
		
	КонецЦикла;
	
	// Возвращаем настройки компоновщика
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

// Возвращает настройки копомоновщика по таблице действий.
//
// Параметры:
//  Действия - ДанныеФормыКоллекция - таблица с действиями (см. реквизит формы Действия)
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы для размещения
//                                                 схемы компоновки данных во временном хранилище.
//
// Возвращаемое значение:
//  НастройкиКомпоновкиДанных - настройки условия
//
&НаСервереБезКонтекста
Функция НастройкиУсловияПоДействиям(Знач Действия, ИдентификаторФормы)
	
	// Инициализируем компоновщик настроек
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, ИдентификаторФормы);
	
	// Заполняем настройки компоновщика условиями по таблице Действия
	Для Каждого СтрокаТаблицы Из Действия Цикл
		
		Если Не СтрокаТаблицы.ИспользоватьВУсловии Тогда
			Продолжить;
		КонецЕсли;
		
		Условие = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.
			СтруктураУсловияВыполненияДляЭлементаОтбораКомпоновкиДанных(
				СтрокаТаблицы.РезультатВыполнения, СтрокаТаблицы.Имя);
		
		ДобавитьУсловиеВЭлементыОтбораКомпоновщика(
			КомпоновщикНастроек.Настройки.Отбор.Элементы,
			"УсловиеПоРезультатамВыполненияДействий",
			Условие);
		
	КонецЦикла;
	
	// Возвращаем настройки компоновщика
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

// Возвращает настройки расширенного условия
//
// Параметры:
//  Компоновщик - КомпоновщикНастроекКомпоновкиДанных - Компоновщик
//
// Возвращаемое значение:
//  НастройкиКомпоновкиДанных - настройки условия.
//
&НаСервереБезКонтекста
Функция НастройкиРасширенногоУсловия(Компоновщик)
	
	НастройкиУсловия = Компоновщик.ПолучитьНастройки();
	
	Возврат НастройкиУсловия;
	
КонецФункции

// Заполняет представление условий в компоновщике.
//
&НаКлиенте
Процедура ЗаполнитьПредставленияУсловийКомпоновщика()
	
	Если ТипУсловия <> ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.РасширенноеУсловие") Тогда
		
		Возврат;
	КонецЕсли;
	
	Условия = Новый Массив;
	
	ПолучитьУсловияКомпоновщика(Компоновщик.Настройки.Отбор.Элементы, Условия);
	
	ПолеУсловиеПоПредметам = Новый ПолеКомпоновкиДанных("УсловиеПоПредметам");
	ПолеУсловиеПоРезультатамВыполненияДействий = 
		Новый ПолеКомпоновкиДанных("УсловиеПоРезультатамВыполненияДействий");
	ПолеВыражениеНаВстроенномЯзыке = Новый ПолеКомпоновкиДанных("ВыражениеНаВстроенномЯзыке");
	
	Для Каждого СтрокаУсловия Из Условия Цикл
		
		Если СтрокаУсловия.ЛевоеЗначение = ПолеУсловиеПоПредметам Тогда
			
			СтрокаУсловия.Представление = ПредставлениеПредмета(СтрокаУсловия.ПравоеЗначение.ИмяПредмета)
				+ " - "
				+ Строка(СтрокаУсловия.ПравоеЗначение.Условие);
			
		ИначеЕсли СтрокаУсловия.ЛевоеЗначение = ПолеУсловиеПоРезультатамВыполненияДействий Тогда
			
			СтрокаУсловия.Представление = ПредставлениеДействия(СтрокаУсловия.ПравоеЗначение.Действие)
				+ " - "
				+ ПредставлениеРезультатаВыполненияДействия(
					СтрокаУсловия.ПравоеЗначение.Действие,
					СтрокаУсловия.ПравоеЗначение.РезультатВыполнения);
			
		ИначеЕсли СтрокаУсловия.ЛевоеЗначение = ПолеВыражениеНаВстроенномЯзыке Тогда
			
			СтрокаУсловия.Представление = СтрокаУсловия.ПравоеЗначение.Наименование;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Очищает представление условий в компоновщике.
//
&НаКлиенте
Процедура ОчиститьПредставленияУсловийКомпоновщика()
	
	Если ТипУсловия <> ПредопределенноеЗначение(
		"Перечисление.ТипыУсловийКомплексныхПроцессов.РасширенноеУсловие") Тогда
		
		Возврат;
	КонецЕсли;
	
	Условия = Новый Массив;
	ПолучитьУсловияКомпоновщика(Компоновщик.Настройки.Отбор.Элементы, Условия);
	Для Каждого СтрокаУсловия Из Условия Цикл
		СтрокаУсловия.Представление = "";
	КонецЦикла;
	
КонецПроцедуры

// Получает все условия компоновщика.
//
// Рекурсивная процедура.
//
// Параметры:
//  ЭлементыОтбораКомпоновщика - КоллекцияЭлементовОтбораКомпоновкиДанных - элементы отбора.
//  Условия - Массив - в этот параметр помещаются все условия.
//
&НаКлиенте
Процедура ПолучитьУсловияКомпоновщика(ЭлементыОтбораКомпоновщика, Условия)
	
	Для Каждого ЭлементОтбора Из ЭлементыОтбораКомпоновщика Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Условия.Добавить(ЭлементОтбора);
		Иначе
			ПолучитьУсловияКомпоновщика(ЭлементОтбора.Элементы, Условия);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает представление действия
//
// Параметры:
//  ИмяДействия - Строка - имя действия в схеме процесса.
//
// Возвращаемое значение:
//  Строка
//
&НаКлиенте
Функция ПредставлениеДействия(ИмяДействия)
	
	ОписаниеДействия = ИмяДействия;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Имя", ИмяДействия);
	
	СтрокиТаблицыДействий = Действия.НайтиСтроки(Отбор);
	
	Если СтрокиТаблицыДействий.Количество() > 0 Тогда
		ОписаниеДействия = СтрокиТаблицыДействий[0].Описание;
	КонецЕсли;
	
	Возврат ОписаниеДействия;
	
КонецФункции

// Возвращает представление предмета
//
// Параметры:
//  ИмяПредмета - СправочникСсылка.ИменаПредметов - имя предмета в процессе.
//
// Возвращаемое значение:
//  Строка
//
&НаКлиенте
Функция ПредставлениеПредмета(ИмяПредмета)
	
	ОписаниеПредмета = ИмяПредмета;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПредмета", ИмяПредмета);
	
	СтрокиТаблицыПредметы = Предметы.НайтиСтроки(Отбор);
	
	Если СтрокиТаблицыПредметы.Количество() > 0 Тогда
		ОписаниеПредмета = СтрокиТаблицыПредметы[0].Описание;
	КонецЕсли;
	
	Возврат ОписаниеПредмета;
	
КонецФункции

// Возвращает представление результата выполнения
//
// Параметры:
//  ИмяДействия - Строка - имя действия в схеме процесса.
//  РезультатВыполнения - Перечисления.РезультатыВыполненияДействийКомплексныхПроцессов - 
//                        результат выполнения действия.
//
// Возвращаемое значение:
//  Строка
//
&НаКлиенте
Функция ПредставлениеРезультатаВыполненияДействия(ИмяДействия, РезультатВыполнения)
	
	ВозможныеРезультатыВыполнения = РезультатыВыполненияДействий[ИмяДействия];
	
	Представление = ВозможныеРезультатыВыполнения.НайтиПоЗначению(РезультатВыполнения).Представление;
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Представление = Строка(РезультатВыполнения);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти
