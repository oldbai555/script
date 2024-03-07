#git reset "$(git merge-base master "$(git branch --show-current)")"
#git add -A && git commit -m 'init project'
#git pull
#git push --force

# $1 对比分支
# $2 commit 信息
OneCommit() {
  git reset "$(git merge-base "$1" "$(git branch --show-current)")"
  git add -A && git commit -m "$2"
  #git pull
  #git push --force
  #git remote set-url origin https://<你的令牌>@github.com/<你的git用户名>/<要修改的仓库名>.git
}

GitPull() {
  git reset --hard
  git pull origin $1
}