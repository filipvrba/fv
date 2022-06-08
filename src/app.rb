require_relative "./share"
require_relative "./project"
require_relative "./app/arguments"


pid = fork do
    app_arguments = App::Arguments.new
    share = Share.new app_arguments.options[:message]
    share.p_path app_arguments.options[:share]

    while true
        sleep 1
    end
end

p pid