#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеУдалятьИсториюАвтоОтветов") Тогда
		РегистрыСведений.АвтоматическиеОтветыПоАдресам.УдалитьЗаписиПоПравилу(Ссылка)
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Отсутствие") Тогда
		Основание = ДанныеЗаполнения;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли