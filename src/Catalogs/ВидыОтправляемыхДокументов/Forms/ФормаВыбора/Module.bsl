
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект.Ссылка;
		
КонецПроцедуры // ОбработкаЗаписиНового()

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект;
		
КонецПроцедуры // СписокОбработкаЗаписиНового() 

#КонецОбласти