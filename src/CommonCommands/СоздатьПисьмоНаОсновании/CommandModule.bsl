&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИспользованиеЛегкойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеЛегкойПочты");
	ИспользованиеВстроеннойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеВстроеннойПочты");
	
	Если Не ИспользованиеЛегкойПочты И Не ИспользованиеВстроеннойПочты Тогда
		ТекстСообщения = НСтр("ru = 'Для отправки письма требуется включить использование встроенной или легкой почты.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрано ни одного объекта для отправки по почте!'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ИспользованиеВстроеннойПочты Тогда	
		
		КоличествоПараметров = ПараметрКоманды.Количество();
		ПоследнийПараметр = ПараметрКоманды[КоличествоПараметров-1];
		
		Если ТипЗнч(ПоследнийПараметр) = Тип("СправочникСсылка.Пользователи") Тогда 
			ВстроеннаяПочтаКлиент.СоздатьПисьмоНаОснованииПользователей(ПараметрКоманды);
		Иначе 
			ВстроеннаяПочтаКлиент.СоздатьПисьмоНаОсновании(ПоследнийПараметр);
		КонецЕсли;
		
	ИначеЕсли ИспользованиеЛегкойПочты Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Объекты", ПараметрКоманды);
		ОткрытьФорму(
			"Обработка.ПочтовоеСообщение.Форма.Форма",
			ПараметрыОткрытия,,
			Новый УникальныйИдентификатор);
			
	КонецЕсли;
	
КонецПроцедуры
