class SidenavItem
  delegate :request_path, :navigation, :product, :documentation?,
           :namespace, :code_language, :enforce_locale?, to: :@sidenav

  def initialize(folder:, sidenav:)
    @folder  = folder
    @sidenav = sidenav
    @options = Navigation.new(folder).options
  end

  def svg?
    svg && svg_color
  end

  def svg
    @options['svg'] && "/symbol/volta-icons.svg#Vlt-icon-#{@options['svg']}"
  end

  def svg_color
    @options['svgColor'] && "Vlt-#{@options['svgColor']}"
  end

  def label?
    label.present?
  end

  def label
    @options['label']
  end

  def children
    @children ||= (@folder[:children] || []).map do |child|
      SidenavSubitem.new(folder: child, sidenav: @sidenav)
    end
  end

  def css_classes
    classes = ['Vlt-badge Vlt-badge--margin-left']
    classes << 'Vlt-bg-green-lighter Vlt-green' if label.casecmp('beta').zero?
    classes << 'Vlt-bg-blue-lighter Vlt-blue' if label.casecmp('dev preview').zero?

    classes.join(' ')
  end

  def link_url
    if enforce_locale?
      "/#{I18n.locale}/product-lifecycle/#{label.downcase.tr(' ', '-')}"
    else
      "/product-lifecycle/#{label.downcase.tr(' ', '-')}"
    end
  end

  def normalized_title
    @normalized_title ||= TitleNormalizer.call(@folder)
  end

  def title
    @folder[:title]
  end
end
