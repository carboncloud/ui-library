import { Elm } from "./MillerColumns.elm";
import elmSource from "./MillerColumns.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "MillerColumns",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" }
  },
};

export const MillerColumns = (controls) =>
  ElmComponent.create(Elm.Stories.MillerColumns, controls);
