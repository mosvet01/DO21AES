
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовоеПисьмо = Параметры.ЭтоНовоеПисьмо;
	СсылкаПисьма = Параметры.СсылкаПисьма;
	
	Если Параметры.Свойство("СписокСохраненныхТекстовПисьма") Тогда
		
		Для Каждого Строка Из Параметры.СписокСохраненныхТекстовПисьма Цикл
			НоваяСтрока = СписокСохраненныхТекстовПисьма.Добавить();
			НоваяСтрока.ПолныйПутьФайла = Строка.ПолныйПутьФайла;
		КонецЦикла;	
		
	КонецЕсли;	
	
	Если Параметры.Свойство("УникальныйИдентификаторРодительскойФормы") Тогда
		
		УникальныйИдентификаторРодительскойФормы = Параметры.УникальныйИдентификаторРодительскойФормы;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоНовоеПисьмо Тогда
		
		Для Каждого СтрокаСпискаФайлов Из СписокСохраненныхТекстовПисьма Цикл
			
			Файл = Новый Файл(СтрокаСпискаФайлов.ПолныйПутьФайла);
			
			Если Файл.Существует() Тогда
			
				Строка = ТаблицаВерсий.Добавить();
				Строка.ДатаСохранения = Файл.ПолучитьВремяИзменения();
				Строка.РазмерТекста = Файл.Размер();
				Строка.ПолныйПутьФайла = СтрокаСпискаФайлов.ПолныйПутьФайла;
				
			КонецЕсли;
			
			
		КонецЦикла;	
		
	Иначе
		
#Если Не ВебКлиент Тогда		
		Каталог = КаталогВременныхФайлов();
		Каталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог, 
			ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
			
		МаскаПоиска = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"v8cln_Автосохранение_Сохр_%1_*.*",
			Строка(СсылкаПисьма.УникальныйИдентификатор()));
			
		МассивФайлов = НайтиФайлы(Каталог, МаскаПоиска);
		
		Для Каждого Файл Из МассивФайлов Цикл
			
			Если Файл.Существует() Тогда
			
				Строка = ТаблицаВерсий.Добавить();
				Строка.ДатаСохранения = Файл.ПолучитьВремяИзменения();
				Строка.РазмерТекста = Файл.Размер();
				Строка.ПолныйПутьФайла = Файл.ПолноеИмя;
				
			КонецЕсли;
			
		КонецЦикла;	
#КонецЕсли		
		
	КонецЕсли;	
	
	ТаблицаВерсий.Сортировать("ДатаСохранения Убыв");
	
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Элементы.ТаблицаВерсий.ТекущиеДанные <> Неопределено Тогда
		ПолныйПутьФайла = Элементы.ТаблицаВерсий.ТекущиеДанные.ПолныйПутьФайла;
		ЗапуститьПриложение(ПолныйПутьФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	ВосстановитьВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьВыполнить()
	
	Если Элементы.ТаблицаВерсий.ТекущиеДанные <> Неопределено Тогда
		ПолныйПутьФайла = Элементы.ТаблицаВерсий.ТекущиеДанные.ПолныйПутьФайла;
		Закрыть();
		Оповестить("ВыбранФайлДляВосстановленияТекста", ПолныйПутьФайла, УникальныйИдентификаторРодительскойФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВерсийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВосстановитьВыполнить();
	
КонецПроцедуры
