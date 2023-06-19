///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭлектронныеПодписи.Объект КАК Объект,
	|	ЭлектронныеПодписи.УникальныйИдентификатор КАК УникальныйИдентификатор
	|ИЗ
	|	РегистрСведений.ЭлектронныеПодписи КАК ЭлектронныеПодписи
	|ГДЕ
	|	(ЭлектронныеПодписи.ИмяФайлаПодписи ПОДОБНО ""%\%""
	|			ИЛИ ЭлектронныеПодписи.ИмяФайлаПодписи ПОДОБНО ""%/%"")";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = Метаданные.РегистрыСведений.ЭлектронныеПодписи.ПолноеИмя();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.ЭлектронныеПодписи;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЭлектронныеПодписи.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
		ЭлементБлокировки.УстановитьЗначение("Объект", Выборка.Объект);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				
				ЧастиИмени = СтрРазделить(Запись.ИмяФайлаПодписи, "\/", Ложь);
				
				Если ЧастиИмени.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				ИмяФайлаПодписиБезПути = ЧастиИмени[ЧастиИмени.ВГраница()];
				Если Запись.ИмяФайлаПодписи <> ИмяФайлаПодписиБезПути Тогда
					Запись.ИмяФайлаПодписи = ИмяФайлаПодписиБезПути;
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				КонецЕсли;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			Обработано = Обработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Проблемных = Проблемных + 1;
			СвойстваКлюча = Новый Структура("Объект",
				Выборка.Объект);
			КлючЗаписи = РегистрыСведений.ЭлектронныеПодписи.СоздатьКлючЗаписи(СвойстваКлюча);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать запись регистра %1 по причине:
					|%2'"),
				ПолучитьНавигационнуюСсылку(КлючЗаписи),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , 
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	ИмяПроцедуры = ПолноеИмяРегистра + "." + "ОбработатьДанныеДляПереходаНаНовуюВерсию";
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре %1 не удалось обработать некоторые записи (пропущены): %2'"), 
			ИмяПроцедуры,
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Информация, МетаданныеРегистра, ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура %1 обработала очередную порцию записей: %2'"),
			ИмяПроцедуры,
			Обработано));
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	
	
КонецПроцедуры
