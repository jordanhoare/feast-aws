import React from "react";
import ReactDOM from "react-dom";
import "./index.css";

import FeastUI from "@feast-dev/feast-ui";
import "@feast-dev/feast-ui/dist/feast-ui.css";

ReactDOM.render(
  <React.StrictMode>
    <FeastUI
      feastUIConfigs={{
        projectListPromise: fetch(SOME_PATH, {
          headers: {
            "Content-Type": "application/json",
          },
        }).then((res) => {
          return res.json();
        })
      }}
    />
  </React.StrictMode>,
  document.getElementById("root")
);
