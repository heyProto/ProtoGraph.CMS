// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import { Editor } from 'proto-editor';

class StoryEditor extends Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(cards) {
    console.log(cards);
  }

  render() {
    return <Editor cards={this.props.cards} onSubmit={this.handleSubmit} />;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('story-editor');
  const cards = JSON.parse(node.getAttribute('data-cards'));

  ReactDOM.render(<StoryEditor cards={cards} />, node);
});
