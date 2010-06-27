module ActionView
  class Base
    def self.field_error_proc
      Proc.new { |html_tag, instance|  "<div class=\"fieldWithErrors\">#{html_tag}</div>" }
    end
  end
end
