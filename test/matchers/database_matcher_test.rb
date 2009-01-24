require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DatabaseMatcherTest < Test::Unit::TestCase # :nodoc:

  context "has_db_column" do
    setup do
      @matcher = has_db_column(:nickname)
    end

    should "accept an existing database column" do
      create_model_table 'superheros' do |table|
        table.string :nickname
      end
      define_model_class 'Superhero'
      assert_accepts @matcher, Superhero.new
    end
    
    should "reject a nonexistent database column" do
      define_model :superhero
      assert_rejects @matcher, Superhero.new
    end
  end
  
  context "has_db_column with column_type option" do
    setup do
      @matcher = has_db_column(:nickname).column_type(:string)
    end

    should "accept an existing column of correct type" do
      create_model_table 'superheros' do |table|
        table.string :nickname
      end
      define_model_class 'Superhero'
      assert_accepts @matcher, Superhero.new
    end
    
    should "reject a nonexistent database column" do
      define_model :superhero
      assert_rejects @matcher, Superhero.new
    end
    
    should "reject a column with the correct name but wrong type" do
      create_model_table 'superheros' do |table|
        table.integer :nickname
      end
      define_model_class 'Superhero'
      assert_rejects @matcher, Superhero.new
    end
  end
  
  context "has_db_column with precision option" do
    setup do
      @matcher = has_db_column(:money).precision(15)
    end
    
    should "accept an existing database column with correct precision" do
      create_model_table 'superheros' do |table|
        table.decimal :money, :precision => 15
      end
      define_model_class 'Superhero'
      assert_accepts @matcher, Superhero.new
    end

    should "reject a column with the wrong precision" do
      create_model_table 'superheros' do |table|
        table.decimal :money, :precision => 30
      end
      define_model_class 'Superhero'
      assert_rejects @matcher, Superhero.new
    end
  end
  
  context "has_db_column with limit option" do
    setup do
      @matcher = has_db_column(:email).column_type(:string).limit(255)
    end
    
    should "accept a column of correct limit" do
      db_column = DatabaseColumn.new(:email, :string, :limit => 255)
      build_model_class :superhero, db_column
      assert_accepts @matcher, Superhero.new
    end

    should "reject a column of wrong limit" do
      db_column = DatabaseColumn.new(:email, :string, :limit => 500)
      build_model_class :superhero, db_column
      assert_rejects @matcher, Superhero.new
    end
  end
  
  context "has_db_column with default option" do
    setup do
      @matcher = has_db_column(:admin).column_type(:boolean).default(false)
    end
    
    should "accept a column of correct default" do
      db_column = DatabaseColumn.new(:admin, :boolean, :default => false)
      build_model_class :superhero, db_column
      assert_accepts @matcher, Superhero.new
    end

    should "reject a column of wrong default" do
      db_column = DatabaseColumn.new(:admin, :boolean, :default => true)
      build_model_class :superhero, db_column
      assert_rejects @matcher, Superhero.new
    end
  end
  
  # :default, :null,
  # :primary, :scale, and :sql_type

end
