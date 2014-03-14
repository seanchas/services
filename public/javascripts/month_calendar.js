i18n.ru.current = 'Текущий'
i18n.en.current = 'Current'

var MonthCalendar = Class.create({
  
  initialize: function(view, input, options) {
    this.view     = $(view);
    this.input    = $(input);
    this.options  = Object.extend({
      input_format:   '%Y-%m-%d',
      view_format:    '%m, %Y',
      week_offset:    1
    }, options || {});
    
    this.start();
  },
  
  start: function() {
    this.init();
    this.bound();
    this.build();
    this.update();
    this.render();
    this.observe();
  },
  
  init: function() {
    this.inputDate = Calendar.parse($F(this.input));
    if (this.inputDate == Calendar.InvalidDate)
      this.inputDate = new Date();
    this.date = this.inputDate;
  },
  
  bound: function() {
    this.boundRenderMonth         = this.boundRenderMonth         || this.renderMonth.bind(this);
    this.boundOnDateChange        = this.boundOnDateChange        || this.onDateChange.bind(this);
    this.boundOnViewClick         = this.boundOnViewClick         || this.onViewClick.bind(this);
    this.boundOnDocumentClick     = this.boundOnDocumentClick     || this.onDocumentClick.bind(this);
    this.boundOnDocumentKeyPress  = this.boundOnDocumentKeyPress  || this.onDocumentKeyPress.bind(this);
  },
  
  build: function() {
    this.calendar = {};
    
    this.calendar.container = new Element('div', { 'class': 'month_calendar' });
    this.calendar.element   = new Element('div', { 'class': 'inner' });

    this.calendar.table     = new Element('table');
    this.calendar.thead     = new Element('thead');
    this.calendar.tbody     = new Element('tbody');
    
    this.buildTitle();
    this.buildLinks();
    this.buildMonths();

    this.calendar.table.insert(this.calendar.thead);
    this.calendar.table.insert(this.calendar.tbody);
    
    this.calendar.element.insert(this.calendar.table);
    this.calendar.container.insert(this.calendar.element);
    
    this.hide();
    
    $(document.body).insert(this.calendar.container);
  },
  
  render: function() {
    this.cleanup();
    this.renderTitle();
    this.renderLinks();
    this.renderMonths();
  },
  
  update: function() {
    this.input.value = i18n.l(this.date, this.options['input_format']);
    this.view.update(i18n.l(this.date, this.options['view_format']));
  },
  
  show: function() {
    this.calendar.container.show();
  },
  
  hide: function() {
    this.calendar.container.hide();
  },
  
  buildTitle: function() {
    this.calendar.titleRow  = new Element('tr', { 'class': 'title' });
    this.calendar.title     = new Element('td', { 'colspan': 5 }).update('&nbsp;');
    
    this.calendar.titleRow.insert(this.calendar.title);
    this.calendar.thead.insert(this.calendar.titleRow);
  },
  
  buildLinks: function() {
    this.calendar.linksRow = new Element('tr', { 'class': 'links' });
    
    this.calendar.prevYearLink  = new Element('td', { 'class': 'link prev_year' }).update('&laquo;');
    this.calendar.nextYearLink  = new Element('td', { 'class': 'link next_year' }).update('&raquo;');
    this.calendar.currentLink   = new Element('td', { 'class': 'link current' }).update(i18n[i18n.get_locale()].current);
    
    this.calendar.linksRow.insert(this.calendar.prevYearLink);
    this.calendar.linksRow.insert(this.calendar.currentLink);
    this.calendar.linksRow.insert(this.calendar.nextYearLink);
    
    this.calendar.thead.insert(this.calendar.linksRow);
  },

  buildMonths: function() {
    this.calendar.rows = $R(0, 3).collect(function(i) {
      return new Element('tr', { 'class': 'row' });
    });

    this.calendar.rows.each(function(row) {
      this.calendar.tbody.insert(row);
    }.bind(this));

    this.calendar.months = this.calendar.rows.collect(function(row) {
        return $R(0, 2).collect(function() {
            var month = new Element('td', { 'class': 'month' }).update('&nbsp;');
            row.insert(month)
            return month
        }.bind(this, row));

    }.bind(this)).flatten();
  },
  
  cleanup: function() {
    this.calendar.months.invoke('removeClassName', 'current');
    this.calendar.months.invoke('removeClassName', 'selected');
  },
  
  renderTitle: function() {
    this.calendar.title.update(i18n.l(this.date, '%Y'))
  },
  
  renderLinks: function() {
    this.calendar.prevYearLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year - 1, this.date_parts().month, 1), '%Y-%m-%d'));
    this.calendar.nextYearLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year + 1, this.date_parts().month, 1), '%Y-%m-%d'));
    this.calendar.currentLink.writeAttribute('data-date', i18n.l(new Date(), '%Y-%m-01'));
  },

  renderMonths: function() {
    $R(0, 11).each(this.boundRenderMonth);
  },

  renderMonth: function(index) {
    var now  = new Date();
    var date = new Date(this.date.getFullYear(), index, 1);
    var cell = this.calendar.months[index];

    if (date.getFullYear() == now.getFullYear() && date.getMonth() == now.getMonth())
      cell.addClassName('current');

    if (date.getFullYear() == this.input_date_parts().year && date.getMonth() == this.input_date_parts().month)
      cell.addClassName('selected');

    cell.writeAttribute('data-date', i18n.l(date, '%Y-%m-%d'));

    cell.update(i18n.l(date, '%G'));
  },

  observe: function() {
    this.calendar.container.on('click', 'td.link, td.month', this.boundOnDateChange);
    this.view.on('click', this.boundOnViewClick);

    document.on('click', this.boundOnDocumentClick);
    $(document.body).on('keydown', this.boundOnDocumentKeyPress);
  },
  
  onDateChange: function(e, element) {
    this.date         = Calendar.parse(element.readAttribute('data-date'));
    this._date_parts  = null;
    this.render();

    if (element.hasClassName('month')) {
      this.inputDate          = this.date;
      this._input_date_parts  = null;
      this.update();
      this.hide();
	  (this.options.updateCallback || Prototype.emptyFunction)(this.input.value);
    }
  },
  
  onViewClick: function(e, element) {
    e.stop();
    this.render();
    
    var cdimensions = this.calendar.container.getDimensions();
    var tdimensions = this.view.getDimensions();
    
    this.calendar.container.clonePosition(this.view, {
      setHeight: false,
      setWidth: false,
      offsetLeft: -((cdimensions.width - tdimensions.width) / 2),
      offsetTop: -((cdimensions.height - tdimensions.height) / 2)
    });
    
    this.show();
  },
  
  onDocumentClick: function(e, element) {
    if (!element.hasClassName('.month_calendar') && !element.up('.month_calendar'))
      this.hide();
  },
  
  onDocumentKeyPress: function(e, element) {
    if (e.keyCode == Event.KEY_ESC)
      this.hide();
  },

  date_parts: function() {
    return this._date_parts = this._date_parts || {
      year:   this.date.getFullYear(),
      month:  this.date.getMonth(),
      day:    this.date.getDate()
    }
  },
  
  input_date_parts: function() {
    return this._input_date_parts = this._input_date_parts || {
      year:   this.date.getFullYear(),
      month:  this.date.getMonth(),
      day:    this.date.getDate()
    }
  }
  
});



Object.extend(Calendar, {
  
  InvalidDate: new Date(''),
  
  parse: function(string) {
    if (string.blank())
      return Calendar.InvalidDate;

    var parts = string.match(/^(\d{4})-(\d{2})-(\d{2})[.(\d{2}):(\d{2}):(\d{2})(.*)]?$/)
    
    if (parts) {
      parts = parts.without(string);
      return new Date(
        parseInt(parts[0], 10),
        parseInt(parts[1], 10) - 1,
        parseInt(parts[2], 10),
        parseInt(parts[3], 10) || 0,
        parseInt(parts[4], 10) || 0,
        parseInt(parts[5], 10) || 0
      );
    }
    
    return Calendar.InvalidDate;
  }
  
});
