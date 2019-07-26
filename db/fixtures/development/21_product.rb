2.times do |id|
    Product.seed do |s|
        s.id = id 
        s.name = "test#{id}"
        s.description = "test#{id}の商品です。"
        s.price = 100 * id
        s.state = "new"
        s.status = "open"
        s.seller_id = 1
        s.category_id = 2
    end
end