#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2020_1";
	Стр.КНД = "1165180";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2020_1";
	Стр.ОписаниеФормы = "По письму ФНС России от 28.10.2020 № АБ-4-19/17644@";
	Стр.ДатаНачала = '20201001';
	Стр.ДатаКонца = '20991231';
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2020_1" Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='формат не опубликован'"));
		Возврат Неопределено;
		Возврат ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru='формат не опубликован'"));
	Возврат Неопределено;
	Если ИмяФормы = "Форма2020_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2020_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2020_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2020_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2020_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(СведенияОтправки)
	Префикс = "IU_PRAKTSVERK";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
		Если Не ЗначениеЗаполнено(Титульная.ИНН) Или Не ЗначениеЗаполнено(Титульная.КПП) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан ИНН/КПП", "Титульная", "ИНН"));
		Иначе
			Если ЗначениеЗаполнено(Титульная.ИНН) И (Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Истина, "")) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Неправильно указан ИНН", "Титульная", "ИНН"));
			КонецЕсли;
			Если ЗначениеЗаполнено(Титульная.КПП) И (Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Титульная.КПП, "")) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Неправильно указан КПП", "Титульная", "КПП"));
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Титульная.ФЛБезИП = Истина Тогда 
		Если Не ЗначениеЗаполнено(Титульная.ИНН) Тогда
			Если Не ЗначениеЗаполнено(Титульная.КодВидДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Не указан код вида документа", "Титульная", "КодВидДок"));
			ИначеЕсли СтрНайти("$21$03$07$08$10$11$12$13$14$15$18$23$24$27$91$", "$" + Титульная.КодВидДок + "$") = 0 Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Неправильно указан код вида документа", "Титульная", "КодВидДок"));
			КонецЕсли;

			Если Не ЗначениеЗаполнено(Титульная.СерНомДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Не указана серия/номер документа", "Титульная", "СерНомДок"));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Титульная.ДатаДок) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Не указана дата выдачи документа", "Титульная", "ДатаДок"));
			КонецЕсли;
		Иначе
			Если (Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Ложь, "")) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Неправильно указан ИНН", "Титульная", "ИНН"));
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Титульная.ИНН) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан ИНН/КПП", "Титульная", "ИНН"));
		Иначе
			Если ЗначениеЗаполнено(Титульная.ИНН) И (Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Ложь, "")) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
					"Неправильно указан ИНН", "Титульная", "ИНН"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан налоговый орган", "Титульная", "КодНО"));
	ИначеЕсли Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО) Или СтрДлина(Титульная.КодНО) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Наименование) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указано наименование организации", "Титульная", "Наименование"));
	КонецЕсли;
	Если (Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Или (Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" И РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация)))
		И (Не ЗначениеЗаполнено(Объект.ПодписантФамилия) Или Не ЗначениеЗаполнено(Объект.ПодписантИмя)) Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Необходимо указать подписанта", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Необходимо указать документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Объект.ПодписантФамилия) И Не ЗначениеЗаполнено(Объект.ПодписантИмя))
		Или (Не ЗначениеЗаполнено(Объект.ПодписантФамилия) И ЗначениеЗаполнено(Объект.ПодписантИмя)) Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"У подписанта необходимо указать имя и фамилию", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "1" И Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "2" Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Неправильно указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Титульная.ПрСпособПолуч) И (Титульная.ПрСпособПолуч <> "1" И Титульная.ПрСпособПолуч <> "2") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Неправильно указан признак способа получения", "Титульная", "ПрСпособПолуч"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.Наименование) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указано наименование организации", "Титульная", "Наименование"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаНачПер) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата начала", "Титульная", "ДатаНачПер"));
	КонецЕсли;
	Если (Титульная.ПрКБК <> "1" И Титульная.ПрКБК <> "2") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан / неправильно указан признак КБК", "Титульная", "ПрКБК"));
	КонецЕсли;
	Если Титульная.ПрКБК = "2" Тогда 
		Если Не ЗначениеЗаполнено(Титульная.КБК) Или СтрДлина(Титульная.КБК) <> 20 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан / неправильно указан КБК", "Титульная", "КБК"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Процедура Проверить_Форма2020_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Данные = Объект.ДанныеУведомления.Получить();
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса()), "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ТлфПодп", Данные.ДанныеУведомления.Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННФЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("КПП", Данные.ДанныеУведомления.Титульная.КПП);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДанныеУведомления.Титульная.НаимДок);
	ОсновныеСведения.Вставить("ПрКБК", Данные.ДанныеУведомления.Титульная.ПрКБК);
	ОсновныеСведения.Вставить("КодВидДок", Данные.ДанныеУведомления.Титульная.КодВидДок);
	ОсновныеСведения.Вставить("ПрЗаяв", Данные.ДанныеУведомления.Титульная.ПрЗаяв);
	
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2020_1");
	ЗаполнитьДанными_Форма2020_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
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

Процедура ЗаполнитьДанными_Форма2020_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ДополнитьПараметры(Параметры)
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

Процедура НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеСверкаРасчетовПоНалогам.ПолучитьМакет(ИмяМакета);
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
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
	ПечатнаяФорма.Вывести(МакетПФ);
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
					Если Не ЗначениеЗаполнено(СтруктураДанныхСтраницы.НомерКорректировки) Тогда
						УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("0--", "НомерКорректировки", ПечатнаяФорма.Области);
					КонецЕсли;
				КонецЕсли;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2020_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2020_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
