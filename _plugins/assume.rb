module Jekyll
  class UpcaseConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /.md/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      pat = /{[^{]*}\([^\(]*\)/
      script = []
      content.scan(pat).each do |match|
        id = /{([^{]*)}/.match(match)[1]
        value = /\(([^\(]*)\)/.match(match)[1]
        if (value =~ /#/)
          content.sub! match, "<b id='#{id}'>#{id}</b>"
          value.gsub!(/#([^\s]+)/, 'document.getElementById(\'\1\').value')
          script.push "document.getElementById('#{id}').innerHTML = Math.round(100 * (#{value})) / 100;"
        else
          content.sub! match, "<input id='#{id}' value='#{value}' size=1 onchange='updateCalValue()' onready='updateCalValue()'>"
        end
      end
      if script.any?
        content = "<script type='text/javascript'>function updateCalValue() {#{script.join}};$().ready(function () {updateCalValue();});</script>" << content
      end
      content
    end
  end
end

