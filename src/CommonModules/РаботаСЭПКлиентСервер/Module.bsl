////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для работы с электронными подписями.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Новые данные для получения текстового статуса подписи.
// 
// Возвращаемое значение:
//  Структура - Новые данные для получения статуса подписи:
//   * ПодписьВерна - Булево - Верна ли подпись криптографически
//   * ТекстОшибкиПроверкиПодписи - Строка - Описание ошибки при проверке криптографической верности подписи
//   * СертификатДействителен - Булево - Действителен ли сертификат
//   * ТекстОшибкиПроверкиСертификата - Строка - Описании ошибки при проверке сертификата
//   * ПодписьПоДоверенности - Булево - Подпись проставлена по доверенности
//   * ДоверенностьДействительна - Булево - Действительна ли доверенность
//   * ПротоколПроверкиДоверенности - Структура, Неопределено - Протокол проверки доверенности
//   * ДатаПроверки - Дата - Дата проверки подписи
//   * СрокПроверкиСертификата - Дата - Дата по которую действителен сертификат подписания или сертификат метки времени
//
Функция НовыеДанныеДляПолученияСтатусаПодписи() Экспорт
	
	ДанныеДляСтатуса = Новый Структура;
	
	ДанныеДляСтатуса.Вставить("ПодписьВерна", Ложь);
	ДанныеДляСтатуса.Вставить("ТекстОшибкиПроверкиПодписи", "");
	
	ДанныеДляСтатуса.Вставить("СертификатДействителен", Ложь);
	ДанныеДляСтатуса.Вставить("ТекстОшибкиПроверкиСертификата", "");
	
	ДанныеДляСтатуса.Вставить("ПодписьПоДоверенности", Ложь);
	ДанныеДляСтатуса.Вставить("ДоверенностьДействительна", Ложь);
	ДанныеДляСтатуса.Вставить("ПротоколПроверкиДоверенности", Новый Структура);
	
	ДанныеДляСтатуса.Вставить("ДатаПроверки", Дата(1, 1, 1));
	ДанныеДляСтатуса.Вставить("СрокПроверкиСертификата", Дата(1, 1, 1));
	
	Возврат ДанныеДляСтатуса;
	
КонецФункции

// Текстовый общий статус проверки подписи
// 
// Параметры:
//  ДанныеДляСтатуса см. РаботаСЭПКлиентСервер.НовыеДанныеДляПолученияСтатусаПодписи
// 
// Возвращаемое значение:
//  Строка - Текстовый статус проверки подписи
Функция ОбщийСтатусПроверкиПодписи(ДанныеДляСтатуса) Экспорт
	
	ПредставлениеДатыПроверки = Формат(ДанныеДляСтатуса.ДатаПроверки, "ДФ='dd.MM.yyyy HH:mm'");
	
	Если Не ЗначениеЗаполнено(ПредставлениеДатыПроверки) Тогда
		Возврат НСтр("ru = 'Не проверена'");
	КонецЕсли;
	
	Если Не ДанныеДляСтатуса.ПодписьВерна Тогда
		Возврат СтрШаблон(НСтр("ru = 'Недействительна (%1)'"), ПредставлениеДатыПроверки);
	КонецЕсли;
	
	Если Не ДанныеДляСтатуса.СертификатДействителен Тогда
		Возврат СтрШаблон(НСтр("ru = 'Подпись действительна, но нет доверия к сертификату (%1)'"),
			ПредставлениеДатыПроверки);
	КонецЕсли;
	
	ДействуетНаДатуПроверки = (ДанныеДляСтатуса.СрокПроверкиСертификата > ДанныеДляСтатуса.ДатаПроверки);
	
	Если Не ДанныеДляСтатуса.ПодписьПоДоверенности Тогда
		
		Если Не ДействуетНаДатуПроверки Тогда
			Возврат СтрШаблон(НСтр("ru = 'Подпись была действительна на момент подписания (%1)'"),
				ПредставлениеДатыПроверки);
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Действительна (%1)'"), ПредставлениеДатыПроверки);
		
	ИначеЕсли Не ДанныеДляСтатуса.ДоверенностьДействительна
		И ДанныеДляСтатуса.ПротоколПроверкиДоверенности = Неопределено Тогда
		
		Если Не ДействуетНаДатуПроверки Тогда
			Возврат СтрШаблон(НСтр("ru = 'Подпись была действительна на момент подписания, доверенность не проверена (%1)'"),
				ПредставлениеДатыПроверки);
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Подпись действительна, доверенность не проверена (%1)'"), ПредставлениеДатыПроверки);
		
	ИначеЕсли Не ДанныеДляСтатуса.ДоверенностьДействительна Тогда
		
		Если Не ДействуетНаДатуПроверки Тогда
			Возврат СтрШаблон(НСтр("ru = 'Подпись была действительна на момент подписания, доверенность недействительна (%1)'"),
				ПредставлениеДатыПроверки);
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Подпись действительна, доверенность недействительна (%1)'"), ПредставлениеДатыПроверки);
		
	Иначе
		
		Если Не ДействуетНаДатуПроверки Тогда
			Возврат СтрШаблон(НСтр("ru = 'Подпись была действительна на момент подписания, доверенность действительна (%1)'"),
				ПредставлениеДатыПроверки);
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Подпись действительна, доверенность действительна (%1)'"), ПредставлениеДатыПроверки);
		
	КонецЕсли;
	
КонецФункции

Функция СтатусПроверкиПодписи(ДанныеДляСтатуса) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеДляСтатуса.ДатаПроверки) Тогда
		Возврат НСтр("ru = 'Не проверена'");
	КонецЕсли;
	
	Если ДанныеДляСтатуса.ПодписьВерна Тогда
		Возврат НСтр("ru = 'Действительна'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеДляСтатуса.ТекстОшибкиПроверкиПодписи) Тогда
		Возврат ДанныеДляСтатуса.ТекстОшибкиПроверкиПодписи;
	КонецЕсли;
	
	Возврат НСтр("ru = 'Недействительна'");
	
КонецФункции

Функция СтатусПроверкиСертификата(ДанныеДляСтатуса) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеДляСтатуса.ДатаПроверки)
		ИЛИ (
			ЗначениеЗаполнено(ДанныеДляСтатуса.ДатаПроверки)
			И Не ДанныеДляСтатуса.СертификатДействителен
			И Не ЗначениеЗаполнено(ДанныеДляСтатуса.ТекстОшибкиПроверкиСертификата)
		) Тогда
			
		Возврат НСтр("ru = 'Не проверен'");
	КонецЕсли;
	
	Если ДанныеДляСтатуса.СертификатДействителен Тогда
		Возврат НСтр("ru = 'Действителен'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеДляСтатуса.ТекстОшибкиПроверкиСертификата) Тогда
		Возврат ДанныеДляСтатуса.ТекстОшибкиПроверкиСертификата;
	КонецЕсли;
	
	Возврат НСтр("ru = 'Недействителен'");
	
КонецФункции

Функция СтатусПроверкиДоверенности(ДанныеДляСтатуса) Экспорт
	
	Если Не ДанныеДляСтатуса.ПодписьПоДоверенности Тогда
		Возврат НСтр("ru = 'Подписано без доверенности'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеДляСтатуса.ДатаПроверки) Тогда
		Возврат НСтр("ru = 'Подпись не проверена'");
	КонецЕсли;
	
	Если Не ДанныеДляСтатуса.ДоверенностьДействительна
		И ДанныеДляСтатуса.ПротоколПроверкиДоверенности = Неопределено Тогда
		
		Возврат НСтр("ru = 'Доверенность не проверена'");
		
	ИначеЕсли Не ДанныеДляСтатуса.ДоверенностьДействительна Тогда
		
		РезультатПроверки = РезультатПроверкиДоверенностиПоПротоколу(ДанныеДляСтатуса.ПротоколПроверкиДоверенности);
		Если ЗначениеЗаполнено(РезультатПроверки.ОписаниеПроблемы) Тогда
			Возврат РезультатПроверки.ОписаниеПроблемы;
		Иначе
			Возврат НСтр("ru = 'Доверенность недействительна'");
		КонецЕсли;
		
	Иначе
		
		Возврат НСтр("ru = 'Доверенность действительна'");
		
	КонецЕсли;
	
КонецФункции

// Формирует строку общего статуса проверки подписи
// 
// Параметры:
//  ПодписьВерна - Булево - Верна ли ЭП
//  СертификатДействителен - Булево - Действителен ли сертификат
//  ДатаПроверкиПодписи - Дата - Дата проверки подписи
//  СрокПроверкиСертификата - Дата - Срок по который возможно проверять сертификат (подписи или метки времени)
// 
// Возвращаемое значение:
//  Строка - Общий статус проверки подписи
Функция ПолучитьОбщийСтатусПроверкиПодписи(Знач ПодписьВерна, Знач СертификатДействителен,
	Знач ДатаПроверкиПодписи, Знач СрокПроверкиСертификата) Экспорт
	
	ПредставлениеДатыПроверки = Формат(ДатаПроверкиПодписи, "ДФ='dd.MM.yyyy HH:mm'");
	
	Если Не ЗначениеЗаполнено(ПредставлениеДатыПроверки) Тогда
		Возврат НСтр("ru = 'Не проверена'");
	КонецЕсли;
	
	Если Не ПодписьВерна Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недействительна (%1)'"), ПредставлениеДатыПроверки);
	КонецЕсли;
	
	Если Не СертификатДействителен Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Действительна, но нет доверия к сертификату (%1)'"),
			ПредставлениеДатыПроверки);
	КонецЕсли;
	
	Если СрокПроверкиСертификата < ДатаПроверкиПодписи Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Была действительна на момент подписания (%1)'"),
			ПредставлениеДатыПроверки);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Действительна (%1)'"), ПредставлениеДатыПроверки);
	
