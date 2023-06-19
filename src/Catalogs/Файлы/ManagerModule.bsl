///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей файла
//
// Возвращаемое значение:
//   Структура
//     Владелец
//     ПутьКФайлуНаДиске
//     ИмяФайла
//
Функция ПолучитьСтруктуруФайла() Экспорт
	
	СтруктураФайла = Новый Структура;
	СтруктураФайла.Вставить("Владелец");
	СтруктураФайла.Вставить("ПутьКФайлуНаДиске");
	СтруктураФайла.Вставить("ИмяФайла");
	
	Возврат СтруктураФайла;
	
КонецФункции

// Создает файл.
//
// Параметры:
//   СтруктураФайла - Структура - структура полей файла.
//
// Возвращаемый параметр:
//   СправочникСсылка.Файлы
//
Функция СоздатьФайл(СтруктураФайла) Экспорт
	
	НовыйФайл = РаботаСФайламиВнешнийВызов.СоздатьФайлНаОсновеФайлаНаДиске(
		СтруктураФайла.Владелец,
		СтруктураФайла.ПутьКФайлуНаДиске,
		СтруктураФайла.ИмяФайла,,
		Истина);
	
	Возврат НовыйФайл;
	
КонецФункции

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоПредмету(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Файл'");
	
КонецФункции

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Описание");
	РедактируемыеРеквизиты.Добавить("Редактирует");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	ТаблицаПравил = ДокументооборотПраваДоступа.ТаблицаПравилОбработкиНастроекПапки();
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ЧтениеПапокИФайлов";
	Стр.Чтение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ДобавлениеПапокИФайлов";
	Стр.Добавление = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ИзменениеПапокИФайлов";
	Стр.Изменение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ПометкаУдаленияПапокИФайлов";
	Стр.Удаление = Истина;
	
	Возврат ТаблицаПравил;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//  Параметры - Структура - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Возврат МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Справочники.Файлы);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецЕсли