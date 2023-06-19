#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// Переопределение для целей избранного - вместо карточки с настройками размещения отчета будет открываться его основная форма.
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СсылкаЗаписиКалендаря = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Ключ");
		Если Не ЗначениеЗаполнено(СсылкаЗаписиКалендаря) Тогда
			Возврат;
		КонецЕсли;
		
		РеквизитыЗаписиКалендаря = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаЗаписиКалендаря, "Связанная, Предмет");
		Если Не РеквизитыЗаписиКалендаря.Связанная Тогда
			Возврат;
		КонецЕсли;
		
		ТипПредмета = ТипЗнч(РеквизитыЗаписиКалендаря.Предмет);
		Если ТипПредмета = Тип("СправочникСсылка.Мероприятия") Тогда
			СтандартнаяОбработка = Ложь;
			Параметры.Ключ = РеквизитыЗаписиКалендаря.Предмет;
			ВыбраннаяФорма = Метаданные.Справочники.Мероприятия.Формы.ФормаЭлемента;
		ИначеЕсли ТипПредмета = Тип("ДокументСсылка.Отсутствие") Тогда
			СтандартнаяОбработка = Ложь;
			Параметры.Ключ = РеквизитыЗаписиКалендаря.Предмет;
			ВыбраннаяФорма = Метаданные.Документы.Отсутствие.Формы.ФормаДокумента;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ПраваДоступа

