
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОПользователяхДокументооборот.Подразделение,
			|	СведенияОПользователяхДокументооборот.Должность
			|ИЗ
			|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
			|ГДЕ
			|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", Отбор.Пользователь.Значение);

		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДополнительныеСвойства.Вставить("Подразделение", Выборка.Подразделение);
			ДополнительныеСвойства.Вставить("Должность", Выборка.Должность);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	
	Подразделения = Новый Массив();
	Должности = Новый Массив();
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОПользователяхДокументооборот.Подразделение,
			|	СведенияОПользователяхДокументооборот.Должность
			|ИЗ
			|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
			|ГДЕ
			|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", Запись.Пользователь);

		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Подразделения.Найти(Выборка.Подразделение) = Неопределено Тогда
				Подразделения.Добавить(Выборка.Подразделение);	
			КонецЕсли;
			Если Должности.Найти(Выборка.Должность) = Неопределено Тогда
				Должности.Добавить(Выборка.Должность);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;	
	
	ДополнительныеСвойства.Вставить("Подразделения", Подразделения);
	ДополнительныеСвойства.Вставить("Должности", Должности);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		
		Если ДополнительныеСвойства.Свойство("Подразделение") Тогда
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				ДополнительныеСвойства.Подразделение);
				
			// Обновление адресной книги
			ОбновитьСписокПользователейПодразделенияВАдреснойКниге(ДополнительныеСвойства.Подразделение);
			
			// Обновление пользователей в контейнерах.
			РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(ДополнительныеСвойства.Подразделение);
			
		КонецЕсли;
		
		// Обновление адресной книги
		Если ДополнительныеСвойства.Свойство("Должность") Тогда
			ОбновитьСловаПоискаПользователейПоДолжности(ДополнительныеСвойства.Должность);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Подразделения = Новый Массив();
	ОбработанныеКонтейнеры = Новый Массив;
	
	Если ДополнительныеСвойства.Свойство("Подразделения") Тогда
		
		Подразделения = ДополнительныеСвойства.Подразделения;
		
		Для Каждого Подразделение Из Подразделения Цикл
			
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				Подразделение);
				
			// Обновление адресной книги
			ОбновитьСписокПользователейПодразделенияВАдреснойКниге(Подразделение);
			
			// Обновление пользователей в контейнерах.
			РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(
				Подразделение,
				ОбработанныеКонтейнеры);
			
		КонецЦикла;
			
	КонецЕсли;	
	
	Должности = ДополнительныеСвойства.Должности;
	// Обновление адресной книги
	Для Каждого Должность ИЗ Должности Цикл
		ОбновитьСловаПоискаПользователейПоДолжности(Должность);
	КонецЦикла;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Подразделения.Найти(Запись.Подразделение) = Неопределено Тогда
			
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				Запись.Подразделение);
				
			// Обновление адресной книги
			ОбновитьСписокПользователейПодразделенияВАдреснойКниге(Запись.Подразделение);
				
			// Обновление пользователей в контейнерах.
			РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(
				Запись.Подразделение,
				ОбработанныеКонтейнеры);
				
			Подразделения.Добавить(Запись.Подразделение);	
		КонецЕсли;
		
		// Обновление адресной книги
		Если Должности.Найти(Запись.Должность) = Неопределено Тогда
			ОбновитьСловаПоискаПользователейПоДолжности(Запись.Должность);
			Должности.Добавить(Запись.Должность);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьСписокПользователейПодразделенияВАдреснойКниге(Подразделение)
	
	ПользователиПодразделения = 
		РаботаСПользователями.ПолучитьПользователейПодразделения(Подразделение,,Ложь);
	Справочники.АдреснаяКнига.РасширитьСписокПользователейРолями(ПользователиПодразделения);
	
	РеквизитыПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Подразделение, "Ссылка, Наименование, Родитель, ПометкаУдаления");
	
	Справочники.АдреснаяКнига.ОбновитьСписокПодчиненныхОбъектов(
		Подразделение,
		РеквизитыПодразделения.Родитель,
		ПользователиПодразделения,
		Справочники.АдреснаяКнига.ПоСтруктуреПредприятия);
		
	РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоПодразделению(РеквизитыПодразделения);
	
КонецПроцедуры

Процедура ОбновитьСловаПоискаПользователейПоДолжности(Должность)
	
	РеквизитыДолжности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Должность, "Ссылка, Наименование, ПометкаУдаления");
	
	РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоДолжности(РеквизитыДолжности);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли