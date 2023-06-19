
Функция ПолучитьОрганизациюПоУмолчанию() Экспорт
	
	ОрганизацияПоУмолчанию = Неопределено;	
	
	ОрганизацияПоУмолчанию = ХранилищеОбщихНастроек.Загрузить("НастройкиРаботыСДокументами", "Организация");
	Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда 
		Возврат ОрганизацияПоУмолчанию;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(НЕ Организации.ПометкаУдаления)
	|	И ЛОЖЬ В
	|			(ВЫБРАТЬ
	|				ЛОЖЬ КАК ЗначениеЛожь
	|			ИЗ
	|				(ВЫБРАТЬ ПЕРВЫЕ 2
	|					ИСТИНА КАК ЗначениеИстина
	|				ИЗ
	|					Справочник.Организации КАК Организации
	|				ГДЕ
	|					(НЕ Организации.ПометкаУдаления)
	|				) КАК ВыбранныеОбъекты
	|			ИМЕЮЩИЕ
	|				КОЛИЧЕСТВО(ВыбранныеОбъекты.ЗначениеИстина) = 1)";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ОрганизацияПоУмолчанию = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат ОрганизацияПоУмолчанию;
	
КонецФункции	

Функция ПолучитьОтветственноеЛицо(ОтветственноеЛицо, Организация, Период) Экспорт
	
	Если Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Организация).Чтение Тогда
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.Пользователь
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОтветственноеЛицо = &ОтветственноеЛицо) КАК ОтветственныеЛицаОрганизацийСрезПоследних";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", Период);
	
	Если ОтветственноеЛицо = "Руководитель" Тогда
		Запрос.УстановитьПараметр("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.РуководительОрганизации);
	ИначеЕсли ОтветственноеЛицо = "РуководительАрхива" Тогда
		Запрос.УстановитьПараметр("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.РуководительАрхива);
	ИначеЕсли ОтветственноеЛицо = "РуководительСлужбыДОУ" Тогда	
		Запрос.УстановитьПараметр("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.РуководительСлужбыДОУ);
	ИначеЕсли ОтветственноеЛицо = "ГлавныйБухгалтер" Тогда
		Запрос.УстановитьПараметр("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ИначеЕсли ОтветственноеЛицо = "УполномоченныйПредставительФНС" Тогда
		Запрос.УстановитьПараметр("ОтветственноеЛицо",
			Перечисления.ОтветственныеЛицаОрганизаций.УполномоченныйПредставительФНС);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Пользователь;
	
КонецФункции	

Функция ПолучитьНаименованиеОрганизации(Организация) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат "";
	КонецЕсли;
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "НаименованиеПолное, Наименование");
	
	Возврат ?(ЗначениеЗаполнено(РеквизитыОрганизации.НаименованиеПолное), РеквизитыОрганизации.НаименованиеПолное, РеквизитыОрганизации.Наименование);
	
КонецФункции

Процедура ПроверитьЗначениеОпцииИспользоватьУчетПоОрганизациямПриЗаписи(Источник, Отказ) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям")
		И Справочники.Организации.КоличествоОрганизаций() > 1 Тогда
		
			УстановитьПривилегированныйРежим(Истина);
			Константы.ИспользоватьУчетПоОрганизациям.Установить(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт

	Если Параметры.Свойство("СтрокаПоиска") 
		И НЕ ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
	
		СтандартнаяОбработка = Ложь;
		
		Текст = Параметры.СтрокаПоиска;
		СловаПоиска = ОбщегоНазначенияДокументооборот.СловаПоиска(Текст);
		ДанныеВыбора = Новый СписокЗначений;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 50
		|	Организации.Ссылка,
		|	""Наименование"" КАК ПолеСовпадения,
		|	Организации.Наименование КАК ЗначениеПоля,
		|	Организации.Представление КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ПометкаУдаления = ЛОЖЬ
		|	И Организации.Наименование ПОДОБНО &Текст
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 50
		|	Организации.Ссылка,
		|	""ИНН"",
		|	Организации.ИНН,
		|	Организации.Представление
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ПометкаУдаления = ЛОЖЬ
		|	И Организации.ИНН ПОДОБНО &Текст
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 50
		|	Организации.Ссылка,
		|	""ОГРН"",
		|	Организации.ОГРН,
		|	Организации.Представление
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ПометкаУдаления = ЛОЖЬ
		|	И Организации.ОГРН ПОДОБНО &Текст";
		
		Запрос.УстановитьПараметр("Текст", "%" + Текст + "%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ПолеСовпадения = "Наименование" Тогда 
				ПредставлениеФорматированнаяСтрока = ОбщегоНазначенияДокументооборот.ФорматированныйРезультатПоиска(
					Выборка.Организация,
					СловаПоиска);
				
				ДобавкаТекста = СтрШаблон(НСтр("ru = ' (%1)'"), "Организация");
					
				ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
					ПредставлениеФорматированнаяСтрока,
					Новый ФорматированнаяСтрока(ДобавкаТекста,
						, WebЦвета.Серый)
					);
							
			ИначеЕсли Выборка.ПолеСовпадения = "ИНН" ИЛИ Выборка.ПолеСовпадения = "ОГРН" Тогда 
				ПредставлениеФорматированнаяСтрока = ОбщегоНазначенияДокументооборот.ФорматированныйРезультатПоиска(
					Выборка.ЗначениеПоля,
					СловаПоиска);
				
				ДобавкаТекста = СтрШаблон(НСтр("ru = ' (%1)'"), Выборка.Организация);
					
				ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
					ПредставлениеФорматированнаяСтрока,
					Новый ФорматированнаяСтрока(ДобавкаТекста,
						, WebЦвета.Серый)
					);
					
			КонецЕсли;
					
			ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
			
		КонецЦикла;
	
	Иначе
		Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	КонецЕсли;

КонецПроцедуры
