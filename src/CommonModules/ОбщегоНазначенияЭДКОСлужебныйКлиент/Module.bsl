////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность электронного документооборота
//             с контролирующими органами  (служебный)". 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ПолучитьСистемнуюИнформацию

Процедура ПолучитьСистемнуюИнформацию(ОповещениеОЗавершении, ВыводитьСообщения = Ложь) Экспорт
	
	Контекст = Новый Структура("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Оповещение = Новый ОписаниеОповещения("ПолучитьСистемнуюИнформациюПослеСозданияКаталога", ЭтотОбъект, Контекст);
	
	ОперацииСФайламиЭДКОКлиент.СоздатьКаталогНаКлиенте(Оповещение);
	
КонецПроцедуры

Процедура ПолучитьСистемнуюИнформациюПослеСозданияКаталога(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ВходящийКонтекст.Вставить("ИмяКаталога", Результат.ИмяКаталога);
		Оповещение = Новый ОписаниеОповещения("ПолучитьСистемнуюИнформациюПослеСохраненияСкрипта", ЭтотОбъект, ВходящийКонтекст);
		
		ТекстСкрипта = 
		":: detect OS
		|@echo off
		|
		|set fileResult=""!directory!detectOS_result.txt""
		|
		|for /F ""tokens=1,2 delims=="" %%A in ('wmic os get Caption /Value') do (if ""%%A"" equ ""Caption"" set CaptionValue=%%B)
		|for /F ""tokens=1,2 delims=="" %%A in ('wmic os get Version /Value') do (if ""%%A"" equ ""Version"" set VersionValue=%%B)
		|for /F ""tokens=1,2 delims=="" %%A in ('wmic os get CSDVersion /Value') do (if ""%%A"" equ ""CSDVersion"" set CSDVersionValue=%%B)
		|
		|if ""%CSDVersionValue%"" equ """" (set CSDVersionValue=-)
		|
		|echo %CaptionValue% > %fileResult%
		|echo %VersionValue% >> %fileResult%
		|echo %CSDVersionValue% >> %fileResult%
		|
		|
		|set Bitness=64
		|if %PROCESSOR_ARCHITECTURE% == x86 (
		|  if not defined PROCESSOR_ARCHITEW6432 set Bitness=32
		|  )
		|echo %Bitness% >> %fileResult%";
		ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "!directory!", ВходящийКонтекст.ИмяКаталога);
		ОперацииСФайламиЭДКОКлиент.ТекстВФайл(Оповещение, ТекстСкрипта, ВходящийКонтекст.ИмяКаталога + "detectOS.bat");
	Иначе
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПолучитьСистемнуюИнформациюПослеСохраненияСкрипта(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Оповещение = Новый ОписаниеОповещения("ПолучитьСистемнуюИнформациюПослеВыполненияСкрипта", ЭтотОбъект, ВходящийКонтекст);
		
		ОперацииСФайламиЭДКОКлиент.ЗапуститьПриложениеНаКлиенте(Оповещение, Результат.ИмяФайла, Истина);
	Иначе
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПолучитьСистемнуюИнформациюПослеВыполненияСкрипта(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено И Результат.КодВозврата = 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПолучитьСистемнуюИнформациюПослеЧтенияРезультатаВыполненияСкрипта", ЭтотОбъект, ВходящийКонтекст);
		
		ОперацииСФайламиЭДКОКлиент.ФайлВТекст(Оповещение, ВходящийКонтекст.ИмяКаталога + "detectOS_result.txt");
	Иначе
		ВыполнитьОбработкуОповещения(
			ВходящийКонтекст.ОповещениеОЗавершении, Новый Структура("Выполнено, ОписаниеОшибки", Ложь, ""));
	КонецЕсли;
		
КонецПроцедуры

Процедура ПолучитьСистемнуюИнформациюПослеЧтенияРезультатаВыполненияСкрипта(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Текст = СокрЛП(Результат.Текст);
		
		СистемнаяИнформация = Новый Структура;
		СистемнаяИнформация.Вставить("ИмяОС", 			"");
		СистемнаяИнформация.Вставить("ВерсияОС", 		"");
		СистемнаяИнформация.Вставить("РазрядностьОС", 	0);
		СистемнаяИнформация.Вставить("ПолноеИмяОС", 	"");
		СистемнаяИнформация.Вставить("ПолнаяВерсияОС", 	"");
		СистемнаяИнформация.Вставить("СборкаОС", 		"");
		
		// Определение версии ОС
		ВерсияСтрока = СтрПолучитьСтроку(Текст, 2);
		СистемнаяИнформация.ПолнаяВерсияОС = СокрЛП(ВерсияСтрока);
		СоставляющиеВерсии = СтрРазделить(ВерсияСтрока, ".", Истина);
		СистемнаяИнформация.ВерсияОС = СтрШаблон("%1.%2", СоставляющиеВерсии[0], СоставляющиеВерсии[1]);
		СистемнаяИнформация.СборкаОС = ?(СоставляющиеВерсии.Количество() >= 3, СокрЛП(СоставляющиеВерсии[2]), "");
		
		// Определение разрядности ОС		
		РазрядностьСтрока = СтрПолучитьСтроку(Текст, 4);
		Если ЗначениеЗаполнено(РазрядностьСтрока) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛП(РазрядностьСтрока)) Тогда
			СистемнаяИнформация.РазрядностьОС = Число(РазрядностьСтрока);
		КонецЕсли;
		
		// Определение имени ОС
		ПолноеИмяОС = СтрПолучитьСтроку(Текст, 1);
		СистемнаяИнформация.ПолноеИмяОС = СокрЛП(ПолноеИмяОС);
		СистемнаяИнформация.Вставить("ИмяОС", ОпределитьИмяОС_Windows(ПолноеИмяОС, СистемнаяИнформация.ВерсияОС));
		
		ОперацииСФайламиЭДКОКлиент.УдалитьФайлыНаКлиенте(, ВходящийКонтекст.ИмяКаталога);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Новый Структура("Выполнено, СистемнаяИнформация", Истина, СистемнаяИнформация));		
	Иначе
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти


#Область УстановитьViPNetCSP

Процедура УстановитьViPNetCSP(ОповещениеОЗавершении, ВладелецФормы) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		ЭтоWindowsXP = СтрНайти(СистемнаяИнформация.ВерсияОС, "Windows XP") > 0
			ИЛИ СтрНайти(СистемнаяИнформация.ИнформацияПрограммыПросмотра, "Windows NT 5.1") > 0;
		
		Контекст = Новый Структура;
		Контекст.Вставить("ЭтоWindowsXP", 			ЭтоWindowsXP);
		Контекст.Вставить("ОповещениеОЗавершении", 	ОповещениеОЗавершении);
		Оповещение = Новый ОписаниеОповещения("УстановитьViPNetCSPПослеВводаРегистрационныхДанных", ЭтотОбъект, Контекст);
		
		ОткрытьФорму(
			"Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.УстановкаViPNetCSPРегистрационныеДанные",,
			ВладелецФормы,,,, Оповещение);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Установка ViPNet CSP возможно только на операционных системах семейства Windows.'");
		ПоказатьПредупреждение(, ОписаниеОшибки,, НСтр("ru = 'Установка ViPNet CSP'"));
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеВводаРегистрационныхДанных(Результат, ВходящийКонтекст) Экспорт
	
	Если ЗначениеЗаполнено(Результат) И ТипЗнч(Результат) = Тип("Структура") Тогда
		ВходящийКонтекст.Вставить("РегистрационныеДанные", Результат);
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьViPNetCSPПослеСозданияВременногоКаталога", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.СоздатьКаталогНаКлиенте(Оповещение);
	Иначе
		Результат = Новый Структура("Выполнено", Ложь);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеСозданияВременногоКаталога(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ВходящийКонтекст.Вставить("ВременныйКаталог", Результат.ИмяКаталога);

		Оповещение = Новый ОписаниеОповещения(
			"УстановитьViPNetCSPПослеПолученияИнформацииОбОперационнойСистеме", ЭтотОбъект, ВходящийКонтекст);
		ПолучитьСистемнуюИнформацию(Оповещение);	
	Иначе
		Результат = Новый Структура("Выполнено", Ложь);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеПолученияИнформацииОбОперационнойСистеме(Результат, ВходящийКонтекст) Экспорт
	
	РезультатВызова = Результат;
	Если НЕ РезультатВызова.Выполнено И ВходящийКонтекст.ЭтоWindowsXP Тогда
		СистемнаяИнформацияXP = Новый Структура;
		СистемнаяИнформацияXP.Вставить("ИмяОС", 			"Windows XP");
		СистемнаяИнформацияXP.Вставить("ВерсияОС", 			"5.1");
		СистемнаяИнформацияXP.Вставить("РазрядностьОС", 	32);
		СистемнаяИнформацияXP.Вставить("ПолноеИмяОС", 		"Microsoft Windows XP");
		СистемнаяИнформацияXP.Вставить("ПолнаяВерсияОС", 	"5.1.0");
		СистемнаяИнформацияXP.Вставить("СборкаОС", 			"0");
		
		РезультатВызова = Новый Структура;
		РезультатВызова.Вставить("Выполнено", Истина);
		РезультатВызова.Вставить("СистемнаяИнформация", СистемнаяИнформацияXP);
	КонецЕсли;
	
	Если РезультатВызова.Выполнено Тогда
		// Windows 10, Windows Server 2016
		Если РезультатВызова.СистемнаяИнформация.ВерсияОС = "10.0" Тогда
			ОписаниеОшибки = СтрШаблон(
								НСтр("ru = 'Работа ViPNet CSP на операционной системе %1 не поддерживается.'"),
								РезультатВызова.СистемнаяИнформация.ИмяОС);
			ПоказатьПредупреждение(, ОписаниеОшибки);
			
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("Выполнено", Ложь);
			РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
			Возврат;
		КонецЕсли;
		ВходящийКонтекст.РегистрационныеДанные.Вставить("Разрядность", 		РезультатВызова.СистемнаяИнформация.РазрядностьОС);
		ВходящийКонтекст.РегистрационныеДанные.Вставить("ПолноеИмяОС", 		РезультатВызова.СистемнаяИнформация.ПолноеИмяОС);
		ВходящийКонтекст.РегистрационныеДанные.Вставить("ПолнаяВерсияОС", 	РезультатВызова.СистемнаяИнформация.ПолнаяВерсияОС);
		ВходящийКонтекст.РегистрационныеДанные.Вставить("СборкаОС", 		РезультатВызова.СистемнаяИнформация.СборкаОС);
		
		// Определение антивируса
		МассивИменСлужбESET_NOD32 = ИменаСлужбESET_NOD32();
		МассивИменСлужбKaspersky = ИменаСлужбKaspersky();
		МассивИменСлужбАнтивирусов = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивИменСлужбАнтивирусов, МассивИменСлужбESET_NOD32, Ложь);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивИменСлужбАнтивирусов, МассивИменСлужбKaspersky, Ложь);
		
		ИмяАнтивируса = "";
		ПутиАнтивирусов = ПолучитьПутиСлужб(МассивИменСлужбАнтивирусов);
		Если ПутиАнтивирусов <> Неопределено Тогда
			Для каждого ПутьАнтивируса Из ПутиАнтивирусов Цикл
				Если СокрЛП(ПутьАнтивируса.Значение) <> "" Тогда
					Если МассивИменСлужбESET_NOD32.Найти(ПутьАнтивируса.Ключ) <> Неопределено Тогда
						ИмяАнтивируса = "ESET_NOD32";
						Прервать;
					ИначеЕсли МассивИменСлужбKaspersky.Найти(ПутьАнтивируса.Ключ) <> Неопределено Тогда
						ИмяАнтивируса = "Kaspersky";
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// Передаваемая при загрузке ViPNet CSP версия Windows
		Если (РезультатВызова.СистемнаяИнформация.ВерсияОС = "6.1" ИЛИ РезультатВызова.СистемнаяИнформация.ВерсияОС = "6.2"
			ИЛИ РезультатВызова.СистемнаяИнформация.ВерсияОС = "6.3") И (ИмяАнтивируса = "Kaspersky"
			ИЛИ ПутиАнтивирусов = Неопределено) Тогда
			
			ВходящийКонтекст.РегистрационныеДанные.ПолноеИмяОС = ?(СтрНайти(РезультатВызова.СистемнаяИнформация.ПолноеИмяОС,
				"Майкрософт") > 0, "Майкрософт Windows Vista", "Microsoft Windows Vista");
			ВходящийКонтекст.РегистрационныеДанные.ПолнаяВерсияОС = "6.0.0";
			ВходящийКонтекст.РегистрационныеДанные.СборкаОС = "0";
			
		ИначеЕсли (РезультатВызова.СистемнаяИнформация.ВерсияОС = "5.1" ИЛИ РезультатВызова.СистемнаяИнформация.ВерсияОС = "5.2"
			ИЛИ РезультатВызова.СистемнаяИнформация.ВерсияОС = "6.0") И ИмяАнтивируса = "ESET_NOD32" Тогда
			
			ВходящийКонтекст.РегистрационныеДанные.ПолноеИмяОС = ?(СтрНайти(РезультатВызова.СистемнаяИнформация.ПолноеИмяОС,
				"Майкрософт") > 0, "Майкрософт Windows 7", "Microsoft Windows 7");
			ВходящийКонтекст.РегистрационныеДанные.ПолнаяВерсияОС = "6.1.0";
			ВходящийКонтекст.РегистрационныеДанные.СборкаОС = "0";
			
		ИначеЕсли РезультатВызова.СистемнаяИнформация.ВерсияОС = "5.1" Тогда
			ВходящийКонтекст.РегистрационныеДанные.ПолноеИмяОС = ?(СтрНайти(РезультатВызова.СистемнаяИнформация.ПолноеИмяОС,
				"Майкрософт") > 0, "Майкрософт Windows 2003", "Microsoft Windows 2003");
			ВходящийКонтекст.РегистрационныеДанные.ПолнаяВерсияОС = "5.2.0";
			ВходящийКонтекст.РегистрационныеДанные.СборкаОС = "0";
		КонецЕсли;
		
		ПараметрыДистрибутива = ОбщегоНазначенияЭДКОСлужебныйВызовСервера.ПолучитьСерийныйНомерДистрибутиваViPNetCSP(ВходящийКонтекст.РегистрационныеДанные);
		
		Если Не ЗначениеЗаполнено(ПараметрыДистрибутива) Тогда
			ОписаниеОшибки = НСтр("ru = 'Сервис временно недоступен. Обратитесь в службу поддержки или повторите попытку позже.'");
			ПоказатьПредупреждение(, ОписаниеОшибки);
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("Выполнено", Ложь);
			РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
			Возврат;
		КонецЕсли;
		
		ВходящийКонтекст.Вставить("Дистрибутив", ПараметрыДистрибутива.Дистрибутив);
		ВходящийКонтекст.Вставить("СерийныйНомер", ПараметрыДистрибутива.СерийныйНомер);
		ВходящийКонтекст.Вставить("Версия", ПараметрыДистрибутива.Версия);
		ВходящийКонтекст.Вставить("КонтрольнаяСумма", ПараметрыДистрибутива.КонтрольнаяСумма);
		
		Оповещение = Новый ОписаниеОповещения("УстановитьViPNetCSPПослеСкачиванияДистрибутива", ЭтотОбъект, ВходящийКонтекст);
		
		ПараметрыВыполнения = Новый Структура("ПоясняющийТекст", НСтр("ru = 'Выполняется загрузка программы...'"));
		ОперацииСФайламиЭДКОКлиент.СкачатьФайлНаСервереВФоне(Оповещение, ПараметрыДистрибутива.Дистрибутив, ПараметрыВыполнения);
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", РезультатВызова.ОписаниеОшибки);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВызова);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеСкачиванияДистрибутива(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ВходящийКонтекст.Вставить("Дистрибутив", Результат.АдресФайла);
		
		РаспакованныеФайлы = ОперацииСФайламиЭДКОСлужебныйВызовСервера.РаспаковатьАрхив(Результат.АдресФайла);
		АдресДистрибутива = "";
		Для Каждого РаспакованныйФайл Из РаспакованныеФайлы Цикл
			Если СтрЗаканчиваетсяНа(РаспакованныйФайл.Имя, ".exe")
				И СтрНайти(РаспакованныйФайл.Имя, "hash") = 0 Тогда
				
				АдресДистрибутива = РаспакованныйФайл.Хранение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ИмяФайла = ВходящийКонтекст.ВременныйКаталог + "Setup.exe";
		Оповещение = Новый ОписаниеОповещения("УстановитьViPNetCSPПослеПолученияФайла", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.ДанныеССервераВФайл(Оповещение, АдресДистрибутива, ИмяФайла);
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеПолученияФайла(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ТекстФайла = "Serial Number: %1
		              |E-mail: %2
		              |User name: %3
		              |Company: %4";

		ТекстФайла = СтрШаблон(
			ТекстФайла,
			ВходящийКонтекст.СерийныйНомер,
			ВходящийКонтекст.РегистрационныеДанные.ЭлектроннаяПочта,
			ВходящийКонтекст.РегистрационныеДанные.КонтактноеЛицо,
			"");
			
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьViPNetCSPПослеСохраненияФайлаСРегистрационнымиДанными", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.ТекстВФайл(Оповещение, ТекстФайла, ВходящийКонтекст.ВременныйКаталог + "cspreg.txt");
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
			  
Процедура УстановитьViPNetCSPПослеСохраненияФайлаСРегистрационнымиДанными(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьViPNetCSPПослеПолученияПодтвержденияНаУстановку", ЭтотОбъект, ВходящийКонтекст);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Дистрибутив", ВходящийКонтекст.ВременныйКаталог + "Setup.exe");
		ПараметрыФормы.Вставить("КонтрольнаяСумма", ВходящийКонтекст.КонтрольнаяСумма);
		ПараметрыФормы.Вставить("Версия", ВходящийКонтекст.Версия);
		
		Если ВходящийКонтекст.РегистрационныеДанные.ВыполнятьКонтрольЦелостности Тогда
			ОткрытьФорму(
				"Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.УстановкаViPNetCSPИнформацияОДистрибутиве",
				ПараметрыФормы,,,,, Оповещение);
		Иначе
			УстановитьViPNetCSPПослеПолученияПодтвержденияНаУстановку(Истина, ВходящийКонтекст);
		КонецЕсли;
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеПолученияПодтвержденияНаУстановку(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Истина Тогда
		Оповещение = Новый ОписаниеОповещения("УстановитьViPNetCSPПослеСохраненияСкрипта", ЭтотОбъект, ВходящийКонтекст);
		
		ТекстСкрипта =		
		":: workaround problem autoenrollment
		|@echo off
		|
		|set AppDataDir=%ALLUSERSPROFILE%
		|if not defined PROGRAMDATA set AppDataDir=%AppDataDir%\Application Data
		|
		|set ViPNet_CSP_dir=%AppDataDir%\InfoTeCS\ViPNet CSP\
		|if not exist ""%ViPNet_CSP_dir%\."" mkdir ""%ViPNet_CSP_dir%""
		|
		|""!setup.exe!"" /qf";
		ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "!setup.exe!", ВходящийКонтекст.ВременныйКаталог + "Setup.exe");
		ОперацииСФайламиЭДКОКлиент.ТекстВФайл(Оповещение, ТекстСкрипта, ВходящийКонтекст.ВременныйКаталог + "Setup.bat");
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Пользователь отклонил установку ViPNet CSP'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеСохраненияСкрипта(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Оповещение = Новый ОписаниеОповещения("УстановитьViPNetCSPПослеЗавершенияУстановки", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.ЗапуститьПриложениеНаКлиенте(
			Оповещение, ВходящийКонтекст.ВременныйКаталог + "Setup.bat", Истина);
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка при установке ViPNet CSP'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьViPNetCSPПослеЗавершенияУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Если ЗначениеЗаполнено(Результат.КодВозврата) Тогда
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("Выполнено", Ложь);
			РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Установка ViPNet CSP не выполнена'"));
			
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		Иначе
			РегистрационныеДанные = Новый Структура;
			РегистрационныеДанные.Вставить("КонтактноеЛицо", ВходящийКонтекст.РегистрационныеДанные.КонтактноеЛицо);
			РегистрационныеДанные.Вставить("ЭлектроннаяПочта", ВходящийКонтекст.РегистрационныеДанные.ЭлектроннаяПочта);
			РегистрационныеДанные.Вставить("СерийныйНомер", ВходящийКонтекст.СерийныйНомер);
			РегистрационныеДанные.Вставить("Версия", ВходящийКонтекст.Версия);
			
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("РегистрационныеДанные", РегистрационныеДанные);
			РезультатВыполнения.Вставить("Выполнено", Истина);
			
			ПараметрыПриложения[ОбщегоНазначенияЭДКОКлиент.ИмяПараметраКриптопровайдеры()] = Неопределено;
			
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Установка ViPNet CSP не выполнена'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УстановитьCryptoProCSP

Процедура УстановитьCryptoProCSP(ОповещениеОЗавершении, ВладелецФормы) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		Контекст.Вставить("ВладелецФормы", ВладелецФормы);
		Оповещение = Новый ОписаниеОповещения("УстановитьCryptoProCSPПослеВводаРегистрационныхДанных", ЭтотОбъект, Контекст);
		
		ОткрытьФорму(
			"Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.УстановкаCryptoProCSPРегистрационныеДанные",,
			ВладелецФормы,,,, Оповещение);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Автоматическая установка CryptoPro CSP возможно только на операционных системах семейства Windows.'");
		ПоказатьПредупреждение(, ОписаниеОшибки,, НСтр("ru = 'Установка CryptoPro CSP'"));
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеВводаРегистрационныхДанных(Результат, ВходящийКонтекст) Экспорт
	
	Если ЗначениеЗаполнено(Результат) И ТипЗнч(Результат) = Тип("Структура") Тогда
		ВходящийКонтекст.Вставить("РегистрационныеДанные", Результат);
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьCryptoProCSPПослеПолученияДистрибутива", ЭтотОбъект, ВходящийКонтекст);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВходящийКонтекст.ВладелецФормы);
		ДлительнаяОперация = ОбщегоНазначенияЭДКОСлужебныйВызовСервера.ПолучитьДистрибутивCryptoProCSP(ВходящийКонтекст.РегистрационныеДанные);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	Иначе
		РезультатВыполнения = Новый Структура("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Пользователь прервал операцию'"));
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеПолученияДистрибутива(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		РезультатВыполнения = Новый Структура("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Вызов API сервиса выдачи дистрибутивов CryptoPro CSP не был завершен штатно.'"));
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		ВходящийКонтекст.Вставить("Дистрибутив", Результат.Дистрибутив);
		ВходящийКонтекст.Вставить("НомерДистрибутива", Результат.НомерДистрибутива);
		ВходящийКонтекст.Вставить("Версия", Результат.Версия);
		ВходящийКонтекст.Вставить("КонтрольнаяСумма", Результат.КонтрольнаяСумма);
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьCryptoProCSPПослеСозданияВременногоКаталога", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.СоздатьКаталогНаКлиенте(Оповещение);
	Иначе
		РезультатВыполнения = Новый Структура("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", ДлительнаяОперация.КраткоеПредставлениеОшибки);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеСозданияВременногоКаталога(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ВходящийКонтекст.Вставить("ВременныйКаталог", Результат.ИмяКаталога);
		
		ИмяФайла = ВходящийКонтекст.ВременныйКаталог + "Setup.exe";
		Оповещение = Новый ОписаниеОповещения("УстановитьCryptoProCSPПослеПолученияФайла", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОКлиент.ДанныеССервераВФайл(Оповещение, ВходящийКонтекст.Дистрибутив, ИмяФайла);
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеПолученияФайла(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"УстановитьCryptoProCSPПослеПолученияПодтвержденияНаУстановку", ЭтотОбъект, ВходящийКонтекст);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Дистрибутив", ВходящийКонтекст.ВременныйКаталог + "Setup.exe");
		ПараметрыФормы.Вставить("Версия", ВходящийКонтекст.Версия);
		ПараметрыФормы.Вставить("КонтрольнаяСумма", ВходящийКонтекст.КонтрольнаяСумма);
		
		Если ВходящийКонтекст.РегистрационныеДанные.ВыполнятьКонтрольЦелостности Тогда
			ОткрытьФорму(
				"Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.УстановкаCryptoProCSPИнформацияОДистрибутиве",
				ПараметрыФормы,,,,, Оповещение);
		Иначе
			УстановитьCryptoProCSPПослеПолученияПодтвержденияНаУстановку(Истина, ВходящийКонтекст);
		КонецЕсли;
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеПолученияПодтвержденияНаУстановку(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Истина Тогда
		Оповещение = Новый ОписаниеОповещения("УстановитьCryptoProCSPПослеСохраненияСкрипта", ЭтотОбъект, ВходящийКонтекст);
		
		ТекстСкрипта =		
		":: setup CryptoPro CSP
		|@echo off
		|
		|""!setup.exe!""!args!";
		ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "!setup.exe!", ВходящийКонтекст.ВременныйКаталог + "Setup.exe");
		Если ЗначениеЗаполнено(ВходящийКонтекст.РегистрационныеДанные.СерийныйНомер) Тогда
			ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "!args!", СтрШаблон(" -args ""PIDKEY=%1""", ВходящийКонтекст.РегистрационныеДанные.СерийныйНомер));
		Иначе
			ТекстСкрипта = СтрЗаменить(ТекстСкрипта, "!args!", "");			
		КонецЕсли;
		ОперацииСФайламиЭДКОКлиент.ТекстВФайл(Оповещение, ТекстСкрипта, ВходящийКонтекст.ВременныйКаталог + "Setup.bat");
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка при установке CryptoPro CSP'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеСохраненияСкрипта(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Оповещение = Новый ОписаниеОповещения("УстановитьCryptoProCSPПослеЗавершенияУстановки", ЭтотОбъект, ВходящийКонтекст);
		ОперацииСФайламиЭДКОСлужебныйКлиент.ЗапуститьПриложениеНаКлиенте(
			Оповещение, ВходящийКонтекст.ВременныйКаталог + "Setup.bat", ВходящийКонтекст.ВременныйКаталог, Истина, Ложь);
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка при установке CryptoPro CSP'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьCryptoProCSPПослеЗавершенияУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Если ЗначениеЗаполнено(Результат.КодВозврата) Тогда
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("Выполнено", Ложь);
			РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Установка CryptoPro CSP не выполнена'"));
			
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		Иначе
			РегистрационныеДанные = Новый Структура;
			РегистрационныеДанные.Вставить("КонтактноеЛицо", ВходящийКонтекст.РегистрационныеДанные.КонтактноеЛицо);
			РегистрационныеДанные.Вставить("ЭлектроннаяПочта", ВходящийКонтекст.РегистрационныеДанные.ЭлектроннаяПочта);
			РегистрационныеДанные.Вставить("СерийныйНомер", ВходящийКонтекст.РегистрационныеДанные.СерийныйНомер);
			РегистрационныеДанные.Вставить("Продукт", ВходящийКонтекст.РегистрационныеДанные.Продукт);
			
			РезультатВыполнения = Новый Структура;
			РезультатВыполнения.Вставить("РегистрационныеДанные", РегистрационныеДанные);
			РезультатВыполнения.Вставить("Выполнено", Истина);
			
			ПараметрыПриложения[ОбщегоНазначенияЭДКОКлиент.ИмяПараметраКриптопровайдеры()] = Неопределено;
			
			ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ОписаниеОшибки", НСтр("ru = 'Установка CryptoPro CSP не выполнена'"));
		
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СообщитьПользователюОКонфликтеКриптопровайдеров

Процедура СообщитьПользователюОКонфликтеКриптопровайдеров() Экспорт
	
	Оповещение = Новый ОписаниеОповещения("СообщитьПользователюОКонфликтеКриптопровайдеровПослеПолученияКриптопровайдеров", ЭтотОбъект);
	КриптографияЭДКОКлиент.ПолучитьКриптопровайдеры(Оповещение, Ложь, Ложь);		
	
КонецПроцедуры

Процедура СообщитьПользователюОКонфликтеКриптопровайдеровПослеПолученияКриптопровайдеров(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		ЭтоLinux = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
		ИзвестныеКриптопровайдеры = КриптографияЭДКОКлиентСервер.ИзвестныеКриптопровайдеры(,, ЭтоLinux);
		ИндексКриптопровайдеров = Неопределено;
		
		УстановленныеКриптопровайдерыГОСТ = Новый Массив;
		УстановленныеТипыКриптопровайдеров = Новый Массив;
		УстановленоТиповПоддерживаемыхКриптопровайдеров = 0;
		
		Для каждого Криптопровайдер Из Результат.Криптопровайдеры Цикл
			СвойстваКриптопровайдера = КриптографияЭДКОКлиентСервер.СвойстваКриптопровайдера(
				Криптопровайдер.Имя,,
				ИзвестныеКриптопровайдеры,
				ИндексКриптопровайдеров);
			Если СвойстваКриптопровайдера <> Неопределено
				И УстановленныеТипыКриптопровайдеров.Найти(СвойстваКриптопровайдера.ТипКриптопровайдера) = Неопределено Тогда
				
				УстановленныеТипыКриптопровайдеров.Добавить(СвойстваКриптопровайдера.ТипКриптопровайдера);
				УстановленныеКриптопровайдерыГОСТ.Добавить(СвойстваКриптопровайдера);
				Если СвойстваКриптопровайдера.Поддерживается Тогда
					УстановленоТиповПоддерживаемыхКриптопровайдеров = УстановленоТиповПоддерживаемыхКриптопровайдеров + 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если УстановленоТиповПоддерживаемыхКриптопровайдеров > 1 ИЛИ УстановленоТиповПоддерживаемыхКриптопровайдеров = 1 И
		(УстановленныеКриптопровайдерыГОСТ.Количество() > 1) Тогда
			Контекст = Новый Структура;
			Контекст.Вставить("Криптопровайдеры", УстановленныеКриптопровайдерыГОСТ);
			Оповещение = Новый ОписаниеОповещения("СообщитьПользователюОКонфликтеКриптопровайдеровПослеПоискаСертификатов", ЭтотОбъект, Контекст);
			ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
			КриптографияЭДКОКлиент.НайтиСертификаты(Оповещение, ПараметрыРаботыКлиентаПриЗапуске.ДоступныеЛокальныеСертификатыПользователя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СообщитьПользователюОКонфликтеКриптопровайдеровПослеПоискаСертификатов(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено И Результат.Сертификаты.Количество() > 0 Тогда
		Сертификаты = Новый Массив;
		Для Каждого НайденныйСертификат Из Результат.Сертификаты Цикл
			Если НайденныйСертификат.ДействителенС < ОбщегоНазначенияКлиент.ДатаСеанса() И НайденныйСертификат.ДействителенПо > ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
				Сертификаты.Добавить(НайденныйСертификат);
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеЗаполнено(Сертификаты) Тогда
			
			Контекст = Новый Структура;
			Контекст.Вставить("Сертификаты", Сертификаты);
			Контекст.Вставить("ТекущийСертификат", 0);
			Контекст.Вставить("Криптопровайдеры", ВходящийКонтекст.Криптопровайдеры);
			
			СообщитьПользователюОКонфликтеКриптопровайдеровВыгрузитьСертификаты(Контекст);
		КонецЕсли; 
	КонецЕсли;
		
КонецПроцедуры

Процедура СообщитьПользователюОКонфликтеКриптопровайдеровВыгрузитьСертификаты(Контекст)
	
	Если Контекст.Сертификаты.Количество() > Контекст.ТекущийСертификат Тогда
		Оповещение = Новый ОписаниеОповещения("СообщитьПользователюОКонфликтеКриптопровайдеровПослеВыгрузкиСертификата", ЭтотОбъект, Контекст);
		КриптографияЭДКОКлиент.ЭкспортироватьСертификатВBase64(Оповещение, Контекст.Сертификаты[Контекст.ТекущийСертификат]);			
	Иначе
		Сертификаты = КриптографияЭДКОСлужебныйВызовСервера.ИзвлечьИнформациюОКриптопровайдереПоСертификату(Контекст.Сертификаты);
		
		ПоказатьПредупреждениеОКонфликтеКриптопровайдеров(Сертификаты, Контекст.Криптопровайдеры);
	КонецЕсли;
		
КонецПроцедуры

Процедура СообщитьПользователюОКонфликтеКриптопровайдеровПослеВыгрузкиСертификата(Результат, ВходящийКонтекст) Экспорт 
	
	Если Результат.Выполнено Тогда
		Сертификат = Новый Структура(ВходящийКонтекст.Сертификаты[ВходящийКонтекст.ТекущийСертификат]);
		Сертификат.Вставить("Сертификат", Base64Значение(Результат.СтрокаBase64));
		ВходящийКонтекст.Сертификаты[ВходящийКонтекст.ТекущийСертификат] = Сертификат;
	КонецЕсли;
	ВходящийКонтекст.ТекущийСертификат = ВходящийКонтекст.ТекущийСертификат + 1;
	СообщитьПользователюОКонфликтеКриптопровайдеровВыгрузитьСертификаты(ВходящийКонтекст);
	
КонецПроцедуры

#КонецОбласти

#Область ИнформацияОКриптопровайдерах

Функция ИнформацияОКриптопровайдерах() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВерсияКриптоПроCSP", 	"");
	Результат.Вставить("ВерсияViPNetCSP", 		"");
	
#Если МобильныйКлиент Тогда
	ОбъектWshShell = Неопределено;
#Иначе
	Попытка
		ОбъектWshShell = Новый COMОбъект("WScript.Shell");
	Исключение
		ОбъектWshShell = Неопределено;
	КонецПопытки;
#КонецЕсли
	
	Если ОбъектWshShell = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПолныйПутьИПараметрВерсииКриптоПроCSP32 = "HKLM\SOFTWARE\Wow6432Node\Crypto Pro\Settings\Version";
	ПолныйПутьИПараметрВерсииКриптоПроCSP = "HKLM\SOFTWARE\Crypto Pro\Settings\Version";
	
	Попытка
		Результат.ВерсияКриптоПроCSP = ОбъектWshShell.RegRead(ПолныйПутьИПараметрВерсииКриптоПроCSP32);
	Исключение
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(Результат.ВерсияКриптоПроCSP) Тогда
		Попытка
			Результат.ВерсияКриптоПроCSP = ОбъектWshShell.RegRead(ПолныйПутьИПараметрВерсииКриптоПроCSP);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	ПолныйПутьИПараметрВерсииViPNetCSP32 = "HKLM\SOFTWARE\Wow6432Node\InfoTeCS\Setup\Products\InfoTeCS-CSP\ProductVersion";
	ПолныйПутьИПараметрВерсииViPNetCSP = "HKLM\SOFTWARE\InfoTeCS\Setup\Products\InfoTeCS-CSP\ProductVersion";
	
	Попытка
		Результат.ВерсияViPNetCSP = ОбъектWshShell.RegRead(ПолныйПутьИПараметрВерсииViPNetCSP32);
	Исключение
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(Результат.ВерсияViPNetCSP) Тогда
		Попытка
			Результат.ВерсияViPNetCSP = ОбъектWshShell.RegRead(ПолныйПутьИПараметрВерсииViPNetCSP);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Результат.ВерсияКриптоПроCSP 	= СокрЛП(Результат.ВерсияКриптоПроCSP);
	Результат.ВерсияViPNetCSP 		= СокрЛП(Результат.ВерсияViPNetCSP);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьИмяОС_Windows(СтрокаОС, ВерсияОС)
	
	ИмяОС = "Unknown";
	
	Если ВерсияОС = "5.2" Тогда
		Если СтрНайти(СтрокаОС, "Windows XP Professional x64") Тогда 
			ИмяОС = "Windows XP Professional x64";
		ИначеЕсли СтрНайти(СтрокаОС, "Windows Server 2003") Тогда
			ИмяОС = "Windows Server 2003";
		ИначеЕсли СтрНайти(СтрокаОС, "Windows Server 2003 R2") Тогда
			ИмяОС = "Windows Server 2003 R2";
		КонецЕсли;
	Иначе
		ВерсииWindowsСерверные = Новый Соответствие;
		ВерсииWindowsСерверные.Вставить("6.0", "Windows Server 2008");
		ВерсииWindowsСерверные.Вставить("6.1", "Windows Server 2008 R2");
		ВерсииWindowsСерверные.Вставить("6.2", "Windows Server 2012");
		ВерсииWindowsСерверные.Вставить("6.3", "Windows Server 2012 R2");
		ВерсииWindowsСерверные.Вставить("10.0", "Windows Server 2016");
		
		ВерсииWindowsКлиентские = Новый Соответствие;
		ВерсииWindowsКлиентские.Вставить("5.1", "Windows XP");
		ВерсииWindowsКлиентские.Вставить("6.0", "Windows Vista");
		ВерсииWindowsКлиентские.Вставить("6.1", "Windows 7");
		ВерсииWindowsКлиентские.Вставить("6.2", "Windows 8");
		ВерсииWindowsКлиентские.Вставить("6.3", "Windows 8.1");
		ВерсииWindowsКлиентские.Вставить("10.0", "Windows 10");
		
		Если СтрНайти(СтрокаОС, "Server") Тогда
			Если ВерсииWindowsСерверные.Получить(ВерсияОС) <> Неопределено Тогда	
				ИмяОС = ВерсииWindowsСерверные.Получить(ВерсияОС);
			КонецЕсли;
		Иначе
			Если ВерсииWindowsКлиентские.Получить(ВерсияОС) <> Неопределено Тогда	
				ИмяОС = ВерсииWindowsКлиентские.Получить(ВерсияОС);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИмяОС;

КонецФункции

Процедура ПоказатьПредупреждениеОКонфликтеКриптопровайдеров(Сертификаты, Криптопровайдеры)
	
	ПараметрыФормы = Новый Структура("Сертификаты,Криптопровайдеры", Сертификаты, Криптопровайдеры);
	ОткрытьФорму("ОбщаяФорма.ПредупреждениеОКонфликтеКриптопровайдеров", ПараметрыФормы);
	
КонецПроцедуры

Функция ПолучитьПутиСлужб(ИменаСлужб)
	
#Если МобильныйКлиент Тогда
	ОбъектWshShell = Неопределено;
#Иначе
	Попытка
		ОбъектWshShell = Новый COMОбъект("WScript.Shell");
	Исключение
		ОбъектWshShell = Неопределено;
	КонецПопытки;
#КонецЕсли
	
	Если ОбъектWshShell = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Соответствие;
	
	Для каждого ИмяСлужбы Из ИменаСлужб Цикл
		ПолныйПутьИПараметр = СтрШаблон(
			"HKLM\SYSTEM\CurrentControlSet\services\%1\ImagePath",
			ИмяСлужбы);
		
		Попытка
			ПутьСлужбы = ОбъектWshShell.RegRead(ПолныйПутьИПараметр);
		Исключение
			ПутьСлужбы = "";
		КонецПопытки;
		
		Результат[ИмяСлужбы] = ПутьСлужбы;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИменаСлужбESET_NOD32()
	
	Результат = Новый Массив;
	
	Результат.Добавить("ekrn");
	Результат.Добавить("epfw");
	Результат.Добавить("epfwtdi");
	Результат.Добавить("eamon");
	Результат.Добавить("easdrv");
	Результат.Добавить("ERA_HTTP_SERVER");
	Результат.Добавить("ERA_SERVER");
	
	Возврат Результат;
	
КонецФункции

Функция ИменаСлужбKaspersky()
	
	Результат = Новый Массив;
	
	Результат.Добавить("klif");
	Результат.Добавить("klflt");
	Результат.Добавить("kltdi");
	Результат.Добавить("klmouflt");
	Результат.Добавить("kavsvc");
	Результат.Добавить("klfltdev");
	Результат.Добавить("klkbdflt");
	Результат.Добавить("AVP");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти



