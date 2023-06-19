#Область ПрограммныйИнтерфейс

//Кеширует на время сеанса признак "ЭтоМобильныйКлиент"
//
// Возвращаемое значение:
// Булево - приложение запущено на мобильном устройстве: Истина/Ложь
Функция ЭтоМобильныйКлиент() Экспорт
	
	Возврат ОбщегоНазначения.ЭтоМобильныйКлиент();

КонецФункции

//Кеширует на время сеанса признак, обозначающий является ли устройство фаблетом или планшетом
//
// Возвращаемое значение:
// Булево - является ли устройство телефоном: Истина/Ложь
Функция ЭтоНеТелефон() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ТипУстройства() <> "Телефон";

КонецФункции

////Кеширует на время сеанса признак, обозначающий является ли устройство телефоном или фаблетом
//
// Возвращаемое значение:
// Булево - является ли устройство телефоном: Истина/Ложь
Функция ЭтоНеПланшет() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ТипУстройства() <> "Планшет";

КонецФункции

#КонецОбласти
