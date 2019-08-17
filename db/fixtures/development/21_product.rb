2.times do |id|
    Product.seed do |s|
        s.id = id + 1
        s.name = "test#{id+1}"
        s.description = "test#{id+1}の商品です。"
        s.price = 100 * (id + 1)
        s.state = "新品、未使用"
        s.status = "open"
        s.seller_id = 1
        s.category_id = 2
    end
end

Product.seed do |s|
    s.id = 3
    s.name = "test3"
    s.description = "test3の商品です。"
    s.price = 300
    s.state = "新品、未使用"
    s.status = "open"
    s.seller_id = 2
    s.category_id = 1
end