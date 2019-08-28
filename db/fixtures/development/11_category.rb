general = Category.create(:name => "一般")

science = general.children.create(:name => "理系")
humanity = general.children.create(:name => "文系")
