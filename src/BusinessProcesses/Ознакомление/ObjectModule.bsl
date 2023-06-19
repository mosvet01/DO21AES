#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//
Процедура ЗаполнитьПоШаблону(ШаблонБизнесПроцесса) Экспорт
	
	Если ШаблонБизнесПроцесса = Справочники.ШаблоныОзнакомления.ПоУмолчанию Тогда
		// Не заполняем шаблон в процессе, если это шаблон по умолчанию.
		// Считаем, что процесс создан с нуля.
	ИначеЕсли ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе 
		И ЗначениеЗаполнено(ШаблонБизнесПроцесса.ИсходныйШаблон) Тогда
		Шаблон = ШаблонБизнесПроцесса.ИсходныйШаблон;
	ИначеЕсли НЕ ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе Тогда
		Шаблон = ШаблонБизнесПроцесса;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса) Тогда 
		Наименование = ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса;
		НаименованиеСПредметами = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(СокрЛП(Наименование), Предметы);
		Если ЗначениеЗаполнено(НаименованиеСПредметами) И ШаблонБизнесПроцесса.ДобавлятьНаименованиеПредмета Тогда
			Наименование = НаименованиеСПредметами;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Описание) Тогда 
		Описание = ШаблонБизнесПроцесса.Описание;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Важность) Тогда 
		Важность = ШаблонБизнесПроцесса.Важность;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Автор) Тогда 
		Автор = ШаблонБизнесПроцесса.Автор;
	КонецЕсли;
	
	// заполнение исполнителей
	Если ШаблонБизнесПроцесса.Исполнители.Количество() > 0 Тогда 
		Исполнители.Очистить();
	КонецЕсли;
	
	ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект,, Истина); 
	
	Для Каждого Строка Из ШаблонБизнесПроцесса.Исполнители Цикл
		
		Если НЕ Строка.Условие.Пустая()
			И ШаблонБизнесПроцесса.ИспользоватьУсловия Тогда
			СтрокаПредмета = Предметы.Найти(Строка.ИмяПредметаУсловия, "ИмяПредмета");
			Если СтрокаПредмета = Неопределено Тогда
				Продолжить;
			Иначе
				Предмет = СтрокаПредмета.Предмет;
				РезультатПроверкиУсловия = РаботаСУсловиямиМаршрутизации.ПроверитьПрименимостьУсловияМаршрутизацииКОбъекту(Предмет, Строка.Условие);
				Если НЕ РезультатПроверкиУсловия Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(Строка.Исполнитель) = Тип("Строка") И ЗначениеЗаполнено(Строка.Исполнитель) Тогда 
			АвтоподстановкаИсполнитель = ШаблоныБизнесПроцессов.ПолучитьЗначениеАвтоподстановки(Строка.Исполнитель, ЭтотОбъект);
			
			Если ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
				
				Если Исполнители.Найти(АвтоподстановкаИсполнитель, "Исполнитель") = Неопределено Тогда 
					НоваяСтрока = Исполнители.Добавить();
					НоваяСтрока.Исполнитель = АвтоподстановкаИсполнитель;
					
					НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
					НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
					НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
					НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
					НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда 	
				
				СтруктураОтбора = Новый Структура("Исполнитель",
					АвтоподстановкаИсполнитель);
					
				Если Исполнители.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда 
					НоваяСтрока = Исполнители.Добавить();
					НоваяСтрока.Исполнитель = АвтоподстановкаИсполнитель;
					
					НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
					НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
					НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
					НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
					НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Структура") Тогда 	
				
				СтруктураОтбора = Новый Структура("Исполнитель",
					АвтоподстановкаИсполнитель.РольИсполнителя);
					
				Если Исполнители.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда 
					НоваяСтрока = Исполнители.Добавить();
					НоваяСтрока.Исполнитель = АвтоподстановкаИсполнитель.РольИсполнителя;
					
					НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
					НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
					НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
					НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
					НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
				КонецЕсли;	
				
			ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Массив") Тогда 
				
				Для Каждого ЭлементМассива Из АвтоподстановкаИсполнитель Цикл
					
					Если ТипЗнч(ЭлементМассива) = Тип("СправочникСсылка.Пользователи") И ЗначениеЗаполнено(ЭлементМассива) Тогда 
						
						Если Исполнители.Найти(ЭлементМассива, "Исполнитель") = Неопределено Тогда 
							НоваяСтрока = Исполнители.Добавить();
							НоваяСтрока.Исполнитель = ЭлементМассива;
							
							НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
							НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
							НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
							НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
							НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
						КонецЕсли;
						
					ИначеЕсли ТипЗнч(ЭлементМассива) = Тип("СправочникСсылка.ПолныеРоли") И ЗначениеЗаполнено(ЭлементМассива)	Тогда 
						
						ПараметрыОтбора = Новый Структура("Исполнитель",
							ЭлементМассива);
					
						Если Исполнители.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда 
							НоваяСтрока = Исполнители.Добавить();
							НоваяСтрока.Исполнитель = ЭлементМассива;
							
							НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
							НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
							НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
							НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
							НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
						КонецЕсли;
						
					ИначеЕсли ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда 	
						
						ПараметрыОтбора = Новый Структура("Исполнитель",
							ЭлементМассива.РольИсполнителя);
					
						Если Исполнители.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда 
							НоваяСтрока = Исполнители.Добавить();
							НоваяСтрока.Исполнитель = ЭлементМассива.РольИсполнителя;
							
							НоваяСтрока.ВариантУстановкиСрокаИсполнения = Строка.ВариантУстановкиСрокаИсполнения;
							НоваяСтрока.СрокИсполнения = Строка.СрокИсполнения;
							НоваяСтрока.СрокИсполненияДни = Строка.СрокИсполненияДни;
							НоваяСтрока.СрокИсполненияЧасы = Строка.СрокИсполненияЧасы;
							НоваяСтрока.СрокИсполненияМинуты = Строка.СрокИсполненияМинуты;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;	
		Иначе
			СтруктураОтбора = Новый Структура("Исполнитель",
				Строка.Исполнитель);
		
			НайденныеСтроки = Исполнители.НайтиСтроки(СтруктураОтбора);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НоваяСтрока = Исполнители.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	// Срок исполнения процесса
	СрокИсполненияПроцесса = ШаблонБизнесПроцесса.СрокИсполненияПроцесса;
	
	// трудозатраты
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ТрудозатратыПланИсполнителя = ШаблонБизнесПроцесса.ТрудозатратыПланИсполнителя;
	КонецЕсли;	
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ШаблонБизнесПроцесса, ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ШаблонДляОтложенногоСтарта", ШаблонБизнесПроцесса);
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса, предмета и автора.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//  Предмет - предмет бизнес-процесса
//  Автор  - автор
//
Процедура ЗаполнитьПоШаблонуИПредмету(ШаблонБизнесПроцесса, ПредметСобытия, АвторСобытия) Экспорт
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонБизнесПроцесса, ЭтотОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ПредметСобытия, Ложь, Истина);
	ЗаполнитьПоШаблону(ШаблонБизнесПроцесса);
	
	Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ПредметСобытия);
	
	Дата = ТекущаяДатаСеанса();
	Автор = АвторСобытия;
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании проектной задачи
//
Процедура ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения) Экспорт 
	
	Проект = ДанныеЗаполнения.Владелец;
	ПроектнаяЗадача = ДанныеЗаполнения;
	
	ДобавлятьНаименованиеПредмета = РаботаСБизнесПроцессами.ДобавлятьНаименованиеПредмета(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Наименование)
		Или Наименование = НаименованиеПроцессаПоУмолчанию(ДобавлятьНаименованиеПредмета) Тогда
		
		Наименование = ПроектнаяЗадача.Наименование;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Описание) Тогда 
		Описание = ПроектнаяЗадача.Описание;
	КонецЕсли;
	
	Если Предметы.Количество() = 0 Тогда 
		Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроектнаяЗадача, "Предмет");
		
		Если Предмет <> Неопределено И Предметы.Найти(Предмет,"Предмет") = Неопределено Тогда
			СтрокаПредметов = Предметы.Добавить();
			СтрокаПредметов.РольПредмета = Перечисления.РолиПредметов.Основной;
			СтрокаПредметов.ИмяПредмета =  МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(
				Предмет, Предметы.ВыгрузитьКолонку("ИмяПредмета"));
			СтрокаПредметов.Предмет = Предмет;
		КонецЕсли;
	КонецЕсли;
		
	Если Исполнители.Количество() = 0
		И ПроектнаяЗадача.Исполнители.Количество() > 0 Тогда
		
		ДанныеПроектнойЗадачи = РаботаСПроектами.ПолучитьСрокиПроектнойЗадачи(ПроектнаяЗадача);
		ТекущийПланОкончание = ДанныеПроектнойЗадачи.ТекущийПланОкончание;
		
		Для Каждого СтрокаИсполнитель Из ПроектнаяЗадача.Исполнители Цикл 
			Если ТипЗнч(СтрокаИсполнитель.Исполнитель) = Тип("СправочникСсылка.Пользователи") 
			 Или ТипЗнч(СтрокаИсполнитель.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда 
				НоваяСтрока = Исполнители.Добавить();
				НоваяСтрока.Исполнитель = СтрокаИсполнитель.Исполнитель;
				НоваяСтрока.СрокИсполнения = ТекущийПланОкончание;
				НоваяСтрока.ВариантУстановкиСрокаИсполнения = Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
	ТрудозатратыПланИсполнителя = РаботаСПроектами.МинимальныеТрудозатратыИсполнителей(ПроектнаяЗадача.Исполнители);
	
КонецПроцедуры

Процедура ЗаполнитьПоРассмотрению(Рассмотрение) Экспорт
	
	Если ТипЗнч(Рассмотрение.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
		Автор = Рассмотрение.Исполнитель;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			| ЗадачаИсполнителя.Исполнитель
			|ИЗ
			| Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
			|ГДЕ
			| ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
			| И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута";
		Запрос.УстановитьПараметр("БизнесПроцесс", Рассмотрение.Ссылка);
		Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.Рассмотрение.ТочкиМаршрута.Рассмотреть);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Автор = Выборка.Исполнитель;
	КонецЕсли;
	
	Наименование = Рассмотрение.НаименованиеОзнакомления;
	
	СрокИсполненияПроцесса = Рассмотрение.СрокИсполненияПроцессаОзнакомления;
	
	Описание = Рассмотрение.ОписаниеОзнакомления;
	Важность = Рассмотрение.ВажностьОзнакомления;
	
	Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, Рассмотрение);
	
	ТрудозатратыПланИсполнителя = Рассмотрение.ТрудозатратыПланИсполнителяОзнакомления;
	
	Исполнители.Загрузить(Рассмотрение.ИсполнителиОзнакомления.Выгрузить());
	
	Проект = Рассмотрение.Проект;
	ПроектнаяЗадача = Рассмотрение.ПроектнаяЗадача;
	
