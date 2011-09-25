require 'test_helper'

class ProductTest < ActiveSupport::TestCase
   test "Atributos do produto nao podem estar vazios" do
   	product = Product.new
   	assert product.invalid?
   	assert product.errors[:title].any?
   	assert product.errors[:description].any?
   	assert product.errors[:price].any?
   	assert product.errors[:image_url].any?
   end

   test "Preco do produto tem que ser positivo" do
   	product = Product.new(title: "Titulo do meu livro",
						description: "yyy",
						image_url: "zzz.jpg")
	product.price = -1
		assert product.invalid?
		assert_equal "Tem que ser maior ou igual a 0.01",
		product.errors[:price].join('; ')
	product.price = 0
		assert product.invalid?
		assert_equal "Tem que ser maior que 0.01",
		product.errors[:price].join('; ')
	product.price = 1
		assert product.valid?
   end

   def new_product(image_url)
   	Product.new (title: "Titulo do meu livro",
   				description: "yyy",
   				price: 1,
   				image_url: image_url)
   end

   test "Image url" do
   	ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
   			http://a.b.c/x/y/z/fred.gif }
   	bad = %w{fred.doc fred.gif/more fred.gif.more }

   	ok each do |name|
   		assert new_product(name).valid?, "#{name} nao devia ser invalido" 
   	end
   	bad each do |name|
   		assert new_product(name).invalid?, "#{name} nao devia ser valido"
   	end
   end

   test "Produto nao e validado se conter um titulo repetido" do
   	product = Product.new(title: products(:ruby).title,
   						description: "yyy",
   						price: 1,
   						image_url: "fred.gif")
   	assert !product.save
   	assert_equal "ja foi utilizado", product.error[:title].join('; ')
   end
   	
   fixtures :products
   
end