// Возвращает наименования реквизитов, необходимых для определения прав доступа.
//
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, Автор, Пользователь, Связанная, Предмет";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ТипПредмета = ТипЗнч(ОбъектДоступа.Предмет);
	
	СтрокиПротокола = Новый Массив;
	
	Если ОбъектДоступа.Связанная И ТипПредмета = Тип("СправочникСсылка.Мероприятия") Тогда
		
		ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаОтВладельца(
			ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Предмет);
			
		СтрокиПротокола.Добавить("Права мероприятия");
			
	ИначеЕсли ОбъектДоступа.Связанная И ТипПредмета = Тип("ДокументСсылка.Отсутствие") Тогда
		
		ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
			ОбъектДоступа, ТаблицаДескрипторов, Справочники.РабочиеГруппы.ВсеПользователи, Ложь);
		
		СтрокиПротокола.Добавить("Права отсутствия");
		
	Иначе
		
		Если ЗначениеЗаполнено(ОбъектДоступа.Автор) Тогда
			
			ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
				ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Автор, Истина);
				
			СтрокиПротокола.Добавить("Автор");
				
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОбъектДоступа.Пользователь) Тогда
			
			ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
				ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Пользователь, Истина);
			
			СтрокиПротокола.Добавить("Пользователь");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПротоколРасчетаПрав <> Неопределено Тогда
		
		Для Каждого СтрПротокола Из СтрокиПротокола Цикл
			
			Если СтрПротокола = "Права мероприятия" Тогда
				ЗаписьПротокола = Новый Структура("Элемент, Описание",
					ОбъектДоступа.Предмет, НСтр("ru = 'Права мероприятия'"));
			ИначеЕсли СтрПротокола = "Права отсутствия" Тогда
				ЗаписьПротокола = Новый Структура("Элемент, Описание",
					ОбъектДоступа.Предмет, НСтр("ru = 'Права на документ ""Отсутсвтие""'"));
			ИначеЕсли СтрПротокола = "Автор" Тогда
				ЗаписьПротокола = Новый Структура("Элемент, Описание",
					ОбъектДоступа.Автор, НСтр("ru = 'Автор'"));
			ИначеЕсли СтрПротокола = "Пользователь" Тогда
				ЗаписьПротокола = Новый Структура("Элемент, Описание",
					ОбъектДоступа.Пользователь, НСтр("ru = 'Пользователь записи календаря'"));
			КонецЕсли;
			
			ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Процедура формирования печатной формы.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Карточка", "Карточка записи календаря", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			, "Справочник.ЗаписиРабочегоКалендаря.ПФ_MXL_Карточка");
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует печатную форму карточки записи календаря.
//
Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ЗаписиКалендаря = ПараметрыПечати.ЗаписиКалендаря;
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_Карточка";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаписиРабочегоКалендаря.Ссылка,
		|	ЗаписиРабочегоКалендаря.Наименование,
		|	ЗаписиРабочегоКалендаря.Пользователь,
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ВесьДень,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.Предмет,
		|	ЗаписиРабочегоКалендаря.Описание
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Формирует массив реквизитов записей календаря и сортируем его по дате начала.
	ТаблицаРеквизитовЗаписейКалендаря = Новый ТаблицаЗначений;
	ТаблицаРеквизитовЗаписейКалендаря.Колонки.Добавить("Реквизиты");
	ТаблицаРеквизитовЗаписейКалендаря.Колонки.Добавить("ДатаНачала");
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.Событие
			Или Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия Тогда
			
			РеквизитыЗаписиКалендаря = Справочники.ЗаписиРабочегоКалендаря.ПолучитьСтруктуруРеквизитовЗаписиКалендаря();
			ЗаполнитьЗначенияСвойств(РеквизитыЗаписиКалендаря, Выборка);
			НоваяСтрока = ТаблицаРеквизитовЗаписейКалендаря.Добавить();
			НоваяСтрока.Реквизиты = РеквизитыЗаписиКалендаря;
			НоваяСтрока.ДатаНачала = РеквизитыЗаписиКалендаря.ДатаНачала;
			
		ИначеЕсли Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие Тогда
			
			ЗаписьКалендаряОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Для Каждого ЗаписьКалендаря Из ЗаписиКалендаря Цикл
				Если Выборка.Ссылка = ЗаписьКалендаря.Ссылка Тогда
					ДатаНачала = Неопределено;
					ЗаписьКалендаря.Свойство("ДатаНачала", ДатаНачала);
					РеквизитыЗаписиКалендаря = ЗаписьКалендаряОбъект.ПолучитьРеквизитыЗаписиКалендаря(ДатаНачала);
					НоваяСтрока = ТаблицаРеквизитовЗаписейКалендаря.Добавить();
					НоваяСтрока.Реквизиты = РеквизитыЗаписиКалендаря;
					НоваяСтрока.ДатаНачала = РеквизитыЗаписиКалендаря.ДатаНачала;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	ТаблицаРеквизитовЗаписейКалендаря.Сортировать("ДатаНачала");
	МассивРеквизитовЗаписейКалендаря = ТаблицаРеквизитовЗаписейКалендаря.ВыгрузитьКолонку("Реквизиты");
	
	// Получение областей макета 
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ЗаписиРабочегоКалендаря.ПФ_MXL_Карточка");
	ОбластьЗаписьКалендаря = Макет.ПолучитьОбласть("ЗаписьКалендаря");
	ОбластьПредмет = Макет.ПолучитьОбласть("Предмет");
	ОбластьПовторять = Макет.ПолучитьОбласть("Повторять");
	ОбластьРеквизитыМероприятия = Макет.ПолучитьОбласть("РеквизитыМероприятия");
	
	ПервыйДокумент = Истина;
	Для Каждого РеквизитыЗаписиКалендаря Из МассивРеквизитовЗаписейКалендаря Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Вывод записи календаря
		ОбластьЗаписьКалендаря.Параметры.Заполнить(РеквизитыЗаписиКалендаря);
		ОбластьЗаписьКалендаря.Параметры.Наименование =
			РаботаСРабочимКалендаремКлиентСервер.ВыделитьПервуюСтрокуОписания(РеквизитыЗаписиКалендаря.Описание);
		ОбластьЗаписьКалендаря.Параметры.Дата =
			РаботаСРабочимКалендаремКлиентСервер.ПолучитьПредставлениеДаты(
				РеквизитыЗаписиКалендаря.ДатаНачала,
				РеквизитыЗаписиКалендаря.ДатаОкончания, 
				РеквизитыЗаписиКалендаря.ВесьДень);
		ОбластьЗаписьКалендаря.Параметры.Пользователь = "(" + РеквизитыЗаписиКалендаря.Пользователь + ")";
		ТабличныйДокумент.Вывести(ОбластьЗаписьКалендаря);
		
		// Вывод повторения
		Если ЗначениеЗаполнено(РеквизитыЗаписиКалендаря.Повторять) Тогда
			ОбластьПовторять.Параметры.Повторять = РеквизитыЗаписиКалендаря.Повторять;
			ТабличныйДокумент.Вывести(ОбластьПовторять);
		КонецЕсли;
		
		// Вывод предмета
		Если ЗначениеЗаполнено(РеквизитыЗаписиКалендаря.Предмет) Тогда
			
			ПредставлениеПредмета = РаботаСРабочимКалендаремСервер.ПолучитьПредставлениеПредмета(РеквизитыЗаписиКалендаря.Предмет);
			Если ЗначениеЗаполнено(ПредставлениеПредмета) Тогда
				
				ОбластьПредмет.Параметры.Предмет = ПредставлениеПредмета;
				ТабличныйДокумент.Вывести(ОбластьПредмет);
				
				// Вывод мероприятия
				Если ТипЗнч(РеквизитыЗаписиКалендаря.Предмет) = Тип("СправочникСсылка.Мероприятия") Тогда
					РеквизитыМероприятия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыЗаписиКалендаря.Предмет, "ВидМероприятия, МестоПроведения, Организатор");
					ОбластьРеквизитыМероприятия.Параметры.Заполнить(РеквизитыМероприятия);
					ТабличныйДокумент.Вывести(ОбластьРеквизитыМероприятия);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, РеквизитыЗаписиКалендаря.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

