User.seed do |s|
    s.id = 1
    s.name = "yanasinn"
    s.email = "ysthon@gmail.com"
    s.password = "password"
    s.password_confirmation = "password"
    s.avatar = Rails.root.join("db/fixtures/avatar.jpg").open
end

User.seed do |s|
    s.id = 2 
    s.name = "test1"
    s.email = "test@example.com"
    s.password = "password"
    s.password_confirmation = "passowrd"
    s.avatar = Rails.root.join("db/fixtures/avatar.jpg").open
end
