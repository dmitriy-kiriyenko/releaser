namespace :releaser do
  desc "Write current revision to CURRENT_VERSION file."
  task :write_current do
    version = run_locally("bundle exec releaser info --no-verbose").chomp
    run "echo \"#{version}\" > #{release_path}/CURRENT_VERSION"
  end

  task :tag_deploy_commit do
    run_locally "bundle exec releaser deploy --push"
  end
end

on :load do
  if fetch(:write_version, false)
    after "deploy:symlink", "releaser:write_current"
  end

  if fetch(:tag_deploy_commit, false)
    before "deploy:update_code", "releaser:tag_deploy_commit"
  end
end
