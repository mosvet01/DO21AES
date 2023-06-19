
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ОписаниеЗадачи") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеЗадачи = Параметры.ОписаниеЗадачи;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Закрыть(ОписаниеЗадачи);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКоманд

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	Элементы.ОписаниеЗадачи.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элементы.ОписаниеЗадачи.Высота = 0;
	Элементы.ОписаниеЗадачи.РастягиватьПоВертикали = Истина;
	
КонецПроцедуры

#КонецОбласти