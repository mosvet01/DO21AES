
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Наименование = Параметры.Наименование;
	
	ИдентификаторСкрипта = Параметры.ИдентификаторСкрипта;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	Если ИдентификаторСкрипта <> УникальныйИдентификаторПустой() Тогда
		Скрипт = РегистрыСведений.СкриптыСхемКомплексныхПроцессов.СкриптСхемы(
			Параметры.Схема, ИдентификаторСкрипта);
	КонецЕсли;
	
	Элементы.ГруппаПроверка.Видимость = Параметры.ПоказыватьОбластьПроверки;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Скрипт.ТолькоПросмотр = Истина;
		Элементы.ГруппаОтступКнопки.Видимость = Ложь;
		Элементы.ГруппаДеревоРеквизитовОбъекта.Видимость = Ложь;
		Элементы.ГруппаНетПрав.Видимость = Ложь;
		
		Элементы.Готово.Видимость = Ложь;
		Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.Отмена.КнопкаПоУмолчанию = Истина;
		
		КлючСохраненияПоложенияОкна = "ТолькоПросмотр";
		
		Если Параметры.ПоказыватьОбластьПроверки Тогда
			КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_ПоказыватьОбластьПроверки";
		КонецЕсли;
		
	Иначе
		
		ЕстьПравоНаРаботуСоСкриптами = ПравоДоступа("Изменение",
			Метаданные.РегистрыСведений.СкриптыСхемКомплексныхПроцессов);
		
		Если ЕстьПравоНаРаботуСоСкриптами Тогда
			
			Если ИдентификаторСкрипта = УникальныйИдентификаторПустой() Тогда
				ИдентификаторСкрипта = Новый УникальныйИдентификатор;
				Скрипт = Параметры.СкриптПоУмолчанию;
			КонецЕсли;
			
			ЗаполнитьДеревоРеквизитовОбъекта();
			
			Элементы.ГруппаНетПрав.Видимость = Ложь;
			
		Иначе
			Элементы.Скрипт.ТолькоПросмотр = Истина;
			Элементы.ГруппаОтступКнопки.Видимость = Ложь;
			Элементы.ГруппаДеревоРеквизитовОбъекта.Видимость = Ложь;
		КонецЕсли;
		
		Если ЕстьПравоНаРаботуСоСкриптами Тогда
			КлючСохраненияПоложенияОкна = "ЕстьПравоНаРаботуСоСкриптами";
			Если Параметры.ПоказыватьОбластьПроверки Тогда
				КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_ПоказыватьОбластьПроверки";
			КонецЕсли;
		Иначе
			КлючСохраненияПоложенияОкна = "НетПраваНаРаботуСоСкриптами";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроцессПриИзменении(Элемент)
	
	ПроверитьВыражениеСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоРеквизитовОбъекта

&НаКлиенте
Процедура ДеревоРеквизитовОбъектаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Скрипт = Скрипт + " " + Элемент.ТекущиеДанные.ПолныйПуть;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьРеквизитИзДерева(Команда)
	
	Если Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные <> Неопределено Тогда
		Скрипт = Скрипт + " "
			+ Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные.ПолныйПуть;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано наименование'"),, "Наименование");
		
		Возврат;
	КонецЕсли;
	
	Если ЕстьПравоНаРаботуСоСкриптами Тогда
		
		Если Не ЗначениеЗаполнено(Скрипт) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено выражение'"),, "Скрипт");
			
			Возврат;
		КонецЕсли;
		
		ЗаписатьТекстВыражения(Параметры.Схема, ИдентификаторСкрипта, Скрипт);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ИдентификаторСкрипта", ИдентификаторСкрипта);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Записывает текст скрипта в базу.
// Если у пользователя нет прав, то будет выдано исключение.
//
// Параметры:
//  см. описание в РегистрыСведений.СкриптыСхемКомплексныхПроцессов.ЗаписатьСкриптСхемы.
//
&НаСервереБезКонтекста
Процедура ЗаписатьТекстВыражения(Схема, ИдентификаторСкрипта, Скрипт)
	
	РегистрыСведений.СкриптыСхемКомплексныхПроцессов.ЗаписатьСкриптСхемы(
		Схема, ИдентификаторСкрипта, Скрипт);
	
КонецПроцедуры

// Заполняет дерево ДеревоРеквизитовОбъекта метаданными комплексного процесса.
//
&НаСервере
Процедура ЗаполнитьДеревоРеквизитовОбъекта()
	
	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитовОбъекта");
	
	Дерево.Строки.Очистить();
	
	ПолныйПуть = "Процесс";
	НоваяСтрокаВладелецФайла = Дерево.Строки.Добавить();
	НоваяСтрокаВладелецФайла.НаименованиеРеквизита = "КомплексныйПроцесс";
	НоваяСтрокаВладелецФайла.ТипРеквизита = "КомплексныйПроцесс";
	НоваяСтрокаВладелецФайла.ПолныйПуть = ПолныйПуть;
	
	ПроцессОбъект = Метаданные.БизнесПроцессы.КомплексныйПроцесс;
	Для Каждого СтандартныйРеквизит Из ПроцессОбъект.СтандартныеРеквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = СтандартныйРеквизит.Имя;
		Строка.ТипРеквизита = СтандартныйРеквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + СтандартныйРеквизит.Имя;
	КонецЦикла;
	Для Каждого Реквизит Из ПроцессОбъект.Реквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = Реквизит.Имя;
		Строка.ТипРеквизита = Реквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + Реквизит.Имя;
	КонецЦикла;
	Для Каждого ТабличнаяЧасть Из ПроцессОбъект.ТабличныеЧасти Цикл
		СтрокаТабличнаяЧасть = НоваяСтрокаВладелецФайла.Строки.Добавить();
		СтрокаТабличнаяЧасть.НаименованиеРеквизита = ТабличнаяЧасть.Имя;
		СтрокаТабличнаяЧасть.ТипРеквизита = "Табличная часть";
		СтрокаТабличнаяЧасть.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]";
		Для Каждого СтандартныйРеквизитТЧ Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = СтандартныйРеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = СтандартныйРеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + СтандартныйРеквизитТЧ.Имя; 
		КонецЦикла;
		Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = РеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = РеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + РеквизитТЧ.Имя;
		КонецЦикла; 
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРеквизитовОбъекта");
	
КонецПроцедуры

// Проверяет скрипт (выражение на встроенном языке) и отображает его
// результат в форме (реквизит ИтогПроверки).
//
&НаСервере
Процедура ПроверитьВыражениеСервер()
	
	Результат = Неопределено;
	ИтогПроверки = "";
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Для Каждого ИмяРазделителя Из РаботаВМоделиСервиса.РазделителиКонфигурации() Цикл
			УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		УстановитьБезопасныйРежим(Истина);
		Выполнить(Скрипт);
		УстановитьБезопасныйРежим(Ложь);
	Исключение
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		
		Описание = "";
		Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
			Описание = Инфо.Причина.Описание;
		Иначе
			Описание = Инфо.Описание;
		КонецЕсли;
		
		ИтогПроверки = НСтр("ru = 'Ошибка.'") + Символы.ВК + Описание;
		Возврат;
	КонецПопытки;
	
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		ИтогПроверки = НСтр("ru = 'Ошибка.
			|Переменной ""Результат"" необходимо присвоить значение типа ""Булево""'");
		Возврат;
	КонецЕсли;
	
	ИтогПроверки = ?(Результат, НСтр("ru = 'Истина'"), НСтр("ru = 'Ложь'"));
	
КонецПроцедуры

#КонецОбласти