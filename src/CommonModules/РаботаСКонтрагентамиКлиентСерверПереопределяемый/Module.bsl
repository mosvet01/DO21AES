///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентовВДокументах

// Определение вида документа.
//
// Параметры:
//  Форма								 - ФормаКлиентскогоПриложения - Форма документа, для которого необходимо получить описание.
//	Результат							 - Структура - Описывает вид документа. Ключи:
//  		"КонтрагентНаходитсяВШапке"			 	- Булево - Признак того, есть у документа контрагент в шапке
//  		"КонтрагентНаходитсяВТабличнойЧасти"	- Булево - Признак того, есть у документа контрагенты в табличных частях
//  		"СчетФактураНаходитсяВПодвале"		 	- Булево - Признак того, есть у документа счет-фактура в подвале
//  		"ЯвляетсяСчетомФактурой"				- Булево - Признак того, является ли сам документ счетом-фактурой.
//
//@skip-warning
Процедура ОпределитьВидДокумента(Форма, Результат) Экспорт
	
	ТипСсылки = ?(ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения"),
		ТипЗнч(Форма.Объект.Ссылка),
		ТипЗнч(Форма));
	
	Если ТипСсылки = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		Результат.Вставить("КонтрагентНаходитсяВШапке", Истина);
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
		Результат.Вставить("КонтрагентНаходитсяВШапке", Истина);
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		Результат.Вставить("КонтрагентНаходитсяВШапке", Истина);
		Результат.Вставить("КонтрагентНаходитсяВТабличнойЧасти", Истина);
	КонецЕсли;
	
КонецПроцедуры

// Получение счета-фактуры, находящегося в подвале документа-основания, чья форма передана в качестве
//             параметра.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения - Форма документа-основания, для которой необходимо получить счет-фактуру.
//  СчетФактура	 - ДокументСсылка - Счет-фактура, полученная для данного документа-основания.
//
//@skip-warning
Процедура ПолучитьСчетФактуру(Форма, СчетФактура) Экспорт
	
	
КонецПроцедуры

// Возможность доопределить сформированную подсказку для формы документа.
//
// Параметры:
//  Результат            - Структура - содержит текст подсказки и цвет фона подсказки.
//  СостояниеКонтрагента - ПеречислениеСсылка.СостоянияСуществованияКонтрагента - текущее состояние контрагента.
//  Цвета                - Структура - содержит цвета, используемые при выводе информации о состоянии контрагента.
//
//@skip-warning
Процедура ПослеФормированияПодсказкиВДокументе(Результат, СостояниеКонтрагента, Цвета) Экспорт
	
	
	
КонецПроцедуры 

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Вывод панели проверки в отчете.
//
// Параметры:
//  Форма	 				- ФормаКлиентскогоПриложения - Форма отчета, для которого выводится результат проверки контрагента.
//  СостояниеПроверки		- Строка - Текущее состояние проверки, может принимать следующие значения, либо быть пустой
//                                строкой: ВсеКонтрагентыКорректные
// 			НайденыНекорректныеКонтрагенты
// 			ДопИнформацияПоПроверке
// 			ПроверкаВПроцессеВыполнения
// 			НетДоступаКСервису.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
//@skip-warning
Процедура УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, СтандартнаяОбработка, СостояниеПроверки = "") Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Отображение результата проверки контрагента в справочнике.
// Реализация тела метода является обязательной.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  ПредставлениеРезультатаПроверки	 - ФорматированнаяСтрока, Строка - представление результата проверки
//  					контрагента.
//
//@skip-warning
Процедура ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки) Экспорт
	
	Форма.РезультатПроверкиКонтрагента = ПредставлениеРезультатаПроверки;
	
КонецПроцедуры

// Определяет строковое представление результата проверки контрагента.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  Текст - Строка - представление результата проверки контрагента.
//
Процедура ПриЗаполненииТекстаРезультатаПроверки(Форма, Текст) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедуры

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
// справочника,  в котором выполняется проверка контрагента, по форме.
// Обязательна к заполнению.
//
// Параметры:
//	Форма     - ФормаКлиентскогоПриложения - Форма документа или справочника, в котором выполняется проверка контрагента.
//	Результат - Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
//
//@skip-warning
Процедура ПриОпределенииОбъектаИСсылкиПоФорме(Форма, Результат) Экспорт
	
	Результат.Объект = Форма.Объект;
	Результат.Ссылка = Форма.Объект.Ссылка;
	
КонецПроцедуры

// Возможность дополнить параметры запуска фонового задания при проверке справочника.
//
// Параметры:
//  ДополнительныеПараметрыЗапуска - Структура - содержит параметры запуска.
//  Форма                          - ФормаКлиентскогоПриложения - форма, из которой запускается фоновое задание.
//
//@skip-warning
Процедура ДополнитьПараметрыЗапускаФоновогоЗадания(ДополнительныеПараметрыЗапуска, Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("НеИспользоватьКэш") Тогда
		ДополнительныеПараметрыЗапуска.Вставить("НеИспользоватьКэш",
			Форма.РеквизитыПроверкиКонтрагентов.НеИспользоватьКэш);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
