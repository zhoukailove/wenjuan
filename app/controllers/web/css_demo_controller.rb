class  Web::CssDemoController < DemoController
  layout 'web_application'

  def index
    @msg = [
        {
            title:'创建内部样式表',
        }
    ]
  end
end
