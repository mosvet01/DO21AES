
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Проверка на заполненность поля ВидДокумента
	Если НЕ ЗначениеЗаполнено(ВладелецФайла) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Владелец файла"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ВладелецФайла", ,Отказ);
	КонецЕсли;	
	
КонецПроцедуры
