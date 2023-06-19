///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов организации и при ее выборе.
//
// Параметры:
//  Параметры - Структура:
//
//    * ТипОрганизации - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых
//                       можно сделать выбор. Начальное значение ОпределяемыйТип.Организация.
//                     - Неопределено  - возвращаемое значение. Выбор организации не поддерживается.
//
//    * Организация - СправочникСсылка - организация из ТипОрганизации, которую нужно заполнить.
//                    Если организация уже заполнена, требуется перезаполнить ее свойства - например,
//                    при повтором вызове, когда пользователь выбрал другую организацию.
//                  - Неопределено - если ТипОрганизации не настроен.
//                    Пользователю недоступен выбор организации.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - возвращаемое значение:
//                    Ложь   - начальное значение - указанная организация является юридическим лицом;
//                    Истина - указанная организация является индивидуальным предпринимателем.
//
//    * ЭтоИностраннаяОрганизация - Булево - возвращаемое значение, когда Истина ОГРН не заполняется.
//                                - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеСокращенное  - Строка - возвращаемое значение. Краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеПолное       - Строка - возвращаемое значение. Краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                      - Строка - возвращаемое значение. ИНН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП                      - Строка - возвращаемое значение. КПП организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ОГРН                     - Строка - возвращаемое значение. ОГРН организации (кроме иностранных).
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * РасчетныйСчет            - Строка - возвращаемое значение. Основной расчетный счет организации для договора.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * БИК                      - Строка - возвращаемое значение. БИК банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КорреспондентскийСчет    - Строка - возвращаемое значение. Корреспондентский счет банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон                  - Строка - возвращаемое значение. Телефон организации в формате JSON, как его
//                                 возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//
//    * ЮридическийАдрес - Строка - возвращаемое значение. Юридический адрес организации в формате JSON, как его
//                         возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт
	
	ЗаявлениеНаСертификатДокументооборот.ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры);
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнении реквизитов владельца и при его выборе.
//
// Параметры:
//  Параметры - Структура:
//    * ЭтоФизическоеЛицо - Булево - если Истина, тогда заявление заполняется для физического лица, иначе для организации.
// 
//    * Организация  - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                   - Неопределено - если ТипОрганизации не настроен или составной и тип организации не выбран.
//
//    * ТипВладельца  - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых можно сделать выбор.
//                    - Неопределено  - возвращаемое значение. Выбор владельца не поддерживается.
//
//    * Сотрудник    - СправочникСсылка - возвращаемое значение. Владелец сертификата из ТипВладельца,
//                     которого нужно заполнить. Если уже заполнен (выбран пользователем), его не следует изменять.
//                   - Неопределено - если ТипВладельца не определен, тогда реквизит не доступен пользователю.
//
//    * Директор     - СправочникСсылка - возвращаемое значение. Директор из ТипВладельца, который может быть
//                     выбран, как владелец сертификата. Не учитывается, если заявление для ИП или физического лица.
//                   - Неопределено - начальное значение - скрыть директора из списка выбора.
//
//    * ГлавныйБухгалтер - СправочникСсылка - возвращаемое значение. Главный бухгалтер из ТипВладельца, который может
//                     быть выбран как владелец сертификата. Не учитывается, если заявление для ИП или физического лица.
//                   - Неопределено - начальное значение - скрыть главного бухгалтера из списка выбора.
//
//    * Пользователь - СправочникСсылка.Пользователи - возвращаемое значение. Пользователь - владелец сертификата.
//                     В общем случае может быть не заполнено. Рекомендуется заполнить, если есть возможность.
//                     Записывается в сертификат в поле Пользователь, может быть изменено в дальнейшем.
//
//    * Фамилия            - Строка - возвращаемое значение. Фамилия сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Имя                - Строка - возвращаемое значение. Имя сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Отчество           - Строка - возвращаемое значение. Отчество сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДатаРождения       - Дата   - возвращаемое значение. Дата рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Пол                - Строка - возвращаемое значение. Пол сотрудника "Мужской" или "Женский".
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * МестоРождения      - Строка - возвращаемое значение. Описание места рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Гражданство        - СправочникСсылка.СтраныМира - возвращаемое значение. Гражданство сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                - Строка - возвращаемое значение. ИНН физического лица.
//                           Учитывается только в заявлении для физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * СтраховойНомерПФР  - Строка - возвращаемое значение. СНИЛС сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Должность          - Строка - возвращаемое значение. Должность сотрудника в организации.
//                           Не учитывается, если заявление для ИП или физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Подразделение      - Строка - возвращаемое значение. Обособленное подразделение организации, в котором
//                           работает сотрудник. Не учитывается, если заявление для ИП или физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументВид        - Строка - возвращаемое значение. Строки "21" или "91". 21 - паспорт гражданина РФ,
//                           91 - иной документ, предусмотренный законодательством РФ (по СПДУЛ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументНомер      - Строка - возвращаемое значение. Номер документа сотрудника (серия и
//                           номер для паспорта гражданина РФ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументКемВыдан   - Строка - возвращаемое значение. Кем выдан документ сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументКодПодразделения - Строка - возвращаемое значение. Код подразделения, если вид документа 21.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДокументДатаВыдачи - Дата   - возвращаемое значение. Дата выдачи документа сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * АдресРегистрации   - Строка - возвращаемое значение. Адрес постоянной или временной регистрации
//                           физического лица (минимум регион, населенный пункт) в формате JSON, как его возвращает
//                           функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                           Учитывается только в заявлении для физического лица.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ЭлектроннаяПочта   - Строка - возвращаемое значение. Адрес электронной почты сотрудника в формате JSON, как его
//                           возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон            - Строка - возвращаемое значение. Телефон физического лица в формате JSON, как его
//                           возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                           Учитывается только в заявлении для физического лица.
//
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
	ЗаявлениеНаСертификатДокументооборот.ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры);
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов руководителя и при его выборе.
// Только для юридического лица. Для индивидуального предпринимателя и физического лица не требуется.
//
// Параметры:
//  Параметры - Структура:
//    * Организация   - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                    - Неопределено - если ТипОрганизации не настроен.
//
//    * ТипРуководителя - ОписаниеТипов - возвращаемое значение. Содержит ссылочные типы, из которых можно сделать выбор.
//                      - Неопределено  - возвращаемое значение. Выбор партнера не поддерживается.
//
//    * Руководитель  - СправочникСсылка - это значение из ТипРуководителя, выбранное пользователем,
//                      по которому нужно заполнить должность.
//                    - Неопределено - ТипРуководителя не определен.
//                    - ЛюбаяСсылка - возвращаемое значение. Руководитель, который будет подписывать документы.
//
//    * Представление - Строка - возвращаемое значение. Представление руководителя.
//                    - Неопределено - получить представление от значения Руководитель.
//
//    * Должность     - Строка - возвращаемое значение. Должность руководителя, который будет подписывать документы.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Основание     - Строка - возвращаемое значение. Основание на котором действует
//                      должностное лицо (устав, доверенность, ...).
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
	
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов партнера и при его выборе.
//
// Параметры:
//  Параметры - Структура:
//    * ЭтоФизическоеЛицо - Булево - если Истина, тогда заявление заполняется для физического лица, иначе для организации.
//
//    * Организация   - СправочникСсылка - выбранная организация из ТипОрганизации, на которую оформляется сертификат.
//                    - Неопределено - если ТипОрганизации не настроен.
//
//    * ТипПартнера   - ОписаниеТипов - содержит ссылочные типы из которых можно сделать выбор.
//                    - Неопределено - выбор партнера не поддерживается.
//
//    * Партнер       - СправочникСсылка - это контрагент (обслуживающая организация) из ТипПартнера,
//                      выбранный пользователем, по которому нужно заполнить реквизиты, описанные ниже.
//                    - Неопределено - ТипПартнера не определен.
//                    - ЛюбаяСсылка - возвращаемое значение. Значение, сохраняемое в заявке для истории.
//
//    * Представление - Строка - возвращаемое значение. Представление партнера.
//                    - Неопределено - получить представление от значения Партнер.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - возвращаемое значение:
//                      Ложь   - начальное значение - указанный партнер является юридическим лицом,
//                      Истина - указанный партнер является индивидуальным предпринимателем.
//
//    * ИНН           - Строка - возвращаемое значение. ИНН партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП           - Строка - возвращаемое значение. КПП партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
