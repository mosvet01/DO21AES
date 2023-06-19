
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьВопросыДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности");
	
	ПараметрыДляИнициализации = ПараметрыИнициализацииФормы();
	ЗаполнитьЗначенияСвойств(ПараметрыДляИнициализации, Параметры);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДляИнициализации);
	
	ОбязательноеУказаниеОтветственного =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "ОбязательноеУказаниеОтветственного");
	
	НастроитьЭлементыПоШаблону();
	
	Если МиграцияДанныхИзВнешнихСистемСервер.БлокироватьОбменСВнешнимиРесурсами() Тогда
		УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовОсновнойСтраницыФормы

&НаКлиенте
Процедура ШаблонДокументаПриИзменении(Элемент)
	
	НастроитьЭлементыПоШаблону();
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаПриИзменении(Элемент)
	
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрифДоступаПриИзменении(Элемент)
	
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросДеятельностиПриИзменении(Элемент)
	
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	НастроитьПодсказкиЭлементовПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонНаименованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МаксимальнаяДлинаСтроки",   500);
	ПараметрыФормы.Вставить("РазрешенПереносСтрок",      Ложь);
	ПараметрыФормы.Вставить("ШаблонСтроки",              ШаблонНаименования);
	ПараметрыФормы.Вставить("НаименованиеПоля",          НСтр("ru = 'Наименование документа'"));
	ПараметрыФормы.Вставить("ИмяМакетаДереваПараметров", "ДеревоПараметровСозданияДокумента");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактированияНаименования", ЭтаФорма);
	
	ОткрытьФорму(
		"РегистрСведений.ПравилаУчетаВидовЭДДО.Форма.ФормаШаблонаСтроковыхПолей",
		ПараметрыФормы,
		ЭтаФорма, , , ,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеРедактированияНаименования(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНаименования = Результат;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонСодержанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МаксимальнаяДлинаСтроки",   0);
	ПараметрыФормы.Вставить("РазрешенПереносСтрок",      Истина);
	ПараметрыФормы.Вставить("ШаблонСтроки",              ШаблонСодержания);
	ПараметрыФормы.Вставить("НаименованиеПоля",          НСтр("ru = 'Содержание документа'"));
	ПараметрыФормы.Вставить("ИмяМакетаДереваПараметров", "ДеревоПараметровСозданияДокумента");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактированияСодержания", ЭтаФорма);
	
	ОткрытьФорму(
		"РегистрСведений.ПравилаУчетаВидовЭДДО.Форма.ФормаШаблонаСтроковыхПолей",
		ПараметрыФормы,
		ЭтаФорма, , , ,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеРедактированияСодержания(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонСодержания = Результат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ИндексКартинкиОтраженияВДО = 3;
	
	Если НастройкиКорректны(ИндексКартинкиОтраженияВДО) Тогда
		ЗаписатьИЗакрыть(ИндексКартинкиОтраженияВДО);
	Иначе
		
		ДопПараметры = Новый Структура("ИндексКартинкиОтраженияВДО", ИндексКартинкиОтраженияВДО);
		
		ОповещениеООтвете = Новый ОписаниеОповещения("ОбработатьОтветЗаписатьИЗакрыть", ЭтаФорма, ДопПараметры);
		
		ПоказатьВопрос(ОповещениеООтвете,
			НСтр("ru = 'В настройках создания документов присутствуют ошибки. Документы могут не создаваться.'") +
				Символы.ПС +
				НСтр("ru = 'Записать настройки в таком виде?'"),
			РежимДиалогаВопрос.ДаНет, , ,
			НСтр("ru = 'Ошибки заполнения'"));
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветЗаписатьИЗакрыть(Результат, ДопПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИЗакрыть(ДопПараметры.ИндексКартинкиОтраженияВДО);
	
КонецПроцедуры

&НаКлиенте
Функция НастройкиКорректны(ИндексКартинкиОтраженияВДО)
	
	ОчиститьСообщения();
	
	ЕстьОшибки = Ложь;
	
	Если Не ЗначениеЗаполнено(ШаблонНаименования) Тогда
		
		ТекстСообщения = НСтр("ru = 'Шаблон наименования не заполнен. Документы будут создаватья по типовому шаблону'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ШаблонНаименования");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(2, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Папка)
		И Не ЗначениеЗаполнено(ПапкаШаблона) Тогда
		
		Если ЗначениеЗаполнено(Шаблон) Тогда
			ТекстСообщения = НСтр("ru = 'Папка не указана ни в шаблоне, ни в настройках'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Папка не указана'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"Папка");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(1, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	Если ИспользоватьГрифыДоступа
		И Не ЗначениеЗаполнено(ГрифДоступа)
		И Не ЗначениеЗаполнено(ГрифДоступаШаблона) Тогда
		
		Если ЗначениеЗаполнено(ГрифДоступа) Тогда
			ТекстСообщения = НСтр("ru = 'Гриф доступа не указан ни в шаблоне, ни в настройках'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Гриф доступа не указан'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ГрифДоступа");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(1, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	Если ИспользоватьВопросыДеятельности
		И Не ЗначениеЗаполнено(ВопросДеятельности)
		И Не ЗначениеЗаполнено(ВопросДеятельностиШаблона) Тогда
		
		Если ЗначениеЗаполнено(Шаблон) Тогда
			ТекстСообщения = НСтр("ru = 'Вопрос деятельности не указан ни в шаблоне, ни в настройках'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Вопрос деятельности не указан'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ВопросДеятельности");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(1, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный)
		И Не ЗначениеЗаполнено(ОтветственныйШаблона)
		И ОбязательноеУказаниеОтветственного Тогда
		
		Если ЗначениеЗаполнено(Шаблон) Тогда
			ТекстСообщения = НСтр("ru = 'Ответственный не указан ни в шаблоне, ни в настройках'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Ответственный не указан'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ВопросДеятельности");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(1, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	РезультатПроверкиШаблонаНаименования = ПроверитьКорректностьШаблона(ШаблонНаименования);
	
	Если Не РезультатПроверкиШаблонаНаименования.Успех Тогда
		ТекстСообщения = НСтр("ru = 'Шаблон наименования документа заполнен некорректно:'")
			+ Символы.ПС
			+ РезультатПроверкиШаблонаНаименования.Описание;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ШаблонНаименования");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(2, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	РезультатПроверкиШаблонаСодержания = ПроверитьКорректностьШаблона(ШаблонСодержания);
	
	Если Не РезультатПроверкиШаблонаСодержания.Успех Тогда
		ТекстСообщения = НСтр("ru = 'Шаблон содержания документа заполнен некорректно:'")
			+ Символы.ПС
			+ РезультатПроверкиШаблонаСодержания.Описание;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,
			"ШаблонСодержания");
		
		ЕстьОшибки = Истина;
		ИндексКартинкиОтраженияВДО = Мин(2, ИндексКартинкиОтраженияВДО);
	КонецЕсли;
	
	Возврат Не ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьИЗакрыть(ИндексКартинкиОтраженияВДО)

	ПараметрыЗакрытия = ПараметрыИнициализацииФормы();
	ЗаполнитьЗначенияСвойств(ПараметрыЗакрытия, ЭтотОбъект);
	
	// Дополнительные служебные свойства
	ПараметрыЗакрытия.Вставить("Модифицированность", Модифицированность);
	ПараметрыЗакрытия.Вставить("ИндексКартинкиОтраженияВДО", ИндексКартинкиОтраженияВДО);
	
	Закрыть(ПараметрыЗакрытия);

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыИнициализацииФормы()
	
	ПараметрыИнициализации = Новый Структура(
		"ВидДокумента,
		|ВидДокументаЭДО,
		|ВопросДеятельности,
		|Ответственный,
		|Папка,
		|ГрифДоступа,
		|Шаблон,
		|ШаблонНаименования,
		|ШаблонСодержания");
	
	Возврат ПараметрыИнициализации;
	
КонецФункции

&НаСервере
Процедура НастроитьЭлементыПоШаблону()
	
	СтруктураПредставлений = Новый Структура("Папка, ВопросДеятельности, Ответственный, ГрифДоступа");
	
	ПапкаШаблона = Неопределено;
	ВопросДеятельностиШаблона = Неопределено;
	ОтветственныйШаблона = Неопределено;
	
	Если ЗначениеЗаполнено(Шаблон) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
				"ВЫБРАТЬ
				|	ПРЕДСТАВЛЕНИЕ(Шаблоны.Папка) КАК ПапкаПредставление,
				|	Шаблоны.Папка КАК Папка,
				|	ПРЕДСТАВЛЕНИЕ(Шаблоны.ВопросДеятельности) КАК ВопросДеятельностиПредставление,
				|	Шаблоны.ВопросДеятельности КАК ВопросДеятельности,
				|	ПРЕДСТАВЛЕНИЕ(Шаблоны.Ответственный) КАК ОтветственныйПредставление,
				|	Шаблоны.Ответственный КАК Ответственный,
				|	ПРЕДСТАВЛЕНИЕ(Шаблоны.ГрифДоступа) КАК ГрифДоступаПредставление,
				|	Шаблоны.ГрифДоступа КАК ГрифДоступа
				|ИЗ
				|	Справочник.ШаблоныВнутреннихДокументов КАК Шаблоны
				|ГДЕ
				|	Шаблоны.Ссылка = &Шаблон";
		Запрос.УстановитьПараметр("Шаблон", Шаблон);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			СтруктураПредставлений.Папка				= Выборка.ПапкаПредставление;
			СтруктураПредставлений.ВопросДеятельности	= Выборка.ВопросДеятельностиПредставление;
			СтруктураПредставлений.Ответственный		= Выборка.ОтветственныйПредставление;
			СтруктураПредставлений.ГрифДоступа			= Выборка.ГрифДоступаПредставление;
			
			ПапкаШаблона								= Выборка.Папка;
			ВопросДеятельностиШаблона					= Выборка.ВопросДеятельности;
			ОтветственныйШаблона						= Выборка.Ответственный;
			ГрифДоступаШаблона							= Выборка.ГрифДоступа;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Папка.АвтоОтметкаНезаполненного = Не ЗначениеЗаполнено(ПапкаШаблона);
	Если ЗначениеЗаполнено(СтруктураПредставлений.Папка) Тогда
		Элементы.Папка.Подсказка = СтрШаблон(
			НСтр("ru = 'В шаблоне документа: %1'"),
			СтруктураПредставлений.Папка);
		Элементы.Папка.ПодсказкаВвода = СтрШаблон(
			НСтр("ru = 'Из шаблона: %1'"),
			СтруктураПредставлений.Папка);
	Иначе
		Элементы.Папка.Подсказка = НСтр("ru = 'В шаблоне не заполнена'");
		Элементы.Папка.ПодсказкаВвода = "";
	КонецЕсли;
	Элементы.Папка.ОтметкаНезаполненного = Не ЗначениеЗаполнено(Папка) И Не ЗначениеЗаполнено(ПапкаШаблона);
	
	Элементы.ВопросДеятельности.АвтоОтметкаНезаполненного = Не ЗначениеЗаполнено(ВопросДеятельностиШаблона);
	Если ЗначениеЗаполнено(СтруктураПредставлений.ВопросДеятельности) Тогда
		Элементы.ВопросДеятельности.Подсказка = СтрШаблон(
			НСтр("ru = 'В шаблоне документа: %1'"),
			СтруктураПредставлений.ВопросДеятельности);
		Элементы.ВопросДеятельности.ПодсказкаВвода = СтрШаблон(
			НСтр("ru = 'Из шаблона: %1'"),
			СтруктураПредставлений.ВопросДеятельности);
	Иначе
		Элементы.ВопросДеятельности.Подсказка = НСтр("ru = 'В шаблоне не заполнен'");
		Элементы.ВопросДеятельности.ПодсказкаВвода = "";
	КонецЕсли;
	Элементы.ВопросДеятельности.ОтметкаНезаполненного =
		Не ЗначениеЗаполнено(ВопросДеятельности) И Не ЗначениеЗаполнено(ВопросДеятельностиШаблона);
	
	Элементы.Ответственный.АвтоОтметкаНезаполненного =
		Не ЗначениеЗаполнено(ОтветственныйШаблона) И ОбязательноеУказаниеОтветственного;
	Если ЗначениеЗаполнено(СтруктураПредставлений.Ответственный) Тогда
		Элементы.Ответственный.Подсказка = СтрШаблон(
			НСтр("ru = 'В шаблоне документа: %1'"),
			СтруктураПредставлений.Ответственный);
		Элементы.Ответственный.ПодсказкаВвода = СтрШаблон(
			НСтр("ru = 'Из шаблона: %1'"),
			СтруктураПредставлений.Ответственный);
	Иначе
		Элементы.Ответственный.Подсказка = НСтр("ru = 'В шаблоне не заполнен'");
		Элементы.Ответственный.ПодсказкаВвода = "";
	КонецЕсли;
	Элементы.Ответственный.ОтметкаНезаполненного =
		Не ЗначениеЗаполнено(Ответственный) И Не ЗначениеЗаполнено(ОтветственныйШаблона)
		И ОбязательноеУказаниеОтветственного;
	
	Элементы.ГрифДоступа.АвтоОтметкаНезаполненного = Не ЗначениеЗаполнено(ГрифДоступаШаблона);
	Если ЗначениеЗаполнено(СтруктураПредставлений.ГрифДоступа) Тогда
		Элементы.ГрифДоступа.Подсказка = СтрШаблон(
			НСтр("ru = 'В шаблоне документа: %1'"),
			СтруктураПредставлений.ГрифДоступа);
		Элементы.ГрифДоступа.ПодсказкаВвода = СтрШаблон(
			НСтр("ru = 'Из шаблона: %1'"),
			СтруктураПредставлений.ГрифДоступа);
	Иначе
		Элементы.ГрифДоступа.Подсказка = НСтр("ru = 'В шаблоне не заполнен'");
		Элементы.ГрифДоступа.ПодсказкаВвода = "";
	КонецЕсли;
	Элементы.ГрифДоступа.ОтметкаНезаполненного =
		Не ЗначениеЗаполнено(ГрифДоступа) И Не ЗначениеЗаполнено(ГрифДоступаШаблона);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодсказкиЭлементовПоШаблону()

	Если Не ЗначениеЗаполнено(Шаблон) Тогда
	
		Элементы.Папка.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ВопросДеятельности.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.Ответственный.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ГрифДоступа.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	
	Иначе
	
		Элементы.Папка.ОтображениеПодсказки = 
			?(ЗначениеЗаполнено(Папка) И ЗначениеЗаполнено(ПапкаШаблона),
				ОтображениеПодсказки.ОтображатьСнизу,
				ОтображениеПодсказки.Нет);
		Элементы.ВопросДеятельности.ОтображениеПодсказки = 
			?(ЗначениеЗаполнено(ВопросДеятельности) И ЗначениеЗаполнено(ВопросДеятельностиШаблона),
				ОтображениеПодсказки.ОтображатьСнизу,
				ОтображениеПодсказки.Нет);
		Элементы.Ответственный.ОтображениеПодсказки = 
			?(ЗначениеЗаполнено(Ответственный) И ЗначениеЗаполнено(ОтветственныйШаблона),
				ОтображениеПодсказки.ОтображатьСнизу,
				ОтображениеПодсказки.Нет);
		Элементы.ГрифДоступа.ОтображениеПодсказки = 
			?(ЗначениеЗаполнено(ГрифДоступа) И ЗначениеЗаполнено(ГрифДоступаШаблона),
				ОтображениеПодсказки.ОтображатьСнизу,
				ОтображениеПодсказки.Нет);
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьКорректностьШаблона(ШаблонЗаполнения)
	
	СтруктураВозврата = Новый Структура("Успех, Описание");
	
	РезультатВыделенияПараметров = ОбменСКонтрагентамиДОСервер.ПараметрыВШаблонеСтроковогоПоля(ШаблонЗаполнения);
	
	Если Не РезультатВыделенияПараметров.Успех Тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, РезультатВыделенияПараметров);
		
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	ДеревоПараметров = ОбменСКонтрагентамиДОСервер.ДеревоПараметровЗаполненияСтроковыхПолей(
		"ДеревоПараметровСозданияДокумента");
	
	Для Каждого ИмяПараметра Из РезультатВыделенияПараметров.МассивПараметров Цикл
		Если ДеревоПараметров.Строки.Найти(ИмяПараметра, "ПредставлениеПолное", Истина) = Неопределено Тогда
			
			СтруктураВозврата.Успех = Ложь;
			СтруктураВозврата.Описание = СтрШаблон(
				НСтр("ru = 'Параметр [%1] не найден в возможных параметрах заполнения.'"),
				ИмяПараметра);
			
			Возврат СтруктураВозврата;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата.Успех = Истина;
	СтруктураВозврата.Описание = НСтр("ru = 'Шаблон заполнения корректен'");
	
	Возврат СтруктураВозврата;
	
КонецФункции // ()

&НаСервере
Процедура УстановитьВидимостьДоступностьПоПереходуНаНовуюВерсию()
	
	ТолькоПросмотр = Истина;
	Элементы.ГруппаМиграцияНаНовуюВерсию.Видимость = Истина;
	Элементы.ФормаКомандаЗаписатьИЗакрыть.Доступность = Ложь;
	
	Элементы.НадписьМиграцияНаНовуюВерсию.Заголовок =
		НСтр("ru = 'Обмен с контрагентами по ЭДО выполняется и настраивается в новой версии программы. Настройки создания документов необходимо производить в новой версии программы.'");
	
КонецПроцедуры

#КонецОбласти
