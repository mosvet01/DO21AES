///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Сохраняет настройки автообновления списка
//
Процедура СохранитьНастройкиАвтообновленияСписка(ИмяФормы, ИмяСписка, Настройки) Экспорт
	
	КлючОбъекта = ИмяФормы + ".Автообновление." + ПолучитьСкоростьКлиентскогоСоединения();
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, ИмяСписка, Настройки);
	
КонецПроцедуры

// Сохраняет настройки автообновления Формы
//
Процедура СохранитьНастройкиАвтообновленияФормы(ИмяФормы, Настройки) Экспорт
	
	КлючОбъекта = ИмяФормы + ".Автообновление";
	КлючНастройки = Строка(ПолучитьСкоростьКлиентскогоСоединения());
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, КлючНастройки, Настройки);
	
КонецПроцедуры

#КонецОбласти