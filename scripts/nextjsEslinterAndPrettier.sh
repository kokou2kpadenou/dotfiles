#!/bin/sh

# Install ESLint
npm i eslint -D

# Install ESLint plugins
npx install-peerdeps --dev eslint-config-airbnb

# Above single(https://www.npmjs.com/package/eslint-config-airbnb) command will
# install 6 plugins: eslint-config-airbnb, eslint-plugin-import, 
# eslint-plugin-react, eslint-plugin-react-hooks, and eslint-plugin-jsx-a11y.
# You can also install these plugins individually.

# Install babel eslint
npm i -D babel-eslint

# Install prettier
npm i -D prettier

# Install prettier plugin (optional, so that prettier doesn't mess up with linting)
npm i -D eslint-config-prettier eslint-plugin-prettier

