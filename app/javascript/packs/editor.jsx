// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import axios from 'axios'
import { Editor } from 'proto-editor'

class StoryEditor extends Component {
  constructor (props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)

    this.dummyCards = [
      {
        type: 'heading',
        attrs: {
          level: 2,
          id: null,
          'data-card-id': 6165,
          'data-template-id': 25
        },
        content: [{ type: 'text', text: 'December 2017 Announcement' }]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'It is still the case that when we think or read about gender, we think about women. And violence. In part, this is as it should be. It was women who made gender visible. Violence against them has been stark, discrimination universal. It continues to live on, even as it is denied.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'The challenge is not just that, women and gender minorities across the world bear brutal violence. It is that they have a vision, voice, and an agency to comment, reflect on some of the greatest crisis of our times: be it food security, national security, environmental justice, diplomatic relations.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Women have been at the forefront in movements for Dalit rights, minority rights, protection of forests, the right to food. Theirs is a unique, diverse struggle against inequality.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'The reality of the urban working-class woman who is also a domestic, casual contract labourer battling multiple struggles: security of employment, space to live in a slum, sexual violence, wages, aspirations. She is often a rural woman, who has come to the city searching for work, to feed her family. In the village she worked outside her home. It was natural and necessary. The work was never recognised. The land she tilled tirelessly was never hers. The urban based woman goes through her own formidable challenges of negotiating hostile spaces. -'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Gender is the new conversation in these times. There is recognition, slow and grudging as it maybe, that gender must inform policy and planning.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Women now occupy almost every conceivable role in public life. They run businesses, lead countries, build roads, participate in movements, create art and climb trees. And, they are no monolith. They can, and do assimilate patriarchal values.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Any commentary on gender is incomplete without the full arc.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'At #GenderAnd we want to mainstream gender. This isn\u2019t about adding a \u201ccustomary woman\u201d to the reportage, thereby balancing some notional equation. Or the belief that this is typically, \u201cabout women\u201d. Another pitfall, we will guard against, that this is an additional \u201cangle\u201d, bestowed on a woman, in this case a woman journalist who has an interest in \u201cgender\u201d.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Over the next four weeks, and in 2018 indianexpress.com will explore gender and the many axes on which it intersects. We will examine the invisibility of women\u2019s work across sectors. We\u2019ll explore the multitude of ongoing struggles against caste, class, religion, even as when focus on gender inequalities. Whether the goal is to \u201cbreak glass ceilings\u201d or smash records or access to power and justice, we are interested in how women and gender minorities are achieving it. There will be reportage, commentary, multimedia reports, data projects, reflecting on stories from history and reporting on lives of women and gender minorities today. Our reporters, writers and photographers will critically and holistically report on Gender.'
          }
        ]
      },
      {
        type: 'heading',
        attrs: {
          level: 2,
          id: null,
          'data-card-id': 6166,
          'data-template-id': 25
        },
        content: [{ type: 'text', text: 'June 2017 Announcement' }]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'In 1950, when women got the right to vote in India, they did not get that right to vote only on \u2018women issues\u2019. They got the vote for a say in everything that concerns the country.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Since the nationwide agitation over the 2012 Delhi gangrape, the media has offered a better platform to talk, question and debate issues around gender in India. Yet, most of the coverage around gender is restricted to sexual violence and crime. While these issues are important, they are also limiting in some way when we talk about women and other sexual or gender minorities in India.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'Stories around gender need not be tucked away in one \u2018women\u2019s section\u2019, in a book, on a website, in a magazine or in a policy file. A right to food policy or a land acquisition bill is as relevant to women and gender minorities as it is for men. The need of the hour is to mainstream gender in politics, business, national affairs and everything under the sun.'
          }
        ]
      },
      {
        type: 'paragraph',
        attrs: {
          class: null,
          'data-card-id': null,
          'data-template-id': null
        },
        content: [
          {
            type: 'text',
            text:
              'All of June, indianexpress.com will put out special stories with a gender lens, each looking at these intersections critically to assess how gender sensitive/inclusive anything in India is. Help us find more such stories using #GenderAnd in your conversations. You can read our reportage, here .'
          }
        ]
      }
    ]
  }

  handleSubmit (cards) {
    console.log(cards)
    console.log(this.props.action_url)
    axios
      .put(
        this.props.action_url,
        { cards },
        {
          headers: { 'Access-Token': this.props.user_token, "Accept": "application/json" }
        }
      )
      .then(function (response) {
        console.log(response)
      })
      .catch(function (err) {
        console.log(err)
      })
  }

  render () {
    return (
      <Editor
        cards={this.dummyCards}
        cards_request={{
          url: this.props.cards_url,
          token: this.props.user_token
        }}
        onSubmit={this.handleSubmit}
      />
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('story-editor')
  // const cards = JSON.parse(node.getAttribute('cards'));
  const cards = null
  const user_token = node.getAttribute('user_token')
  const action_url = node.getAttribute('action_url')
  const cards_url = node.getAttribute('cards_url')

  ReactDOM.render(
    <StoryEditor
      cards={cards}
      user_token={user_token}
      action_url={action_url}
      cards_url={cards_url}
    />,
    node
  )
})
