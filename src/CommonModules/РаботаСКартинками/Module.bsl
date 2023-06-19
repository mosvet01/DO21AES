#Область ПрограммныйИнтерфейс

// Собирает картинки в одну вертикально.
//
// Параметры:
//   ИсходныеКартинки - Массив - массив строк или двоичных данных с исходными картинками.
//   Формат - Строка - расширение формата.
//
// Возвращаемое значение:
//   Строка - путь к картинке, являющейся сборкой исходных по вертикали.
//
Функция СобратьКартинки(ИсходныеКартинки, Формат) Экспорт
	
	ПутьНовогоФайла = ПолучитьИмяВременногоФайла(Формат);
	ФайлыКУдалению = Новый Массив;
	
	ПараметрыConvert = Новый Массив;
	Для Каждого ИсходнаяКартинка Из ИсходныеКартинки Цикл
		Если ТипЗнч(ИсходнаяКартинка) = Тип("ДвоичныеДанные") Тогда
			ПутьИсходногоФайла = ПолучитьИмяВременногоФайла(Формат);
			ИсходнаяКартинка.Записать(ПутьИсходногоФайла);
			ФайлыКУдалению.Добавить(ПутьИсходногоФайла);
		ИначеЕсли ТипЗнч(ИсходнаяКартинка) = Тип("Строка") Тогда
			ПутьИсходногоФайла = ИсходнаяКартинка;
		КонецЕсли;
		ПараметрыConvert.Добавить(ПутьИсходногоФайла);
	КонецЦикла;
	
	Параметры = СтрШаблон("convert %1 -append %2",
		СтрСоединить(ПараметрыConvert, " "),
		ПутьНовогоФайла);
		
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

// Преобразует pdf в массив png
Функция ПреобразоватьPdfВPng(ИмяФайлаPdf, ВременнаяПапкаДляРазархивирования) Экспорт
	
	МассивПутейPng = Новый Массив;
	
	ПутьНовогоФайла = ВременнаяПапкаДляРазархивирования + ПолучитьРазделительПути() + "res.png";
	ФайлыКУдалению = Новый Массив;
	
	Параметры = СтрШаблон("convert -strip -density 150 -quality 0 %1 %2",
		ИмяФайлаPdf,
		ПутьНовогоФайла);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению);
	
	МассивФайлов = НайтиФайлы(ВременнаяПапкаДляРазархивирования, "res*.png");
	
	МассивПутей = Новый Массив;
	МассивСтруктур = Новый Массив;
	
	// отсортируем по дате
	Для Каждого Файл Из МассивФайлов Цикл
		
		ПутьФайла = Файл.ПолноеИмя;
		
		СтруктураФайла = Новый Структура("ПутьФайла, ИмяБезРасширения");
		СтруктураФайла.ПутьФайла = ПутьФайла;
		СтруктураФайла.ИмяБезРасширения = Файл.ИмяБезРасширения;
		
		МассивСтруктур.Добавить(СтруктураФайла);
		
	КонецЦикла;	
	
	СортироватьМассивПоЧислам(МассивСтруктур, МассивПутей);
	
	Для Каждого ПутьФайла Из МассивПутей Цикл
		МассивПутейPng.Добавить(ПутьФайла);
	КонецЦикла;	
	
	Возврат МассивПутейPng;

КонецФункции

// Преобразует массив png в pdf 
Процедура ПреобразоватьPngВPdf(МассивНовыхPng, ИмяФайлаPdfНовое, ИмяBatФайла = "") Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если (ТипПлатформыСервера = ТипПлатформы.Linux_x86 
		Или ТипПлатформыСервера = ТипПлатформы.Linux_x86_64) Тогда
	
		ИмяBatФайла = "";
	
	КонецЕсли;
	
	ФайлыКУдалению = Новый Массив;
	
	ПараметрыConvert = Новый Массив;
	Для Каждого ПутьИсходногоФайла Из МассивНовыхPng Цикл
		ПараметрыConvert.Добавить(ПутьИсходногоФайла);
	КонецЦикла;
	
	Параметры = СтрШаблон("convert %1 %2",
		СтрСоединить(ПараметрыConvert, " "),
		ИмяФайлаPdfНовое);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению, ИмяBatФайла);

КонецПроцедуры

// Уменьшить штамп. 
Процедура УменьшитьШтамп(ИмяФайлаШтампа, ЧислоПодписей) Экспорт
	
	ФайлыКУдалению = Новый Массив;
	НоваяВысота = ЧислоПодписей * 140;
	
	Параметры = СтрШаблон("mogrify -resize 600x%1 %2",
		Формат(НоваяВысота, "ЧГ=0"), // ЧГ=0  без группировки по 3
		ИмяФайлаШтампа);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению); 
	
КонецПроцедуры

// Увеличить штамп. 
Процедура УвеличитьШтамп(ИмяФайлаШтампа, ЧислоПодписей) Экспорт
	
	ФайлыКУдалению = Новый Массив;
	НоваяВысота = ЧислоПодписей * 140*4;
	
	Параметры = СтрШаблон("mogrify -resize 2400x%1 %2",
		Формат(НоваяВысота, "ЧГ=0"), // ЧГ=0  без группировки по 3
		ИмяФайлаШтампа);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению); 
	
КонецПроцедуры

// Накладывает на картинки штамп. 
Функция НаложитьШтамп(ПутьPng, ИмяФайлаШтампа, 
	ВременнаяПапкаДляРазархивирования, Счетчик,
	РасположениеШтампаЭПВPdf) Экспорт
	
	ОтступX = ""; //как строка
	ОтступY = "";
	
	ПоложениеШтампаСтрока = "NorthWest";
	Если РасположениеШтампаЭПВPdf = Перечисления.ВариантыПечатиШтампаЭП.ЛевыйВерхний Тогда
		ПоложениеШтампаСтрока = "NorthWest";
		ОтступX = "+120";
		ОтступY = "+120";
	ИначеЕсли РасположениеШтампаЭПВPdf = Перечисления.ВариантыПечатиШтампаЭП.ЛевыйНижний Тогда
		ПоложениеШтампаСтрока = "SouthWest";
		ОтступX = "+120";
		ОтступY = "+120";
	ИначеЕсли РасположениеШтампаЭПВPdf = Перечисления.ВариантыПечатиШтампаЭП.ПравыйВерхний Тогда
		ПоложениеШтампаСтрока = "NorthEast";
		ОтступX = "+60";
		ОтступY = "+120";
	ИначеЕсли РасположениеШтампаЭПВPdf = Перечисления.ВариантыПечатиШтампаЭП.ПравыйНижний Тогда
		ПоложениеШтампаСтрока = "SouthEast";
		ОтступX = "+60";
		ОтступY = "+120";
	КонецЕсли;	
	
	ПутьНовогоФайла = ВременнаяПапкаДляРазархивирования + ПолучитьРазделительПути() + СтрШаблон("res%1.png", Счетчик);
	ФайлыКУдалению = Новый Массив;
	
	Параметры = СтрШаблон("composite -dissolve 80 -gravity %1 -geometry %2%3 %4 %5 %6",
		ПоложениеШтампаСтрока,
		ОтступX,
		ОтступY,
		ИмяФайлаШтампа,
		ПутьPng,
		ПутьНовогоФайла);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению);
	
	УдалитьФайлы(ПутьPng);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

// Формирует изображение штампа ЭП
//
// Параметры:
//   ОписаниеЭП - Структура со свойствами:
//     Номер - Строка - серийный номер
//     Владелец - Строка - владелец сертификата ЭП.
//     ДатаНачала - Дата - дата начала действия сертификата.
//     ДатаОкончания - Дата - дата окончания действия сертификата.
//   Формат - Строка - расширение формата.
//
// Возвращаемое значение:
//   Строка - полный путь к картинке штампа ЭП.
//
Функция СформироватьШтампЭП(ОписаниеЭП, Формат = "PNG") Экспорт
	
	ФайлыКУдалению = Новый Массив;
	
	МакетСертификат = ПолучитьОбщийМакет("ШаблонОтметкиЭП");
	
	ПутьФайлаШаблона = ПолучитьИмяВременногоФайла(Формат);
	МакетСертификат.Записать(ПутьФайлаШаблона);
	ФайлыКУдалению.Добавить(ПутьФайлаШаблона);
	
	ПараметрыDraw = Новый Массив;
	
	ПараметрыDraw.Добавить(
		СтрШаблон(
			"text %1, %2 '%3'",
			260,
			133,
			ОписаниеЭП.Номер));
	
	ПараметрыDraw.Добавить(
		СтрШаблон(
			"text %1, %2 '%3'",
			260,
			333,
			СтрШаблон(
				НСтр("ru = 'с %1 по %2'"),
				Формат(ОписаниеЭП.ДатаНачала, "ДФ=dd.MM.yyyy"),
				Формат(ОписаниеЭП.ДатаОкончания, "ДФ=dd.MM.yyyy"))));
	
	
	ПараметрыСоздания = Новый Массив;
	
	ПараметрыСоздания.Добавить(
		СтрШаблон("convert %1", ПутьФайлаШаблона));
	
	ПараметрыСоздания.Добавить(
		СтрШаблон(" -pointsize 36 -fill ""#0A64DC"" -draw ""%1""", 
			СтрСоединить(ПараметрыDraw, " ")));
	
	ПараметрыСоздания.Добавить(
		СтрШаблон(
			"-background none  -fill ""#0A64DC"" -stroke None -pointsize 36 -size 940x140 -gravity NorthWest caption:""%1"" -geometry +%2+%3 -composite",
			ОписаниеЭП.Владелец,
			260,
			150)); // 260 150 - координаты (лево верх)
	
	ПутьНовогоФайла = ПолучитьИмяВременногоФайла("PNG");
	
	ПараметрыСоздания.Добавить(ПутьНовогоФайла);
	
	ПараметрыImageMagick = СтрСоединить(ПараметрыСоздания, " ");
	
	ЗапуститьImageMagick(ПараметрыImageMagick, ФайлыКУдалению);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

Функция СформироватьШтампЭПСДоверенностью(ОписаниеЭП, Формат = "PNG") Экспорт
	
	ФайлыКУдалению = Новый Массив;

	МакетСертификат = ПолучитьОбщийМакет("ШаблонОтметкиЭПСДоверенностью");
	
	ПутьФайлаШаблона = ПолучитьИмяВременногоФайла(Формат);
	МакетСертификат.Записать(ПутьФайлаШаблона);
	ФайлыКУдалению.Добавить(ПутьФайлаШаблона);
	
	ПараметрыDraw = Новый Массив;
	
	ПараметрыDraw.Добавить(
		СтрШаблон(
			"text %1, %2 '%3'",
			260,
			133,
			ОписаниеЭП.Номер));
	
	ПараметрыDraw.Добавить(
		СтрШаблон(
			"text %1, %2 '%3'",
			260,
			233,
			СтрШаблон(
				НСтр("ru = 'с %1 по %2'"),
				Формат(ОписаниеЭП.ДатаНачала, "ДФ=dd.MM.yyyy"),
				Формат(ОписаниеЭП.ДатаОкончания, "ДФ=dd.MM.yyyy"))));
	
	ПараметрыDraw.Добавить(
		СтрШаблон(
			"text %1, %2 '%3'",
			260,
			413,
			ОписаниеЭП.ДанныеДоверенности.НомерДоверенности));
	
	
	ПараметрыСоздания = Новый Массив;
	
	ПараметрыСоздания.Добавить(
		СтрШаблон("convert %1", ПутьФайлаШаблона));
	
	ПараметрыСоздания.Добавить(
		СтрШаблон(" -pointsize 36 -fill ""#0A64DC"" -draw ""%1""", 
			СтрСоединить(ПараметрыDraw, " ")));
	
	ПараметрыСоздания.Добавить(
		СтрШаблон(
			"-background none  -fill ""#0A64DC""  -stroke None -pointsize 36 -size 940x90 -gravity NorthWest caption:""%1"" -geometry +%2+%3 -composite",
			ОписаниеЭП.Владелец,
			260,
			150)); // 260 150 - координаты (лево верх)
	
	ПараметрыСоздания.Добавить(
		СтрШаблон(
			"-background none  -fill ""#0A64DC""  -stroke None -pointsize 36 -size 940x90 -gravity NorthWest caption:""%1"" -geometry +%2+%3 -composite",
			СтрЗаменить(ОписаниеЭП.ДанныеДоверенности.ДоверительПредставление, """", ""),
			260,
			280));
	
	ПутьНовогоФайла = ПолучитьИмяВременногоФайла("PNG");
	
	ПараметрыСоздания.Добавить(ПутьНовогоФайла);
	
	ПараметрыImageMagick = СтрСоединить(ПараметрыСоздания, " ");
	
	ЗапуститьImageMagick(ПараметрыImageMagick, ФайлыКУдалению);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

// Накладывает на изображение строки в указанных местах.
//
// Параметры:
//   ИсходнаяКартинка - Строка, ДвоичныеДанные - исходная картинка.
//   Формат - Строка - расширение формата.
//   Строки - Массив - массив структур со свойствами:
//     Слева - Число - пикселей слева до левого края строки.
//     Сверху - Число - пикселей сверху до нижнего края строки.
//     Строка - Строка - накладываемая строка.
//   Размер - Число - размер шрифта в пикселях.
//
// Возвращаемое значение:
//   Строка - полный путь к картинке с наложенным текстом.
//
Функция НаложитьСтроки(ИсходнаяКартинка, Формат, Строки, Размер) Экспорт
	
	ФайлыКУдалению = Новый Массив;
	Если ТипЗнч(ИсходнаяКартинка) = Тип("ДвоичныеДанные") Тогда
		ПутьИсходногоФайла = ПолучитьИмяВременногоФайла(Формат);
		ИсходнаяКартинка.Записать(ПутьИсходногоФайла);
		ФайлыКУдалению.Добавить(ПутьИсходногоФайла);
	ИначеЕсли ТипЗнч(ИсходнаяКартинка) = Тип("Строка") Тогда
		ПутьИсходногоФайла = ИсходнаяКартинка;
	КонецЕсли;
	
	ПутьНовогоФайла = ПолучитьИмяВременногоФайла(Формат);
	
	ПараметрыDraw = Новый Массив;
	Для Каждого Строка Из Строки Цикл
		ПараметрDraw = СтрШаблон("text %1, %2 '%3'",
			Формат(Строка.Слева, "ЧГ=0"),
			Формат(Строка.Сверху, "ЧГ=0"),
			Строка.Текст);
		ПараметрыDraw.Добавить(ПараметрDraw);
	КонецЦикла;
	Параметры = СтрШаблон("convert -pointsize %1 -draw ""%2"" %3 %4",
		Формат(Размер, "ЧГ=0"),
		СтрСоединить(ПараметрыDraw, " "),
		ПутьИсходногоФайла,
		ПутьНовогоФайла);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

// Конвертирует картинку из указанного формата в новый.
//
// Параметры:
//   ИсходнаяКартинка - Строка, ДвоичныеДанные - исходная картинка.
//   ИсходныйФормат - Строка - расширение исходного формата.
//   НовыйФормат - Строка - расширение нового формата.
//
// Возвращаемое значение:
//   Строка - полный путь к картинке в новом формате.
//
Функция Конвертировать(ИсходнаяКартинка, ИсходныйФормат, НовыйФормат) Экспорт
	
	ФайлыКУдалению = Новый Массив;
	Если ТипЗнч(ИсходнаяКартинка) = Тип("ДвоичныеДанные") Тогда
		ПутьИсходногоФайла = ПолучитьИмяВременногоФайла(ИсходныйФормат);
		ИсходнаяКартинка.Записать(ПутьИсходногоФайла);
		ФайлыКУдалению.Добавить(ПутьИсходногоФайла);
	ИначеЕсли ТипЗнч(ИсходнаяКартинка) = Тип("Строка") Тогда
		ПутьИсходногоФайла = ИсходнаяКартинка;
	КонецЕсли;
	
	ПутьНовогоФайла = ПолучитьИмяВременногоФайла(НовыйФормат);
	Параметры = СтрШаблон("convert %1 %2", ПутьИсходногоФайла, ПутьНовогоФайла);
	
	ЗапуститьImageMagick(Параметры, ФайлыКУдалению);
	
	Возврат ПутьНовогоФайла;
	
КонецФункции

// Запускает ImageMagick с указанными параметрами. В случае ошибки вызывается исключение,
// в остальных случаях возвращается код возврата ImageMagick.
//
// Параметры:
//   Параметры - Строка - параметры запуска ImageMagick.
//   ФайлыКУдалению - Массив - необязательный параметр, временные файлы, требующие удаления.
//   ИмяBatФайла - строка, полный путь + имя  bat файла. Может быть пуст.
//
// Возвращаемое значение:
//   Число - 0 в случае успешного выполнения, 300+ - при завершении с предупреждением.
//     Полный список предупреждений см. в документации к ImageMagick.
//
Функция ЗапуститьImageMagick(Параметры, ФайлыКУдалению, ИмяBatФайла = "") Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();	
	
	ПолныйПуть = Константы.ПутьКПрограммеКонвертацииPDF.Получить();
	
	// в Линукс можно пустой путь
	Если (ТипПлатформыСервера <> ТипПлатформы.Linux_x86 
		И ТипПлатформыСервера <> ТипПлатформы.Linux_x86_64) Тогда
		Если Не ЗначениеЗаполнено(ПолныйПуть) Тогда
			УдалитьВременныеФайлы(ФайлыКУдалению);
			ВызватьИсключение НСтр("ru = 'В настройках программы не указан полный путь к программе ImageMagick.'");
		КонецЕсли;
	КонецЕсли;
	
	Если ПолныйПуть = "convert.exe" Тогда
		УдалитьВременныеФайлы(ФайлыКУдалению);
		ВызватьИсключение НСтр("ru = 'В настройках программы указан полный путь к устаревшей версии ImageMagick (convert.exe).'");
	КонецЕсли;
	
	Если (ТипПлатформыСервера = ТипПлатформы.Linux_x86 
		Или ТипПлатформыСервера = ТипПлатформы.Linux_x86_64) Тогда
		
		Если ПолныйПуть <> "" Тогда
			СтрокаКоманды = СокрЛП(ПолныйПуть) + " " + Параметры;
		Иначе	
			СтрокаКоманды = Параметры;
		КонецЕсли;			
		
	Иначе	
		СтрокаКоманды = """" + СокрЛП(ПолныйПуть) + """ " + Параметры;
	КонецЕсли;
	
	СтрокаЗапуска = СтрокаКоманды;
	Если ИмяBatФайла <> "" Тогда
		ЗаписьТекста = Новый ЗаписьТекста(ИмяBatФайла, "cp866");
		ЗаписьТекста.Записать(СтрокаКоманды);
		ЗаписьТекста.Закрыть();
		ФайлыКУдалению.Добавить(ИмяBatФайла);
		СтрокаЗапуска = ИмяBatФайла;
	КонецЕсли;	
	
	КодВозврата = Неопределено;
	Попытка
		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
	Исключение
		УдалитьВременныеФайлы(ФайлыКУдалению);
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Ошибка при вызове ImageMagick с командной строкой:
			|%1
			|(%2)'"),
			СтрокаКоманды,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
	УдалитьВременныеФайлы(ФайлыКУдалению);
	
	// Успех.
	Если КодВозврата = 0 Тогда
		Возврат КодВозврата;
	КонецЕсли;
	
	// Не ImageMagick.
	Если КодВозврата = Неопределено Тогда
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Нет кода возврата при вызове ImageMagick с командной строкой:
			|%1
			|Возможно, указанный путь не является путем к ImageMagick.'"),
			СтрокаКоманды);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Предупреждение.
	Если КодВозврата >= 300 
		И КодВозврата < 400 Тогда
		ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Предупреждение %1 при вызове ImageMagick с командной строкой:
			|%2
			|Подробности см. в документации к ImageMagick.'"),
			КодВозврата,
			СтрокаКоманды);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Работа с картинками'"),
			УровеньЖурналаРегистрации.Предупреждение,,,
			ТекстПредупреждения);
		Возврат КодВозврата;
	КонецЕсли;
	
	// Ошибка ОС или иного приложения.
	Если КодВозврата < 300 Тогда
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Ошибка %1 при вызове ImageMagick с командной строкой:
			|%2
			|Возможно, нарушена структура командной строки.'"),
			КодВозврата,
			СтрокаКоманды);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Ошибка ImageMagick.
	ТекстИсключения = СтрШаблон(НСтр("ru = 'Ошибка %1 при вызове ImageMagick с командной строкой:
		|%2
		|Подробности см. в документации к ImageMagick.'"),
		КодВозврата,
		СтрокаКоманды);
	ВызватьИсключение ТекстИсключения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьВременныеФайлы(ФайлыКУдалению)
	
	Если ФайлыКУдалению = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ФайлКУдалению Из ФайлыКУдалению Цикл
		УдалитьФайлы(ФайлКУдалению);
	КонецЦикла;
	
КонецПроцедуры

// Определяет, является ли переданная строка числом
//
// Параметры:
//   СтрокаСимволов - Строка - строка символов
//
// Возвращаемое значение:
//   Булево - возвращает Истина, если строка является числом
//
Функция ЭтоЧисло(СтрокаСимволов)
	
	СтрокаСимволов = СокрЛП(СтрокаСимволов);
	
	Если Не ЗначениеЗаполнено(СтрокаСимволов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(СтрокаСимволов);
	
	Для ТекущийСимвол = 1 По ДлинаСтроки Цикл
		
		КодСимвола = КодСимвола(СтрокаСимволов, ТекущийСимвол);
		
		Если КодСимвола < 48 Или КодСимвола > 57 Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Процедура СортироватьМассивПоЧислам(МассивСтруктур, МассивПутей)
	
	ПараметрыДаты = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	
	ТаблицаФайлов = Новый ТаблицаЗначений;
	ТаблицаФайлов.Колонки.Добавить("ПутьФайла");
	ТаблицаФайлов.Колонки.Добавить("Номер", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтруктураФайла Из МассивСтруктур Цикл
		
		НоваяСтрока = ТаблицаФайлов.Добавить();
		НоваяСтрока.ПутьФайла = СтруктураФайла.ПутьФайла;
		
		ИмяБезРасширения = СтруктураФайла.ИмяБезРасширения;
		
		Номер = 0;
		СтрокаНомера = "";
		
		ТекПоз = СтрДлина(ИмяБезРасширения);
		Пока ТекПоз > 1 Цикл
			Символ = Сред(ИмяБезРасширения, ТекПоз, 1);
			Если Не ЭтоЧисло(Символ) Тогда
				Прервать;
			КонецЕсли;	
			СтрокаНомера = Символ + СтрокаНомера;
			ТекПоз = ТекПоз - 1;
		КонецЦикла;	
		
		Попытка
			Номер = Число(СтрокаНомера);
		Исключение
		КонецПопытки;	
		
		НоваяСтрока.Номер = Номер;
		
	КонецЦикла;		
	
	ТаблицаФайлов.Сортировать("Номер Возр");  
	
	МассивПутей.Очистить();
	
	Для Каждого Стр Из ТаблицаФайлов Цикл
		МассивПутей.Добавить(Стр.ПутьФайла);
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти
