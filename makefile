# Keys
PROJECT = Trace
WORKSPACE = $(PROJECT).xcworkspace
TRACESCHEME = $(PROJECT)
TRACETESTSCHEME = iOSDemo
TRACEINTERNALSCHEME = $(PROJECT)Internal

# Compete
LastGitTagVersion := $(shell git describe --abbrev=0 --tags `git rev-list --tags --skip=1 --max-count=0`)

# Commands

# Open project
.SILENT open:
	open $(WORKSPACE)

# Update project dependency
.SILENT update:
	pod update
	bundler update

# Run all tests
.SILENT test:
	xcodebuild "-workspace" $(WORKSPACE) "-scheme" $(TRACESCHEME) "test" | xcpretty
	xcodebuild "-workspace" $(WORKSPACE) "-scheme" $(TRACETESTSCHEME) "test" | xcpretty
	xcodebuild "-workspace" $(WORKSPACE) "-scheme" $(TRACEINTERNALSCHEME) "test" | xcpretty

# Deploy new version of Trace SDK
.SILENT publish version:
	echo "MakeFile"
	echo "Starting publish step"

# Validation
ifeq ($(strip $(version)),)
	echo "Error must provide a non-empty version number i.e make publish version=1.7.11"
	exit 1
endif

ifndef version
	echo "Error must provide a version number i.e make publish version=1.7.11"
	exit 1
endif

ifeq ($(version), $(LastGitTagVersion))
	echo "Error duplicate version number $(LastGitTagVersion), check git tags"
	exit 1
endif

	echo "\nLast git tag version: $(LastGitTagVersion)"

	# Bump pod version and tag number
	sed -i '' 's/$(LastGitTagVersion)/$(version)/' BitriseTrace.podspec.json
	echo "\n'BitriseTrace.podspec.json' version updated from $(LastGitTagVersion) to $(version)"
	git --no-pager diff --minimal BitriseTrace.podspec.json 
	
	# Bump Constants.swift file
	echo "\n'Trace/Constants.swift' version updated from $(LastGitTagVersion) to $(version)"
	sed -i '' 's/$(LastGitTagVersion)/$(version)/' Trace/Constants.swift
	git --no-pager diff --minimal Trace/Constants.swift

	# Bump Xcode project file 
	echo "\n'Trace.xcodeproj/project.pbxproj' version updated from $(LastGitTagVersion) to $(version)"
	sed -i '' 's/$(LastGitTagVersion)/$(version)/' Trace.xcodeproj/project.pbxproj
	git --no-pager diff --minimal Trace.xcodeproj/project.pbxproj

	# Bump Package.swift
	echo "\n'Package.swift' version updated from $(LastGitTagVersion) to $(version)"
	sed -i '' 's/$(LastGitTagVersion)/$(version)/' Package.swift
	git --no-pager diff --minimal Package.swift

	# Bump README.md
	echo "\n'README.md' version updated from $(LastGitTagVersion) to $(version)"
	sed -i '' 's/$(LastGitTagVersion)/$(version)/' README.md
	git --no-pager diff --minimal README.md

	# Show final changes
	echo "\nFinal changes to be commited"
	git --no-pager status --porcelain

	# Commit/Tag changes and push
	git add --all
	git commit -m "Bumped version to $(version) [ci skip]"
	git tag $(version)
	git push
	git push --tags
	echo "\nPushed changed to remote repo"

	echo "\n\nComplete"
	