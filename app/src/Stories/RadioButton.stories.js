import { Elm } from "./RadioButton.elm";
import elmSource from "./RadioButton.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "RadioButton",
  parameters: { elmSource },
  argTypes: {
    label: { control: { type: "text" } },
    direction: { control: { type: "radio" }, options: ["Horizontal", "Vertical"]},
    onAction: { action: "Elm" },
  },
};

export const RadioButton = (controls) =>
  ElmComponent.create(Elm.Stories.RadioButton, controls);
