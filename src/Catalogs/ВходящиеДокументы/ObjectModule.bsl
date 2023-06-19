#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриКопировании(ОбъектКопирования)
	
	РегистрационныйНомер = "";
	ЧисловойНомер 	= 0;
	ДатаРегистрации	= '00010101';
	ДатаСоздания 	= ТекущаяДатаСеанса();
	Зарегистрировал = ПользователиКлиентСервер.ТекущийПользователь();
	Создал	 		= Зарегистрировал;
	
	ИсходящийНомер	= "";
	ИсходящаяДата	= '00010101';
	СрокИсполнения 	= '00010101';
	СрокИсполненияПервоначальный = Неопределено;
	
	КоличествоЭкземпляров = 1;
	КоличествоЛистов 	 = 1;
	КоличествоПриложений = 0;
	ЛистовВПриложениях 	 = 0;
	Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
	
	ПодписанЭП = Ложь;
	
	Для Каждого СтрокаВопрос Из ВопросыОбращения Цикл 
		СтрокаВопрос.ДатаОтвета = Неопределено;
		СтрокаВопрос.ОрганДляПередачи = Неопределено;
		СтрокаВопрос.РезультатРассмотрения = Неопределено;
		СтрокаВопрос.МнениеАвтораОРезультатах = Неопределено;
		СтрокаВопрос.МнениеАвтораОМерах = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	Если ЭтоНовый() Тогда
		
		РегистрационныйНомер = "";
		ЧисловойНомер 	= 0;
		ДатаРегистрации	= '00010101';
		ДатаСоздания 	= ТекущаяДатаСеанса();
		Зарегистрировал = ПользователиКлиентСервер.ТекущийПользователь();
		Создал	 		= Зарегистрировал;
		
		ИсходящийНомер	= "";
		ИсходящаяДата	= '00010101';
		ОтправленОтвет	= Справочники.ИсходящиеДокументы.ПустаяСсылка();
		ВОтветНа		= Справочники.ИсходящиеДокументы.ПустаяСсылка();
		СрокИсполнения 	= '00010101';
		
		КоличествоЭкземпляров = 1;
		КоличествоЛистов 	  = 1;
		КоличествоПриложений  = 0;
		ЛистовВПриложениях 	  = 0;
		Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
		
		Резолюция 	   = "";
		АвторРезолюции = Справочники.Пользователи.ПустаяСсылка();
		ДатаРезолюции  = '00010101';
		
		Если Не ЗначениеЗаполнено(ВидДокумента) Тогда 
			ВидДокумента = Делопроизводство.ПолучитьВидДокументаПоУмолчанию(Ссылка);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Организация) Тогда 
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СпособПолучения) Тогда 
			СпособПолучения = Делопроизводство.ПолучитьСпособДоставкиПоУмолчанию("СпособПолучения");
		КонецЕсли;
		
		Если Константы.ИспользоватьГрифыДоступа.Получить() Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидДокумента) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВоВходящих", 
			Новый Структура("ВидВходящегоДокумента", ВидДокумента)) Тогда 
			Валюта = Делопроизводство.ПолучитьВалютуПоУмолчанию();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
		
		ФормаДокумента = Перечисления.ВариантыФормДокументов.Бумажная;
	КонецЕсли;
	
	ОснованиеЗаполнения = ДанныеЗаполнения;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Основание") Тогда
		ОснованиеЗаполнения = ДанныеЗаполнения.Основание;
	КонецЕсли;
	
	// Сначала заполняем данными шаблона - затем документа-основания.
	
	// Создание из шаблона.
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ШаблонДокумента") Тогда
		
		Шаблон = ДанныеЗаполнения.ШаблонДокумента;
		ШаблоныДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(Шаблон, ЭтотОбъект);
		
	КонецЕсли;
	
	// Регламентированный учет обращений
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ТаблицаВопросы") Тогда
		РаботаСОбращениямиВызовСервера.ЗаполнитьВопросыДокумента(ЭтотОбъект, ДанныеЗаполнения.ТаблицаВопросы);
	КонецЕсли;
	// Конец Регламентированный учет обращений
	
	// Ввод на основании исходящего документа.
	Если ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		
		Если ОснованиеЗаполнения.Получатели.Количество() = 1 Тогда 
			Отправитель = ОснованиеЗаполнения.Получатели[0].Получатель;
			Подписал = ОснованиеЗаполнения.Получатели[0].Адресат;
		Иначе
			УстановитьПривилегированныйРежим(Истина);
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВходящиеДокументы.Ссылка,
			|	ВходящиеДокументы.Отправитель,
			|	ВходящиеДокументы.Подписал
			|ИЗ
			|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязиДокументовВОтветНа
			|		ПО ВходящиеДокументы.Ссылка = СвязиДокументовВОтветНа.Документ
			|			И (СвязиДокументовВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученВОтветНа))
			|ГДЕ
			|	СвязиДокументовВОтветНа.СвязанныйДокумент = &ВОтветНа";
			Запрос.УстановитьПараметр("ВОтветНа", ОснованиеЗаполнения.Ссылка);
			
			Выборка = Запрос.Выполнить().Выгрузить();
			Для Каждого Строка Из ОснованиеЗаполнения.Получатели Цикл
				ПараметрыОтбора = Новый Структура("Отправитель, Подписал", Строка.Получатель, Строка.Адресат);
				Если Выборка.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда 
					Отправитель = Строка.Получатель;
					Подписал = Строка.Адресат;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОснованиеЗаполнения, 
			"Подразделение, Подписал, ГрифДоступа, ВопросДеятельности, Организация, Проект");
		
		Адресат = РеквизитыОснования.Подписал;
		Подразделение = РеквизитыОснования.Подразделение;
		ГрифДоступа = РеквизитыОснования.ГрифДоступа;
		ВопросДеятельности = РеквизитыОснования.ВопросДеятельности;
		Организация = РеквизитыОснования.Организация;
		Проект = РеквизитыОснования.Проект;
	
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("Массив")   
		И ОснованиеЗаполнения.Количество() > 0
		И ТипЗнч(ОснованиеЗаполнения[0]) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ОснованиеЗаполнения.Количество() = 1 И Не ЗначениеЗаполнено(Заголовок) Тогда			
			Заголовок = ОснованиеЗаполнения[0].ПолноеНаименование;			
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") И Не ЗначениеЗаполнено(Проект) Тогда
			Проекты = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ОснованиеЗаполнения, "Проект");
			Проект = Проекты.Получить(ОснованиеЗаполнения[0]);
			Для Каждого Строка Из Проекты Цикл
				Если Строка.Значение <> Проект Тогда 
					Проект = Неопределено;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;	
			
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ОснованиеЗаполнения) Тогда
		
		ОснованиеЗаполненияОбъект = ОснованиеЗаполнения.ПолучитьОбъект();
		
		Содержание = ОснованиеЗаполненияОбъект.ПолучитьТекстовоеПредставлениеСодержанияПисьма();
		Заголовок = ОснованиеЗаполненияОбъект.Тема;
		Проект = ОснованиеЗаполненияОбъект.Проект;
		
		Если ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ОснованиеЗаполнения) Тогда
			СтруктураРезультата = ВстроеннаяПочтаСервер.ПолучитьКонтрагентаИКонтактноеЛицоПоСтрокеАдреса(
				ОснованиеЗаполненияОбъект.ОтправительАдресат.Адрес);
			Если СтруктураРезультата <> Неопределено Тогда
				Отправитель = СтруктураРезультата.Контрагент;
				Подписал = СтруктураРезультата.КонтактноеЛицо;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ОтчетностьВКонтролирующиеОрганыКлиентСервер.ЭтоДокументОбменаСКонтролирующимОрганом(
				ОснованиеЗаполнения) Тогда
		
		СведенияОДокументе = ОтчетностьВКонтролирующиеОрганы.СведенияОбЭлектронномДокументе(ОснованиеЗаполнения);
		
		Заголовок = СведенияОДокументе.Наименование;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОДокументе, "Организация,Содержание,Комментарий");
		
		Если ЗначениеЗаполнено(СведенияОДокументе.СообщениеОбОшибке) Тогда
			ОбщегоНазначения.СообщитьПользователю(СведенияОДокументе.СообщениеОбОшибке);
		Иначе
			Отправитель = СведенияОДокументе.Контрагент;
			Если Не ЗначениеЗаполнено(СпособПолучения) Тогда
				СпособПолучения = Справочники.СпособыДоставки.Сервис1СОтчетность;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Отправитель"));
	
	Если Не ПолучитьФункциональнуюОпцию("УчитыватьКакОбращениеГраждан", Новый Структура("ВидВходящегоДокумента", ВидДокумента)) Тогда  
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ВидОбращения"));
		
	ИначеЕсли ПолучитьФункциональнуюОпцию("РегламентированныйУчетОбращений") Тогда 
		Если ВопросыОбращения.Количество() = 0 Тогда 
			ДатаПроверкиНаличияВопросов = ДелопроизводствоСерверПовтИсп.ДатаПроверкиНаличияВопросов();
			
			Если Не ЗначениеЗаполнено(ДатаПроверкиНаличияВопросов)
				Или (ЗначениеЗаполнено(ДатаПроверкиНаличияВопросов) 
					И ЗначениеЗаполнено(ДатаРегистрации) И ДатаРегистрации > ДатаПроверкиНаличияВопросов)
				Или (ЗначениеЗаполнено(ДатаПроверкиНаличияВопросов) 
					И Не ЗначениеЗаполнено(ДатаРегистрации) И ДатаСоздания > ДатаПроверкиНаличияВопросов) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не указано ни одного вопроса документа'"),,
						"КодВопроса",, Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		//Проверка табличной части ВопросыОбращения на задвоения
		КоличествоВопросыОбращения = ВопросыОбращения.Количество();
		Если КоличествоВопросыОбращения > 1 Тогда
			Для Инд1 = 0 По КоличествоВопросыОбращения - 2 Цикл
				Для Инд2 = Инд1 + 1 По КоличествоВопросыОбращения - 1 Цикл
					Если ВопросыОбращения[Инд1].Вопрос = ВопросыОбращения[Инд2].Вопрос Тогда 
						ТекстСообщения = СтрШаблон(
							НСтр("ru = 'Вопрос ""%1"" указан дважды в списке вопросов обращения'"),
							ВопросыОбращения[Инд2].КодВопроса);
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
							"ВопросыОбращения["+ Формат(Инд2, "ЧН=0; ЧГ=0") +"].КодВопроса",,Отказ);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;

	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВоВходящих", Новый Структура("ВидВходящегоДокумента", ВидДокумента)) Тогда 
		Если ЗначениеЗаполнено(Сумма) Тогда 
			ПроверяемыеРеквизиты.Добавить("Валюта");
		КонецЕсли;	
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам")
			И ПолучитьФункциональнуюОпцию("ИспользоватьВидыВходящихДокументов")
			И ЗначениеЗаполнено(ВидДокумента)
			И ОбщегоНазначения.СсылкаСуществует(ВидДокумента) Тогда
		НастройкиУчетаПоПроектам = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента,
			"ОбязательноУказаниеПроекта, КонтролироватьУникальностьДокументаВРамкахПроекта");
		Если НастройкиУчетаПоПроектам.ОбязательноУказаниеПроекта Тогда
			ПроверяемыеРеквизиты.Добавить("Проект");
		КонецЕсли;
		Если НастройкиУчетаПоПроектам.КонтролироватьУникальностьДокументаВРамкахПроекта
				И Не РаботаСПроектами.ДокументУникален(ЭтотОбъект) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Уже есть %1 с проектом %2. Документ данного вида должен быть уникален в рамках проекта'"),
						ВидДокумента,
						Проект),
				ЭтотОбъект,
				"Проект",,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИсходящийНомер) И ЗначениеЗаполнено(ИсходящаяДата)
		И НРег(ИсходящийНомер) <> НСтр("ru = 'б\н'") 
		И НРег(ИсходящийНомер) <> НСтр("ru = 'б/н'") Тогда 
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВходящийДокумент.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящийДокумент
		|ГДЕ
		|	ВходящийДокумент.ИсходящийНомер = &ИсходящийНомер
		|	И ВходящийДокумент.ИсходящаяДата = &ИсходящаяДата
		|	И ВходящийДокумент.Отправитель = &Отправитель
		|	И ВходящийДокумент.ВидДокумента = &ВидДокумента
		|	И (НЕ ВходящийДокумент.ПометкаУдаления)
		|	И ВходящийДокумент.Ссылка <> &Ссылка";
		
		Запрос.УстановитьПараметр("ИсходящийНомер", ИсходящийНомер);
		Запрос.УстановитьПараметр("ИсходящаяДата", ИсходящаяДата);
		Запрос.УстановитьПараметр("Отправитель", Отправитель);
		Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
			Запрос.Текст = Запрос.Текст + " И (Организация = &Организация) ";
			Запрос.УстановитьПараметр("Организация", Организация);
		КонецЕсли;
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ №%1 от %2 отправителя ""%3"" уже зарегистрирован!'"),
				ИсходящийНомер,
				Формат(ИсходящаяДата, "ДЛФ=D"),
				Строка(Отправитель));
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ИсходящийНомер",, 
				Отказ);
				
			РаботаССВД.ОбработатьОшибкуРегистрацииДокумента(Ссылка, ТекстСообщения);
				
		КонецЕсли;	
		
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РегистрационныйНомер) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		Если Не Делопроизводство.РегистрационныйНомерУникален(ЭтотОбъект) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Регистрационный номер не уникален!'"),
				ЭтотОбъект,
				"РегистрационныйНомер",, 
				Отказ);
		КонецЕсли;	
	КонецЕсли;	
	
	Делопроизводство.ПроверитьЗаполнениеДела(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(Дело) Тогда 
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВидДокумента <> ВидДокумента)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВидыДокументов", ВидДокумента, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы с видом %1.'"),
					Строка(ВидДокумента)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
		Если (Ссылка.Дело <> Дело Или Ссылка.Отправитель <> Отправитель)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("Контрагенты", Отправитель, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы по контрагенту %1.'"),
					Строка(Отправитель)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВопросДеятельности <> ВопросДеятельности)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВопросыДеятельности", ВопросДеятельности, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы по вопросу деятельности %1.'"),
					Строка(ВопросДеятельности)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Делопроизводство.ПроверкаСвязейПриИзмененииВидаДокумента(ЭтотОбъект, Отказ);
	
	Если ВидДокумента.ВестиУчетПоНоменклатуреДел Тогда
		Делопроизводство.ПроверитьСоответствиеНоменклатурыДел(ЭтотОбъект, Отказ);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ВидДокумента) Тогда 
		
		ОбязательноеУказаниеОтветственного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, 
			"ОбязательноеУказаниеОтветственного");
			
		Если ОбязательноеУказаниеОтветственного И Не ЗначениеЗаполнено(Ответственный) Тогда
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У документа вида ""%1"" должен быть обязательно указан ответственный.'"),
					Строка(ВидДокумента)),
				ЭтотОбъект,
				"Ответственный",, 
				Отказ);
				
		КонецЕсли;
		
		Делопроизводство.ПроверитьЗаполнениеРеквизитовХранения(ЭтотОбъект, ПроверяемыеРеквизиты);
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РаздельныйУчетДокументов") Тогда 
		ПроверяемыеРеквизиты.Добавить("ФормаДокумента");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"РегистрационныйНомер, Ответственный, ПодписанЭП, ПометкаУдаления");
	Иначе
		ПредыдущиеЗначенияРеквизитов = Новый Структура(
			"РегистрационныйНомер, Ответственный, ПодписанЭП, ПометкаУдаления",
			Неопределено,
			Неопределено,
			Ложь,
			Ложь);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПредыдущийРегистрационныйНомер",
		ПредыдущиеЗначенияРеквизитов.РегистрационныйНомер);
	ДополнительныеСвойства.Вставить("ПредыдущийОтветственный",
		ПредыдущиеЗначенияРеквизитов.Ответственный);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьПодписанногоОбъекта = Ложь;
	Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
		ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
	КонецЕсли;
	
	Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина Тогда
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Если ПодписанЭП И ПредыдущиеЗначенияРеквизитов.ПодписанЭП Тогда
				// тут проверяем ключевые поля - изменились ли
				МассивИмен = Справочники.ВходящиеДокументы.ПолучитьИменаКлючевыхРеквизитов();
				РаботаСЭП.ПроверитьИзмененностьКлючевыхПолей(МассивИмен, ЭтотОбъект, Ссылка);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	// Заполним Наименование по шаблону
	Если ЗначениеЗаполнено(Шаблон) Тогда 
		УстановитьПривилегированныйРежим(Истина);
		РеквизитыШаблона = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шаблон,
			"ЗаполнениеНаименованияПоШаблону, Заголовок");
		Если РеквизитыШаблона.ЗаполнениеНаименованияПоШаблону Тогда 
			ШаблонЗаголовка = РеквизитыШаблона.Заголовок;
			Заголовок = ШаблоныДокументов.СформироватьНаименованиеПоШаблону(
				ЭтотОбъект, ШаблонЗаголовка);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	// Заполним наименование
	Наименование = Делопроизводство.НаименованиеДокумента(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(СрокИсполненияПервоначальный) 
		И ЗначениеЗаполнено(СрокИсполнения)
		И ЗначениеЗаполнено(РегистрационныйНомер) Тогда
		СрокИсполненияПервоначальный = СрокИсполнения;
	КонецЕсли;
	
	// Пометка на удаление приложенных файлов.
	Если ПометкаУдаления <> ПредыдущиеЗначенияРеквизитов.ПометкаУдаления Тогда 
		
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
		
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполним дату начала дела, если не заполнена
	Если ЗначениеЗаполнено(Дело) И Не ЗначениеЗаполнено(Дело.ДатаНачала) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Дело);
		ДелоОбъект = Дело.ПолучитьОбъект();
		ДелоОбъект.ДатаНачала = ДатаРегистрации;
		ДелоОбъект.Записать();	
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить(
			"ИзменилсяСписокПерсональныхДанных", ПерсональныеДанные.ИзменилсяСписокПерсональныхДанных(ЭтотОбъект));
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") И Не Ссылка.Пустая() Тогда 
		СсылкаПроект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Проект");
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ИзменилсяПроект", СсылкаПроект <> Проект);
	КонецЕсли;
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.ВходящиеДокументы.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Определение дескрипторов для проверки прав при записи рабочей группы.
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ЭтотОбъект);
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление автоматических участников из самого объекта
	Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(ЭтотОбъект) Тогда
		
		НовыеУчастникиРГ = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
		
		Если ДополнительныеСвойства.Свойство("ПолученПоСВД") И ДополнительныеСвойства.ПолученПоСВД Тогда
			МассивПользователей = ПолучитьВсехПользователейИмеющихПравоИзмененияВходящих();
			Для Каждого Пользователь Из МассивПользователей Цикл
				Строка = НовыеУчастникиРГ.Добавить();
				Строка.Участник = Пользователь;
			КонецЦикла;
		Иначе
			ДобавитьУчастниковРабочейГруппыВНабор(НовыеУчастникиРГ);
		КонецЕсли;
		
		РаботаСРабочимиГруппами.ЗаполнитьКолонкуИзменениеПоСтандартнымПравам(СсылкаОбъекта, НовыеУчастникиРГ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НовыеУчастникиРГ, РабочаяГруппа);
		
	КонецЕсли;
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			Строка.Изменение = Эл.Изменение;
			
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			
			// Поиск удаляемого участника в итоговой рабочей группе
			Для Каждого Эл2 Из РабочаяГруппа Цикл
				
				Если Эл2.Участник = Эл.Участник 
					И Эл2.Изменение = Эл.Изменение Тогда
					
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;	
				
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Обработка обязательного заполнения рабочих групп 
	Если РабочаяГруппа.Количество() = 0 Тогда
	
		Если РаботаСРабочимиГруппами.ОбязательноеЗаполнениеРабочихГруппДокументов(ВидДокумента) Тогда
			//Если документ получен по СВД, то в его рабочую группу добавляются все, кто может зарегистрировать его
			Если ДополнительныеСвойства.Свойство("ПолученПоСВД") И ДополнительныеСвойства.ПолученПоСВД Тогда
				МассивПользователей = ПолучитьВсехПользователейИмеющихПравоИзмененияВходящих();
				Для Каждого Пользователь Из МассивПользователей Цикл
					Строка = РабочаяГруппа.Добавить();
					Строка.Участник = Пользователь;
					Строка.Изменение = Истина;
				КонецЦикла;
			Иначе
				Строка = РабочаяГруппа.Добавить();
				Строка.Участник = ПользователиКлиентСервер.ТекущийПользователь();
				Строка.Изменение = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь); //ОбновитьПраваДоступа
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЧисловойНомер > 0 Тогда
		СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ЭтотОбъект);
		Нумерация.ОсвободитьНомер(СтруктураПараметров);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеВходящегоДокумента);
		Иначе	
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента);
		КонецЕсли;
		
		Делопроизводство.ЗарегистрироватьСобытиеНазначениеОтветственного(
			Ссылка,
			Ответственный,
			ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый,
			?(ДополнительныеСвойства.Свойство("ПредыдущийОтветственный"),
				ДополнительныеСвойства.ПредыдущийОтветственный,
				Неопределено));
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;	
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ЗначениеЗаполнено(РегистрационныйНомер) И РегистрационныйНомер <> ДополнительныеСвойства.ПредыдущийРегистрационныйНомер Тогда
			Если ЗначениеЗаполнено(ДополнительныеСвойства.ПредыдущийРегистрационныйНомер) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента);	
			Иначе	
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента);	
				РаботаССВД.ОбработатьРегистрациюДокумента(Ссылка);
			КонецЕсли;			
		КонецЕсли;		
	КонецЕсли;		
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды")
		И ДополнительныеСвойства.Свойство("ЭтоНовый") 
		И ДополнительныеСвойства.ЭтоНовый Тогда
		
		Штрихкод = ШтрихкодированиеСервер.СформироватьШтрихКод();
		ШтрихкодированиеСервер.ПрисвоитьШтрихКод(Ссылка, Штрихкод);
		
	КонецЕсли;
	
	// Заполняем сведения о персональных данных во всех файлах
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		
		Если Не ОбменДанными.Загрузка 
			И ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяСписокПерсональныхДанных") 
			И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяСписокПерсональныхДанных Тогда
			
			ПерсональныеДанные.ЗаполнитьПерсональныеДанныеФайлов(Ссылка);
			
		КонецЕсли;	
		
	КонецЕсли;
	
	// Заполнение проекта в файлах
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяПроект") 
		   И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяПроект Тогда
			РаботаСПроектами.ЗаполнитьПроектПодчиненныхФайлов(Ссылка);
		КонецЕсли;
	КонецЕсли;	
	
	// обновить связи документа
	СвязиДокументов.ОбновитьСвязиДокумента(Ссылка);
	
	// запись статуса проверки ЭП
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") 
		И ДополнительныеСвойства.ЭтоНовый Тогда
		
		Если РаботаСЭП.ПолучитьЭлектронныеПодписи(Ссылка).Количество() > 0 Тогда 
			РаботаСЭП.УстановитьСтатусПроверки(Ссылка, Перечисления.СтатусПроверкиЭП.ПодписьНеПроверена);
		Иначе
			РаботаСЭП.УстановитьСтатусПроверки(Ссылка, Перечисления.СтатусПроверкиЭП.ПодписиНет);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ВидДокумента, Ответственный, Зарегистрировал, Адресат, Создал");
			
		Если ИсходныеРеквизиты.ВидДокумента = ВидДокумента Тогда
			ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);
		Иначе
			ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		КонецЕсли;	
		
	Иначе	
		
		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	// Добавление реквизита Ответственный
	Если ИсходныеРеквизиты.Ответственный <> Ответственный Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	КонецЕсли;
	
	// Добавление реквизита Зарегистрировал
	Если ИсходныеРеквизиты.Зарегистрировал <> Зарегистрировал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	КонецЕсли;
	
	// Добавление реквизита Адресат
	Если ИсходныеРеквизиты.Адресат <> Адресат Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	КонецЕсли;
	
	// Добавление реквизита Создал
	Если ИсходныеРеквизиты.Создал <> Создал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	
	Если Ссылка.Пустая() Тогда 
		Возврат;
	КонецЕсли;
	
	// Добавление контролеров
	Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, Ссылка);
	
КонецПроцедуры

Функция ПолучитьВсехПользователейИмеющихПравоИзмененияВходящих()
	
	УстановитьПривилегированныйРежим(Истина);
	ОбъектМетаданныхРоль = Метаданные.Роли.ДобавлениеИзменениеВходящихДокументов;
	ИдентификаторРоли = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданныхРоль);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументооборотПользователиГруппДоступа.Пользователь
		|ИЗ
		|	РегистрСведений.ДокументооборотПользователиГруппДоступа КАК ДокументооборотПользователиГруппДоступа
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|		ПО ДокументооборотПользователиГруппДоступа.ГруппаДоступа.Профиль = ПрофилиГруппДоступаРоли.Ссылка
		|ГДЕ ПрофилиГруппДоступаРоли.Роль = &Роль";
	
	Запрос.УстановитьПараметр("Роль", ИдентификаторРоли);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции

#КонецЕсли