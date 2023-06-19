
// Выводит состояние документа (проведен, не проведен, записан)
Процедура ОбновитьСостояниеДокумента(Ссылка, СостояниеДокумента, КартинкаСостоянияДокумента) Экспорт
	
	Проведен = Ссылка.Проведен;
	ПометкаУдаления = Ссылка.ПометкаУдаления;
	РазрешеноПроведение = (Ссылка.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить);
	
	Если ПометкаУдаления Тогда 
		СостояниеДокумента = "Помечен на удаление";
		КартинкаСостоянияДокумента = 2;
	ИначеЕсли Проведен Тогда
		СостояниеДокумента = "Проведен";
		КартинкаСостоянияДокумента = 1;
	ИначеЕсли РазрешеноПроведение Тогда 
		СостояниеДокумента = "Не проведен";
		КартинкаСостоянияДокумента = 0;
	Иначе
		СостояниеДокумента = "Записан";
		КартинкаСостоянияДокумента = 3;
	КонецЕсли;
	
КонецПроцедуры

// Продлевает срок действия документов из регламентного задания
Процедура АвтоматическоеПродлениеДоговоров() Экспорт
	
	Отказ = Ложь;
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.АвтоматическоеПродлениеДоговоров, Отказ);
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДокументыОтветственных = Новый ТаблицаЗначений;
	ДокументыОтветственных.Колонки.Добавить("Документ");
	ДокументыОтветственных.Колонки.Добавить("Ответственный");
	ДокументыОтветственных.Колонки.Добавить("СтараяДатаОкончания");
	ДокументыОтветственных.Колонки.Добавить("НоваяДатаОкончания");
	КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВнутренниеДокументы.Ссылка,
	|	ВнутренниеДокументы.ПорядокПродления,
	|	ВнутренниеДокументы.Ответственный
	|ИЗ
	|	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
	|ГДЕ
	|	ВнутренниеДокументы.ВидДокумента.УчитыватьСрокДействия
	|	И (НЕ ВнутренниеДокументы.Бессрочный)
	|	И ВнутренниеДокументы.ПорядокПродления В(&ПорядокПродления)
	|	И КОНЕЦПЕРИОДА(ВнутренниеДокументы.ДатаОкончанияДействия, ДЕНЬ) < &ТекущаяДата";
	
	ПорядокПродления = Новый Массив;
	ПорядокПродления.Добавить(Перечисления.ПорядокПродления.АвтоматическиНаМесяц);
	ПорядокПродления.Добавить(Перечисления.ПорядокПродления.АвтоматическиНаКвартал);
	ПорядокПродления.Добавить(Перечисления.ПорядокПродления.АвтоматическиНаПолугодие);
	ПорядокПродления.Добавить(Перечисления.ПорядокПродления.АвтоматическиНаГод);
	ПорядокПродления.Добавить(Перечисления.ПорядокПродления.АвтоматическиНаНеопределенныйСрок);
	
	Запрос.УстановитьПараметр("ПорядокПродления", ПорядокПродления);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПорядокПродления = Перечисления.ПорядокПродления.АвтоматическиНаМесяц Тогда 
			НаСрок = 1;
		ИначеЕсли Выборка.ПорядокПродления = Перечисления.ПорядокПродления.АвтоматическиНаКвартал Тогда 
			НаСрок = 3;
		ИначеЕсли Выборка.ПорядокПродления = Перечисления.ПорядокПродления.АвтоматическиНаПолугодие Тогда 
			НаСрок = 6;
		ИначеЕсли Выборка.ПорядокПродления = Перечисления.ПорядокПродления.АвтоматическиНаГод Тогда 	
			НаСрок = 12;
		КонецЕсли;	
		
		ТекстСообщения = "";
		Попытка 	
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			СтараяДатаОкончания = Объект.ДатаОкончанияДействия;
			
			Если Выборка.ПорядокПродления = Перечисления.ПорядокПродления.АвтоматическиНаНеопределенныйСрок Тогда 
				Объект.ДатаОкончанияДействия = '00010101';
				Объект.Бессрочный = Истина;
				НоваяДатаОкончания = "Бессрочный";
			Иначе	
				Если КонецДня(Объект.ДатаОкончанияДействия) = КонецМесяца(Объект.ДатаОкончанияДействия) Тогда 
					Объект.ДатаОкончанияДействия = КонецМесяца(ДобавитьМесяц(Объект.ДатаОкончанияДействия, НаСрок));
				Иначе
					Объект.ДатаОкончанияДействия = ДобавитьМесяц(Объект.ДатаОкончанияДействия, НаСрок);	
				КонецЕсли;	
				НоваяДатаОкончания = Объект.ДатаОкончанияДействия;
			КонецЕсли;
			
			Объект.Записать();
			
			// Записываем информацию о продлении в историю срока действия документа.
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("Документ", Объект.Ссылка);
			ПараметрыЗаписи.Вставить("ДатаНачалаДействия", Объект.ДатаНачалаДействия);
			ПараметрыЗаписи.Вставить("ДатаОкончанияДействия", Объект.ДатаОкончанияДействия);
			ПараметрыЗаписи.Вставить("Бессрочный", Объект.Бессрочный);
			ПараметрыЗаписи.Вставить("ПорядокПродления", Объект.ПорядокПродления);
			ПараметрыЗаписи.Вставить("ДокументИсточникИзменения", Неопределено);
			ПараметрыЗаписи.Вставить("Комментарий", НСтр("ru = 'Срок действия документа автоматически продлен.'", КодОсновногоЯзыка));
			РегистрыСведений.ИсторияСроковДействияДокументов.ДобавитьЗапись(ПараметрыЗаписи);
			
		Исключение
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Ошибка при автоматическом продлении срока действия документа: %1.'", КодОсновногоЯзыка),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Ошибка;	
		КонецПопытки;	
		
		Если ПустаяСтрока(ТекстСообщения) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Автоматически продлен срок действия документа до %1.'", КодОсновногоЯзыка), 
				Формат(НоваяДатаОкончания, "ДЛФ=D"));
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Информация;	
			
			Если ЗначениеЗаполнено(Выборка.Ответственный) Тогда 
				НоваяСтрока = ДокументыОтветственных.Добавить();
				НоваяСтрока.Документ = Выборка.Ссылка;
				НоваяСтрока.Ответственный = Выборка.Ответственный;
				НоваяСтрока.СтараяДатаОкончания = СтараяДатаОкончания;
				НоваяСтрока.НоваяДатаОкончания = НоваяДатаОкончания;
			КонецЕсли;	
		КонецЕсли;	
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Документы.Автоматическое продление договоров.'", КодОсновногоЯзыка),
			УровеньВажностиСобытия, Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
		
	КонецЦикла;	
	
	
	// отправка уведомлений по почте
	Ответственные = ДокументыОтветственных.Скопировать();
	Ответственные.Свернуть("Ответственный");
	
	Для Каждого Строка Из Ответственные Цикл
		
		Ответственный = Строка.Ответственный;
		ПочтовыйАдрес = "";
		ПочтовыйАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
			Ответственный, 
			Справочники.ВидыКонтактнойИнформации.EmailПользователя,, 
			ТекущаяДатаСеанса(),
			Новый Структура("ТолькоПервая", Истина));
		
		Если ПустаяСтрока(ПочтовыйАдрес) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Уведомление не было отправлено, так как у пользователя %1 не задан адрес электронной почты.'",
					КодОсновногоЯзыка), 
				Строка(Ответственный));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Документы.Уведомление об автоматическом продлении договоров'",
					КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Кому", ПочтовыйАдрес);
		
		ТелоПисьма = 
		НСтр("ru = 'У следующих документов был автоматически продлен срок действия:
		|
		|'", КодОсновногоЯзыка);
		
		НайденныеСтроки = ДокументыОтветственных.НайтиСтроки(Новый Структура("Ответственный", Ответственный));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Документ = НайденнаяСтрока.Документ;
			
			ТелоПисьма = ТелоПисьма + Документ.Заголовок;
			
			Если ЗначениеЗаполнено(Документ.РегистрационныйНомер) Тогда 
				ТелоПисьма = ТелоПисьма + " " + СтрШаблон(
					НСтр("ru = '№ %1'", КодОсновногоЯзыка),
					Документ.РегистрационныйНомер);
			КонецЕсли;	
			
			Если ЗначениеЗаполнено(Документ.ДатаРегистрации) Тогда 
				ТелоПисьма = ТелоПисьма + " " + СтрШаблон(
					НСтр("ru = 'от %1'", КодОсновногоЯзыка),
					Формат(Документ.ДатаРегистрации,"ДФ=dd.MM.yyyy"));
			КонецЕсли;
			
			КонтрагентыДляСписков = РегистрыСведений.ОбщиеРеквизитыДокументов.ПолучитьОбщийРеквизитДокумента(
				Документ.Ссылка, "КонтрагентыДляСписков");
			
			Если Документ.Контрагенты.Количество() > 1 Тогда 
				ТелоПисьма = ТелоПисьма + СтрШаблон(
					НСтр("ru = ', контрагенты %1'", КодОсновногоЯзыка),
					КонтрагентыДляСписков);
			ИначеЕсли Документ.Контрагенты.Количество() > 0 Тогда 
				ТелоПисьма = ТелоПисьма + СтрШаблон(
					НСтр("ru = ', контрагент %1'", КодОсновногоЯзыка),
					КонтрагентыДляСписков);
			КонецЕсли;
			
			ТелоПисьма = ТелоПисьма + " " + СтрШаблон(
				НСтр("ru = '- срок действия продлен до %1'", КодОсновногоЯзыка),
				Формат(НайденнаяСтрока.НоваяДатаОкончания, "ДЛФ=D"));
				
			ТелоПисьма = ТелоПисьма + Символы.ПС;
			
		КонецЦикла;	
		ПараметрыПисьма.Вставить("Текст", ТелоПисьма);
		
		ТемаПисьма = СтрШаблон(
			НСтр("ru = 'Автоматически продлены сроки действия документов (%1)'", КодОсновногоЯзыка),
			НайденныеСтроки.Количество());
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
		
		
		ТекстСообщения = "";
		Попытка
			ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыПисьма);
		Исключение
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Ошибка при отправке уведомления об автоматическом продлении договоров: %1.'",
					КодОсновногоЯзыка),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Ошибка;
		КонецПопытки;
		
		Если ПустаяСтрока(ТекстСообщения) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Уведомление об автоматическом продлении договоров успешно отправлено на адрес %1.'",
					КодОсновногоЯзыка),
				ПочтовыйАдрес);
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Документы.Автоматическое продление договоров'", КодОсновногоЯзыка),
			УровеньВажностиСобытия,,, ТекстСообщения);
		
	КонецЦикла;
	
	
КонецПроцедуры
