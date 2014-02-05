module GithubDiscover
  class Recommender
    include_package "org.apache.commons.pool.impl"
    include_package "org.apache.commons.dbcp"

    MySQLBooleanPrefJDBCDataModel = org.apache.mahout.cf.taste.impl.model.jdbc.MySQLBooleanPrefJDBCDataModel
    ReloadFromJDBCDataModel = org.apache.mahout.cf.taste.impl.model.jdbc.ReloadFromJDBCDataModel
    MahoutSimilarity = org.apache.mahout.cf.taste.impl.similarity
    MahoutNeighborhood = org.apache.mahout.cf.taste.impl.neighborhood
    MahoutRecommender = org.apache.mahout.cf.taste.impl.recommender

    attr_reader :model

    def recommend(user_id, results_limit)
      recommender.recommend(user_id, results_limit)
    end

    private

    def similarity
      @similarity ||= MahoutSimilarity.TanimotoCoefficientSimilarity.new(model)
    end

    def neighborhood
      @neighborhood ||= MahoutNeighborhood.NearestNUserNeighborhood.new(5, similarity, model)
    end

    def recommender
      @recomennder ||= MahoutRecommender.GenericBooleanPrefUserBasedRecommender.new(model, neighborhood, similarity)
    end

    def model
      @model ||= ReloadFromJDBCDataModel.new(
        MySQLBooleanPrefJDBCDataModel.new(datasource, "stars", "user_id", "repo_id", nil)
      )
    end

    def datasource
      @datasource ||= begin
        connection_pool = GenericObjectPool.new
        connection_factory = DriverManagerConnectionFactory.new("jdbc:mysql://localhost/github_discover", "root", "")
        poolable_connection_factory = PoolableConnectionFactory.new(connection_factory, connection_pool, nil, nil, false, true)
        PoolingDataSource.new(connection_pool)
      end
    end
  end
end
