namespace :releaser do
  desc 'Write current revision to CURRENT_VERSION file.'
  task :write_current do
    on roles(:app) do
      upload! 'tmp/CURRENT_VERSION', "#{release_path}/CURRENT_VERSION"
    end
  end

  task :tag_deploy_commit do
    run_locally "bundle exec releaser deploy --push --object=#{real_revision}"
  end

  task :untag_deploy_commit do
    run_locally "bundle exec releaser undo_deploy --push --object=#{real_revision}"
  end
end

on :load do
  run_locally do
    execute 'echo `bundle exec releaser info --no-verbose` > tmp/CURRENT_VERSION'
  end

  if fetch(:write_version, true)
    after 'deploy:publishing', 'releaser:write_current'
  end

  if fetch(:tag_deploy_commit, false)
    before 'deploy:updated', 'releaser:tag_deploy_commit'
    before 'deploy:reverted', 'releaser:untag_deploy_commit'
  end
end
