var i18n = {
  
  default_locale: 'ru',
  
  locales: ['ru', 'en'],
  
  ru: {
    
    date: {
      day_names: $w('Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота'),
      abbr_day_names: $w('Вс Пн Вт Ср Чт Пт Сб'),
      month_names: $w('Января Февраля Марта Апреля Мая Июня Июля Августа Сентября Октября Ноября Декабря'),
      abbr_month_names: $w('Янв. Фев. Мар. Апр. Мая Июн. Июл. Авг. Сен. Окт. Ноя. Дек.'),
      standalone_month_names: $w('Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'),
      
      formats: {
        'default': '',
        'order_form': '%e %B %Y г.'
      }
    }
    
  },
  
  en: {
    
    date: {
      day_names: $w('Sunday Monday Tuesday Wednesday Thursday Friday Saturday'),
      abbr_day_names: $w('Sun Mon Tue Wed Thu Fri Sat'),
      month_names: $w('January February March April May June July August September October November December'),
      abbr_month_names: $w('Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'),
      standalone_month_names: $w('January February March April May June July August September October November December'),
      
      formats: {
        'default': '',
        'order_form': '%e %B %Y'
      }
    }
    
  },
  
  set_locale: function(locale) {
    if (this.locales.include(locale))
      this.locale = locale;
  },
  
  get_locale: function() {
    return this.locale || this.default_locale;
  },
  
  l: function(object, format) {
    if (object instanceof Date) return this.l_date(object, format);
  },
  
  l_date: function(object, format) {
    return i18n._date.strftime(object, format);
  },
  
  _date: {
    
    strftime: function(date, format, locale) {
      locale = this._locale(locale);
      format = this._format(format, locale);
      return this._tokens(format).uniq().inject(format, function(container, token) {
        return container = container.gsub('%' + token, this._methods[token](date, locale));
      }.bind(this));
    },
    
    _locale: function(locale) {
      return i18n.locales.include(locale) ? locale : i18n.get_locale();
    },
    
    _format: function(format, locale) {
      if (!format) format = i18n[locale].date.formats['default'];
      return i18n[locale].date.formats[format] || format;
    },
    
    _tokens: function(format) {
      var tokens = [];

      format.scan(/%([aAbBdeGHIlmMSwyY%])/, function(token) {
        tokens.push(token[1]);
      });

      return tokens;
    },
    
    _methods: {
      
      'a': function(date, locale) {
        return i18n[locale].date.abbr_day_names[date.getDay()];
      },
      
      'A': function(date, locale) {
        return i18n[locale].date.day_names[date.getDay()];
      },
      
      'b': function(date, locale) {
        return i18n[locale].date.abbr_month_names[date.getMonth()];
      },
      
      'B': function(date, locale) {
        return i18n[locale].date.month_names[date.getMonth()];
      },
      
      'd': function(date, locale) {
        return date.getDate().toPaddedString(2);
      },
      
      'e': function(date) {
          return date.getDate().toString();
      },
      
      'G': function(date, locale) {
        return i18n[locale].date.standalone_month_names[date.getMonth()];
      },
      
      'H': function(date, locale) {
        return date.getHours().toPaddedString(2);
      },
      
      'I': function(date, locale) {
        return (date.getHours() % 12 || 12).toPaddedString(2);
      },
      
      'l': function(date, locale) {
        return date.getHours().toString();
      },
      
      'm': function(date, locale) {
        return (date.getMonth() + 1).toPaddedString(2);
      },
      
      'M': function(date, locale) {
        return date.getMinutes().toPaddedString(2);
      },
      
      'S': function(date, locale) {
        return date.getSeconds().toPaddedString(2);
      },
      
      'w': function(date, locale) {
        return date.getDay().toPaddedString(2);
      },
      
      'y': function(date, locale) {
        return (date.getFullYear() % 100).toPaddedString(2);
      },
      
      'Y': function(date, locale) {
        return date.getFullYear().toString();
      },
      
      '%': function(date, locale) {
        return ''
      }
    }
    
  }
  
};
