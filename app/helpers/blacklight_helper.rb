module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  include FrontpageHelper

  def locale_picker(locale)
    paths = {
        '/nl/collections' => '/nl/collecties',
        '/en/collecties' => '/en/collections',
        '/nl/how-to-use' => '/nl/handleiding',
        '/en/handleiding' => '/en/how-to-use',
        '/nl/open-data' => '/nl/open-gegevens',
        '/en/open-gegevens' => '/en/open-data',
        '/nl/open-source' => '/nl/open-bron',
        '/en/open-bron' => '/en/open-source',
        '/nl/contact-en' => '/nl/contact-nl',
        '/en/contact-nl' => '/en/contact-en',
        '/nl/legal-notification' => '/nl/juridische-kennisgeving',
        '/en/juridische-kennisgeving' => '/en/legal-notification'
    }

    url = url_for(locale: locale)
    unless paths[url].nil?
        translated = paths[url]
        "#{translated}"
    else
        "#{url}"
    end
  end

  def render_technical_details(document=@document, options = {})
    return if document.nil?    
    @technical_details = []

    @technical_details << {
    	format: "Permalink",
    	url: solr_document_url(@document),
    	link: true
    }

    @technical_details << {
    	format: "Work PURL",
    	url: document.fetch(:work_pid),
    	link: false
    }

    @technical_details << {
    	format: "Data PURL",
    	url: document.fetch(:data_pid),
    	link: true
    }

    @technical_details << {
        format: "JSON",
        url: polymorphic_url(url_for_document(@document), format: 'json', only_path: false),
    	link: true
    }

    @technical_details << {
        format: "LIDO XML",
        url: polymorphic_url(url_for_document(@document), format: 'xml', only_path: false),
    	link: true
    }

    render partial: "catalog/technical_detail", collection: @technical_details
  end

  def render_iiif_manifest_url(document=@document, options = {})
    id = document.fetch(:id)
    riiif_manifest_url(id)
  end

  def link_to_repository(repository)
    host = url_for("http://"+request.host)
    if I18n.locale.to_s == "nl"
      locale = "nl"
    else
      locale = "en"
    end
    "#{host}/#{locale}/catalog?f%5Brepository%5D%5B%5D=#{repository}"
  end

  def render_meta_description(document=@document)
    meta_description = document.fetch(:description)
    "#{meta_description}"
  end

  def render_canonical_url
    url = url_for(:only_path => false)
    "#{url}"
  end

  def render_nl_url
    host = url_for("http://"+request.host)
    url = locale_picker("nl")
    "#{host}#{url}"
  end

  def render_en_url
    host = url_for("http://"+request.host)
    url = locale_picker("en")
    "#{host}#{url}"
  end

  def render_language_territory
    if I18n.locale.to_s == "nl"
        "nl_BE"
    else
        "en_GB"
    end
  end

  def render_alternate_language_territory
    if I18n.locale.to_s == "nl"
        "en_GB"
    else
        "nl_BE"
    end
  end

  def render_image(document=@document)
    riiif_image_url(document)
  end

end
