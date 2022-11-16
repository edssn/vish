class KnowledgeArea < ActiveRecord::Base
  validates :key, :presence => true, :uniqueness => true


  ###########
  # Methods
  ###########

  def self.default
    KnowledgeArea.find_by_key("ka-administration-business")
  end

  def self.getknowledgeAreaWithName(name)
    return nil if !name.is_a? String or name.blank?
    KnowledgeArea.all.each do |l|
      I18n.available_locales.each do |locale|
        if l.name(locale) === name
          return l
        end
      end
    end
    nil
  end

  def self.getknowledgeAreaName(id)
    area = KnowledgeArea.find_by_id(id)
    return (area.nil?) ? "-" : area.name
  end

  def name(locale=nil)
    options = {}
    options[:locale] = locale unless locale.nil? or !I18n.available_locales.include?(locale.to_sym)
    I18n.t('knowledge_areas.' + self.key.to_s, options)
  end

end