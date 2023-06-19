
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ФайлПисьма") Тогда
		
		ФайлВложенногоПисьма = Параметры.ФайлПисьма;
		
		ДвоичныеДанные = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(ФайлВложенногоПисьма);
		
	ИначеЕсли Параметры.Свойство("ДвоичныеДанные") Тогда	
		
		ДвоичныеДанные = Параметры.ДвоичныеДанные;
		
	Иначе	
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	ПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	ПочтовоеСообщение.УстановитьИсходныеДанные(ДвоичныеДанные);
	
	Сообщение = Почта.ПолучитьСтруктуруПочтовогоСообщенияИзПисьма(ПочтовоеСообщение);
	
	Тема = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Сообщение.Тема);
	Важность = Сообщение.Важность;
	
	ДатаПолучения = Неопределено;
	
	СтрокаДаты = ПочтовоеСообщение.ПолучитьПолеЗаголовка("X-1C-Date", "Строка");
	Попытка 
		ДатаПолучения = Дата(СтрокаДаты);
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ДатаПолучения) Тогда
		Элементы.ДатаПолучения.Видимость = Истина;
	Иначе	
		Элементы.ДатаПолучения.Видимость = Ложь;
	КонецЕсли;	
	
	ОтправительАдресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(
		Сообщение.Отправитель.Адрес,Сообщение.Отправитель.ОтображаемоеИмя);
		
	ДобавитьПолучателя(
		НСтр("ru = 'От:'"),
		ОтправительАдресат);
		
	ЗаполнитьИнтернетПочтовыеАдреса(Перечисления.ТипыАдресатов.Кому, Сообщение.Получатели);
	ЗаполнитьИнтернетПочтовыеАдреса(Перечисления.ТипыАдресатов.Кому, Сообщение.Копии);
	
	СтруктураТекста = ВстроеннаяПочтаСервер.ПолучитьСтруктуруТекстаИзСтруктурыПочтовогоСообщения(Сообщение);
	ТипТекста = СтруктураТекста.ТипТекста;
	
	ПоказыватьКартинкиВТелеПисьма = Ложь;
	ТекстПисьмаНРег = "";
	Если СтруктураТекста.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		ПоказыватьКартинкиВТелеПисьма = Истина;
		ТекстПисьмаНРег = НРег(СтруктураТекста.ТекстHTML);
	КонецЕсли;	
	
	//Сообщение.Вложения
	Для Каждого ВложениеСтрока Из Сообщение.Вложения Цикл
		
		Если ПоказыватьКартинкиВТелеПисьма Тогда
			
			Если ЗначениеЗаполнено(ВложениеСтрока.Идентификатор) 
				И СтрНайти(ТекстПисьмаНРег, НРег(ВложениеСтрока.Идентификатор)) <> 0 Тогда
				Вложение = ВложенияКартинки.Добавить();
			Иначе	
				Вложение = Вложения.Добавить();
			КонецЕсли;	
			
		Иначе	
			Вложение = Вложения.Добавить();
		КонецЕсли;	
		
		Вложение.ИмяФайла =
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ВложениеСтрока.Имя, "_");
			
		Если НРег(ВложениеСтрока.ТипСодержимого) = НРег("message/rfc822") Тогда
			Вложение.ЭтоВложенноеПисьмо = Истина;
		КонецЕсли;	
			
		Вложение.Представление = Вложение.ИмяФайла;	
		Вложение.Идентификатор = ВложениеСтрока.Идентификатор;
			
		Вложение.Адрес = ПоместитьВоВременноеХранилище(ВложениеСтрока.Данные, УникальныйИдентификатор);
		Вложение.Размер = ВложениеСтрока.Данные.Размер();
		
		ИмяФайлаИнфо = РаботаСоСтроками.РазложитьИмяФайла(Вложение.ИмяФайла);
		Вложение.Расширение = ИмяФайлаИнфо.Расширение;
		Вложение.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ИмяФайлаИнфо.Расширение);
		Вложение.РазмерПредставление = РаботаСоСтроками.ПолучитьРазмерСтрокой(Вложение.Размер);
			
	КонецЦикла;	
	
	Если СтруктураТекста.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		
		ТекстПисьма = СтруктураТекста.ТекстHTML;
		
		ВстроеннаяПочтаСервер.ДобавитьНеобходимыеТэгиHTML(ТекстПисьма);
		
		// тут вставка картинок
		ВставитьКартинкиВТекстHTML(
			ТекстПисьма,
			УникальныйИдентификатор);
		
	Иначе
		
		ТекстПисьма = РаботаС_HTML.ПолучитьHTMLИзТекста(СтруктураТекста.Текст);
		
	КонецЕсли;
	
	ИдентификаторПроектаСтрока = ВстроеннаяПочтаСервер.ПолучитьЗначениеПоляИзЗаголовкаПисьма(Сообщение.Заголовок, "X-1C-Project-ID");
	Если ЗначениеЗаполнено(ИдентификаторПроектаСтрока) Тогда
		
		ИдентификаторПроекта = Неопределено;
		
		Попытка
			ИдентификаторПроекта = Новый УникальныйИдентификатор(ИдентификаторПроектаСтрока);
		Исключение
			// может придти некорректный Ид проекта
		КонецПопытки;
		
		Если ЗначениеЗаполнено(ИдентификаторПроекта) Тогда
			ПроектПисьма = Справочники.Проекты.ПолучитьСсылку(ИдентификаторПроекта);
			Если ЗначениеЗаполнено(ПроектПисьма) 
				И ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ПроектПисьма).Чтение Тогда 
				Проект = ПроектПисьма;
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнтернетПочтовыеАдреса(ТипАдреса, Адреса)
	
	Для каждого Адрес Из Адреса Цикл
		
		Если Не РаботаСоСтроками.ЭтоАдресЭлектроннойПочты(Адрес.Адрес) Тогда
			Продолжить;
		КонецЕсли;
		
		Адресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(Адрес.Адрес, Адрес.ОтображаемоеИмя);
		
		ДобавитьПолучателя(ТипАдреса, Адресат);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПолучателя(ТипАдреса, ПочтовыйАдресат)
	
	НоваяСтрока = Получатели.Добавить();
	ДанныеПолучателя = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(ПочтовыйАдресат);
	НоваяСтрока.Представление = ДанныеПолучателя.Представление;
	НоваяСтрока.Контакт = ДанныеПолучателя.Контакт;
	НоваяСтрока.Адресат = ПочтовыйАдресат;
 	НоваяСтрока.ТипАдреса = ТипАдреса;
	НоваяСтрока.Адрес = ПочтовыйАдресат.Адрес;
	НоваяСтрока.Внешний = ДанныеПолучателя.Внешний;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаДанных = Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
	Если ЗначениеЗаполнено(СтрокаДанных.Контакт) Тогда
		ПоказатьЗначение(, СтрокаДанных.Контакт);
	КонецЕсли;
	
КонецПроцедуры

// При работе с веб сервером вставляет картинки письма в тело HTML,
// иначе помещает их во временное хранилище и заменяет ссылки на временное хранилище.
//
// Параметры
//  ТекстHTML - html текст - тела письма - входной и выходной параметр (туда же и пишутся изменения)
//  Письмо - ссылка на письмо (вх или исх)
//  УникальныйИдентификаторФормы - идентификатор формы
//  ИдентификаторыКартинокИсходящегоПисьма - список значений, в нем структуры "ИсточникФайла, НавигационнаяСсылка"
//      ИсточникФайла - это "id" в теге <img src=id....
//		НавигационнаяСсылка - навигационная ссылка на картинку у нас во временном хранилище
//
Процедура ВставитьКартинкиВТекстHTML(
	ТекстHTML,
	УникальныйИдентификаторФормы,
	ИдентификаторыКартинокИсходящегоПисьма = Неопределено)
	
	Для каждого ФайлПисьма Из ВложенияКартинки Цикл
		
		ВставлятьКакBase64 = Истина;
		
		ИсточникФайла = ФайлПисьма.Идентификатор;
		
		Если СтрЧислоВхождений(ТекстHTML, ИсточникФайла) > 0 Тогда
			
			Если ВставлятьКакBase64 Тогда
				
				ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ФайлПисьма.Адрес);
				
				Расширение = ФайлПисьма.Расширение;
				
				Если ПустаяСтрока(Расширение) Тогда
					Картинка = Новый Картинка(ДвоичныеДанныеФайла);
					Расширение = Строка(Картинка.Формат());
				КонецЕсли;
				
				СтрокаИсточника = "data:image/" + Расширение + ";base64," + Base64Строка(ДвоичныеДанныеФайла);
				ТекстHTML = СтрЗаменить(ТекстHTML, "cid:" + ИсточникФайла, СтрокаИсточника);
				ТекстHTML = СтрЗаменить(ТекстHTML, "CID:" + ИсточникФайла, СтрокаИсточника);
				Если СтрДлина(ИсточникФайла) > 18 Тогда
					ТекстHTML = СтрЗаменить(ТекстHTML, ИсточникФайла, СтрокаИсточника);
				КонецЕсли;	
				
			Иначе // тонкий клиент
				
				НавигационнаяСсылкаИнформационнойБазы = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
				
				Попытка
					НавигационнаяССылка = ФайлПисьма.Адрес;
				Исключение
					Инфо = ИнформацияОбОшибке();
					ЗаписьЖурналаРегистрации(
						НСтр("ru = 'Ошибка вставки картинок в HTML'", Метаданные.ОсновнойЯзык.КодЯзыка),
						УровеньЖурналаРегистрации.Ошибка,,
						,
						ПодробноеПредставлениеОшибки(Инфо));
					Продолжить;
				КонецПопытки;	
				
				АбсолютнаяСсылкаНаКартинку = НавигационнаяСсылкаИнформационнойБазы + "/" + НавигационнаяССылка;
				
				ТекстHTML = СтрЗаменить(ТекстHTML, "http:cid:" + ИсточникФайла, АбсолютнаяСсылкаНаКартинку); // коррекция ошибочного html
				ТекстHTML = СтрЗаменить(ТекстHTML, "cid:" + ИсточникФайла, АбсолютнаяСсылкаНаКартинку);
				ТекстHTML = СтрЗаменить(ТекстHTML, "CID:" + ИсточникФайла, АбсолютнаяСсылкаНаКартинку);
				Если СтрДлина(ИсточникФайла) > 18 Тогда
					ТекстHTML = СтрЗаменить(ТекстHTML, ИсточникФайла, АбсолютнаяСсылкаНаКартинку);
				КонецЕсли;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВложенияВыборОбработка();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыборОбработка()
	
	Вложение = Элементы.Вложения.ТекущиеДанные;

	#Если ВебКлиент Тогда
		ПолучитьФайл(Вложение.Адрес, Вложение.ИмяФайла, Истина);
	#Иначе
		
		Если Не Вложение.ЭтоВложенноеПисьмо Тогда
			ДелопроизводствоКлиент.ОткрытьФайлИзВременногоХранилища(Вложение.Адрес, Вложение.ИмяФайла);
		Иначе
			ОткрытьПисьмоИзВременногоХранилища(Вложение.Адрес, Вложение.ИмяФайла);
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
// Копирует файл из временного хранилища на клиента и открывает его для просмотра
//
Процедура ОткрытьПисьмоИзВременногоХранилища(АдресВоВременномХранилище, ИмяФайла)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	Если ДвоичныеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось получить файл. Возможно он был удален.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("ДвоичныеДанные", ДвоичныеДанные);
	ОткрытьФорму(
		"ЖурналДокументов.ЭлектроннаяПочта.Форма.ПросмотрВложенногоПисьма", 
		ПараметрыОткрытия,
		ЭтаФорма,,,,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПисьмаHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если Найти(ДанныеСобытия.Href, "javascript") <> 0 Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	ВстроеннаяПочтаКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Неопределено, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьВложение(Команда)
	
	ВложенияВыборОбработка();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложениеКак(Команда)
	
	Вложение = Элементы.Вложения.ТекущиеДанные;

	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
		
	Если Вложение.ЭтоВложенноеПисьмо Тогда
		Возврат;
	КонецЕсли;
		
	// Выбираем путь к файлу на диске.
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	ВыборФайла.ПолноеИмяФайла = Вложение.ИмяФайла;
	ВыборФайла.Расширение = Вложение.Расширение;
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), Вложение.Расширение, Вложение.Расширение);
	ВыборФайла.Фильтр = Фильтр;
	
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	ИмяФайла = Вложение.ИмяФайла;
	
	РазмерВМб = Вложение.Размер / (1024 * 1024);
	
	ТекстПояснения =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняется сохранение файла ""%1"" (%2 Мб)...
			       |Пожалуйста, подождите.'"),
		ИмяФайла, 
		ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМб));
		
	Состояние(ТекстПояснения);
	
	АдресФайла = Вложение.Адрес;
	
	ПередаваемыеФайлы = Новый Массив;
	Описание = Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, АдресФайла);
	ПередаваемыеФайлы.Добавить(Описание);
	
	ПутьКФайлу = Файл.Путь;
	ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКФайлу);
	
	// Сохраним Файл из БД на диск.
	Если ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь) Тогда
		
	КонецЕсли;
			
	Состояние(НСтр("ru = 'Файл успешно сохранен'"), , ПолноеИмяФайла);
			
КонецПроцедуры
