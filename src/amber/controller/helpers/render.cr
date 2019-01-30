module Amber::Controller::Helpers
  module Render
    LAYOUT = "application.slang"

    macro render(template = nil, layout = true, partial = nil, path = "src/views", folder = __FILE__)
      {% if !(template || partial) %}
        raise "Template or partial required!"
      {% end %}

      {{ filename = template || partial }}

      # Render Template and return content
      {% if filename.id.split("/").size > 1 %}
        %content = render_template("#{{{filename}}}", {{path}})
      {% else %}
        {{ short_path = folder.gsub(/^.+?(?:controllers|views)\//, "") }}
        {% if folder.id.ends_with?(".ecr") %}
          %content = render_template("#{{{short_path.gsub(/\/[^\.\/]+\.ecr/, "")}}}/#{{{filename}}}", {{path}})
        {% else %}
          %content = render_template("#{{{short_path.gsub(/\_controller\.cr|\.cr/, "")}}}/#{{{filename}}}", {{path}})
        {% end %}
      {% end %}

      # Render Layout
      {% if layout && !partial %}
        content = %content
        {% if layout.class_name == "StringLiteral" %}
          render_template("layouts/#{{{layout}}}", {{path}})
        {% elsif LAYOUT.class_name == "Proc" %}
          render_template("layouts/#{{{layout.call}}}", {{path}})
        {% else %}
          render_template("layouts/#{{{LAYOUT}}}", {{path}})
        {% end %}
      {% else %}
        %content
      {% end %}
    end

    private macro render_template(filename, path = "src/views")
      Kilt.render("#{{{path}}}/{{filename.id}}")
    end
  end
end
