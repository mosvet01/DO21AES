////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Зависимости типов при замене ссылок.
// 
// Возвращаемое значение: 
//  ФиксированноеСоответствие из КлючИЗначение - Зависимости типов при замене ссылок:
// * Ключ - Строка
// * Значение - Массив из Строка
Функция ЗависимостиТиповПриЗаменеСсылок() Экспорт
	
	Возврат ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.ЗависимостиНеразделенныхОбъектовМетаданных();
	
КонецФункции

// Объект метаданных разделен хоть одним разделителем.
// 
// Параметры: 
//	ОбъектМетаданных - ОбъектМетаданныхПланОбмена, ОбъектМетаданныхПеречисление - объект метаданных.
//	Кэш - Соответствие из КлючИЗначение:
//	 * Ключ - Строка
//	 * Значение - СоставОбщегоРеквизита
// 
// Возвращаемое значение: 
//	Булево - Объект метаданных разделен хоть одним разделителем.
Функция ОбъектМетаданныхРазделенХотьОднимРазделителем(Знач ОбъектМетаданных, Кэш) Экспорт
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			
			АвтоИспользование = (ОбщийРеквизит.АвтоИспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать);
			
			Состав = Кэш.Получить(ОбщийРеквизит.ПолноеИмя());
			Если Состав = Неопределено Тогда
				Состав = ОбщийРеквизит.Состав;
				Кэш.Вставить(ОбщийРеквизит.ПолноеИмя(), Состав);
			КонецЕсли;
			
			ЭлементСостава = Состав.Найти(ОбъектМетаданных);
			Если ЭлементСостава <> Неопределено Тогда
				
				Если ЭлементСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать
						ИЛИ (АвтоИспользование И ЭлементСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто) Тогда
					
					Возврат Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#Область ОбработчикиСлужебныхСобытий

// Заполняет массив типов, для которых при выгрузке необходимо использовать аннотацию
// ссылок в файлах выгрузки.
//
// Параметры:
//  Типы - Массив Из ОбъектМетаданных - объекты метаданных.
//
Процедура ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы) Экспорт
	
	ТипыОбщихДанных = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	Для Каждого ТипОбщихДанных Из ТипыОбщихДанных Цикл
		Типы.Добавить(ТипОбщихДанных);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при регистрации произвольных обработчиков выгрузки данных.
//
// Параметры:
//   ТаблицаОбработчиков - ТаблицаЗначений - в данной процедуре требуется
//  дополнить эту таблицу значений информацией о регистрируемых произвольных
//  обработчиках выгрузки данных. Колонки:
//    ОбъектМетаданных - ОбъектМетаданных - при выгрузке данных которого должен
//      вызываться регистрируемый обработчик,
//    Обработчик - ОбщийМодуль - общий модуль, в котором реализован произвольный
//      обработчик выгрузки данных. Набор экспортных процедур, которые должны
//      быть реализованы в обработчике, зависит от установки значений следующих
//      колонок таблицы значений,
//    Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных,
//      поддерживаемого обработчиком,
//    ПередВыгрузкойТипа - Булево - флаг необходимости вызова обработчика перед
//      выгрузкой всех объектов информационной базы, относящихся к данному объекту
//      метаданных. Если присвоено значение Истина - в общем модуле обработчика должна
//      быть реализована экспортируемая процедура ПередВыгрузкойТипа(),
//      поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных - перед выгрузкой данных которого
//          был вызван обработчик,
//        Отказ - Булево - если в процедуре ПередВыгрузкойТипа() установить значение
//          данного параметра равным Истина - выгрузка объектов, соответствующих
//          текущему объекту метаданных, выполняться не будет.
//    ПередВыгрузкойОбъекта - Булево - флаг необходимости вызова обработчика перед
//      выгрузкой конкретного объекта информационной базы. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПередВыгрузкойОбъекта(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект - ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы -
//          менеджер выгрузки текущего объекта. Подробнее см. комментарий к программному интерфейсу обработки
//          ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы. Параметр передается только при вызове
//          процедур обработчиков, для которых при регистрации указана версия не ниже 1.0.0.1,
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПередВыгрузкойОбъекта() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        Объект - КонстантаМенеджерЗначения, СправочникОбъект, ДокументОбъект,
//          БизнесПроцессОбъект, ЗадачаОбъект, ПланСчетовОбъект, ПланОбменаОбъект,
//          ПланВидовХарактеристикОбъект, ПланВидовРасчетаОбъект, РегистрСведенийНаборЗаписей,
//          РегистрНакопленияНаборЗаписей, РегистрБухгалтерииНаборЗаписей,
//          РегистрРасчетаНаборЗаписей, ПоследовательностьНаборЗаписей, ПерерасчетНаборЗаписей -
//          объект данных информационной базы, перед выгрузкой которого был вызван обработчик.
//          Значение, переданное в процедуру ПередВыгрузкойОбъекта() в качестве значения параметра
//          Объект может быть модифицировано внутри обработчика ПередВыгрузкойОбъекта(), при
//          этом внесенные изменения будут отражены в сериализации объекта в файлах выгрузки, но
//          не будут зафиксированы в информационной базе
//        Артефакты - Массив Из ОбъектXDTO - набор дополнительной информации, логически неразрывно
//          связанной с объектом, но не являющейся его частью (артефакты объекта). Артефакты должны
//          сформированы внутри обработчика ПередВыгрузкойОбъекта() и добавлены в массив, переданный
//          в качестве значения параметра Артефакты. Каждый артефакт должен являться XDTO-объектом,
//          для типа которого в качестве базового типа используется абстрактный XDTO-тип
//          {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать XDTO-пакеты,
//          помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных. В дальнейшем
//          артефакты, сформированные в процедуре ПередВыгрузкойОбъекта(), будут доступны в процедурах
//          обработчиков загрузки данных (см. комментарий к процедуре ПриРегистрацииОбработчиковЗагрузкиДанных().
//        Отказ - Булево - если в процедуре ПередВыгрузкойОбъекта() установить значение
//           данного параметра равным Истина - выгрузка объекта, для которого был вызван обработчик,
//           выполняться не будет.
//    ПослеВыгрузкиТипа() - Булево, флаг необходимости вызова обработчика после выгрузки всех
//      объектов информационной базы, относящихся к данному объекту метаданных. Если присвоено значение
//      Истина - в общем модуле обработчика должна быть реализована экспортируемая процедура
//      ПослеВыгрузкиТипа(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//          контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//          к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения
//          аннотации ссылок. В случае, если в произвольном обработчике выгрузки требуется
//          выполнять выгрузку дополнительных данных - следует использовать
//          СериализаторXDTO, переданный в процедуру ПослеВыгрузкиТипа() в качестве
//          значения параметра Сериализатор, а не полученных с помощью свойства глобального
//          контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных - после выгрузки данных которого
//          был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаНеразделенныхДанных;
	НовыйОбработчик.ПередВыгрузкойДанных = Истина;
	
	ТипыОбщихДанных = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	
	Для Каждого ТипОбщихДанных Из ТипыОбщихДанных Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ТипОбщихДанных;
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаНеразделенныхДанных;
		НовыйОбработчик.ПередВыгрузкойТипа = Истина;
		НовыйОбработчик.ПослеВыгрузкиОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
	ОбъектыДляКонтроляНеразделенныхДанныхПриВыгрузке = ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.КонтрольСсылокНаНеразделенныеДанныеВРазделенныхПриВыгрузке();
	Для Каждого ОбъектДляКонтроляНеразделенныхДанныхПриВыгрузке Из ОбъектыДляКонтроляНеразделенныхДанныхПриВыгрузке Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектДляКонтроляНеразделенныхДанныхПриВыгрузке.Ключ);
		
		Если ТипыОбщихДанных.Найти(ОбъектМетаданных) = Неопределено Тогда // Иначе для объекта уже зарегистрирован обработчик
			
			НовыйОбработчик = ТаблицаОбработчиков.Добавить();
			НовыйОбработчик.ОбъектМетаданных = ОбъектМетаданных;
			НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаНеразделенныхДанных;
			НовыйОбработчик.ПослеВыгрузкиОбъекта = Истина;
			НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыгрузкойДанных(Контейнер) Экспорт
	
	Контейнер.ДополнительныеСвойства.Вставить(
		"ОбщиеДанныеТребующиеСопоставленияСсылок",
		ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке());
	
	Контейнер.ДополнительныеСвойства.Вставить(
		"ЛокальныйКэшСоставовРазделителей",
		Новый Соответствие());
	
КонецПроцедуры

// Вызывается перед выгрузкой типа данных.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередВыгрузкойТипа(Контейнер, Сериализатор, ОбъектМетаданных, Отказ) Экспорт
	
	Если Не ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда 
		ВызватьИсключение НСтр("ru = 'Замена ссылок доступна только в ссылочных данных'");
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
	ПоляЕстественногоКлюча = МенеджерОбъекта.ПоляЕстественногоКлюча();
	
	ПроверитьПоляЕстественногоКлюча(ОбъектМетаданных, ПоляЕстественногоКлюча);
	ПроверитьНаличиеДублейЕстественныхКлючей(ОбъектМетаданных, ПоляЕстественногоКлюча);
	
КонецПроцедуры

// Вызывается после выгрузки объекта данных. См. описание ПриРегистрацииОбработчиковВыгрузкиДанных.
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера выгрузки данных.
//	МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы -
//	 менеджер выгрузки текущего объекта.
//	Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения аннотации ссылок.
//	Объект - КонстантаМенеджерЗначения, СправочникОбъект, ДокументОбъект, БизнесПроцессОбъект, ЗадачаОбъект - 
//		   - ПланСчетовОбъект, ПланОбменаОбъект, ПланВидовХарактеристикОбъект, ПланВидовРасчетаОбъект -  
//		   - РегистрРасчетаНаборЗаписей, РегистрБухгалтерииНаборЗаписей, РегистрНакопленияНаборЗаписей - 
//		   - РегистрСведенийНаборЗаписей - объект данных.
//	Артефакты - Массив Из ОбъектXDTO - набор дополнительной информации 
Процедура ПослеВыгрузкиОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	ПолноеИмяОбъектаМетаданных = ОбъектМетаданных.ПолноеИмя();
	
	ПоляДляКонтроляСсылокНаНеразделенныеДанные =
		ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.КонтрольСсылокНаНеразделенныеДанныеВРазделенныхПриВыгрузке().Получить(
			ПолноеИмяОбъектаМетаданных);
	
	Если ПоляДляКонтроляСсылокНаНеразделенныеДанные <> Неопределено Тогда
		КонтрольСсылокНаНеразделенныеДанныеПриВыгрузке(Контейнер, Объект, ПоляДляКонтроляСсылокНаНеразделенныеДанные);
	КонецЕсли;
	
	Если Контейнер.ДополнительныеСвойства.ОбщиеДанныеТребующиеСопоставленияСсылок.Найти(ОбъектМетаданных) <> Неопределено Тогда
		
		Если Не ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда 
			ВызватьИсключение НСтр("ru = 'Подмена ссылок доступна только в ссылочных данных'");
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
		
		ПоляЕстественногоКлюча = МенеджерОбъекта.ПоляЕстественногоКлюча();
		
		ЕстественныйКлюч = Новый Структура();
		Для Каждого ПолеЕстественногоКлюча Из ПоляЕстественногоКлюча Цикл
			ЕстественныйКлюч.Вставить(ПолеЕстественногоКлюча, Объект[ПолеЕстественногоКлюча]);
		КонецЦикла;
		
		МенеджерВыгрузкиОбъекта.ТребуетсяСопоставитьСсылкуПриЗагрузке(Объект.Ссылка, ЕстественныйКлюч);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтрольИспользованияСсылокНаНеразделенныеДанныеВРазделенных() Экспорт
	
	Попытка
		
		ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.КонтрольСсылокНаНеразделенныеДанныеВРазделенныхПриВыгрузке();
		
	Исключение
		
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Обнаружены ошибки в структуре метаданных конфигурации: %1'", Метаданные.ОсновнойЯзык.КодЯзыка),
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура КонтрольЗаполненияПолейЕстественногоКлючаДляНеразделенныхОбъектов() Экспорт
	
	Попытка
		
		ВыгрузкаЗагрузкаНеразделенныхДанныхПовтИсп.ЗависимостиНеразделенныхОбъектовМетаданных();
		
	Исключение
		
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Обнаружены ошибки в структуре метаданных конфигурации: %1'", Метаданные.ОсновнойЯзык.КодЯзыка),
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие дублей естественных ключей объектов.
//
// Параметры:
//	ОбъектМетаданных - ОбъектМетаданных - выгружаемый объект метаданных.
//	ПоляЕстественногоКлюча - Массив - массив строк, в которых хранятся имена естественных ключей.
//
Процедура ПроверитьНаличиеДублейЕстественныхКлючей(Знач ОбъектМетаданных, Знач ПоляЕстественногоКлюча)
	
	ИмяТаблицы = ОбъектМетаданных.ПолноеИмя();
	
	ТекстЗапроса = СтрЗаменить(
	"ВЫБРАТЬ
	|	&ПоляВыборки,
	|	МАКСИМУМ(_Таблица_Справочника_Первая.Ссылка) КАК Ссылка,
	|	КОЛИЧЕСТВО(*) КАК Сч
	|ПОМЕСТИТЬ втДубли
	|ИЗ
	|	&Таблица КАК _Таблица_Справочника_Первая
	|
	|СГРУППИРОВАТЬ ПО
	|	&ПоляГруппировки
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	_Таблица_Справочника_Первая.Ссылка КАК СсылкаНаЭлементы
	|ИЗ
	|	втДубли КАК втДубли
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ &Таблица КАК _Таблица_Справочника_Первая
	|		ПО втДубли.Ссылка <> _Таблица_Справочника_Первая.Ссылка
	|		И &ТекстДополнительногоЗапроса", "&Таблица", ИмяТаблицы);
	
	ТекстДополнительногоЗапроса = "";
	ТекстВыборкиПоля = "";
	Итерация = 1;
	Для Каждого ПолеЕстественногоКлюча Из ПоляЕстественногоКлюча Цикл 
		
		ТекстВыборкиПоля = ТекстВыборкиПоля + "_Таблица_Справочника_Первая.%ИмяКлюча, 
			|";
		
		ТекстДополнительногоЗапроса = ТекстДополнительногоЗапроса + "И (_Таблица_Справочника_Первая.%ИмяКлюча = втДубли.%ИмяКлюча) ";
		
		ТекстДополнительногоЗапроса = СтрЗаменить(ТекстДополнительногоЗапроса, "%ИмяКлюча", ПолеЕстественногоКлюча);
		
		ТекстВыборкиПоля = СтрЗаменить(ТекстВыборкиПоля, "%ИмяКлюча", ПолеЕстественногоКлюча);
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляВыборки,", ТекстВыборкиПоля);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляГруппировки", Сред(ТекстВыборкиПоля, 1, СтрДлина(ТекстВыборкиПоля) - 3));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстДополнительногоЗапроса", ТекстДополнительногоЗапроса);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Определение объектов у которых дублируются первичные ключи
	ТаблицаСДублями = РезультатЗапроса.Выгрузить();
	Итерация = 0;
	СписокЭлементов = "";
	Для Каждого ДублируемыйЭлемент Из ТаблицаСДублями Цикл 
		
		ЗнакПрепинания = ?(Итерация = 0, "", "
		|");
		СписокЭлементов = СписокЭлементов + ЗнакПрепинания + Строка(ДублируемыйЭлемент.СсылкаНаЭлементы);
		Итерация = Итерация + 1;
		Если Итерация = 5 Тогда 
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ИменаКлючей = "";
	Итерация = 0;
	Для Каждого ПолеЕстественногоКлюча Из ПоляЕстественногоКлюча Цикл 
		
		ЗнакПрепинания = ?(Итерация = 0, "", "
		|");
		ИменаКлючей = ИменаКлючей + ЗнакПрепинания + ПолеЕстественногоКлюча;
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
	// Заполнение предупреждающего текста
	ТекстСообщения = СтрШаблон(НСтр("ru = 'У некоторых объектов %1: 
		|%2
		|
		|дублируются поля:
		|%3.
		|
		|Рекомендуется выполнить удаление дублирующихся элементов.'"),
		ИмяТаблицы, СписокЭлементов, ИменаКлючей);
	
	ВызватьИсключение ТекстСообщения;
	
КонецПроцедуры

// Проверяет наличие естественных ключей у объекта метаданных.
//
// Параметры:
//	ОбъектМетаданных - ОбъектМетаданных - выгружаемый объект метаданных.
//	ПоляЕстественногоКлюча - Массив из Строка - массив строк, в которых хранятся имена естественных ключей.
//
Процедура ПроверитьПоляЕстественногоКлюча(Знач ОбъектМетаданных, Знач ПоляЕстественногоКлюча)
	
	Если ПоляЕстественногоКлюча = Неопределено Или ПоляЕстественногоКлюча.Количество() = 0 Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Для типа данных %1 не указаны естественные ключи для замены ссылок.
                  |Проверьте обработчик ПриОпределенииТиповТребующихЗагрузкиВЛокальнуюВерсию.'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтрольСсылокНаНеразделенныеДанныеПриВыгрузке(Контейнер, Знач Объект, ПоляДляКонтроляСсылокНаНеразделенныеДанные)
	
	ОбъектМетаданных = Объект.Метаданные();
	ПолноеИмяОбъектаМетаданных = ОбъектМетаданных.ПолноеИмя();
	СтруктураИмениОбъекта = СтрРазделить(ПолноеИмяОбъектаМетаданных, ".");
	
	Для Каждого ПолеДляКонтроляСсылокНаНеразделенныеДанные Из ПоляДляКонтроляСсылокНаНеразделенныеДанные Цикл
		
		СтруктураИмениПоля = СтрРазделить(ПолеДляКонтроляСсылокНаНеразделенныеДанные, ".");
		
		Если СтруктураИмениОбъекта[0] <> СтруктураИмениПоля[0] Или СтруктураИмениОбъекта[1] <> СтруктураИмениПоля[1] Тогда
			
			ВызватьИсключение НСтр("ru = 'Некорректный кэш контроля неразделенных данных при выгрузке.'");
			
		КонецЕсли;
		
		Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
			
			КонтрольСсылкиНаНеразделенныеДанныеПриВыгрузке(
				Контейнер,
				Объект.Значение,
				Объект,
				ОбъектМетаданных,
				ПолеДляКонтроляСсылокНаНеразделенныеДанные);
			
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
			
			Если СтруктураИмениПоля[2] = "Реквизит" ИЛИ СтруктураИмениПоля[2] = "Attribute" Тогда // Не локализуется
				
				КонтрольСсылкиНаНеразделенныеДанныеПриВыгрузке(
					Контейнер,
					Объект[СтруктураИмениПоля[3]],
					Объект,
					ОбъектМетаданных,
					ПолеДляКонтроляСсылокНаНеразделенныеДанные);
				
			ИначеЕсли СтруктураИмениПоля[2] = "ТабличнаяЧасть" ИЛИ СтруктураИмениПоля[2] = "TabularSection" Тогда // Не локализуется
				
				ИмяТабличнойЧасти = СтруктураИмениПоля[3];
				
				Если СтруктураИмениПоля[4] = "Реквизит" ИЛИ СтруктураИмениПоля[4] = "Attribute" Тогда // Не локализуется
					
					ИмяРеквизита = СтруктураИмениПоля[5];
					
					Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
						
						КонтрольСсылкиНаНеразделенныеДанныеПриВыгрузке(
							Контейнер,
							СтрокаТабличнойЧасти[ИмяРеквизита],
							Объект,
							ОбъектМетаданных,
							ПолеДляКонтроляСсылокНаНеразделенныеДанные);
						
					КонецЦикла;
					
				Иначе
					
					ВызватьИсключение НСтр("ru = 'Некорректный кэш контроля неразделенных данных при выгрузке.'");
					
				КонецЕсли;
				
			Иначе
				
				ВызватьИсключение НСтр("ru = 'Некорректный кэш контроля неразделенных данных при выгрузке.'");
				
			КонецЕсли;
			
		ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
			
			Если СтруктураИмениПоля[2] = "Измерение" ИЛИ СтруктураИмениПоля[2] = "Dimension"
					ИЛИ СтруктураИмениПоля[2] = "Ресурс" ИЛИ СтруктураИмениПоля[2] = "Resource"
					ИЛИ СтруктураИмениПоля[2] = "Реквизит" ИЛИ СтруктураИмениПоля[2] = "Attribute" Тогда // Не локализуется
				
				Для Каждого Запись Из Объект Цикл
					
					КонтрольСсылкиНаНеразделенныеДанныеПриВыгрузке(
						Контейнер,
						Запись[СтруктураИмениПоля[3]],
						Объект,
						ОбъектМетаданных,
						ПолеДляКонтроляСсылокНаНеразделенныеДанные);
					
				КонецЦикла;
				
			Иначе
				
				ВызватьИсключение НСтр("ru = 'Некорректный кэш контроля неразделенных данных при выгрузке.'");
				
			КонецЕсли;
			
		Иначе
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Объект метаданных %1 не поддерживается.'", Метаданные.ОсновнойЯзык.КодЯзыка),
				ПолноеИмяОбъектаМетаданных);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура КонтрольСсылкиНаНеразделенныеДанныеПриВыгрузке(Контейнер, Знач ПроверяемаяСсылка, Знач ИсходныйОбъект, Знач ИсходныйОбъектМетаданных, Знач ИмяПоля)
	
	Если Не ЗначениеЗаполнено(ПроверяемаяСсылка) Тогда
		// Если значение реквизита не заполнено - контроль не требуется
		Возврат;
	КонецЕсли;
	
	ТипЗначения = ТипЗнч(ПроверяемаяСсылка);
	
	Если Не ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
		// Контроль требуется только для значений ссылочного типа
		Возврат;
	КонецЕсли;
	
	ОбъектМетаданных = ПроверяемаяСсылка.Метаданные();
	
	Если ОбщегоНазначенияБТС.ЭтоПеречисление(ОбъектМетаданных) Тогда
		// Для ссылок на элементы перечислений используется один и тот же уникальный идентификатор
		// во всех информационных базах одной конфигурации - поэтому для них не требуется выполнять
		// сопоставление ссылок при загрузке.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектМетаданных) Тогда
		Если ПроверяемаяСсылка.Предопределенный Тогда
			// Сопоставление ссылок на предопределенные элементы выполняется отдельным механизмом
			// (см. общий модуль ВыгрузкаЗагрузкаПредопределенныхДанных).
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбъектМетаданныхРазделенХотьОднимРазделителем(ОбъектМетаданных, Контейнер.ДополнительныеСвойства.ЛокальныйКэшСоставовРазделителей) Тогда
		// Разделенные данные будут загружены с сохранением оригинальных уникальных идентификаторов (для объектов,
		// разделенных разделителями с типом разделения "Независимо и совместно" все ссылки будут сгенерированы заново).
		Возврат;
	КонецЕсли;
	
	Если Контейнер.ДополнительныеСвойства.ОбщиеДанныеТребующиеСопоставленияСсылок.Найти(ОбъектМетаданных) <> Неопределено Тогда
		// Если разработчик указал для объекта метаданных состав полей естественного ключа - сопоставление
		// ссылок при загрузке будет выполнено по значениям полей естественного ключа.
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.СсылкаСуществует(ПроверяемаяСсылка) Тогда
		// Наличие "битых" ссылок не диагностирует ошибку разработчика по обеспечению сопоставления ссылок
		// при загрузке.
		Возврат;
	КонецЕсли;
	
	ШаблонОшибки =
		НСтр("ru = 'Объект метаданных %1 включен в перечень объектов, для которых не требуется сопоставление ссылок при выгрузке / загрузке
              |данных (в переопределяемой процедуре 
              |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(),
              |но при этом для него не обеспечивается требования отсутствия несопоставляемых ссылок при выгрузке.
              |
              |Несопоставляемая ссылка обнаружена при выгрузке объекта %2, у которого в качестве значения реквизита %3
              |установлена ссылка на объект %1, которая не сможет быть корректно сопоставлена при загрузке данных.
              |Требуется пересмотреть логику использования объекта %1 и обеспечить для него отсутствие несопоставляемых ссылок
              |в выгружаемых данных.
              |
              |Диагностическая информация:
              |1. Сериализация выгружаемого объекта:
              |---------------------------------------------------------------------------------------------------------------------------
              |%4
              |---------------------------------------------------------------------------------------------------------------------------
              |2. Сериализация объекта несопоставляемой ссылки
              |---------------------------------------------------------------------------------------------------------------------------
              |%5
              |---------------------------------------------------------------------------------------------------------------------------'");
	
	ТекстОшибки = СтрШаблон(
		ШаблонОшибки,
		ОбъектМетаданных,
		ИсходныйОбъектМетаданных,
		ИмяПоля,
		ОбщегоНазначения.ЗначениеВСтрокуXML(ИсходныйОбъект),
		ОбщегоНазначения.ЗначениеВСтрокуXML(ПроверяемаяСсылка.ПолучитьОбъект()));
	
	ВызватьИсключение ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

