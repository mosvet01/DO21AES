///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейСлужебныйПовтИсп.
//
// Серверные процедуры и функции повторного использования Интернет-поддержки пользователей:
//  - получение настроек программы;
//  - кэширование доступности сервисов;
//  - общие процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает base64-строку: идентификатор конфигурации информационной базы.
//
Функция ИДКонфигурации() Экспорт
	
	Если ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		Возврат КлиентЛицензирования.ИДКонфигурации();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает текущие настройки соединения с серверами Интернет-поддержки.
//
Функция НастройкиСоединенияССерверамиИПП() Экспорт
	
	Результат = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	Результат.Вставить("ДоменРасположенияСерверовИПП"     , ИнтернетПоддержкаПользователей.ДоменРасположенияСерверовИПП());
	Результат.Вставить("УстанавливатьПодключениеНаСервере", Истина);
	Результат.Вставить("ТаймаутПодключения"               , 30);
	
	Возврат Результат;
	
КонецФункции

// Кэширует вызов ОбщегоНазначения.КодОсновногоЯзыка().
// Возвращает код основного языка конфигурации, например "ru".
//
// Возвращаемое значение:
//  Строка - код языка.
//
Функция КодОсновногоЯзыка() Экспорт

	Возврат ОбщегоНазначения.КодОсновногоЯзыка();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. ИнтернетПоддержкаПользователей.СлужебнаяПроверитьURLДоступен.
//
Функция ПроверитьURLДоступен(URL, Метод, ИмяОшибки, СообщениеОбОшибке, ИнформацияОбОшибке) Экспорт
	
	ИнтернетПоддержкаПользователей.СлужебнаяПроверитьURLДоступен(
		URL,
		Метод,
		ИмяОшибки,
		СообщениеОбОшибке,
		ИнформацияОбОшибке);
	
	Если Не ПустаяСтрока(ИмяОшибки) Тогда
		ВызватьИсключение ИмяОшибки;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенная конфигурация.
//
Функция ЭтоРазделеннаяКонфигурация() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервисаБИП = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервисаБИП");
		ЕстьРазделители = МодульРаботаВМоделиСервисаБИП.ЭтоРазделеннаяКонфигурация();
	Иначе
		ЕстьРазделители = Ложь;
	КонецЕсли;
	
	Возврат ЕстьРазделители;
	
КонецФункции

// Определяет, сеанс запущен с разделителями или без.
//
// Возвращаемое значение:
//   Булево - Истина, если сеанс запущен без разделителей.
//
Функция СеансЗапущенБезРазделителей() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервисаБИП = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервисаБИП");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервисаБИП.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Возврат СеансЗапущенБезРазделителей;
	
КонецФункции

#КонецОбласти