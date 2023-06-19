
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение реквизитов.
	Если Параметры.Свойство("ЗначениеКопирования")
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда 
		СведенияПользователей = РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(
			Новый Структура("Пользователь", Параметры.ЗначениеКопирования));
		Подразделение = СведенияПользователей.Подразделение;
		Должность = СведенияПользователей.Должность;
		ГрафикРаботы = СведенияПользователей.ГрафикРаботы;
		Ранг = СведенияПользователей.Ранг;
	ИначеЕсли ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		Подразделение = Параметры.Подразделение;
	Иначе
		СведенияПользователей = РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(
			Новый Структура("Пользователь", Объект.Ссылка));
		Подразделение = СведенияПользователей.Подразделение;
		Должность = СведенияПользователей.Должность;
		ГрафикРаботы = СведенияПользователей.ГрафикРаботы;
		Ранг = СведенияПользователей.Ранг;
	КонецЕсли;
	
	ДоступноИзменениеПользователей = ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ()
		Или РольДоступна("ДобавлениеИзменениеПользователей");
	ДоступноИзменениеТекущегоПользователя = ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ()
		Или РольДоступна("ИзменениеТекущегоПользователя");
	РазрешеноРедактировать = ДоступноИзменениеПользователей
		Или (ДоступноИзменениеТекущегоПользователя 
			И Объект.Ссылка = ПользователиКлиентСервер.ТекущийПользователь());
	
	Если Ранг = 0 Тогда 
		Элементы.РангЗаголовок.Видимость = Ложь;
		Элементы.РангЗначение.Видимость = Ложь;
	Иначе 
		Элементы.РангЗначение.Картинка = БиблиотекаКартинок["Ранг" + СокрЛП(Ранг)];
		Элементы.РангЗначение.Ширина =  Ранг + 2;
	КонецЕсли;
	
	Элементы.Наименование.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.ПредставлениеВДокументах.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.ПредставлениеВПереписке.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.Подразделение.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.Должность.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.ГрафикРаботы.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	Элементы.ПомещениеТекст.ТолькоПросмотр = Не ДоступноИзменениеПользователей;
	
	ОбновитьОтсутствие();
	
	Руководитель = ДелопроизводствоКлиентСервер.ПолучитьНепосредственногоРуководителя(
		Подразделение, Объект.Ссылка);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСхемыПомещений")
		И ЗначениеЗаполнено(Объект.Помещение) Тогда
		ПомещениеТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(
			Объект.Помещение);
	КонецЕсли;
	
	Если Не РазрешеноРедактировать Тогда 
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		Элементы.ФормаЗакрыть.Видимость = Истина;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
		Элементы.ГруппаДополнительныеРеквизиты.ТолькоПросмотр = Истина;
		ЭтаФорма.ТекущийЭлемент = Элементы.Наименование;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// СтандартныеПодсистемы.Свойства
	
	Если Не ДоступноИзменениеПользователей Тогда
		Элементы.Подразделение.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Подразделение.Гиперссылка = Истина;
		Элементы.Должность.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Должность.Гиперссылка = Истина;
		Элементы.ГрафикРаботы.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.ГрафикРаботы.Гиперссылка = Истина;
		Элементы.Руководитель.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Руководитель.Гиперссылка = Истина;
	КонецЕсли;
	
	ПоказатьКонтактнуюИнформацию();
	
	Элементы.ЧасовойПоясПредставление.Видимость = ЗначениеЗаполнено(ЧасовойПоясПредставление);
	
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	МК_НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ТекущийЭлемент = Элементы.КонтактнаяИнформацияHTML;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОтображатьФотографииПерсональнаяНастройка =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ОтображатьФотографииПерсональнаяНастройка",
		Истина);
		
	ДоступноИзменениеПользователей = ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ()
		Или РольДоступна("ДобавлениеИзменениеПользователей");
	ДоступноИзменениеТекущегоПользователя = ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ()
		Или РольДоступна("ИзменениеТекущегоПользователя");
	РазрешеноРедактировать = ДоступноИзменениеПользователей
		Или (ДоступноИзменениеТекущегоПользователя 
			И Объект.Ссылка = ПользователиКлиентСервер.ТекущийПользователь());
	
	ОтображатьФотографииОбщаяНастройка = ПолучитьФункциональнуюОпцию("ОтображатьФотографииОбщаяНастройка");	
	
	ПолучатьФотографии = Истина;
	
	Если Не ОтображатьФотографииОбщаяНастройка 
		Или Не ОтображатьФотографииПерсональнаяНастройка
		Или ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая Тогда
		ПолучатьФотографии = Ложь;
		Элементы.ГруппаСтраницыФотографии.Видимость = Ложь;
	КонецЕсли;
	
	Если ПолучатьФотографии Тогда
		ПоказатьФотоПользователя(Объект.Ссылка, УникальныйИдентификатор, Фотография);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ДоступноИзменениеПользователей Тогда
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	КонецЕсли;
	
	ЧасовойПоясПредставление = РаботаСЧасовымиПоясами.ПредставлениеЧасовогоПоясаПользователя(Объект.Ссылка);
	Элементы.ЧасовойПоясПредставление.Видимость = ЗначениеЗаполнено(ЧасовойПоясПредставление);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Отказ И ДоступноИзменениеПользователей Тогда
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.Свойства
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Запись подразделения и должности
	Сведения = Новый Структура;
	Сведения.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	Сведения.Вставить("Должность", Справочники.Должности.ПустаяСсылка());
	Сведения.Вставить("ГрафикРаботы", Справочники.ГрафикиРаботы.ПустаяСсылка());
	Сведения.Вставить("Ранг", 0);
	
	ЗаписьРегистра = РегистрыСведений.СведенияОПользователяхДокументооборот.СоздатьМенеджерЗаписи();
	ЗаписьРегистра.Пользователь = ТекущийОбъект.Ссылка;
	ЗаписьРегистра.Прочитать();
	
	ЕстьЗапись = ЗаписьРегистра.Выбран();
	Если ЕстьЗапись Тогда
		ЗаполнитьЗначенияСвойств(Сведения, ЗаписьРегистра);
	КонецЕсли;
	
	Если Сведения.Подразделение <> Подразделение
		Или Сведения.Должность <> Должность 
		Или Сведения.ГрафикРаботы <> ГрафикРаботы
		Или Сведения.Ранг <> Ранг Тогда
		
		Набор = РегистрыСведений.СведенияОПользователяхДокументооборот.СоздатьНаборЗаписей();
		Набор.Отбор.Пользователь.Установить(ТекущийОбъект.Ссылка);
		
		Если ЗначениеЗаполнено(Подразделение) Тогда
			
			НоваяЗапись = Набор.Добавить();
			НоваяЗапись.Пользователь = ТекущийОбъект.Ссылка;
			НоваяЗапись.Подразделение = Подразделение;
			НоваяЗапись.Должность = Должность;
			НоваяЗапись.ГрафикРаботы = ГрафикРаботы;
			НоваяЗапись.Ранг = Ранг;
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		Набор.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Если ДоступноИзменениеПользователей Тогда
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ДоступноИзменениеПользователей Тогда
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
		// Конец СтандартныеПодсистемы.Свойства
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Отсутствие" И Параметр.Сотрудник = Объект.Ссылка Тогда
		ОбновитьОтсутствие();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	НельзяМенятьПоляСведений = Не ЗначениеЗаполнено(Подразделение);
	Элементы.Должность.ТолькоПросмотр = НельзяМенятьПоляСведений;
	
	Если НельзяМенятьПоляСведений Тогда 
		Руководитель = Неопределено;
	Иначе 
		Руководитель = ДелопроизводствоКлиентСервер.ПолучитьНепосредственногоРуководителя(
			Подразделение, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтсутствиеОписаниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Отсутствие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) <> "v8doc:" Тогда 
		Возврат;
	КонецЕсли;	
	НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
	
	ПараметрыНажатия = Новый Структура;
	ПараметрыНажатия.Вставить("Элемент", Элемент);
	ПараметрыНажатия.Вставить("ЭтаФорма", ЭтаФорма);
	ПараметрыНажатия.Вставить("Объект", Объект.Ссылка);
	
	ДелопроизводствоКлиент.ОбработатьНажатиеНаПолеОбзор(Объект,
		НавигационнаяСсылкаПоля, ПараметрыНажатия);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если РазрешеноРедактировать Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		ДобавитьИзображениеНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

// Работа с помещением

&НаКлиенте
Процедура ПомещениеТекстПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПомещениеТекст) Тогда 
		Объект.Помещение = Неопределено;
		ПомещениеТекст = Неопределено;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.Помещение);
	ОткрытьФорму("Справочник.ТерриторииИПомещения.ФормаВыбора", ПараметрыФормы, 
		Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Помещение = Неопределено;
	ПомещениеТекст = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПомещениеТекст) Тогда
		ПоказатьЗначение(, Объект.Помещение);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда 
		
		СтандартнаяОбработка = Ложь;
		Объект.Помещение = ВыбранноеЗначение;
		Модифицированность = Истина;
		
		Если ЗначениеЗаполнено(Объект.Помещение) Тогда 
			ПомещениеТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(
				Объект.Помещение);
		Иначе 
			ПомещениеТекст = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПомещения(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПомещения(Текст);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	РаботаСФотографиями.ОчиститьИзображение(Объект.Ссылка, УникальныйИдентификатор);
	
	ЕстьКартинка = Ложь;
	Элементы.Фотография.Гиперссылка = Не ЕстьКартинка;
	Элементы.АдресКартинкиКонтекстноеМенюДобавитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.АдресКартинкиКонтекстноеМенюОчиститьИзображение.Доступность = ЕстьКартинка;
	Прочитать();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПоказатьФотоПользователя(Контакт, УникальныйИдентификатор, Фотография)
	
	// фото пользователя
	Если ЭтоАдресВременногоХранилища(Фотография) Тогда
		УдалитьИзВременногоХранилища(Фотография);
	КонецЕсли;	
	
	Фотография = "";
	Если ЗначениеЗаполнено(Контакт) Тогда
		
		ЕстьКартинка = Ложь;
		Фотография = РаботаСФотографиями.ПолучитьАдресФото(Контакт, УникальныйИдентификатор, ЕстьКартинка);
		
	КонецЕсли;
	
	Если ЕстьКартинка Тогда
		ЭтаФорма.Элементы.ГруппаСтраницыФотографии.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаФотография;
	Иначе
		ЭтаФорма.Элементы.ГруппаСтраницыФотографии.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаКартинкаПоУмолчанию;
	КонецЕсли;
	
	Элементы.Фотография.Гиперссылка = Не ЕстьКартинка;
	
	Если РазрешеноРедактировать Тогда 
		Элементы.АдресКартинкиКонтекстноеМенюДобавитьИзображение.Доступность = Не ЕстьКартинка;
		Элементы.ДекорацияКартинкаПоУмолчаниюКонтекстноеМенюДобавитьИзображение.Доступность = Не ЕстьКартинка;
		Элементы.АдресКартинкиКонтекстноеМенюОчиститьИзображение.Доступность = ЕстьКартинка;
		Элементы.ДекорацияКартинкаПоУмолчанию.Гиперссылка = Истина;
	Иначе 
		Элементы.АдресКартинкиКонтекстноеМенюДобавитьИзображение.Доступность = Ложь;
		Элементы.ДекорацияКартинкаПоУмолчаниюКонтекстноеМенюДобавитьИзображение.Доступность = Ложь;
		Элементы.АдресКартинкиКонтекстноеМенюОчиститьИзображение.Доступность = Ложь;
		Элементы.ДекорацияКартинкаПоУмолчанию.Гиперссылка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	ПараметрыОписания = Новый Структура(
		"АдресВременногоХранилищаФайла", 
		"");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавитьИзображениеНаКлиентеЗавершение", 
		ЭтотОбъект,
		ПараметрыОписания);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru = 'Для выбора изображения необходимо записать объект. Записать?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Записать();
	Иначе 
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьКартинка И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыборКартинкиПродолжение",
			ЭтотОбъект,
			ДополнительныеПараметры);

		ФайловыеФункцииКлиент.ВыбратьКартинкуИПоместитьВХранилище(
			ОписаниеОповещения, УникальныйИдентификатор,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКартинкиПродолжение(Результат, Параметры) Экспорт 

	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФотографиями.ЗаписатьИзображение(Параметры.АдресВременногоХранилищаФайла, 
		УникальныйИдентификатор, 
		Объект.Ссылка,
		Объект.Наименование,
		Истина);

	ЕстьКартинка = Истина;
	Элементы.Фотография.Гиперссылка = Не ЕстьКартинка;
	Элементы.АдресКартинкиКонтекстноеМенюДобавитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.АдресКартинкиКонтекстноеМенюОчиститьИзображение.Доступность = ЕстьКартинка;
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтсутствие()
	
	Отсутствия.ОбновитьДанныеОтсутствияФормыПользователя(Объект.Ссылка, Отсутствие,
		ОтсутствиеОписание, Элементы.ГруппаОтсутствие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьКонтактнуюИнформацию()
	
	Если ДоступноИзменениеПользователей Тогда  
		// СтандартныеПодсистемы.КонтактнаяИнформация
		УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, 
			"КонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
		// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		Элементы.КонтактнаяИнформацияHTML.Видимость = Ложь;
	Иначе 
		КонтактнаяИнформацияHTML = ПолучитьHTMLКонтактнойИнформации(); 
		Элементы.КонтактнаяИнформацияHTML.Видимость = Истина;
		Элементы.ПомещениеТекст.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьHTMLКонтактнойИнформации()  
	
	HTMLТекст = "<html>
		|<head>
		|<style type=""text/css"">
		|	body {
		|		overflow:    auto;
		|		margin-top:  6px;  
		|		margin-left: 0px; 
		|		font-family: Arial; }
		|		font-size:   10pt;}
		|	table {
		|		width:       100%; 
		|		font-family: Arial; 
		|		font-size:   10pt;
		|	}
		|	td {vertical-align: top;}
		|		.even {padding: 7px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;} 
		|		.lc {border-bottom: 1px solid white; padding: 7px;}
		| 	a:link {
		|		color: #006699; text-decoration: none;}
		|	a:visited {
		|		color: #006699; text-decoration: none;}
		|	a:hover {
		|		color: #006699; text-decoration: underline;}
		|	p {
		|		margin-top: 8px;}
		|</style>
		|<body>";
	
	МассивТелефонов = Новый Массив;
	МассивМайлАдресов = Новый Массив;
	МассивПрочихКИ = Новый Массив;
	КонтактнаяИнформация = Объект.Ссылка.КонтактнаяИнформация.Выгрузить();
	
	Для Каждого КИ Из КонтактнаяИнформация Цикл 
		Если Не ЗначениеЗаполнено(КИ.Вид) Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КИ.Вид, "ПометкаУдаления") Тогда 
			Продолжить;
		КонецЕсли;
		
		Если КИ.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда 
			МассивМайлАдресов.Добавить(КИ);
		ИначеЕсли КИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда 
			МассивТелефонов.Добавить(КИ);
		Иначе 
			МассивПрочихКИ.Добавить(КИ);
		КонецЕсли;
	КонецЦикла;
	
	ИспользоватьГрафикиРаботы = ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы");
	Если ИспользоватьГрафикиРаботы Тогда 
		МинимальноеКоличествоСтрок = 1;
	Иначе 
		МинимальноеКоличествоСтрок = 0;
	КонецЕсли;
	
	КоличествоАдресов = МассивМайлАдресов.Количество();
	КоличествоТелефонов = МассивТелефонов.Количество();
	МаксимальноеКоличествоСтрок = Макс(МинимальноеКоличествоСтрок, КоличествоАдресов, КоличествоТелефонов);
	
	Если ИспользоватьГрафикиРаботы И КоличествоАдресов > 0 И КоличествоТелефонов > 0 Тогда 
		КоличествоКолонок = 3;
	ИначеЕсли (ИспользоватьГрафикиРаботы И (КоличествоАдресов > 0 Или КоличествоТелефонов > 0))
		Или (Не ИспользоватьГрафикиРаботы И КоличествоАдресов > 0 И КоличествоТелефонов > 0) Тогда 
		КоличествоКолонок = 2;
	ИначеЕсли ИспользоватьГрафикиРаботы Или КоличествоАдресов > 0 Или КоличествоТелефонов > 0 Тогда 
		КоличествоКолонок = 1;
	Иначе 
		КоличествоКолонок = 0;
	КонецЕсли;
	
	HTMLТекст = HTMLТекст + "<table>";
	
	// Контактная информация.
	Для Ит = 0 По МаксимальноеКоличествоСтрок - 1 Цикл 
		Телефон = ""; Емайл = "";
		Если Ит < КоличествоАдресов Тогда 
			Емайл = МассивМайлАдресов.Получить(Ит);
		КонецЕсли;
		
		Если Ит < КоличествоТелефонов Тогда 
			Телефон = МассивТелефонов.Получить(Ит);
		КонецЕсли;
		
		HTMLТекст = HTMLТекст + "<tr align=""left"">";
		
		Если ЗначениеЗаполнено(Емайл) Тогда
			HTMLТекст = HTMLТекст + "<td class=""even""; width=""30%"">";
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.НепрочтенноеПисьмо,, Емайл.Вид);
			HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<A href=v8doc:%1>%2</A><BR>",
				"message" + Емайл.Представление, Емайл.Представление);
			HTMLТекст = HTMLТекст + "</td>";
		ИначеЕсли КоличествоАдресов > 0 Тогда 
			HTMLТекст = HTMLТекст + "<td class=""lc""; width=""30%"">";
			HTMLТекст = HTMLТекст + "&nbsp;";
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		Если КоличествоАдресов > 0 Тогда
			HTMLТекст = HTMLТекст + "<td class=""lc""; width=""2%"">";
			HTMLТекст = HTMLТекст + "&nbsp;";
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Телефон) Тогда
			HTMLТекст = HTMLТекст + "<td class=""even""; width=""30%"">";
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.Телефон16,, Телефон.Вид);
			ОбзорОбъектовКлиентСервер.ДобавитьРеквизит(HTMLТекст, "", Телефон.Представление);
			HTMLТекст = HTMLТекст + "</td>";
		ИначеЕсли КоличествоТелефонов > 0 Тогда 
			HTMLТекст = HTMLТекст + "<td class=""lc""; width=""30%"">";
			HTMLТекст = HTMLТекст + "&nbsp;";
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		Если КоличествоТелефонов > 0 Тогда
			HTMLТекст = HTMLТекст + "<td class=""lc""; width=""2%"">";
			HTMLТекст = HTMLТекст + "&nbsp;";
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		Если Ит = 0 И ИспользоватьГрафикиРаботы Тогда 
			HTMLТекст = HTMLТекст + "<td class=""even""; width=""30%"">";
			ДобавитьКартинку(HTMLТекст, БиблиотекаКартинок.КалендарьПользователя);
			HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"<A href=v8doc:%1>%2</A><BR>",
					"calendar", НСтр("ru = 'Календарь сотрудника'"));
			HTMLТекст = HTMLТекст + "</td>";
		ИначеЕсли ИспользоватьГрафикиРаботы Тогда 
			HTMLТекст = HTMLТекст + "<td class=""lc""; width=""30%"">";
			HTMLТекст = HTMLТекст + "&nbsp;";
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		HTMLТекст = HTMLТекст + "<td class=""lc""; width=""2%"">";
		HTMLТекст = HTMLТекст + "&nbsp;";
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
	КонецЦикла;
	HTMLТекст = HTMLТекст + "</table>";
	
	HTMLТекст = HTMLТекст + "<table>";
	
	Если КоличествоКолонок = 1 Тогда 
		HTMLТекст = СтрЗаменить(HTMLТекст, "class=""even""", "class=""lc""");
		HTMLТекст = СтрЗаменить(HTMLТекст, "padding: 7px;", "padding: 2px;");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСхемыПомещений")
		И ЗначениеЗаполнено(ПомещениеТекст) Тогда
		HTMLТекст = HTMLТекст + "<tr align=""left"">";
		HTMLТекст = HTMLТекст + "<td colspan=""3"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Помещение:'"));
		HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<A href=v8doc:%1>%2</A><BR>",
				"room", ПомещениеТекст);
		HTMLТекст = HTMLТекст + "</td>";
		HTMLТекст = HTMLТекст + "</tr>";
	КонецЕсли;
	
	Для Каждого КИ Из МассивПрочихКИ Цикл 
		Если ЗначениеЗаполнено(КИ) Тогда
			HTMLТекст = HTMLТекст + "<tr align=""left"">";
			HTMLТекст = HTMLТекст + "<td colspan=""3"">";
			
			Если КИ.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда 
				ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, СокрЛП(КИ.Вид) + ":");
				HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"<A href=v8doc:%1>%2</A><BR>",
					"site" + КИ.Представление, КИ.Представление);
			Иначе 
				ОбзорОбъектовКлиентСервер.ДобавитьРеквизит(HTMLТекст, СокрЛП(КИ.Вид) + ":", КИ.Представление);
			КонецЕсли;
			
			HTMLТекст = HTMLТекст + "</td>";
			HTMLТекст = HTMLТекст + "</tr>";
			
			МаксимальноеКоличествоСтрок = МаксимальноеКоличествоСтрок + 1;
		КонецЕсли;
	КонецЦикла;
	
	HTMLТекст = HTMLТекст + "</table>";
	HTMLТекст = HTMLТекст + "</body></html>";
	
	ОбзорОбъектовКлиентСервер.УдалитьВредоносныйКодИзТекста(HTMLТекст);
	
	Если МаксимальноеКоличествоСтрок > 4 Тогда 
		Элементы.КонтактнаяИнформацияHTML.Высота = МаксимальноеКоличествоСтрок + 4;
	КонецЕсли;
	
	Возврат HTMLТекст;
	
КонецФункции

&НаСервере
Процедура ДобавитьКартинку(HTMLТекст, Картинка, Ссылка = "", Подсказка = "") 
	
	ДвоичныеДанныеКартинки = Картинка.ПолучитьДвоичныеДанные();
	Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "<a href=v8doc:"+Ссылка+">";
	КонецЕсли;
	
	HTMLТекст = HTMLТекст
		+ "<img src='data:image/"
		+ Картинка.Формат()
		+ ";base64,"
		+ Base64ДанныеКартинки
		+ "' title='"
		+ Подсказка
		+ "' align='absmiddle' style='margin-right:5px' border='0' >";
		
	Если ЗначениеЗаполнено(Ссылка) Тогда
		HTMLТекст = HTMLТекст + "</a>";
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	МК_ВыровнятьЭлементФормы(Элементы.Наименование);
	МК_ВыровнятьЭлементФормы(Элементы.ПредставлениеВДокументах);
	МК_ВыровнятьЭлементФормы(Элементы.ПредставлениеВПереписке);
	МК_ВыровнятьЭлементФормы(Элементы.Подразделение);
	МК_ВыровнятьЭлементФормы(Элементы.Руководитель);
	
	Элементы.ГруппаОтсутствие.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	Элементы.ОтсутствиеКартинкаПредупреждения.Ширина = 4;
	Элементы.ОтсутствиеКартинкаПредупреждения.Высота = 2;
	
	Элементы.Переместить(Элементы.ГруппаФото, Элементы.ГруппаОсновныеИФото, Элементы.ГруппаОсновные);

	Элементы.ГруппаСтраницыФотографии.РастягиватьПоГоризонтали = Истина;
	Элементы.СтраницаФотография.РастягиватьПоГоризонтали = Истина;
	Элементы.СтраницаКартинкаПоУмолчанию.РастягиватьПоГоризонтали = Истина;
	
	Элементы.СтраницаФотография.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Центр;
	Элементы.СтраницаКартинкаПоУмолчанию.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Центр;
	
	Элементы.СтраницаФотография.ЦветФона = ЦветаСтиля.МК_ЦветФонаГруппы;
	Элементы.СтраницаКартинкаПоУмолчанию.ЦветФона = ЦветаСтиля.МК_ЦветФонаГруппы;
	
	МобильныйКлиентКлиентСервер.АдаптироватьHtmlПодЭкранПриНеобходимости(КонтактнаяИнформацияHTML);

КонецПроцедуры

&НаСервере
Процедура МК_ВыровнятьЭлементФормы(Элемент)
	
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	Элемент.РастягиватьПоГоризонтали = Истина;
	
КонецПроцедуры

#КонецОбласти
