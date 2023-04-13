init:
	pip install ansible molecule 'molecule[docker]' ansible-lint

# https://github.com/docker/for-mac/issues/6073#issuecomment-1018793677
init-configure-sysfs-for-mac:
	test -z "$(docker ps -q 2>/dev/null)" && osascript -e 'quit app "Docker"'
	brew install jq moreutils yamllint
	echo '{"deprecatedCgroupv1": true}' | \
	  jq -s '.[0] * .[1]' ~/Library/Group\ Containers/group.com.docker/settings.json - | \
	  sponge ~/Library/Group\ Containers/group.com.docker/settings.json
	  open --background -a Docker

init-mac:
	init
	init-configure-sysfs-for-mac

verify:
	for env in default multi-node ; do \
	  echo "Trying to test ${env} scenario" ; \
	  molecule create -s "${env}" ; \
	  molecule converge -s "${env}" ; \
	  molecule verify -s "${env}" ; \
	  echo "Testing ${env} scenario is finished" ; \
	done
