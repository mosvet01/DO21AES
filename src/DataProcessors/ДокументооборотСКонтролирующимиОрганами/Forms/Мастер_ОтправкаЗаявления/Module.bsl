&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ВыполняемоеОповещение;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заявление 			= Параметры.Заявление;
	ТипКриптопровайдера = Заявление.ТипКриптопровайдера;
	ФИО 				= СокрЛП(Заявление.ВладелецЭЦПИмя + " " + Заявление.ВладелецЭЦПОтчество);
	НомерТелефона    	= Заявление.ТелефонМобильныйДляАвторизации;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = Заявление.ЭлектроннаяПодписьВМоделиСервиса;
	
	Если ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП() Тогда
		ПоказатьСтраницуОтправкиЗаявления();
	Иначе
		ПоказатьСтраницуПодготовкиКСозданиюКлюча();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Успешное создание закрытого ключа'") Тогда
		ПоказатьСтраницуОтправкиЗаявления();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Ошибка создание закрытого ключа'") Тогда
		ПричинаОшибки = Параметр;
		ПоказатьОшибкуСозданияКлюча();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Ошибка отправки заявления'") И НЕ ЗначениеЗаполнено(ПричинаОшибки) Тогда
		// Заходим сюда только если ранее не выпадала ошибка создания контейнера
		ПричинаОшибки = Параметр;
		ПоказатьОшибкуОтправкиЗаявления();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Успешная отправки заявления'")
		ИЛИ ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Отказ от ввода пароля'") Тогда
		ЗапретитьЗакрытие = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗапретитьЗакрытие Тогда
		Отказ = Истина;
	Иначе
		Оповестить(НСтр("ru = 'Закрытие Мастер_ОтправкаЗаявления'"),,Заявление);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить(НСтр("ru = 'Закрытие Мастер_ОтправкаЗаявления'"),,Заявление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РекомендацияКОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	КонтекстЭДОКлиент.ОбработкаНавигационнойСсылкиИТС(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КонтекстЭДОКлиент.ОткрытьИнструкциюИнструкциюПоСозданиюКлючаЭЦП(ТипКриптопровайдера);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗакрытыйКлюч(Команда)
	
	ВладелецФормы.ОтправитьЗаявлениеИзВладельца();
	ПоказатьСтраницуСозданияКлюча();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяПомощьНажатие(Элемент)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Фио", ФИО);
	ДополнительныеПараметры.Вставить("НомерТелефона", НомерТелефона);
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_Помощь", ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП()
	
	КонтекстЭДОСервер        = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	ИспользоватьСуществующий = Заявление.СпособПолученияСертификата = Перечисления.СпособПолученияСертификата.ИспользоватьСуществующий;
	ЭтоПервичноеЗаявление    = Заявление.ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Первичное;
	ЭтоВторичноеЗаявление    = НЕ ЭтоПервичноеЗаявление;

	ЭтоПереизданиеСертификата = Ложь;
	ЭтоПереходВКоробку        = Ложь;
	ЭтоПереходВОблако         = Ложь;
	
	Если ЭтоВторичноеЗаявление Тогда
		
		СписокРеквизитов = Заявление.ИзменившиесяРеквизитыВторичногоЗаявления;
		 
		ЭтоПереизданиеСертификата = КонтекстЭДОСервер.ЭтотПараметрИзменился(
		 	СписокРеквизитов, 
			Перечисления.ПараметрыПодключенияК1СОтчетности.ПереизданиеСертификата);
			
		ЭтоПереходВКоробку = КонтекстЭДОСервер.ЭтотПараметрИзменился(
		 	СписокРеквизитов, 
			Перечисления.ПараметрыПодключенияК1СОтчетности.ПереходВКоробку);
			
		ЭтоПереходВОблако = КонтекстЭДОСервер.ЭтотПараметрИзменился(
		 	СписокРеквизитов, 
			Перечисления.ПараметрыПодключенияК1СОтчетности.ПереходВОблако);
			
		Пропустить = 
			НЕ ЭтоПереизданиеСертификата 
			ИЛИ ЭтоЭлектроннаяПодписьВМоделиСервиса И НЕ ЭтоПереходВКоробку
			ИЛИ ЭтоПереходВОблако
			ИЛИ ИспользоватьСуществующий;
			
	Иначе
		Пропустить = ЭтоЭлектроннаяПодписьВМоделиСервиса ИЛИ ИспользоватьСуществующий;
	КонецЕсли;
	
	Возврат Пропустить;
		
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Активизировать();
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_НачатьОтправкуЗаявленияСразу", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьОтправкуЗаявленияСразу()
	
	ВладелецФормы.ОтправитьЗаявлениеИзВладельца();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуПодготовкиКСозданиюКлюча()
	
	Заголовок 						= НСтр("ru = 'Создание ключа и отправка заявления'");
	Элементы.СоздатьЗакрытыйКлюч.КнопкаПоУмолчанию = Истина;
	ЗапретитьЗакрытие = Ложь;
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.НачатьСозданиеКлюча);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуОтправкиЗаявления()
	
	Заголовок = НСтр("ru = 'Подождите, пожалуйста...'");
	
	Если ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется отправка заявления...
                                                    |Обычно это занимает 1-2 минуты'");
	Иначе
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется отправка заявления...'");
	КонецЕсли;
	
	ЗапретитьЗакрытие = Истина;
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ДлительноеДействие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуСозданияКлюча()
	
	Заголовок = НСтр("ru = 'Подождите, пожалуйста...'");
	
	Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется создание ключа...'");
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ДлительноеДействие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуСозданияКлюча()
	
	Заголовок 								 = НСтр("ru = 'Создание ключа'");
	Элементы.ЗаголовокКОшибке.Заголовок 	 = НСтр("ru = 'Не удалось создать закрытый ключ по причине:'");
	Элементы.ТекстОшибки.Заголовок 			 = ПричинаОшибки;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
	Элементы.БезЭлектроннойПодписи.Видимость = Ложь;
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ОписаниеОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОтправкиЗаявления()
	
	Заголовок = НСтр("ru = 'Отправка заявления'");
	РеквизитыДокумента       = ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьСтруктуруРеквизитовЗаявления(Заявление);
	ИспользоватьСуществующий = РеквизитыДокумента.СпособПолученияСертификата = ПредопределенноеЗначение("Перечисление.СпособПолученияСертификата.ИспользоватьСуществующий");
		
	ПричинаОшибки = СтрЗаменить(ПричинаОшибки, Символы.ПС + Символы.ПС, Символы.ПС);
	
	Если СтрНайти(ПричинаОшибки, НСтр("ru = 'Не удалось выполнить подписание сертификатом'")) <> 0 Тогда
		
		Ошибки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПричинаОшибки, Символы.Таб);
		
		Элементы.ЗаголовокКОшибке.Заголовок = Ошибки[0];
		Элементы.ТекстОшибки.Заголовок 		= Ошибки[1];
		
		Если ИспользоватьСуществующий Тогда
			Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
			Элементы.БезЭлектроннойПодписи.Видимость = Ложь;
		Иначе
			
			Элементы.РекомендацияКОшибке.Заголовок 	= НСтр("ru = '
                                                |Попробуйте устранить причину или отправьте заявление без электронной подписи.'");
			Элементы.БезЭлектроннойПодписи.КнопкаПоУмолчанию = Истина;
			Элементы.ПустышкаДляВыравнивания.Видимость       = Ложь;
		КонецЕсли;
		
	ИначеЕсли СтрНайти(ПричинаОшибки, НСтр("ru = 'ТикетАутентификацииНаПорталеПоддержки'")) <> 0 Тогда
		
		Если ПричинаОшибки = "ТикетАутентификацииНаПорталеПоддержки.КодОшибки:ПревышеноКоличествоПопыток"
			И НЕ РеквизитыДокумента.ЭлектроннаяПодписьВМоделиСервиса Тогда
			
			Элементы.ТекстОшибки.Заголовок 		   = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС.
                                                           |Ответ сервера: превышено количество попыток авторизации'");
			Элементы.РекомендацияКОшибке.Заголовок = КонтекстЭДОКлиент.ТекстДляПревышеноКоличествоПопытокПолученияТикета();

		ИначеЕсли ПричинаОшибки = "ТикетАутентификацииНаПорталеПоддержки.КодОшибки:НеверныйЛогинИлиПароль"
			И НЕ РеквизитыДокумента.ЭлектроннаяПодписьВМоделиСервиса Тогда
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			
			Элементы.РекомендацияКОшибке.Заголовок = Новый ФорматированнаяСтрока(
				Символы.ПС,
				НСтр("ru = 'Для отправки заявления необходимо '"),
				Новый ФорматированнаяСтрока(НСтр("ru = 'задать'"),,,,"задать логин и пароль от ИТС"),
				НСтр("ru = ' логин и пароль от '"),
				Новый ФорматированнаяСтрока(НСтр("ru = 'Портала 1С:ИТС'"),,,,"перейти на Портал ИТС"),
				НСтр("ru = ' и повторить отправку.'"));

		ИначеЕсли СокрЛП(РеквизитыДокумента.НомерОсновнойПоставки1с) = "" Тогда
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = '
                                                           |Для отправки заявления необходимо заполнить рег. номер программы в заявлении'");
			
			Оповестить(НСтр("ru = 'Заполнить рег. номер'"), Истина, Заявление);
			
		Иначе
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = '
                                                           |Обратитесь в службу поддержки или повторите попытку позже.'");
			
			Оповестить(НСтр("ru = 'Заполнить рег. номер'"), Истина, Заявление);
			
		КонецЕсли;
		
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию    = Истина;
		Элементы.БезЭлектроннойПодписи.Видимость   = Ложь;
		Элементы.ПустышкаДляВыравнивания.Видимость = Истина;		
	Иначе
		Элементы.ЗаголовокКОшибке.Заголовок		   = НСтр("ru = 'Не удалось отправить заявление по причине:'");
		Элементы.ТекстОшибки.Заголовок 			   = ПричинаОшибки;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию    = Истина;
		Элементы.БезЭлектроннойПодписи.Видимость   = Ложь;
		Элементы.ПустышкаДляВыравнивания.Видимость = Истина;
	КонецЕсли;
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ОписаниеОшибки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницу(Форма, ТекущаяСтраница)
	
	ДокументооборотСКОКлиентСервер.АктивизироватьСтраницу(Форма.Элементы.Этапы, ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура БезЭлектроннойПодписи(Команда)
	
	ВладелецФормы.ОтправитьВБумажномВиде();
	ЗапретитьЗакрытие = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти