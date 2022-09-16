# Copyright 2022 Eric Cornelissen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM node:18-alpine

WORKDIR /home/node/js-re-scan

COPY package.json package-lock.json ./
RUN npm install \
	--omit=dev \
	--no-fund \
	--no-update-notifier

COPY ./ ./

ENTRYPOINT [ \
	"npm", \
	"run", \
	"eslint", \
	"--no-update-notifier", \
	"--", \
	\
	# This option avoids unexpected errors if the project being scanned includes
	# an ESLint configuration file.
	"--no-eslintrc", \
	\
	# Explicitly specify a path to the local configuration file so it can't be
	# missed.
	"--config", \
	"./.eslintrc.yml", \
	\
	# Specify the extensions of files that should be scanned.
	"--ext", \
	".js,.cjs.ejs", \
	\
	# The folder that should be scanned. This is the folder that users should
	# mount their project to.
	"/project" \
]
