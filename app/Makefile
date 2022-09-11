.PHONY: dart-proto protoc protoc-gen-dart
all: dart-proto

PROTOC=${HOME}/.local/bin/protoc
PROTOC_GEN_DART=${HOME}/.pub-cache/bin/protoc-gen-dart
PROTO_FILES := $(shell find ../server/proto/src/ -type f -name \*.proto)

# Compile protobuf files to Dart
dart-proto: lib/data/proto/items.pb.dart
lib/data/proto/items.pb.dart: protoc protoc-gen-dart
	mkdir -p lib/data/proto
	rm -rf lib/data/proto/*.dart
	${PROTOC} -I=../server/proto/src/ --dart_out=lib/data/proto/ ${PROTO_FILES} --plugin=${PROTOC_GEN_DART}


# Install protoc
protoc: ${HOME}/.local/bin/protoc
${HOME}/.local/bin/protoc:
	rm -rf /tmp/drankroulette-protoc
	mkdir -p /tmp/drankroulette-protoc
	wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip -O /tmp/drankroulette-protoc/protoc.zip
	unzip /tmp/drankroulette-protoc/protoc.zip -d /tmp/drankroulette-protoc/

	mkdir -p ${HOME}/.local/bin/
	mv /tmp/drankroulette-protoc/bin/protoc ${HOME}/.local/bin
	rm -rf /tmp/drankroulette-protoc

# Install the protoc-gen-dart plugin
protoc-gen-dart: ${HOME}/.pub-cache/bin/protoc-gen-dart
${HOME}/.pub-cache/bin/protoc-gen-dart:
	dart pub global activate protoc_plugin
	echo 'export PATH="$$PATH":"$$HOME/.pub-cache/bin"' >> ${HOME}/.bashrc
	export PATH="${PATH}:${HOME}/.pub-cache/bin"
