
#Область ПрограммныйИнтерфейс

Процедура АдаптироватьЭлементыФормыКарточкиПроцесса(Форма, Параметры) Экспорт
	
	Элементы = Форма.Элементы;
	Форма.СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	Форма.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
#Область ОсновныеСведенияОПроцессе
	
	Если Параметры.ЭлементНаименование <> Неопределено Тогда
		
		ЭлементНаименование = Параметры.ЭлементНаименование;
		
		Если ПустаяСтрока(ЭлементНаименование.Заголовок)
			И Не ПустаяСтрока(ЭлементНаименование.ПодсказкаВвода) Тогда
			ЭлементНаименование.Заголовок = ЭлементНаименование.ПодсказкаВвода;
			ЭлементНаименование.ПодсказкаВвода = "";
		КонецЕсли;
		
		ЭлементНаименование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		ЭлементНаименование.МногострочныйРежим = Истина;
		ЭлементНаименование.АвтоМаксимальнаяВысота = Ложь;
		ЭлементНаименование.МаксимальнаяВысота = 4;
		
	КонецЕсли;
	
	Если Параметры.ЭлементВажность <> Неопределено Тогда
		
		ЭлементВажность = Параметры.ЭлементВажность;
		
		Если ПустаяСтрока(ЭлементВажность.Заголовок)
			И Не ПустаяСтрока(ЭлементВажность.ПодсказкаВвода) Тогда
			ЭлементВажность.Заголовок = ЭлементВажность.ПодсказкаВвода;
			ЭлементВажность.ПодсказкаВвода = "";
		КонецЕсли;
		
		ЭлементВажность.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		ЭлементВажность.РастягиватьПоГоризонтали = Истина;
		ЭлементВажность.Ширина = 0;
		ЭлементВажность.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		
	КонецЕсли;
	
	Если Параметры.ЭлементОписание <> Неопределено Тогда
		
		ЭлементОписание = Параметры.ЭлементОписание;
		
		Если ПустаяСтрока(ЭлементОписание.Заголовок)
			И Не ПустаяСтрока(ЭлементОписание.ПодсказкаВвода) Тогда
			ЭлементОписание.Заголовок = ЭлементОписание.ПодсказкаВвода;
			ЭлементОписание.ПодсказкаВвода = "";
		КонецЕсли;
		
		ЭлементОписание.Высота = 4;
		ЭлементОписание.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
	КонецЕсли;
	
#КонецОбласти

#Область ИсполнителиИСрок
	
	Если Параметры.ЭлементГруппаИсполнители <> Неопределено Тогда
		
		ЭлементГруппаИсполнители = Параметры.ЭлементГруппаИсполнители;
		ЭлементГруппаИсполнители.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение;
		Если ЗначениеЗаполнено(ЭлементГруппаИсполнители.Заголовок) Тогда
			ЭлементГруппаИсполнители.ОтображатьЗаголовок = Истина;
			ЭлементГруппаИсполнители.ШрифтЗаголовка = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ЭлементИсполнители <> Неопределено Тогда
		
		// Адаптируем таблицу Исполнители.
		
		ЭлементИсполнители = Параметры.ЭлементИсполнители;
		НоваяВысотаТаблицы = 4;
		ЭлементИсполнители.ВысотаВСтрокахТаблицы = 1;
		ЭлементИсполнители.МаксимальнаяВысотаВСтрокахТаблицы = НоваяВысотаТаблицы;
		ЭлементИсполнители.Высота = 1;
		ЭлементИсполнители.МаксимальнаяВысота = НоваяВысотаТаблицы;
		ЭлементИсполнители.ВариантУправленияВысотой = ВариантУправленияВысотойТаблицы.ПоСодержимому;
		ЭлементИсполнители.АвтоМаксимальнаяВысотаВСтрокахТаблицы = Ложь;
		ЭлементИсполнители.АвтоМаксимальнаяВысота = Ложь;
		ЭлементИсполнители.Шапка = Ложь;
		
		ЭлементИсполнителиШаг = ЭлементИсполнители.ПодчиненныеЭлементы.Найти("Шаг");
		Если ЭлементИсполнителиШаг <> Неопределено Тогда
			ЭлементИсполнителиШаг.Ширина = 3;
		КонецЕсли;
		
		Если Параметры.ЭлементИсполнителиИсполнитель <> Неопределено Тогда
			
			ЭлементИсполнителиИсполнитель = Параметры.ЭлементИсполнителиИсполнитель;
			ЭлементИсполнителиИсполнитель.Ширина = 0;
			ЭлементИсполнителиИсполнитель.РастягиватьПоГоризонтали = Истина;
			ЭлементИсполнителиИсполнитель.АвтоВысотаЯчейки = Истина;
			ЭлементИсполнителиИсполнитель.АвтоМаксимальнаяВысота = Ложь;
			ЭлементИсполнителиИсполнитель.МаксимальнаяВысота = 2;
			
		КонецЕсли;
		
	КонецЕсли;
	
		Если Параметры.ЭлементСрокОбработкиРезультатов <> Неопределено Тогда
		
		// Адаптируем поле ввода срока обработки результата.
		ЭлементСрокОбработкиРезультатов = Параметры.ЭлементСрокОбработкиРезультатов;
		ЭлементСрокОбработкиРезультатов.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		ЭлементСрокОбработкиРезультатов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		ЭлементСрокОбработкиРезультатов.РастягиватьПоГоризонтали = Истина;
		ЭлементСрокОбработкиРезультатов.Ширина = 0;
		ЭлементСрокОбработкиРезультатов.МногострочныйРежим = Истина;
		
	КонецЕсли;
	
#КонецОбласти
	
#Область СтраницаДополнительно
	Если Параметры.ЭлементСтраницаДополнительно <> Неопределено Тогда
		
		// Адаптируем страницу Дополнительно.
		ЭлементСтраницаДополнительно = Параметры.ЭлементСтраницаДополнительно;
		ЭлементСтраницаДополнительно.ВыравниваниеЭлементовИЗаголовков =
			ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
			
		ГруппаИнфо = Элементы.Найти("ГруппаИнфо");
		Если ГруппаИнфо <> Неопределено Тогда
			ГруппаИнфо.Отображение = ОтображениеОбычнойГруппы.Нет;
		КонецЕсли;
		
		Начато = Элементы.Найти("Начато");
		Если Начато <> Неопределено Тогда
			Начато.Ширина = 0;
		КонецЕсли;
		
		Завершено = Элементы.Найти("Завершено");
		Если Завершено <> Неопределено Тогда
			Завершено.РастягиватьПоГоризонтали = Истина;
		КонецЕсли;
		
		ПроектЗадача = Элементы.Найти("ПроектЗадача");
		Если ПроектЗадача <> Неопределено Тогда
			ПроектЗадача.МногострочныйРежим = Истина;
			ПроектЗадача.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		КонецЕсли;
		
		ГлавнаяЗадача = Элементы.Найти("ГлавнаяЗадача");
		Если ГлавнаяЗадача <> Неопределено Тогда
			ГлавнаяЗадача.МногострочныйРежим = Истина;
			ГлавнаяЗадача.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		КонецЕсли;
		
		Автор = Элементы.Найти("Автор");
		Если Автор <> Неопределено Тогда
			Автор.МногострочныйРежим = Истина;
			Автор.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		КонецЕсли;
		
		ТрудозатратыПланАвтора = Элементы.Найти("ТрудозатратыПланАвтора");
		Если ТрудозатратыПланАвтора <> Неопределено Тогда
			ТрудозатратыПланАвтора.Ширина = 0;
		КонецЕсли;
		
		ПодписыватьЭП = Элементы.Найти("ПодписыватьЭП");
		Если ПодписыватьЭП <> Неопределено Тогда
			ПодписыватьЭП.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		КонецЕсли;
		
	КонецЕсли;
#КонецОбласти
	
#Область СтраницаЗадачи
	
	Если Параметры.ЭлементСтраницаЗадачи <> Неопределено
		И Параметры.ЭлементАктивныеЗадачи <> Неопределено
		И Параметры.ЭлементЗадачиИПроцессы <> Неопределено Тогда
		
		// Таблицы лежат в сворачиваемой группе, отключим их.
		ЭлементАктивныеЗадачиРодитель = Параметры.ЭлементАктивныеЗадачи.Родитель;
		Если ТипЗнч(ЭлементАктивныеЗадачиРодитель) = Тип("ГруппаФормы") Тогда
			ЭлементАктивныеЗадачиРодитель.Поведение = ПоведениеОбычнойГруппы.Обычное;
			ЭлементАктивныеЗадачиРодитель.ОтображатьЗаголовок = Ложь;
		КонецЕсли;
		
		ЭлементЗадачиИПроцессыРодитель = Параметры.ЭлементЗадачиИПроцессы.Родитель;
		Если ТипЗнч(ЭлементЗадачиИПроцессыРодитель) = Тип("ГруппаФормы") Тогда
			ЭлементЗадачиИПроцессыРодитель.Поведение = ПоведениеОбычнойГруппы.Обычное;
			ЭлементЗадачиИПроцессыРодитель.ОтображатьЗаголовок = Ложь;
		КонецЕсли;
		
		// Добавим переключать таблиц.
		ЭлементСтраницаЗадачи = Параметры.ЭлементСтраницаЗадачи;
		
		РеквизитВидСпискаЗадачДляОтображенияМК =
			Новый РеквизитФормы("ВидСпискаЗадачДляОтображенияМК", Новый ОписаниеТипов("Строка"));
		МассивРеквизитов = Новый Массив;
		МассивРеквизитов.Добавить(РеквизитВидСпискаЗадачДляОтображенияМК);
		Форма.ИзменитьРеквизиты(МассивРеквизитов);
		
		ЭлементВидСпискаЗадачДляОтображенияМК =
			Элементы.Добавить("ВидСпискаЗадачДляОтображенияМК", Тип("ПолеФормы"), ЭлементСтраницаЗадачи);
		ЭлементВидСпискаЗадачДляОтображенияМК.Вид = ВидПоляФормы.ПолеПереключателя;
		ЭлементВидСпискаЗадачДляОтображенияМК.ПутьКДанным = РеквизитВидСпискаЗадачДляОтображенияМК.Имя;
		ЭлементВидСпискаЗадачДляОтображенияМК.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		ЭлементВидСпискаЗадачДляОтображенияМК.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Центр;
		
		ЭлементВидСпискаЗадачДляОтображенияМК.СписокВыбора.Очистить();
		ЭлементВидСпискаЗадачДляОтображенияМК.СписокВыбора.Добавить(
			"ЗадачиВРаботе", ЭлементАктивныеЗадачиРодитель.Заголовок);
		ЭлементВидСпискаЗадачДляОтображенияМК.СписокВыбора.Добавить(
			"ВсеПроцессыИЗадачи", ЭлементЗадачиИПроцессыРодитель.Заголовок);
		
		// По умолчанию покажем задачи в работе.
		Форма[РеквизитВидСпискаЗадачДляОтображенияМК.Имя] = "ЗадачиВРаботе";
		Параметры.ЭлементАктивныеЗадачи.Видимость = Истина;
		Параметры.ЭлементЗадачиИПроцессы.Видимость = Ложь;
		
		// Новое поле должно быть первым.
		Если ЭлементСтраницаЗадачи.ПодчиненныеЭлементы.Количество() > 0 Тогда
			Элементы.Переместить(
				ЭлементВидСпискаЗадачДляОтображенияМК,
				ЭлементСтраницаЗадачи,
				ЭлементСтраницаЗадачи.ПодчиненныеЭлементы[0]);
		КонецЕсли;
		
		ЭлементВидСпискаЗадачДляОтображенияМК.УстановитьДействие(
			"ПриИзменении", "Подключаемый_ВидСпискаЗадачДляОтображенияМКПриИзменении");
		
	КонецЕсли;
	
	// Список активных задач
	Если Параметры.ЭлементАктивныеЗадачи <> Неопределено Тогда
		
		ЭлементАктивныеЗадачи = Параметры.ЭлементАктивныеЗадачи;
		Если ЭлементАктивныеЗадачи <> Неопределено Тогда
			
			ЭлементАктивныеЗадачи.Шапка = Ложь;
			ЭлементАктивныеЗадачи.Высота = 0;
			
			СписокАктивныхЗадачНомерФлага = ЭлементАктивныеЗадачи.ПодчиненныеЭлементы.Найти("СписокАктивныхЗадачНомерФлага");
			СписокАктивныхЗадачНаименование = ЭлементАктивныеЗадачи.ПодчиненныеЭлементы.Найти("СписокАктивныхЗадачНаименование");
			
			Если СписокАктивныхЗадачНомерФлага <> Неопределено
				И СписокАктивныхЗадачНаименование <> Неопределено Тогда
					// Картинки сделаем в первом столбце
					СписокАктивныхЗадачНомерФлага.Ширина = 1;
					СписокАктивныхЗадачНомерФлага.ОтображатьВШапке = Ложь;
					Элементы.Переместить(СписокАктивныхЗадачНомерФлага, ЭлементАктивныеЗадачи,
						СписокАктивныхЗадачНаименование);
			КонецЕсли;
			
			Если СписокАктивныхЗадачНаименование <> Неопределено Тогда
				СписокАктивныхЗадачНаименование.АвтоВысотаЯчейки = Истина;
			КонецЕсли;
			
			// Скроем пустые флаги.
			Если СписокАктивныхЗадачНомерФлага <> Неопределено Тогда
				МобильныйКлиентАдаптацияИнтерфейсаСервер.УстановитьПолюУсловноеОформлениеСкрытНеВидим(
					Форма.УсловноеОформление, СписокАктивныхЗадачНомерФлага.Имя, 0,, СписокАктивныхЗадачНомерФлага.ПутьКДанным);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дерево процессов и задач.
	Если Параметры.ЭлементЗадачиИПроцессы <> Неопределено Тогда
		
		Параметры.ЭлементЗадачиИПроцессы.Шапка = Ложь;
		ЗадачиИПроцессыПодчиненныеЭлементы = Параметры.ЭлементЗадачиИПроцессы.ПодчиненныеЭлементы;
		
		ДеревоЗадачВажность = ЗадачиИПроцессыПодчиненныеЭлементы.Найти("ДеревоЗадачВажность");
		Если ДеревоЗадачВажность <> Неопределено Тогда
			
			ДеревоЗадачВажность.Ширина = 1;
			
			// Скроем пустую важность.
			МобильныйКлиентАдаптацияИнтерфейсаСервер.УстановитьПолюУсловноеОформлениеСкрытНеВидим(
				Форма.УсловноеОформление, ДеревоЗадачВажность.Имя, 1, , ДеревоЗадачВажность.ПутьКДанным);
			
		КонецЕсли;
		
		ДеревоЗадачСостояниеКартинка = ЗадачиИПроцессыПодчиненныеЭлементы.Найти("ДеревоЗадачСостояниеКартинка");
		Если ДеревоЗадачСостояниеКартинка <> Неопределено Тогда
			ДеревоЗадачСостояниеКартинка.Ширина = 1;
			ДеревоЗадачСостояниеКартинка.Видимость = Ложь;
		КонецЕсли;
		
		// Скроем поля с картинками.
		ДеревоЗадачСостояниеКонтроля = ЗадачиИПроцессыПодчиненныеЭлементы.Найти("ДеревоЗадачСостояниеКонтроля");
		Если ДеревоЗадачСостояниеКонтроля <> Неопределено Тогда
			ДеревоЗадачСостояниеКонтроля.Видимость = Ложь;
		КонецЕсли;
		ДеревоЗадачНомерФлага = ЗадачиИПроцессыПодчиненныеЭлементы.Найти("ДеревоЗадачНомерФлага");
		Если ДеревоЗадачНомерФлага <> Неопределено Тогда
			ДеревоЗадачНомерФлага.Видимость = Ложь;
		КонецЕсли;
		
		// Тип лежит во вложенной группе, поэтому ищем в Элементах.
		ДеревоЗадачТип = Элементы.Найти("ДеревоЗадачТип");
		Если ДеревоЗадачТип <> Неопределено Тогда
			
			ДеревоЗадачТип.Ширина = 1;
			
			// Скроем картинку для задач.
			МобильныйКлиентАдаптацияИнтерфейсаСервер.УстановитьПолюУсловноеОформлениеСкрытНеВидим(
				Форма.УсловноеОформление, ДеревоЗадачТип.Имя, 1, , ДеревоЗадачТип.ПутьКДанным);
			
			// Скроем столбцы, которые не заполняются для процессов.
			МобильныйКлиентАдаптацияИнтерфейсаСервер.УстановитьПолюУсловноеОформлениеСкрытНеВидим(
				Форма.УсловноеОформление,
				"ДеревоЗадачИсполнитель,ДеревоЗадачСрокИсполнения,ДеревоЗадачДатаВыполнения",
				0,,
				ДеревоЗадачТип.ПутьКДанным);
			
		КонецЕсли;
		
		ДеревоЗадачНаименование = Элементы.Найти("ДеревоЗадачНаименование");
		Если ДеревоЗадачНаименование <> Неопределено Тогда
			ДеревоЗадачНаименование.АвтоВысотаЯчейки = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ЭлементЗадачиИПроцессыРезультатВыполнения <> Неопределено Тогда
		Параметры.ЭлементЗадачиИПроцессыРезультатВыполнения.Видимость = Ложь;
	КонецЕсли;
	
#КонецОбласти
	
#Область ОтображениеСтраницИНоваяСтраницаПредметы
	
	Если Параметры.ЭлементГруппаСтраницы <> Неопределено Тогда
		
		// Адаптируем страницы.
		ЭлементГруппаСтраницы = Параметры.ЭлементГруппаСтраницы;
		ЭлементГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСнизу;
		
		Если Параметры.ЭлементСтраницаГлавное <> Неопределено Тогда
			Параметры.ЭлементСтраницаГлавное.Картинка = БиблиотекаКартинок.БизнесПроцесс;
			Параметры.ЭлементСтраницаГлавное.ВертикальнаяПрокруткаПриСжатии = Истина;
		КонецЕсли;
		
		Если Параметры.ЭлементСтраницаЗадачи <> Неопределено Тогда
			Параметры.ЭлементСтраницаЗадачи.Картинка = БиблиотекаКартинок.Задача;
			Параметры.ЭлементСтраницаЗадачи.ВертикальнаяПрокруткаПриСжатии = Истина;
		КонецЕсли;
		
		Если Параметры.ЭлементСтраницаДополнительно <> Неопределено Тогда
			Параметры.ЭлементСтраницаДополнительно.Картинка = БиблиотекаКартинок.ВложеннаяТаблица;
			Параметры.ЭлементСтраницаДополнительно.ВертикальнаяПрокруткаПриСжатии = Истина;
		КонецЕсли;
		
		Если Параметры.ЭлементПредметы <> Неопределено
			И Параметры.ЭлементСтраницаДополнительно <> Неопределено Тогда
			
			ЭлементПредметы = Параметры.ЭлементПредметы;
			
			// Добавим новую страницу (перед Дополнительно) для работы с предметами задачи.
			НоваяСтраница = Форма.Элементы.Добавить("ГруппаПредметыМК", Тип("ГруппаФормы"), ЭлементГруппаСтраницы);
			НоваяСтраница.Вид = ВидГруппыФормы.Страница;
			НоваяСтраница.Заголовок = НСтр("ru='Предметы'");
			НоваяСтраница.ВертикальнаяПрокруткаПриСжатии = Истина;
			НоваяСтраница.Картинка = БиблиотекаКартинок.Документ;
			
			Форма.Элементы.Переместить(НоваяСтраница, ЭлементГруппаСтраницы, Параметры.ЭлементСтраницаДополнительно);
			// Адаптируем предметы.
			//  Перенесем на новую страницу.
			Форма.Элементы.Переместить(ЭлементПредметы, НоваяСтраница);
			
			//  Перенесем кнопки по добавлению новых предметов в командную панель.
			Если Параметры.ЭлементПредметыКомандаДобавить <> Неопределено Тогда
				ЭлементПредметыКомандаДобавить = Параметры.ЭлементПредметыКомандаДобавить;
				ЭлементПредметыКомандаДобавить.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
				ЭлементПредметыКомандаДобавить.Отображение = ОтображениеКнопки.КартинкаИТекст;
				Форма.Элементы.Переместить(ЭлементПредметыКомандаДобавить, ЭлементПредметы.КоманднаяПанель);
				ЭлементПредметы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Верх;
			КонецЕсли;
			
			ПредметыОписание = ЭлементПредметы.ПодчиненныеЭлементы.Найти("ПредметыОписание");
			Если ПредметыОписание <> Неопределено Тогда
				ПредметыОписание.АвтоВысотаЯчейки = Истина;
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
#КонецОбласти
	
#Область ПрочиеНастройки

	АдаптироватьГруппуИнструкции(Параметры.ЭлементГруппаИнструкции);

	ЭлементСтартИЗакрыть = Параметры.ЭлементСтартИЗакрыть;
	Если ЭлементСтартИЗакрыть <> Неопределено Тогда
		ЭлементСтартИЗакрыть.Картинка = БиблиотекаКартинок.СтартБизнесПроцесса;
		ЭлементСтартИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
	ЗаписатьИЗакрыть = Параметры.ЭлементЗаписатьИЗакрыть;
	Если ЗаписатьИЗакрыть <> Неопределено Тогда
		ЗаписатьИЗакрыть.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		// Если кнопка Старт не доступна, то у ЗаписатьИЗакрыть скроем текст.
		Если ЭлементСтартИЗакрыть = Неопределено Или
			ЭлементСтартИЗакрыть.Видимость = Ложь Тогда
			ЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
		КонецЕсли;
	КонецЕсли;
	
	
#КонецОбласти

КонецПроцедуры

// Выполняет адаптацию элементов формы карточки задачи к экрану мобильного устройства.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения  - Адаптируемая форма.
//  Параметры - Структура - Параметры адаптации, см. НовыеПараметрыАдаптацииФормыКарточкиЗадачи
//
Процедура АдаптироватьЭлементыФормыКарточкиЗадачи(Форма, Параметры) Экспорт
	
	Форма.СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	Форма.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	ДобавитьРеквизитФормыСтруктура(Форма, "ПараметрыМобильныйКлиент");
	
	Элементы = Форма.Элементы;
	Форма.СворачиваниеЭлементовПоВажности =  СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	
#Область ПоляПереключенияВкладок
	
	Если Параметры.ЭлементРасположениеСтраницРодитель = Неопределено Тогда
		Если Параметры.ЭлементРасположениеСтраниц <> Неопределено Тогда
			Параметры.ЭлементРасположениеСтраницРодитель = Параметры.ЭлементРасположениеСтраниц.Родитель;
		Иначе
			Параметры.ЭлементРасположениеСтраницРодитель = Форма;
		КонецЕсли;
	КонецЕсли;
	
	ГруппаПереключениеСтраниц = Элементы.Добавить("ГруппаПереключениеСтраницМК", Тип("ГруппаФормы"),
		Параметры.ЭлементРасположениеСтраницРодитель);
	Если Параметры.ЭлементРасположениеСтраниц <> Неопределено Тогда
		Элементы.Переместить(
			ГруппаПереключениеСтраниц,
			Параметры.ЭлементРасположениеСтраницРодитель,
			Параметры.ЭлементРасположениеСтраниц);
	КонецЕсли;
	
	ГруппаПереключениеСтраниц.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаПереключениеСтраниц.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаПереключениеСтраниц.ОтображатьЗаголовок = Ложь;
	ГруппаПереключениеСтраниц.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаПереключениеСтраниц.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Центр;
	ГруппаПереключениеСтраниц.РастягиватьПоГоризонтали = Истина;
	
	КомандаСтраницаВлево  = Форма.Команды.Добавить("ПереключитьСтраницуВлевоМК");
	КомандаСтраницаВправо = Форма.Команды.Добавить("ПереключитьСтраницуВправоМК");
	КомандаСтраницаВлево.Действие  = "Подключаемый_ВыполнитьКомандуМК";
	КомандаСтраницаВправо.Действие = "Подключаемый_ВыполнитьКомандуМК";
	
	СтраницаВлево  = Элементы.Добавить("ПереключитьСтраницуВлевоМК", Тип("КнопкаФормы"), ГруппаПереключениеСтраниц);
	СтраницаВлево.ГоризонтальноеПоложениеВГруппе   = ГоризонтальноеПоложениеЭлемента.Лево;
	СтраницаВлево.Ширина  = 9;
	СтраницаВлево.ИмяКоманды   = "ПереключитьСтраницуВлевоМК";
	
	ТекущаяВкладка = Элементы.Добавить("ТекущаяСтраницаМК", Тип("ДекорацияФормы"), ГруппаПереключениеСтраниц);
	ТекущаяВкладка.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Центр;
	ТекущаяВкладка.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
	ТекущаяВкладка.Вид = ВидДекорацииФормы.Надпись;
	ТекущаяВкладка.Ширина  = 9;
	
	ПраваяВкладка  = Элементы.Добавить("ПереключитьСтраницуВправоМК", Тип("КнопкаФормы"), ГруппаПереключениеСтраниц);
	ПраваяВкладка.ГоризонтальноеПоложениеВГруппе  = ГоризонтальноеПоложениеЭлемента.Право;
	ПраваяВкладка.Ширина = 9;
	ПраваяВкладка.ИмяКоманды  = "ПереключитьСтраницуВправоМК";
	
#КонецОбласти
	
#Область СтраницыСПролистыванием
	
	Страницы = Элементы.Добавить("СтраницыМК", Тип("ГруппаФормы"), Параметры.ЭлементРасположениеСтраницРодитель);
	Если Параметры.ЭлементРасположениеСтраниц <> Неопределено Тогда
		Элементы.Переместить(
			Страницы,
			Параметры.ЭлементРасположениеСтраницРодитель,
			Параметры.ЭлементРасположениеСтраниц);
	КонецЕсли;
	
	Страницы.Вид = ВидГруппыФормы.Страницы;
	Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Пролистывание;
	Страницы.РастягиватьПоГоризонтали = Истина;
	Страницы.УстановитьДействие("ПриСменеСтраницы", "Подключаемый_ПриСменеСтраницыМК");
	
	Если Параметры.СтраницыНомерТекущейСтраницы = Неопределено Тогда
		Параметры.СтраницыНомерТекущейСтраницы = 0;
	КонецЕсли;
	Для Индекс = 0 По Параметры.СтраницыНазвания.Количество() - 1 Цикл
		
		ИмяСтраницы = СтрШаблон("Страница%1МК", Индекс);
		НоваяСтраница = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Страницы);
		НоваяСтраница.Вид = ВидГруппыФормы.Страница;
		НоваяСтраница.Заголовок = Параметры.СтраницыНазвания[Индекс];
		НоваяСтраница.ВертикальнаяПрокруткаПриСжатии = Истина;
		
		// Переместим элементы на страницу
		ЭлементыСтраницы = Параметры.СтраницыЭлементы[Индекс];
		Для Каждого НовыйЭлемент Из ЭлементыСтраницы Цикл
			Элементы.Переместить(
				НовыйЭлемент,
				НоваяСтраница);
		КонецЦикла;
		
		Если Индекс = Параметры.СтраницыНомерТекущейСтраницы Тогда
			Страницы.ТекущаяСтраница = НоваяСтраница;
		КонецЕсли;
	КонецЦикла;
	
	Форма.ПараметрыМобильныйКлиент.Вставить("ЭлементСтраницыИмя", Страницы.Имя);
	
	МобильныйКлиентАдаптацияИнтерфейсаКлиентСервер.ОбновитьСтраницыИПереключатели(Форма);
	
#КонецОбласти
	
#Область ОбластьВыполненияЗадачи
	
	ГруппаОбластьВыполнения = Параметры.ЭлементГруппаОбластьВыполнения;
	Если ГруппаОбластьВыполнения <> Неопределено Тогда
		
		ОтображатьКомандыВыполненияБезГруппировки = Ложь;
		Если Параметры.ОтображатьКомандыВыполненияБезГруппировки <> Неопределено Тогда
			ОтображатьКомандыВыполненияБезГруппировки = Параметры.ОтображатьКомандыВыполненияБезГруппировки;
		КонецЕсли;
		
		Если Параметры.ЭлементРасположениеСтраниц <> Неопределено Тогда
			Элементы.Переместить(
				ГруппаОбластьВыполнения,
				Параметры.ЭлементРасположениеСтраницРодитель,
				Параметры.ЭлементРасположениеСтраниц);
		КонецЕсли;
		
		ГруппаОбластьВыполнения.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаОбластьВыполнения.Отображение = ОтображениеОбычнойГруппы.Нет;
		
		КомандыВыполнения = Новый Массив;
		Если Параметры.ЭлементГруппаКомандыВыполнения <> Неопределено Тогда
			
			ПодчиненныеЭлементы = Параметры.ЭлементГруппаКомандыВыполнения.ПодчиненныеЭлементы;
			
			Для Каждого ПодчиненныйЭлемент Из ПодчиненныеЭлементы Цикл
				
				КомандыВыполнения.Добавить(ПодчиненныйЭлемент);
				
			КонецЦикла;
			//Параметры.ЭлементГруппаКомандыВыполнения.Видимость = Ложь;
			
		КонецЕсли;
		
		АдаптироватьОбластьВыполненияЗадачи(ГруппаОбластьВыполнения, ОтображатьКомандыВыполненияБезГруппировки, КомандыВыполнения, Форма);
		
	КонецЕсли;
	
#КонецОбласти
	
	ДеревоПриложений = Параметры.ЭлементПредметы;
	Если ДеревоПриложений <> Неопределено Тогда
		
		УстановитьСвойстваПоляДереваПредметов(ДеревоПриложений);
		
		// Переместим кнопки добавления предмета в компандную панель.
		ЭлементыДляПереноса = Новый Массив;
		ЭлементДобавленияПредмета = Форма.Элементы.Найти("ДеревоПриложенийКонтекстноеМенюДобавитьПредмет");
		Если ЭлементДобавленияПредмета <> Неопределено Тогда
			ЭлементыДляПереноса.Добавить(ЭлементДобавленияПредмета);
		КонецЕсли;
		ЭлементДобавленияФайла = Форма.Элементы.Найти("ДеревоПриложенийКонтекстноеМенюДобавитьФайл");
		Если ЭлементДобавленияФайла <> Неопределено Тогда
			ЭлементыДляПереноса.Добавить(ЭлементДобавленияФайла);
		КонецЕсли;
		
		Если ЭлементыДляПереноса.Количество() > 0 Тогда
			
			Для Каждого ЭлементДляПереноса Из ЭлементыДляПереноса Цикл
				
				ЭлементДляПереноса.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
				ЭлементДляПереноса.Отображение = ОтображениеКнопки.КартинкаИТекст;
				
				Элементы.Переместить(
					ЭлементДляПереноса,
					ДеревоПриложений.КоманднаяПанель);
				
			КонецЦикла;
			
			ДеревоПриложений.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Верх;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Исполнители = Параметры.ЭлементИсполнители;
	Если Исполнители <> Неопределено Тогда
		
		НоваяВысотаТаблицы = 4;
		Исполнители.ВысотаВСтрокахТаблицы = 1;
		Исполнители.МаксимальнаяВысотаВСтрокахТаблицы = НоваяВысотаТаблицы;
		Исполнители.Высота = 1;
		Исполнители.МаксимальнаяВысота = НоваяВысотаТаблицы;
		Исполнители.ВариантУправленияВысотой = ВариантУправленияВысотойТаблицы.ПоСодержимому;
		Исполнители.АвтоМаксимальнаяВысотаВСтрокахТаблицы = Ложь;
		Исполнители.АвтоМаксимальнаяВысота = Ложь;
		Исполнители.Шапка = Ложь;
		
		Если Параметры.ЭлементИсполнителиЗаголовок <> Неопределено Тогда
			Исполнители.Заголовок = Параметры.ЭлементИсполнителиЗаголовок;
			Исполнители.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		КонецЕсли;
		
	КонецЕсли;
	
	Подзадачи = Параметры.ЭлементПодзадачи;
	Если Подзадачи <> Неопределено Тогда
		
		// Уберем шапку у подзадач, без нее понятны поля.
		Подзадачи.Шапка = Ложь;
		
		ПодзадачиГруппаДанные = Подзадачи.ПодчиненныеЭлементы.Найти("ПодзадачиГруппаДанные");
		Если ПодзадачиГруппаДанные <> Неопределено Тогда
			
			ПодзадачиГруппаДанные.Группировка = ГруппировкаКолонок.Вертикальная;
			
			ПодзадачиЗадача = Подзадачи.ПодчиненныеЭлементы.Найти("ПодзадачиЗадача");
			Если ПодзадачиЗадача <> Неопределено Тогда
				ПодзадачиЗадача.Ширина = 0;
				ПодзадачиЗадача.АвтоВысотаЯчейки = Истина;
			КонецЕсли;
			
			// Поставим исполнителя перед сроком.
			ПодзадачиСрок = Подзадачи.ПодчиненныеЭлементы.Найти("ПодзадачиСрок");
			ПодзадачиУчастник = Подзадачи.ПодчиненныеЭлементы.Найти("ПодзадачиУчастник");
			Если ПодзадачиСрок <> Неопределено И ПодзадачиУчастник <> Неопределено Тогда
				Элементы.Переместить(
					ПодзадачиУчастник,
					ПодзадачиУчастник.Родитель,
					ПодзадачиСрок);
				ПодзадачиСрок.Ширина = 0;
				ПодзадачиУчастник.Ширина = 0;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	АдаптироватьГруппуИнструкции(Параметры.ЭлементГруппаИнструкции);

	
#Область ПрочиеНастройки
	
	ЗаписатьИЗакрыть = Параметры.ЭлементЗаписатьИЗакрыть;
	Если ЗаписатьИЗакрыть <> Неопределено Тогда
		ЗаписатьИЗакрыть.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		ЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
	ПредставлениеHTML = Параметры.ЭлементПредставлениеHTML;
	Если ПредставлениеHTML <> Неопределено Тогда
		МобильныйКлиентКлиентСервер.АдаптироватьHtmlПодЭкранПриНеобходимости(ПредставлениеHTML);
	КонецЕсли;
	
#КонецОбласти

	
КонецПроцедуры

// 
//
Процедура АдаптироватьОбластьВыполненияЗадачи(ГруппаОбластьВыполнения, Знач ОтображатьКомандыВыполненияБезГруппировки, Знач КомандыВыполнения, Знач Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	// Групп может быть несколько для карточки задачи Рассмотрения.
	Индекс = 0;
	Пока Истина Цикл
		ИмяГруппыКоманд = СтрШаблон("ГруппаВыполнениеЗадачиКомандыМК%1", Формат(Индекс, "ЧГ="));
		Проверка = Форма.Элементы.Найти(ИмяГруппыКоманд);
		Если Проверка = Неопределено Тогда
			Прервать;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ИмяКоманднойПанели = СтрШаблон("ГруппаВыполнениеЗадачиКомандыМК%1", Формат(Индекс, "ЧГ="));
	ГруппаКоманднаяПанель = Элементы.Добавить(ИмяКоманднойПанели, Тип("ГруппаФормы"), ГруппаОбластьВыполнения);
	ГруппаКоманднаяПанель.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Центр;
	ГруппаКоманднаяПанель.Вид = ВидГруппыФормы.КоманднаяПанель;
	ГруппаКоманднаяПанель.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
	
	Если ОтображатьКомандыВыполненияБезГруппировки Тогда
		ГруппаКонтейнерКомандВыполнения = ГруппаКоманднаяПанель;
	Иначе
		ИмяКонтейнерКомандВыполнения = СтрШаблон("ГруппаВыполнениеЗадачиПодменюМК%1", Формат(Индекс, "ЧГ="));
		ГруппаКонтейнерКомандВыполнения = Элементы.Добавить(ИмяКонтейнерКомандВыполнения, Тип("ГруппаФормы"), ГруппаКоманднаяПанель);
		ГруппаКонтейнерКомандВыполнения.Вид = ВидГруппыФормы.Подменю;
		ГруппаКонтейнерКомандВыполнения.Картинка = БиблиотекаКартинок.ЗадачаНейтральноеВыполнение;
	КонецЕсли;
	
	Для Каждого Команда Из КомандыВыполнения Цикл
		Команда.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Элементы.Переместить(Команда, ГруппаКонтейнерКомандВыполнения);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает пустую структуру параметров, необходимых для адаптации формы задачи под мобильный клиент.
//
// Возвращаемое значение:
//  Структура
//
Функция НовыеПараметрыАдаптацииФормыКарточкиЗадачи() Экспорт
	
	Результат = Новый Структура();
	
	// 2 массива для описания страниц с основным содержанием формы:
	// названия страниц и их содержимое.
	// Должны иметь одинаковое количество элементов.
	Результат.Вставить("СтраницыНазвания", Новый Массив);
	Результат.Вставить("СтраницыЭлементы", Новый Массив);
	// Индекс страницы, показываемой пользователю по умолчанию.
	Результат.Вставить("СтраницыНомерТекущейСтраницы");
	
	// Параметы для разных элементов, находящихся на формах,
	// с которыми производятся одинаковые действия на всех формах.
	// Элемент формы, перед которым будут созданы новые элементы управления.
	Результат.Вставить("ЭлементРасположениеСтраниц");
	// Элемент формы, внутри которого будут созданы новые элементы управления.
	Результат.Вставить("ЭлементРасположениеСтраницРодитель");
	// Кнопка "Записать и закрыть"
	Результат.Вставить("ЭлементЗаписатьИЗакрыть");
	// Элемент с HTML описанием задачи.
	Результат.Вставить("ЭлементПредставлениеHTML");
	// ТИаблица предметов задачи.
	Результат.Вставить("ЭлементПредметы");
	// Таблица исполнителей задачи.
	Результат.Вставить("ЭлементИсполнители");
	// Заголовок декорации для сворачивания таблицы исполнителей
	Результат.Вставить("ЭлементИсполнителиЗаголовок");
	// Таблица подзадач.
	Результат.Вставить("ЭлементПодзадачи");
	// Группа для отображения инструкций.
	Результат.Вставить("ЭлементГруппаИнструкции");
	// Группа, содержащая элементы, относящиеся к работе с результатом задачи: комментарий, цикл и т.п.
	Результат.Вставить("ЭлементГруппаОбластьВыполнения");
	// Группа, содержащая кнопки для завершения работы над задачей.
	Результат.Вставить("ЭлементГруппаКомандыВыполнения");
	// Если Истина, команды будут выводиться без группировки в подменю. Одновременно нужно скрыть поле Комментарий.
	Результат.Вставить("ОтображатьКомандыВыполненияБезГруппировки", Ложь);
	// Группа страниц формы, которую необходимо преобразовать в разделы.
	Результат.Вставить("ЭлементСтраницыДляРазделов");
	// Кнопка "Записать и закрыть"
	Результат.Вставить("ЭлементСтартоватьИЗакрыть");
	
	Возврат Результат;
	
КонецФункции

// Возвращает пустую структуру параметров, необходимых для адаптации формы процесса под мобильный клиент.
//
// Возвращаемое значение:
//  Структура
//
Функция НовыеПараметрыАдаптацииФормыКарточкиПроцесса() Экспорт
	
	Результат = Новый Структура();
	
	// Параметы для разных элементов, находящихся на формах,
	// с которыми производятся одинаковые действия на всех формах.
	
	// Элементы основных сведений о процессе.
	Результат.Вставить("ЭлементНаименование");
	Результат.Вставить("ЭлементВажность");
	Результат.Вставить("ЭлементОписание");
	Результат.Вставить("ЭлементГруппаИсполнители");
	// Таблица исполнителей процесса.
	Результат.Вставить("ЭлементИсполнители");
	
	// Поля в таблице исполнителей.
	Результат.Вставить("ЭлементИсполнителиШаг");
	Результат.Вставить("ЭлементИсполнителиИсполнитель");
	// Сведения о сроке обработки резултата.
	Результат.Вставить("ЭлементСрокОбработкиРезультатов");
	
	// Элементы по страницам, отображаемым на карточке.
	Результат.Вставить("ЭлементГруппаСтраницы");
	Результат.Вставить("ЭлементСтраницаГлавное");
	Результат.Вставить("ЭлементСтраницаДополнительно");
	Результат.Вставить("ЭлементСтраницаЗадачи");
	
	// таблица со списком предметов.
	Результат.Вставить("ЭлементПредметы");
	// Команда добавления нового предмета.
	Результат.Вставить("ЭлементПредметыКомандаДобавить");
	
	// Элементы со страницы с задачами.
	// Таблица с кативными задачами.
	Результат.Вставить("ЭлементАктивныеЗадачи");
	// Дерево задач и процессов.
	Результат.Вставить("ЭлементЗадачиИПроцессы");
	// Поле для вывода сведений о результате выпонления выделенной задачи.
	Результат.Вставить("ЭлементЗадачиИПроцессыРезультатВыполнения");
	
	// Группа с инструкциями
	Результат.Вставить("ЭлементГруппаИнструкции");
	// Кнопка "Записать и закрыть"
	Результат.Вставить("ЭлементЗаписатьИЗакрыть");
	// Кнопка "Старт и закрыть"
	Результат.Вставить("ЭлементСтартИЗакрыть");
	
	Возврат Результат;
	
КонецФункции

// Программно добавляет элементы для управления видимостью таблицей на форме.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Адаптируемая форма.
//  ТаблицаФормы - ТаблицаФормы - Элемент формы, видимость которого учитывается.
//  ТекстДекорации - ТаблицаФормы - Элемент формы, видимость которого учитывается.
//  ИмяСобытияНажатияДекорации - Строка - Имя функции для события Нажатие.
// 
// Возвращаемое значение:
//  Строка - Имя созданного элемена формы.
Функция ДобавитьЭлементыДляСкрытияТаблицыВФормеЗадачи(Форма, ТаблицаФормы, ТекстДекорации,
	ИмяСобытияНажатияДекорации) Экспорт
	
	ОсноваИмениЭлементов = СтрЗаменить(ТекстДекорации, " ", "");
	ИмяЭлементаКоманднойПанели = СтрШаблон("ГруппаМКСкрытиеТаблицы%1", ОсноваИмениЭлементов);
	ИмяЭлементаДекорации = СтрШаблон("ДекорацияМКСкрытиеТаблицы%1", ОсноваИмениЭлементов);
	
	КоманднаяПанельМК =
		Форма.Элементы.Добавить(ИмяЭлементаКоманднойПанели, Тип("ГруппаФормы"), ТаблицаФормы.Родитель);
	КоманднаяПанельМК.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	КоманднаяПанельМК.ОтображатьЗаголовок = Ложь;
	
	Форма.Элементы.Переместить(
		КоманднаяПанельМК,
		ТаблицаФормы.Родитель,
		ТаблицаФормы);
	
	ДекорацияТекст = Форма.Элементы.Добавить(ИмяЭлементаДекорации, Тип("ДекорацияФормы"), КоманднаяПанельМК);
	ДекорацияТекст.Вид = ВидДекорацииФормы.Надпись;
	ДекорацияТекст.Заголовок = ТекстДекорации;
	ДекорацияТекст.ЦветТекста = WebЦвета.ЦветМорскойВолны;
	ДекорацияТекст.Подсказка = ТекстДекорации;
	
	Если ЗначениеЗаполнено(ИмяСобытияНажатияДекорации) Тогда
		ДекорацияТекст.Гиперссылка = Истина;
		ДекорацияТекст.УстановитьДействие("Нажатие", ИмяСобытияНажатияДекорации);
	КонецЕсли;
	
	Возврат ИмяЭлементаДекорации;
	
КонецФункции

// Выполняет улучшение отображения кнопок выполнения в карточке задачи.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения  - Адаптируемая форма
//  ГруппаРазмещенияКнопок  - ГруппаФормы - Группа, в которой нужно разместить кнопки.
//  Кнопки  - Массив - Кнопки для оформления, см. СведенияОКнопкеВыполненияЗадачи.
//
Процедура АдаптироватьКнопкиВыполненияВФормеЗадачи(Форма, ГруппаРазмещенияКнопок, Кнопки) Экспорт
	
	ИмяГруппыКоманд = "";
	Индекс = 0;
	Пока Истина Цикл
		ИмяГруппыКоманд = СтрШаблон("ГруппаКомандыВыполненияМК%1", Формат(Индекс, "ЧГ="));
		Проверка = Форма.Элементы.Найти(ИмяГруппыКоманд);
		Если Проверка = Неопределено Тогда
			Прервать;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ГруппаКомандыВыполненияМК =
		Форма.Элементы.Добавить(ИмяГруппыКоманд, Тип("ГруппаФормы"), ГруппаРазмещенияКнопок);
	ГруппаКомандыВыполненияМК.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
	ГруппаКомандыВыполненияМК.РастягиватьПоГоризонтали = Истина;
	
	Если ЗначениеЗаполнено(Кнопки) Тогда
		
		Для Каждого Кнопка Из Кнопки Цикл
			
			Кнопка.Элемент.Картинка = Кнопка.Картинка;
			Кнопка.Элемент.Отображение = ОтображениеКнопки.КартинкаИТекст;
			Кнопка.Элемент.Высота = 1;
			
			Форма.Элементы.Переместить(Кнопка.Элемент, ГруппаКомандыВыполненияМК);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру со сведениями о кнопке выполнения задачи.
//
// Параметры:
//  Элемент  - КнопкаФормы - Кнопка выполнения задачи.
//  Картинка  - Картинка - Картинка, соответствующая кнопке.
//
// Возвращаемое значение:
//   Структура   - Сведения о кнопке выполнения задачи.
//
Функция СведенияОКнопкеВыполненияЗадачи(Элемент, Картинка) Экспорт
	
	Возврат Новый Структура("Элемент,Картинка", Элемент, Картинка);
	
КонецФункции

// Устанавливает скрытие поля, если условие не выполнено.
//
// Параметры:
//  УсловноеОформлениеСписка - УсловноеОформлениеКомпоновкиДанных - условное оформление динамического списка.
//  ИменаПолей - Строка - имена полей через запятую, которые необходимо скрыть.
//  ЗначениеУсловия - Произвольный - значение с чем сравнивается поле отбора.
//  Условие - ВидСравненияКомпоновкиДанных - вид сравнения поля со значением.
//  ИмяПоляУсловия - Строка - имя поля, по которому устанавливается условие.
//
Процедура УстановитьПолюУсловноеОформлениеСкрытНеВидим(УсловноеОформлениеСписка, ИменаПолей, 
		ЗначениеУсловия = Неопределено, Условие = Неопределено, ИмяПоляУсловия = Неопределено) Экспорт
	
	//ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПредставлениеЭлемента = СтрШаблон(НСтр("ru = 'Скрытие ячейки ""%1"" если поле пустое'"), ИменаПолей);
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформлениеСписка, ПредставлениеЭлемента);

	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Видимость");
	ЭлементЦветаОформления.Использование = Истина;
	ЭлементЦветаОформления.Значение      = Ложь;

	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Отображать");
	ЭлементЦветаОформления.Использование = Истина;
	ЭлементЦветаОформления.Значение      = Ложь;

	Если СтрНайти(ИменаПолей, ",") = 0 Тогда
		ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных(ИменаПолей);
	Иначе
		МассивИменаПолей = СтрРазделить(ИменаПолей, ",");
		Для Каждого ИмяПоля Из МассивИменаПолей Цикл
			ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЦикла;
		ИменаПолей = Неопределено;
	КонецЕсли;

	ПолеУсловия = ?(ИмяПоляУсловия = Неопределено, ИменаПолей, ИмяПоляУсловия);
	
	Если Условие = Неопределено Тогда

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУсловногоОформления.Отбор, 
				ПолеУсловия, ВидСравненияКомпоновкиДанных.Равно, ЗначениеУсловия, "", Истина);

	ИначеЕсли Условие = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУсловногоОформления.Отбор, 
				ПолеУсловия, ВидСравненияКомпоновкиДанных.НеЗаполнено, , "", Истина);

	ИначеЕсли Условие = ВидСравненияКомпоновкиДанных.Равно Тогда

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУсловногоОформления.Отбор, 
				ПолеУсловия, ВидСравненияКомпоновкиДанных.Равно, ЗначениеУсловия, , Истина);

	КонецЕсли;

	ЭлементУсловногоОформления.Использование  = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьРеквизитФормыСтруктура(Форма, ИмяРеквизита)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ИмяРеквизита) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов));
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Форма[ИмяРеквизита] = Новый Структура;
	
КонецПроцедуры

Процедура УстановитьСвойстваПоляДереваПредметов(Элемент)
	
	ТипЭлемента = ТипЗнч(Элемент);
	Если ТипЭлемента = Тип("ПолеФормы")
		И Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
		
		Элемент.АвтоВысотаЯчейки = Истина;
		Элемент.АвтоМаксимальнаяВысота = Ложь;
		Элемент.МаксимальнаяВысота = 2;
		
	ИначеЕсли ТипЭлемента = Тип("ГруппаФормы")
		Или ТипЭлемента = Тип("ТаблицаФормы") Тогда
		Для Каждого ПодчиненныйЭлемент Из Элемент.ПодчиненныеЭлементы Цикл
			УстановитьСвойстваПоляДереваПредметов(ПодчиненныйЭлемент);
		КонецЦикла;
	КонецЕсли;
	
		
	
КонецПроцедуры

Процедура АдаптироватьГруппуИнструкции(Знач Инструкции)
	
	Если Инструкции <> Неопределено Тогда
		Если Инструкции.Видимость Тогда
			Инструкции.Поведение = ПоведениеОбычнойГруппы.Всплывающая;
			Инструкции.Заголовок = НСтр("ru='Инструкции'");
			Инструкции.ОтображатьЗаголовок = Истина;
			Инструкции.Скрыть();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
