i18n.ru.today = 'Сегодня';
i18n.en.today = 'Today';

var MonthCalendar = Class.create({
  
  initialize: function(view, input, options) {
    this.view     = $(view);
    this.input    = $(input);
    this.options  = Object.extend({
      input_format:   '%Y-%m-%d',
      view_format:    '%d.%m.%Y',
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
    this.boundRenderDay           = this.boundRenderDay           || this.renderDay.bind(this);
    this.boundOnDateChange        = this.boundOnDateChange        || this.onDateChange.bind(this);
    this.boundOnViewClick         = this.boundOnViewClick         || this.onViewClick.bind(this);
    this.boundOnDocumentClick     = this.boundOnDocumentClick     || this.onDocumentClick.bind(this);
    this.boundOnDocumentKeyPress  = this.boundOnDocumentKeyPress  || this.onDocumentKeyPress.bind(this);
  },
  
  build: function() {
    this.calendar = {};
    
    this.calendar.container = new Element('div', { 'class': 'calendar' });
    this.calendar.element   = new Element('div', { 'class': 'inner' });

    this.calendar.table     = new Element('table');
    this.calendar.thead     = new Element('thead');
    this.calendar.tbody     = new Element('tbody');
    this.calendar.tfoot     = new Element('tfoot');
    
    this.buildTitle();
    this.buildLinks();
    
    this.buildWeek();
    this.buildWeeks();
    this.buildDays();
    
    this.calendar.table.insert(this.calendar.thead);
    this.calendar.table.insert(this.calendar.tbody);
    this.calendar.table.insert(this.calendar.tfoot);
    
    this.calendar.element.insert(this.calendar.table);
    this.calendar.container.insert(this.calendar.element);
    
    this.hide();
    
    $(document.body).insert(this.calendar.container);
  },
  
  render: function() {
    this.cleanup();
    this.renderTitle();
    this.renderLinks();
    this.renderDays();
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
    this.calendar.title     = new Element('td', { 'colspan': 7 }).update('&nbsp;');
    
    this.calendar.titleRow.insert(this.calendar.title);
    this.calendar.thead.insert(this.calendar.titleRow);
  },
  
  buildLinks: function() {
    this.calendar.linksRow = new Element('tr', { 'class': 'links' });
    
    this.calendar.prevYearLink  = new Element('td', { 'class': 'link prev_year' }).update('&laquo;');
    this.calendar.nextYearLink  = new Element('td', { 'class': 'link next_year' }).update('&raquo;');
    this.calendar.prevMonthLink = new Element('td', { 'class': 'link prev_month' }).update('&lsaquo;');
    this.calendar.nextMonthLink = new Element('td', { 'class': 'link next_month' }).update('&rsaquo;');
    this.calendar.todayLink     = new Element('td', { 'colspan': 3, 'class': 'link next_year' }).update(i18n[i18n.get_locale()].today);
    
    this.calendar.linksRow.insert(this.calendar.prevYearLink);
    this.calendar.linksRow.insert(this.calendar.prevMonthLink);
    this.calendar.linksRow.insert(this.calendar.todayLink);
    this.calendar.linksRow.insert(this.calendar.nextMonthLink);
    this.calendar.linksRow.insert(this.calendar.nextYearLink);
    
    this.calendar.thead.insert(this.calendar.linksRow);
  },
  
  buildWeek: function() {
    this.calendar.week = new Element('tr', { 'class': 'week_days' });

    this.calendar.week_days = $R(0,6).collect(function(i) {
      return new Element('th').update(i18n[i18n.get_locale()].date.abbr_day_names[this.week_offset(i)]);
    }.bind(this));

    this.calendar.week_days.each(function(week_day) {
      this.calendar.week.insert(week_day);
    }.bind(this));
    
    this.calendar.tbody.insert(this.calendar.week);
  },
  
  buildWeeks: function() {
    this.calendar.weeks = $R(0, 5).collect(function(i) {
      return new Element('tr', { 'class': 'week' });
    });

    this.calendar.weeks.each(function(week) {
      this.calendar.tbody.insert(week);
    }.bind(this));
  },
  
  buildDays: function() {
    this.calendar.days = this.calendar.weeks.collect(function(week) {
      return $R(0, 6).collect(function(week, i) {
        var day = new Element('td', { 'class': 'day' }).update('&nbsp;');
        if (this.week_offset(i) == 0 || this.week_offset(i) == 6)
          day.addClassName('weekend');
        week.insert(day);
        return day;
      }.bind(this, week));
    }.bind(this)).flatten();
  },
  
  cleanup: function() {
    this.calendar.days.invoke('removeClassName', 'other');
    this.calendar.days.invoke('removeClassName', 'today');
    this.calendar.days.invoke('removeClassName', 'selected');
    this.calendar.weeks.invoke('hide');
  },
  
  renderTitle: function() {
    this.calendar.title.update(i18n.l(this.date, '%G %Y'))
  },
  
  renderLinks: function() {
    this.calendar.prevYearLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year - 1, this.date_parts().month, 1), '%Y-%m-%d'));
    this.calendar.nextYearLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year + 1, this.date_parts().month, 1), '%Y-%m-%d'));
    this.calendar.prevMonthLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year, this.date_parts().month - 1, 1), '%Y-%m-%d'));
    this.calendar.nextMonthLink.writeAttribute('data-date', i18n.l(new Date(this.date_parts().year, this.date_parts().month + 1, 1), '%Y-%m-%d'));
    this.calendar.todayLink.writeAttribute('data-date', i18n.l(new Date(), '%Y-%m-%d'));
  },
  
  renderDays: function() {
    var first   = new Date(this.date_parts().year, this.date_parts().month, 1);
    var last    = new Date(this.date_parts().year, this.date_parts().month + 1, 0);

    var before  = this.week_index(first.getDay());
    var total   = last.getDate();
    var after   = 6 - this.week_index(last.getDay());
    
    $R(1 - before, total + after).each(this.boundRenderDay);

    $R(1, (before + total + after) / 7).each(function(i) {
      this.calendar.weeks[i - 1].show();
    }.bind(this));
  },
  
  renderDay: function(offset, index) {
    var now   = new Date();
    var date  = new Date(this.date.getFullYear(), this.date.getMonth(), offset);
    var cell  = this.calendar.days[index];

    if (date.getFullYear() != this.date_parts().year || date.getMonth() != this.date_parts().month)
      cell.addClassName('other');
    
    if (date.getFullYear() == now.getFullYear() && date.getMonth() == now.getMonth() && date.getDate() == now.getDate())
      cell.addClassName('today');

    if (date.getFullYear() == this.input_date_parts().year && date.getMonth() == this.input_date_parts().month && date.getDate() == this.input_date_parts().day)
      cell.addClassName('selected');

    cell.writeAttribute('data-date', i18n.l(date, '%Y-%m-%d'));

    cell.update(date.getDate());
  },
  
  observe: function() {
    this.calendar.container.on('click', 'td.link, td.day', this.boundOnDateChange);
    this.view.on('click', this.boundOnViewClick);

    document.on('click', this.boundOnDocumentClick);
    $(document.body).on('keydown', this.boundOnDocumentKeyPress);
  },
  
  onDateChange: function(e, element) {
    this.date         = Calendar.parse(element.readAttribute('data-date'));
    this._date_parts  = null;
    this.render();

    if (element.hasClassName('day')) {
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
    if (!element.hasClassName('.calendar') && !element.up('.calendar'))
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
  },
  
  week_offset: function(i) {
    var result = i - 7 + this.options['week_offset'];
    return result < 0 ? 7 + result : result;
  },
  
  week_index: function(i) {
    var result = i - this.options['week_offset'];
    return result < 0 ? 7 + result : result;
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
