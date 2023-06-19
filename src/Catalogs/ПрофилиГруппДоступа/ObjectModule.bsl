///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыеЗначения; // Значения некоторых реквизитов и табличных частей профиля
                      // до его изменения для использования в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	РегистрыСведений.ПраваРолей.ПроверитьДанныеРегистра();
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
		"Ссылка, ПометкаУдаления, Роли, Назначение, ВидыДоступа, ЗначенияДоступа");
	
	// Проверка ролей.
	РолиАдминистратора = Новый Массив;
	РолиАдминистратора.Добавить("Роль.ПолныеПрава");
	РолиАдминистратора.Добавить("Роль.АдминистраторСистемы");
	ИдентификаторыРолей = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(РолиАдминистратора);
	ОбработанныеРоли = Новый Соответствие;
	Индекс = Роли.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Роль = Роли[Индекс].Роль;
		Если ОбработанныеРоли.Получить(Роль) <> Неопределено Тогда
			Роли.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
		ОбработанныеРоли.Вставить(Роль, Истина);
		Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
			Продолжить;
		КонецЕсли;
		Если Роль = ИдентификаторыРолей["Роль.ПолныеПрава"]
		 Или Роль = ИдентификаторыРолей["Роль.АдминистраторСистемы"] Тогда
			
			Роли.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ДополнительныеСвойства.Свойство("НеОбновлятьРеквизитПоставляемыйПрофильИзменен") Тогда
		ПоставляемыйПрофильИзменен =
			Справочники.ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен(ЭтотОбъект);
	КонецЕсли;
	
	ИнтерфейсУпрощенный = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если ИнтерфейсУпрощенный Тогда
		// Обновление наименования у персональных групп доступа этого профиля (если есть).
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Профиль",      Ссылка);
		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	ГруппыДоступа.Профиль = &Профиль
		|	И ГруппыДоступа.Пользователь <> НЕОПРЕДЕЛЕНО
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Наименование <> &Наименование";
		ИзмененныеГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Если ИзмененныеГруппыДоступа.Количество() > 0 Тогда
			Для каждого ГруппаДоступаСсылка Из ИзмененныеГруппыДоступа Цикл
				ПерсональнаяГруппаДоступаОбъект = ГруппаДоступаСсылка.ПолучитьОбъект();
				ПерсональнаяГруппаДоступаОбъект.Наименование = Наименование;
				ПерсональнаяГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
				ПерсональнаяГруппаДоступаОбъект.Записать();
			КонецЦикла;
			ДополнительныеСвойства.Вставить(
				"ПерсональныеГруппыДоступаСОбновленнымНаименованием", ИзмененныеГруппыДоступа);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьОднозначностьПоставляемыхДанных();
	Справочники.ПрофилиГруппДоступа.ОбновитьВспомогательныеДанныеПрофилейИзмененныхПриЗагрузке();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
	ПроверитьОднозначностьПоставляемыхДанных(Истина, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбъектКопирования.Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		Роли.Очистить();
	КонецЕсли;
	
	ИдентификаторПоставляемыхДанных = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ПроверитьОднозначностьПоставляемыхДанных(ПроверкаЗаполнения = Ложь, Отказ = Ложь)
	
	// Проверка однозначности поставляемых данных.
	Если Не ЗначениеЗаполнено(ИдентификаторПоставляемыхДанных) Тогда
		Возврат;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПоставляемыхДанных", ИдентификаторПоставляемыхДанных);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.Ссылка КАК Ссылка,
	|	ПрофилиГруппДоступа.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ИдентификаторПоставляемыхДанных";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 1 Тогда
		
		КраткоеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при записи профиля ""%1"".
			           |Поставляемый профиль уже существует:'"),
			Наименование);
		
		ПодробноеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при записи профиля ""%1"".
			           |Идентификатор поставляемых данных ""%2"" уже используется в профиле:'"),
			Наименование,
			Строка(ИдентификаторПоставляемыхДанных));
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.Ссылка <> Ссылка Тогда
				
				КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки
					+ Символы.ПС + """" + Выборка.Наименование + """.";
				
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки
					+ Символы.ПС + """" + Выборка.Наименование + """ ("
					+ Строка(Выборка.Ссылка.УникальныйИдентификатор())+ ")."
			КонецЕсли;
		КонецЦикла;
		
		Если ПроверкаЗаполнения Тогда
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки,,,, Отказ);
		Иначе
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Управление доступом.Нарушение однозначности поставляемого профиля'",
				     ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли