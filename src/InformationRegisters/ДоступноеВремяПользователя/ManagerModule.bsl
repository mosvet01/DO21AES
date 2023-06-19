////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает таблицу доступности пользователей
Функция ПолучитьТаблицуДоступности(МассивПользователей) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаДоступности = Новый ТаблицаЗначений;
	ТаблицаДоступности.Колонки.Добавить("Пользователь");
	ТаблицаДоступности.Колонки.Добавить("ДеньНедели");
	ТаблицаДоступности.Колонки.Добавить("ВремяНачала");
	ТаблицаДоступности.Колонки.Добавить("ВремяОкончания");
	ТаблицаДоступности.Колонки.Добавить("Занят");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДоступноеВремяПользователя.Пользователь,
		|	ДоступноеВремяПользователя.ДеньНедели,
		|	ДоступноеВремяПользователя.ВремяНачала,
		|	ДоступноеВремяПользователя.ВремяОкончания,
		|	ЛОЖЬ КАК Занят
		|ИЗ
		|	РегистрСведений.ДоступноеВремяПользователя КАК ДоступноеВремяПользователя
		|ГДЕ
		|	ДоступноеВремяПользователя.Пользователь В (&МассивПользователей)";
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	ТаблицаДоступноеВремяПользователя = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиРабочегоКалендаря.Пользователь,
		|	НастройкиРабочегоКалендаря.Значение КАК Доступность
		|ИЗ
		|	РегистрСведений.НастройкиРабочегоКалендаря КАК НастройкиРабочегоКалендаря
		|ГДЕ
		|	НастройкиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И НастройкиРабочегоКалендаря.Настройка = ЗНАЧЕНИЕ(Перечисление.НастройкиРабочегоКалендаря.Доступность)";
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	ТаблицаНастройкиРабочегоКалендаря = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Пользователь Из МассивПользователей Цикл
		
		ДоступностьПользователя = Неопределено;
		
		НастройкаРабочегоКалендаряПользователя =
			ТаблицаНастройкиРабочегоКалендаря.Найти(Пользователь, "Пользователь");
		Если НастройкаРабочегоКалендаряПользователя <> Неопределено Тогда
			ДоступностьПользователя = НастройкаРабочегоКалендаряПользователя.Доступность;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоступностьПользователя) Тогда
			ДоступностьПользователя = Перечисления.ДоступностьПользователя.ДоступенВсегда;
		КонецЕсли;
		
		Если ДоступностьПользователя = Перечисления.ДоступностьПользователя.ДоступенВсегда Тогда
			
			ЗаполнитьТаблицуДоступностиПоУмолчаниюДляПользователя(ТаблицаДоступности, Пользователь, Перечисления.СостоянияЗанятости.Доступен)
			
		ИначеЕсли ДоступностьПользователя = Перечисления.ДоступностьПользователя.ЗанятВсегда Тогда
			
			ЗаполнитьТаблицуДоступностиПоУмолчаниюДляПользователя(ТаблицаДоступности, Пользователь, Перечисления.СостоянияЗанятости.Занят)
			
		ИначеЕсли ДоступностьПользователя = Перечисления.ДоступностьПользователя.ДоступенПоРасписанию Тогда
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Пользователь", Пользователь);
			НайденныеСтроки = ТаблицаДоступноеВремяПользователя.НайтиСтроки(ПараметрыОтбора);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				
				НачалоОтсчета = НачалоДня(ТекущаяДатаСеанса());
				ВремяНачала = НачалоОтсчета
					+ (НайденнаяСтрока.ВремяНачала - НачалоДня(НайденнаяСтрока.ВремяНачала));
				ВремяОкончания = НачалоОтсчета
					+ (НайденнаяСтрока.ВремяОкончания - НачалоДня(НайденнаяСтрока.ВремяОкончания));
				
				ИсходныйДеньНачала = День(ВремяНачала);
				ИсходныйДеньОкончания = День(ВремяОкончания);
				
				ВремяНачала = 
					РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
						РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
							ВремяНачала,
							НайденнаяСтрока.Пользователь));
				ВремяОкончания = 
					РаботаСЧасовымиПоясами.ПривестиКМестномуВремени(
						РаботаСЧасовымиПоясами.ПривестиМестноВремяПользователяКВремениСеанса(
							ВремяОкончания,
							НайденнаяСтрока.Пользователь));
				
				СмещенныйДеньНачала = День(ВремяНачала);
				СмещенныйДеньОкончания = День(ВремяОкончания);
				
				Если ИсходныйДеньНачала <> СмещенныйДеньНачала Тогда
					
					НоваяСтрока = ТаблицаДоступности.Добавить();
					НоваяСтрока.Пользователь = НайденнаяСтрока.Пользователь;
					Если НайденнаяСтрока.ДеньНедели = 1 Тогда
						НоваяСтрока.ДеньНедели = 7
					Иначе
						НоваяСтрока.ДеньНедели = НайденнаяСтрока.ДеньНедели - 1;
					КонецЕсли;
					НоваяСтрока.ВремяНачала = Дата(1, 1, 1)
						+ (ВремяНачала - НачалоДня(ВремяНачала));
					НоваяСтрока.ВремяОкончания = Дата(1, 1, 1)
						+ (КонецДня(ВремяНачала) - НачалоДня(ВремяНачала));
					
					Если НайденнаяСтрока.Занят Тогда
						НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Занят;
					Иначе
						НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Доступен;
					КонецЕсли;
					
					ВремяНачала = НачалоДня(ВремяНачала);
					
				КонецЕсли;
				
				Если ИсходныйДеньОкончания <> СмещенныйДеньОкончания Тогда
					
					НоваяСтрока = ТаблицаДоступности.Добавить();
					НоваяСтрока.Пользователь = НайденнаяСтрока.Пользователь;
					Если НайденнаяСтрока.ДеньНедели = 7 Тогда
						НоваяСтрока.ДеньНедели = 1
					Иначе
						НоваяСтрока.ДеньНедели = НайденнаяСтрока.ДеньНедели + 1;
					КонецЕсли;
					НоваяСтрока.ВремяНачала = Дата(1, 1, 1)
						+ (НачалоДня(ВремяОкончания) - НачалоДня(ВремяОкончания));
					НоваяСтрока.ВремяОкончания = Дата(1, 1, 1)
						+ (ВремяОкончания - НачалоДня(ВремяОкончания));
					
					Если НайденнаяСтрока.Занят Тогда
						НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Занят;
					Иначе
						НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Доступен;
					КонецЕсли;
					
					ВремяОкончания = НачалоДня(ВремяОкончания);
					
				КонецЕсли;
				
				ВремяНачала = Дата(1, 1, 1)
					+ (ВремяНачала - НачалоДня(ВремяНачала));
				ВремяОкончания = Дата(1, 1, 1)
					+ (ВремяОкончания - НачалоДня(ВремяОкончания));
				
				НоваяСтрока = ТаблицаДоступности.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденнаяСтрока);
				
				НоваяСтрока.ВремяНачала = ВремяНачала;
				НоваяСтрока.ВремяОкончания = ВремяОкончания;
				
				Если НайденнаяСтрока.Занят Тогда
					НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Занят;
				Иначе
					НоваяСтрока.Занят = Перечисления.СостоянияЗанятости.Доступен;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаДоступности;
	
КонецФункции

Процедура ЗаполнитьТаблицуДоступностиПоУмолчаниюДляПользователя(ТаблицаДоступности, Пользователь, Занят)
	
	ВремяНачала = Дата(1, 1, 1);
	ВремяОкончания = КонецДня(ВремяНачала) + 1;
	
	Для ДеньНедели = 1 По 7 Цикл
		
		НоваяСтрока = ТаблицаДоступности.Добавить();
		НоваяСтрока.Пользователь = Пользователь;
		НоваяСтрока.ДеньНедели = ДеньНедели;
		НоваяСтрока.ВремяНачала = ВремяНачала;
		НоваяСтрока.ВремяОкончания = ВремяОкончания;
		НоваяСтрока.Занят = Занят;
		
	КонецЦикла;
	
КонецПроцедуры