КонецПроцедуры	

// Возвращает признак наличия метода ИзменитьРеквизитыНевыполненныхЗадач
//
Функция ЕстьМетодИзменитьРеквизитыНевыполненныхЗадач() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Обновляет значения реквизитов невыполненных задач 
// при изменении реквизитов бизнес-процесса.
//
Процедура ИзменитьРеквизитыНевыполненныхЗадач(СтарыеУчастникиПроцесса, ПараметрыЗаписи) Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	СтарыеИсполнители = СтарыеУчастникиПроцесса.Исполнители;
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Задачи.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.ПометкаУдаления = ЛОЖЬ
		|	И Задачи.Выполнена = ЛОЖЬ";
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗаблокироватьДанныеДляРедактирования(ЗадачаОбъект.Ссылка);
			ЗадачаОбъект.Важность = Важность;
			ЗадачаОбъект.Описание = Описание;
			ЗадачаОбъект.Автор = Автор;
			
			СтрИсполнителя = Исполнители.Найти(ЗадачаОбъект.Ссылка, "ЗадачаИсполнителя");
			
			Если СтрИсполнителя <> Неопределено Тогда
				
				СрокиИсполненияПроцессов.ЗаполнитьСрокИсполненияЗадачи(
					ЗадачаОбъект,
					СтрИсполнителя.ВариантУстановкиСрокаИсполнения,
					СтрИсполнителя.СрокИсполнения,
					СтрИсполнителя.СрокИсполненияДни,
					СтрИсполнителя.СрокИсполненияЧасы,
					СтрИсполнителя.СрокИсполненияМинуты);
				
			КонецЕсли;
			
			ЗадачаОбъект.Наименование = Наименование;
			
			ЗадачаОбъект.Проект = Проект;
			ЗадачаОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
			
			ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ЗадачаОбъект, ДополнительныеСвойства);
			
			ЗадачаОбъект.Записать();
		КонецЦикла;
		
		// обновление исполнителей
		ДобавленныеСтроки = Новый Массив;
		УдаленныеСтроки   = Новый Массив;
		ИзмененныеСтроки  = Новый Массив;
		
		КоличествоСтрок = СтарыеИсполнители.Количество();
		Для Инд = 1 По КоличествоСтрок Цикл
			Строка = СтарыеИсполнители[КоличествоСтрок-Инд];
			Если Строка.Пройден Или Не ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) Тогда 
				СтарыеИсполнители.Удалить(Строка);
			КонецЕсли;	
		КонецЦикла;	
		
		НовыеИсполнители = ЭтотОбъект.Исполнители.Выгрузить();
		КоличествоСтрок = НовыеИсполнители.Количество();
		Для Инд = 1 По КоличествоСтрок Цикл
			Строка = НовыеИсполнители[КоличествоСтрок-Инд];
			Если Строка.Пройден Тогда
				НовыеИсполнители.Удалить(Строка);
			КонецЕсли;
		КонецЦикла;	
		
		КоличествоСтрок = НовыеИсполнители.Количество();
		Для Инд = 0 По КоличествоСтрок-1 Цикл
			Строка = НовыеИсполнители[Инд];			
			Если Не ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) Тогда 
				ДобавленныеСтроки.Добавить(Строка);				
			КонецЕсли;
		КонецЦикла;	
		
		Для Каждого Строка Из НовыеИсполнители Цикл
			Если Не ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) Тогда 
				Продолжить;
			КонецЕсли;	
			
			НайденнаяСтрока = СтарыеИсполнители.Найти(Строка.ЗадачаИсполнителя, "ЗадачаИсполнителя");
			Если НайденнаяСтрока = Неопределено Тогда 
				Продолжить;
			КонецЕсли;	
				
			Если Строка.Исполнитель <> НайденнаяСтрока.Исполнитель Тогда 
				ИзмененныеСтроки.Добавить(Строка);
			КонецЕсли;
		КонецЦикла;	
		
		Для Каждого Строка Из СтарыеИсполнители Цикл
			НайденнаяСтрока = НовыеИсполнители.Найти(Строка.ЗадачаИсполнителя, "ЗадачаИсполнителя");
		    Если НайденнаяСтрока = Неопределено Тогда 
				УдаленныеСтроки.Добавить(Строка);
			КонецЕсли;
		КонецЦикла;	
		
		// добавленные строки
		Для Каждого Строка Из ДобавленныеСтроки Цикл
			
			Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			ЗаполнитьЗадачуОзнакомиться(Задача, Строка, БизнесПроцессы.Ознакомление.ТочкиМаршрута.Ознакомиться);
			Задача.Записать();
			
			НайденнаяСтрока = ЭтотОбъект.Исполнители.Найти(Строка.НомерСтроки, "НомерСтроки");
			Если НайденнаяСтрока <> Неопределено Тогда 
				НайденнаяСтрока.ЗадачаИсполнителя = Задача.Ссылка;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ДобавленныеСтроки.Количество() > 0 Тогда 
			Записать();
		КонецЕсли;
		
		// измененные строки
		Для Каждого Строка Из ИзмененныеСтроки Цикл	
			Задача = Строка.ЗадачаИсполнителя.ПолучитьОбъект();
			
			Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
				
				Если Задача.ПринятаКИсполнению Тогда
					Задача.ПринятаКИсполнению = Ложь;
					Задача.ДатаПринятияКИсполнению = '00010101';
				КонецЕсли;
				
				Задача.Исполнитель = Строка.Исполнитель;
				Задача.РольИсполнителя = Неопределено;
			Иначе	
				Задача.Исполнитель = Неопределено;
				Задача.РольИсполнителя = Строка.Исполнитель;
			КонецЕсли;	
			
			Задача.Записать();
		КонецЦикла;

		// удаленные строки
		Если УдаленныеСтроки.Количество() > 0 Тогда 
		
			Для Каждого Строка Из УдаленныеСтроки Цикл	
				Задача = Строка.ЗадачаИсполнителя.ПолучитьОбъект();
				Задача.ИсключитьИзПроцесса();
			КонецЦикла;	
			Прочитать();
			Записать();
			
		КонецЕсли;

		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры 

