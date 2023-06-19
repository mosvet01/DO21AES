#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Родитель") И ЗначениеЗаполнено(Параметры.Родитель) Тогда
		Объект.Родитель = Параметры.Родитель;
	КонецЕсли;
	
	ПланСхема = РаботаСФотографиями.ПолучитьНавигационнуюСсылкуРеквизита(
		Объект.Ссылка, УникальныйИдентификатор, ЕстьКартинка);
	ПланСхемаПриЗагрузке = ПланСхема;
	Элементы.ЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ФормаЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ОчиститьИзображение.Доступность = ЕстьКартинка;
	Элементы.ФормаОчиститьИзображение.Доступность = ЕстьКартинка;
	
	// Заполнение текстовых реквизитов
	Если ЗначениеЗаполнено(Объект.Родитель) Тогда
		РодительТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(Объект.Родитель);
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая()Тогда 
		Элементы.ФормаЗагрузитьИзображение.ТолькоВоВсехДействиях = Истина;
		Элементы.ФормаОчиститьИзображение.ТолькоВоВсехДействиях = Истина;
	КонецЕсли;
	
	ИспользоватьБронированиеПомещений = ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПомещений");
	Элементы.ФормаПодписаться.Видимость = ИспользоватьБронированиеПомещений;
	Элементы.СтраницаБронирование.Видимость = ИспользоватьБронированиеПомещений;
	Если ИспользоватьБронированиеПомещений Тогда
		Элементы.СтранцыТерриторииИПомещения.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.СтранцыТерриторииИПомещения.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	ОбновитьОтветственныхЗаОбеспечение();
	УстановитьДоступностьПоПравам();
	
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	МК_НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если  ПланСхема <> ПланСхемаПриЗагрузке Тогда 
		Если ЗначениеЗаполнено(ПланСхема) Тогда 
			РаботаСФотографиями.ЗаписатьИзображениеТерритории(Объект.Ссылка, ПланСхема, УникальныйИдентификатор);
		ИначеЕсли Не Объект.Ссылка.Пустая() Тогда 
			РаботаСФотографиями.ОчиститьИзображениеТерритории(Объект.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПланСхема <> ПланСхемаПриЗагрузке Тогда 
		ПланСхемаПриЗагрузке = ПланСхема;
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
	Оповестить("Запись_ТерриторииИПомещения", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйХозяйственноеОбеспечениеПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйТехническоеОбеспечениеПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСхемаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ПланСхема) Тогда 
		ЗагрузитьИзображениеНаКлиенте();
	Иначе 
		ИмяВременногоФайла = КаталогВременныхФайлов() + УникальныйИдентификатор + ".png";
		Картинка = РаботаСФотографиями.ПолучитьДвоичныеДанныеСхемыТерритории(Объект.Ссылка, ПланСхема);
		Если ЗначениеЗаполнено(Картинка) Тогда 
			Картинка.Записать(ИмяВременногоФайла);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПланСхемаНажатиеПослеЗапускаПриложения",
				ЭтотОбъект);
			НачатьЗапускПриложения(ОписаниеОповещения, ИмяВременногоФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСхемаНажатиеПослеЗапускаПриложения(КодВозврата, ДополнительныеПараметры) Экспорт
	ПроходитАПК = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(РодительТекст) Тогда 
		Объект.Родитель = Неопределено;
		РодительТекст = Неопределено;
		ОтветственныйТехническоеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		ОтветственныйХозяйственноеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		УстановитьВидимостьЭлементов();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.Родитель);
	ОткрытьФорму("Справочник.ТерриторииИПомещения.ФормаВыбора", ПараметрыФормы, 
		Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Родитель = Неопределено;
	РодительТекст = Неопределено;
	ОтветственныйТехническоеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ОтветственныйХозяйственноеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(РодительТекст) Тогда
		ПоказатьЗначение(, Объект.Родитель);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда 
		
		СтандартнаяОбработка = Ложь;
		Объект.Родитель = ВыбранноеЗначение;
		Модифицированность = Истина;
		
		Если ЗначениеЗаполнено(Объект.Родитель) Тогда 
			РодительТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(Объект.Родитель);
			ОбновитьОтветственныхЗаОбеспечение();
		Иначе
			РодительТекст = Неопределено;
			ОтветственныйТехническоеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			ОтветственныйХозяйственноеОбеспечениеПоИерархии = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;
		УстановитьВидимостьЭлементов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораРодителя(Текст, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораРодителя(Текст, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзображение(Команда)
	
	ЗагрузитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	ЕстьКартинка = Ложь;
	ПланСхема = Неопределено;
	Элементы.ЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ФормаЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ОчиститьИзображение.Доступность = ЕстьКартинка;
	Элементы.ФормаОчиститьИзображение.Доступность = ЕстьКартинка;
	Прочитать();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьИзображениеНаКлиенте()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗагрузитьИзображениеНаКлиентеПродолжение",
		ЭтотОбъект);
		
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Ок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзображениеНаКлиентеПродолжение(Результат, Параметры)Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗагрузитьИзображениеНаКлиентеЗавершение",
		ЭтотОбъект,
		Новый Структура("АдресВременногоХранилищаФайла", ""));
		
	ФайловыеФункцииКлиент.ВыбратьКартинкуИПоместитьВХранилище(
		ОписаниеОповещения, УникальныйИдентификатор, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзображениеНаКлиентеЗавершение(Результат, Параметры)Экспорт 
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьКартинка = Истина;
	ПланСхема = Параметры.АдресВременногоХранилищаФайла;
	
	Элементы.ЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ФормаЗагрузитьИзображение.Доступность = Не ЕстьКартинка;
	Элементы.ОчиститьИзображение.Доступность = ЕстьКартинка;
	Элементы.ФормаОчиститьИзображение.Доступность = ЕстьКартинка;
	Прочитать();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораРодителя(Текст, ТекущееМесто)
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТерриторииИПомещения.Ссылка
			|ИЗ
			|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
			|ГДЕ
			|	ТерриторииИПомещения.Наименование ПОДОБНО &Текст
			|	И НЕ ТерриторииИПомещения.ПометкаУдаления
			|	И ТерриторииИПомещения.Ссылка <> &ТекущееМесто"; 
			   
	
	Запрос.УстановитьПараметр("Текст", Текст + "%"); 
	Запрос.УстановитьПараметр("ТекущееМесто", ТекущееМесто); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПланТекст = ДелопроизводствоКлиентСервер.ПолучитьПолныйПутьКПомещению(Выборка.Ссылка);
		ДанныеВыбора.Добавить(Выборка.Ссылка, ПланТекст);
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	Если ИспользоватьБронированиеПомещений Тогда
		Элементы.ОтветственныйТехническоеОбеспечениеПоИерархии.Видимость =
			ЗначениеЗаполнено(ОтветственныйТехническоеОбеспечениеПоИерархии)
			И Не ЗначениеЗаполнено(Объект.ОтветственныйТехническоеОбеспечение);
		Элементы.ОтветственныйХозяйственноеОбеспечениеПоИерархии.Видимость = 
			ЗначениеЗаполнено(ОтветственныйХозяйственноеОбеспечениеПоИерархии)
			И Не ЗначениеЗаполнено(Объект.ОтветственныйХозяйственноеОбеспечение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоПравам()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
		Если Не ПраваПоОбъекту.Изменение Тогда
			ТолькоПросмотр = Истина;
			Элементы.РодительТекст.ТолькоПросмотр = Истина;
			Элементы.РодительТекст.КнопкаВыбора = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтветственныхЗаОбеспечение()
	
	ОтветственныйТехническоеОбеспечениеПоИерархии =
		Справочники.ТерриторииИПомещения.ОтветственныйТехническоеОбеспечение(Объект.Родитель);
	ОтветственныйХозяйственноеОбеспечениеПоИерархии =
		Справочники.ТерриторииИПомещения.ОтветственныйХозяйственноеОбеспечение(Объект.Родитель);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	// Общая настройка формы.
	СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	// Страница с помещением.
	Элементы.ГруппаНаименованиеИКод.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Элементы.Наименование.Заголовок = НСтр("ru = 'Наименование'");
	Элементы.Наименование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.Наименование.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	Элементы.Наименование.РастягиватьПоГоризонтали = Истина;
	
	Элементы.РодительТекст.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.РодительТекст.РастягиватьПоГоризонтали = Истина;
	Элементы.РодительТекст.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	
	// Страница с бронированием.
	Элементы.ДоступноБронирование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.БрониВводитОтветственный.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
