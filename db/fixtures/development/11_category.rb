general = Category.create(:name => "general")

science = general.children.create(:name => "science")
humanity = general.children.create(:name => "humanity")

Category.seed do |s|
    s.id = 1
    s.name = "general"
end

Category.seed do |s|
    s.id = 2
    s.name = "science"
    s.ancestry = 1
end

Category.seed do |s|
    s.id = 3
    s.name = "humanity"
    s.ancestry = 1
end