describe 'format' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return device from RMQ or an instance of rmq' do
    @rmq.format.should == RubyMotionQuery::Format

    rmq = RubyMotionQuery::RMQ.new
    rmq.format.should == RubyMotionQuery::Format
  end

  it 'should cache numeric formatters' do
    formatter = @rmq.format.numeric_formatter('#0.00')

    @rmq.format.numeric_formatter('#0.00').object_id.should == formatter.object_id
    @rmq.format.numeric_formatter('#00.00').object_id.should != formatter.object_id
  end

  it 'should cache date formatters' do
    formatter = @rmq.format.date_formatter('EEE, MMM d, ''yy')

    @rmq.format.date_formatter('EEE, MMM d, ''yy').object_id.should == formatter.object_id
    @rmq.format.date_formatter('EEE').object_id.should != formatter.object_id
  end

  it 'should format a number with a formatting string' do
    format = '#,##0.#'
    formated_string = @rmq.format.numeric(1000, format)
    @rmq.format.number(1000, format).should == formated_string

    # This is tough to test, because ever developer will get different results based
    # on thier locale
    number_formater = NSNumberFormatter.alloc.init
    number_formater.setPositiveFormat(format)

    number_formater.stringFromNumber(1000).should == formated_string
  end

  it 'should format a date with a formatting string' do
    format = 'EEE, MMM d, ''yy'
    time = Time.now
    formated_string = @rmq.format.date(time, format)

    # This is tough to test, because ever developer will get different results based
    # on thier locale
    format_template = NSDateFormatter.dateFormatFromTemplate(format, options: 0,
                                                      locale: NSLocale.currentLocale)
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat(format_template)

    formatter.stringFromDate(time).should == formated_string
  end

  it "should format a date with style symbols" do
    date = Time.new(2013,1,2,12,15,30)

    # date styles
    rmq.format.date(date, :short_date).should == '1/2/13'
    rmq.format.date(date, :medium_date).should == 'Jan 2, 2013'
    rmq.format.date(date, :long_date).should == 'January 2, 2013'
    rmq.format.date(date, :full_date).should == 'Wednesday, January 2, 2013'

    # time styles
    rmq.format.date(date, :short_time).should == '12:15 PM'
    rmq.format.date(date, :medium_time).should == '12:15:30 PM'
    # skipping due to variable locales
    #rmq.format.date(date, :long_time).should == '12:15:30 PM EST'
    #rmq.format.date(date, :full_time).should == '12:15:30 PM Eastern Standard Time'

    # combos
    rmq.format.date(date, :short_date, :medium_time).should == '1/2/13, 12:15:30 PM'
    rmq.format.date(date, :medium_time, :short_date).should == '1/2/13, 12:15:30 PM'
  end

  it "should associate formats with custom styles" do
    date = Time.new(2013,1,2,12,15,30)

    rmq.format.add_datetime_style(:mon_year, "MMM yyyy")
    rmq.format.date_formatter(:mon_year).class.should == NSDateFormatter
    rmq.format.date_formatter(:mon_year).stringFromDate(date).should == 'Jan 2013'
    rmq.format.date(date, :mon_year).should == 'Jan 2013'
  end

end
