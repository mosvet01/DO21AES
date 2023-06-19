
#Область ПрограмныйИнтерфейс

Процедура ПоставитьВОчередь(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОчередьСозданияОбъектовЭДО.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.КоличествоПопытокОбработки = 0;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция ДобавитьПопыткуОбработки(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОчередьСозданияОбъектовЭДО.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Документ = Документ;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.КоличествоПопытокОбработки = 
			МенеджерЗаписи.КоличествоПопытокОбработки + 1;
		МенеджерЗаписи.Записать();
		
		Возврат МенеджерЗаписи.КоличествоПопытокОбработки;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Процедура УдалитьИзОчереди(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОчередьСозданияОбъектовЭДО.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Документ = Документ;
	
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

#КонецОбласти
