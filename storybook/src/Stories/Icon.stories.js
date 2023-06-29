import { Elm } from "./Icon.elm";
import elmSource from "./Icon.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Icon",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" },
  },
};

export const Icon = (controls) =>
  ElmComponent.create(Elm.Stories.Icon, controls);
