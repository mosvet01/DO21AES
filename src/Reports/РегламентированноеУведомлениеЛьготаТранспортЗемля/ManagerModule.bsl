#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.КНД = "1150064";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеЛьготаТранспортЗемля.Форма.Форма2019_1";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 25.07.2019 № ММВ-7-21/377@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2019_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2019_1" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2019_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2019_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2019_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Данные.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
		Данные.Вставить("ПодписантИмя", Объект.ПодписантИмя);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(СведенияОтправки)
	Префикс = "UT_PRORGLZTRNAL";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	ОТЧ = Новый ОписаниеТипов("Число");
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИНН) 
		Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Истина, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Титульная.КПП, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан КПП", "Титульная", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
		Если Не ЗначениеЗаполнено(Данные.ПодписантИмя) Или Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан подписант", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		КонецЕсли;
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО))
		Или СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Титульная.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ)
		И (Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Или Не ЗначениеЗаполнено(Данные.ПодписантИмя))Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны фамилия/имя представителя", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.СпособИнфРез) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан способ информирования налогоплательщика о результатах рассмотрения настоящего заявления", "Титульная", "СпособИнфРез"));
	КонецЕсли;
	
	ЕстьЗаполненныеЛисты = Ложь;
	Для Каждого Лист0Итер Из Данные.ДанныеМногостраничныхРазделов.Транспорт Цикл
		Лист0 = Лист0Итер.Значение;
		Страница0Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист0);
		ТекЗаполнена = Страница0Заполнена;
		Если Страница0Заполнена Тогда 
			ЕстьЗаполненныеЛисты = Истина;
		КонецЕсли;
		Для Каждого Лист1Итер Из Данные.ДанныеМногостраничныхРазделов.ЛьготаДокументТранспорт Цикл
			Лист1 = Лист1Итер.Значение;
			Если Лист1.УИДРодителя <> Лист0.УИД Тогда 
				Продолжить;
			КонецЕсли;
			Страница1Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист1);
			Если Не Страница1Заполнена И Не Страница0Заполнена Тогда 
				Продолжить;
			КонецЕсли;
			Если Страница1Заполнена Тогда 
				ЕстьЗаполненныеЛисты = Истина;
			КонецЕсли;
			Если Страница1Заполнена И Не Страница0Заполнена Тогда 
				Страница0Заполнена = Истина;
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена страница", "Транспорт", "ВидТС", Лист0.УИД));
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Лист1.НаимДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнено наименование документа ", "ЛьготаДокументТранспорт", "НаимДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ВыдДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен орган или лицо, выдавшее документ ", "ЛьготаДокументТранспорт", "ВыдДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ДатаДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата документа", "ЛьготаДокументТранспорт", "ДатаДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ПрПериодДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен период действия документа", "ЛьготаДокументТранспорт", "ПрПериодДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ДатаНачПериод) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата начала действия документа", "ЛьготаДокументТранспорт", "ДатаНачПериод", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.НомерДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен номер документа", "ЛьготаДокументТранспорт", "НомерДок", Лист1.УИД));
			КонецЕсли;
			
			Если Лист1.ПрПериодДок = "1" Тогда 
				Если ЗначениеЗаполнено(Лист1.ДатаКонПериод) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("При бессрочном периоде действия дата окончания не указывается", "ЛьготаДокументТранспорт", "ДатаКонПериод", Лист1.УИД));
				КонецЕсли;
			ИначеЕсли Лист1.ПрПериодДок = "2" Тогда 
				Если Не ЗначениеЗаполнено(Лист1.ДатаКонПериод) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата окончания действия документа", "ЛьготаДокументТранспорт", "ДатаКонПериод", Лист1.УИД));
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(Лист1.ПрПериодДок) Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно заполнен период действия документа", "ЛьготаДокументТранспорт", "ПрПериодДок", Лист1.УИД));
			КонецЕсли;
		КонецЦикла;
		
		Если Не ТекЗаполнена Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Лист0.ВидТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен вид транспортного средства", "Транспорт", "ВидТС", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.РегЗнакТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен регистрационный знак", "Транспорт", "РегЗнакТС", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.КодНалЛьготТр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен код налоговой льготы", "Транспорт", "КодНалЛьготТр", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.ДатаНачСр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата начала действия льготы", "Транспорт", "ДатаНачСр", Лист0.УИД));
		КонецЕсли;
		
		Если "30200" = Лист0.КодНалЛьготТр Тогда
			Если ЗначениеЗаполнено(Лист0.ДатаЗакон) Или ЗначениеЗаполнено(Лист0.НомерЗакон) Или ЗначениеЗаполнено(Лист0.СтруктЕдЗакон) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("При коде льготы 30200 сведения о законе не заполняются", "Транспорт", "ДатаЗакон", Лист0.УИД));
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(Лист0.ДатаЗакон) Или ЗначениеЗаполнено(Лист0.НомерЗакон) Или ЗначениеЗаполнено(Лист0.СтруктЕдЗакон) Тогда 
				Если Не ЗначениеЗаполнено(Лист0.ДатаЗакон) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата закона", "Транспорт", "ДатаЗакон", Лист0.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Лист0.НомерЗакон) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен номер закона", "Транспорт", "НомерЗакон", Лист0.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Лист0.СтруктЕдЗакон) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена структурная единица", "Транспорт", "СтруктЕдЗакон", Лист0.УИД));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Лист0.СтруктЕдЗакон) И СтрДлина(СокрЛП(Лист0.СтруктЕдЗакон)) <> 24 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Структурная единица должна иметь длину 24 знака", "Транспорт", "СтруктЕдЗакон", Лист0.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Лист0Итер Из Данные.ДанныеМногостраничныхРазделов.Земля Цикл
		Лист0 = Лист0Итер.Значение;
		Страница0Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист0);
		ТекЗаполнена = Страница0Заполнена;
		Если Страница0Заполнена Тогда 
			ЕстьЗаполненныеЛисты = Истина;
		КонецЕсли;
		Для Каждого Лист1Итер Из Данные.ДанныеМногостраничныхРазделов.ЛьготаДокументЗемля Цикл
			Лист1 = Лист1Итер.Значение;
			Если Лист1.УИДРодителя <> Лист0.УИД Тогда 
				Продолжить;
			КонецЕсли;
			Страница1Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист1);
			Если Не Страница1Заполнена И Не Страница0Заполнена Тогда 
				Продолжить;
			КонецЕсли;
			Если Страница1Заполнена Тогда 
				ЕстьЗаполненныеЛисты = Истина;
			КонецЕсли;
			Если Страница1Заполнена И Не Страница0Заполнена Тогда 
				Страница0Заполнена = Истина;
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена страница", "Земля", "НомКадастрЗУ", Лист0.УИД));
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Лист1.НаимДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнено наименование документа ", "ЛьготаДокументЗемля", "НаимДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ВыдДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен орган или лицо, выдавшее документ ", "ЛьготаДокументЗемля", "ВыдДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ДатаДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата документа", "ЛьготаДокументЗемля", "ДатаДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ПрПериодДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен период действия документа", "ЛьготаДокументЗемля", "ПрПериодДок", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.ДатаНачПериод) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата начала действия документа", "ЛьготаДокументЗемля", "ДатаНачПериод", Лист1.УИД));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Лист1.НомерДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен номер документа", "ЛьготаДокументЗемля", "НомерДок", Лист1.УИД));
			КонецЕсли;
			
			Если Лист1.ПрПериодДок = "1" Тогда 
				Если ЗначениеЗаполнено(Лист1.ДатаКонПериод) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("При бессрочном периоде действия дата окончания не указывается", "ЛьготаДокументЗемля", "ДатаКонПериод", Лист1.УИД));
				КонецЕсли;
			ИначеЕсли Лист1.ПрПериодДок = "2" Тогда 
				Если Не ЗначениеЗаполнено(Лист1.ДатаКонПериод) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата окончания действия документа", "ЛьготаДокументЗемля", "ДатаКонПериод", Лист1.УИД));
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(Лист1.ПрПериодДок) Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно заполнен период действия документа", "ЛьготаДокументЗемля", "ПрПериодДок", Лист1.УИД));
			КонецЕсли;
		КонецЦикла;
		
		Если Не ТекЗаполнена Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Лист0.НомКадастрЗУ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен кадастровый номер земельного участка", "Земля", "НомКадастрЗУ", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.КодНалЛьготЗем) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен код налоговой льготы", "Земля", "КодНалЛьготЗем", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.ДатаНачСр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата начала действия льготы", "Земля", "ДатаНачСр", Лист0.УИД));
		КонецЕсли;
		
		чКодНалЛьготЗем = ОТЧ.ПривестиЗначение(Лист0.КодНалЛьготЗем);
		Если чКодНалЛьготЗем = 3029000 Или (чКодНалЛьготЗем >= 3021110 И чКодНалЛьготЗем <= 3021198) Тогда
			Если ЗначениеЗаполнено(Лист0.ДатаАкт) Или ЗначениеЗаполнено(Лист0.НомерАкт) Или ЗначениеЗаполнено(Лист0.СтруктЕдАкт) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("При коде льготы 3021110-3021198 и 3029000 сведения об акте не заполняются", "Земля", "ДатаАкт", Лист0.УИД));
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(Лист0.ДатаАкт) Или ЗначениеЗаполнено(Лист0.НомерАкт) Или ЗначениеЗаполнено(Лист0.СтруктЕдАкт) Тогда 
				Если Не ЗначениеЗаполнено(Лист0.ДатаАкт) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена дата акта", "Земля", "ДатаАкт", Лист0.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Лист0.НомерАкт) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен номер акта", "Земля", "НомерАкт", Лист0.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Лист0.СтруктЕдАкт) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнена структурная единица", "Земля", "СтруктЕдАкт", Лист0.УИД));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Лист0.СтруктЕдАкт) И СтрДлина(СокрЛП(Лист0.СтруктЕдАкт)) <> 24 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Структурная единица должна иметь длину 24 знака", "Земля", "СтруктЕдАкт", Лист0.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьЗаполненныеЛисты Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнены сведения о льготах", "Транспорт", "ВидТС", Данные.ДанныеМногостраничныхРазделов.Транспорт[0].Значение.УИД));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Ложь);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ТлфПодп", Данные.ДанныеУведомления.Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДанныеУведомления.Титульная.НаимДок);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	ДанныеУведомления.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
	ДанныеУведомления.Вставить("ПодписантИмя", Объект.ПодписантИмя);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2019_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2019_1");
	ЗаполнитьДанными_Форма2019_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ДополнитьПараметры_2019(Параметры)
КонецПроцедуры

Процедура ЗаполнитьДанными_Форма2019_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры_2019(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП, ВыводитьМакет = Истина, МакетПФ = Неопределено)
	Попытка
		Если МакетПФ = Неопределено Тогда 
			МакетПФ = Отчеты.РегламентированноеУведомлениеЛьготаТранспортЗемля.ПолучитьМакет(ИмяМакета);
		КонецЕсли;
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ, МакетПФ.Области, "-");
		КонецЕсли;
	КонецЦикла;
	
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
	ЗаполнитьЗначенияСвойств(МакетПФ.Параметры, СтруктураДанныхСтраницы);
	Если ВыводитьМакет Тогда 
		ПечатнаяФорма.Вывести(МакетПФ);
	КонецЕсли;
КонецПроцедуры

Процедура НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПарам, ПечатнаяФорма, НомСтр, ИННКПП)
	МакетыПФ = СтрПарам.МакетыПФ;
	ИмяМакета = СтрПарам.ИмяМакета;
	
	Если Не ЗначениеЗаполнено(МакетыПФ) И Не ЗначениеЗаполнено(ИмяМакета) Тогда 
		Для Каждого СтрПодч Из СтрПарам.Строки Цикл
			НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПодч, ПечатнаяФорма, НомСтр, ИННКПП);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МакетыПФ) Тогда 
		МассивИменМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МакетыПФ, ";");
	Иначе 
		МассивИменМакетов = Новый Массив;
		МассивИменМакетов.Добавить("ПФ_" + ИмяМакета);
	КонецЕсли;
	
	Если СтруктураПараметров.ДанныеУведомления.Свойство(СтрПарам.ИДНаименования) Тогда 
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл 
			СтруктураДанныхСтраницы = СтруктураПараметров.ДанныеУведомления[СтрПарам.ИДНаименования];
			Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(СтруктураДанныхСтраницы) Тогда
				НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП);
				Если СтрПарам.ИДНаименования = "Титульная" Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
					ПечатнаяФорма.Области.ЭлАдрес.Текст = СтруктураДанныхСтраницы.ЭлАдрес;
				КонецЕсли;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2019_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2019_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НомСтр = 1;
	НапечататьЛистыСвед(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП, "Печать_Форма2019_1_Транспорт", "Транспорт", "ЛьготаДокументТранспорт");
	НапечататьЛистыСвед(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП, "Печать_Форма2019_1_Земля", "Земля", "ЛьготаДокументЗемля");
	Возврат Листы;
КонецФункции

Процедура НапечататьЛистыСвед(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП, ИмяМакетаПФ, ДанныеУровень0, ДанныеУровень1)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеЛьготаТранспортЗемля.ПолучитьМакет(ИмяМакетаПФ);
		ОТЧ = Новый ОписаниеТипов("Число");
	Исключение
		Возврат;
	КонецПопытки;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ТекИнд = 1;
	Для Каждого Элт0 Из СтруктураПараметров.ДанныеМногостраничныхРазделов[ДанныеУровень0] Цикл
		Свед0 = Элт0.Значение;
		Если Не УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Свед0) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Элт1 Из СтруктураПараметров.ДанныеМногостраничныхРазделов[ДанныеУровень1] Цикл
			Свед1 = Элт1.Значение;
			Если Свед1.УИДРодителя <> Свед0.УИД Тогда 
				Продолжить;
			КонецЕсли;
			
			НапечататьСтруктуру(Свед0, НомСтр, ИмяМакетаПФ, ПечатнаяФорма, ИННКПП, Ложь, МакетПФ);
			НапечататьСтруктуру(Свед1, 0, ИмяМакетаПФ, ПечатнаяФорма, ИННКПП, Ложь, МакетПФ);
			ПечатнаяФорма.Вывести(МакетПФ);
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
