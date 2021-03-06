authorization do
  role :guest do
    
    has_permission_on :users, :to => :create
    
  end
  
  role :user do
    has_permission_on :users, :to => :manage do
      if_attribute :id => is{user.id}
    end
    
    has_permission_on :companies, :to => :create
    
    has_permission_on :companies, :to => [:manage] do
      if_attribute :owner_id => is{user.id}
    end
    
    has_permission_on :clients_invoices, :to => [:index] do
      if_permitted_to :manage, :client
    end
  end
  
  role :admin do
    
    has_permission_on :company_based_roles, :to => [:manage] do
      if_attribute :company_id => is{user.current_company.id}
    end
    
    has_permission_on :companies, :to => [:read, :create, :update] do
      if_attribute :admin_ids => contains{user.id}
    end
    has_permission_on :companies, :to => [:read, :create, :update] do
      if_attribute :owner_id=> is{user.id}
    end
    
    has_permission_on :expenses, :to => :manage do
      if_permitted_to :manage, :project
    end
    
    has_permission_on [:invoices], :to => :manage do
      if_permitted_to :manage, :client
    end
    
    has_permission_on :contacts, :to => :manage do
      if_permitted_to :manage, :client
    end
    
    has_permission_on :associated_tasks, :to => :index
    has_permission_on :tasks, :to => [:index, :create]
    has_permission_on :tasks, :to => :manage do
      if_permitted_to :manage, :company
    end
    has_permission_on :home, :to => :manage

    has_permission_on :clients, :to => :create
    has_permission_on :clients, :to => :manage do
      if_permitted_to :manage, :company
    end
    # has_permission_on :projects, :to => :new
    has_permission_on :projects, :to => :manage do
      if_permitted_to :manage, :client
    end
  end
  
  # permissions on other roles, such as
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
