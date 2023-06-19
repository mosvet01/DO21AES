///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

// РаботаСФайлами
Перем КомпонентаПолученияКартинкиИзБуфера Экспорт; // компонента получения картинки из буфера обмена
// Конец РаботаСФайлами

// Почта
Перем ВыполненаПроверкаНаличияНесохраненныхПисем Экспорт; // Выполнен поиск на диске несохраненных писем
Перем НеУдалятьАвтосохраненныеФайлы Экспорт; // Если Истина, то при выходе не будут удаляться автосохраненные файлы
Перем ПараметрыПроверкиОрфографииТекст Экспорт;
// Почта

Перем ДрайверСканераШтрихкодов Экспорт; // Сканер штрихкодов
Перем КомпонентаРаспознаванияШтрихкодов Экспорт; // Компонента распознавания штрихкодов

// Переменные общего обработчика ожидания
Перем ДатаПоследнейПроверкиПочты Экспорт;
Перем ДатаПоследнегоСохраненияЗамеров Экспорт;
Перем ИнтервалПроверкиПочты Экспорт;
Перем ИнтервалСохраненияЗамеров Экспорт;
Перем ДатаПоследнейЗаписиЖурналаРегистрации Экспорт;
Перем ДатаПоследнейПроверкиОчисткиКешаФайлов Экспорт;
Перем ДатаПоследнегоАвтопомещенияФайлов Экспорт;

Перем ПараметрыФормыНастройкиОтложенногоСтарта Экспорт;

// НагрузочноеТестирование
Перем НТТекущиеСценарии Экспорт; // Сценарии пользователя для проведения нагрузочного теста.
Перем НТИндексТекущегоСценария Экспорт; // Порядковый номер выполняемого сценария.
Перем НТТекущийСценарий Экспорт; // Выполняемый сценарий.
Перем НТИндексТекущегоШагаСценария Экспорт; // Порядковый номер выполняемого шага текущего сценария.
Перем НТЗавершитьРаботуПослеВыполненияСценариев Экспорт; // Признак завершения работы клиента, после выполнения всех сценариев нагрузочного теста.
// Конец НагрузочноеТестирование

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// НагрузочноеТестирование
	#Если Не ВебКлиент Тогда
		НагрузочноеТестированиеКлиент.ЗапуститьВыполнениеСценариев(ПараметрЗапуска);
	#КонецЕсли
	// Конец НагрузочноеТестирование
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	Если Не Отказ Тогда
		РаботаСТорговымОборудованием.ОтключитьСканерШтрихкодов();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(
			НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
			
	ОбсужденияДокументооборотКлиент.ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(
			НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
КонецПроцедуры

Процедура АвтоПодборПользователейСистемыВзаимодействия(Текст, ДанныеВыбора, НазначениеВыбора, Форма, ИдентификаторОбсуждения)
	
	ОбсужденияДокументооборотКлиент.АвтоПодборПользователейСистемыВзаимодействия(
		Текст, ДанныеВыбора, НазначениеВыбора, Форма, ИдентификаторОбсуждения)
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	Если Источник = "ПоискДокументовПоШтрихкоду" Тогда
		ШтрихкодированиеКлиент.ПоискПоШтрихкоду(Данные, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
	
	ВстроеннаяПочтаКлиент.УдалитьАвтосохраненныеФайлы();
	
КонецПроцедуры

#КонецОбласти