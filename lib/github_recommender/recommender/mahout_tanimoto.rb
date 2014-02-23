module GithubRecommender
  class Recommender
    class MahoutTanimoto
      JDBC_URI_TEMPLATE = "jdbc:%s://%s/%s"

      include_package "org.apache.mahout.cf.taste.impl.similarity"
      include_package "org.apache.mahout.cf.taste.impl.neighborhood"
      include_package "org.apache.mahout.cf.taste.impl.recommender"
      include_package "org.apache.mahout.cf.taste.impl.model.jdbc"
      include_package "org.apache.commons.pool.impl"
      include_package "org.apache.commons.dbcp"

      def recommend(user_id, limit)
        recommender.recommend(user_id, limit).map { |r| [r.item_id, r.value] }
      end

      def similarity
        @similarity ||= TanimotoCoefficientSimilarity.new(model)
      end

      def neighborhood
        @neighborhood ||= NearestNUserNeighborhood.new(5, similarity, model)
      end

      def recommender
        @recommender ||= GenericBooleanPrefUserBasedRecommender.new(model, neighborhood, similarity)
      end

      def model
        @model ||= ReloadFromJDBCDataModel.new(
          MySQLBooleanPrefJDBCDataModel.new(datasource, "stars", "user_id", "repo_id", nil)
        )
      end

      def datasource
        @datasource ||= begin
          connection_pool = GenericObjectPool.new
          user, pass = GithubRecommender.db_config.values_at(:username, :password)
          connection_factory = DriverManagerConnectionFactory.new(jdbc_uri, user, pass)
          poolable_connection_factory = PoolableConnectionFactory.new(connection_factory, connection_pool, nil, nil, false, true)
          PoolingDataSource.new(connection_pool)
        end
      end

      def jdbc_uri
        JDBC_URI_TEMPLATE % GithubRecommender.db_config.values_at(:adapter, :host, :database)
      end
    end
  end
end
