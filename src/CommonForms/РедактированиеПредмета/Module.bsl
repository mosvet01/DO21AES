////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РольПредмета = Перечисления.РолиПредметов.Основной И Параметры.Добавление Тогда
		Заголовок = НСтр("ru='Добавление основного предмета'");
	ИначеЕсли Параметры.РольПредмета = Перечисления.РолиПредметов.Основной И Не Параметры.Добавление Тогда
		Заголовок = НСтр("ru='Основной предмет'");
	ИначеЕсли Параметры.РольПредмета = Перечисления.РолиПредметов.Вспомогательный И Параметры.Добавление Тогда
		Заголовок = НСтр("ru='Добавление вспомогательного предмета'");
	ИначеЕсли Параметры.РольПредмета = Перечисления.РолиПредметов.Вспомогательный И Не Параметры.Добавление Тогда
		Заголовок = НСтр("ru='Вспомогательный предмет'");
	КонецЕсли;
	
	Если Параметры.РольПредмета = Перечисления.РолиПредметов.Основной Тогда
		Элементы.ДекорацияОписание.Заголовок = НСтр("ru='Основной предмет изменяет свое состояние по мере выполнения задач процесса.'")
	ИначеЕсли Параметры.РольПредмета = Перечисления.РолиПредметов.Вспомогательный Тогда
		Элементы.ДекорацияОписание.Заголовок = НСтр("ru='Вспомогательный предмет несет дополнительную информацию и не 
														|меняет свое состояние по мере выполнения задач процесса.'")
	КонецЕсли;
	
	Параметры.Свойство("Предмет", Предмет);
	Параметры.Свойство("Предмет", ИсходныйПредмет);
	Параметры.Свойство("ИмяПредмета", ИмяПредмета);
	Параметры.Свойство("ИмяПредмета",ИсходноеИмяПредмета);
	Параметры.Свойство("ИмяПредмета", ИмяПредметаСтрокой);
	Параметры.Свойство("РольПредмета",РольПредмета);
	Параметры.Свойство("ИменаПредметовИсключений",ИменаПредметовИсключений);
	Параметры.Свойство("СсылкаНаПроцесс",СсылкаНаПроцесс);
	Параметры.Свойство("Шаблон",Шаблон);
	Параметры.Свойство("ШаблонПроцесса",ШаблонПроцесса);
	Параметры.Свойство("ТолькоПросмотр", ТолькоПросмотр);
	
	Если Параметры.Свойство("Шаблон") Тогда
		СсылкаНаПроцесс = МультипредметностьПереопределяемый.ПолучитьСсылкуНаПроцессПоШаблону(Параметры.Шаблон);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонПроцесса) Тогда 
		ТипыПредмета = МультипредметностьВызовСервера.ПолучитьОграничениеТиповИмениПредметаШаблона(ШаблонПроцесса, ИмяПредмета);
	КонецЕсли;
	
	Если ТипыПредмета.Количество() = 0 Тогда
		ТипыПредмета = МультипредметностьВызовСервера.ПолучитьСписокТиповПредметовПроцесса(СсылкаНаПроцесс, РольПредмета);
	КонецЕсли;
	
	Если Параметры.Свойство("Шаблон") Тогда
		ТипыПредмета.Вставить(0, "Неопределено", НСтр("ru='Любой доступный тип'"));
	КонецЕсли;
	
	Для Каждого Элемент Из ТипыПредмета Цикл
		Элементы.ПредметСтрокой.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	
	Если Предмет = Неопределено Тогда
		ПредметСтрокой = "Неопределено";
	Иначе
		ПредметСтрокой = Предмет.Метаданные().ПолноеИмя();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТолькоПросмотр Тогда
		Отказ = Истина;
		ПоказатьЗначение(,Предмет);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредметСтрокойПриИзменении(Элемент)
	
	Если ПредметСтрокой = "" Тогда
		ПредметСтрокой = "Неопределено";
	КонецЕсли;
	
	ВыбранноеЗначение = ТипыПредмета.НайтиПоЗначению(ПредметСтрокой);
	Если ВыбранноеЗначение <> Неопределено Тогда
		Если Найти(ВыбранноеЗначение.Значение,"Справочник")
			Или Найти(ВыбранноеЗначение.Значение,"Документ") Тогда
			Предмет = ПредопределенноеЗначение(ВыбранноеЗначение.Значение + ".ПустаяСсылка");
		Иначе
			Предмет = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПредметаСтрокойПриИзменении(Элемент)
	
	ИмяПредмета = МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредмета(ИмяПредметаСтрокой);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПредметаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если СтрДлина(Текст) > 1 Тогда
		МультипредметностьВызовСервера.ПолучитьДанныеДляАвтоподбораИмениПредмета(ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Шаблон = Неопределено Тогда
		Если Не ЗначениеЗаполнено(Предмет) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			    НСтр("ru = 'Поле ""Предмет"" не заполнено'"),, 
				"Предмет");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяПредмета) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    НСтр("ru = 'Поле ""Имя предмета"" не заполнено'"),, 
			"ИмяПредметаСтрокой");
		Отказ = Истина;
	КонецЕсли;	
	
	Если ИменаПредметовИсключений.НайтиПоЗначению(ИмяПредмета) <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя предмета ""%1"" уже используется в этом процессе'"),
				Строка(ИмяПредмета)),, 
			"ИмяПредметаСтрокой");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяПредмета <> ИсходноеИмяПредмета 
	 Или Предмет <> ИсходныйПредмет Тогда
	 
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("РольПредмета",РольПредмета);
		СтруктураВозврата.Вставить("ИмяПредмета",ИмяПредмета);
		СтруктураВозврата.Вставить("Предмет",Предмет);
		
		Если Шаблон = Неопределено Тогда
			СтруктураВозврата.Вставить("Описание", ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(Предмет, ИмяПредмета));
		Иначе
			СтруктураВозврата.Вставить("Описание");
			МультипредметностьКлиентСервер.УстановитьОписаниеСтрокиПредметаШаблона(СтруктураВозврата);
		КонецЕсли;
		
		Закрыть(СтруктураВозврата);
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры


