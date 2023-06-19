///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейВызовСервера.
//
// Серверные процедуры и функции Интернет-поддержки пользователей:
//  - определение доступности подключения;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, доступно ли текущему пользователю выполнение подключения
// Интернет-поддержки: авторизация/регистрация пользователя, регистрация
// программного продукта в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//  Булево - Истина - подключение Интернет-поддержки доступно,
//           Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Тарификация

// См. ИнтернетПоддержкаПользователей.УслугаПодключена.
//
Функция УслугаПодключена(Знач ИдентификаторУслуги, Знач ЗначениеРазделителя = Неопределено) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.УслугаПодключена(ИдентификаторУслуги, ЗначениеРазделителя);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиПрограммы

// Обработка события отключения Интернет-поддержки пользователей.
//
Процедура ВыйтиИзИПП() Экспорт
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для записи данных аутентификации Интернет-поддержки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(Неопределено);
	
КонецПроцедуры

// Возвращает значение функциональной опции "ОтправлятьПисьмаВФорматеHTML"
//
// Возвращаемое значение:
//  Булево - признак использования функциональной опции "ОтправлятьПисьмаВФорматеHTML".
//
Функция ОтправлятьПисьмаВФорматеHTML() Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ОтправлятьПисьмаВФорматеHTML();
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

// См. ИнтернетПоддержкаПользователей.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта.
//
Функция СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(Знач URLСтраницыСайта) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(URLСтраницыСайта);
	
КонецФункции

// Выполнить стандартные действия перед началом работы пользователя
// с областью данных, либо в локальном режиме работы.
//
// Параметры:
//  ПараметрыКлиента - Структура - параметры клиентского приложения.
//
// Возвращаемое значение:
//  Структура - результат определения параметров приложения.
//
Функция ПередНачаломРаботыСистемы(Знач ПараметрыКлиента) Экспорт
	
	Результат = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.ПараметрыКлиентаНаСервереБИП = Новый ФиксированнаяСтруктура(ПараметрыКлиента);
	УстановитьПривилегированныйРежим(Ложь);
	
	КлиентЛицензирования.ПередНачаломРаботыСистемы();
	Результат.Вставить("ДоступнаРаботаСНастройкамиКлиентаЛицензирования",
		ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования());
	
	Возврат Результат;
	
КонецФункции

// См. ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML
//
Функция ФорматированнаяСтрокаИзHTML(Знач ТекстСообщения) Экспорт
	
	Возврат ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		ТекстСообщения);
	
КонецФункции

// Записывает в журнал регистрации описание ошибки
// с именем события "Интернет-поддержка пользователей.Ошибка".
//
// Параметры:
//  Сообщение - Строка - строковое представление ошибки.
//  Данные - Произвольный - данные, к которым относится сообщение об ошибке;
//  Ошибка - Булево - определяет уровень журнала регистрации.
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(
		СообщениеОбОшибке,
		Данные = Неопределено,
		Ошибка = Истина) Экспорт
	
	ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
		СообщениеОбОшибке,
		Данные,
		Ошибка);
	
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

