import { Elm } from "./Button.elm";
import elmSource from "./../../../src/Ui/Button.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Button",
  parameters: { elmSource },
  argTypes: {
    label: { control: { type: "text" } },
    type: { control: { type: "radio" }, options: ["Raised", "Ghost", "Flat"] },
    color: { control: { type: "radio" }, options: ["Primary", "Secondary", "Warn", "Neutral"] },
    onAction: { action: "Elm" },
  },
};

export const Button = (controls) =>
  ElmComponent.create(Elm.Stories.Button, controls);
