
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Параметры.Организация;
	Представление.УстановитьТекст(Параметры.ТекстВыгрузки);
	
	РаспознатьФайлВыгрузки(Отказ);
КонецПроцедуры

&НаСервере
Функция ПолучитьОписаниеОтчетаПоИмени(ИмяОтчета)
	Для Каждого КЗ Из УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьСоответствиеВидовУведомленийИменамОтчетов() Цикл 
		Если КЗ.Значение = ИмяОтчета Тогда 
			Возврат КЗ.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
КонецФункции

&НаСервере
Процедура РаспознатьФайлВыгрузки(Отказ)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Представление.ПолучитьТекст());
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ВерсияФормата = "";
	КНД = "";
	ИНН = "";
	КодНО = "";
	
	Для Каждого Элемент Из ДокументDOM.ДочерниеУзлы Цикл 
		Если НРег(Элемент.ИмяУзла) = "файл" Тогда 
			Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
				Если НРег(Атрибут.ИмяУзла) = "версформ" Тогда
					ВерсияФормата = Атрибут.ЗначениеУзла;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого Элемент Из Элемент.ДочерниеУзлы Цикл
				Если НРег(Элемент.ИмяУзла) = "документ" Тогда
					Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
						Если НРег(Атрибут.ИмяУзла) = "кнд" Тогда
							КНД = Атрибут.ЗначениеУзла;
						КонецЕсли;
						Если НРег(Атрибут.ИмяУзла) = "кодно" Тогда
							КодНО = Атрибут.ЗначениеУзла;
						КонецЕсли;
					КонецЦикла;
					Для Каждого Элемент Из Элемент.ДочерниеУзлы Цикл
						Если НРег(Элемент.ИмяУзла) = "свнп" Тогда
							Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
								Если НРег(Атрибут.ИмяУзла) = "иннфл" Или НРег(Атрибут.ИмяУзла) = "инн" Или НРег(Атрибут.ИмяУзла) = "иннюл" Тогда
									ИНН = Атрибут.ЗначениеУзла;
								КонецЕсли;
							КонецЦикла;
							Для Каждого Элемент Из Элемент.ДочерниеУзлы Цикл
								Если НРег(Элемент.ИмяУзла) = "нпюл" Тогда
									Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
										Если НРег(Атрибут.ИмяУзла) = "иннюл" Или НРег(Атрибут.ИмяУзла) = "инн" Тогда
											ИНН = Атрибут.ЗначениеУзла;
										КонецЕсли;
									КонецЦикла;
								ИначеЕсли НРег(Элемент.ИмяУзла) = "нпфл" Тогда
									Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
										Если НРег(Атрибут.ИмяУзла) = "иннфл" Или НРег(Атрибут.ИмяУзла) = "инн" Тогда
											ИНН = Атрибут.ЗначениеУзла;
										КонецЕсли;
									КонецЦикла;
									Если Не ЗначениеЗаполнено(ИНН) Тогда 
										Для Каждого Элемент Из Элемент.ДочерниеУзлы Цикл
											Если НРег(Элемент.ИмяУзла) = "иннфл" Или НРег(Элемент.ИмяУзла) = "инн" Тогда
												ИНН = Элемент.ТекстовоеСодержимое;
											КонецЕсли;
										КонецЦикла;
									КонецЕсли;
								ИначеЕсли НРег(Элемент.ИмяУзла) = "нпип" Тогда
									Для Каждого Атрибут Из Элемент.Атрибуты Цикл 
										Если НРег(Атрибут.ИмяУзла) = "иннфл" Или НРег(Атрибут.ИмяУзла) = "инн" Тогда
											ИНН = Атрибут.ЗначениеУзла;
										КонецЕсли;
									КонецЦикла;
									Если Не ЗначениеЗаполнено(ИНН) Тогда 
										Для Каждого Элемент Из Элемент.ДочерниеУзлы Цикл
											Если НРег(Элемент.ИмяУзла) = "иннфл" Или НРег(Элемент.ИмяУзла) = "инн" Тогда
												ИНН = Элемент.ТекстовоеСодержимое;
											КонецЕсли;
										КонецЦикла;
									КонецЕсли;
								КонецЕсли;
							КонецЦикла;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	КНДФайла = КНД;
	ФорматФайла = ВерсияФормата;
	Если ЗначениеЗаполнено(КНД) И ЗначениеЗаполнено(ВерсияФормата) Тогда 
		Элементы.ИнформацияОФормате.Заголовок = "КНД: " + КНД + ", версия формата: " + ВерсияФормата;
		Элементы.ИнформацияОФормате.ЦветТекста = ЦветаСтиля.ЦветГиперссылкиБРО;
	Иначе
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Не удалось распознать документ");
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыXML") Тогда 
		КНДФайла = Параметры.ПараметрыXML.КНД;
		ФорматФайла = Параметры.ПараметрыXML.ВерсФорм;
		Если Параметры.ПараметрыXML.КНД <> КНД Тогда 
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю("КНД в файле на соответствует КНД уведомления, требуется файл с КНД " + Параметры.ПараметрыXML.КНД);
			Возврат;
		КонецЕсли;
		Если Параметры.ПараметрыXML.ВерсФорм <> ВерсияФормата Тогда 
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю("Версия формата в файле на соответствует версии формата текущего уведомления, требуется файл версии " + Параметры.ПараметрыXML.ВерсФорм);
			Возврат;
		КонецЕсли;
		ДоступныПараметрыЗагрузки = Истина;
	Иначе
		ДоступныПараметрыЗагрузки = Ложь;
	КонецЕсли;
	
	ИмяОтчета = УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьСоответствиеОтчетаПоКНД()[КНД];
	Если Не ЗначениеЗаполнено(ИмяОтчета) Тогда 
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Загрузка отчета с КНД " + КНД + " не поддерживается");
		Возврат;
	ИначеЕсли Метаданные.Отчеты.Найти(ИмяОтчета) = Неопределено Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю( "Загрузка отчета """ + ПолучитьОписаниеОтчетаПоИмени(ИмяОтчета) + """ не поддерживается");
		Возврат;
	КонецЕсли;
	
	МодульМенеджера = ОбщегоНазначения.ОбщийМодуль("Отчеты." + ИмяОтчета);
	Попытка
		ТаблицаПримененияФорматов = МодульМенеджера.ПолучитьТаблицуПримененияФорматов();
		ОтобранныеСтроки = ТаблицаПримененияФорматов.НайтиСтроки(Новый Структура("КНД, ВерсияФормата", КНД, ВерсияФормата));
		Если ОтобранныеСтроки.Количество() = 0 Тогда
			Элементы.ИнформацияОВозможностиЗагрузки.ЦветТекста = ЦветаСтиля.ЦветОшибкиВПротоколеБРО;
			Элементы.ФормаСоздать.Доступность = Ложь;
			ОписаниеОтчета = ПолучитьОписаниеОтчетаПоИмени(ИмяОтчета);
			Если ЗначениеЗаполнено(ОписаниеОтчета) Тогда 
				Элементы.ИнформацияОВозможностиЗагрузки.Заголовок = "Загрузка отчета """ + ОписаниеОтчета + """ не поддерживается";
			КонецЕсли;
			Возврат;
		КонецЕсли;
		ПолныйПутьКФорме = "Отчет." + ИмяОтчета + ".Форма." + ОтобранныеСтроки[0].ИмяФормы;
	Исключение
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю( "Загрузка отчета """ + ПолучитьОписаниеОтчетаПоИмени(ИмяОтчета) + """ не поддерживается");
		Возврат;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ИНН)
		И Метаданные.Справочники.Организации.Реквизиты.Найти("ИНН") <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИНН", ИНН);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ИНН = &ИНН
		|	И Не Организации.ПометкаУдаления";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			Организация = Выборка.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Организация.Видимость = Ложь;
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(КодНО) Тогда 
		РегистрацияВНалоговомОргане = УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьРегистрациюВИФНСПоКоду(КодНО, Организация);
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда 
		РегистрацияВНалоговомОргане = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Организация);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Необходимо указать организацию'"));
		Возврат;
	КонецЕсли;
	ПараметрыОткрытия = Новый Структура("Организация, ПредставлениеXML, РегистрацияВНалоговомОргане, КНДФайла, ФорматФайла", 
										Организация, Представление.ПолучитьТекст(), РегистрацияВНалоговомОргане,
										КНДФайла, ФорматФайла);
	ОткрытьФорму(ПолныйПутьКФорме, ПараметрыОткрытия, ВладелецФормы);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ДоступныПараметрыЗагрузки Тогда 
		ПараметрыОткрытия = Новый Структура("Организация, ПредставлениеXML, РегистрацияВНалоговомОргане, КНДФайла, ФорматФайла", 
											Организация, Представление.ПолучитьТекст(), РегистрацияВНалоговомОргане,
											КНДФайла, ФорматФайла);
		ВладелецФормы.ЗагрузитьИзXML(ПараметрыОткрытия);
		Отказ = Истина;
		ВладелецФормы.Активизировать();
		Попытка
			ВыполнитьОбработкуОповещения(ВладелецФормы.ОписаниеОповещенияОЗавершенииЗагрузки);
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
		КонецПопытки;
		Закрыть();
	КонецЕсли;
КонецПроцедуры
