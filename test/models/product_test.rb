require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be valid and positive" do
    product = Product.new({
        title: "hello",
        description: "hi helo",
        image_url: "hello.jpg"
    })
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",product.errors[:price].join('; ')
    product.price = 1.19
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
            title: "hello",
            description: "hi",
            image_url: image_url,
            price: 19.90
        )
  end

  test "image url should be valid" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
    http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
        assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
        assert new_product(name).invalid?, "#{name} should be invalid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(
        title: products(:ruby).title,
        description: "sfaafdsaf",
        price: 22.10,
        image_url: "sdfhjksh.jpg"
      )
    assert !product.save
    assert_equal I18n.translate('errors.messages.taken'), product.errors[:title].join('; ' )
  end

end
