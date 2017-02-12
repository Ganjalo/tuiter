module ApplicationHelper

  # Returns the full page title
  def full_title(page_title = '')
    base_title = "Tuiter"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
end
