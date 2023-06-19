#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Записывает сведения о мобильном приложении.
// Параметры:
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный
//	Дата - дата и время последнего подключения
//	Описание - строка с описанием мобильного клиента
//  Версия - Версия приложения
//
Процедура ЗаписатьСведенияОКлиенте(МобильноеПриложение, Дата, Описание, Версия) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СведенияОМобильныхКлиентах.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.МобильныйКлиент = МобильноеПриложение;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.МобильныйКлиент = МобильноеПриложение;
	МенеджерЗаписи.ДатаПоследнейАктивности = Дата;
	Если Не ЗначениеЗаполнено(МенеджерЗаписи.Описание) Или ЗначениеЗаполнено(Описание) Тогда
		МенеджерЗаписи.Описание = Описание;
	КонецЕсли;
	МенеджерЗаписи.ВерсияКлиента = Версия;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
	
// Возвращает дату последнего подключения мобильного клиента
// Параметры:
//	МобильноеПриложение - СправочникСсылка.ПользователиМобильныхПриложений
Функция ДатаПоследнейАктивности(МобильноеПриложение) Экспорт
	
	СведенияОМобильномПриложении = СведенияОМобильномПриложении(МобильноеПриложение);
	
	Возврат ?(СведенияОМобильномПриложении = Неопределено, Дата(1,1,1),
		СведенияОМобильномПриложении.ДатаПоследнейАктивности);	

КонецФункции

// Возвращает сведения о мобильном приложении в виде структуры
// Параметры:
//  МобильноеПриложение - СправочникСсылка.ПользователиМобильногоПриложения - Текущее мобильное приложение
// Возвращаемое значение:
//  Сведения - Структура с ключами:
//		"ДатаПоследнейАктивности" - Дата - Дата последней активности приложения
//		"Описание" - Строка - Описание моб.приложения
//		"Версия" - Строка - Версия моб. приложения
//		"ГраницаСборкиДанных" - Число (15) - граница сборки данных
//		"ДатаПервоначальнойЗагрузкиДанных" - Дата - Дата первоначальной загрузки
//
Функция СведенияОМобильномПриложении(МобильноеПриложение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОМобильныхКлиентах.ДатаПоследнейАктивности КАК ДатаПоследнейАктивности,
		|	СведенияОМобильныхКлиентах.Описание КАК Описание,
		|	СведенияОМобильныхКлиентах.ВерсияКлиента КАК ВерсияКлиента,
		|	СведенияОМобильныхКлиентах.ГраницаСборкиДанных КАК ГраницаСборкиДанных,
		|	СведенияОМобильныхКлиентах.ДатаПервоначальнойЗагрузкиДанных КАК ДатаПервоначальнойЗагрузкиДанных
		|ИЗ
		|	РегистрСведений.СведенияОМобильныхКлиентах КАК СведенияОМобильныхКлиентах
		|ГДЕ
		|	СведенияОМобильныхКлиентах.МобильныйКлиент = &МобильноеПриложение";
	Запрос.УстановитьПараметр("МобильноеПриложение", МобильноеПриложение);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка, Неопределено);

КонецФункции

//Возвращает версию мобильного приложения
//Параметры:
//	МобильноеПриложение - СправочникСсылка.ПользователиМобильногоПриложения - Текущее моб. приложение
//Возвращаемое значение:
// Версия - Строка - Версия моб. приложения. Если версия не указано, возвращается пустая строка
//
Функция ВерсияМобильногоПриложения(МобильноеПриложение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сведения = СведенияОМобильномПриложении(МобильноеПриложение);
	
	Возврат ?(Сведения <> Неопределено, Сведения.ВерсияКлиента, "");

КонецФункции

//Возвращает дату первоначальной загрузки данных
//Параметры:
//	МобильноеПриложение - СправочникСсылка.ПользователиМобильногоПриложения - Текущее моб. приложение
//Возвращаемое значение:
// Дата - Дата, Неопределено - Дата первоначальной загрузки данных мобильного приложения. Если данных нет - Неопределено
//
Функция ДатаПервоначальнойЗагрузки(МобильноеПриложение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сведения = СведенияОМобильномПриложении(МобильноеПриложение);
	ЕстьСведения = Сведения <> Неопределено; 
	
	Возврат ?(ЕстьСведения, Сведения.ДатаПервоначальнойЗагрузкиДанных, Неопределено);
	
КонецФункции

//Сохраняет дату первоначальной загрузки данных
//Параметры:
//	МобильноеПриложение - СправочникСсылка.ПользователиМобильногоПриложения - Текущее моб. приложение
//  Дата - Дата - Дата первонач. загрузки
Процедура ЗаписатьДатуПервоначальнойЗагрузкиДанных(МобильноеПриложение, Дата) Экспорт
	
	МЗ = СоздатьМенеджерЗаписи();
	МЗ.МобильныйКлиент = МобильноеПриложение;
	МЗ.Прочитать();
	МЗ.ДатаПервоначальнойЗагрузкиДанных = Дата;
	МЗ.Записать();
	
КонецПроцедуры

// Сохраняет границу сборки данных
// Параметры:
//  МобильноеПриложение - СправочникСсылка.ПользователиМобильныхПриложений - мобильное приложение 
//  	для сохранения границы сборки
//  ГраницаСборкиДанных - Число(15) - граница сборки данных в виде универсальной даты в числовом формате (в мс)
//
Процедура ОбновитьГраницуСборкиДанных(МобильноеПриложение, ГраницаСборкиДанных = Неопределено) Экспорт

	МЗ = СоздатьМенеджерЗаписи();
	МЗ.МобильныйКлиент = МобильноеПриложение;
	МЗ.Прочитать();
	МЗ.ГраницаСборкиДанных = ГраницаСборкиДанных;
	МЗ.Записать();
	
КонецПроцедуры

// Возрващает границу сборки данных
// Параметры:
//  МобильноеПриложение - СправочникСсылка.ПользователиМобильныхПриложений - мобильное приложение
//		для получения границы сборки
// Возвращаемое значение
// ГраницаСборкиДанных - Число(15) - граница сборки данных в виде универсальной даты в числовом формате (в мс)
//
Функция ГраницаСборкиДанных(МобильноеПриложение) Экспорт
	
	Сведения = СведенияОМобильномПриложении(МобильноеПриложение);
	
	Если Сведения <> Неопределено Тогда
		Возврат Сведения.ГраницаСборкиДанных;	
	КонецЕсли; 
	
КонецФункции

// Заполняет границы сборок из отметок времени
// 
Процедура ЗаполнитьГраницыПоОтметкамПриНеобходимости() Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеКлиенты") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОМобильныхКлиентах.МобильныйКлиент Как МобильноеПриложение,
		|	СведенияОМобильныхКлиентах.УдалитьОтметкаВремениСборкиДанных
		|ИЗ
		|	РегистрСведений.СведенияОМобильныхКлиентах КАК СведенияОМобильныхКлиентах
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПользователиМобильногоПриложения КАК ПользователиМобильногоПриложения
		|		ПО СведенияОМобильныхКлиентах.МобильныйКлиент = ПользователиМобильногоПриложения.Ссылка
		|ГДЕ
		|	НЕ ПользователиМобильногоПриложения.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДатаОтметки =
			ОтметкиВремени.УниверсальнаяДатаПоОтметкеВремени(Выборка.УдалитьОтметкаВремениСборкиДанных); 
		ГраницаПоОтметке = ОтметкиВремени.ДатаВДатуВМиллисекундах(ДатаОтметки);
		
		ОбновитьГраницуСборкиДанных(Выборка.МобильноеПриложение, ГраницаПоОтметке);
	
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли