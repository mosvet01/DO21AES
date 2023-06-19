///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Модуль процедур, исполняемых на сервере и на клиенте

#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует структуру параметров для получения данных файла. См. РаботаСФайлами.ДанныеФайла.
//
// Возвращаемое значение:
//  Структура:
//    * ИдентификаторФормы             - УникальныйИдентификатор - уникальный идентификатор формы, во временное хранилище
//                                     которой надо поместить файл и вернуть адрес в свойстве СсылкаНаДвоичныеДанныеФайла.
//                                     Значение по умолчанию - Неопределено.
//    * ПолучатьСсылкуНаДвоичныеДанные - Булево - если передать Ложь, то ссылка на двоичные данные в СсылкаНаДвоичныеДанныеФайла
//                                     не будет получена, что существенно ускорит выполнение для больших двоичных данных.
//                                     Значение по умолчанию - Истина.
//    * ДляРедактирования              - Булево - если указать Истина, то файл будет захвачен для редактирования.
//                                     Значение по умолчанию - Ложь.
//    * ВызыватьИсключение             - Булево - если указать Ложь, то функция в исключительных ситуациях не будет вызывать
//                                     исключений и вернет Неопределено. Значение по умолчанию - Истина.
//
Функция ПараметрыДанныхФайла() Экспорт
	
	ПараметрыДанных = Новый Структура;
	ПараметрыДанных.Вставить("ДляРедактирования",              Ложь);
	ПараметрыДанных.Вставить("ИдентификаторФормы",             Неопределено);
	ПараметрыДанных.Вставить("ВызыватьИсключение",             Истина);
	ПараметрыДанных.Вставить("ПолучатьСсылкуНаДвоичныеДанные", Истина);
	Возврат ПараметрыДанных;
	
КонецФункции

// Инициализирует структуру со сведениями о файле.
//
// Параметры:
//   Режим        - Строка - "Файл" или "ФайлСВерсией".
//   ИсходныйФайл - Файл   - файл, на основании которого заполняются свойства структуры.
//
// Возвращаемое значение:
//   Структура:
//    * ИмяБезРасширения             - Строка - имя файла без расширения.
//    * РасширениеБезТочки           - Строка - расширение файла.
//    * ВремяИзменения               - Дата   - дата и время изменения файла.
//    * ВремяИзмененияУниверсальное  - Дата   - UTC дата и время изменения файла.
//    * Размер                       - Число  - размер файла в байтах.
//    * АдресВременногоХранилищаФайла  - Строка
//                                     - ХранилищеЗначения - адрес во временном хранилище с двоичными данными
//                                       файла или непосредственно двоичные данные файла.
//    * АдресВременногоХранилищаТекста - Строка
//                                     - ХранилищеЗначения - адрес во временном хранилище с извлеченным текстов
//                                       для ППД или непосредственно сами данные с текстом.
//    * ЭтоВебКлиент                 - Булево - Истина, если вызов идет из веб клиента.
//    * Автор                        - СправочникСсылка.Пользователи - автор файла. Если Неопределено, то текущий
//                                                                     пользователь.
//    * Комментарий                  - Строка - комментарий к файлу.
//    * ЗаписатьВИсторию             - Булево - записать в историю работы пользователя.
//    * ХранитьВерсии                - Булево - разрешить хранение версий у файла в ИБ;
//                                              при создании новой версии - создавать новую версию, или изменять
//                                              существующую (Ложь).
//    * Зашифрован                   - Булево - файл зашифрован.
//
Функция СведенияОФайле(Знач Режим, Знач ИсходныйФайл = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяБезРасширения");
	Результат.Вставить("Комментарий", "");
	Результат.Вставить("АдресВременногоХранилищаТекста");
	Результат.Вставить("ХранитьВерсии", Истина);
	Результат.Вставить("Автор"); 
	Результат.Вставить("ШаблонОснование");
	Результат.Вставить("ИдентификаторФайла"); 
	Результат.Вставить("ДополнительныеПараметры");
	Результат.Вставить("СписокКатегорий");
	Результат.Вставить("Проект");
	Результат.Вставить("НеобходимоВыполнитьВставкуШКНаКлиенте", Ложь);
	
	Если Режим = "ФайлСВерсией" Тогда
		Результат.Вставить("РасширениеБезТочки");
		Результат.Вставить("ВремяИзменения", Дата('00010101'));
		Результат.Вставить("ВремяИзмененияУниверсальное", Дата('00010101'));
		Результат.Вставить("Размер", 0);
		Результат.Вставить("Зашифрован");
		Результат.Вставить("АдресВременногоХранилищаФайла");
		Результат.Вставить("ЗаписатьВИсторию", Ложь);
		Результат.Вставить("Кодировка");
		Результат.Вставить("СсылкаНаВерсиюИсточник");
		Результат.Вставить("НоваяВерсияДатаСоздания"); 
		Результат.Вставить("НоваяВерсияАвтор"); 
		Результат.Вставить("НоваяВерсияКомментарий"); 
		Результат.Вставить("НоваяВерсияНомерВерсии"); 
		Результат.Вставить("НовыйСтатусИзвлеченияТекста"); 
		Результат.Вставить("ПараметрыРаспознавания");
	КонецЕсли;
	
	Если ИсходныйФайл <> Неопределено Тогда
		Результат.ИмяБезРасширения = ИсходныйФайл.ИмяБезРасширения;
		Результат.РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ИсходныйФайл.Расширение);
		Результат.ВремяИзменения = ИсходныйФайл.ПолучитьВремяИзменения();
		Результат.ВремяИзмененияУниверсальное = ИсходныйФайл.ПолучитьУниверсальноеВремяИзменения();
		Результат.Размер = ИсходныйФайл.Размер();
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#Область Распознавание

// Возвращает Истина, если файл с таким расширением можно распознать - т.е. это картинка или PDF
Функция ЭтотФайлМожноРаспознать(Расширение, ИспользоватьImageMagickДляПреобразованияPDF, ПрограммаРаспознавания) Экспорт
	
	Если ЭтоРасширениеКартинки(НРег(Расширение)) Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если ИспользоватьImageMagickДляПреобразованияPDF И (НРег(Расширение) = "pdf") Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если ПрограммаРаспознавания = ПредопределенноеЗначение(
		"Перечисление.ПрограммыРаспознавания.СервисРаспознавания")
		
		И (НРег(Расширение) = "pdf") Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // РасширениеФайлаРазрешеноДляЗагрузки()

#КонецОбласти

// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОпределитьФормуПрисоединенногоФайла(Источник, ВидФормы, Параметры,
	ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	РаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(
		Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет, можно ли занять файл и, если нет, то формирует строку ошибки.
//
// Параметры:
//  ДанныеФайла  - Структура - структура с данными файла.
//  СтрокаОшибки - Строка - возвращаемое значение. Если файл занять нельзя,
//                 тогда содержит описание ошибки.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда текущий пользователь может занять файл или
//           файл уже занят текущим пользователем.
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Нельзя занять файл ""%1"", т.к. он помечен на удаление.'"),
		  Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	
	Результат = ДанныеФайла.Редактирует.Пустая() Или ДанныеФайла.РедактируетТекущийПользователь;  
	Если Результат Тогда
		
		Возврат Истина;
		
	Иначе
		
		ДатаЗаема = ?(ЗначениеЗаполнено(ДанныеФайла.ДатаЗаема), 
			" " + НСтр("ru = 'с'") + " " + Формат(ДанныеФайла.ДатаЗаема, "ДЛФ=ДВ"), "");
		
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл ""%1""
			           |уже занят для редактирования пользователем
			           |""%2""%3.'"),
			Строка(ДанныеФайла.Ссылка), Строка(ДанныеФайла.Редактирует), ДатаЗаема);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением является картинкой
Функция ЭтоРасширениеКартинки(Расширение) Экспорт
	
	РасширениеКартинки = (Расширение = "bmp" ИЛИ Расширение = "tif" ИЛИ Расширение = "tiff" 
		ИЛИ Расширение = "jpg" ИЛИ Расширение = "jpeg" ИЛИ Расширение = "png" ИЛИ Расширение = "gif");
		
	Возврат РасширениеКартинки;
	
КонецФункции // РасширениеФайлаРазрешеноДляЗагрузки()

// создает элемент справочника Файлы
Функция СоздатьЭлементСправочникаФайлы(ВыбранныйФайл, МассивСтруктурВсехФайлов, Владелец, 
	ИдентификаторФормы, Комментарий, ХранитьВерсии, ДобавленныеФайлы,
	АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста,
	Пользователь, ПараметрыРаспознавания, Категории = Неопределено,
	Кодировка = Неопределено) Экспорт
	
	// Создадим карточку Файла в БД
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией", ВыбранныйФайл);
	СведенияОФайле.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
	СведенияОФайле.АдресВременногоХранилищаТекста = АдресВременногоХранилищаТекста;
	СведенияОФайле.Комментарий = Комментарий;
	СведенияОФайле.Кодировка = Кодировка;
	СведенияОФайле.Автор = Пользователь;
	СведенияОФайле.ХранитьВерсии = ХранитьВерсии;
	СведенияОФайле.ПараметрыРаспознавания = ПараметрыРаспознавания;
	СведенияОФайле.СписокКатегорий = Категории;

	ДокСсылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(Владелец, СведенияОФайле);
	
	Если Категории <> Неопределено Тогда  
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Для Каждого Категория Из Категории Цикл
				РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(ПользователиКлиентСервер.ТекущийПользователь(), Категория.Значение, ДокСсылка);	
			КонецЦикла;	
		Иначе
			Для Каждого Категория Из Категории Цикл
				РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(ПользователиКлиентСервер.ТекущийПользователь(), Категория.Значение, Владелец);	
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
	Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаФайла) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаФайла);	
	КонецЕсли;	
	
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда 
		Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаТекста) Тогда
			УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);	
		КонецЕсли;	
	КонецЕсли;	

	ДобавленныйФайлИПуть = Новый Структура("ФайлСсылка, Путь, ПолноеИмя", ДокСсылка, ВыбранныйФайл.Путь, ВыбранныйФайл.ПолноеИмя);
	ДобавленныеФайлы.Добавить(ДобавленныйФайлИПуть);
	
	Запись = Новый Структура;
	Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
	Запись.Вставить("Файл", ДокСсылка);
	МассивСтруктурВсехФайлов.Добавить(Запись);
	
	Если Пользователь = Неопределено Тогда // вызов из импорта файлов
		ПротоколированиеРаботыПользователей.ЗаписатьИмпортФайлов(ДокСсылка, ВыбранныйФайл.ПолноеИмя);		
	КонецЕсли;	

КонецФункции

// Получает имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы
//
// Параметры:
//  НомерФайла  - Число - целое число, например, 12.
//  ПрефиксБазы - Строка - префикс базы, например, "ДМ".
//
// Возвращаемое значение:
//  Строка - имя сканированного файла, например, "ДМ-00000012".
//
Функция ИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	
	Возврат ИмяФайла;
	
КонецФункции	

// Преобразует дату в универсальное время и возвращает его
Функция ПолучитьУниверсальноеВремя(Дата) Экспорт
	
	УниверсальноеВремя = Дата('00010101');
	
	#Если Сервер Тогда
		ЧасовойПояс = ЧасовойПояс();
		Если ПолучитьДопустимыеЧасовыеПояса().Найти(ЧасовойПояс) = Неопределено Тогда
			// Если на компьютере установлен некорректный часовой пояс, то считаем, что GMT 0:00.
			УниверсальноеВремя = Дата;
		Иначе
			УниверсальноеВремя = УниверсальноеВремя(Дата, ЧасовойПояс);
		КонецЕсли;
	#Иначе
		УниверсальноеВремя = УниверсальноеВремя(Дата);
	#КонецЕсли
	
	Возврат УниверсальноеВремя;
	
КонецФункции	

// Преобразует дату в местное время и возвращает его
Функция ПолучитьМестноеВремя(Дата) Экспорт
	
	МестноеВремя = Дата('00010101');
	
	#Если Сервер Тогда
		ЧасовойПояс = ЧасовойПояс();
		Если ПолучитьДопустимыеЧасовыеПояса().Найти(ЧасовойПояс) = Неопределено Тогда
			// Если на компьютере установлен некорректный часовой пояс, то считаем, что GMT 0:00.
			МестноеВремя = Дата;
		Иначе
			МестноеВремя = МестноеВремя(Дата, ЧасовойПояс);
		КонецЕсли;
	#Иначе
		МестноеВремя = МестноеВремя(Дата);
	#КонецЕсли
	
	Возврат МестноеВремя;
	
КонецФункции	

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Файлы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Возвращает Истина, если файл с таким расширением находится в списке расширений.
Функция РасширениеФайлаВСписке(СписокРасширений, РасширениеФайла) Экспорт
	
	РасширениеФайлаБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	МассивРасширений = СтрРазделить(
		НРег(СписокРасширений), " ", Ложь);
	
	Если МассивРасширений.Найти(РасширениеФайлаБезТочки) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением можно делать автовизуализацию
Функция ЭтоРасширениеДляАвтовизуализации(Расширение) Экспорт
	
	Если НРег(Расширение) = "doc"
		Или НРег(Расширение) = "docx"
		Или НРег(Расширение) = "odt"
		Или НРег(Расширение) = "pdf" Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции // РасширениеФайлаРазрешеноДляЗагрузки()

#КонецОбласти
