module Searchlogic
  # ==========================================================
  # = This extention allows the user to set default ordering =
  # ==========================================================
  module RailsHelpers
    # Creates a link that alternates between acending and descending. It basically
    # alternates between calling 2 named scopes: "ascend_by_*" and "descend_by_*"
    #
    # By default Searchlogic gives you these named scopes for all of your columns, but
    # if you wanted to create your own, it will work with those too.
    #
    # Examples:
    #
    #   order @search, :by => :username
    #   order @search, :by => :created_at, :as => "Created"
    #
    # This helper accepts the following options:
    #
    # * <tt>:by</tt> - the name of the named scope. This helper will prepend this value with "ascend_by_" and "descend_by_"
    # * <tt>:as</tt> - the text used in the link, defaults to whatever is passed to :by
    # * <tt>:ascend_scope</tt> - what scope to call for ascending the data, defaults to "ascend_by_:by"
    # * <tt>:descend_scope</tt> - what scope to call for descending the data, defaults to "descend_by_:by"
    # * <tt>:params</tt> - hash with additional params which will be added to generated url
    # * <tt>:params_scope</tt> - the name of the params key to scope the order condition by, defaults to :search
    def order(search, options = {}, html_options = {})
      options[:params_scope] ||= :search
      if !options[:as]
        id = options[:by].to_s.downcase == "id"
        options[:as] = id ? options[:by].to_s.upcase : options[:by].to_s.humanize
      end
      options[:ascend_scope] ||= "ascend_by_#{options[:by]}"
      options[:descend_scope] ||= "descend_by_#{options[:by]}"
      options[:default_scope] ||= :ascend_scope # => This line is monkey patched
      ascending = search.order.to_s == options[:ascend_scope]
      descending = search.order.to_s == options[:descend_scope]
      new_scope = ascending ? options[:descend_scope] : options[:ascend_scope]
      selected = [options[:ascend_scope], options[:descend_scope]].include?(search.order.to_s)
      if selected
        css_classes = html_options[:class] ? html_options[:class].split(" ") : []
        if ascending
          options[:as] = "&#9650;&nbsp;#{options[:as]}"
          css_classes << "ascending"
        else
          options[:as] = "&#9660;&nbsp;#{options[:as]}"
          css_classes << "descending"
        end
        html_options[:class] = css_classes.join(" ")
      else
        new_scope = options[options[:default_scope].to_sym] # => This line is monkey patched
      end
      url_options = {
        options[:params_scope] => search.conditions.merge( { :order => new_scope } )
      }.deep_merge(options[:params] || {})
      link_to options[:as], url_for(url_options), html_options
    end

  end
  
  
  
  # =================================================================
  # = This extension adds case insensitive ordering to searchlogic. =
  # =================================================================
  module NamedScopes
    module Ordering
        
        def ordering_condition_details(name)
          # raise name.to_s
          if name.to_s =~ /^(ascend|descend|iascend|idescend)_by_(#{column_names.join("|")})$/
            {:order_as => $1, :column => $2}
          elsif name.to_s =~ /^order$/
            {}
          end
        end
        
        def create_ordering_conditions(column)
          named_scope("ascend_by_#{column}".to_sym, {:order => "#{table_name}.#{column} ASC"})
          named_scope("descend_by_#{column}".to_sym, {:order => "#{table_name}.#{column} DESC"})
        
          named_scope("iascend_by_#{column}".to_sym, {:order => "upper(#{table_name}.#{column}) ASC"})
          named_scope("idescend_by_#{column}".to_sym, {:order => "upper(#{table_name}.#{column}) DESC"})
        end
    end
    
    module AssociationOrdering
      private        
        def association_ordering_condition_details(name)
          associations = reflect_on_all_associations.collect { |assoc| assoc.name }
          if name.to_s =~ /^(ascend|descend|iascend|idescend)_by_(#{associations.join("|")})_(\w+)$/
            {:order_as => $1, :association => $2, :condition => $3}
          end
        end
    end
  end
end