КонецФункции

// Формирует сообщение об отсутствии установленных сертификатов у пользователя в хранилище личных.
//
Функция СообщениеОбОтсутствииСертификатовВХранилище() Экспорт
	
	Результат = НСтр("ru = 'В хранилище личных сертификатов не найдено ни одного сертификата.
                      |Выполнение операции невозможно. Обратитесь к администратору.'");
	
	Возврат Результат;
	
КонецФункции

// Формирует сообщение об отсутствии установленных сертификатов у пользователя.
//
Функция СообщениеОбОтсутствииУстановленныхСертификатов() Экспорт
	
	Результат = НСтр("ru = 'Не установлено ни одного личного сертификата для выполнения операции.
                      |Установить личный сертификат можно в персональных настройках ЭП.'");
								
	Возврат Результат;
	
КонецФункции

// Формирует сообщение об отсутствии установленных сертификатов у пользователя в хранилище личных
// для выполнения операции расшифрования.
//
Функция СообщениеОбОтсутствииУстановленныхСертификатовДляРасшифрования() Экспорт
	
	Результат = НСтр("ru = 'Не установлено ни одного личного сертификата, предназначенного для расшифровки файла.
                     |Установить личный сертификат можно в персональных настройках ЭП.'");
	
	Возврат Результат;
	
КонецФункции

#Область ПроверкаПодписей

// Новые данные подписи для проверки.
// 
// Возвращаемое значение:
//  Структура - Новые данные подписи для проверки:
//   * УникальныйИдентификатор - УникальныйИдентификатор - УИД подписи
//   * ДатаПодписи - Дата - Дата установки подписи
//   * Объект - ОпределяемыйТип.ПодписанныйОбъект, Неопределено - Подписанный объект
//   * УстановившийПодпись - СправочникСсылка.Пользователи - Пользователь, занесший информацию о подписи
//   * Версия - Число - Номер версии подписи, т.е. номер правил по которым формируются набор ключевых реквизитов
//   * ДатаПроверкиПодписи - Дата - Дата проверки подписи
//   * Комментарий - Строка - Комментарий к подписи
//   * КомуВыданСертификат - Строка - Представление субъекта, которому выдан сертификат ЭП
//   * Отпечаток - Строка - Отпечаток сертификата, которым выполнено подписание
//   * АдресПодписи - Строка - Адрес двоичных данных подписи во временном хранилище
//   * ПодписьВерна - Булево - Указывает, верна ли подпись (криптографически)
//   * АдресСертификата - Строка - Адрес двоичных данных сертификата во временном хранилище
//   * СертификатДействителен - Булево - Указывает, действителен ли сертификат
//   * СрокДействияПоследнейМеткиВремени - Дата - Срок, по который действует сертификат метки времени
//   * Доверенность - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций,
//                    СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на доверенность, по которой выполнено подписание
//   * ДоверенностьВерна - Булево - Указывает, верна ли доверенность для данной подписи
//   * Зашифрован - Булево - Если подписанный объект файл - указывает, зашифрован ли он.
//   * Статус - Строка - Статус проверки подписи
//
Функция НовыеДанныеПодписиДляПроверки() Экспорт
	
	ПустаяДата = Дата(1, 1, 1);
	ПустойПользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ПустаяДоверенность = ПредопределенноеЗначение("Справочник.МашиночитаемыеДоверенностиОрганизаций.ПустаяСсылка");
	
	ДанныеПодписи = Новый Структура;
	ДанныеПодписи.Вставить("УникальныйИдентификатор", УникальныйИдентификаторПустой());
	ДанныеПодписи.Вставить("ДатаПодписи", ПустаяДата);
	ДанныеПодписи.Вставить("Объект", Неопределено);
	ДанныеПодписи.Вставить("УстановившийПодпись", ПустойПользователь);
	ДанныеПодписи.Вставить("Версия", 0);
	ДанныеПодписи.Вставить("ДатаПроверкиПодписи", ПустаяДата);
	ДанныеПодписи.Вставить("Комментарий", "");
	ДанныеПодписи.Вставить("КомуВыданСертификат", "");
	ДанныеПодписи.Вставить("Отпечаток", "");
	ДанныеПодписи.Вставить("АдресПодписи", "");
	ДанныеПодписи.Вставить("ПодписьВерна", Ложь);
	ДанныеПодписи.Вставить("АдресСертификата", "");
	ДанныеПодписи.Вставить("СертификатДействителен", Ложь);
	ДанныеПодписи.Вставить("СрокДействияПоследнейМеткиВремени", ПустаяДата);
	
	ДанныеПодписи.Вставить("ТекстОшибкиПроверкиПодписи", "");
	ДанныеПодписи.Вставить("ТекстОшибкиПроверкиСертификата", "");
	
	ДанныеПодписи.Вставить("Доверенность", ПустаяДоверенность);
	ДанныеПодписи.Вставить("ДоверенностьВерна", Ложь);
	
	ДанныеПодписи.Вставить("Зашифрован", Ложь);
	
	ДанныеПодписи.Вставить("Статус", "");
	
	Возврат ДанныеПодписи;
	
КонецФункции

// Возвращает новые данные объекта для проверки подписей
// 
// Возвращаемое значение:
//  Структура - Новые данные объекта для проверки подписи:
//   * Зашифрован - Булево - Указывает, зашифрованы ли двоичные данные
//   * ОбъектШифрования - ОпределяемыйТип.ПодписанныйОбъект, Неопределено - Ссылка на зашифрованный объект
//                                               Например для версий файлов, зашифрованным является именно файл.
//   * АдресДанных - Строка - Адрес двоичных данных во временном хранилище
//   * РазныеВерсииПодписей - Булево - Указывает, что двоичные данные могут различаться в зависимости от версии подписи
//   * ДвоичныеДанныеПоВерсиям - Соответствие из КлючИЗначение - Заполняется, если РазныеВерсииПодписей = Истина:
//     ** Ключ - Число - ВерсияОбъекта
//     ** Значение - Массив из Строка - Массив адресов двоичных данных во временном хранилище
//
Функция НовыеДанныеОбъектаДляПроверкиПодписи() Экспорт
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("Зашифрован", Ложь);
	ДанныеОбъекта.Вставить("ОбъектШифрования", Неопределено);
	ДанныеОбъекта.Вставить("АдресДанных", "");
	ДанныеОбъекта.Вставить("РазныеВерсииПодписей", Ложь);
	ДанныеОбъекта.Вставить("ДвоичныеДанныеПоВерсиям", Новый Соответствие);
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Функция НовыеПараметрыПолученияДанныхОбъектовДляПроверкиПодписей() Экспорт
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ДанныеПодписейОбъектов", Новый Соответствие);
	ПараметрыПолучения.Вставить("УникальныйИдентификаторФормы", Неопределено);
	ПараметрыПолучения.Вставить("РасшифрованныеДанные", Новый Соответствие);
	
	Возврат ПараметрыПолучения;
	
КонецФункции

Функция НовыеДанныеДляПроверкиДоверенностиПодписи() Экспорт
	
	ПустаяДоверенность = ПредопределенноеЗначение("Справочник.МашиночитаемыеДоверенностиОрганизаций.ПустаяСсылка");
	ПустаяДата = Дата(1, 1, 1);
	
	ДанныеДляПроверки = Новый Структура;
	ДанныеДляПроверки.Вставить("Доверенность", ПустаяДоверенность);
	
	ДанныеПодписи = Новый Структура;
	ДанныеПодписи.Вставить("ДатаПроверкиПодписи", ПустаяДата);
	ДанныеПодписи.Вставить("ПодписьВерна", Ложь);
	ДанныеПодписи.Вставить("ДатаПодписи", ПустаяДата);
	ДанныеПодписи.Вставить("АдресСертификата", "");
	ДанныеПодписи.Вставить("Сертификат", Неопределено);
	ДанныеПодписи.Вставить("УникальныйИдентификатор", УникальныйИдентификаторПустой());
	
	ДанныеДляПроверки.Вставить("ДанныеПодписи", ДанныеПодписи);
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

Функция РезультатПроверкиДоверенностиПоПротоколу(ПротоколПроверки) Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("ДоверенностьДействительна", Ложь);
	РезультатПроверки.Вставить("ОписаниеПроблемы", "");
	
	Если Не ВерныйФорматПротоколаПроверки(ПротоколПроверки) Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Протокол проверки имеет неверный формат'");
		Возврат РезультатПроверки
	КонецЕсли;
	
	РезультатПроверкиПодписи = РезультатПроверкиПодписиВПротоколе(ПротоколПроверки.ПроверкаПодписиДокумента);
	Если Не РезультатПроверкиПодписи.Успех Тогда
		РезультатПроверки.ОписаниеПроблемы = РезультатПроверкиПодписи.ОписаниеПроблемы;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	РезультатПроверкиДоверенности = РезультатПроверкиДоверенности(ПротоколПроверки.ПроверкаМЧД);
	Если Не РезультатПроверкиДоверенности.Успех Тогда
		РезультатПроверки.ОписаниеПроблемы = РезультатПроверкиДоверенности.ОписаниеПроблемы;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	РезультатПроверки.ДоверенностьДействительна = Истина;
	Возврат РезультатПроверки;
	
КонецФункции

Функция НовыйРезультатПроверкиПодписи() Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("ПодписьВерна", Ложь);
	РезультатПроверки.Вставить("СертификатДействителен", Ложь);
	РезультатПроверки.Вставить("ТекстОшибкиПроверкиПодписи", "");
	РезультатПроверки.Вставить("ТекстОшибкиПроверкиСертификата", "");
	
	Возврат РезультатПроверки;
	
КонецФункции

// Возвращает новые данные подписи без сертификата
// 
// Возвращаемое значение:
//  Структура:
//    * Объект - ОпределяемыйТип.ПодписанныйОбъект - Подписанный объект
//    * ДанныеПодписи см. РаботаСЭПКлиентСервер.НовыеДанныеПодписиДляПроверки
Функция НовыеДанныеПодписиБезСертификата() Экспорт
	
	ДанныеПодписиБезСертификата = Новый Структура;
	ДанныеПодписиБезСертификата.Вставить("Объект", Неопределено);
	ДанныеПодписиБезСертификата.Вставить("ДанныеПодписи", НовыеДанныеПодписиДляПроверки());
	
	Возврат ДанныеПодписиБезСертификата;
	
КонецФункции

// Возвращает новые данные сертификата, полученные из подписи
// 
// Возвращаемое значение:
//  Структура:
// * АдресСертификата - Строка - Адрес двоичных данны сертификата
// * КомуВыданСертификат - Строка - Представление кому выдан сертификат
// * Отпечаток - Строка - Base64 строка отпечатка сертификата
Функция НовыйРезультатПолученияДанныхСертификатаИзПодписи() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("АдресСертификата", "");
	Результат.Вставить("КомуВыданСертификат", "");
	Результат.Вставить("Отпечаток", "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВерныйФорматПротоколаПроверки(Протокол)
	
	Если ТипЗнч(Протокол) <> Тип("Структура") Тогда
		Возврат Ложь;
	ИначеЕсли Не Протокол.Свойство("ПроверкаМЧД") Тогда
		Возврат Ложь;
	ИначеЕсли Не Протокол.Свойство("ПроверкаПодписиДокумента") Тогда
		Возврат Ложь;
	ИначеЕсли ТипЗнч(Протокол.ПроверкаПодписиДокумента) <> Тип("Структура") Тогда
		Возврат Ложь;
	ИначеЕсли ТипЗнч(Протокол.ПроверкаМЧД) <> Тип("Структура") Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция РезультатПроверкиПодписиВПротоколе(ПроверкаПодписи)
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("Успех", Ложь);
	РезультатПроверки.Вставить("ОписаниеПроблемы", "");
	
	Если ПроверкаПодписи.Выполнено <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка подписи документа'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПроверкаПодписи.Успех <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Подпись документа неверна'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	РезультатПроверки.Успех = Истина;
	Возврат РезультатПроверки;
	
КонецФункции

Функция РезультатПроверкиДоверенности(ПроверкаМЧД)
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("Успех", Ложь);
	РезультатПроверки.Вставить("ОписаниеПроблемы", "");
	
	Если ТипЗнч(ПроверкаМЧД.ПроверкаОтзываМЧД) <> Тип("Структура")
		Или ПроверкаМЧД.ПроверкаОтзываМЧД.Выполнено <> Истина Тогда
		
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка отзыва доверенности'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПроверкаМЧД.ПроверкаОтзываМЧД.Успех <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Доверенность отозвана'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ТипЗнч(ПроверкаМЧД.ПроверкаПериодаДействия) <> Тип("Структура")
		Или ПроверкаМЧД.ПроверкаПериодаДействия.Выполнено <> Истина Тогда
		
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка периода действия доверенности'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПроверкаМЧД.ПроверкаПериодаДействия.Успех <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Доверенность не действовала на момент подписания'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ТипЗнч(ПроверкаМЧД.ПроверкаПодписиМЧД) <> Тип("Структура")
		Или ПроверкаМЧД.ПроверкаПодписиМЧД.Выполнено <> Истина Тогда
		
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка подписи доверенности'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПроверкаМЧД.ПроверкаПодписиМЧД.Успех <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Подпись доверенности не верна'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ТипЗнч(ПроверкаМЧД.ПроверкаСтатусаВРеестреФНС) = Тип("Структура") Тогда
		
		Если ПроверкаМЧД.ПроверкаСтатусаВРеестреФНС.Выполнено <> Истина Тогда
			РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка статуса доверенности в реестре ФНС'");
			Возврат РезультатПроверки;
		КонецЕсли;
		
		Если ПроверкаМЧД.ПроверкаСтатусаВРеестреФНС.Успех <> Истина Тогда
			РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Доверенность не была действительна в реестре ФНС на момент подписания'");
			Возврат РезультатПроверки;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ПроверкаМЧД.СопоставлениеПредставителя) <> Тип("Структура")
		Или ПроверкаМЧД.СопоставлениеПредставителя.Выполнено <> Истина Тогда
		
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'Не выполнена проверка соответствия доверителя и доверенности'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ПроверкаМЧД.СопоставлениеПредставителя.Успех <> Истина Тогда
		РезультатПроверки.ОписаниеПроблемы = НСтр("ru = 'ИНН сертификата подписи не соответствует представителю в доверенности'");
		Возврат РезультатПроверки;
	КонецЕсли;
	
	РезультатПроверки.Успех = Истина;
	Возврат РезультатПроверки;
	
КонецФункции

#КонецОбласти