// Формирует шаблон по процессу
// Параметры:
//	ВладелецШаблона - ссылка на шаблон комплексного процесса или комплексный процесс, который будет владельцем
//		создаваемого шаблона процесса
// Возвращает:
//	Ссылка на созданный шаблон
Функция СоздатьШаблонПоПроцессу(ВладелецШаблона = Неопределено) Экспорт
	
	ИмяТипа = БизнесПроцессы[ЭтотОбъект.Метаданные().Имя].ТипШаблона();	
	ШаблонОбъект = Справочники[СтрЗаменить(ИмяТипа, "Справочник.", "")].СоздатьЭлемент();
	
	// Перенос базовых реквизитов процесса
	ШаблонОбъект.Наименование = Наименование;
	ШаблонОбъект.НаименованиеБизнесПроцесса = Наименование;
	ШаблонОбъект.Описание = Описание;
	ШаблонОбъект.Важность = Важность;
	ШаблонОбъект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ШаблонОбъект.ВладелецШаблона = ВладелецШаблона;
	
	ШаблонОбъект.Предметы.Загрузить(Предметы.Выгрузить());
	Для Каждого СтрокаПредмета Из ШаблонОбъект.Предметы Цикл
		Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтрокаПредмета.Предмет.Метаданные().ПолноеИмя()).ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	ШаблонОбъект.ПредметыЗадач.Загрузить(ПредметыЗадач.Выгрузить());
	
	// Перенос исполнителей
	ШаблонОбъект.Исполнители.Очистить();
	Для Каждого Исполнитель Из Исполнители Цикл
		ИсполнительШаблона = ШаблонОбъект.Исполнители.Добавить();
		ЗаполнитьЗначенияСвойств(
			ИсполнительШаблона,
			Исполнитель,
			"Исполнитель, СрокИсполненияДни, СрокИсполненияЧасы, СрокИсполненияМинуты");
			
		ИсполнительШаблона.ВариантУстановкиСрокаИсполнения = 
			Перечисления.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок;
	КонецЦикла;
	ШаблонОбъект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();	
	ШаблонОбъект.Записать();
	Возврат ШаблонОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Проверяет права участников процесса на предметы этого процесса.
