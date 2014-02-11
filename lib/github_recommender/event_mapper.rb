module GithubRecommender
  class EventMapper
    REPO_PROPERTIES = %W[owner name url description homepage language]
    USER_PROPERTIES = %W[name]

    attr_reader :event, :user, :repo

    def self.map!(event)
      new(event).map!
    end

    def initialize(event)
      @event = event
    end

    def map!
      if event["type"] == "WatchEvent"
        find_or_create_user!
        find_or_create_repo!
        find_or_create_star!
      end
    end

    private

    def find_or_create_user!
      @user = User.where(login: user_login).first_or_create!(user_properties)
    rescue ActiveRecord::RecordNotUnique
      puts "Retrying after record not unique error (likely race condition)"
      retry
    end

    def find_or_create_repo!
      @repo = Repo.where(id: repo_id).first_or_create!(repo_properties)
    rescue ActiveRecord::RecordNotUnique
      puts "Retrying after record not unique error (likely race condition)"
      retry
    end

    def find_or_create_star!
      user.starred_repos << repo
    rescue ActiveRecord::RecordNotUnique
      # Do nothing, if it exists we're good
    end

    def repo_id
      event_repo["id"]
    end

    def user_login
      event_user["login"]
    end

    def repo_properties
      event_repo.slice(*REPO_PROPERTIES)
    end

    def user_properties
      event_user.slice(*USER_PROPERTIES)
    end

    def event_repo
      event["repository"]
    end

    def event_user
      event["actor_attributes"] || { "login" => event["actor"] }
    end
  end
end
