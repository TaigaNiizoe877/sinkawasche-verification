# frozen_string_literal: true

module FormsHelper
  def next_step_path(current_step)
    number = current_step.to_i + 1
    page_steps[:"#{number}"]
  end

  def prev_step_path(current_step)
    number = current_step.to_i - 1
    page_steps[:"#{number}"]
  end

  def target_page(number)
    page_steps[:"#{number}"]
  end

  def page_steps
    {
      "0": "/forms/select_working_location",
      "1": "/forms/select_menu",
      "2": "/forms/select_day",
      "3": "/forms/select_time",
      "4": "/forms/input_info",
      "5": "/forms/confirm"
    }
  end
end
