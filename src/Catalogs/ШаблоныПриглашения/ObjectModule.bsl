#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;

	Если Исполнители.Количество() = 0 Тогда
		МассивПолей.Добавить("Исполнители");
	КонецЕсли;	
	
	Возврат МассивПолей;
	
КонецФункции	

//Формирует текстовое представление бизнес-процесса, создаваемого по шаблону
Функция СформироватьСводкуПоШаблону() Экспорт
	
	Результат = ШаблоныБизнесПроцессов.ПолучитьОбщуюЧастьОписанияШаблона(Ссылка);
		
	Если ЗначениеЗаполнено(НаименованиеБизнесПроцесса) Тогда
		Результат = Результат + НСтр("ru = 'Заголовок'") + ": " + НаименованиеБизнесПроцесса + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Описание) Тогда
		Результат = Результат + НСтр("ru = 'Описание'") + ": " + Описание + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Важность) Тогда
		Результат = Результат + НСтр("ru = 'Важность'") + ": " + Строка(Важность) + Символы.ПС;
	КонецЕсли;
	
	Если Исполнители.Количество() > 0 Тогда
		Результат = Результат + НСтр("ru = 'Согласующие'") + ": ";
		Для Каждого Исполнитель Из Исполнители Цикл
			Результат = Результат + Исполнитель.Исполнитель
				+ ";" + Символы.ПС;
		КонецЦикла;
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 2);
		Результат = Результат + Символы.ПС;
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(ЭтотОбъект);
	ДлительностьПроцессаСтрокой = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
		ДлительностьПроцесса.СрокИсполненияПроцессаДни,
		ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
		ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
	Если ЗначениеЗаполнено(ДлительностьПроцессаСтрокой) Тогда
		Результат = Результат + Нстр("ru = 'Срок'") + ": "
			+ ДлительностьПроцессаСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Заполняет предопределенный шаблон по умолчанию.
// Предназначена для вызова из предопределенного объекта.
// Если объект не предопределенный, то вызов процедуры приведет к исключению.
//
Процедура ЗаполнитьШаблонПоУмолчанию() Экспорт
	
	Если Ссылка <> Справочники.ШаблоныПриглашения.ПоУмолчанию Тогда
		ВызватьИсключение НСтр("ru = 'Процедура ЗаполнитьШаблонПоУмолчанию предназначена для вызова из предопределенного шаблона.'");
	КонецЕсли;
	
	Автор = Справочники.Пользователи.ПустаяСсылка();
	Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	ВариантУстановкиСрокаОбработкиРезультатов = Перечисления.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок;
	ВладелецШаблона = Неопределено;
	ДобавлятьНаименованиеПредмета = Истина;
	ИспользоватьУсловия = Ложь;
	ИсходныйШаблон = Справочники.ШаблоныПриглашения.ПустаяСсылка();
	КоличествоИтераций = 1;
	Комментарий = "";
	КомплексныйПроцесс = БизнесПроцессы.КомплексныйПроцесс.ПустаяСсылка();
	НаименованиеБизнесПроцесса = "";
	Наименование = НСтр("ru = 'По умолчанию'");
	Описание = "";
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	Если Не Пользователи.ЭтоПолноправныйПользователь(Ответственный) Тогда
		Ответственный = Пользователи.СсылкаНеуказанногоПользователя(Истина);
	КонецЕсли;
	
	ПодписыватьЭП = Ложь;
	
	СрокИсполненияПроцесса = Дата(1,1,1);
	
	СрокОбработкиРезультатов = Дата(1,1,1);
	СрокОбработкиРезультатовДни = 0;
	СрокОбработкиРезультатовМинуты = 0;
	СрокОбработкиРезультатовЧасы = 0;
	
	СрокОтложенногоСтарта = 0;
	
	ТрудозатратыПланАвтора = 0;
	ТрудозатратыПланИсполнителя = 0;
	
	ШаблонВКомплексномПроцессе = Ложь;
	
	Исполнители.Очистить();
	Предметы.Очистить();
	ПредметыЗадач.Очистить();
	УсловияЗапретаВыполнения.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаМеханизмаОтсутствий

// Получает исполнителей
Функция ПолучитьИсполнителей() Экспорт
	
	МассивИсполнителей = Новый Массив;
	
	Для Каждого СтрокаИсполнитель Из Исполнители Цикл
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(СтрокаИсполнитель.Исполнитель);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЦикла;
	
	Возврат МассивИсполнителей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ШаблоныБизнесПроцессов.НачальноеЗаполнениеШаблона(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныБизнесПроцессов.ШаблонПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Ссылка <> Справочники.ШаблоныПриглашения.ПоУмолчанию Тогда
		ПроверяемыеРеквизиты.Добавить("НаименованиеБизнесПроцесса");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли