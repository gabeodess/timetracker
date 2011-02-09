# ===================
# = Build A Company =
# ===================
Factory.define :company do |c|
  c.sequence(:name){ |i| "Comany #{i}" }
  c.sequence(:url_id){ |i| "company#{i}" }
  
  c.association :owner, :factory => :user
  
  c.after_create do |company|
    2.times do |i|
      Factory(:client, :company => company)
      Factory(:task, :company => company)
    end
    company.save!
  end
end

Factory.define :client do |c|
  c.sequence(:name){ |i| "Client #{i}" }
    
  c.after_create do |client|
    2.times do |i|
      Factory(:project, :client_id => client.id, :tasks => client.company.tasks)
    end                
  end
end

Factory.define :project do |p|
  p.sequence(:name){ |i| "Project #{i}" }
  p.billing 'user'  
end

Factory.define :user do |u|
  u.sequence(:login){ |i| "foo#{i}" }
  u.sequence(:email){ |i| "foo#{i}@bar.com" }
  u.password 'password'
  u.password_confirmation 'password'
  u.billing_rate 40
end

Factory.define :task do |t|
  t.sequence(:name){ |i| "Task #{i}" }  
end

Factory.define :timer do |t|
  t.total_time((rand * 10 ** (1..9).to_a.random_element).floor)
end

Factory.define :loaded_timer, :parent => :timer do |lt|
  lt.association :associated_task
  lt.association :user
end

Factory.define :associated_task do |at|
end

Factory.define(:invoice) do |i|
end

# Factory.define(:loaded_invoice, :parent => :invoice) do |li|
#   li.before_save do |invoice|
#     2.times do |i|
#       @project.timers << Factory(:timer, :associated_task => @project.associated_tasks.random_element)
#       @project.expenses << Factory(:expense)
#     end
#     invoice.timers = invoice.client.uninvoiced_timers
#     invoice.expenses = invoice.client.uninvoiced_expenses
#   end
# end

Factory.define :expense do |e|
  e.sequence(:name){ |i| "Expense #{i}" }
  e.your_cost((rand * 10 ** (1..9).to_a.random_element).floor.to_s)
end