Функция ОтправитьДанныеСообщенияВТехПоддержку(
	Знач Тема,
	Знач Сообщение,
	Знач Получатель,
	Знач Вложения,
	Знач ДопПараметры) Экспорт
	
	// Извлечение данных из временного хранилища.
	Если Вложения <> Неопределено Тогда
		Для каждого ТекВложение Из Вложения Цикл
			Если ТекВложение.Свойство("Адрес") Тогда
				ДДФайла = ПолучитьИзВременногоХранилища(ТекВложение.Адрес);
				ТекВложение.Вставить(
					"Текст",
					ИнтернетПоддержкаПользователей.ТекстВДвоичныхДанных(ДДФайла));
				ТекВложение.Удалить("Адрес");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	Результат = ИнтернетПоддержкаПользователей.ОтправитьДанныеСообщенияВТехПоддержку(
		Тема,
		Сообщение,
		Получатель,
		Вложения,
		НастройкиСоединенияССерверами,
		ДопПараметрыОтправкиСообщения(ДопПараметры));
	
	Результат.Вставить("Предупреждение", "");
	
	Если ПустаяСтрока(Результат.КодОшибки) Тогда
		ЗаполнитьПараметрыСтраницыОтправкиСообщенияВТехПоддержку(Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция URLСтраницыОтправкиСообщенияВТехПоддержку(Домен, ТокенДанных)

	Возврат "https://"
		+ ИнтернетПоддержкаПользователей.ХостСервисовТехническойПоддержки(Домен)
		+ "/confirm?uuid=" + ТокенДанных;

КонецФункции

Процедура ЗаполнитьПараметрыСтраницыОтправкиСообщенияВТехПоддержку(ПараметрыСообщения)
	
	НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	ПараметрыСообщения.Вставить("URLСтраницы", "");
	ПараметрыСообщения.URLСтраницы = URLСтраницыОтправкиСообщенияВТехПоддержку(
		НастройкиСоединенияССерверами.ДоменРасположенияСерверовИПП,
		ПараметрыСообщения.ТокенДанных);
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		РезультатПолученияТикета =
			ИнтернетПоддержкаПользователей.ТикетАутентификацииНаПорталеПоддержки(ПараметрыСообщения.URLСтраницы);
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ЗначениеЗаполнено(РезультатПолученияТикета.Тикет) Тогда
			ПараметрыСообщения.URLСтраницы = ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				"/ticket/auth?token=" + РезультатПолученияТикета.Тикет,
				НастройкиСоединенияССерверами);
		Иначе
			Если РезультатПолученияТикета.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
				ПараметрыСообщения.Предупреждение = НСтр("ru = 'Ошибка входа на Портал 1С:ИТС.
					|Подробнее см. в журнале регистрации.'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДопПараметрыОтправкиСообщения(Знач ДопПараметры)
	
	Результат = Новый Структура;
	Результат.Вставить("Логин"         , "");
	Результат.Вставить("ПарольЗаполнен", Ложь);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	Если ДанныеАутентификации <> Неопределено Тогда
		Результат.Логин = ДанныеАутентификации.Логин;
		Результат.ПарольЗаполнен = ЗначениеЗаполнено(ДанныеАутентификации.Пароль);
	КонецЕсли;
	
	Результат.Вставить("ШаблонТекстаСообщения", ШаблонТекстаСообщения(ДопПараметры));
	
	Вложения = Новый Массив;
	Вложения.Добавить(
		Новый Структура(
			"Представление, Текст",
			НСтр("ru = 'Техническая информация.txt'"),
			ТекстВложенияТехническаяИнформация(
				ДопПараметры.ВидПриложения,
				Результат)));
	
	Результат.Вставить("Вложения", Вложения);
	
	Возврат Результат;
	
КонецФункции

Функция ШаблонТекстаСообщения(ДопПараметры)
	
	Возврат НСтр("ru = 'Здравствуйте!
			|
			|%msgtxt
			|
			|Регистрационный номер программного продукта: <Укажите рег. номер>;
			|Организация: <Укажите название организации>;
			|ИНН организации: <Укажите ИНН организации>.
			|С уважением,
			|.'");
	
КонецФункции

// Возвращает текст описания технических параметров программы.
Функция ТекстВложенияТехническаяИнформация(ВидПриложения, ДопПараметры)
	
	// Общие технические параметры и информация о сеансе
	СистИнфо = Новый СистемнаяИнформация;
	ЭтоФайловаяИБ = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ИмяПрограммы = Строка(ИнтернетПоддержкаПользователей.СлужебнаяИмяПрограммы());
	Если ИмяПрограммы = "Unknown" Тогда
		ИмяПрограммы = НСтр("ru = '<Не заполнено>'");
	КонецЕсли;
	
	// Общая информация:
	Результат = НСтр("ru = 'Техническая информация о программе:
		|Название программы: %1
		|Имя программы: %2;
		|Версия программы: %3;
		|Поставщик: %4;
		|Версия Платформы 1С:Предприятие: %5;
		|Версия Библиотеки Интернет-поддержки: %6;
		|Версия Библиотеки стандартных подсистем: %7;
		|Вид приложения: %8;
		|Режим: %9;'");
	
	Результат = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Результат,
			Метаданные.Синоним,
			ИмяПрограммы
				+ " (" + Строка(ИнтернетПоддержкаПользователей.ИмяКонфигурации()) + ")",
			Строка(ИнтернетПоддержкаПользователей.ВерсияКонфигурации()),
			Метаданные.Поставщик,
			Строка(СистИнфо.ВерсияПриложения),
			ИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки(),
			СтандартныеПодсистемыСервер.ВерсияБиблиотеки(),
			ВидПриложения,
			?(ЭтоФайловаяИБ, НСтр("ru = 'Файловый'"), НСтр("ru = 'Серверный'")));
	
	// Права:
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Полные права: %1;
				|Права администратора: %2;
				|Права для подключения Интернет-поддержки: %3;'"),
			?(Пользователи.ЭтоПолноправныйПользователь(, Ложь, Ложь), НСтр("ru = 'есть'"), НСтр("ru = 'нет'")),
			?(Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь), НСтр("ru = 'есть'"), НСтр("ru = 'нет'")),
			?(ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП(), НСтр("ru = 'есть'"), НСтр("ru = 'нет'")));
	
	// Личные данные:
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Логин для подключения Интернет-поддержки: %1;
				|Пароль для подключения Интернет-поддержки: %2;
				|Регистрационный номер программного продукта: %3;'"),
			ДопПараметры.Логин,
			?(ДопПараметры.ПарольЗаполнен, НСтр("ru = 'заполнен'"), НСтр("ru = 'не заполнен'")),
			ИнтернетПоддержкаПользователей.РегистрационныйНомерПрограммногоПродукта());
	
	// Настройки соединения:
	НастройкиСоединения = ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами();
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Настройки соединения с серверами Интернет-поддержки:
				|	Доменная зона: %1'"),
			?(НастройкиСоединения.ДоменРасположенияСерверовИПП = 1, "1c.eu", "1c.ru"));
	
	// Настройки прокси:
	НастройкиПрокси = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкиПрокси = Неопределено Тогда
		ЗначениеНастройкиПрокси = НСтр("ru = 'не используется'");
	Иначе
		Если НастройкиПрокси.Получить("ИспользоватьПрокси") Тогда
			ЗначениеНастройкиПрокси = ?(НастройкиПрокси.Получить("ИспользоватьСистемныеНастройки"),
				НСтр("ru = 'автоматические'"),
				НСтр("ru = 'ручные'"));
		Иначе
			ЗначениеНастройкиПрокси = НСтр("ru = 'не используется'");
		КонецЕсли;
	КонецЕсли;
	
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Настройки прокси-сервера: %1'"),
			ЗначениеНастройкиПрокси);
	Результат = Результат
		+ Символы.ПС
		+ НСтр("ru = 'Установленные расширения:'")
		+ Символы.ПС
		+ ТекстОписаниеУстановленныхРасширений();
	
	ИдентификаторЦентрМониторинга = "";
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
		ИдентификаторЦентрМониторинга = МодульЦентрМониторинга.ИдентификаторИнформационнойБазы();
	КонецЕсли;
	
	Результат = Результат
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Идентификатор ИБ: %1'"),
			?(ЗначениеЗаполнено(ИдентификаторЦентрМониторинга),
				ИдентификаторЦентрМониторинга,
				НСтр("ru = '<Нет>'")));
	
	// Настройки клиента лицензирования:
	Если ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		ИДКонфигурации = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ИДКонфигурации();
		Если Не ПустаяСтрока(ИДКонфигурации) Тогда
			Результат = Результат + Символы.ПС
				+ НСтр("ru = 'Имя клиента лицензирования:'") + " "
				+ КлиентЛицензирования.ИмяКлиентаЛицензирования()
				+ Символы.ПС + НСтр("ru = 'Идентификатор конфигурации:'")
				+ Символы.ПС + ИДКонфигурации;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстОписаниеУстановленныхРасширений()
	
	ОписаниеРасширенийМассивСтр = Новый Массив;
	
	// Обращение в тех поддержку может формировать
	// не только администратор ИБ.
	УстановитьПривилегированныйРежим(Истина);
	УстановленныеРасширения = РасширенияКонфигурации.Получить();
	
	Для Каждого Расширение Из УстановленныеРасширения Цикл
		ОписаниеРасширенийМассивСтр.Добавить(
			Символы.Таб
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (%2); Акт.: %3; Распр. ИБ: %4; БР: %5'"),
				Расширение.Имя,
				Расширение.Назначение,
				Расширение.Активно,
				Расширение.ИспользуетсяВРаспределеннойИнформационнойБазе,
				Расширение.БезопасныйРежим));
	КонецЦикла;
	
	Если ОписаниеРасширенийМассивСтр.Количество() = 0 Тогда
		ОписаниеРасширенийМассивСтр.Добавить(НСтр("ru = '<Нет>'"));
	КонецЕсли;
	
	Возврат СтрСоединить(ОписаниеРасширенийМассивСтр, Символы.ПС);
	
КонецФункции

// См. ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования.
//
Функция ДоступнаРаботаСНастройкамиКлиентаЛицензирования()
	
	Возврат ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования();
	
КонецФункции

#КонецОбласти

#КонецОбласти
