general = Category.create(:name => "一般")

science = general.children.create(:name => "理系")
humanity = general.children.create(:name => "文系")

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