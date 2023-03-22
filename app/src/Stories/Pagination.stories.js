import { Elm } from "./Pagination.elm";
import elmSource from "./Pagination.elm?raw";
import { ElmComponent } from "elm-storybook";

export default {
  title: "Pagination",
  parameters: { elmSource },
  argTypes: {
    label: { control: { type: "text" } },
    onAction: { action: "Elm" },
  },
};

export const Pagination = (controls) =>
  ElmComponent.create(Elm.Stories.Pagination, controls);
