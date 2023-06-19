
&НаКлиенте
Процедура Заполнить(Команда)
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ЗавершениеЗаполнить", ЭтотОбъект, Список);
		
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Перезаполнение состава субъектов прав доступа может занять продолжительное время.
			|Продолжить?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗаполнить(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПояснения =
		НСтр("ru = 'Выполняется перезаполнение состава субъектов.
			|Пожалуйста, подождите...'");
	Состояние(ТекстПояснения);
	ЗаполнитьНаСервере();
	ТекстПояснения =
		НСтр("ru = 'Состав субъектов заполнен.'");
	Состояние(ТекстПояснения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьНаСервере()
	
	РегистрыСведений.СоставСубъектовПравДоступа.ОбновитьВсеДанные(Истина);
	
КонецПроцедуры
