///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Состав обязательных процедур такого модуля см. в общем модуле ОбновлениеИнформационнойБазыБСП
// (область ПрограммныйИнтерфейс).
// При этом сам модуль Библиотеки стандартных подсистем ОбновлениеИнформационнойБазыБСП
// не требуется явно добавлять в массив МодулиПодсистем.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//                             Например: "ОбновлениеИнформационнойБазыБРО" - библиотека,
//                                       "ОбновлениеИнформационнойБазыБП"  - конфигурация.
//                    
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыДокументооборот");
	
	// БиблиотекаЭлектронныхДокументов
 	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБЭД");
	// Конец БиблиотекаЭлектронныхДокументов
	
	// БиблиотекаРегламентированнойОтчетности
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБРО");
	// Конец БиблиотекаРегламентированнойОтчетности
	
КонецПроцедуры

#КонецОбласти
