
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// При изменении подразделения
Процедура ОбновитьСловаПоискаПоПодразделению(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОПользователяхДокументооборот.Пользователь КАК Пользователь,
		|	НЕ Пользователи.ПометкаУдаления
		|		И НЕ Пользователи.Служебный
		|		И НЕ Пользователи.Недействителен
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ПОМЕСТИТЬ ПользователиПодразделений
		|ИЗ
		|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО СведенияОПользователяхДокументооборот.Пользователь = Пользователи.Ссылка
		|ГДЕ
		|	СведенияОПользователяхДокументооборот.Подразделение = &Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсполнителиЗадач.РольИсполнителя.Владелец КАК РольИсполнителя,
		|	МАКСИМУМ(НЕ ИсполнителиЗадач.РольИсполнителя.ПометкаУдаления)
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ПОМЕСТИТЬ РолиПодразделения
		|ИЗ
		|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПользователиПодразделений КАК ПользователиПодразделений
		|		ПО ИсполнителиЗадач.Исполнитель = ПользователиПодразделений.Пользователь
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсполнителиЗадач.РольИсполнителя.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПользователиПодразделений.Пользователь КАК ОбъектПоиска,
		|	ПользователиПодразделений.ИспользоватьВПоиске
		|ИЗ
		|	ПользователиПодразделений КАК ПользователиПодразделений
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РолиПодразделения.РольИсполнителя,
		|	РолиПодразделения.ИспользоватьВПоиске
		|ИЗ
		|	РолиПодразделения КАК РолиПодразделения";
	Запрос.УстановитьПараметр("Подразделение", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Неопределено, "ОбъектДоступа");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Объект.Наименование;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении группы пользователей
Процедура ОбновитьСловаПоискаПоРабочейГруппе(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РабочиеГруппыСостав.Пользователь,
		|	НЕ Пользователи.ПометкаУдаления
		|		И НЕ Пользователи.Служебный
		|		И НЕ Пользователи.Недействителен
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ПОМЕСТИТЬ ПользователиГруппы
		|ИЗ
		|	Справочник.РабочиеГруппы.Состав КАК РабочиеГруппыСостав
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО РабочиеГруппыСостав.Пользователь = Пользователи.Ссылка
		|ГДЕ
		|	РабочиеГруппыСостав.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсполнителиЗадач.РольИсполнителя.Владелец КАК РольИсполнителя,
		|	МАКСИМУМ(НЕ ИсполнителиЗадач.РольИсполнителя.ПометкаУдаления)
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ПОМЕСТИТЬ РолиГруппы
		|ИЗ
		|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПользователиГруппы КАК ПользователиГруппы
		|		ПО ИсполнителиЗадач.Исполнитель = ПользователиГруппы.Пользователь
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсполнителиЗадач.РольИсполнителя.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПользователиГруппы.Пользователь КАК ОбъектПоиска,
		|	ПользователиГруппы.ИспользоватьВПоиске
		|ИЗ
		|	ПользователиГруппы КАК ПользователиГруппы
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РолиГруппы.РольИсполнителя,
		|	РолиГруппы.ИспользоватьВПоиске
		|ИЗ
		|	РолиГруппы КАК РолиГруппы";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Неопределено, "ОбъектДоступа");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Объект.Наименование;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении мероприятия
Процедура ОбновитьСловаПоискаПоМероприятию(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.ПолныеРоли
		|			ТОГДА УчастникиМероприятия.Исполнитель.Владелец
		|		ИНАЧЕ УчастникиМероприятия.Исполнитель
		|	КОНЕЦ КАК ОбъектПоиска,
		|	ВЫБОР
		|		КОГДА УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ УчастникиМероприятия.Исполнитель.ПометкаУдаления
		|			И НЕ УчастникиМероприятия.Исполнитель.Служебный
		|			И НЕ УчастникиМероприятия.Исполнитель.Недействителен
		|			И &ИспользоватьВПоиске
		|		ИНАЧЕ
		|		НЕ УчастникиМероприятия.Исполнитель.ПометкаУдаления
		|		И &ИспользоватьВПоиске
		|	КОНЕЦ КАК ИспользоватьВПоиске
		|ИЗ
		|	РегистрСведений.УчастникиМероприятия КАК УчастникиМероприятия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО УчастникиМероприятия.Исполнитель = Пользователи.Ссылка
		|ГДЕ
		|	УчастникиМероприятия.Мероприятие = &Мероприятие
		|	И (УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.Пользователи
		|	ИЛИ УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.ПолныеРоли)
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.ПолныеРоли
		|			ТОГДА УчастникиМероприятия.Исполнитель.Владелец
		|		ИНАЧЕ УчастникиМероприятия.Исполнитель
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА УчастникиМероприятия.Исполнитель ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ УчастникиМероприятия.Исполнитель.ПометкаУдаления
		|			И НЕ УчастникиМероприятия.Исполнитель.Служебный
		|			И НЕ УчастникиМероприятия.Исполнитель.Недействителен
		|			И &ИспользоватьВПоиске
		|		ИНАЧЕ
		|		НЕ УчастникиМероприятия.Исполнитель.ПометкаУдаления
		|		И &ИспользоватьВПоиске
		|	КОНЕЦ";
	Запрос.УстановитьПараметр("Мероприятие", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "ОбъектДоступа");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.ОбъектДоступа = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Объект.Наименование;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении проекта
Процедура ОбновитьСловаПоискаПоПроекту(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.ПолныеРоли
		|			ТОГДА ПроектыПроектнаяКоманда.Исполнитель.Владелец
		|		ИНАЧЕ ПроектыПроектнаяКоманда.Исполнитель
		|	КОНЕЦ КАК ОбъектПоиска,
		|	ВЫБОР
		|		КОГДА ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ ПроектыПроектнаяКоманда.Исполнитель.ПометкаУдаления
		|			И НЕ ПроектыПроектнаяКоманда.Исполнитель.Служебный
		|			И НЕ ПроектыПроектнаяКоманда.Исполнитель.Недействителен
		|			И &ИспользоватьВПоиске
		|		ИНАЧЕ
		|		НЕ ПроектыПроектнаяКоманда.Исполнитель.ПометкаУдаления
		|		И &ИспользоватьВПоиске
		|	КОНЕЦ КАК ИспользоватьВПоиске
		|ИЗ
		|	Справочник.Проекты.ПроектнаяКоманда КАК ПроектыПроектнаяКоманда
		|ГДЕ
		|	(ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.Пользователи
		|	ИЛИ ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.ПолныеРоли)
		|	И ПроектыПроектнаяКоманда.Ссылка = &Проект
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.ПолныеРоли
		|			ТОГДА ПроектыПроектнаяКоманда.Исполнитель.Владелец
		|		ИНАЧЕ ПроектыПроектнаяКоманда.Исполнитель
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПроектыПроектнаяКоманда.Исполнитель ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ ПроектыПроектнаяКоманда.Исполнитель.ПометкаУдаления
		|			И НЕ ПроектыПроектнаяКоманда.Исполнитель.Служебный
		|			И НЕ ПроектыПроектнаяКоманда.Исполнитель.Недействителен
		|			И &ИспользоватьВПоиске
		|		ИНАЧЕ
		|		НЕ ПроектыПроектнаяКоманда.Исполнитель.ПометкаУдаления
		|		И &ИспользоватьВПоиске
		|	КОНЕЦ";
	Запрос.УстановитьПараметр("Проект", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "ОбъектДоступа");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.ОбъектДоступа = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Объект.Наименование;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении пользователя
Процедура ОбновитьСловаПоискаПоПользователю(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	СтрокиДляПоиска.Добавить(Объект.ПредставлениеВДокументах);
	СтрокиДляПоиска.Добавить(Объект.ПредставлениеВПереписке);
	СтрокиДляПоиска.Добавить(Объект.ПредставлениеВПерепискеСРангом);
	
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = 
		НЕ Объект.ПометкаУдаления И НЕ Объект.Служебный И НЕ Объект.Недействителен;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении должности
Процедура ОбновитьСловаПоискаПоДолжности(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОПользователяхДокументооборот.Пользователь КАК ОбъектПоиска,
		|	НЕ Пользователи.ПометкаУдаления
		|		И НЕ Пользователи.Служебный
		|		И НЕ Пользователи.Недействителен
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ИЗ
		|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО СведенияОПользователяхДокументооборот.Пользователь = Пользователи.Ссылка
		|ГДЕ
		|	СведенияОПользователяхДокументооборот.Должность = &Должность";
	Запрос.УстановитьПараметр("Должность", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	ОбъектыПоиска.ЗаполнитьЗначения(Неопределено, "ОбъектДоступа");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении роли
Процедура ОбновитьСловаПоискаПоРоли(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении Контрагента
Процедура ОбновитьСловаПоискаПоКонтрагенту(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактныеЛица.Ссылка КАК ОбъектПоиска,
		|	НЕ КонтактныеЛица.ПометкаУдаления
		|		И &ИспользоватьВПоиске КАК ИспользоватьВПоиске
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|ГДЕ
		|	КонтактныеЛица.Владелец = &Контрагент";
	Запрос.УстановитьПараметр("Контрагент", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", Не Объект.ПометкаУдаления);
	
	ОбъектыПоиска = Запрос.Выполнить().Выгрузить();
	
	ОбъектыПоиска.Колонки.Добавить("Слово");
	ОбъектыПоиска.Колонки.Добавить("ОбъектДоступа");
	ОбъектыПоиска.Колонки.Добавить("КритерийПоиска");
	
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Наименование, "Слово");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "ОбъектДоступа");
	ОбъектыПоиска.ЗаполнитьЗначения(Объект.Ссылка, "КритерийПоиска");
	
	НаборЗаписей.Загрузить(ОбъектыПоиска);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.ОбъектДоступа = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении Контактного лица
Процедура ОбновитьСловаПоискаПоКонтактномуЛицу(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ОбъектДоступа = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении личного адресата
Процедура ОбновитьСловаПоискаПоЛичномуАдресату(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ОбъектДоступа = Объект.Пользователь;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// При изменении критерия использования в поиске
Процедура ОбновитьДоступностьВПоиске(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Пользователи") Тогда
		ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления
			И НЕ Объект.Служебный
			И НЕ Объект.Недействителен;
	Иначе
		ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	КонецЕсли;
	
	// Обновление по критерию поиска.
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПоискВАдреснойКниге");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("КритерийПоиска", Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоискВАдреснойКниге.ОбъектПоиска КАК ОбъектПоиска,
		|	ПоискВАдреснойКниге.КритерийПоиска КАК КритерийПоиска,
		|	ПоискВАдреснойКниге.Слово КАК Слово,
		|	ПоискВАдреснойКниге.ОбъектДоступа КАК ОбъектДоступа,
		|	ВЫБОР
		|		КОГДА ПоискВАдреснойКниге.ОбъектПоиска ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ ПоискВАдреснойКниге.ОбъектПоиска.ПометкаУдаления
		|					И НЕ ПоискВАдреснойКниге.ОбъектПоиска.Служебный
		|					И НЕ ПоискВАдреснойКниге.ОбъектПоиска.Недействителен
		|					И &ИспользоватьВПоиске
		|		ИНАЧЕ НЕ ПоискВАдреснойКниге.ОбъектПоиска.ПометкаУдаления
		|				И &ИспользоватьВПоиске
		|	КОНЕЦ КАК ИспользоватьВПоиске
		|ИЗ
		|	РегистрСведений.ПоискВАдреснойКниге КАК ПоискВАдреснойКниге
		|ГДЕ
		|	ПоискВАдреснойКниге.КритерийПоиска = &КритерийПоиска";
	Запрос.УстановитьПараметр("КритерийПоиска", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", ИспользоватьВПоиске);
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
		НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	// Обновление по объекту поиска.
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПоискВАдреснойКниге");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("КритерийПоиска", Объект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоискВАдреснойКниге.ОбъектПоиска КАК ОбъектПоиска,
		|	ПоискВАдреснойКниге.КритерийПоиска КАК КритерийПоиска,
		|	ПоискВАдреснойКниге.Слово КАК Слово,
		|	ПоискВАдреснойКниге.ОбъектДоступа КАК ОбъектДоступа,
		|	ВЫБОР
		|		КОГДА ПоискВАдреснойКниге.КритерийПоиска ССЫЛКА Справочник.Пользователи
		|			ТОГДА НЕ ПоискВАдреснойКниге.КритерийПоиска.ПометкаУдаления
		|					И НЕ ПоискВАдреснойКниге.КритерийПоиска.Служебный
		|					И НЕ ПоискВАдреснойКниге.КритерийПоиска.Недействителен
		|					И &ИспользоватьВПоиске
		|		ИНАЧЕ НЕ ПоискВАдреснойКниге.КритерийПоиска.ПометкаУдаления
		|				И &ИспользоватьВПоиске
		|	КОНЕЦ КАК ИспользоватьВПоиске
		|ИЗ
		|	РегистрСведений.ПоискВАдреснойКниге КАК ПоискВАдреснойКниге
		|ГДЕ
		|	ПоискВАдреснойКниге.ОбъектПоиска = &ОбъектПоиска";
	Запрос.УстановитьПараметр("ОбъектПоиска", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИспользоватьВПоиске", ИспользоватьВПоиске);
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектПоиска.Установить(Объект.Ссылка);
		НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;	
	
КонецПроцедуры

// При изменении Организации
Процедура ОбновитьСловаПоискаПоОрганизации(Объект) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или Не ОбщегоНазначения.СсылкаСуществует(Объект.Ссылка) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КритерийПоиска.Установить(Объект.Ссылка);
	
	СтрокиДляПоиска = Объект.КонтактнаяИнформация.ВыгрузитьКолонку("Представление");
	
	СтрокиДляПоиска.Добавить(Объект.Наименование);
	
	КоличествоСтрок = СтрокиДляПоиска.Количество();
	Для Индекс = 1 По КоличествоСтрок Цикл
		ОбратныйИндекс = КоличествоСтрок - Индекс;
		Если ПустаяСтрока(СтрокиДляПоиска[ОбратныйИндекс]) Тогда
			СтрокиДляПоиска.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	
	Слово = СтрСоединить(СтрокиДляПоиска, "~");
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ОбъектПоиска = Объект.Ссылка;
	НоваяЗапись.КритерийПоиска = Объект.Ссылка;
	НоваяЗапись.ИспользоватьВПоиске = НЕ Объект.ПометкаУдаления;
	НоваяЗапись.Слово = Слово;
	
	НаборЗаписей.Записать();	

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет заполнение слов поиска в регистре для всех объектов адр. книги. 
//
Процедура ЗаполнитьСловаПоиска() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Подразделение = Справочники.СтруктураПредприятия.ВыбратьИерархически();
	Пока Подразделение.Следующий() Цикл
		ОбновитьСловаПоискаПоПодразделению(Подразделение);
	КонецЦикла;
	
	РабочиеГруппы = Справочники.РабочиеГруппы.ВыбратьИерархически();
	Пока РабочиеГруппы.Следующий() Цикл
		ОбновитьСловаПоискаПоРабочейГруппе(РабочиеГруппы);
	КонецЦикла;
	
	Мероприятия = Справочники.Мероприятия.ВыбратьИерархически();
	Пока Мероприятия.Следующий() Цикл
		Если Мероприятия.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		ОбновитьСловаПоискаПоМероприятию(Мероприятия);
	КонецЦикла;
	
	Проекты = Справочники.Проекты.ВыбратьИерархически();
	Пока Проекты.Следующий() Цикл
		Если Проекты.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		ОбновитьСловаПоискаПоПроекту(Проекты);
	КонецЦикла;
	
	ВсеПользователи = Справочники.Пользователи.Выбрать();
	Пока ВсеПользователи.Следующий() Цикл
		ОбновитьСловаПоискаПоПользователю(ВсеПользователи);
	КонецЦикла;
	
	Должности = Справочники.Должности.Выбрать();
	Пока Должности.Следующий() Цикл
		ОбновитьСловаПоискаПоДолжности(Должности);
	КонецЦикла;
	
	ВсеРоли = Справочники.РолиИсполнителей.Выбрать();
	Пока ВсеРоли.Следующий() Цикл
		ОбновитьСловаПоискаПоРоли(ВсеРоли);
	КонецЦикла;
	
	Контрагенты = Справочники.Контрагенты.ВыбратьИерархически();
	Пока Контрагенты.Следующий() Цикл
		Если Контрагенты.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		ОбновитьСловаПоискаПоКонтрагенту(Контрагенты);
	КонецЦикла;
	
	КонтактныеЛица = Справочники.КонтактныеЛица.Выбрать();
	Пока КонтактныеЛица.Следующий() Цикл
		ОбновитьСловаПоискаПоКонтактномуЛицу(КонтактныеЛица);
	КонецЦикла;
	
	ЛичныеАдресаты = Справочники.ЛичныеАдресаты.Выбрать();
	Пока ЛичныеАдресаты.Следующий() Цикл
		ОбновитьСловаПоискаПоЛичномуАдресату(ЛичныеАдресаты);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

