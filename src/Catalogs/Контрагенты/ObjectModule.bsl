
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ОбновитьДанныеКонтрагентаВАдреснойКниге;
Перем ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге;
Перем ОбновитьДанныеОтображенияКонтрагентаВАдреснойКниге;
Перем ОбновитьДоступностьВПоискеПоКонтрагенту;

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда 
		ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыКонтрагентаПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Ссылка, "Наименование, ГруппаДоступа, ПометкаУдаления, Родитель, КонтактнаяИнформация");
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	СтароеНаименование = "";
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		СтароеНаименование = РеквизитыКонтрагентаПоСсылке.Наименование;
	КонецЕсли;	
	ДополнительныеСвойства.Вставить("СтароеНаименование", СтароеНаименование);
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = РеквизитыКонтрагентаПоСсылке.ПометкаУдаления;
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
	
	// Обновление адресной книги.
	ОбновитьДанныеКонтрагентаВАдреснойКниге = Ложь;
	ОбновитьДанныеОтображенияКонтрагентаВАдреснойКниге = Ложь;
	ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге = Ложь;
	ОбновитьДоступностьВПоискеПоКонтрагенту = Ложь;
	
	Если ЭтоНовый() Тогда
		ОбновитьДанныеКонтрагентаВАдреснойКниге = Истина;
		Если НЕ ЭтоГруппа Тогда
			ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге = Истина;
		КонецЕсли;
	Иначе
		Если РеквизитыКонтрагентаПоСсылке.Родитель <> Родитель Тогда
			ОбновитьДанныеКонтрагентаВАдреснойКниге = Истина;
		КонецЕсли;
		Если РеквизитыКонтрагентаПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбновитьДанныеКонтрагентаВАдреснойКниге = Истина;
			ОбновитьДанныеОтображенияКонтрагентаВАдреснойКниге = Истина;
		КонецЕсли;
		Если РеквизитыКонтрагентаПоСсылке.Наименование <> Наименование Тогда
			ОбновитьДанныеОтображенияКонтрагентаВАдреснойКниге = Истина;
			ОбновитьДанныеКонтрагентаВАдреснойКниге = Истина;
		КонецЕсли;
		
		Если НЕ ЭтоГруппа Тогда
			Если РеквизитыКонтрагентаПоСсылке.Наименование <> Наименование Тогда
				ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге = Истина;
			КонецЕсли;
			Если НЕ ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге Тогда
				СтараяКонтактнаяИнформация = РеквизитыКонтрагентаПоСсылке.
					КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
				НоваяКонтактнаяИнформация = КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
				Для Каждого СтрИнфо ИЗ НоваяКонтактнаяИнформация Цикл
					Если СтараяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
						ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если НЕ ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге Тогда
					Для Каждого СтрИнфо ИЗ СтараяКонтактнаяИнформация Цикл
						Если НоваяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
							ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если РеквизитыКонтрагентаПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбновитьДоступностьВПоискеПоКонтрагенту = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда 
		КПП = "";
		КодПоОКПО = "";
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда 
		КПП = "";
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда 
		ИНН = "";
		КПП = "";
		КодПоОКПО = "";
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		Если Не ЭтоКонтролирующийОрган
			Или Не ПолучитьФункциональнуюОпцию("ИспользоватьОтчетностьВКонтролирующиеОрганы")
			Или ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
			ЭтоКонтролирующийОрган = Ложь;
			ТипКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПустаяСсылка();
			КодКонтролирующегоОргана = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СтароеНаименование = ДополнительныеСвойства.СтароеНаименование;
	Если ЗначениеЗаполнено(СтароеНаименование) И СтароеНаименование <> Наименование Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсходящиеДокументы.Ссылка КАК Ссылка,
		|	ИсходящиеДокументы.Получатели.(
		|		НомерСтроки,
		|		Получатель КАК Контрагент
		|	) КАК Контрагенты
		|ИЗ
		|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИсходящиеДокументы.Получатели КАК ИсходящиеДокументыПолучатели
		|		ПО ИсходящиеДокументы.Ссылка = ИсходящиеДокументыПолучатели.Ссылка
		|ГДЕ
		|	ИсходящиеДокументыПолучатели.Получатель = &Контрагент
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВнутренниеДокументы.Ссылка,
		|	ВнутренниеДокументы.Контрагенты.(
		|		НомерСтроки,
		|		Контрагент
		|	)
		|ИЗ
		|	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВнутренниеДокументы.Контрагенты КАК ВнутренниеДокументыКонтрагенты
		|		ПО ВнутренниеДокументы.Ссылка = ВнутренниеДокументыКонтрагенты.Ссылка
		|ГДЕ
		|	ВнутренниеДокументыКонтрагенты.Контрагент = &Контрагент";
		
		Запрос.УстановитьПараметр("Контрагент", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			КонтрагентыДляСписков = Делопроизводство.ПолучитьКонтрагентовДляСписков(
				Выборка.Контрагенты.Выгрузить());
			РегистрыСведений.ОбщиеРеквизитыДокументов.ЗаписатьОбщийРеквизитДокумента(
				Выборка.Ссылка, "КонтрагентыДляСписков", КонтрагентыДляСписков);
		КонецЦикла;	
		
	КонецЕсли;	
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	Если ДополнительныеСвойства.Свойство("ДанныеКонтактногоЛица")
		И ТипЗнч(ДополнительныеСвойства.ДанныеКонтактногоЛица) = Тип("Структура") Тогда
		ДанныеКонтактногоЛица = ДополнительныеСвойства.ДанныеКонтактногоЛица;
		
		КонтактноеЛицо = Справочники.КонтактныеЛица.СоздатьЭлемент();
		Если ЭтоНовый() Тогда
			СсылкаНового = ПолучитьСсылкуНового();
			Если НЕ ЗначениеЗаполнено(СсылкаНового) Тогда
				СсылкаНового = Справочники.Контрагенты.ПолучитьСсылку();
			КонецЕсли;
			УстановитьСсылкуНового(СсылкаНового);
			КонтактноеЛицо.Владелец = СсылкаНового;
		Иначе
			КонтактноеЛицо.Владелец = Ссылка;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(КонтактноеЛицо, ДанныеКонтактногоЛица);
		КонтактноеЛицо.Наименование = ДанныеКонтактногоЛица.Фамилия 
			+ ?(ЗначениеЗаполнено(ДанныеКонтактногоЛица.Имя), " " + ДанныеКонтактногоЛица.Имя, "")
			+ ?(ЗначениеЗаполнено(ДанныеКонтактногоЛица.Отчество), " " + ДанныеКонтактногоЛица.Отчество, "");
		УстановитьПривилегированныйРежим(Истина);
		КонтактноеЛицо.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	// Обновление адресной книги
	Если ОбновитьДанныеКонтрагентаВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка,
			Родитель,
			Справочники.АдреснаяКнига.Контрагенты,
			Ссылка);
	КонецЕсли;
	Если ОбновитьДанныеОтображенияКонтрагентаВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОтображенияПодчиненногоОбъекта(Ссылка);
	КонецЕсли;
	Если ОбновитьСловаПоискаПоКонтрагентуВАдреснойКниге Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоКонтрагенту(ЭтотОбъект);
	КонецЕсли;
	Если ОбновитьДоступностьВПоискеПоКонтрагенту Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьДоступностьВПоиске(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеКонтрагента);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЭтоГруппа
		И ЭтоКонтролирующийОрган
		И ПолучитьФункциональнуюОпцию("ИспользоватьОтчетностьВКонтролирующиеОрганы") Тогда
		
		ПроверяемыеРеквизиты.Добавить("ТипКонтролирующегоОргана");
		ПроверяемыеРеквизиты.Добавить("КонтролирующийОрган");
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли