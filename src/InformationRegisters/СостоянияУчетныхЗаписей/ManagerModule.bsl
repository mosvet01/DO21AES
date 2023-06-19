// Записывает настройку отложенной отправки писем.
//
Функция ЗаписатьСобытие(УчетнаяЗапись, Операция, Дата, ОперацияУспешноЗавершена, Комментарий) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СостоянияУчетныхЗаписей.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.Операция = Операция;
	Запись.Прочитать();
	
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.Операция = Операция;
	Запись.Дата = Дата;
	Запись.ОперацияУспешноЗавершена = ОперацияУспешноЗавершена;
	Запись.Комментарий = Комментарий;
	Запись.Записать(Истина);
	
КонецФункции
