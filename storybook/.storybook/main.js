const Elm = require("vite-plugin-elm");
const path = require("path");
const folder = path.resolve(__dirname, "./elm-storybook");
module.exports = {
  stories: ["../src/**/*.stories.@(js|jsx|ts|tsx)"],
  addons: [
    "@storybook/addon-a11y",
    "@storybook/addon-actions",
    "@storybook/addon-controls",
    "@storybook/addon-outline",
    "./elm-storybook/addon/register",
  ],
  staticDirs: ["../public"],
  framework: {
    name: "@storybook/html-vite",
    options: {},
  },
  async viteFinal(config) {
    // Allow .elm files to be imported
    config.plugins.push(
      Elm.plugin({
        debug: false,
        optimize: false,
      })
    );

    // Allow `elm-storybook` to be imported in *.stories.js
    config.resolve = config.resolve || {};
    config.resolve.alias = config.resolve.alias || {};
    config.resolve.alias["elm-storybook"] = folder;

    // Watch for changes in ../../ui-library/*.elm
    config.watch = config.watch || [];
    config.watch.push({
      pattern: "../../ui-library/**/*.elm",
      options: {
        ignored: /node_modules/,
      },
    });


    return config;
  },
};