// Формирует HTML представление записи календаря.
//
Функция СформироватьHTMLПредставление(ЗаписьКалендаря, ДатаЗаписи) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗаписьКалендаря)
		ИЛИ ТипЗнч(ЗаписьКалендаря) <> Тип("СправочникСсылка.ЗаписиРабочегоКалендаря") Тогда
		Возврат РаботаСРабочимКалендаремКлиентСервер.ПолучитьПустоеHTMLПредставление();
	КонецЕсли;
	
	ЗаписьКалендаряОбъект = ЗаписьКалендаря.ПолучитьОбъект();
	РеквизитыЗаписиКалендаря = ЗаписьКалендаряОбъект.ПолучитьРеквизитыЗаписиКалендаря(ДатаЗаписи);
	
	Если НЕ ЗначениеЗаполнено(РеквизитыЗаписиКалендаря) Тогда
		Возврат РаботаСРабочимКалендаремКлиентСервер.ПолучитьПустоеHTMLПредставление();
	КонецЕсли;
	
	ТекстТема =
		РаботаСРабочимКалендаремКлиентСервер.ВыделитьПервуюСтрокуОписания(РеквизитыЗаписиКалендаря.Описание);
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстТема);
	Если РеквизитыЗаписиКалендаря.Пользователь <> ПользователиКлиентСервер.ТекущийПользователь() Тогда
		ТекстПользователь = Строка(РеквизитыЗаписиКалендаря.Пользователь);
	Иначе
		ТекстПользователь = "";
	КонецЕсли;
	ТекстВремя = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ=ЧЧ:мм") + " - "
		+ Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ=ЧЧ:мм");
	ТекстДата = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг'");
	Если РеквизитыЗаписиКалендаря.ВесьДень Тогда
		ТекстДатаНачала = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг'");
		ТекстДатаОкончания = Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ='дддд, д ММММ гггг'");
	Иначе
		ТекстДатаНачала = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг ЧЧ:мм'");
		ТекстДатаОкончания = Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ='дддд, д ММММ гггг ЧЧ:мм'");
	КонецЕсли;
	ТекстПовторять = РеквизитыЗаписиКалендаря.Повторять;
	ТекстПредмет = РаботаС_HTML.ПолучитьСсылкуНаПредмет(РеквизитыЗаписиКалендаря.Предмет);
	
	ТекстОписание = СтрЗаменить(
		РаботаС_HTML.ЗаменитьСпецСимволыHTML(РеквизитыЗаписиКалендаря.Описание), Символы.ПС, "<br>");
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстОписание);
	
	ПредставлениеHTML =
		"<html><body topmargin=0 scroll=auto>
		|<div style='font-size=14pt;font-family=Arial;line-height:150%'>
		|<b>[Тема]</b>
		|</div>
		|<div style='font-size=12pt;font-family=Arial;top-margin:10px'>
		|<b>[НадписьПользователь]:</b> [Пользователь]<br>
		|<b>[НадписьВремя]:</b> [Время]<br>
		|<b>[НадписьДата]:</b> [Дата]<br>
		|<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>
		|<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>
		|<b>[НадписьПовторять]:</b> [Повторять]<br>
		|<b>[НадписьПредмет]:</b> [Предмет]<br>
		|</div>
		|<hr>
		|<div style='font-size=12pt;font-family=Arial'>
		|[Описание]
		|</div>
		|</body></html>";
	
	Если НачалоДня(РеквизитыЗаписиКалендаря.ДатаОкончания) - НачалоДня(РеквизитыЗаписиКалендаря.ДатаНачала) <> 0 Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьВремя]:</b> [Время]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДата]:</b> [Дата]<br>", "");
	ИначеЕсли РеквизитыЗаписиКалендаря.ВесьДень Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьВремя]:</b> [Время]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>", "");
	Иначе
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>", "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекстПовторять) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПовторять]:</b> [Повторять]<br>", "");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекстПредмет) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПредмет]:</b> [Предмет]<br>", "");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекстПользователь) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПользователь]:</b> [Пользователь]<br>", "");
	КонецЕсли;
	
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПользователь]", НСтр("ru = 'Пользователь'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьВремя]", НСтр("ru = 'Время'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДата]", НСтр("ru = 'Дата'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДатаНачала]", НСтр("ru = 'Дата начала'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДатаОкончания]", НСтр("ru = 'Дата окончания'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПовторять]", НСтр("ru = 'Повторять'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПредмет]", НСтр("ru = 'Предмет'"));
	
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Пользователь]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстПользователь));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Время]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстВремя));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Дата]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДата));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[ДатаНачала]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДатаНачала));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[ДатаОкончания]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДатаОкончания));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Повторять]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстПовторять));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Тема]", ТекстТема);
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Описание]", ТекстОписание);
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Предмет]", ТекстПредмет);
	
	Возврат ПредставлениеHTML;
	
КонецФункции

// Возвращает таблицу занятости пользователей.
//
Функция ПолучитьТаблицуЗанятости(Знач МассивПользователей, ДатаНачала, ДатаОкончания, ИсключенияЗанятости) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(МассивПользователей) = Тип("СправочникСсылка.Пользователи") Тогда
		Пользователь = МассивПользователей;
		МассивПользователей = Новый Массив;
		МассивПользователей.Добавить(Пользователь);
	КонецЕсли;
	
	Если ИсключенияЗанятости = Неопределено Тогда
		МассивИсключенийЗанятости = Новый Массив;
	ИначеЕсли ТипЗнч(ИсключенияЗанятости) = Тип("Массив") Тогда
		СвязанныеЗаписиКалендаря =
			Справочники.ЗаписиРабочегоКалендаря.СвязанныеЗаписиКалендаря(ИсключенияЗанятости);
		МассивИсключенийЗанятости = СвязанныеЗаписиКалендаря.ВыгрузитьКолонку("Ссылка");
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивИсключенийЗанятости, ИсключенияЗанятости, Истина);
	Иначе
		СвязанныеЗаписиКалендаря =
			Справочники.ЗаписиРабочегоКалендаря.СвязанныеЗаписиКалендаря(ИсключенияЗанятости);
		МассивИсключенийЗанятости = СвязанныеЗаписиКалендаря.ВыгрузитьКолонку("Ссылка");
		МассивИсключенийЗанятости.Добавить(ИсключенияЗанятости);
	КонецЕсли;
	
	ТаблицаЗанятости = Новый ТаблицаЗначений;
	ТаблицаЗанятости.Колонки.Добавить("Пользователь");
	ТаблицаЗанятости.Колонки.Добавить("ДатаНачала");
	ТаблицаЗанятости.Колонки.Добавить("ДатаОкончания");
	ТаблицаЗанятости.Колонки.Добавить("Занят");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.Пользователь КАК Пользователь,
		|	ЗаписиРабочегоКалендаря.ДатаНачала КАК ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания КАК ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.Состояние КАК Состояние,
		|	ЗаписиРабочегоКалендаря.Связанная КАК Связанная,
		|	ЗаписиРабочегоКалендаря.Предмет КАК Предмет,
		|	ЗаписиРабочегоКалендаря.ВесьДень КАК ВесьДень
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаНачала < &ДатаОкончания
		|	И ЗаписиРабочегоКалендаря.ДатаОкончания > &ДатаНачала
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|			ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря <> ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)";
	
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ИсключенияЗанятости", МассивИсключенийЗанятости);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаЗанятости.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если Выборка.Связанная
			И Не Выборка.ВесьДень
			И (ТипЗнч(Выборка.Предмет) = Тип("СправочникСсылка.Мероприятия")
				Или ТипЗнч(Выборка.Предмет) = Тип("ДокументСсылка.Отсутствие")) Тогда
			
			НоваяСтрока.ДатаНачала = РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(Выборка.ДатаНачала);
			НоваяСтрока.ДатаОкончания = РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(Выборка.ДатаОкончания);
			
		ИначеЕсли Не Выборка.Связанная И Не Выборка.ВесьДень Тогда
			
			НоваяСтрока.ДатаНачала = 
				РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
					РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
						Выборка.ДатаНачала,
						Выборка.Пользователь));
			НоваяСтрока.ДатаОкончания = 
				РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
					РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
						Выборка.ДатаОкончания,
						Выборка.Пользователь));
			
		КонецЕсли;
		
		НоваяСтрока.Занят = ПолучитьСоответствующееСостояниеЗанятости(
			Выборка.Состояние,
			Выборка.Связанная,
			Выборка.Предмет);
		
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ИсключенияПовторения.(
		|		ДатаИсключения,
		|		ЗаписьИсключения
		|	) КАК ИсключенияПовторения,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДням.(
		|		ДеньНедели,
		|		НомерВхождения
		|	) КАК ПовторениеПоДням,
		|	ЗаписиРабочегоКалендаря.ДатаНачалаПовторения,
		|	ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения,
		|	ЗаписиРабочегоКалендаря.ИнтервалПовторения,
		|	ЗаписиРабочегоКалендаря.КоличествоПовторов,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДнямМесяца,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоМесяцам,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря КАК ТипЗаписиКалендаря1,
		|	ЗаписиРабочегоКалендаря.ЧастотаПовторения,
		|	ЗаписиРабочегоКалендаря.Состояние,
		|	ЗаписиРабочегоКалендаря.Пользователь,
		|	ЗаписиРабочегоКалендаря.Связанная,
		|	ЗаписиРабочегоКалендаря.Предмет
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения >= &ДатаНачала
		|	И ЗаписиРабочегоКалендаря.ДатаНачалаПовторения < &ДатаОкончания
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|			ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря = ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ИсключенияПовторения.(
		|		ДатаИсключения,
		|		ЗаписьИсключения
		|	),
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДням.(
		|		ДеньНедели,
		|		НомерВхождения
		|	),
		|	ЗаписиРабочегоКалендаря.ДатаНачалаПовторения,
		|	ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения,
		|	ЗаписиРабочегоКалендаря.ИнтервалПовторения,
		|	ЗаписиРабочегоКалендаря.КоличествоПовторов,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДнямМесяца,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоМесяцам,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ЧастотаПовторения,
		|	ЗаписиРабочегоКалендаря.Состояние,
		|	ЗаписиРабочегоКалендаря.Пользователь,
		|	ЗаписиРабочегоКалендаря.Связанная,
		|	ЗаписиРабочегоКалендаря.Предмет
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения = ДАТАВРЕМЯ(1, 1, 1)
		|	И ЗаписиРабочегоКалендаря.ДатаНачалаПовторения < &ДатаОкончания
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|			ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря = ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)";
	
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ИсключенияЗанятости", МассивИсключенийЗанятости);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПроверяемаяДата = НачалоДня(ДатаНачала);
		Пока ПроверяемаяДата < ДатаОкончания Цикл
			
			СтруктураПравилаПовторения = РаботаСРабочимКалендаремСервер.ПолучитьСтруктуруПравилаПовторения();
			ЗаполнитьЗначенияСвойств(СтруктураПравилаПовторения, Выборка);
			СтруктураПравилаПовторения.ИсключенияПовторения = Выборка.ИсключенияПовторения.Выгрузить();
			СтруктураПравилаПовторения.ПовторениеПоДням = Выборка.ПовторениеПоДням.Выгрузить();
			
			Если РаботаСРабочимКалендаремСервер.ДатаУдовлетворяетПравилуПовторения(
					ПроверяемаяДата, СтруктураПравилаПовторения) Тогда
				
				ДатаНачалаПоПравилуПовторения = НачалоДня(ПроверяемаяДата) + (Выборка.ДатаНачала - НачалоДня(Выборка.ДатаНачала));
				ДатаОкончанияПоПравилуПовторения = НачалоДня(ПроверяемаяДата) + (Выборка.ДатаОкончания - НачалоДня(Выборка.ДатаНачала));
				Если ДатаНачалаПоПравилуПовторения < ДатаОкончания
					И ДатаОкончанияПоПравилуПовторения > ДатаНачала Тогда
					
					НоваяСтрока = ТаблицаЗанятости.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
					
					НоваяСтрока.ДатаНачала = 
						РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
							РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
								ДатаНачалаПоПравилуПовторения,
								Выборка.Пользователь));
					НоваяСтрока.ДатаОкончания = 
						РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
							РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
								ДатаОкончанияПоПравилуПовторения,
								Выборка.Пользователь));
					
					НоваяСтрока.Занят = ПолучитьСоответствующееСостояниеЗанятости(
						Выборка.Состояние,
						Выборка.Связанная,
						Выборка.Предмет);
					
				КонецЕсли;
			КонецЕсли;
			
			ПроверяемаяДата = ПроверяемаяДата + 86400; // 86400 - число секунд в сутках
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТаблицаЗанятости;
	
