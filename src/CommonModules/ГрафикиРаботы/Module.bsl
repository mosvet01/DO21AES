
Функция ИнтервалыПересекаются(Начало1, Конец1, Начало2, Конец2) Экспорт
	
	Возврат Макс(Начало1, Начало2) < Мин(Конец1, Конец2);
	
КонецФункции

Функция ПолучитьОсновнойГрафикРаботы() Экспорт
	
	ГрафикРаботы = Справочники.ГрафикиРаботы.ПустаяСсылка();
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
		Возврат ГрафикРаботы;
	КонецЕсли;
	
	ГрафикРаботы = Константы.ОсновнойГрафикРаботы.Получить();
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		ТекстСообщения = НСтр("ru = 'В настройках системы не определен основной график работы!'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;	
	
	Возврат ГрафикРаботы;
	
КонецФункции	

Функция ПолучитьГрафикРаботыПользователя(Пользователь) Экспорт
	
	ГрафикРаботы = Справочники.ГрафикиРаботы.ПустаяСсылка();
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
		Возврат ГрафикРаботы;
	КонецЕсли;
	
	СведенияПользователей = РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(Новый Структура("Пользователь", Пользователь));
	ГрафикРаботы = СведенияПользователей.ГрафикРаботы;
	Если ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		Возврат ГрафикРаботы;
	КонецЕсли;
	
	Подразделение = СведенияПользователей.Подразделение;
	ГрафикРаботы = Подразделение.ГрафикРаботы;
	Если ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		Возврат ГрафикРаботы;
	КонецЕсли;	
	
	ТекПодразделение = Подразделение.Родитель;
	Пока Не ТекПодразделение.Пустая() Цикл
		ГрафикРаботы = ТекПодразделение.ГрафикРаботы;
		Если ЗначениеЗаполнено(ГрафикРаботы) Тогда 
			Возврат ГрафикРаботы;
		КонецЕсли;	
		
		ТекПодразделение = ТекПодразделение.Родитель;
	КонецЦикла;	
	
	ГрафикРаботы = Константы.ОсновнойГрафикРаботы.Получить();
	Если Не ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		ТекстСообщения = НСтр("ru = 'В настройках системы не определен основной график работы!'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Возврат ГрафикРаботы;
	
КонецФункции	


Функция ПолучитьВремя(Дата)
	
	Возврат Дата(1, 1, 1, Час(Дата), Минута(Дата), Секунда(Дата));
	
КонецФункции	

Функция ДобавитьВремя(Дата, Время)
	
	Возврат НачалоДня(Дата) + Час(Время)*3600 + Минута(Время)*60 + Секунда(Время);
	
КонецФункции

Функция ЭтоРабочийДень(ПроверяемаяДата, ГрафикРаботы) Экспорт 
	
	РабочиеДни = Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(ГрафикРаботы.Календарь, Год(ПроверяемаяДата));
	Если РабочиеДни.Найти(НачалоДня(ПроверяемаяДата)) <> Неопределено Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции	

Функция СформироватьТаблицуРабочегоВремени(ГрафикРаботы, ДатаНачала, ДатаОкончания) Экспорт 
	
	// рабочие дни
	РабочиеДни = Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(ГрафикРаботы.Календарь, Год(ДатаНачала));
	Если РабочиеДни.Количество() = 0 Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( 
			НСтр("ru = 'Не заполнен рабочий календарь %1 на %2 год'"),
			Строка(ГрафикРаботы.Календарь),
			Формат(Год(ДатаНачала), "ЧГ="));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;	
	
	Если Год(ДатаОкончания) > Год(ДатаНачала) Тогда 
		ВрРабочиеДни = Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(ГрафикРаботы.Календарь, Год(ДатаОкончания));
		Если ВрРабочиеДни.Количество() = 0 Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( 
				НСтр("ru = 'Не заполнен рабочий календарь %1 на %2 год'"),
				Строка(ГрафикРаботы.Календарь),
				Формат(Год(ДатаОкончания), "ЧГ="));
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		Для Каждого Элемент Из ВрРабочиеДни Цикл
			РабочиеДни.Добавить(Элемент);
		КонецЦикла;	
	КонецЕсли;	
	
	
	// общее рабочее время
	РабочееВремя = Новый ТаблицаЗначений;
	РабочееВремя.Колонки.Добавить("ВремяНачала");
	РабочееВремя.Колонки.Добавить("ВремяОкончания");
	РабочееВремя.Колонки.Добавить("Рабочее");
	
	РабочееВремяГрафика = ГрафикРаботы.РабочееВремя.Выгрузить();
	РабочееВремяГрафика.Сортировать("ВремяНачала");
	ВГраница = РабочееВремяГрафика.Количество() - 1;
	
	Если РабочееВремяГрафика[0].ВремяНачала > '00010101' Тогда 
		НоваяСтрока = РабочееВремя.Добавить();
		НоваяСтрока.ВремяНачала = '00010101';
		НоваяСтрока.ВремяОкончания = РабочееВремяГрафика[0].ВремяНачала-1;
		НоваяСтрока.Рабочее = Ложь;
	КонецЕсли;	
	
	Для Инд = 0 По ВГраница Цикл
		НоваяСтрока = РабочееВремя.Добавить();
		НоваяСтрока.ВремяНачала = РабочееВремяГрафика[Инд].ВремяНачала;
		НоваяСтрока.ВремяОкончания = РабочееВремяГрафика[Инд].ВремяОкончания;
		НоваяСтрока.Рабочее = Истина;
		
		Если Инд < ВГраница Тогда 
			НоваяСтрока = РабочееВремя.Добавить();
			НоваяСтрока.ВремяНачала = РабочееВремяГрафика[Инд].ВремяОкончания+1;
			НоваяСтрока.ВремяОкончания = РабочееВремяГрафика[Инд+1].ВремяНачала-1;
			НоваяСтрока.Рабочее = Ложь;
		КонецЕсли;
	КонецЦикла;	
	
	Если РабочееВремяГрафика[ВГраница].ВремяОкончания < '00010101235959' Тогда 
		НоваяСтрока = РабочееВремя.Добавить();
		НоваяСтрока.ВремяНачала = РабочееВремяГрафика[ВГраница].ВремяОкончания+1;
		НоваяСтрока.ВремяОкончания = '00010101235959';
		НоваяСтрока.Рабочее = Ложь;
	КонецЕсли;
	
	
	// особое рабочее время
	ОсобоеРабочееВремя = Новый ТаблицаЗначений;
	ОсобоеРабочееВремя.Колонки.Добавить("РабочийДень");
	ОсобоеРабочееВремя.Колонки.Добавить("ВремяНачала");
	ОсобоеРабочееВремя.Колонки.Добавить("ВремяОкончания");
	ОсобоеРабочееВремя.Колонки.Добавить("Рабочее");
	
	ОсобоеРабочееВремяГрафика = ГрафикРаботы.ОсобоеРабочееВремя.Выгрузить();
	ОсобоеРабочееВремяГрафика.Сортировать("РабочийДень, ВремяНачала");
	
	ДниОсобогоРабочегоВремени = ОсобоеРабочееВремяГрафика.Скопировать();
	ДниОсобогоРабочегоВремени.Свернуть("РабочийДень");
	ДниОсобогоРабочегоВремени.Сортировать("РабочийДень");
	
	Для Каждого СтрокаДень Из ДниОсобогоРабочегоВремени Цикл
		
		ОтборСтрок = Новый Структура("РабочийДень", СтрокаДень.РабочийДень);
		НайденныеСтроки = ОсобоеРабочееВремяГрафика.НайтиСтроки(ОтборСтрок);
		ВГраница = НайденныеСтроки.Количество()-1;
		
		Если НайденныеСтроки[0].ВремяНачала > '00010101' Тогда 
			НоваяСтрока = ОсобоеРабочееВремя.Добавить();
			НоваяСтрока.РабочийДень = СтрокаДень.РабочийДень;
			НоваяСтрока.ВремяНачала = '00010101';
			НоваяСтрока.ВремяОкончания = НайденныеСтроки[0].ВремяНачала-1;
			НоваяСтрока.Рабочее = Ложь;
		КонецЕсли;	
		
		Для Инд = 0 По ВГраница Цикл
			НоваяСтрока = ОсобоеРабочееВремя.Добавить();
			НоваяСтрока.РабочийДень = СтрокаДень.РабочийДень;
			НоваяСтрока.ВремяНачала = НайденныеСтроки[Инд].ВремяНачала;
			НоваяСтрока.ВремяОкончания = НайденныеСтроки[Инд].ВремяОкончания;
			НоваяСтрока.Рабочее = Истина;
			
			Если Инд < ВГраница Тогда 
				НоваяСтрока = ОсобоеРабочееВремя.Добавить();
				НоваяСтрока.РабочийДень = СтрокаДень.РабочийДень;
				НоваяСтрока.ВремяНачала = НайденныеСтроки[Инд].ВремяОкончания+1;
				НоваяСтрока.ВремяОкончания = НайденныеСтроки[Инд+1].ВремяНачала-1;
				НоваяСтрока.Рабочее = Ложь;
			КонецЕсли;
		КонецЦикла;	
		
		Если НайденныеСтроки[ВГраница].ВремяОкончания < '00010101235959' Тогда 
			НоваяСтрока = ОсобоеРабочееВремя.Добавить();
			НоваяСтрока.РабочийДень = СтрокаДень.РабочийДень;
			НоваяСтрока.ВремяНачала = НайденныеСтроки[ВГраница].ВремяОкончания+1;
			НоваяСтрока.ВремяОкончания = '00010101235959';
			НоваяСтрока.Рабочее = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	
	// таблица рабочего времени
	ТаблицаРабочегоВремени = Новый ТаблицаЗначений;
	ТаблицаРабочегоВремени.Колонки.Добавить("ДатаНачала");
	ТаблицаРабочегоВремени.Колонки.Добавить("ДатаОкончания");
	ТаблицаРабочегоВремени.Колонки.Добавить("Длительность");
	
	ТекущаяДата = ДатаНачала;
	Пока ТекущаяДата < ДатаОкончания Цикл
		
		Если РабочиеДни.Найти(НачалоДня(ТекущаяДата)) = Неопределено Тогда // нерабочий день
			ТекущаяДата = КонецДня(ТекущаяДата) + 1; 
			Продолжить;
		КонецЕсли;
		ТекущееВремя = ПолучитьВремя(ТекущаяДата);	
		
		Если ОсобоеРабочееВремя.Найти(НачалоДня(ТекущаяДата), "РабочийДень") <> Неопределено Тогда // особый рабочий день
			ВрРабочееВремя = ОсобоеРабочееВремя.Скопировать();
			ВрРабочееВремя.Очистить();
			
			Для Каждого Строка Из ОсобоеРабочееВремя Цикл
				Если Строка.РабочийДень = НачалоДня(ТекущаяДата) Тогда 
					НоваяСтрока = ВрРабочееВремя.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
				КонецЕсли;
			КонецЦикла;
		Иначе
			врРабочееВремя = РабочееВремя;
		КонецЕсли;	
			
		Для Каждого Строка Из ВрРабочееВремя Цикл 
			Если (Строка.ВремяНачала <= ТекущееВремя) И (ТекущееВремя <= Строка.ВремяОкончания) Тогда 
				
				Если Строка.Рабочее Тогда 
					НоваяСтрока = ТаблицаРабочегоВремени.Добавить();
					НоваяСтрока.ДатаНачала = ТекущаяДата;
					НоваяСтрока.ДатаОкончания = ДобавитьВремя(ТекущаяДата, Строка.ВремяОкончания);
					
					Если НоваяСтрока.ДатаОкончания > ДатаОкончания Тогда 
						НоваяСтрока.ДатаОкончания = ДатаОкончания;
					КонецЕсли;
					
					НоваяСтрока.Длительность = НоваяСтрока.ДатаОкончания - НоваяСтрока.ДатаНачала;
					Если НоваяСтрока.ДатаОкончания = КонецДня(НоваяСтрока.ДатаОкончания) Тогда 
						НоваяСтрока.Длительность = НоваяСтрока.Длительность + 1
					КонецЕсли;	
				КонецЕсли;
				
				ТекущаяДата = ДобавитьВремя(ТекущаяДата, Строка.ВремяОкончания) + 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;	
	
	Возврат ТаблицаРабочегоВремени;
	
КонецФункции


Функция ПолучитьДатуОкончанияСек(ГрафикРаботы, Знач ДатаНачала, ДлительностьСек = 0) Экспорт 

	ДатаОкончания = ДатаНачала;
	
	Если ДлительностьСек > 0 Тогда 
		Длительность = ДлительностьСек;
		
		НачалоПериода = ДатаНачала;
		КонецПериода = НачалоПериода + 10*24*3600; // десять дней
		
		ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
		Пока ТаблицаРабочегоВремени.Количество() < 2 Цикл  
			КонецПериода = КонецПериода + 10*24*3600; // десять дней
			ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
		КонецЦикла;
		
		ДатаОкончания = ТаблицаРабочегоВремени[0].ДатаНачала;
		Пока Длительность > 0 Цикл
			Для Инд = 0 По ТаблицаРабочегоВремени.Количество()-2 Цикл
				Строка = ТаблицаРабочегоВремени[Инд];
				Если Строка.Длительность = Длительность Тогда 
					ДатаОкончания = Строка.ДатаОкончания;
					Длительность = 0;
					Прервать;
				ИначеЕсли Строка.Длительность < Длительность Тогда 	
					ДатаОкончания = ТаблицаРабочегоВремени[Инд+1].ДатаНачала;
					Длительность = Длительность - Строка.Длительность;
				Иначе
					ДатаОкончания = ДатаОкончания + Длительность;
					Длительность = 0;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			
			Если Длительность > 0 Тогда  
				НачалоПериода = ДатаОкончания;
				КонецПериода = НачалоПериода + 10*24*3600; // десять дней
				
				ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
				Пока ТаблицаРабочегоВремени.Количество() < 2 Цикл  
					КонецПериода = КонецПериода + 10*24*3600; // десять дней
					ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;	
		
	КонецЕсли;
	
	Возврат ДатаОкончания;
	
КонецФункции	

Функция ПолучитьДлительностьПериодаСек(ГрафикРаботы, ДатаНачала, ДатаОкончания, ТаблицаРабочегоВремени = Неопределено) Экспорт 
	
	Если ТаблицаРабочегоВремени = Неопределено Тогда 
		Таблица = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, ДатаНачала, ДатаОкончания);
	Иначе
		Таблица = ТаблицаРабочегоВремени;
	КонецЕсли;	
	
	Длительность = 0;
	Для Каждого Строка Из Таблица Цикл
		
		Если ДатаНачала > Строка.ДатаНачала И ДатаНачала > Строка.ДатаОкончания Тогда 
			Продолжить;
		ИначеЕсли ДатаОкончания < Строка.ДатаНачала И ДатаОкончания < Строка.ДатаОкончания Тогда 
			Продолжить;
		ИначеЕсли ДатаНачала >= Строка.ДатаНачала И ДатаНачала <= Строка.ДатаОкончания Тогда 
			Длительность = Длительность + (Строка.ДатаОкончания - ДатаНачала);
		ИначеЕсли ДатаОкончания >= Строка.ДатаНачала И ДатаОкончания <= Строка.ДатаОкончания Тогда 
			Длительность = Длительность + (ДатаОкончания - Строка.ДатаНачала);
		Иначе	
			Длительность = Длительность + (Строка.ДатаОкончания - Строка.ДатаНачала);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Длительность;
	
КонецФункции

Функция ПолучитьДатуНачалаПериодаСек(ГрафикРаботы, ДатаОкончания, ДлительностьСек) Экспорт
	
	Длительность = ДлительностьСек;
	
	КонецПериода = ДатаОкончания;
	НачалоПериода = КонецПериода - 10*24*3600; // десять дней
	
	ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
	Пока ТаблицаРабочегоВремени.Количество() < 2 Цикл  
		НачалоПериода = НачалоПериода - 10*24*3600; // десять дней
		ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
	КонецЦикла;
	
	ВГраница = ТаблицаРабочегоВремени.Количество() - 1;

	ДатаНачала = ТаблицаРабочегоВремени[ВГраница].ДатаОкончания;
	Пока Длительность > 0 Цикл
		Для Инд = 0 По ТаблицаРабочегоВремени.Количество()-2 Цикл
			Строка = ТаблицаРабочегоВремени[ВГраница - Инд];
			
			Если Строка.Длительность = Длительность Тогда 
				ДатаНачала = Строка.ДатаНачала;
				Длительность = 0;
				Прервать;
			ИначеЕсли Строка.Длительность < Длительность Тогда 	
				ДатаНачала = ТаблицаРабочегоВремени[ВГраница - Инд - 1].ДатаОкончания;
				Длительность = Длительность - Строка.Длительность;
			Иначе
				ДатаНачала = ДатаНачала - Длительность;
				Длительность = 0;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Длительность > 0 Тогда  
			КонецПериода = ДатаНачала;
			НачалоПериода = КонецПериода - 10*24*3600; // десять дней
			
			ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
			Пока ТаблицаРабочегоВремени.Количество() < 2 Цикл  
				НачалоПериода = НачалоПериода - 10*24*3600; // десять дней
				ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоПериода, КонецПериода);
			КонецЦикла;
			ВГраница = ТаблицаРабочегоВремени.Количество() - 1;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ДатаНачала;
	
КонецФункции


Функция ПолучитьДатуОкончанияПериода(ГрафикРаботы, Знач ДатаНачала, ДлительностьДн, ДлительностьЧас = 0) Экспорт
	
	Если Не ЭтоРабочаяДатаВремя(ГрафикРаботы, ДатаНачала) Тогда 
		ВрДатаНачала = ПолучитьДатуОкончанияСек(ГрафикРаботы, ДатаНачала, 1);
		ДатаНачала = ВрДатаНачала - 1;
	КонецЕсли;	
	
	ДатаОкончания = ДатаНачала;
	
	Если ДлительностьДн > 0 Тогда 
		врДатаНачала = КалендарныеГрафики.ПолучитьДатуПоКалендарю(ГрафикРаботы.Календарь, ДатаНачала, ДлительностьДн);
		ДатаНачала = ДобавитьВремя(врДатаНачала, ДатаНачала);
		ДатаОкончания = ДатаНачала;
	КонецЕсли;
	
	ДатаОкончания = ПолучитьДатуОкончанияСек(ГрафикРаботы, ДатаНачала, ДлительностьЧас*3600);
	
	Возврат ДатаОкончания;
	
КонецФункции

Функция ПолучитьДлительностьПериода(ГрафикРаботы, ДатаНачала, ДатаОкончания) Экспорт 
	
	Таблица = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, ДатаНачала, ДатаОкончания);
	Если Таблица.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексПоследнего = Таблица.Количество() - 1;
	
	// вычисление количества полных рабочих дней между датами
	СчитатьПервыйДень = Таблица[0].ДатаНачала >= ДатаНачала;
	СчитатьПоследнийДень = Таблица[ИндексПоследнего].ДатаОкончания <= ДатаОкончания;
	МассивРабочихДней = Новый Массив;
	Для Каждого Строка Из Таблица Цикл
		ЗначениеДобавления = НачалоДня(Строка.ДатаНачала);
		Если МассивРабочихДней.Найти(ЗначениеДобавления) = Неопределено Тогда
			МассивРабочихДней.Добавить(ЗначениеДобавления);
		КонецЕсли;
	КонецЦикла;
	КоличествоПолныхРабочихДней = МассивРабочихДней.Количество();
	Если НЕ СчитатьПервыйДень Тогда
		КоличествоПолныхРабочихДней = КоличествоПолныхРабочихДней - 1;
	КонецЕсли;
	Если НЕ СчитатьПоследнийДень Тогда
		КоличествоПолныхРабочихДней = КоличествоПолныхРабочихДней - 1;
	КонецЕсли;
	Если КоличествоПолныхРабочихДней < 0 Тогда
		КоличествоПолныхРабочихДней = 0;
	КонецЕсли;
	
	// вычисление количества полных рабочих часов в дополнение к рабочим дням
	ЧасыСНачалаПервогоРабочегоПериода = 0;
	ЧасыСНачалаПоследнегоРабочегоПериода = 0;
	Если Не СчитатьПервыйДень Тогда
		// добавляем часы с начала первого рабочего периода до ДатыНачала
		ЧасыСНачалаПервогоРабочегоПериода = Цел((ДатаНачала - Таблица[0].ДатаНачала) / 3600);
		ДатаПервогоРабочегоПериода = НачалоДня(Таблица[0].ДатаНачала);
		Для Индекс = 1 по ИндексПоследнего Цикл
			Если ДатаПервогоРабочегоПериода = НачалоДня(Таблица[Индекс].ДатаНачала) Тогда
				ЧасыСНачалаПервогоРабочегоПериода = 
					ЧасыСНачалаПервогоРабочегоПериода
					+ Цел(Таблица[Индекс].Длительность / 3600);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если НЕ СчитатьПоследнийДень Тогда
		// добавляем часы с начала последнего рабочего периода до ДатыОкончания
		ЧасыСНачалаПоследнегоРабочегоПериода = Цел((ДатаОкончания - Таблица[ИндексПоследнего].ДатаНачала) / 3600);
		ДатаНачалаПоследнегоРабочегоПериода = НачалоДня(Таблица[ИндексПоследнего].ДатаНачала);
		Для Индекс = 0 По ИндексПоследнего - 1 Цикл
			Если ДатаНачалаПоследнегоРабочегоПериода = НачалоДня(Таблица[Индекс].ДатаНачала) Тогда
				ЧасыСНачалаПоследнегоРабочегоПериода = 
					ЧасыСНачалаПоследнегоРабочегоПериода
					+ Цел(Таблица[Индекс].Длительность / 3600);
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	КоличествоЧасовВДополнениеКДням = ЧасыСНачалаПервогоРабочегоПериода + ЧасыСНачалаПоследнегоРабочегоПериода;
	
	ДанныеВозврата = Новый Структура();
	ДанныеВозврата.Вставить("КоличествоПолныхРабочихДней", КоличествоПолныхРабочихДней);
	ДанныеВозврата.Вставить("КоличествоПолныхРабочихЧасов", КоличествоЧасовВДополнениеКДням);
	
	Возврат ДанныеВозврата;
	
КонецФункции	

Функция ПолучитьНачалоИОкончаниеРабочегоДня(Дата, ГрафикРаботы) Экспорт
	
	СтруктураВозврата = Новый Структура("НачалоДня, ОкончаниеДня", Дата(1,1,1), Дата(1,1,1));
	Если Не ЭтоРабочийДень(Дата, ГрафикРаботы) Тогда 
		Возврат СтруктураВозврата;
	КонецЕсли;	
	
	ОсобоеРабочееВремяГрафика = ГрафикРаботы.ОсобоеРабочееВремя.Выгрузить();
	НайденныеСтроки = ОсобоеРабочееВремяГрафика.НайтиСтроки(Новый Структура("РабочийДень", НачалоДня(Дата)));
	Если НайденныеСтроки.Количество() > 0 Тогда 
		ТаблНайденныеСтроки = Новый ТаблицаЗначений;
		ТаблНайденныеСтроки.Колонки.Добавить("ВремяНачала");
		ТаблНайденныеСтроки.Колонки.Добавить("ВремяОкончания");
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НоваяСтрока = ТаблНайденныеСтроки.Добавить();
			НоваяСтрока.ВремяНачала = НайденнаяСтрока.ВремяНачала;
			НоваяСтрока.ВремяОкончания = НайденнаяСтрока.ВремяОкончания;
		КонецЦикла;	
	Иначе
		ТаблНайденныеСтроки = ГрафикРаботы.РабочееВремя.Выгрузить();
	КонецЕсли;	
		
	ТаблНайденныеСтроки.Сортировать("ВремяНачала Возр");
	СтруктураВозврата.НачалоДня = ТаблНайденныеСтроки[0].ВремяНачала;
	
	ТаблНайденныеСтроки.Сортировать("ВремяОкончания Убыв");
	СтруктураВозврата.ОкончаниеДня = ТаблНайденныеСтроки[0].ВремяОкончания;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ПолучитьДлительностьРабочегоДня(Дата, ГрафикРаботы) Экспорт 
	
	ОсобоеРабочееВремяГрафика = ГрафикРаботы.ОсобоеРабочееВремя.Выгрузить();
	НайденныеСтроки = ОсобоеРабочееВремяГрафика.НайтиСтроки(Новый Структура("РабочийДень", НачалоДня(Дата)));
	Если НайденныеСтроки.Количество() > 0 Тогда 
		ТаблНайденныеСтроки = Новый ТаблицаЗначений;
		ТаблНайденныеСтроки.Колонки.Добавить("ВремяНачала");
		ТаблНайденныеСтроки.Колонки.Добавить("ВремяОкончания");
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НоваяСтрока = ТаблНайденныеСтроки.Добавить();
			НоваяСтрока.ВремяНачала = НайденнаяСтрока.ВремяНачала;
			НоваяСтрока.ВремяОкончания = НайденнаяСтрока.ВремяОкончания;
		КонецЦикла;	
	Иначе
		ТаблНайденныеСтроки = ГрафикРаботы.РабочееВремя.Выгрузить();
	КонецЕсли;
	
	Длительность = 0;
	Для Каждого Строка Из ТаблНайденныеСтроки Цикл
		Длительность = Длительность + (Строка.ВремяОкончания - Строка.ВремяНачала);
	КонецЦикла;	
	
	Возврат Длительность;
	
