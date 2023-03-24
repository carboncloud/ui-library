import { Elm } from "./Text.elm";
import elmSource from "./Text.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Text",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" }
  },
};

export const Text = (controls) =>
  ElmComponent.create(Elm.Stories.Text, controls);
