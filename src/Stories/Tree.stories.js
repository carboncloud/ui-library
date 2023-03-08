import { Elm } from "./Tree.elm";
import elmSource from "./Tree.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Tree",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" }
  },
};

export const Tree = (controls) =>
  ElmComponent.create(Elm.Stories.Tree, controls);