КонецФункции

Функция ПолучитьПервоеРабочееВремяДня(ГрафикРаботы, Дата) Экспорт
	
	Если ГрафикиРаботы.ЭтоРабочаяДатаВремя(ГрафикРаботы, Дата) Тогда
		Возврат Дата;
	КонецЕсли;
	
	ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(
		ГрафикРаботы,
		НачалоДня(Дата),
		КонецДня(Дата));
	Если ТаблицаРабочегоВремени.Количество() > 0 Тогда
		Если Дата > ТаблицаРабочегоВремени[0].ДатаНачала
			И Дата < ТаблицаРабочегоВремени[ТаблицаРабочегоВремени.Количество() - 1].ДатаОкончания Тогда
			Возврат Дата;
		ИначеЕсли Дата < ТаблицаРабочегоВремени[ТаблицаРабочегоВремени.Количество() - 1].ДатаОкончания Тогда
			Возврат ТаблицаРабочегоВремени[0].ДатаНачала;
		Иначе
			Возврат ПолучитьПервоеРабочееВремяДня(ГрафикРаботы, НачалоДня(Дата + 24 * 3600));
		КонецЕсли;
	Иначе
		Возврат ПолучитьПервоеРабочееВремяДня(ГрафикРаботы, НачалоДня(Дата + 24 * 3600));
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьПоследнееРабочееВремяДня(ГрафикРаботы, Дата) Экспорт
	
	Если ГрафикиРаботы.ЭтоРабочаяДатаВремя(ГрафикРаботы, Дата) Тогда
		Возврат Дата;
	КонецЕсли;
		
	ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(
		ГрафикРаботы,
		НачалоДня(Дата),
		КонецДня(Дата));
	Если ТаблицаРабочегоВремени.Количество() > 0 Тогда
		Если Дата < ТаблицаРабочегоВремени[ТаблицаРабочегоВремени.Количество() - 1].ДатаОкончания
			И Дата > ТаблицаРабочегоВремени[0].ДатаНачала Тогда
			Возврат Дата;
		ИначеЕсли Дата < ТаблицаРабочегоВремени[ТаблицаРабочегоВремени.Количество() - 1].ДатаОкончания Тогда
			Возврат ТаблицаРабочегоВремени[ТаблицаРабочегоВремени.Количество() - 1].ДатаОкончания;
		Иначе
			Возврат ПолучитьПоследнееРабочееВремяДня(ГрафикРаботы, НачалоДня(Дата + 24 * 3600));
		КонецЕсли;
	Иначе
		Возврат ПолучитьПоследнееРабочееВремяДня(ГрафикРаботы, НачалоДня(Дата + 24 * 3600));
	КонецЕсли;
	
КонецФункции

// Возвращает признак того, что указанная точка времени принадлежит отрезку рабочего времени
Функция ЭтоРабочаяДатаВремя(ГрафикРаботы, ПроверяемаяДата) Экспорт
	
	Если Не ЭтоРабочийДень(ПроверяемаяДата, ГрафикРаботы) Тогда
		Возврат Ложь;
	КонецЕсли;	
		
	ТаблицаРабочегоВремени = СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоДня(ПроверяемаяДата), КонецДня(ПроверяемаяДата)); 
		
	Для Каждого СтрокаТаблицы Из ТаблицаРабочегоВремени Цикл
		Если СтрокаТаблицы.ДатаНачала <= ПроверяемаяДата И ПроверяемаяДата <= СтрокаТаблицы.ДатаОкончания Тогда 
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции
