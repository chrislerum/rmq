class Section < UIView

  def rmq_build
    rmq(self).tap do |q|
      q.apply_style :section

      q.append(UILabel, :section_title)


      q.append(UILabel, :section_enabled_title)

      q.append(UISwitch, :section_enabled).on(:change) do |sender|
        style = sender.isOn ? :section_button_enabled : :section_button_disabled
        rmq(sender).parent.find(UIButton).apply_style(style)
      end

      q.append(UIButton, :start_spinner).on(:tap) do # optional |sender, rmq_event| on events
        rmq.animations.start_spinner
      end

      q.append(UIButton, :stop_spinner).on(:tap) do
        rmq.animations.stop_spinner
      end
    end
  end

end
