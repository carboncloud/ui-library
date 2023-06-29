import { Elm } from "./Menu.elm";
import elmSource from "./Menu.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Menu",
  parameters: { elmSource },
  argTypes: {
    onAction: { action: "Elm" }
  },
};

export const Menu = (controls) =>
  ElmComponent.create(Elm.Stories.Menu, controls);
