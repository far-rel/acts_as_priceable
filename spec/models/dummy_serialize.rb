class DummySerialize < ActiveRecord::Base

  serialize :hash_data, Hash
  serialize :hstore_data, ActiveRecord::Coders::Hstore

end