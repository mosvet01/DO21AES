&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СпособУказанияВремени = УчетВремени.ПолучитьСпособУказанияВремени();
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
		Элементы.Длительность.Видимость = Истина;
		Элементы.Начало.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
	Иначе
		Элементы.Длительность.Видимость = Ложь;
		Элементы.Начало.Видимость = Истина;
		Элементы.Окончание.Видимость = Истина;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	ПериодОтбора = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	УстановитьОтборПериодаНаСервере();
	
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	МК_НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборПериодаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтбораПриИзменении(Элемент)
	
	УстановитьОтборПериодаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПериодаНаСервере()
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаДобавленияНачало", ПериодОтбора.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаДобавленияКонец", ПериодОтбора.ДатаОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления(Элемент)
	
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Список.Шапка = Ложь;
	Элементы.ФормаОбновить.Видимость = Ложь;
	Элементы.Проект.Видимость = Ложь;
	
	Элементы.МК_ГруппаКолонок.Видимость = Истина;
	
	Элементы.Переместить(Элементы.ОписаниеРаботы, Элементы.ГруппаОписаниеДлительность);
	Элементы.Переместить(Элементы.Длительность, Элементы.ГруппаОписаниеДлительность);
	
	Элементы.Переместить(Элементы.ВидРабот, Элементы.ГруппаВидРаботДата);
	Элементы.Переместить(Элементы.ДатаДобавления, Элементы.ГруппаВидРаботДата);
	
	Элементы.Длительность.Ширина = 8;
	Элементы.ДатаДобавления.Ширина = 8;
	
	Элементы.ДатаДобавления.Формат = НСтр("ru='ДФ=''dd.MM.yy'''");
	
КонецПроцедуры
