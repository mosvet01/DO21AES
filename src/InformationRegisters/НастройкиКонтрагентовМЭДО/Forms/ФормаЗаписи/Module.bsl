#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Контрагент") И ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		
		ЗаписьВРегистре = РегистрыСведений.НастройкиКонтрагентовМЭДО.СоздатьМенеджерЗаписи();
		ЗаписьВРегистре.Контрагент = Параметры.Контрагент;
		ЗаписьВРегистре.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьВРегистре.Контрагент) Тогда
			ЗначениеВДанныеФормы(ЗаписьВРегистре, Запись);
		Иначе // Нет в БД, это новая запись:
			Запись.Контрагент = Параметры.Контрагент;
		КонецЕсли;
		
		ИдентификаторМЭДО = ИнтеграцияСМЭДО.ИдентификаторВнешнегоОбъекта(
			Запись.Контрагент, МЭДО.Обозначение_ВнешнийКонтрагент());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписьНастроекМЭДО", Запись.Контрагент, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИдентификаторМенялся Тогда
		ИнтеграцияСМЭДО.СоздатьПроверитьСвязьОбъектаИБИВнешнегоОбъекта(
			ИдентификаторМЭДО, МЭДО.Обозначение_ВнешнийКонтрагент(), Запись.Контрагент);
		ИдентификаторМенялся = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификаторМЭДОПриИзменении(Элемент)
	
	ИдентификаторМенялся = Истина;
	
КонецПроцедуры

#КонецОбласти