import * as Turbo from "@hotwired/turbo-rails";
import "popper";
import * as Bootstrap from "bootstrap";
import "controllers";

document.addEventListener("turbo:render", () => {
  "use strict";
});

document.addEventListener("turbo:submit-start", ({target}) => {
  if (target.elements != undefined && target.elements != null) {
    for (const field of target.elements) {
      field.disabled = true;
    }
  }
});

document.addEventListener("turbo:submit-end", ({target}) => {
  if (target.elements != undefined && target.elements != null) {
    for (const field of target.elements) {
      field.disabled = false;
    }
  }
});

document.addEventListener("turbo:click", () => {
  // document.querySelectorAll("body, input, a, button").forEach((element) => {
  //   element.style.cursor = "progress";
  // });
});

document.addEventListener("turbo:load", () => {
  "use strict";
}, {once: true});