КонецФункции

// Устаревшее. Следует использовать РеквизитыЗаписиКалендаря().
// Возвращает структуру реквизитов записи календаря.
Функция ПолучитьСтруктуруРеквизитовЗаписиКалендаря() Экспорт
	
	Возврат РеквизитыЗаписиКалендаря();
	
КонецФункции

// Возвращает структуру реквизитов записи календаря.
// 
// Возвращаемое значение:
//  Структура - Реквизиты записи календаря.
//   * Ссылка - СправочникСсылка.ЗаписиРабочегоКалендаря - Ссылка на запись календаря.
//   * Наименование - Строка - Первая строка описания.
//   * Описание - Строка - Описание без первой строки.
//   * Пользователь - СправочникСсылка.Пользователи - Пользователь.
//   * Автор - СправочникСсылка.Пользователи - Автор.
//   * ДатаНачала - Дата - Дата начала.
//   * ДатаОкончания - Дата - Дата окончания.
//   * ВесьДень - Булево - Признак того, что запись на весь день.
//   * Повторять - Строка - Представление описания повторения.
//   * Предмет - ЛюбаяСсылка - Ссылка на предмет записи календаря.
//
Функция РеквизитыЗаписиКалендаря(ЗаписьКалендаря = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ЗаписьКалендаря) Тогда
		ЗаписьКалендаряОбъект = ЗаписьКалендаря.ПолучитьОбъект();
		РеквизитыЗаписиКалендаря = ЗаписьКалендаряОбъект.Реквизиты();
	Иначе
		РеквизитыЗаписиКалендаря = Новый Структура(
			"Ссылка, Описание, Пользователь, ДатаНачала, ДатаОкончания,
			|ВесьДень, Повторять, Предмет, Наименование, Автор");
		РеквизитыЗаписиКалендаря.Повторять = "";
	КонецЕсли;
	
	Возврат РеквизитыЗаписиКалендаря;
	
КонецФункции

// Удаляет связанные записи календаря.
//
// Параметры:
//  Предмет - ЛюбаяСсылка - Предмет.
//
Процедура УдалитьСвязанныеЗаписиКалендаря(Предмет) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Предмет = &Предмет
		|	И ЗаписиРабочегоКалендаря.Связанная = ИСТИНА
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ");
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписьКалендаря = Выборка.Ссылка.ПолучитьОбъект();
		ЗаписьКалендаря.ДополнительныеСвойства.Вставить("ИзменениеСвязаннойЗаписи");
		ЗаписьКалендаря.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает связанные записи календаря.
//
// Параметры:
//  Предмет - ЛюбаяСсылка, Массив - Предмет.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Связанные записи календаря.
//
Функция СвязанныеЗаписиКалендаря(Предмет) Экспорт
	
	Если ТипЗнч(Предмет) = Тип("Массив") Тогда
		Предметы = Предмет;
	ИначеЕсли ЗначениеЗаполнено(Предмет) Тогда
		Предметы = Новый Массив;
		Предметы.Добавить(Предмет);
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.Ссылка КАК Ссылка,
		|	ЗаписиРабочегоКалендаря.Пользователь КАК Пользователь
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Предмет В (&Предметы)
		|	И ЗаписиРабочегоКалендаря.Связанная = ИСТИНА
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ");
	
	Запрос.УстановитьПараметр("Предметы", Предметы);
	
	СвязанныеЗаписиКалендаря = Запрос.Выполнить().Выгрузить();
	
	Возврат СвязанныеЗаписиКалендаря;
	
КонецФункции

// Возвращает связаннубю запись календаря для указнного пользователя.
//
// Параметры:
//  Предмет - ЛюбаяСсылка, Массив - Предмет.
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//
// Возвращаемое значение:
//  СправочникСсылка.ЗаписиРабочегоКалендаря - Связанная запись календаря.
//
Функция СвязаннаяЗаписьКалендаря(Предмет, Знач Пользователь) Экспорт
	
	СвязаннаяЗаписьКалендаря = Справочники.ЗаписиРабочегоКалендаря.ПустаяСсылка();
	Если Не ЗначениеЗаполнено(Предмет) Тогда
		Возврат СвязаннаяЗаписьКалендаря;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаписиРабочегоКалендаря.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Предмет = &Предмет
		|	И ЗаписиРабочегоКалендаря.Пользователь = &Пользователь
		|	И ЗаписиРабочегоКалендаря.Связанная = ИСТИНА
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ");
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		СвязаннаяЗаписьКалендаря = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат СвязаннаяЗаписьКалендаря;
	
КонецФункции

// Создает связанную запись календаря.
//
// Параметры:
//  Предмет - ЛюбаяСсылка - Предмет.
//  ДатаНачала - Дата - Дата начала.
//  ДатаОкончания - Дата - Дата окончания.
//  ВесьДень - Булево - Весь день.
//  Описание - Строка - Описание.
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Состояние - ПеречислениеСсылка.СостоянияЗаписейРабочегоКалендаря - Состояние.
//  ПодключатьНапоминаниеАвтоматически - Булево - Подключать напоминание автоматически.
//  НеРегистрироватьСобытиеУведомления - Булево - Отключает регистрацию событий уведомлений.
//
Процедура СоздатьСвязаннуюЗаписьКалендаря(
	Предмет,
	Пользователь,
	Состояние,
	ПодключатьНапоминаниеАвтоматически,
	НеРегистрироватьСобытиеУведомления = Ложь) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Предмет", Предмет);
	ДанныеЗаполнения.Вставить("Пользователь", Пользователь);
	ДанныеЗаполнения.Вставить("Состояние", Состояние);
	ДанныеЗаполнения.Вставить("Связанная", Истина);
	
	ЗаписьКалендаря = Справочники.ЗаписиРабочегоКалендаря.СоздатьЭлемент();
	ЗаписьКалендаря.Заполнить(ДанныеЗаполнения);
	ЗаписьКалендаря.ДополнительныеСвойства.Вставить("ИзменениеСвязаннойЗаписи");
	Если НеРегистрироватьСобытиеУведомления Тогда
		ЗаписьКалендаря.ДополнительныеСвойства.Вставить("НеРегистрироватьСобытиеУведомления");
	КонецЕсли;
	ЗаписьКалендаря.Записать();
	
	Если ПодключатьНапоминаниеАвтоматически Тогда
		РаботаСРабочимКалендаремСервер.ПодключитьНапоминаниеАвтоматически(ЗаписьКалендаря.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет связанную запись календаря.
//
// Параметры:
//  СвязаннаяЗаписьКалендаря - СправочникСсылка.ЗаписиРабочегоКалендаря - Связанная запись календаря.
//  ДатаНачала - Дата - Дата начала.
//  ДатаОкончания - Дата - Дата окончания.
//  ВесьДень - Булево - Весь день.
//  Описание - Строка - Описание.
//
Процедура ОбновитьСвязаннуюЗаписьКалендаря(
	СвязаннаяЗаписьКалендаря,
	Предмет) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Предмет", Предмет);
	
	ЗаписьКалендаря = СвязаннаяЗаписьКалендаря.ПолучитьОбъект();
	ЗаписьКалендаря.Заблокировать();
	ЗаписьКалендаря.Заполнить(ДанныеЗаполнения);
	ЗаписьКалендаря.ДополнительныеСвойства.Вставить("ИзменениеСвязаннойЗаписи");
	ЗаписьКалендаря.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает соответствующее состояние занятости
//
// Параметры:
//  СостояниеЗаписиРабочегоКалендаря - ПеречислениеСсылка.СостоянияЗаписейРабочегоКалендаря - Состояние записи рабочего календаря.
//  Связанная - Булево - Запись календаря является связанной.
//  Предмет - СправочникСсылка, ДокументСсылка - Предмет записи календаря.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияЗанятости - Состояние занятости.
//
Функция ПолучитьСоответствующееСостояниеЗанятости(СостояниеЗаписиРабочегоКалендаря, Связанная, Предмет) Экспорт
	
	СостоянияЗанятости = Неопределено;
	
	Если Связанная И ТипЗнч(Предмет) = Тип("ДокументСсылка.Отсутствие")
		И СостояниеЗаписиРабочегоКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.Принято Тогда
		СостоянияЗанятости = ?(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "БудуРазбиратьЗадачи"),
			Перечисления.СостоянияЗанятости.Доступен,
			Перечисления.СостоянияЗанятости.Отсутствует);
	ИначеЕсли СостояниеЗаписиРабочегоКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.Принято Тогда
		СостоянияЗанятости = Перечисления.СостоянияЗанятости.Занят;
	ИначеЕсли СостояниеЗаписиРабочегоКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено Тогда
		СостоянияЗанятости = Перечисления.СостоянияЗанятости.Доступен;
	ИначеЕсли СостояниеЗаписиРабочегоКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.ПодВопросом
		Или Не ЗначениеЗаполнено(СостояниеЗаписиРабочегоКалендаря) Тогда
		СостоянияЗанятости = Перечисления.СостоянияЗанятости.ПодВопросом;
	КонецЕсли;
	
	Возврат СостоянияЗанятости;
	
КонецФункции

#КонецОбласти

#КонецЕсли
