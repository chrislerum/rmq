class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_label_kitchen_sink(st)
    st.text = 'rmq is awesome'
    st.font = font.system(12)
    st.color = color.black
    st.text_alignment = :center
    st.number_of_lines = :unlimited
    st.adjusts_font_size = true
    st.resize_to_fit_text
    st.size_to_fit
    st.line_break_mode = NSLineBreakByWordWrapping
  end

  def ui_label_color(st)
    st.text_color = color.blue
  end

  def ui_label_centered(st)
    ui_label_kitchen_sink(st)
    st.text_alignment = :centered
  end

  def ui_label_attributed_string(st)
    st.attributed_text = NSAttributedString.alloc.initWithString("RMQ")
  end
end

describe 'stylers/ui_label' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UILabel
  end

  behaves_like "styler"

  it 'should apply a style with every UILabelStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink).get

    view.tap do |v|
      v.text.should == 'rmq is awesome'
      v.font.should == UIFont.systemFontOfSize(12)
      v.color.should == UIColor.blackColor
      v.textAlignment.should == NSTextAlignmentCenter
      v.adjustsFontSizeToFitWidth.should == true
      v.size.width.should > 0
      v.numberOfLines.should == 0
      v.lineBreakMode.should == NSLineBreakByWordWrapping
    end

  end

  it 'allows color set with `text_color`' do
    view = @vc.rmq.append!(@view_klass, :ui_label_color)
    view.textColor.should == rmq.color.blue
  end

  it 'should use :centered as an alias for :center' do
    view = @vc.rmq.append(@view_klass, :ui_label_centered).get

    view.tap do |v|
      v.textAlignment.should == NSTextAlignmentCenter
    end
  end

  it "applies an attributed string" do
    view = @vc.rmq.append(@view_klass, :ui_label_attributed_string).get

    view.tap do |v|
      v.text.should == 'RMQ'
    end
  end
end

