#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет, обозначает ли состояние исходящего электронного документа, что он отклонен контрагентом.
//
// Параметры:
//  СостояниеЭДО - ПеречислениеСсылка.СостоянияЭДОДокументооборот - Состояние исходящего электронного документа.
// 
// Возвращаемое значение:
//  Булево - Состояние обозначает, что исходящий электронный документ отклонен контрагентом.
//
Функция ИсходящийОтклоненКонтрагентом(СостояниеЭДО) Экспорт
	
	ИсходящийОтклоненКонтрагентом =
		СостояниеЭДО = ЗакрытСОтклонением
		Или СостояниеЭДО = ОтклоненПолучателем
		Или СостояниеЭДО = ТребуетсяУточнение;
	
	Возврат ИсходящийОтклоненКонтрагентом;
	
КонецФункции

// Определяет, обозначает ли состояние электронного документа, что обмен по ЭДО выполнен успешно.
//
// Параметры:
//  СостояниеЭДО - ПеречислениеСсылка.СостоянияЭДОДокументооборот - Состояние электронного документа.
// 
// Возвращаемое значение:
//  Булево - Состояние обозначает, что обмен по ЭДО выполнен успешно.
//
Функция ОбменВыполненУспешно(СостояниеЭДО) Экспорт
	
	ОбменВыполненУспешно =
		СостояниеЭДО = ОбменЗавершен
		Или СостояниеЭДО = ОбменЗавершенСИсправлением;
	
	Возврат ОбменВыполненУспешно;
	
КонецФункции

// Определяет, обозначает ли состояние электронного документа, что документ аннулирован
//
// Параметры:
//  СостояниеЭДО - ПеречислениеСсылка.СостоянияЭДОДокументооборот - Состояние электронного документа.
// 
// Возвращаемое значение:
//  Булево - Состояние обозначает, что документ аннулирован.
//
Функция ДокументАннулирован(СостояниеЭДО) Экспорт
	
	ДокументАннулирован =
		СостояниеЭДО = Аннулирован;
	
	Возврат ДокументАннулирован;
	
КонецФункции

// Определяет, обозначает ли состояние электронного документа, что документ аннулирован
//
// Параметры:
//  СостояниеЭДО - ПеречислениеСсылка.СостоянияЭДОДокументооборот - Состояние электронного документа.
// 
// Возвращаемое значение:
//  Булево - Состояние обозначает, что документ аннулирован.
//
Функция ТребуетсяАннулирование(СостояниеЭДО) Экспорт
	
	ТребуетсяАннулирование =
		СостояниеЭДО = ТребуетсяАннулировать;
	
	Возврат ТребуетсяАннулирование;
	
КонецФункции


// Возвращает все состояния завершения обработки
// 
// Возвращаемое значение:
//  Массив - массив значений перечисления
//
Функция СостоянияОработано() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(НеСформирован);
	Результат.Добавить(ОбменЗавершен);
	Результат.Добавить(ОбменЗавершенСИсправлением);
	Результат.Добавить(ЗакрытПринудительно);
	Возврат Результат;
	
КонецФункции

// Возвращает все состояния от начала до завершения обработки
// 
// Возвращаемое значение:
//  Массив - массив значений перечисления
//
Функция СостоянияВРаботе() Экспорт
	
	Результат = Новый Массив;
	Кроме = СостоянияОработано();
	Кроме.Добавить(НеСформирован);
	
	Для Ин = 0 По Количество()-1 Цикл
		Если Кроме.Найти(Получить(Ин)) = Неопределено Тогда
			Результат.Добавить(Получить(Ин));
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Список значений перечисления с адаптированными представлениями
//
// Параметры:
//  ДляОрганизации		 - Булево - сторона обмена. Истина - для нашей организации, Ложь - для внешнего контрагента.
//  ТолькоПредставления	 - Булево - список только значений передставления. Без значений перечисления.
//  ДобавлятьГруппы		 - Булево - включать виртуальные группы значений перечисления для отборов сразу по нескольким значениям.
//  ДобавлятьОформление	 - Булево - выделять группы доступным оформлением.
// 
// Возвращаемое значение:
//   - СписокЗначений
//
Функция СписокПредставлений(ДляОрганизации = Истина, ТолькоПредставления = Ложь, ДобавлятьГруппы = Ложь, ДобавлятьОформление = Ложь) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Группы = ГруппыСостоянийПредставления();
	Если ТолькоПредставления Тогда
		Если ДобавлятьГруппы Тогда
			Эл = Результат.Добавить(Группы.ВРаботе);
			Если ДобавлятьОформление Тогда
				Эл.Представление = Новый ФорматированнаяСтрока(Эл.Значение, Новый Шрифт(,,,Истина));
			Иначе
				Эл.Представление = Эл.Значение;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ДобавлятьГруппы Тогда
		ГруппыСостояний = Новый Соответствие;
		Для Каждого Эл Из СостоянияВРаботе() Цикл
			ГруппыСостояний.Вставить(Эл, Группы.ВРаботе);
		КонецЦикла;
		Для Каждого Эл Из СостоянияОработано() Цикл
			ГруппыСостояний.Вставить(Эл, Группы.Обработано);
		КонецЦикла;
		ГруппыСостояний.Вставить(НеСформирован, Группы.НеНачато);
		
	КонецЕсли;
	
	Параметры = Новый Структура("Дата,Направление,Состояние", '00010101');
	
	Для Каждого Направление Из Перечисления.НаправленияЭДО.ПолучитьДанныеВыбора(Новый Структура()) Цикл
		Параметры.Направление = Направление.Значение.Значение;
		
		Для Ин = 0 По Количество()-1 Цикл
			Параметры.Состояние = Получить(Ин);
			
			Если Не ДобавлятьГруппы И Параметры.Состояние = НеСформирован Тогда
				Продолжить;
			КонецЕсли;
			
			Значение = ОбменСКонтрагентамиДОСервер.ПолучитьОписаниеСостоянияЭДО(Неопределено, Ложь, Параметры)
				[?(ДляОрганизации, "СостояниеСНашейСтороны", "СостояниеСоСтороныКонтрагента")];
				
			Если ЗначениеЗаполнено(Значение) Тогда
				Если ТолькоПредставления Тогда
					Если Результат.НайтиПоЗначению(Значение) = Неопределено Тогда
						Результат.Добавить(Значение, Значение);
					КонецЕсли;
				ИначеЕсли ДобавлятьГруппы Тогда
					Результат.Добавить(Новый Структура("Значение,Направление,Группа", Параметры.Состояние, Параметры.Направление, ГруппыСостояний.Получить(Параметры.Состояние)), Значение);
				Иначе
					Результат.Добавить(Новый Структура("Значение,Направление", Параметры.Состояние, Параметры.Направление), Значение);
				КонецЕсли;
			Конецесли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значения перечисления по представлению
//
// Параметры:
//  Представления	 - Строка,СписокЗначений,Массив - строковое представление значения.
//  ДляОрганизации	 - Булево - сторона обмена. См. функцию СписокПредставлений().
// 
// Возвращаемое значение:
//   - Массив - значений перечисления.
//
Функция ЗначенияПоПредсталению(Представления, ДляОрганизации = Истина) Экспорт
	
	Значения = СписокПредставлений(ДляОрганизации, Ложь, Истина);
	
	Если ТипЗнч(Представления) = Тип("СписокЗначений") Тогда
		Результат = Новый СписокЗначений;
		
		Для Каждого Значение Из Значения Цикл
			Для Каждого Представление Из Представления Цикл
				Если (Значение.Представление = Представление.Значение Или Значение.Значение.Группа = Представление.Значение)
					И Результат.НайтиПоЗначению(Значение.Значение.Значение) = Неопределено Тогда
					Результат.Добавить(Значение.Значение.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Представления) = Тип("Массив") Тогда
		Результат = Новый Массив;
		
		Для Каждого Значение Из Значения Цикл
			Для Каждого Представление Из Представления Цикл
				Если (Значение.Представление = Представление.Значение Или Значение.Значение.Группа = Представление.Значение)
					И Результат.Найти(Значение.Значение.Значение) = Неопределено Тогда
					Результат.Добавить(Значение.Значение.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	Иначе //Строка
		Результат = Новый Массив;
		
		Для Каждого Значение Из Значения Цикл
			Если (Значение.Представление = Представления Или Значение.Значение.Группа = Представления)
				И Результат.Найти(Значение.Значение.Значение) = Неопределено Тогда
				Результат.Добавить(Значение.Значение.Значение);
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена групп значений с представлениями.
// 
// Возвращаемое значение:
//   - Структура
//
Функция ГруппыСостоянийПредставления() Экспорт
	
	Возврат Новый Структура("НеНачато,ВРаботе,Обработано",
		Строка(НеСформирован),
		НСтр("ru = 'В работе'"),
		НСтр("ru = 'Обработано'"));
	
КонецФункции

// Возвращает представления групп со значениями
// 
// Возвращаемое значение:
//   - Соответствие. Ключ = представление группы. Значение - массив значений перечисления.
//
Функция ГруппыСостоянийЗначения() Экспорт
	
	Результат = Новый Соответствие;
	Группы = ГруппыСостоянийПредставления();
	
	Результат.Вставить(Группы.НеНачато, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НеСформирован));
	Результат.Вставить(Группы.ВРаботе, СостоянияВРаботе());
	Результат.Вставить(Группы.Обработано, СостоянияОработано());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли