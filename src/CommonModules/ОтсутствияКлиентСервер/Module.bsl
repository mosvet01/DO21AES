////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отсутствия".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пустое HTML представление.
//
// Возвращаемое значение:
//  Строка - пустое HTML представление.
//
Функция ПолучитьПустоеHTMLПредставление() Экспорт
	
	Возврат "<html><body scroll=auto></body></html>";
	
КонецФункции

// Возвращает структуру данных об исполнителе.
//
// Параметры:
//  Исполнитель - СправочникСсылка.ПолныеРоли, СправочникСсылка.Пользователи - Исполнитель.
//  СрокИсполнения - Дата - Срок исполнения.
//
// Возвращаемое значение:
//  Структура - Данные исполнителя.
//
Функция ПолучитьДанныеИсполнителя(Исполнитель = Неопределено, СрокИсполнения = Неопределено) Экспорт
	
	Если СрокИсполнения = Неопределено Тогда
		СрокИсполнения = Дата(1, 1, 1);
	КонецЕсли;
	
	ДанныеИсполнителя = Новый Структура;
	ДанныеИсполнителя.Вставить("Исполнитель", Исполнитель);
	ДанныеИсполнителя.Вставить("СрокИсполнения", СрокИсполнения);
	
	Возврат ДанныеИсполнителя;
	
КонецФункции

// Формирует представление отсутствия.
//
// Параметры:
//  РеквизитыОтсутствия - Структура - Структура реквизитов отсутствия.
//  ВключатьОписаниеДаты - Булево - Признак того, что следует формировать описание даты.
//
// Возвращаемое значение:
//  Строка - Представление отсутствия.
//
Функция СформироватьПредставлениеОтсутствия(РеквизитыОтсутствия, ВключатьОписаниеДаты) Экспорт
	
	ОписаниеСотрудника = Строка(РеквизитыОтсутствия.Сотрудник);
	ОписаниеВидаОтсутствия = Строка(РеквизитыОтсутствия.ВидОтсутствия);
	ОписаниеОтсутствия = ОписаниеВидаОтсутствия + " - " + ОписаниеСотрудника;
	Если ВключатьОписаниеДаты Тогда
		ОписаниеДаты = СформироватьДатыОтсутствия(
			РеквизитыОтсутствия.ДатаНачала, РеквизитыОтсутствия.ДатаОкончания,
			РеквизитыОтсутствия.ВесьДень, Ложь, Ложь, Ложь);
		ОписаниеОтсутствия = ОписаниеОтсутствия + " - " + ОписаниеДаты;
	КонецЕсли;
	
	Возврат ОписаниеОтсутствия;
	
КонецФункции

// Формирует текстовое представление периода отсутствия.
//
// Параметры:
//  ДатаНачала - Дата - Дата начала отсутствия.
//  ДатаОкончания - Дата - Дата окончания отсутствия.
//  ВесьДень - Булево - Признак того что отсутствие на весь день.
//  ПредставлениеЧасовогоПояса - Строка - Представление часового пояса.
//
// Возвращаемое значение:
//  Строка - Текстовое представление периода отсутствия.
//
Функция ПериодСтрокой(ДатаНачала, ДатаОкончания, ВесьДень, ПредставлениеЧасовогоПояса) Экспорт
	
	ПериодСтрокой = ОтсутствияКлиентСервер.СформироватьДатыОтсутствия(
		ДатаНачала,
		ДатаОкончания,
		ВесьДень,
		Истина,
		Ложь,
		Истина);
	Если ЗначениеЗаполнено(ПредставлениеЧасовогоПояса) Тогда
		ПериодСтрокой = ПериодСтрокой + " " + ПредставлениеЧасовогоПояса;
	КонецЕсли;
	
	Возврат ПериодСтрокой;
	
КонецФункции

// Формирует текстовое представление дат отсутствия.
//
// Параметры:
//  ДатаНачала - Дата - Дата начала отсутствия.
//  ДатаОкончания - Дата - Дата окончания отсутствия.
//  ВесьДень - Булево - Признак того что отсутствие на весь день.
//  ПолнаяДата - Булево - Признак того, что дату следует формировать в виде полной даты.
//  ДатаДо - Булево - Флаг, определяющий следует ли включать только дату окончания в описание даты.
//  КраткоеОписание - Булево - Флаг, определяющий следует ли использовать краткий формат даты.
//
// Возвращаемое значение:
//  Строка - Текстовое представление даты отсутствия.
//
Функция СформироватьДатыОтсутствия(ДатаНачала, ДатаОкончания,
	ВесьДень, ПолнаяДата, ДатаДо, КраткоеОписание) Экспорт
	
	ЭтоМобильныйКлиент = МобильныйКлиентКлиентСервер.ЭтоМобильныйКлиент();
	
	ОписаниеДаты = "";

	Если ДатаДо Тогда
		ОписаниеДатыОкончания = СформироватьТекстовоеОписаниеДаты(ДатаОкончания, ВесьДень,
			ПолнаяДата, КраткоеОписание, Истина);
		ОписаниеДаты = СтрШаблон(НСтр("ru = 'до %1'"), ОписаниеДатыОкончания);	
	ИначеЕсли НачалоДня(ДатаОкончания) - НачалоДня(ДатаНачала) = 0 Тогда
		День = СформироватьТекстовоеОписаниеДаты(ДатаНачала, Истина,
			ПолнаяДата, КраткоеОписание, Истина);
		Если ВесьДень Тогда
			ОписаниеДаты = День;
		Иначе
			ВремяНачала = Формат(ДатаНачала, "ДФ='HH:mm'");
			ВремяОкончания = Формат(ДатаОкончания, "ДФ='HH:mm'");
			
			Если КраткоеОписание Тогда
				
				Если Не ЭтоМобильныйКлиент Тогда
					ОписаниеДаты = СтрШаблон(НСтр("ru = '%1 %2 - %3'"), День, ВремяНачала, ВремяОкончания);
				Иначе
					ОписаниеДаты = СтрШаблон(НСтр("ru = '%1%4%2 - %3'"), День, ВремяНачала, ВремяОкончания, Символы.ПС);
				КонецЕсли;
								
			Иначе
				ОписаниеДаты = СтрШаблон(НСтр("ru = '%1 с %2 по %3'"), День, ВремяНачала, ВремяОкончания);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ВключатьОписаниеГода = НачалоГода(ДатаНачала) <> НачалоГода(ДатаОкончания);
		ОписаниеДатыНачала = СформироватьТекстовоеОписаниеДаты(ДатаНачала, ВесьДень,
			ПолнаяДата, КраткоеОписание, ВключатьОписаниеГода);
		ОписаниеДатыОкончания = СформироватьТекстовоеОписаниеДаты(ДатаОкончания, ВесьДень,
			ПолнаяДата, КраткоеОписание, Истина);
		Если КраткоеОписание Тогда
			
			Если Не ЭтоМобильныйКлиент Тогда
				ОписаниеДаты = СтрШаблон(НСтр("ru = '%1 - %2'"), ОписаниеДатыНачала, ОписаниеДатыОкончания);
			Иначе
				ОписаниеДаты = СтрШаблон(НСтр("ru = '%1%3%2'"), ОписаниеДатыНачала, ОписаниеДатыОкончания, Символы.ПС);
			КонецЕсли;
			
		Иначе
			ОписаниеДаты = СтрШаблон(НСтр("ru = 'с %1 по %2'"), ОписаниеДатыНачала, ОписаниеДатыОкончания);
		КонецЕсли;
	КонецЕсли;

	Возврат ОписаниеДаты;
	
КонецФункции

// Формирует структуру настроек проверки отсутствий.
//
// Возвращаемое значение:
//  Структура - Настройки проверки отсутствий.
//
Функция НастройкиПроверкиОтсутствий() Экспорт
	
	НастройкиПроверкиОтсутствий = Новый Структура;
	НастройкиПроверкиОтсутствий.Вставить("УчитыватьФлагБудуРазбиратьЗадачи", Истина);
	НастройкиПроверкиОтсутствий.Вставить("УчитыватьТолькоВидыОтсутствийНеВФонде", Ложь);
	
	Возврат НастройкиПроверкиОтсутствий;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует текстовое представление даты.
//
// Параметры:
//  Дата - Дата - Дата, текстовое представление которой необходимо сформировать.
//  ВесьДень - Булево - Признак того, что в дату не нужно включать время.
//  ПолнаяДата - Булево - Признак того, что дату следует формировать в виде полной даты.
//  КраткоеОписание - Булево - Флаг, определяющий следует ли использовать краткий формат даты.
//
// Возвращаемое значение:
//  Строка - Текстовое представление даты.
//
Функция СформироватьТекстовоеОписаниеДаты(Дата, ВесьДень, ПолнаяДата, КраткоеОписание, ВключатьОписаниеГода)
	
	ЭтоМобильныйКлиент = МобильныйКлиентКлиентСервер.ЭтоМобильныйКлиент();			

	ФорматДаты = "";
	
	ПериодСледующийГод = Новый СтандартныйПериод(ВариантСтандартногоПериода.СледующийГод);
	НачалоСледующегоГода = ПериодСледующийГод.ДатаНачала;
	ПериодЭтотГод = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотГод);
	НачалоЭтогоГода = ПериодЭтотГод.ДатаНачала;
	ПериодЗавтра = Новый СтандартныйПериод(ВариантСтандартногоПериода.Завтра);
	НачалоЗавтрашнегоДня = ПериодЗавтра.ДатаНачала;
	ПериодСегодня = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	НачалоЭтогоДня = ПериодСегодня.ДатаНачала;
	ПериодВчера = Новый СтандартныйПериод(ВариантСтандартногоПериода.Вчера);
	НачалоВчерашнегоДня = ПериодВчера.ДатаНачала;
	
	ДатаДень = НачалоДня(Дата);

	Если Не ЭтоМобильныйКлиент Тогда
		
		Если Дата >= НачалоСледующегоГода Или Дата < НачалоЭтогоГода Или ПолнаяДата Тогда
			Если КраткоеОписание Тогда
				ФорматДаты = "d MMM";
			Иначе
				ФорматДаты = "d MMMM";
			КонецЕсли;
			Если ВключатьОписаниеГода Тогда
				ФорматДаты = ФорматДаты + " yyyy";
			КонецЕсли;
		ИначеЕсли ДатаДень = НачалоЗавтрашнегоДня Тогда
			ФорматДаты = НСтр("ru = 'За''''в''''тра'");
		ИначеЕсли ДатаДень = НачалоЭтогоДня Тогда
			ФорматДаты = НСтр("ru = 'Се''''г''''о''''д''''ня'");
		ИначеЕсли ДатаДень = НачалоВчерашнегоДня Тогда
			ФорматДаты = НСтр("ru = 'В''''ч''''ера'");
		ИначеЕсли (Дата < НачалоСледующегоГода И Дата >= НачалоЗавтрашнегоДня) Или 
					(Дата < НачалоВчерашнегоДня И Дата >= НачалоЭтогоГода) Тогда
			Если КраткоеОписание Тогда
				ФорматДаты = "d MMM";
			Иначе
				ФорматДаты = "d MMMM";
			КонецЕсли;
		КонецЕсли;
	
	Иначе		
		ФорматДаты = "dd.MM";
	КонецЕсли;		
	
	Если Не ВесьДень Тогда
			ФорматДаты = ФорматДаты + " HH:mm";
	КонецЕсли;
	
	ФорматДаты = "ДФ='" + ФорматДаты + "'";
	ОписаниеДаты = Формат(Дата, ФорматДаты);
	ОписаниеДаты = НРег(ОписаниеДаты);
	
	Возврат ОписаниеДаты;
	
КонецФункции

#КонецОбласти