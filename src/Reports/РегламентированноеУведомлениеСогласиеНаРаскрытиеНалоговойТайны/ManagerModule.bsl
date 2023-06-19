#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.КНД = "1110058";
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
	Возврат "Отчет.РегламентированноеУведомлениеСогласиеНаРаскрытиеНалоговойТайны.Форма.Форма2017_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.ОписаниеФормы = "Форма согласия на раскрытие налоговой тайны в соответствии с приказом ФНС России от 15.11.2016 N ММВ-7-17/615@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2017_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2017_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2017_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2017_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Объект, Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(СведенияОтправки)
	Префикс = "IU_SOGNTOB";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Объект, Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
		Если Не ЗначениеЗаполнено(Титульная.ИНН) Или Не ЗначениеЗаполнено(Титульная.КПП) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН/КПП", "Титульная", "ИНН"));
		Иначе
			Если ЗначениеЗаполнено(Титульная.ИНН) И (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН) Или СтрДлина(Титульная.ИНН) <> 10) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульная", "ИНН"));
			КонецЕсли;
			Если ЗначениеЗаполнено(Титульная.КПП) И (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КПП) Или СтрДлина(Титульная.КПП) <> 9) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП", "Титульная", "КПП"));
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "4" Тогда 
		Если Не ЗначениеЗаполнено(Титульная.ИНН) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН", "Титульная", "ИНН"));
		ИначеЕсли Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН) Или СтрДлина(Титульная.ИНН) <> 12 Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульная", "ИНН"));
		КонецЕсли;
	ИначеЕсли Титульная.ПРИЗНАК_НП_ПОДВАЛ = "3" Тогда 
		Если Не ЗначениеЗаполнено(Титульная.КодВидДок) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код документа", "Титульная", "КодВидДок"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Титульная.СерНомДок) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана серия и номер документа", "Титульная", "СерНомДок"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Титульная.ДатаДок) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата выдачи документа", "Титульная", "ДатаДок"));
		КонецЕсли;
		Если ЗначениеЗаполнено(Титульная.ИНН) И (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН) Или СтрДлина(Титульная.ИНН) <> 12) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульная", "ИНН"));
		КонецЕсли;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
		Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "3" Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Коды 2 и 3 не могут быть использованы организацией", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
		КонецЕсли;
	Иначе
		Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Код 1 не может быть использован физичеким лицом", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Титульная", "КодНО"));
	ИначеЕсли Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО) Или СтрДлина(Титульная.КодНО) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Наименование) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации/ФИО физлица", "Титульная", "Наименование"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаНачПер) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата начала", "Титульная", "ДатаНачПер"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПризСвед) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак на титульной странице", "Титульная", "ПризСвед"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если (Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "4")
		И (Не ЗначениеЗаполнено(Объект.ПодписантФамилия) Или Не ЗначениеЗаполнено(Объект.ПодписантИмя)) Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Необходимо указать подписанта", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если (Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "1" И Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "2" И Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "3" И Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "4") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если (Титульная.ПризСвед <> "1" И Титульная.ПризСвед <> "2") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан признак сведений", "Титульная", "ПризСвед"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "4" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	
	Если Титульная.ПризСвед = "2" Тогда
		ЕстьДС = Ложь;
		Есть1400 = Ложь;
		Для Каждого Стр Из Данные.ДанныеДопСтрокБД.МнгСтр Цикл
			Если ЗначениеЗаполнено(Стр.КодСвед) Тогда 
				ЕстьДС = Истина;
				Если Стр.КодСвед = "1400" Тогда 
					Есть1400 = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьДС Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны коды признаков", "Лист002", "КодСвед___1"));
		КонецЕсли;
		Если Есть1400 И Не ЗначениеЗаполнено(Данные.ДанныеУведомления.Лист002.ТекстСвед) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана информация по коду 1400", "Лист002", "ТекстСвед"));
		КонецЕсли;
	КонецЕсли;
	Возврат ТаблицаОшибок;
КонецФункции

Процедура Проверить_Форма2017_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
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
	ОсновныеСведения.Вставить("ТекстСвед", Данные.ДанныеУведомления.Лист002.ТекстСвед);
	ОсновныеСведения.Вставить("ПризСвед", Данные.ДанныеУведомления.Титульная.ПризСвед);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Объект, ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2017_1");
	ЗаполнитьДанными_Форма2017_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
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

Процедура ЗаполнитьДанными_Форма2017_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	ЗаполнитьМногострочнуюЧасть(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ЗаполнитьМногострочнуюЧасть(ДанныеУведомления, ДеревоВыгрузки)
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_СоглНТОбщ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "СоглНТОбщ");
	Узел_КодСвед = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СоглНТОбщ, "КодСвед");
	Если Узел_КодСвед = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр Из ДанныеУведомления.ДанныеДопСтрокБД.МнгСтр Цикл
		Если ЗначениеЗаполнено(Стр.КодСвед) Тогда 
			НовУзел_КодСвед = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_КодСвед);
			Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(НовУзел_КодСвед, Стр.КодСвед);
		КонецЕсли;
	КонецЦикла;
	РегламентированнаяОтчетность.УдалитьУзел(Узел_КодСвед);
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
		МакетПФ = Отчеты.РегламентированноеУведомлениеСогласиеНаРаскрытиеНалоговойТайны.ПолучитьМакет(ИмяМакета);
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(КЗ.Значение), КЗ.Ключ, МакетПФ.Области, "-");
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
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантФамилия), "ПодпФ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантИмя), "ПодпИ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантОтчество), "ПодпО", ПечатнаяФорма.Области, "-");
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

Функция СформироватьСписокЛистовФорма2017_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2017_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантФамилия), "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантИмя), "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Объект.ПодписантОтчество), "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Лист002"], НомСтр, "Печать_Форма2017_1_Лист002", ПечатнаяФорма, ИННКПП);
	Инд = 0;
	Для Каждого Стр Из СтруктураПараметров.ДанныеДопСтрокБД.МнгСтр Цикл
		Если ЗначениеЗаполнено(Стр.КодСвед) Тогда 
			Инд = Инд + 1;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(Стр.КодСвед), "КодСвед_" + Инд, ПечатнаяФорма.Области, "-");
		КонецЕсли;
		
		Если Инд = 96 Тогда 
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Пока Инд < 96 Цикл 
		Инд = Инд + 1;
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("----", "КодСвед_" + Инд, ПечатнаяФорма.Области, "-");
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
