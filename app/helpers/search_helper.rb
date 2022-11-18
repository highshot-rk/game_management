module SearchHelper
  def search_params
    @search_params ||= params[:search] || {}
  end

  def search_checkbox(key, list, id_key, label_key, params: {})
    list.map do |element|
      label_tag do
        id = element.send(id_key).to_s
        element_checked = params[key].to_a.include?(id)
        check_box_tag("#{key}[]", id, element_checked) + element.send(label_key)
      end
    end.join('<br>').html_safe
  end
end
