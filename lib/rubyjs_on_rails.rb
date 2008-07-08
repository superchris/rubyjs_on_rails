module RubyjsHelper
  def rubyjs(klass_name, method="main")
    js_file = klass_name.underscore + ".js"
    rb_file = File.join(RAILS_ROOT, "app", "views", controller.controller_name, klass_name.underscore + ".rb")
    js_file_full = File.join(RAILS_ROOT, "public", "javascripts", "rubyjs", js_file)
    unless File.exist?(js_file_full) && 
        !(File.mtime(rb_file) > File.mtime(js_file_full))
      unless system("rubyjs -O PrettyPrint -d -m #{klass_name + "." + method} -o #{js_file_full} #{rb_file}")
        raise "Unable to execute rubyjs: you did do install rubyjs gem > 0.8.1 or later, right?"
      end
    end
    <<EOHTML
    <script src="/javascripts/rubyjs/#{js_file}" />
EOHTML
  end
end
