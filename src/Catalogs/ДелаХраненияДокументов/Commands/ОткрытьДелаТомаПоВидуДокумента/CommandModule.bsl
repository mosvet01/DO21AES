
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ВидДокумента", ПараметрКоманды);
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.Форма.ФормаДелаТомаПоВидуДокумента", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
