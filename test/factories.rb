Factory.define :invoice do |i|
  
  i.association :client
end

Factory.define :client do |c|
  c.name 'Client 1'
  
  c.association :company
  
  # c.after_create{ |client| 5.times{ |i| client.projects << Factory(:project, :name => "project#{i}") } }
end

Factory.define :company do |c|
  c.sequence(:name){ |i| "Comany #{i}" }
  c.sequence(:url_id){ |i| "company#{i}" }
  
  c.association :owner, :factory => :user
  
  # c.after_create{ |company| 5.times{ |i| company.tasks << Factory(:task) } }
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
  
  t.association :company
end

Factory.define :project do |p|
  p.sequence(:name){ |i| "Project #{i}" }
  
  # p.association :client
  
  # p.after_create{ |project| project.tasks = project.company.tasks }
end

Factory.define :timer do |t|
  t.total_time((rand * 10 ** (1..9).to_a.random_element).floor)
  
  t.association :user
end

Factory.define :expense do |e|
  e.sequence(:name){ |i| "Expense #{i}" }
  e.your_cost((rand * 10 ** (1..9).to_a.random_element).floor.to_s)
end