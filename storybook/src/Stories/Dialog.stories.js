import { Elm } from "./Dialog.elm";
import elmSource from "./Dialog.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Dialog",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" }
  },
};

export const Dialog = (controls) =>
  ElmComponent.create(Elm.Stories.Dialog, controls);