// Если у участников процесса отсутствуют права на предметы, то выводятся сообщения с привязкой
// к карточке процесса.
//
// Параметры
//  ПроцессОбъект - БизнесПроцессОбъект - процесс.
//  Отказ - Булево - в этот параметр помещается значение Истина, если кто-то из участников не имеет
//                   прав на предметы.
//  ПроверятьПриИзменении - Булево - если указано значение Истина, то проверка выполняется только если
//                          изменены участники или предметы процесса, иначе проверка выполняется всегда.
//
Процедура ПроверитьПраваУчастниковПроцессаНаПредметы(
	ПроцессОбъект, Отказ, ПроверятьПриИзменении) Экспорт
	
	Мультипредметность.ПроверитьПраваУчастниковПроцессаНаПредметы(
		ПроцессОбъект, Отказ, ПроверятьПриИзменении);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ЭтоНовый() Тогда 
		Дата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(Автор) Тогда
			Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения, Ложь, Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ЗадачаСсылка = ДанныеЗаполнения;
		ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
			ЗадачаСсылка = ДанныеЗаполнения.ЗадачаИсполнителя;
			ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Исполнители") Тогда
			Для Каждого Исполнитель ИЗ ДанныеЗаполнения.Исполнители Цикл
				Строка = Исполнители.Добавить();
				Строка.Исполнитель = Исполнитель;
			КонецЦикла;
		КонецЕсли;
		
		ТипыПисем = МультипредметностьПереопределяемый.ПолучитьТипыПисем();
		ОсновныеПисьма = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыПисем, Истина);
		Для Каждого Письмо Из ОсновныеПисьма Цикл
			Тема = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Тема");
			Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Проект");
			Если Не ЗначениеЗаполнено(Наименование) Тогда
				Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ознакомиться ""%1""'"),
					Тема);
			КонецЕсли;
			Прервать;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда 	
		
		ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) И Предметы.Количество() > 0 Тогда
		МультипредметностьКлиентСервер.ЗаполнитьНаименованиеПроцесса(ЭтотОбъект, НСтр("ru = 'Ознакомиться'"));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеМероприятиями") Тогда 
		УправлениеМероприятиями.ЗаполнитьБизнесПроцессПоМероприятию(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Мультипредметность.ПроверитьКорректностьТиповОсновныхПредметов(ЭтотОбъект, Отказ);
	
	РаботаСБизнесПроцессамиКлиентСервер.ПроверитьНаДублиТаблицуИсполнителей(
		Исполнители, "Объект.Исполнители", Отказ, Ложь);
	
	// Проверка прав участников процесса на предметы
	Если Не РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		ПроверитьПраваУчастниковПроцессаНаПредметы(ЭтотОбъект, Отказ, Стартован);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбычнаяЗапись = Истина;
	ТолькоОбновлениеРабочейГруппыПроцессов = Ложь;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		
		ОбычнаяЗапись = Ложь;
		
		ТолькоОбновлениеРабочейГруппыПроцессов = 
			(ДополнительныеСвойства.ВидЗаписи =
			"ЗаписьСОбновлением_Предметов_ПредметовЗадач_Проекта_ОбщегоСпискаПроцессов_РабочихГруппПредметов_РабочихГруппПроцессов_ДопРеквизитовПоПредметам");
		
		Если Не ТолькоОбновлениеРабочейГруппыПроцессов Тогда 
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
	
		Если Не РаботаСБизнесПроцессамиВызовСервера.ПроверитьПередЗаписью(ЭтотОбъект) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;	
		
		ПредыдущаяПометкаУдаления = Ложь;
		Если Не Ссылка.Пустая() Тогда
			ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
		КонецЕсли;
		ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
			
			ПредметыДляУстановки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект,, Истина);
			
			Если ПометкаУдаления Тогда 
				Для Каждого Предмет Из ПредметыДляУстановки Цикл
					ПриОткрепленииПредмета(Предмет);
				КонецЦикла;
			Иначе
				ВосстановитьСостояниеПредметов();
			КонецЕсли;
		КонецЕсли;
		
		ПредыдущееСостояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Состояние");
		Если Состояние = Перечисления.СостоянияБизнесПроцессов.Прерван
			И Состояние <> ПредыдущееСостояние Тогда
			КомпенсироватьСостояниеПредметов();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Или ТолькоОбновлениеРабочейГруппыПроцессов Тогда
		// Обработка рабочей группы	
		РаботаСБизнесПроцессамиВызовСервера.СформироватьРабочуюГруппу(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	СтартПроцессовСервер.ПроцессПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачала = '00010101';
	ДатаЗавершения = '00010101';
	
КонецПроцедуры

/////////////////////////////
// Карта маршрута

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	ЗаписатьСостояниеПредметовНаИсполнении();
	
	РаботаСПроектами.ОтметитьНачалоВыполненияПроектнойЗадачи(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОзнакомитьсяПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого Строка Из Исполнители Цикл
		
		Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		ЗаполнитьЗадачуОзнакомиться(Задача, Строка, ТочкаМаршрутаБизнесПроцесса);
		ФормируемыеЗадачи.Добавить(Задача);
		
	КонецЦикла;
	
	РаботаСБизнесПроцессами.ЗаписатьПроцесс(ЭтотОбъект, "ЗаписьСОбновлениемРезультатаВыполнения");
	
КонецПроцедуры

Процедура ОзнакомитьсяОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура ОзнакомитьсяПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Исполнитель Из Исполнители Цикл
		Если Исполнитель.ЗадачаИсполнителя = Задача Тогда
			Исполнитель.Пройден = Истина;
			
			РаботаСБизнесПроцессами.ЗаписатьПроцесс(ЭтотОбъект, "ЗаписьСОбновлениемРезультатаВыполнения");
			
			Возврат;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗавершения = ТекущаяДатаСеанса();
	
	ЗаписатьСостояниеПредметовИсполнен();
	
	РаботаСПроектами.ОтметитьОкончаниеВыполненияПроектнойЗадачи(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЗадачуОзнакомиться(Задача, Исполнитель, ТочкаМаршрута)
	
	Задача.Дата  	= ТекущаяДатаСеанса();
	Задача.Автор 	= Автор;
	Задача.Описание = Описание;
	Задача.Важность	= Важность;
	
	Мультипредметность.ЗадачаПередСозданием(ЭтотОбъект, Задача, ТочкаМаршрута);
	
	Задача.Наименование = Наименование;
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрута;
	
	Задача.Проект = Проект;
	Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	
	Если ТипЗнч(Исполнитель.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		Задача.Исполнитель = Исполнитель.Исполнитель;
	Иначе	
		Задача.РольИсполнителя = Исполнитель.Исполнитель;
	КонецЕсли;
	
	СрокиИсполненияПроцессов.ЗаполнитьСрокИсполненияЗадачи(
		Задача,
		Исполнитель.ВариантУстановкиСрокаИсполнения,
		Исполнитель.СрокИсполнения,
		Исполнитель.СрокИсполненияДни,
		Исполнитель.СрокИсполненияЧасы,
		Исполнитель.СрокИсполненияМинуты);
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Задача.БизнесПроцесс, Задача);
	
	ЗадачаСсылка = Задачи.ЗадачаИсполнителя.ПолучитьСсылку();
	Задача.УстановитьСсылкуНового(ЗадачаСсылка);
	
	Исполнитель.ЗадачаИсполнителя = ЗадачаСсылка;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

Процедура ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка)
	
	РаботаСБизнесПроцессами.ЗаполнитьБизнесПроцессПоЗадаче(ЭтотОбъект, ЗадачаСсылка);
	
КонецПроцедуры

// Восстанавливает состояние предмета БП при отмене удаления
//
Процедура ВосстановитьСостояниеПредметов()
	
	Если ЗначениеЗаполнено(ДатаНачала) Тогда 
		ЗаписатьСостояниеПредметовНаИсполнении();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаЗавершения) Тогда 
		ЗаписатьСостояниеПредметовИсполнен();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСостояниеПредметовНаИсполнении(Предмет = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеМероприятиями") Тогда 
		УправлениеМероприятиями.УстановитьСостояниеМероприятияИзБизнесПроцесса(ЭтотОбъект, БизнесПроцессы.Ознакомление.ТочкиМаршрута.Старт);
	КонецЕсли;
	
	ТипыПредметов = Новый Массив;
	ТипыПредметов.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	ТипыПредметов.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы"));
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		ПредметыДляУстановки = Новый Массив;
		Если ТипыПредметов.Найти(ТипЗнч(Предмет)) <> Неопределено Тогда
			ПредметыДляУстановки.Добавить(Предмет);
		КонецЕсли;
	Иначе
		ПредметыДляУстановки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(
			ЭтотОбъект, ТипыПредметов, Истина);
	КонецЕсли;
	
	Если ПредметыДляУстановки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		БизнесПроцессСсылка = Ссылка;
	Иначе
		БизнесПроцессСсылка = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(БизнесПроцессСсылка) Тогда
			БизнесПроцессСсылка = БизнесПроцессы.Ознакомление.ПолучитьСсылку();
			УстановитьСсылкуНового(БизнесПроцессСсылка);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого СтрПредмет Из ПредметыДляУстановки Цикл
		Делопроизводство.ЗаписатьСостояниеДокумента(
			СтрПредмет,
			ДатаНачала,
			Перечисления.СостоянияДокументов.НаИсполнении,
			БизнесПроцессСсылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьСостояниеПредметовИсполнен(Предмет = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеМероприятиями") Тогда 
		УправлениеМероприятиями.УстановитьСостояниеМероприятияИзБизнесПроцесса(ЭтотОбъект, БизнесПроцессы.Ознакомление.ТочкиМаршрута.Завершение);
	КонецЕсли;	
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы"));
	
	ПредметыДляУстановки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, МассивТипов, Истина);
	
	Если ПредметыДляУстановки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ДатаИсполнения = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЗадачаИсполнителя.ДатаИсполнения) КАК ДатаИсполнения
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	БизнесПроцесс = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		ДатаИсполнения = Выборка.ДатаИсполнения;
	КонецЕсли;
	
	Делопроизводство.УстановитьСостояниеИсполненПредметамПроцесса(Ссылка,
		ПредметыДляУстановки,
		ДатаИсполнения);
	
КонецПроцедуры

// Возвращает признак наличия метода ПриПрикрепленииПредмета
// 
Функция ЕстьМетодПриПрикрепленииПредмета() Экспорт
	Возврат Истина;
КонецФункции

// Вызывается при прикреплении предмета к стартованному БП
//
Процедура ПриПрикрепленииПредмета(Предмет = Неопределено) Экспорт
	
	ЗаписатьСостояниеПредметовНаИсполнении(Предмет);
	
КонецПроцедуры

// Возвращает признак наличия метода ПриОткрепленииПредмета
// 
Функция ЕстьМетодПриОткрепленииПредмета() Экспорт
	Возврат Истина;
КонецФункции

// Вызывается при откреплении предмета от стартованного БП
//
Процедура ПриОткрепленииПредмета(Документ = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Документ) Тогда 
		Делопроизводство.УдалитьСостояниеДокумента(Документ, Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

// Компенсирует состояние документа при прерывании БП
//
Процедура КомпенсироватьСостояниеПредметов() Экспорт
	
	ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект,, Истина);
	
	Для Каждого Предмет Из ОсновныеПредметы Цикл
		Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Предмет) Тогда 
			Делопроизводство.УдалитьСостояниеДокумента(Предмет, Ссылка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описание задачи, специфичное для бизнес-процесса
Функция ПолучитьОписаниеУведомленияЗадачи(Задача, КодЯзыкаПолучателя) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы со стартом процесса

Процедура ОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.СтартоватьПроцессОтложенно(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОтключитьОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.ОтключитьОтложенныйСтарт(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для поддержки комплексных процессов

// Дополняет описание процесса общим описанием
Процедура ДополнитьОписание(ОбщееОписание) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ОбщееОписание) Тогда
		Возврат;
	КонецЕсли;
	Описание = ОбщееОписание + Символы.ПС + Описание;
	
КонецПроцедуры



// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	
	Если Исполнители.Количество() = 0 Тогда
		МассивПолей.Добавить("Исполнители");
	КонецЕсли;
	
	Возврат МассивПолей;
	
КонецФункции

Функция НаименованиеПроцессаПоУмолчанию(ДобавлятьНаименованиеПредмета)
	
	НаименованиеПоУмолчанию = НСтр("ru = 'Ознакомиться '");
	
	Если ДобавлятьНаименованиеПредмета Тогда
		НаименованиеПоУмолчанию = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(
			СокрЛП(НаименованиеПоУмолчанию), Предметы);
	КонецЕсли;
	
	Возврат НаименованиеПоУмолчанию;
	
КонецФункции

#КонецЕсли
