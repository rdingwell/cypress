require 'test_helper'

class ProductTestTest < MiniTest::Test
  def setup
    collection_fixtures('patient_cache', 'records', 'bundles')
    vendor = Vendor.create(name: 'test_vendor_name')
    @product = vendor.products.create(name: 'test_product')
  end

  def after_teardown
    drop_database
  end

  def test_create
    pt = @product.product_tests.build(name: 'test_for_measure_1a',
                                      measure_id: '1a',
                                      bundle_id: BSON::ObjectId.from_string('4fdb62e01d41c820f6000001'),
                                      effective_date: 1_293_840_000)
    assert pt.valid?, 'product test should be valid with product, name , measure_id, bundle_id and effective_date'
    assert pt.save, 'should be able to save valid product test'
    assert pt.records.count > 0, 'product test creation should have created random number of test records'
  end

  def test_required_fields
    pt = @product.product_tests.build
    assert_equal false,  pt.valid?, 'product test should not be valid without a name'
    assert_equal false,  pt.save, 'should not be able to save product test without a name'
    errors = pt.errors
    assert errors.key?(:name)
    assert errors.key?(:measure_id)
    assert errors.key?(:bundle_id)
    assert errors.key?(:effective_date)
  end
end
