// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, { Component } from "react";
import ReactDOM from "react-dom";
import PropTypes from "prop-types";
import axios from "axios";
import { Editor } from "proto-editor";

class StoryEditor extends Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(cards) {
    axios
      .put(
        this.props.action_url,
        {
          page: {
            content: JSON.stringify(cards),
            prepare_cards_for_assembling: "true",
          },
        },
        {
          headers: {
            "Access-Token": this.props.user_token,
            Accept: "application/json",
          },
        }
      )
      .then(function(response) {
        window.location.href = response.data.redirect_url;
      })
      .catch(function(err) {
        console.log(err);
      });
  }

  render() {
    return (
      <Editor
        cards={this.props.cards}
        cards_request={{
          url: this.props.cards_url,
          token: this.props.user_token,
        }}
        onSubmit={this.handleSubmit}
      />
    );
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("story-editor");
  const cards = node.getAttribute("cards")
    ? JSON.parse(node.getAttribute("cards"))
    : null;
  const user_token = node.getAttribute("user_token");
  const action_url = node.getAttribute("action_url");
  const cards_url = node.getAttribute("cards_url");

  ReactDOM.render(
    <StoryEditor
      cards={cards}
      user_token={user_token}
      action_url={action_url}
      cards_url={cards_url}
    />,
    node
  );
});
